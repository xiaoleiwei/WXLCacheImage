//
//  WXLCore.m
//  WXLImageView
//
//  Created by 魏晓磊 on 16/5/31.
//  Copyright © 2016年 魏晓磊. All rights reserved.
//

#import "WXLCore.h"
#import "WXLMemoryManager.h"
#import "WXLFileManager.h"
#import "WXLImageDownload.h"
#import "WXLConstants.h"
#import "WXLPubfun.h"

@interface WXLCore()<WXLDownloadDelegate> {
    WXLImageDownload * load;
}

@end

@implementation WXLCore

- (void)setURL:(NSString *)url coreDelegate:(id<WXLCoreDelegate>)delegate {
 
    self.url = url;
    self.key = [[WXLPubfun defaultPubfun] md5:url];
    self.delegate = delegate;
    
}

- (void)cacheCore {
    BOOL isExist = [self isExistInMemoryAndLocalfile];
    if (isExist)
    {
        if ([self.delegate respondsToSelector:@selector(imageloadFinished:)]) {
            [self.delegate imageloadFinished:self.savedData];
        }
        return;
    }
    else
    {
        load = [[WXLImageDownload alloc] init];
        [load downloadWithURL:[NSURL URLWithString:self.url] delegate:self];
        [load start];
    }
}


#pragma mark - Check include data
- (BOOL)isExistInMemoryAndLocalfile {
    
    NSMutableData * mdata = [[[WXLMemoryManager defaultMemoryManager] getMemoryData] objectForKey:self.key];
    if (mdata)
    {
        NSLog(@"内存中已经存在缓存好的data");
        self.savedData = mdata;
        return YES;
        
    }
    else
    {
        NSMutableData * cdata = [[WXLFileManager defaultFileManager] getFileData:self.key];
        if (cdata)
        {
            NSLog(@"本地中已经存在缓存好的data");
            //保存到内存
            [[WXLMemoryManager defaultMemoryManager] saveMemoryWithData:cdata key:self.key];
            self.savedData = cdata;
            return YES;
        }
    }
    return NO;
}


#pragma mark - WXLCustomImageView Delegate
- (void)downloadFinished:(WXLImageDownload *)imageDownload responseData:(NSMutableData *)data {
    
    NSLog(@"\"%@\"-------->下载成功!",self.key);
    
    //保存到内存
    [[WXLMemoryManager defaultMemoryManager] saveMemoryWithData:data key:self.key];
    //保存到本地
    [[WXLFileManager defaultFileManager] saveFileManagerData:data key:self.key];
    
    if ([self.delegate respondsToSelector:@selector(imageloadFinished:)]) {
        [self.delegate imageloadFinished:data];
    }
}

- (void)download:(WXLImageDownload *)imageDownload didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(imageloadDidFailWithError:)]) {
        [self.delegate imageloadDidFailWithError:error];
    }
}

- (void)downloadPercent:(double)percent {
    if ([self.delegate respondsToSelector:@selector(imageloadPercent:)]) {
        [self.delegate imageloadPercent:percent];
    }
}
 

@end
