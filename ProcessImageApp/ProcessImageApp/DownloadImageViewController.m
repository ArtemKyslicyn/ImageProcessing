//
//  DownloadImageViewController.m
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "DownloadImageViewController.h"

@interface DownloadImageViewController ()
@property (nonatomic, strong)  ImageDownloader *downloadManager;
@end
@implementation DownloadImageViewController

-(void)awakeFromNib{
   [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
}
-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [UIView animateWithDuration:0.4 animations:^() {self.view.alpha = 1;}
                   completion:^(BOOL finished){}];
}
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.downloadManager  =  [ImageDownloader new];
  self.view.alpha = 0;
  self.modalPresentationStyle = UIModalPresentationOverFullScreen;
  self.providesPresentationContextTransitionStyle = YES;
  self.definesPresentationContext = YES;
  self.view.backgroundColor = [UIColor clearColor];
  self.progressView.progress = 0;
  
}
- (IBAction)okAction:(id)sender {
 
    [self dismissViewControllerAnimated:YES completion:Nil];
    [self.delegate successChoosedImage:self.iamgeView.image];

}
- (IBAction)loadImageAction:(id)sender {
  [self loadImage];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

-(void)loadImage{
  if (self.urlTextField.text.length>0) {
    __weak typeof(self) weakSelf = self;
    [self.downloadManager addImageOperationForUrlString:self.urlTextField.text fail:^(NSError *error) {
      
    } complete:^(UIImage *image) {
      
      weakSelf.iamgeView.image = image;
      
    } progress:^(float progress) {
      weakSelf.progressView.progress = progress;
      NSLog(@"progress loading  image %f ",progress);
    }];
  }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  [self loadImage];
  [textField resignFirstResponder];
    return YES;
}

@end
