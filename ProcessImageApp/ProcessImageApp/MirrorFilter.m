//
//  MirrorFilter.m
//  ProcessImageApp
//
//  Created by Arcilite on 28.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import "MirrorFilter.h"

@implementation MirrorFilter


-(UIImage*)operationImage{
  return [self horizontalMirror];
}


- (UIImage *)horizontalMirror{
  UIImage *flippedImage = [UIImage imageWithCGImage:self.image.CGImage scale:1.0 orientation:UIImageOrientationDownMirrored];
  
  CGImageRef inImage = self.image.CGImage;
  CGContextRef ctx = CGBitmapContextCreate(NULL,
                                           CGImageGetWidth(inImage),
                                           CGImageGetHeight(inImage),
                                           CGImageGetBitsPerComponent(inImage),
                                           CGImageGetBytesPerRow(inImage),
                                           CGImageGetColorSpace(inImage),
                                           CGImageGetBitmapInfo(inImage)
                                           );
  CGRect cropRect = CGRectMake(flippedImage.size.width / 2, 0, flippedImage.size.width / 2, flippedImage.size.height);
  CGImageRef TheOtherHalf = CGImageCreateWithImageInRect(flippedImage.CGImage, cropRect);
  CGContextDrawImage(ctx, CGRectMake(0, 0, CGImageGetWidth(inImage), CGImageGetHeight(inImage)), inImage);
  
  CGAffineTransform transform = CGAffineTransformMakeTranslation(flippedImage.size.width, 0.0);
  transform = CGAffineTransformScale(transform, -1.0, 1.0);
  CGContextConcatCTM(ctx, transform);
  
  CGContextDrawImage(ctx, cropRect, TheOtherHalf);
  
  CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
  CGContextRelease(ctx);
  UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
  CGImageRelease(imageRef);
  
  return finalImage;
}

@end
