//
//  WXLMemoryManager.h
//  WXLImageView
//
//  Created by weixiaolei on 16/6/2.
//  Copyright © 2016年 魏晓磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXLMemoryManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (nonatomic, strong) NSMutableArray *keyArray;

+ (WXLMemoryManager *)defaultMemoryManager;

/**
 *  save data in memory
 *
 *  @param data saved data
 *  @param key  key
 */
- (void)saveMemoryWithData:(NSData *)data key:(NSString *)key;
/**
 *  get data from memory
 *
 *  @return data dictionary
 */
- (NSMutableDictionary *)getMemoryData;


@end
