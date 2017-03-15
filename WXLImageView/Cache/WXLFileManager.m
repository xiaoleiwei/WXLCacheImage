//
//  WXLFileManager.m
//  WXLImageView
//
//  Created by weixiaolei on 16/6/2.
//  Copyright © 2016年 魏晓磊. All rights reserved.
//

#import "WXLFileManager.h"

@implementation WXLFileManager

+ (WXLFileManager *)defaultFileManager {
    static WXLFileManager * fileManager = nil;
    if (!fileManager) {
        static dispatch_once_t token;
        dispatch_once(&token, ^{
            fileManager = [[WXLFileManager alloc] init];
        });
    }
    return fileManager;
}

- (void)saveFileManagerData:(NSData *)data key:(NSString *)key {
    
    BOOL success = [[WXLFileTool defaultFileTool] writeCacheFile:data withFileName:key];
    NSLog(@"写入数据%@",success?@"成功":@"失败");

}

- (NSMutableData *)getFileData:(NSString *)path {
    
    return (NSMutableData *)[[WXLFileTool defaultFileTool] getDataFromFile:path];

}


@end
