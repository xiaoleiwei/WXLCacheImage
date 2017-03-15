//
//  YUMINativeRequest.m
//  YUMINativeAd
//
//  Created by weixiaolei on 16/3/17.
//  Copyright © 2016年 zPlayCompany. All rights reserved.
//

#import "YUMINativeRequest.h"


@interface NSString (WBRequest)

- (NSString *)URLEncodedString;
- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;
@end

@implementation NSString (WBRequest)

- (NSString *)URLEncodedString
{
    return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}

- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[self mutableCopy], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding));
    
}

@end


@implementation YUMINativeRequest

@synthesize timeout;
@synthesize postDataType =_postDataType;

+(YUMINativeRequest *) initWithURL:(NSString *)url
                         httpMethod:(NSString *)httpMethod
                             params:(NSDictionary *)params
                   httpHeaderFields:(NSDictionary *)httpHeaderFields
                   shortTimeOutType:(NSInteger)timeout
                       postDataType:(AdsYuMIHttpRequestPostDataType)postDataTypeParams
                           delegate:(id<YuMINativHttpRequestDelegate>)delegate{
    
    YUMINativeRequest *request = [[YUMINativeRequest alloc] init];
    request.url = url;
    request.httpMethod = httpMethod;
    request.params = params;
    request.timeout=timeout;
    request.httpHeaderFields = httpHeaderFields;
    request.delegate = delegate;
    request.postDataType =postDataTypeParams;
    return request;
}



- (void) asynchronousConnect{
    //TOOD:判断网络是否异常
    NSString *urlString = [YUMINativeRequest serializeURL:_url params:_params httpMethod:_httpMethod];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:timeout];
    [request setHTTPMethod:_httpMethod];
    
    
    if ([[_httpMethod uppercaseString] isEqualToString:@"POST"])
    {
        
        [request setHTTPBody:[self postBody]];
    }
    
    
    for (NSString *key in [_httpHeaderFields keyEnumerator])
    {
        [request setValue:[_httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
    }

    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}


+ (NSString *) serializeURL:(NSString *)baseURL
                     params:(NSDictionary *)params
                 httpMethod:(NSString *)httpMethod{
    
    
    if (![[httpMethod uppercaseString] isEqualToString:@"GET"])
    {
        return baseURL;
    }
    
    NSURL *parsedURL = [NSURL URLWithString:baseURL];
    if (params!=nil) {
        NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
        NSString *query;
        if ([[httpMethod uppercaseString] isEqualToString:@"GET"]) {
            query = [YUMINativeRequest stringFromDictionaryWithApi:params];
        }else {
            query = [YUMINativeRequest stringFromDictionary:params];
        }
        return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
    }
    return baseURL;
}

//获取验证标签
+ (NSString *)stringFromDictionary:(NSDictionary *)dict
{
    NSArray *sortArray=[dict allKeys];
    
    NSArray *array =  [sortArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *pairs = [NSMutableArray array];
    for (int i =0; i<array.count; i++) {
        [pairs addObject:[NSString stringWithFormat:@"%@=%@",[array objectAtIndex:i], [[dict objectForKey:[array objectAtIndex:i]] URLEncodedString]]];
    }
    return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)stringFromDictionaryWithApi:(NSDictionary *)dict
{
    NSArray *sortArray=[dict allKeys];
    
    NSArray *array =  [sortArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *pairs = [NSMutableArray array];
    for (int i =0; i<array.count; i++) {
        NSString * key =[array objectAtIndex:i];
        NSString * value =[dict objectForKey:[array objectAtIndex:i]];
        if ([[dict objectForKey:[array objectAtIndex:i]] isKindOfClass:[NSString class]]) {
            value= [value URLEncodedString];
        }
        [pairs addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
    }
    
    
    if([[pairs objectAtIndex:0] rangeOfString:@"MOGO_API_AUTHKEY"].location !=NSNotFound)
    {
        NSString * mogoApi_authkey= [pairs objectAtIndex:0];
        [pairs removeObjectAtIndex:0];
        [pairs addObject:mogoApi_authkey];
    }
    
    
    if([[pairs objectAtIndex:0] rangeOfString:@"MOGO_API_SIGNATURE"].location !=NSNotFound)
    {
        NSString * mogoApi_signature= [pairs objectAtIndex:0];
        [pairs removeObjectAtIndex:0];
        [pairs addObject:mogoApi_signature];
    }
    
    
    return [pairs componentsJoinedByString:@"&"];
}

- (NSData *) synchronousConnect{
    //TOOD:判断网络是否异常
    
    NSString *urlString = [YUMINativeRequest serializeURL:_url params:_params httpMethod:_httpMethod];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:timeout];
    [request setHTTPMethod:_httpMethod];
    
    
    if ([[_httpMethod uppercaseString] isEqualToString:@"POST"])
    {
        
        [request setHTTPBody:[self postBody]];
    }
    
    
    
    for (NSString *key in [_httpHeaderFields keyEnumerator])
    {
        [request setValue:[_httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
    }
    
    
    NSURLResponse *response = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    return data;
}




#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    responseData = [[NSMutableData alloc] init];
    
    if ([self.delegate respondsToSelector:@selector(request:didReceiveResponse:)])
    {
        [self.delegate request:self didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    
    if ([self.delegate respondsToSelector:@selector(request:didReceiveRawData:)]) {
        [self.delegate request:self didReceiveRawData:data];
    }
    
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    if ([self.delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)]) {
        [self.delegate request:self didFinishLoadingWithResult:responseData];
    }
    [connection cancel];
    connection = nil;
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        [self.delegate request:self didFailWithError:error];
    }
    [self disconnect];
}


#pragma AdsYuMIHttpRequest  Private Method

+ (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString
{
    [body appendData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
}



- (NSMutableData *)postBody
{
    NSMutableData *body = [NSMutableData data];
    
    if (_postDataType == AdsYuMIHttpRequestPostDataTypeNormal)
    {
        [YUMINativeRequest appendUTF8Body:body dataString:[YUMINativeRequest stringFromDictionary:_params]];
    }
   else if (_postDataType == AdsYuMIHttpRequestPostDataTypeJSON){
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_params options:NSJSONWritingPrettyPrinted error:&parseError];
        if (parseError==nil) {
            [body appendData:jsonData];
        }else{
        }
    }else if (_postDataType == AdsYuMIHttpRequestPostDataTypeJSONDES3){

        [YUMINativeRequest appendUTF8Body:body dataString:[YUMINativeRequest stringFromDictionary:_params]];
    }
    
    return body;
}



- (void) disconnect{
    @try {
        responseData = nil;
        [connection cancel];connection = nil;
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }
}

- (void)dealloc
{
    self.delegate=nil;
}


@end
