//
//  WXLCustomImageView.m
//  WXLImageView
//
//  Created by 魏晓磊 on 16/5/31.
//  Copyright © 2016年 魏晓磊. All rights reserved.
//

#import "WXLCustomImageView.h"
#import "WXLCore.h"
#import "WXLConstants.h"

@interface WXLCustomImageView()<WXLCoreDelegate> {
    
    NSString *request_url;
    NSString *deaultImageName;
    WXLCore *core;
    BOOL isDownload;
    UIView *bgview;
    UIView *progressView;
    UIImage *dataImage;
}

@end


@implementation WXLCustomImageView

- (WXLCustomImageView *)initWithFrame:(CGRect)frame URL:(NSString *)url defaultImg:(NSString *)img {
    
    self =  [super initWithFrame:frame];
    
    core =[[WXLCore alloc]init];
    [core setURL:url coreDelegate:self];
    [core cacheCore];
    
    request_url =url;
    deaultImageName =img;
        
    if (!isDownload) {
        
        //add progress
        bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ImgDefaultWidth, 4)];
        bgview.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgview];
        
        progressView = [[UIView alloc] initWithFrame:CGRectMake(-ImgDefaultWidth, 0, ImgDefaultWidth, 4)];
        progressView.backgroundColor = [UIColor greenColor];
        [self addSubview:progressView];
        
        self.image = [UIImage imageNamed:deaultImageName];
    }
 
    return self;
}

#pragma mark - WXLCoreDelegate
/**
 *  image data load finished
 *
 *  @param data loaded data
 */
- (void)imageloadFinished:(NSMutableData *)data {
    if ([NSThread isMainThread]) {
        isDownload = YES;
        
        self.image = [UIImage imageWithData:data];
    }
   
}
/**
 *  image data load failed
 *
 *  @param error failed log
 */
- (void)imageloadDidFailWithError:(NSError *)error {
    isDownload = NO;
    if ([NSThread isMainThread]) {
        self.image = [UIImage imageNamed:deaultImageName];
    }
}

/**
 *  image data load percent
 *
 *  @param percent
 */
- (void)imageloadPercent:(double)percent {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = progressView.frame;
        frame.origin.x = -ImgDefaultWidth+(percent*ImgDefaultWidth);
        progressView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        if (progressView.frame.origin.x == 0) {
            [bgview removeFromSuperview];
            [progressView removeFromSuperview];
        }
        
    }];
    
}



@end








