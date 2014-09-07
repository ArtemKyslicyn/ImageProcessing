//
//  DownloadOperation.m
//  ProcessImageApp
//
//  Created by Arcilite on 08.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "DownloadOperation.h"
@interface DownloadOperation()

@property (nonatomic,retain) NSMutableData * receivedData;

@end
@implementation DownloadOperation{
    
}


-(void)downloadByUrlString:(NSString*)urlString{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:10.0];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [theConnection start];
    
    if (theConnection) {
        
        self.receivedData = [NSMutableData data] ;
        
    }


}






- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_receivedData appendData:data];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    
}


- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes{
    NSLog(@" is %lld  from% lld",totalBytesWritten,expectedTotalBytes);
}



- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *) destinationURL{
    
    
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
 
    NSLog(@"Connection failed! Error - %@",
          [error localizedDescription]);
}



@end
