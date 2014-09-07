//
//  ImageOperationHistoryManager.h
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagesFileManager : NSObject

+(void)saveProcessedImage:(UIImage*)image;

+(NSArray*)loadProcessedImagesFilePathsFromDocuments;

+(BOOL)removeProcessedImageByPath:(NSString*)path;

@end
