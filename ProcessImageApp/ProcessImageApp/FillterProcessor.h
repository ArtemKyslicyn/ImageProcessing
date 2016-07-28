//
//  FillterProcessor.h
//  ProcessImageApp
//
//  Created by Arcilite on 27.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseFilter;

@interface FillterProcessor : NSObject

@property (nonatomic, strong) ImageOperationManager *operationManager;

@property (nonatomic, copy) void (^start)();
@property (nonatomic, copy) void (^progressBlock) (ImageOperation*progress);
- (void)startFilter: (BaseFilter*)filter
           complete:(void (^)(UIImage*))complete;
@end
