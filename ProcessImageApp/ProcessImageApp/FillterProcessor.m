//
//  FillterProcessor.m
//  ProcessImageApp
//
//  Created by Arcilite on 27.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import "FillterProcessor.h"
#import "BaseFilter.h"
#import "ImageOperationManager.h"
@interface FillterProcessor ()

@property (nonatomic, strong) ImageOperationManager *operationManager;

@end


@implementation FillterProcessor

-(NSArray*)imageOperationsArrray{
  return self.operationManager.imageOperationsArrray;
}

- (id)init
{
  if (self = [super init]) {
    _operationManager = [ImageOperationManager new];
  
  }
  return self;
}

- (void)startFilter: (BaseFilter*)filter
                         complete:(void (^)(UIImage*))complete{
  

  
  [self.operationManager addImageOperationForImage:filter.image operation:^id{
    return [filter operationImage];
  } start:self.start complete:complete     progress:self.progressBlock];
  
  
}

- (void)deleteImageProcessedOperation:(ImageOperation *)imageOperation
                             complete:(void (^)())complete
                                 fail:(void (^)())fail{
  [self.operationManager deleteImageProcessedOperation:imageOperation complete:complete fail:fail];
}
  


@end
