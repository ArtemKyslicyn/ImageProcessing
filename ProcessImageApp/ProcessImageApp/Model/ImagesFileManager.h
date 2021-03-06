//
//  ImageOperationHistoryManager.h
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//


@interface ImagesFileManager : NSObject

+ (NSString *)saveProcessedImage:(UIImage *)image;
+ (NSArray *)loadProcessedImagesFilePathsFromDocuments;
+ (BOOL)removeProcessedImageByPath:(NSString *)path;

@end
