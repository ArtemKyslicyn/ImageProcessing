//
//  BlurFilter.h
//  ProcessImageApp
//
//  Created by Arcilite on 28.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import "BaseFilter.h"

@interface BlurFilter : BaseFilter

- (id)initWithImage:(UIImage*)image blurRadius:(CGFloat)radius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor;

@property (nonatomic,assign)  UIColor*  tintColor;
@property (nonatomic,assign)  CGFloat saturationDeltaFactor;
@property (nonatomic,assign)  CGFloat blurRadius;
@end
