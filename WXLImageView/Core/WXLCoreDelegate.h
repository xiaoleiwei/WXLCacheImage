//
//  WXLCoreDelegate.h
//  WXLImageView
//
//  Created by weixiaolei on 16/6/2.
//  Copyright © 2016年 魏晓磊. All rights reserved.
//

@protocol WXLCoreDelegate <NSObject>

/**
 *  image data load finished
 *
 *  @param data loaded data
 */
- (void)imageloadFinished:(NSMutableData *)data;
/**
 *  image data load failed
 *
 *  @param error failed log
 */
- (void)imageloadDidFailWithError:(NSError *)error;

/**
 *  image data load percent
 *
 *  @param percent 
 */
- (void)imageloadPercent:(double)percent;


@end