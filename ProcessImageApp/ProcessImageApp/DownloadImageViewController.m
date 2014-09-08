//
//  DownloadImageViewController.m
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "DownloadImageViewController.h"

@implementation DownloadImageViewController

- (IBAction)okAction:(id)sender {
 
    [self dismissViewControllerAnimated:YES completion:Nil];

}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length>0) {
        [[Engine sharedManager].downloadManager addImageOperationForUrlString:textField.text fail:^(NSError *error) {
            
        } complete:^(UIImage *image) {
            
            self.iamgeView.image = image;
            
        } progress:^(float progress) {
            self.progressView.progress = progress;
        }];
    }
    [textField resignFirstResponder];
    return YES;
}

@end
