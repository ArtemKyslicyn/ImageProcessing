//
//  UIImage+Effects.m
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};

#import "UIImage+Effects.h"
#import <float.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <Accelerate/Accelerate.h>
@implementation UIImage (Effects)

- (UIImage *)rotateImageForDegree:(float)degrees
{
    float newSide = MAX(self.size.width, self.size.height);
    CGSize size =  CGSizeMake(newSide, newSide);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, newSide / 2, newSide / 2);
    CGContextRotateCTM(ctx, DegreesToRadians(degrees));
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(-self.size.width / 2, -self.size.height / 2, size.width, size.height), self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)invertedImage
{
    CGRect rect = (CGRect) {.size = self.size };
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(ctx, kCGBlendModeCopy);
    [self drawInRect:rect];
    CGContextSetBlendMode(ctx, kCGBlendModeDifference);
    
    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CGContextClipToMask(ctx, rect, self.CGImage);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillRect(ctx, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)negativeImage
{
    // get width and height as integers, since we'll be using them as
    // array subscripts, etc, and this'll save a whole lot of casting
    CGSize size = self.size;
    int width = size.width;
    int height = size.height;
    
    // Create a suitable RGB+alpha bitmap context in BGRA colour space
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *memoryPool = (unsigned char *)calloc(width * height * 4, 1);
    CGContextRef context = CGBitmapContextCreate(memoryPool, width, height, 8, width * 4, colourSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    
    // draw the current image to the newly created context
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    // run through every pixel, a scan line at a time...
    for(int y = 0; y < height; y++)
    {
        // get a pointer to the start of this scan line
        unsigned char *linePointer = &memoryPool[y * width * 4];
        
        // step through the pixels one by one...
        for(int x = 0; x < width; x++)
        {
            // get RGB values. We're dealing with premultiplied alpha
            // here, so we need to divide by the alpha channel (if it
            // isn't zero, of course) to get uninflected RGB. We
            // multiply by 255 to keep precision while still using
            // integers
            int r, g, b;
            if(linePointer[3])
            {
                r = linePointer[0] * 255 / linePointer[3];
                g = linePointer[1] * 255 / linePointer[3];
                b = linePointer[2] * 255 / linePointer[3];
            }
            else
                r = g = b = 0;
            
            // perform the colour inversion
            r = 255 - r;
            g = 255 - g;
            b = 255 - b;
            
            // multiply by alpha again, divide by 255 to undo the
            // scaling before, store the new values and advance
            // the pointer we're reading pixel data from
            linePointer[0] = r * linePointer[3] / 255;
            linePointer[1] = g * linePointer[3] / 255;
            linePointer[2] = b * linePointer[3] / 255;
            linePointer += 4;
        }
    }
    
    // get a CG image from the context, wrap that into a
    // UIImage
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    
    // clean up
    CGImageRelease(cgImage);
    CGContextRelease(context);
    free(memoryPool);
    
    // and return
    return returnImage;
}

- (UIImage *)horizontalMirror
{
    UIImage *flippedImage = [UIImage imageWithCGImage:self.CGImage scale:1.0 orientation:UIImageOrientationDownMirrored];
    
    CGImageRef inImage = self.CGImage;
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

- (UIImage *)applyLightEffect
{
  UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
  return [self applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyExtraLightEffect
{
  UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
  return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyDarkEffect
{
  UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
  return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor
{
  const CGFloat EffectColorAlpha = 0.6;
  UIColor *effectColor = tintColor;
  long componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
  if (componentCount == 2) {
    CGFloat b;
    if ([tintColor getWhite:&b alpha:NULL]) {
      effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
    }
  }
  else {
    CGFloat r, g, b;
    if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
      effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
    }
  }
  return [self applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}


- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
  // Check pre-conditions.
  if (self.size.width < 1 || self.size.height < 1) {
    NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
    return nil;
  }
  if (!self.CGImage) {
    NSLog (@"*** error: image must be backed by a CGImage: %@", self);
    return nil;
  }
  if (maskImage && !maskImage.CGImage) {
    NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
    return nil;
  }
  
  CGRect imageRect = { CGPointZero, self.size };
  UIImage *effectImage = self;
  
  BOOL hasBlur = blurRadius > __FLT_EPSILON__;
  BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
  if (hasBlur || hasSaturationChange) {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef effectInContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(effectInContext, 1.0, -1.0);
    CGContextTranslateCTM(effectInContext, 0, -self.size.height);
    CGContextDrawImage(effectInContext, imageRect, self.CGImage);
    
    vImage_Buffer effectInBuffer;
    effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
    effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
    effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
    effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
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
  UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
  CGContextRef outputContext = UIGraphicsGetCurrentContext();
  CGContextScaleCTM(outputContext, 1.0, -1.0);
  CGContextTranslateCTM(outputContext, 0, -self.size.height);
  
  // Draw base image.
  CGContextDrawImage(outputContext, imageRect, self.CGImage);
  
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
