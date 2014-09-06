//
//  ImageOperationHistoryManager.m
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "ImagesFileManager.h"
#import "Helper.h"

 NSString * const kProcessedImagesFolder = @"/ProcessedImages";

@implementation ImagesFileManager

+(NSArray*)loadProcessedImagesFilePathsFromDocuments{
    NSError * error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:kProcessedImagesFolder];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:&error];
    
    return filePathsArray;
}

+(void)saveProcessedImage:(UIImage*)image{
    NSError * error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:kProcessedImagesFolder];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString * filename = [NSString stringWithFormat:@"%@.png",[Helper timeStamp]];
    NSString * filePath = [dataPath stringByAppendingPathComponent:filename];
    
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    
    
}


@end
