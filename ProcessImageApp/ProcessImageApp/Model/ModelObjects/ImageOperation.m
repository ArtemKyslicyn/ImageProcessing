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


-(void)start{
    
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           UIImage * image = self.operation();
          
           float periodTime = rand() % (25) + 5;
           
           dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
           dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, periodTime * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
           
           int timerFires = 0;
           dispatch_source_set_event_handler(timer, ^{
               float progress = (timerFires*5) /periodTime;
               self.progress(progress);
           });
           
          dispatch_resume(timer);
          
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(periodTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               
               dispatch_async(dispatch_get_main_queue(), ^{
                   self.completeBlock(image);
               });
               
          });
          
          
           
         
       });
    
}
//-(void)invertOperationForImage:(UIImage*)image{
//    __block UIImage * resultImage;
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        resultImage = [image invertedImage];
//        [ImagesFileManager saveProcessedImage:image];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            /* Код, который выполниться в главном потоке */
//            self.imageView.image = image;
//            
//        });
//    });
//}

@end
