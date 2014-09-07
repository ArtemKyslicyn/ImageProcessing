//
//  ImageOperation.h
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//


typedef void(^ProgressBlock)();
typedef id (^OperationBlock)(void);
typedef void(^CompleteBlock)(UIImage * image);


@interface ImageOperation : NSObject

@property (nonatomic, assign) BOOL isProcessed;
@property (nonatomic, assign) float progress;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, copy) ProgressBlock progressBlock;
@property (nonatomic, copy) OperationBlock operation;
@property (nonatomic, copy) CompleteBlock completeBlock;

-(void)processedImage:(void (^)(UIImage* image))complete;
-(void)start;

@end
