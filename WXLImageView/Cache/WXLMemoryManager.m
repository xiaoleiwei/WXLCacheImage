//
//  WXLMemoryManager.m
//  WXLImageView
//
//  Created by weixiaolei on 16/6/2.
//  Copyright © 2016年 魏晓磊. All rights reserved.
//

#import "WXLMemoryManager.h"

@implementation WXLMemoryManager

+ (WXLMemoryManager *)defaultMemoryManager {
    static WXLMemoryManager * cacheurl = nil;
    if (!cacheurl) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            cacheurl = [[WXLMemoryManager alloc] init];
        });
    }
    return cacheurl;
}

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] init];
    }
    return _dataDic;
}

- (NSMutableArray *)keyArray {
    if (!_keyArray) {
        _keyArray = [[NSMutableArray alloc] init];
    }
    return _keyArray;
}

- (void)saveMemoryWithData:(NSData *)data key:(NSString *)key {
    
    [self.keyArray addObject:key];

    //防止存入内存中的图片太多，造成崩溃
    if (self.dataDic.count > 5)
    {

        if (self.keyArray.count > 0)
        {
            [self.dataDic removeObjectForKey:_keyArray[0]];
        }
    }
    
    [self.dataDic setObject:data forKey:key];
}

- (NSMutableDictionary *)getMemoryData {
    return _dataDic;
}

@end
