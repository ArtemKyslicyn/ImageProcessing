//
//  ImagePickerProvider.h
//  ProcessImageApp
//
//  Created by Arcilite on 27.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "DownloadImageViewController.h"
@interface ImagePickerProvider : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
-(id)initWithViewController:(UIViewController <DownloadImageViewControllerDelegate>*)viewController;
@end
