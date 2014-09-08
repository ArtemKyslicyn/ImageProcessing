//
//  DownloadOperation.m
//  ProcessImageApp
//
//  Created by Arcilite on 08.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "DownloadOperation.h"


@interface DownloadOperation ()

@property (nonatomic, strong) NSMutableData *receivedData;

@end


@implementation DownloadOperation {
    NSURLConnection *_theConnection;
}


- (void)downloadByUrlString:(NSString *)urlString
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:10.0];
    
    _theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    if (_theConnection) {
        self.receivedData = [NSMutableData data];
    }
}

- (void)start
{
    [_theConnection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
     self.completeBlock([UIImage imageWithData:self.receivedData]);
    
}

- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten
                                            totalBytesWritten:(long long)totalBytesWritten
                                           expectedTotalBytes:(long long)expectedTotalBytes
{
    NSLog(@" is %lld  from% lld", totalBytesWritten, expectedTotalBytes);
    float progress = totalBytesWritten / expectedTotalBytes;
    self.progressBlock(progress);
}

- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL
{
    self.completeBlock([UIImage imageWithData:self.receivedData]);
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@",
          [error localizedDescription]);
}

@end
