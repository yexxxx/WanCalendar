//
//  YEXNetAPI.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/1.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXNetAPI.h"

typedef void(^handler)();
@interface YEXNetAPI ()<NSURLSessionDataDelegate>
{
    NSString *appKey;
    NSString *apiDomain;
}

@end

@implementation YEXNetAPI

- (instancetype)init
{
    self = [super init];
    if (self) {
        appKey = @"c92914c8c1e80eb952a5a9fdb7e8edfa";
#ifdef DEBUG
        apiDomain = @"http://japi.juhe.cn/calendar";
#else
        apiDomain = @"https://japi.juhe.cn/calendar";
#endif
    }
    return self;
}

+(instancetype)netAPI {
    return [[self alloc] init];
}

- (void)getDataWithType:(YEXNetType)type andDate:(NSDate *)date
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure {
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSOperationQueue *operationQ = [[NSOperationQueue alloc] init];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:operationQ];
    
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self DomainWithType:type]]];
    requestM.HTTPMethod = @"post";
    requestM.timeoutInterval = 300;
    requestM.HTTPBody = [[self postBodyWithType:type andDate:date] dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:requestM
               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           if (error) {
               if (failure) {
                   failure(error);
               }
           } else {
               id responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:&error];
               if (success) {
                   success(responseObject);
               }
           }
    }];
    [task resume];
}

- (NSString *)DomainWithType:(YEXNetType)type {
    NSString *appendStr;
    switch (type) {
        case YEXNetTypeDay:
            appendStr =  @"day";
            break;
        case YEXNetTypeMonth:
            appendStr = @"month";
            break;
        case YEXNetTypeYear:
            appendStr =  @"year";
            break;
        default:
            break;
    }
    return [apiDomain stringByAppendingPathComponent:appendStr];
}

- (NSString *)postBodyWithType:(YEXNetType)type andDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *parm1;
    NSString *parm2 = @"key=";
    switch (type) {
        case YEXNetTypeDay:
            parm1 = @"date=";
            dateFormatter.dateFormat = @"yyyy-MM-dd";
            break;
        case YEXNetTypeMonth:
            parm1 = @"year-month=";
            dateFormatter.dateFormat = @"yyyy-MM";
            break;
        case YEXNetTypeYear:
            parm1 = @"year=";
            dateFormatter.dateFormat = @"yyyy";
            break;
        default:
            break;
    }
    NSString *dateStr = [dateFormatter stringFromDate:date];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"-0" withString:@"-"];
    parm1 = [parm1 stringByAppendingString:dateStr];
    parm2 = [parm2 stringByAppendingString:appKey];
    return [parm1 stringByAppendingString:[@"&" stringByAppendingString:parm2]];
}
@end
