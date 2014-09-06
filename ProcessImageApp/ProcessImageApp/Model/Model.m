//
//  Model.m
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "Model.h"

static NSString * const kAKException             = @"You Can't create instance for singleton";
static NSString * const kAKExceptionReason       = @"You Trying to call new for singleton";
static NSString * const KRachebilityTestResource = @"www.google.com";


@implementation Model

static id _sharedInstance;

+ (id)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
       
        
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = nil;
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (id)new
{
    NSException *exception = [[NSException alloc] initWithName:kAKException
                                                        reason:kAKExceptionReason
                                                      userInfo:nil];
    [exception raise];
    
    return nil;
}


@end
