//
//  ImageOperationHistoryManager.m
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "ImagesFileManager.h"
#import "Helper.h"
#import  <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

NSString * const kProcessedImagesFolder = @"/ProcessedImages";


@implementation ImagesFileManager

+ (NSArray *)loadProcessedImagesFilePathsFromDocuments
{
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:kProcessedImagesFolder];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory error:&error];
    
    NSMutableArray *jpegFiles = [NSMutableArray arrayWithCapacity:[filePathsArray count]];
    NSString *filename;
    
    for (filename in filePathsArray) {
        if ([filename pathExtension].length > 0) {
            NSString *fullFilePath = [documentsDirectory stringByAppendingPathComponent:filename];
            [jpegFiles addObject:fullFilePath];
        }
    }
    
    return jpegFiles;
}

+ (NSString *)saveProcessedImage:(UIImage *)image
{
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:kProcessedImagesFolder];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *filename = [NSString stringWithFormat:@"%@.png", [Helper timeStamp]];
    NSString *filePath = [dataPath stringByAppendingPathComponent:filename];
  NSData * data = UIImagePNGRepresentation(image);
  [data writeToFile:filePath atomically:YES];
  
  CGImageSourceRef source;
  source = CGImageSourceCreateWithData((CFDataRef)data, NULL);
  
  NSDictionary *metadata = (NSDictionary *) CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source, 0, NULL));
  
  NSMutableDictionary *metadataAsMutable = [metadata mutableCopy];
 
  
  NSMutableDictionary *EXIFDictionary = [[metadataAsMutable objectForKey:(NSString *)kCGImagePropertyExifDictionary]mutableCopy];
  NSMutableDictionary *GPSDictionary = [[metadataAsMutable objectForKey:(NSString *)kCGImagePropertyGPSDictionary]mutableCopy];
  
  
  if(!EXIFDictionary)
  {
    //if the image does not have an EXIF dictionary (not all images do), then create one for us to use
    EXIFDictionary = [NSMutableDictionary dictionary];
  }
  
  if(!GPSDictionary)
  {
    GPSDictionary = [NSMutableDictionary dictionary];
  }
  
  //Setup GPS dict -
  //I am appending my custom data just to test the logic……..
  
  [GPSDictionary setValue:[NSNumber numberWithFloat:1.1] forKey:(NSString*)kCGImagePropertyGPSLatitude];
  [GPSDictionary setValue:[NSNumber numberWithFloat:2.2] forKey:(NSString*)kCGImagePropertyGPSLongitude];
  [GPSDictionary setValue:@"lat_ref" forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
  [GPSDictionary setValue:@"lon_ref" forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
  [GPSDictionary setValue:[NSNumber numberWithFloat:3.3] forKey:(NSString*)kCGImagePropertyGPSAltitude];
  [GPSDictionary setValue:[NSNumber numberWithShort:4.4] forKey:(NSString*)kCGImagePropertyGPSAltitudeRef];
  [GPSDictionary setValue:[NSNumber numberWithFloat:5.5] forKey:(NSString*)kCGImagePropertyGPSImgDirection];
  [GPSDictionary setValue:@"_headingRef" forKey:(NSString*)kCGImagePropertyGPSImgDirectionRef];
  
  [EXIFDictionary setValue:@"xml_user_comment" forKey:(NSString *)kCGImagePropertyExifUserComment];
  //add our modified EXIF data back into the image’s metadata
  [metadataAsMutable setObject:EXIFDictionary forKey:(NSString *)kCGImagePropertyExifDictionary];
  [metadataAsMutable setObject:GPSDictionary forKey:(NSString *)kCGImagePropertyGPSDictionary];
  
  CFStringRef UTI = CGImageSourceGetType(source);
  NSMutableData *dest_data = [NSMutableData data];
  
  CGImageDestinationRef destination = CGImageDestinationCreateWithData((CFMutableDataRef) dest_data, UTI, 1, NULL);
  
  if(!destination)
  {
    NSLog(@"--------- Could not create image destination---------");
  }
  
  
  CGImageDestinationAddImageFromSource(destination, source, 0, (CFDictionaryRef) metadataAsMutable);
  
  BOOL success = NO;
  success = CGImageDestinationFinalize(destination);
  
  if(!success)
  {
    NSLog(@"-------- could not create data from image destination----------");
  }
  //[dest_data writeToFile:filePath atomically:YES];

  return filePath;
}

+ (BOOL)removeProcessedImageByPath:(NSString *)path
{
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    
    if (!success) {
        NSLog(@"Could not delete file -:%@ ", [error localizedDescription]);
    }
    
    return success;
}

@end
