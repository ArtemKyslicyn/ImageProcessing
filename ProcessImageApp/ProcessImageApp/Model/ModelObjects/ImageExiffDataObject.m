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
  
   NSLog(@"meta %@",myMetadata);
    NSDictionary *exifDic = [myMetadata objectForKey:(NSString *)kCGImagePropertyExifDictionary];
    NSDictionary *tiffDic = [exifDic objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
    NSLog(@"tiff %@",tiffDic);
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
  self.cameraString = [tiffDic objectForKey:(NSString *)kCGImagePropertyTIFFModel];
  self.focalLength = [exifDic objectForKey:(NSString *)kCGImagePropertyExifFocalLength];
  self.shaterSpeed =  [NSString stringWithFormat:@"1/%d", decShutterSpeed];
  self.rawShutterSpeed = [[exifDic objectForKey:(NSString *)kCGImagePropertyExifExposureTime] stringValue];
  self.aperture = [exifDic objectForKey:(NSString *)kCGImagePropertyExifFNumber];
  self.exifISOSpeed = [ExifISOSpeed stringValue];
  self.taken = [[exifDic objectForKey:(NSString *)kCGImagePropertyExifExposureTime] stringValue];
  self.depth = [[myMetadata objectForKey:@"Depth"] stringValue];
  self.pixelWidth = [[myMetadata objectForKey:(NSString *)kCGImagePropertyPixelWidth] stringValue];
  self.pixelHeight = [[myMetadata objectForKey:(NSString *)kCGImagePropertyPixelHeight] stringValue];
  CFRelease((__bridge CFTypeRef)(myMetadata));
  CFRelease(source);
  
  
}


@end
