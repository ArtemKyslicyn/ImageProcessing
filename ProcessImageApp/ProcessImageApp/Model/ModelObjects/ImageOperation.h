//
//  ImageOperation.h
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ProgressBlock)(float progress);

typedef id (^OperationBlock)(void);

typedef void(^CompleteBlock)(UIImage * image);


@interface ImageOperation : NSObject

@property (nonatomic,assign) BOOL isProcessed ;

@property (nonatomic,strong) NSString * filePath;

@property (nonatomic,copy) ProgressBlock progress ;

@property (nonatomic,copy) OperationBlock operation ;

@property (nonatomic,copy) CompleteBlock completeBlock ;

-(void)processedImage:(void (^)(UIImage* image))complete;

-(void)start;

@end
