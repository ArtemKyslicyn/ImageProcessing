//
//  ImagePickerProvider.m
//  ProcessImageApp
//
//  Created by Arcilite on 27.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import "ImagePickerProvider.h"
#import "DownloadImageViewController.h"
@interface ImagePickerProvider ()

@property UIViewController <DownloadImageViewControllerDelegate>* viewController;

@end

@implementation ImagePickerProvider


-(id)initWithViewController:(UIViewController <DownloadImageViewControllerDelegate>*)viewController{
  self = [super init];
  if (self){
    self.viewController = viewController;
  }
  
  return self;
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  switch (buttonIndex) {
    case 0:
      
      [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
      
      break;
      
    case 1:{
      
      [self.viewController performSegueWithIdentifier:@"modalDownload" sender:nil];
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
  
  [self.viewController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - picker view delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
  [self.viewController successChoosedImage:image];
  
  [self.viewController dismissViewControllerAnimated:YES completion:NULL];
}



@end
