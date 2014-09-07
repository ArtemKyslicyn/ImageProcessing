//
//  ImageOperation.m
//  ProcessImageApp
//
//  Created by Arcilite on 06.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "ImageOperation.h"

@interface ImageOperation()

@property (nonatomic,assign) dispatch_queue_t myQueue ;

@end

@implementation ImageOperation{
    
}

-(void)processedImage:(void (^)(UIImage* image))complete{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage * img ;

       
        img = [UIImage imageWithContentsOfFile:self.filePath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(img);
        });
    });
   
    
    
}

@end
