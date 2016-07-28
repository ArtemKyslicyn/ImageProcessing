//
//  BaseFilter.m
//  ProcessImageApp
//
//  Created by Arcilite on 27.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import "BaseFilter.h"

@implementation BaseFilter


- (id)initWithImage:(UIImage*)image{
  self = [super init];
  if (self) {
    self.image = image;
  }
  return self;
}

-(UIImage*)operationImage{
  return nil;
}

@end


