//
//  ImageExiffDataObject.h
//  ProcessImageApp
//
//  Created by Arcilite on 09.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageExiffDataObject : NSObject

@property (nonatomic,assign) NSString * cameraString;
@property (nonatomic,assign) NSString * focalLength;
@property (nonatomic,assign) NSString * shaterSpeed;
@property (nonatomic,assign) NSString * rawShutterSpeed;
@property (nonatomic,assign) NSString * aperture;
@property (nonatomic,assign) NSString * exifISOSpeed;
@property (nonatomic,assign) NSString * taken;

-(void)extractExifDataInObjectFromImage:(UIImage*)image;


@end
