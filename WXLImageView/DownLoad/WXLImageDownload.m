//
//  WXLImageDownload.m
//  WXLImageView
//
//  Created by 魏晓磊 on 16/5/31.
//  Copyright © 2016年 魏晓磊. All rights reserved.
//

#import "WXLImageDownload.h"
#import "WXLFileTool.h"
#import "WXLPubfun.h"

@implementation WXLImageDownload

- (void)downloadWithURL:(NSURL *)url delegate:(id<WXLDownloadDelegate>)delegate {
    
    self.url = url;
    self.delegate = delegate;
}

- (void)start {
    
    self.filename = [[WXLPubfun defaultPubfun] md5:[self.url absoluteString]];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [self.connection start];
    
    if (self.connection)
    {
        self.imageData = [NSMutableData data];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(download:didFailWithError:)])
        {
            [self.delegate performSelector:@selector(download:didFailWithError:) withObject:self withObject:[NSError errorWithDomain:@"Connect link fail" code:ConnectLinkFail userInfo:nil]];
        }
    }
}

- (void)cancel
{
    if (self.connection)
    {
        [self.connection cancel];
        self.connection = nil;
    }
}

#pragma mark NSURLConnection (delegate)

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    NSHTTPURLResponse * http = (NSHTTPURLResponse*)response;
//    NSLog(@"请求状态码------->%ld",(long)http.statusCode);
    
    // 获得文件的总大小
    self.totalLength = response.expectedContentLength;

}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
    
    // 累计写入文件的长度
    self.currentLength += data.length;
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadPercent:)])
    {
        [self.delegate downloadPercent:(double)self.currentLength/self.totalLength];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
    self.currentLength = 0;
    self.totalLength = 0;
    
    self.connection = nil;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadFinished:responseData:)])
    {
        [self.delegate performSelector:@selector(downloadFinished:responseData:) withObject:self.imageData];
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(download:didFailWithError:)])
    {
        [self.delegate performSelector:@selector(download:didFailWithError:) withObject:self withObject:error];
    }
    
    self.connection = nil;
    self.imageData = nil;
}

@end
