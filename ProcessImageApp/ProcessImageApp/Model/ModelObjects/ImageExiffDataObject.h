//
//  ImageExiffDataObject.h
//  ProcessImageApp
//
//  Created by Arcilite on 09.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageExiffDataObject : NSObject

@property (nonatomic,strong) NSString * cameraString;
@property (nonatomic,strong) NSString * focalLength;
@property (nonatomic,strong) NSString * shaterSpeed;
@property (nonatomic,strong) NSString * rawShutterSpeed;
@property (nonatomic,strong) NSString * aperture;
@property (nonatomic,strong) NSString * exifISOSpeed;
@property (nonatomic,strong) NSString * taken;
@property (nonatomic,strong) NSString * сolorModel;
@property (nonatomic,strong) NSString * depth;
@property (nonatomic,strong) NSString * pixelHeight;
@property (nonatomic,strong) NSString * pixelWidth;

-(void)extractExifDataInObjectFromImage:(UIImage*)image;


@end
