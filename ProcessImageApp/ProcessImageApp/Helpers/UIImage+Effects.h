//
//  UIImage+Effects.h
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//


@interface UIImage (Effects)

- (UIImage *)rotateImageForDegree:(float)degree;
- (UIImage *)invertedImage;
- (UIImage *)negativeImage;
- (UIImage *)horizontalMirror;

@end
