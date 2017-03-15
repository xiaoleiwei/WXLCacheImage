//
//  WXLCustomImageView.h
//  WXLImageView
//
//  Created by 魏晓磊 on 16/5/31.
//  Copyright © 2016年 魏晓磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WXLCustomImageView : UIImageView

/**
 *  load image
 *  if memory and local file don't have the image, it will request image from the url
 */
- (WXLCustomImageView *)initWithFrame:(CGRect)frame URL:(NSString *)url defaultImg:(NSString *)img;

@end
