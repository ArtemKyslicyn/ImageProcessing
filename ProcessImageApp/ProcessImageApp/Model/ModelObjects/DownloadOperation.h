//
//  DownloadOperation.h
//  ProcessImageApp
//
//  Created by Arcilite on 08.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ProgressBlock)();

typedef id (^OperationBlock)(void);

typedef void(^CompleteBlock)(UIImage * image);

@interface DownloadOperation : NSObject

@property (nonatomic,copy) ProgressBlock progressBlock ;

@property (nonatomic,copy) OperationBlock operation ;

@property (nonatomic,copy) CompleteBlock completeBlock ;


@end
