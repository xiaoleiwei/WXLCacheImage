//
//  WXLFileManager.h
//  WXLImageView
//
//  Created by weixiaolei on 16/6/2.
//  Copyright © 2016年 魏晓磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXLFileTool.h"

@interface WXLFileManager : NSObject

@property (nonatomic, strong) WXLFileTool * fileTool;

+ (WXLFileManager *)defaultFileManager;

/**
 *  save data in file
 *
 *  @param data saved data
 *  @param key  key
 */
- (void)saveFileManagerData:(NSData *)data key:(NSString *)key;
/**
 *  get data from file
 *
 *  @param path file path
 *
 *  @return data
 */
- (NSMutableData *)getFileData:(NSString *)path;


@end
