//
//  ViewController.m
//  ProcessImageApp
//
//  Created by Arcilite on 05.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "ImageProcessingViewController.h"
#import "UIImage+Effects.h"
#import "DownloadImageViewController.h"
#import "ImagesFileManager.h"
#import "ProcessImageTableViewCell.h"

const int kAddImageActionSheet = 1;
const int kImageOperationActionSheet = 2;


@interface ImageProcessingViewController ()

@property (nonatomic,strong) NSMutableArray * imagesArray;
@property (nonatomic,assign) NSInteger  selectedImageIndex;
@property (nonatomic, weak) DownloadImageViewController *containerViewController;
@end

@implementation ImageProcessingViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadProcessedList];

}


-(void)loadProcessedList{
    
    self.imagesArray  = [ImagesFileManager loadProcessedImagesFilePathsFromDocuments];
    [self.tableView reloadData];
    
}



#pragma mark TableView delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.imagesArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
   ProcessImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[ProcessImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier] ;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
   
    
    NSString * pathImage = [self.imagesArray objectAtIndex:indexPath.row];
    NSString * fullPath = [documentsDirectory stringByAppendingPathComponent:pathImage];
    
    cell.processedImageView.image = [UIImage imageWithContentsOfFile:fullPath];
//    // Here we use the provided setImageWithURL: method to load the web image
//    // Ensure you use a placeholder image otherwise cells will be initialized with no image
//    [cell.imageView setImageWithURL:[NSURL URLWithString:@"http://example.com/image.jpg"]
//                   placeholderImage:[UIImage imageNamed:@"placeholder"]];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Yes  i understend thats is not  is best solution 
    self.selectedImageIndex = indexPath.row;
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"Operation",@"")
                          message:NSLocalizedString(@"What are you want to do with result",@"")
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"Cancel",@"")
                          otherButtonTitles:NSLocalizedString(@"Delete",@""),NSLocalizedString( @"Save To Library",@""), NSLocalizedString(@"Process Again",@""), nil];
    [alert show];
}


#pragma mark Actions

- (IBAction)addImageAction:(id)sender {
   
   // I don't like action sheet
    UIActionSheet *  actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Add Image From", @"")
                                              delegate:self
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"Library", @""), NSLocalizedString(@"Download Image", @""), nil];
    
    
    
    
     actionSheet.tag = kAddImageActionSheet;
  
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [actionSheet addButtonWithTitle: NSLocalizedString(@"Camera", @"Camera")];
        [actionSheet setCancelButtonIndex:3];
    }else{
        [actionSheet setCancelButtonIndex:2];
    }
    
    [actionSheet addButtonWithTitle: NSLocalizedString(@"Cancel", @"Cancel")];
    
    
    [actionSheet showInView:self.view];

}




- (IBAction)rotateImageAction:(id)sender {
    self.imageView.image = [self.imageView.image rotateImageForDegree:90];
    [ImagesFileManager saveProcessedImage: self.imageView.image];
}

- (IBAction)mirorImageAction:(id)sender {
    __block UIImage * image;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        image = [self.imageView.image horizontalMirror];
        [ImagesFileManager saveProcessedImage:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            /* Код, который выполниться в главном потоке */
            self.imageView.image = image;
        });
    });
}

- (IBAction)invertColorsImageAction:(id)sender {
    
    __block UIImage * image;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
       image = [self.imageView.image invertedImage];
        [ImagesFileManager saveProcessedImage:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            /* Код, который выполниться в главном потоке */
            self.imageView.image = image;
            
        });
    });
    
}


#pragma mark Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            
            [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
            break;
        
        case 1:
            
            [self performSegueWithIdentifier:@"embedContainer" sender:nil];
            
            break;
        
        case 2:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
            }
            
            break;
            
        default:
            break;
    }
   
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark picker view delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    self.imageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark Alert view delegates

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
//    if ([segue.identifier isEqualToString:@"embedContainer"]) {
//        self.containerViewController = segue.destinationViewController;
//    }
}


@end
