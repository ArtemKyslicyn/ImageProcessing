//
//  ImageOperationManager.h
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//


@class ImageOperation;

@interface ImageOperationManager : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *imageOperationsArrray;
@property (nonatomic, assign) float progress;

- (void)deleteImageProcessedOperation:(ImageOperation *)imageOperation
                             complete:(void (^)())complete
                                 fail:(void (^)())fail;

- (void)addImageOperationForImage:(UIImage *)image
                        operation:(id (^)())operationBlock
                            start:(void (^)())start
                         complete:(void (^)(UIImage*))complete
                         progress:(void (^)())progress;

@end
