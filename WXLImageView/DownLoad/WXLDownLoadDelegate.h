//
//  WXLDownLoadDelegate.h
//  WXLImageView
//
//  Created by 魏晓磊 on 16/5/31.
//  Copyright © 2016年 魏晓磊. All rights reserved.
//

@class WXLImageDownload;

@protocol WXLDownloadDelegate <NSObject>

- (void)downloadFinished:(WXLImageDownload *)imageDownload responseData:(NSMutableData *)data;
- (void)download:(WXLImageDownload *)imageDownload didFailWithError:(NSError *)error;
- (void)downloadPercent:(double)percent;

@end
