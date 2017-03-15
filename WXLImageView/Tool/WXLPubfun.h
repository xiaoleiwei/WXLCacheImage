//
//  WXLPubfun.h
//  WXLImageView
//
//  Created by weixiaolei on 16/6/2.
//  Copyright © 2016年 魏晓磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreGraphics/CGGeometry.h>

@interface WXLPubfun : NSObject

+ (WXLPubfun *)defaultPubfun;

/**
 *  md5
 *
 *  @param str
 *
 *  @return encryption str
 */
- (NSString *)md5:(NSString *)str;

/**
 *  get image size based on image url
 *
 *  @param imageURL image url
 *
 *  @return image size
 */
- (CGSize)getImageSizeWithURL:(id)imageURL;

@end
