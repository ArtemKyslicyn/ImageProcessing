//
//  ImageDownloader.h
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//


@interface ImageDownloader : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *imageDownloadOperationsArrray;

- (void)addImageOperationForUrlString:(NSString *)url
                                 fail:(void (^)(NSError *))fail
                             complete:(void (^)(UIImage *image))complete
                             progress:(void (^)(float progress))progressBlock;

@end
