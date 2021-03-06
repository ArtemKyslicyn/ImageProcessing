//
//  DownloadOperation.h
//  ProcessImageApp
//
//  Created by Arcilite on 08.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//


typedef void (^ProgressBlock)(float progress);
typedef void (^CompleteBlock)(UIImage *image);
typedef void (^FailBlock)(NSError *error);


@interface DownloadOperation : NSObject

@property (nonatomic, copy) ProgressBlock progressBlock;
@property (nonatomic, copy) FailBlock failBlock;
@property (nonatomic, copy) CompleteBlock completeBlock;
@property (nonatomic,assign) NSUInteger totalSize;
- (void)downloadByUrlString:(NSString *)urlString;
- (void)start;

@end
