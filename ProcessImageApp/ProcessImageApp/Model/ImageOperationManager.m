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

- (id)init
{
    self = [super init];
    if (self) {
        _imageOperationsArrray = [NSMutableArray new];
        [self loadOperationsArray];
    }
    return self;
}

- (void)loadOperationsArray
{
    NSArray *pathsArray = [ImagesFileManager loadProcessedImagesFilePathsFromDocuments];
    
    for (NSString *path in pathsArray) {
        ImageOperation *operation = [ImageOperation new];
        operation.filePath = path;
        operation.isProcessed = YES;
        [self.imageOperationsArrray addObject:operation];
    }
}

- (void)deleteImageProcessedOperation:(ImageOperation *)imageOperation
                             complete:(void (^)())complete
                                 fail:(void (^)())fail
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL sucess = [ImagesFileManager removeProcessedImageByPath:imageOperation.filePath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (sucess) {
                [_imageOperationsArrray removeObject:imageOperation];
                complete();
            }
            else {
                fail();
            }
        });
    });
}

- (void)addImageOperationForImage:(UIImage *)image
                        operation:(id (^)())operationBlock
                            start:(void (^)())start
                         complete:(void (^)(UIImage*))complete
                         progress:(void (^)(ImageOperation*))progress
{
    if (!image) return;
    
    ImageOperation *operation = [ImageOperation new];
    operation.operation = operationBlock;
    operation.isProcessed = NO;
    
   
    
    operation.completeBlock = ^(UIImage *image,ImageOperation * operation) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *filePath = [ImagesFileManager saveProcessedImage:image];
            dispatch_async(dispatch_get_main_queue(), ^{
                operation.filePath = filePath;
                complete(image);
            });
        });
    };
    
    [self.imageOperationsArrray insertObject:operation atIndex:0];
    
    operation.progressBlock = ^(ImageOperation * operation) {
        
        progress(operation);
        
    };
    
    [operation start];
    
    start();
}

@end
