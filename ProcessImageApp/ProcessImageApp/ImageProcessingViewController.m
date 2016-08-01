///
//  ViewController.m
//  ProcessImageApp
//
//  Created by Arcilite on 05.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "ImageProcessingViewController.h"
#import "DownloadImageViewController.h"
#import "ImageOperationManager.h"
#import "ImageOperation.h"
#import "ImagesFileManager.h"
#import "ProcessImageTableViewCell.h"
#import "UIImage+Effects.h"
#import "ImageExiffDataObject.h"
#import "ImageProcessingTableDataSource.h"
#import "FillterProcessor.h"
#import "BlurFilter.h"
#import "RotateFilter.h"
#import "InvertFilter.h"
#import "NegatieFilter.h"
#import "MirrorFilter.h"
#import "ImagePickerProvider.h"
#import "UIViewController+Messages.h"
const NSInteger kAddImageActionSheet = 1;
const NSInteger kImageOperationActionSheet = 2;


@interface ImageProcessingViewController ()

@property (nonatomic, strong)  NSArray *imagesArray;
@property (nonatomic, assign) NSInteger selectedImageIndex;

@property (nonatomic, strong) ImageOperationManager *operationManager;
@property (nonatomic, strong) ImageProcessingTableDataSource * tableDatasource;
@property (nonatomic, strong) FillterProcessor * filterProcessor;
@property (nonatomic, strong) ImagePickerProvider * pickerProvider;

@end


@implementation ImageProcessingViewController

- (id)initWithCoder:(NSCoder *)decoder{
  self = [super initWithCoder:decoder];
  if (self ){
    [self initTableViewDataSource];
    [self initFilterProcessor];
    [self initPickerProvider];
  }
  return  self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
  self.tableView.delegate =  self.tableDatasource;
  self.tableView.dataSource = self.tableDatasource;
  
}

-(void) initFilterProcessor{
  self.filterProcessor  = [[FillterProcessor alloc] init];
  
  __weak typeof(self) weakSelf = self;
  
  self.filterProcessor.progressBlock = ^(ImageOperation * imageOperation){
    NSUInteger row =[weakSelf.imagesArray indexOfObject:imageOperation];
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:row inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [weakSelf.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
  };
  
  self.filterProcessor.start = ^{
    [weakSelf updateProcessedList];
  };
  
}

-(void)initTableViewDataSource{
  
  self.tableDatasource = [[ImageProcessingTableDataSource alloc] init];

  
   __weak typeof(self) weakSelf = self;
  
   self.tableDatasource.selectedRow = ^(NSInteger index){
    weakSelf.selectedImageIndex = index;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Operation", @"")
                                                    message:NSLocalizedString(@"What are you want to do with result", @"")
                                                   delegate:weakSelf
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                          otherButtonTitles:NSLocalizedString(@"Delete", @""),
                          NSLocalizedString(@"Save To Library", @""),
                          NSLocalizedString(@"Process Again", @""), nil];
    [alert show];
    
  };
  
  self.tableDatasource.reloadBlock = ^{
    [weakSelf updateProcessedList];
  };
}

-(void)initPickerProvider{
  self.pickerProvider =  [[ImagePickerProvider alloc] initWithViewController:self];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateProcessedList];
}

- (void)updateProcessedList
{
    self.imagesArray  = self.filterProcessor.operationManager.imageOperationsArrray;
    self.tableDatasource.imagesArray = self.filterProcessor.operationManager.imageOperationsArrray;
    [self.tableView reloadData];
}

#pragma mark - Actions

- (IBAction)addImageAction:(id)sender
{
        // I don't like action sheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Add Image From", @"")
                                                             delegate:self.pickerProvider
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Library", @""),
                                                                      NSLocalizedString(@"Download Image", @""), nil];
    
    actionSheet.tag = kAddImageActionSheet;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Camera", @"Camera")];
        [actionSheet setCancelButtonIndex:3];
    }
    else {
        [actionSheet setCancelButtonIndex:2];
    }
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
    [actionSheet showInView:self.view];
}

- (IBAction)rotateImageAction:(id)sender {
  if  (!self.imageView.image) {
    [self errorMessageWithTitle:NSLocalizedString(@"Error","") message: NSLocalizedString(@"Please choose image",@"")];
  }else{
  RotateFilter * filter = [[RotateFilter alloc] initWithImage:self.imageView.image rotate: 90 ];
    [self proccesedFilter:filter];
  }
}

