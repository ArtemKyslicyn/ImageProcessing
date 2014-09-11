//
//  ImageExiffDataObject.m
//  ProcessImageApp
//
//  Created by Arcilite on 09.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "ImageExiffDataObject.h"

@implementation ImageExiffDataObject


-(void)extractExifDataInObjectFromImage:(UIImage*)image{
    
    NSData *jpeg = [NSData dataWithData:UIImagePNGRepresentation(image)];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)jpeg, NULL);
   // CFDictionaryRef imageMetaData = CGImageSourceCopyPropertiesAtIndex(source,0,NULL);
    NSDictionary *myMetadata = (__bridge NSDictionary *) CGImageSourceCopyPropertiesAtIndex(source,0,NULL);
    NSDictionary *exifDic = [myMetadata objectForKey:(NSString *)kCGImagePropertyExifDictionary];
    NSDictionary *tiffDic = [myMetadata objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
    NSLog(@"exifDic properties: %@", myMetadata); //all data
    float rawShutterSpeed = [[exifDic objectForKey:(NSString *)kCGImagePropertyExifExposureTime] floatValue];
    int decShutterSpeed = (1 / rawShutterSpeed);
    NSLog(@"Camera %@",[tiffDic objectForKey:(NSString *)kCGImagePropertyTIFFModel]);
    NSLog(@"Focal Length %@mm",[exifDic objectForKey:(NSString *)kCGImagePropertyExifFocalLength]);
    NSLog(@"Shutter Speed %@", [NSString stringWithFormat:@"1/%d", decShutterSpeed]);
    NSLog(@"Aperture f/%@",[exifDic objectForKey:(NSString *)kCGImagePropertyExifFNumber]);
    NSNumber *ExifISOSpeed  = [[exifDic objectForKey:(NSString*)kCGImagePropertyExifISOSpeedRatings] objectAtIndex:0];
    NSLog(@"ISO %ld",(long)[ExifISOSpeed integerValue]);
    NSLog(@"Taken %@",[exifDic objectForKey:(NSString*)kCGImagePropertyExifDateTimeDigitized]);

}


@end
