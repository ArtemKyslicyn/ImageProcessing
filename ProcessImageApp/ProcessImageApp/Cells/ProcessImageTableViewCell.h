//
//  ProcessImageTableViewCell.h
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *processedImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
