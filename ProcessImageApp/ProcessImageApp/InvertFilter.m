//
//  InvertFilter.m
//  ProcessImageApp
//
//  Created by Arcilite on 28.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import "InvertFilter.h"

@implementation InvertFilter


-(UIImage*)operationImage{
  return [self invertedImage];
}



- (UIImage *)invertedImage
{
  CGRect rect = (CGRect) {.size = self.image.size };
  
  UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.image.scale);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSetBlendMode(ctx, kCGBlendModeCopy);
  [self.image drawInRect:rect];
  CGContextSetBlendMode(ctx, kCGBlendModeDifference);
  
  CGContextTranslateCTM(ctx, 0, rect.size.height);
  CGContextScaleCTM(ctx, 1.0, -1.0);
  
  CGContextClipToMask(ctx, rect, self.image.CGImage);
  CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
  CGContextFillRect(ctx, rect);
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}



@end
