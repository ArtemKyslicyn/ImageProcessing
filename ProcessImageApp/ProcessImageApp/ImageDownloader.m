//
//  ImageDownloader.m
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "ImageDownloader.h"
#import "DownloadOperation.h"


@implementation ImageDownloader

- (void)addImageOperationForUrlString:(NSString *)url
                                 fail:(void (^)(NSError *))fail
                             complete:(void (^)(UIImage *image))complete
                             progress:(void (^)(float progress))progressBlock
{
    if (!url) return;
    
    DownloadOperation *operation = [DownloadOperation new];
    operation.completeBlock = complete;
    
    [self.imageDownloadOperationsArrray addObject:operation];
    
    operation.progressBlock = ^(float progress) {
        progressBlock(progress);
            // cell.progressView.progress = progress;
    };
    
    [operation start];
}

@end
