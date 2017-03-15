//
//  WXLFileTool.h
//  WXLImageView
//
//  Created by weixiaolei on 16/6/2.
//  Copyright © 2016年 魏晓磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXLFileTool : NSObject

+ (WXLFileTool *)defaultFileTool;

/**
 *  获取 kAdMoGoCachePath 完成路径
 *  AdMoGoSDK 所有缓存文件都保存在此目录下
 *
 *  @return  缓存文件路径
 */
- (NSString *) getAdYuMICacheFilePath;


/**
 *  将数据写入 kAdMoGoCachePath 定义的路径下
 *
 *  @param data     待写入的数据
 *  @param fileName 文件名
 *
 *  @return 写入成功YES，写入失败返回NO
 */
- (BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName;


/**
 *  将数据写入 AdsYUMICachePath 路径下的 AdsYUMICacheFileName 文件
 *  将用户配置保存到本地
 *
 *  @param data 待写入的数据
 *
 *  @return  写入成功YES，写入失败返回NO
 */
- (BOOL)writeCacheFile:(NSData *)data;

/**
 *   将数据写入 AdsYUMICachePath 路径下的 fileName 文件
 *   将用户配置保存到本地
 *
 *  @param data     待写入的数据
 *  @param fileName 文件名
 *
 *  @return  写入成功YES，写入失败返回NO
 */
- (BOOL)writeCacheFile:(NSData *)data withFileName:(NSString *)fileName;
/**
 *  将数据写入 AdsYUMICachePath 路径下的 fileName 文件
 *  将用户配置保存到本地
 *
 *  @param data     待写入的数据
 *  @param fileName 文件名
 *
 *  @return  写入成功YES，写入失败返回NO
 */
- (BOOL)writePlistFile:(NSDictionary *)data withFileName:(NSString *)fileName;

/**
 *  删除缓存文件
 *
 *  @param fileName 文件名称
 */
-(void)removeApplicationData:(NSString*)fileName;

/**
 *  从 AdsYUMICachePath 路径下获取文件数据
 *
 *  @param fileName 文件名
 *
 *  @return 数据文件
 */
- (NSData *) getDataFromFile:(NSString *)fileName;


@end
