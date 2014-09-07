//
//  ImageOperationManager.m
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "ImageOperationManager.h"
#import  "ImagesFileManager.h"
#import  "ImageOperation.h"
@interface ImageOperationManager()

@end


@implementation ImageOperationManager

-(id)init{
    self =[super init];
    if (self) {
        _imageOperationsArrray = [NSMutableArray new];
        [self loadOperationsArray];
    }
    return self;
}


-(void)loadOperationsArray{
   
    NSArray * pathsArray = [ImagesFileManager loadProcessedImagesFilePathsFromDocuments];
    
    for (NSString * path in pathsArray) {
        ImageOperation * operation = [ImageOperation new];
        operation.filePath = path;
        operation.isProcessed = YES;
        [self.imageOperationsArrray addObject:operation];
    }
    
    
}




@end
