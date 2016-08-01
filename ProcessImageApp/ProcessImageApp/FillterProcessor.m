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

@implementation FillterProcessor
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

@end
