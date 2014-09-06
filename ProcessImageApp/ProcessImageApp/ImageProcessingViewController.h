//
//  ViewController.h
//  ProcessImageApp
//
//  Created by Arcilite on 05.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageProcessingViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction) addImageAction:(id)sender;
- (IBAction) rotateImageAction:(id)sender;
- (IBAction) mirorImageAction:(id)sender;
- (IBAction) invertColorsImageAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
