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
  NSMutableDictionary *mutableMetadata = [[NSMutableDictionary alloc] init];
  [mutableMetadata setObject:@"addd" forKey:(NSString *)kCGImagePropertyTIFFModel];
  [mutableMetadata setObject:@"addd" forKey:(NSString *)kCGImagePropertyExifFocalLength];
  [mutableMetadata setObject:@"addd" forKey:(NSString *)kCGImagePropertyExifDateTimeDigitized];
  [mutableMetadata setObject:@"addd" forKey:(NSString *)kCGImagePropertyExifISOSpeedRatings];
  [mutableMetadata setObject:@"addd" forKey:(NSString *)kCGImagePropertyExifDateTimeDigitized];
  
  
  [mutableMetadata setObject:@(1.0) forKey:(__bridge NSString *)kCGImageDestinationLossyCompressionQuality];
  
  
  // Create an image destination.
  CGImageDestinationRef imageDestination = CGImageDestinationCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:filePath], kUTTypeJPEG , 1, NULL);
  
  
  // Add your image to the destination.
  CGImageDestinationAddImage(imageDestination, image.CGImage, (__bridge CFDictionaryRef)mutableMetadata);
  
  // Finalize the destination.
  if (CGImageDestinationFinalize(imageDestination) == NO) {
    
    // Handle failure.
    NSLog(@"Error -> failed to finalize the image.");
  }
  
  CFRelease(imageDestination);
  
 

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
