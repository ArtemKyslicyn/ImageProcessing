//
//  RotateFiltet.h
//  ProcessImageApp
//
//  Created by Arcilite on 28.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import "BaseFilter.h"

@interface RotateFilter : BaseFilter
@property (nonatomic,assign) float degrees;

- (id)initWithImage:(UIImage*)image rotate:(float)degrees;

@end
