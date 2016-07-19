///
//  ViewController.m
//  ProcessImageApp
//
//  Created by Arcilite on 05.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "ImageProcessingViewController.h"
#import "DownloadImageViewController.h"
#import "Engine.h"
#import "ImageOperation.h"
#import "ImagesFileManager.h"
#import "ProcessImageTableViewCell.h"
#import "UIImage+Effects.h"
#import "ImageExiffDataObject.h"
const NSInteger kAddImageActionSheet = 1;
const NSInteger kImageOperationActionSheet = 2;


@interface ImageProcessingViewController ()

@property (nonatomic, strong)  NSArray *imagesArray;
@property (nonatomic, assign) NSInteger selectedImageIndex;

@property (nonatomic, strong) ImageOperationManager *operationManager;

@end


@implementation ImageProcessingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateProcessedList];
}

- (void)updateProcessedList
{
    self.imagesArray  = [Engine sharedManager].operationsManager.imageOperationsArrray;
    
    [self.tableView reloadData];
}

#pragma mark - TableView delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    ProcessImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                      forIndexPath:indexPath];
    
    ImageOperation *imageOperation = [self.imagesArray objectAtIndex:indexPath.row];
    
    cell.processedImageView.image = nil;
    cell.progressView.hidden = imageOperation.isProcessed;
    cell.progressView.progress = imageOperation.progress;
    cell.processedImageView.image = imageOperation.image;
    [imageOperation processedImage: ^(UIImage *image) {
        cell.processedImageView.image = image;
        [self.tableView reloadData];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Yes  i understend thats is not  is best solution
    self.selectedImageIndex = indexPath.row;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Operation", @"")
                                                    message:NSLocalizedString(@"What are you want to do with result", @"")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                          otherButtonTitles:NSLocalizedString(@"Delete", @""),
                                                            NSLocalizedString(@"Save To Library", @""),
                                                            NSLocalizedString(@"Process Again", @""), nil];
    [alert show];
}

#pragma mark - Actions

- (IBAction)addImageAction:(id)sender
{
        // I don't like action sheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Add Image From", @"")
                                                             delegate:self
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
    UIImage * image = self.imageView.image;
    
    __weak typeof(self) weakSelf = self;
    
    [[Engine sharedManager].operationsManager addImageOperationForImage:image operation:^id{
        return [image rotateImageForDegree:90];
    } start:^{
        [weakSelf updateProcessedList];
    } complete:^(UIImage*image){
        [weakSelf updateProcessedList];
         self.imageView.image = image;
    }
    progress:^(ImageOperation * imageOperation){
        //[weakSelf updateProcessedList];
        NSUInteger row =[weakSelf.imagesArray indexOfObject:imageOperation];
        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:row inSection:0];
        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [weakSelf.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (IBAction)mirorImageAction:(id)sender
{
    UIImage * image = self.imageView.image;
    
    __weak typeof(self) weakSelf = self;
    
    [[Engine sharedManager].operationsManager addImageOperationForImage:image operation:^id{
        return [image horizontalMirror];
    } start:^{
        [weakSelf updateProcessedList];
    } complete:^(UIImage*image){
        [weakSelf updateProcessedList];
         self.imageView.image = image;
    }
    
    progress:^(ImageOperation * imageOperation){
        NSUInteger row =[weakSelf.imagesArray indexOfObject:imageOperation];
        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:row inSection:0];
        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [weakSelf.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}

- (IBAction)invertColorsImageAction:(id)sender
{
    UIImage * image = self.imageView.image;
    
    __weak typeof(self) weakSelf = self;
    
    [[Engine sharedManager].operationsManager addImageOperationForImage:image operation:^id{
        return [image invertedImage];
    } start:^{
        [weakSelf updateProcessedList];
    } complete:^(UIImage*image){
        [self updateProcessedList];
        weakSelf.imageView.image = image;
    }
     
    progress:^(ImageOperation * imageOperation){
        NSUInteger row =[weakSelf.imagesArray indexOfObject:imageOperation];
        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:row inSection:0];
        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [weakSelf.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (IBAction)exifAction:(id)sender {
   ImageExiffDataObject * object = [[ImageExiffDataObject alloc]init];
   [object extractExifDataInObjectFromImage:self.imageView.image];
  NSString * string = [NSString stringWithFormat:@"camera %@ \n  focalLength %@ \n   rawShutterSpeed %@ \n aperture %@ \n  exifISOSpeed %@ \n taken %@ ",object.cameraString,object.focalLength,object.rawShutterSpeed,object.aperture,object.exifISOSpeed,object.taken];
                      
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"EXIF", @"")
                                                  message:string
                                                 delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                        otherButtonTitles: nil];
  [alert show];
}

- (IBAction)blurAction:(id)sender {
  UIImage * image = self.imageView.image;
  
  __weak typeof(self) weakSelf = self;
  
  [[Engine sharedManager].operationsManager addImageOperationForImage:image operation:^id{
    return [image applyBlurWithRadius:5 tintColor:[UIColor colorWithRed:0.1 green:0 blue:1.0 alpha:0.4] saturationDeltaFactor:0.1 maskImage:image];
  } start:^{
    [weakSelf updateProcessedList];
  } complete:^(UIImage*image){
    [weakSelf updateProcessedList];
    self.imageView.image = image;
  }
          progress:^(ImageOperation * imageOperation){
            
            NSUInteger row =[weakSelf.imagesArray indexOfObject:imageOperation];
            NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:row inSection:0];
            NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
            [weakSelf.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    }];

  
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
            break;
            
        case 1:{
            
           [self performSegueWithIdentifier:@"modalDownload" sender:nil];
        }
            break;
            
        case 2:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
            }
            
            break;
            
        default:
            break;
    }
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle   = UIModalPresentationCurrentContext;
    imagePickerController.sourceType               = sourceType;
    imagePickerController.delegate                 = self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - picker view delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.imageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Alert view delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ImageOperation *imageOperation = [self.imagesArray objectAtIndex:_selectedImageIndex];
    __weak typeof(self) weakSelf = self;
    switch (buttonIndex) {
        case 1: {
            [[Engine sharedManager].operationsManager deleteImageProcessedOperation:imageOperation complete: ^{
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
                [weakSelf procesAgainImage:image];
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
         }];
    }];
}

- (void)procesAgainImage:(UIImage *)image
{
    self.imageView.image = image;
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"modalDownload"]) {
        
        DownloadImageViewController *dowbloadViewController = (DownloadImageViewController *) segue.destinationViewController;
      self.definesPresentationContext = YES; //self is presenting view controller
     // presentedController.view.backgroundColor = [UIColor clearColor];      presentedController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [dowbloadViewController setDelegate:self];
    }
    
}



#pragma mark - DownloadImageProcessingDelegate

-(void)successChoosedImage:(UIImage*)image{
    
    self.imageView.image = image;
    
}

@end
