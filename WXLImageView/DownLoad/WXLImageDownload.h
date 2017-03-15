//
//  WXLImageDownload.h
//  WXLImageView
//
//  Created by 魏晓磊 on 16/5/31.
//  Copyright © 2016年 魏晓磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXLDownLoadDelegate.h"

typedef enum : NSUInteger {
    ConnectLinkFail = 11,
} DownloadErrorType;

@interface WXLImageDownload : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<WXLDownloadDelegate>delegate;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *imageData;
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, assign) long long totalLength;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *filepath;
@property (nonatomic, strong) NSFileHandle *writehandle;
@property (nonatomic, assign) long long currentLength;


- (void)downloadWithURL:(NSURL *)url delegate:(id<WXLDownloadDelegate>)delegate;
- (void)start;
- (void)cancel;

@end
