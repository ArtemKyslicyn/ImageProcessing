//
//  ImageOperationManager.h
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageOperation;
@interface ImageOperationManager : NSObject

@property (nonatomic,strong,readonly) NSMutableArray * imageOperationsArrray;

-(void)deleteImageProcessedOperation:(ImageOperation*)imageOperation complete:(void (^)())complete fail:(void (^)())fail;

@end
