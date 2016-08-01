//
//  FillterProcessor.h
//  ProcessImageApp
//
//  Created by Arcilite on 27.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseFilter;
@class ImageOperationManager;
@class ImageOperation;

@interface FillterProcessor : NSObject

@property (nonatomic, strong, readonly) NSArray *imageOperationsArrray;

@property (nonatomic, copy) void (^start)();
@property (nonatomic, copy) void (^progressBlock) (ImageOperation*progress);
- (void)startFilter: (BaseFilter*)filter
           complete:(void (^)(UIImage*))complete;

- (void)deleteImageProcessedOperation:(ImageOperation *)imageOperation
                             complete:(void (^)())complete
                                 fail:(void (^)())fail;
@end
