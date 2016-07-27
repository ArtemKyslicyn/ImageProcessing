//
//  AlertOperationDelegationObject.m
//  ProcessImageApp
//
//  Created by Arcilite on 27.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import "AlertOperationDelegationObject.h"

@implementation AlertOperationDelegationObject


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
//  __weak typeof(self) weakSelf = self;
//  switch (buttonIndex) {
//    case 1: {
//      ImageOperation *imageOperation = [self.imagesArray objectAtIndex:_selectedImageIndex];
//      [self.engine.operationsManager deleteImageProcessedOperation:imageOperation complete: ^{
//        [weakSelf updateProcessedList];
//      } fail: ^{
//      }];
//    }
//      break;
//      
//    case 2: {
//      ImageOperation *imageOperation = [self.imagesArray objectAtIndex:_selectedImageIndex];
//      [imageOperation processedImage: ^(UIImage *image) {
//        [weakSelf saveToLibarayImage:image];
//      }];
//    }
//      
//      break;
//      
//    case 3: {
//      ImageOperation *imageOperation = [self.imagesArray objectAtIndex:_selectedImageIndex];
//      [imageOperation processedImage: ^(UIImage *image) {
//        [weakSelf procesAgainImage:image];
//      }];
//    }
//      
//      break;
//      
//    default:
//      break;
//  }
}


@end
