//
//  ImageProcessingTableDataSource.m
//  ProcessImageApp
//
//  Created by Arcilite on 27.07.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import "ImageProcessingTableDataSource.h"
#import "ProcessImageTableViewCell.h"
#import "ImageOperation.h"
@implementation ImageProcessingTableDataSource



#pragma mark - TableView delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.imagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"cellIdentifier";
  
  ProcessImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                    forIndexPath:indexPath];
  
  ImageOperation *imageOperation = [self.imagesArray objectAtIndex:indexPath.row];
  
  cell.processedImageView.image = nil;
  cell.progressView.hidden = imageOperation.isProcessed;
  cell.progressView.progress = imageOperation.progress;
  cell.processedImageView.image = imageOperation.image;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  self.selectedRow(indexPath.row);
}



@end
