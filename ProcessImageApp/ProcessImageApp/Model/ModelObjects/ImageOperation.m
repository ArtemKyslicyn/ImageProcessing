//
//  ImageOperation.m
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "ImageOperation.h"
#import "Helper.h"


@interface ImageOperation()

@property (nonatomic,assign) dispatch_queue_t myQueue ;

@end


@implementation ImageOperation {
    NSTimer *_timer;
    float _timerFires;
    float _periodTime;
   // UIImage *_img;
}

- (void)processedImage:(void (^)(UIImage *image))complete
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *img = nil;
        img = [UIImage imageWithContentsOfFile:self.filePath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(img);
        });
    });
}

- (void)start
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = self.operation();
        
        _periodTime = rand() % (25) + 5;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_periodTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completeBlock(image);
                self.isProcessed = YES;
            });
        });
    });
    
    _timer = [NSTimer scheduledTimerWithTimeInterval: 1
                                              target:self
                                            selector:@selector(progressUpdate:)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)progressUpdate:(id)sender
{
    _timerFires++;
    
    NSLog(@"timer %f", _timerFires);
    NSLog(@"period %f", _periodTime);
    
    float progress = (_timerFires  ) / _periodTime;
    NSLog(@"progress %f", progress);
    
    self.progress = progress;
    self.progressBlock();
    
    if ((_timerFires ) >= _periodTime) {
        [_timer invalidate];
    }
}

@end
