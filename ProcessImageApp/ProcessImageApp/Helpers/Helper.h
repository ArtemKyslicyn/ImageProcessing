//
//  Helper.h
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//


@interface Helper : NSObject

+ (NSString *)timeStamp;

dispatch_source_t CreateDispatchTimer(uint64_t         interval,
                                      uint64_t         leeway,
                                      dispatch_queue_t queue,
                                      dispatch_block_t block);

@end
