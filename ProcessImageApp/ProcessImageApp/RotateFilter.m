//
//  RotateFiltet.m
//  ProcessImageApp
//
//  Created by Arcilite on 28.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import "RotateFilter.h"

@implementation RotateFilter

- (id)initWithImage:(UIImage*)image rotate:(float)degrees{
  self = [super init];
  if (self) {
    self.image = image;
    self.degrees = degrees;
  }
  return self;
}


-(UIImage*)operationImage{
  return [self rotateImageForDegree:self.degrees];
}


CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};

- (UIImage *)rotateImageForDegree:(float)degrees
{
  float newSide = MAX(self.image.size.width, self.image.size.height);
  CGSize size =  CGSizeMake(newSide, newSide);
  UIGraphicsBeginImageContext(size);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(ctx, newSide / 2, newSide / 2);
  CGContextRotateCTM(ctx, DegreesToRadians(degrees));
  CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(-self.image.size.width / 2, -self.image.size.height / 2, size.width, size.height), self.image.CGImage);
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}


@end
