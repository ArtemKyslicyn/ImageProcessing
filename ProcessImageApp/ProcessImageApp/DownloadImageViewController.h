//
//  DownloadImageViewController.h
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//


@protocol DownloadImageViewControllerDelegate <NSObject>

-(void)successChoosedImage:(UIImage*)image;

@end


@interface DownloadImageViewController : UIViewController
- (IBAction)okAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *iamgeView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (nonatomic, weak) id <DownloadImageViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong) Engine * engine;

@end
