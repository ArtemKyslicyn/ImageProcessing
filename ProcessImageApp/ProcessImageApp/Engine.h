//
//  Engine.h
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "ImageOperationManager.h"
#import "ImageDownloader.h"

@interface Engine : NSObject

@property (nonatomic, retain)  ImageOperationManager *operationsManager;
@property (nonatomic, retain)  ImageDownloader *downloadManager;

+ (Engine *)sharedManager;

@end
