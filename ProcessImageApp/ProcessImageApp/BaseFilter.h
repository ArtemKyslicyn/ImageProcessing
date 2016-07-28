//
//  BaseFilter.h
//  ProcessImageApp
//
//  Created by Arcilite on 27.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <Accelerate/Accelerate.h>

@interface BaseFilter : NSObject
@property(nonatomic,strong) UIImage * image;
-(UIImage*)operationImage;
- (id)initWithImage:(UIImage*)image;
@end
