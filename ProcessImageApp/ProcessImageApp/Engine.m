//
//  Engine.m
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

static NSString * const kAKException             = @"You Can't create instance for singleton";
static NSString * const kAKExceptionReason       = @"You Trying to call new for singleton";
static NSString * const KRachebilityTestResource = @"www.google.com";

#import "Engine.h"

static id _sharedInstance;


@implementation Engine

//+ (Engine *)sharedManager
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedInstance = [[self alloc] init];
//    });
//    return _sharedInstance;
//}

- (id)init
{
    if (self = [super init]) {
        _operationsManager = [ImageOperationManager new];
        _downloadManager  =  [ImageDownloader new];
    }
    return self;
}

//+ (id)allocWithZone:(NSZone *)zone
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedInstance = nil;
//        _sharedInstance = [super allocWithZone:zone];
//    });
//    return _sharedInstance;
//}
//
//- (id)copyWithZone:(NSZone *)zone
//{
//    return self;
//}
//
//+ (id)new
//{
//    NSException *exception = [[NSException alloc] initWithName:kAKException
//                                                        reason:kAKExceptionReason
//                                                      userInfo:nil];
//    [exception raise];
//    
//    return nil;
//}

@end
