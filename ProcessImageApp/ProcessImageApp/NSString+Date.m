//
//  NSString+Date.m
//  ProcessImageApp
//
//  Created by Arcilite on 27.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

+ (NSString *) timeStamp {
  return [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
}

@end