- (IBAction)mirorImageAction:(id)sender{
  if  (!self.imageView.image) {
    [self errorMessageWithTitle:NSLocalizedString(@"Error","") message: NSLocalizedString(@"Please choose image",@"")];
  }else{
    
    MirrorFilter * filter = [[MirrorFilter alloc] initWithImage:self.imageView.image ];
    [self proccesedFilter:filter];
    
  }
}

- (IBAction)invertColorsImageAction:(id)sender{
  if  (!self.imageView.image) {
    [self errorMessageWithTitle:NSLocalizedString(@"Error","") message: NSLocalizedString(@"Please choose image",@"")];
  }else{
  InvertFilter * filter = [[InvertFilter alloc] initWithImage:self.imageView.image  ];
  [self proccesedFilter:filter];
  }
}


- (IBAction)blurAction:(id)sender {
  if  (!self.imageView.image) {
    [self errorMessageWithTitle:NSLocalizedString(@"Error","") message: NSLocalizedString(@"Please choose image",@"")];
  }else{
  BlurFilter * filter = [[BlurFilter alloc] initWithImage:self.imageView.image blurRadius:0.1 tintColor:[UIColor colorWithRed:0.1 green:0 blue:1.0 alpha:0.4] saturationDeltaFactor:0];
  [self proccesedFilter:filter];
  }
}

-(void)proccesedFilter:(BaseFilter*)filter{
   __weak typeof(self) weakSelf = self;
  if  (!self.imageView.image) {
    [self errorMessageWithTitle:NSLocalizedString(@"Error","") message: NSLocalizedString(@"Please choose image",@"")];
  }else{
  [self.filterProcessor startFilter:filter complete:^(UIImage * image) {
    [weakSelf updateProcessedList];
    weakSelf.imageView.image = image;
  } ];
  }

}

- (IBAction)exifAction:(id)sender {
  if  (!self.imageView.image) {
    [self errorMessageWithTitle:NSLocalizedString(@"Error","") message: NSLocalizedString(@"Please choose image",@"")];
  }else{
  ImageExiffDataObject * object = [[ImageExiffDataObject alloc]init];
  [object extractExifDataInObjectFromImage:self.imageView.image];
  NSString * string = [NSString stringWithFormat:@" width %@ \n  height %@ \n depth %@ ",object.pixelWidth,object.pixelHeight,object.depth];
  

  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"EXIF", @"")
                                                  message:string
                                                 delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                        otherButtonTitles: nil];
  [alert show];
  }
}




#pragma mark - Alert view delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   ImageOperation *imageOperation = [self.imagesArray objectAtIndex:_selectedImageIndex];
    __weak typeof(self) weakSelf = self;
    switch (buttonIndex) {
        case 1: {
         
            [self.filterProcessor.operationManager deleteImageProcessedOperation:imageOperation complete: ^{
                [weakSelf updateProcessedList];
            } fail: ^{
            }];
        }
            break;
            
        case 2: {
  
            [imageOperation processedImage: ^(UIImage *image) {
                [weakSelf saveToLibarayImage:image];
            }];
        }
            
            break;
            
        case 3: {
        
            [imageOperation processedImage: ^(UIImage *image) {
                [weakSelf successChoosedImage:image];
            }];
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - Operations

- (void)saveToLibarayImage:(UIImage *)image
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library writeImageToSavedPhotosAlbum:image.CGImage
                              orientation:(ALAssetOrientation)image.imageOrientation
                          completionBlock: ^(NSURL *assetURL, NSError *error) {
                              
        NSLog(@"IMAGE SAVED TO PHOTO ALBUM");
        [library assetForURL:assetURL resultBlock: ^(ALAsset *asset) {
            NSLog(@"we have our ALAsset!");
        }
                failureBlock: ^(NSError *error) {
         NSLog(@"Error loading asset");
                  [self errorMessageWithTitle:@"Error" message: [error localizedDescription]];
                  
         }];
    }];
}



#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"modalDownload"]) {
        
        DownloadImageViewController *dowbloadViewController = (DownloadImageViewController *) segue.destinationViewController;
      self.definesPresentationContext = YES; //self is presenting view controller
        [dowbloadViewController setDelegate:self];
    }
    
}




#pragma mark - DownloadImageProcessingDelegate

-(void)successChoosedImage:(UIImage*)image{
    
    self.imageView.image = image;
    
}

@end
