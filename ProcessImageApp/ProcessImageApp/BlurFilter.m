//
//  BlurFilter.m
//  ProcessImageApp
//
//  Created by Arcilite on 28.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import "BlurFilter.h"

@implementation BlurFilter

- (id)initWithImage:(UIImage*)image{
  self = [super init];
  if (self) {
    self.image = image;
  }
  return self;
}

- (id)initWithImage:(UIImage*)image blurRadius:(CGFloat)radius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor{
  self = [super init];
  if (self) {
    self.image = image;
    self.blurRadius = radius;
    self.tintColor = tintColor;
    self.saturationDeltaFactor = saturationDeltaFactor;
    
    
   
  }
  return self;
}


-(UIImage*)operationImage{
  return [self applyBlurWithRadius: self.blurRadius tintColor: self.tintColor saturationDeltaFactor:self.saturationDeltaFactor maskImage:self.image];
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
  // Check pre-conditions.
  if (self.image.size.width < 1 || self.image.size.height < 1) {
    NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.image.size.width, self.image.size.height, self);
    return nil;
  }
  if (!self.image.CGImage) {
    NSLog (@"*** error: image must be backed by a CGImage: %@", self);
    return nil;
  }
  if (maskImage && !maskImage.CGImage) {
    NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
    return nil;
  }
  
  CGRect imageRect = { CGPointZero, self.image.size };
  UIImage *effectImage = self.image;
  
  BOOL hasBlur = blurRadius > __FLT_EPSILON__;
  BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
  if (hasBlur || hasSaturationChange) {
    UIGraphicsBeginImageContextWithOptions(self.image.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef effectInContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(effectInContext, 1.0, -1.0);
    CGContextTranslateCTM(effectInContext, 0, -self.image.size.height);
    CGContextDrawImage(effectInContext, imageRect, self.image.CGImage);
    
    vImage_Buffer effectInBuffer;
    effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
    effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
    effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
    effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
    
    UIGraphicsBeginImageContextWithOptions(self.image.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
    vImage_Buffer effectOutBuffer;
    effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
    effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
    effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
    effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
    
    if (hasBlur) {
      
      CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
      int radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
      if (radius % 2 != 1) {
        radius += 1; // force radius to be odd so that the three box-blur methodology works.
      }
      vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
      vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
      vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
    }
    BOOL effectImageBuffersAreSwapped = NO;
    if (hasSaturationChange) {
      CGFloat s = saturationDeltaFactor;
      CGFloat floatingPointSaturationMatrix[] = {
        0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
        0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
        0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
        0,                    0,                    0,  1,
      };
      const int32_t divisor = 256;
      NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
      int16_t saturationMatrix[matrixSize];
      for (NSUInteger i = 0; i < matrixSize; ++i) {
        saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
      }
      if (hasBlur) {
        vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
        effectImageBuffersAreSwapped = YES;
      }
      else {
        vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
      }
    }
    if (!effectImageBuffersAreSwapped)
      effectImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (effectImageBuffersAreSwapped)
      effectImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  }
  
  // Set up output context.
  UIGraphicsBeginImageContextWithOptions(self.image.size, NO, [[UIScreen mainScreen] scale]);
  CGContextRef outputContext = UIGraphicsGetCurrentContext();
  CGContextScaleCTM(outputContext, 1.0, -1.0);
  CGContextTranslateCTM(outputContext, 0, -self.image.size.height);
  
  // Draw base image.
  CGContextDrawImage(outputContext, imageRect, self.image.CGImage);
  
  // Draw effect image.
  if (hasBlur) {
    CGContextSaveGState(outputContext);
    if (maskImage) {
      CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
    }
    CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
    CGContextRestoreGState(outputContext);
  }
  
  // Add in color tint.
  if (tintColor) {
    CGContextSaveGState(outputContext);
    CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
    CGContextFillRect(outputContext, imageRect);
    CGContextRestoreGState(outputContext);
  }
  
  // Output image is ready.
  UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return outputImage;
}

@end
