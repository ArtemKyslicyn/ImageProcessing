//
//  ImageProcessingTableDataSource.h
//  ProcessImageApp
//
//  Created by Arcilite on 27.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageProcessingTableDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)  NSArray *imagesArray;
@property (nonatomic, copy) void (^reloadBlock)();
@property (nonatomic, copy) void (^selectedRow)(NSInteger row);

@end
