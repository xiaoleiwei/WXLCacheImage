//
//  YUMINativeRequest.h
//  YUMINativeAd
//
//  Created by weixiaolei on 16/3/17.
//  Copyright © 2016年 zPlayCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    /**
     *  横幅
     */
    AdsYuMIAdTypeBanner=2,
    /**
     *  插屏
     */
    AdsYuMIAdTypeInter=3,
    /**
     *  视频
     */
    AdsYuMIAdTypeVideo=5,
    /**
     *  开屏
     */
    AdsYuMIAdTypeSplash=6,
    
    /**
     *  积分墙
     */
    AdsYuMIAdTypeWal=7,
    /**
     *  信息流
     */
    AdsYuMIAdTypeFlow=8
    
} AdsYuMIAdType;





typedef enum : NSUInteger {
    AdsYuMIDeviceTypeIphone=1,
    AdsYuMIDeviceTypeIpad=2,
} AdsYuMIDeviceType;

@class YUMINativeRequest;
@protocol YuMINativHttpRequestDelegate <NSObject>

@optional

- (void)request:(YUMINativeRequest *)request didReceiveResponse:(NSURLResponse *)response;

- (void)request:(YUMINativeRequest *)request didReceiveRawData:(NSData *)data;

- (void)request:(YUMINativeRequest *)request didFailWithError:(NSError *)error;

- (void)request:(YUMINativeRequest *)request didFinishLoadingWithResult:(id)result;

@end


typedef enum
{
    AdsYuMIHttpRequestPostDataTypeNone,
    AdsYuMIHttpRequestPostDataTypeNormal,			// for normal data post, such as "user=name&password=psd"
    AdsYuMIHttpRequestPostDataTypeMultipart,        // for uploading images and files.
    AdsYuMIHttpRequestPostDataTypeJSON,
    AdsYuMIHttpRequestPostDataTypeJSONDES3,
}AdsYuMIHttpRequestPostDataType;


@interface YUMINativeRequest : NSObject<NSURLConnectionDelegate>
{
    /**
     *  请求url
     */
    NSString                *_url;
    
    /**
     *  请求方法 GET POST
     */
    NSString                *_httpMethod;
    
    /**
     *   请求参数
     *   key:请求参数 value:请求值
     */
    NSDictionary            *_params;
    
    /*
     *   请求头参数
     *   key:请求参数 value:请求值
     */
    NSDictionary            *_httpHeaderFields;
    
    /**
     *  http 请求对象
     */
    NSURLConnection         *connection;
    
    /**
     *  响应数据
     */
    NSMutableData           *responseData;
    /**
     *  超时时间
     */
    //    NSInteger               timeout;
    
    
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *httpMethod;
@property (nonatomic, retain) NSDictionary *params;
@property (nonatomic, assign) NSInteger   timeout;
@property (nonatomic, retain) NSDictionary *httpHeaderFields;
@property (nonatomic, weak) id<YuMINativHttpRequestDelegate> delegate;
@property (nonatomic,assign) AdsYuMIHttpRequestPostDataType postDataType;

/**
 *  初始化http请求
 *
 *  @param url              http请求地址
 *  @param httpMethod       http请求方法可选值GET、POST
 *  @param params           请求参数
 *  @param httpHeaderFields http请求头参数
 *  @param timeout          超时时间
 *  @param delegate         http代理对象，用于请求后回调
 *
 *  @return HTTP请求对象
 */
+(YUMINativeRequest *) initWithURL:(NSString *)url
                         httpMethod:(NSString *)httpMethod
                             params:(NSDictionary *)params
                   httpHeaderFields:(NSDictionary *)httpHeaderFields
                   shortTimeOutType:(NSInteger)timeout
                       postDataType:(AdsYuMIHttpRequestPostDataType)postDataType
                           delegate:(id<YuMINativHttpRequestDelegate>)delegate;


/**
 *   发起异步请求请求
 */
- (void) asynchronousConnect;

/**
 *   发起同步请求
 *
 *  @return 请求数据
 */
- (NSData *) synchronousConnect;


/**
 *   取消当前请求
 */
- (void) disconnect;

@end
