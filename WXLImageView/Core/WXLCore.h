//
//  WXLCore.h
//  WXLImageView
//
//  Created by 魏晓磊 on 16/5/31.
//  Copyright © 2016年 魏晓磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXLCoreDelegate.h"

@interface WXLCore : NSObject

@property (nonatomic, assign) id<WXLCoreDelegate>delegate;

@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * key;
@property (nonatomic, strong) NSMutableData * savedData;

- (void)setURL:(NSString *)url coreDelegate:(id<WXLCoreDelegate>)delegate;

- (void)cacheCore;

@end
