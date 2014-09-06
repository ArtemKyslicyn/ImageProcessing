//
//  Helper.m
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+(NSString *) timeStamp; {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] *1000;
    NSInteger time = interval;
    return [NSString stringWithFormat:@"%ld",(long)time];
}

@end
