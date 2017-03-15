//
//  WXLFileTool.m
//  WXLImageView
//
//  Created by weixiaolei on 16/6/2.
//  Copyright © 2016年 魏晓磊. All rights reserved.
//

#import "WXLFileTool.h"
#import "WXLConstants.h"

@implementation WXLFileTool

+ (WXLFileTool *)defaultFileTool {
    static WXLFileTool * tool = nil;
    if (!tool) {
        static dispatch_once_t token;
        dispatch_once(&token, ^{
            tool = [[WXLFileTool alloc] init];
        });
    }
    return tool;
}

-(NSString *) getAdYuMICacheFilePath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    //获得Library的路径
    NSString *libDirectory = [paths objectAtIndex:0];
    //拼接缓存文件存放的路径
    NSString *path = [libDirectory stringByAppendingPathComponent:WXLCachePath];
    
    return path;
}

- (BOOL)writePlistFile:(NSDictionary *)data withFileName:(NSString *)fileName{
    
    //获得目录路径
    NSString *directoryPath = [self getAdYuMICacheFilePath];
    
    //拼接文件路径
    NSString *appFile = [directoryPath stringByAppendingPathComponent:fileName];
    
    return  [data writeToFile:appFile atomically:YES];
}

/*
 写入文件
 */
- (BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName{
    
    //获得目录路径
    NSString *directoryPath = [self getAdYuMICacheFilePath];
    
    //拼接文件路径
    NSString *appFile = [directoryPath stringByAppendingPathComponent:fileName];
    //创建NSFileManager用于创建缓存文件并写入数据
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //如果路径不存在 创建路径
    if(![fileManager fileExistsAtPath:directoryPath]){
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //写入数据
    BOOL writestatus = [fileManager createFileAtPath:appFile contents:data attributes:nil];
    return writestatus;
}

/**
 *  删除缓存文件
 *
 *  @param fileName 删除缓存文件
 */
-(void)removeApplicationData:(NSString*)fileName{
    //获得目录路径
    NSString *directoryPath = [self getAdYuMICacheFilePath];
    //拼接文件路径
    NSString *appFile = [directoryPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:appFile];
    if (bRet) {
        NSError *err;
        [fileMgr removeItemAtPath:appFile error:&err];
    }
}



- (BOOL)writeCacheFile:(NSData *)data{
    return  [self writeApplicationData:data toFile:WXLCacheFileName];
}

- (BOOL)writeCacheFile:(NSData *)data withFileName:(NSString *)fileName{
    return [self writeApplicationData:data toFile:fileName];
}

/**
 *获取配置数据通过离线缓存
 */
- (NSData *)getDataFromFile:(NSString *)fileName{
    
    NSData *configData = nil;
    NSString *appFile = [[self getAdYuMICacheFilePath] stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //如果存在文件读出Content
    if([fileManager fileExistsAtPath:appFile]){
        configData = [[NSData alloc] initWithContentsOfFile:appFile];
    }
    return configData;
}

@end
