//
//  NetworkManager.m
//  JFNetworking
//
//  Created by JiFeng on 2017/4/5.
//  Copyright © 2017年 Terminator. All rights reserved.
//

#import "NetworkManager.h"

#pragma mark -  系统版本
#define SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/**
 *  公共参数
 *
 *  appVersion 客户端版本
 *  market 投放市场
 *
 */
static NSMutableDictionary *publicParameter = nil;

static NSTimeInterval const TimeoutInterval = 15;


@implementation NetWorkManager

+ (void)setupPublicParameter {
    if (!publicParameter) {
        
        
        NSString *userToken = @"";
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        double latitude = [userDefault doubleForKey:@"latitude"];
        double longitude = [userDefault doubleForKey:@"longitude"];
        
        publicParameter = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           [UIDevice currentDevice].model, @"client",
                           SYSTEM_VERSION, @"deviceVersion",
                           APP_VERSION, @"appVersion",
                           @"AppStore", @"channel",
                           @"JFNetworking", @"appName",
                           [[NSLocale preferredLanguages] firstObject], @"lan",
                           @(longitude), @"lon",
                           @(latitude), @"lat",
                           userToken, @"userToken",
                           nil];
    }
    [self checkNetworkStatus];
}

+ (void)checkNetworkStatus {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSString *netWorkStatus = (status == AFNetworkReachabilityStatusReachableViaWiFi ? @"WiFi" : @"WWAN");
        [publicParameter setObject:netWorkStatus forKey:@"network"];
    }];
}

+ (void)updateLongitude:(double)longitude latitude:(double)latitude {
    [publicParameter setObject:@(longitude) forKey:@"lon"];
    [publicParameter setObject:@(latitude) forKey:@"lat"];
}

+ (void)updateUserInfo {
    NSString *userToken = @"";
    [publicParameter setObject:userToken forKey:@"userToken"];
}

+ (nullable AFHTTPSessionManager *)GET:(nonnull NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                               success:(nullable void (^)(id _Nullable responseObject))success
                               failure:(nullable void (^)(NSError *_Nonnull error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:publicParameter];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        [dict addEntriesFromDictionary:parameters];
    }
    
    [manager GET:URLString parameters:dict progress:^(NSProgress * _Nonnull progress) {
        if (downloadProgress) {
            downloadProgress(progress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    return manager;
}

+ (nullable AFHTTPSessionManager *)GET:(nonnull NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(id _Nullable responseObject))success
                               failure:(nullable void (^)(NSError *_Nonnull error))failure {
    
    return [self GET:URLString parameters:parameters progress:nil success:success failure:failure];
}

+ (nullable AFHTTPSessionManager *)POST:(nonnull NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> _Nullable formData))block
                               progress:(nullable void (^)(NSProgress *_Nonnull uploadProgress)) uploadProgress
                                success:(nullable void (^)(id _Nullable responseObject))success
                                failure:(nullable void (^)( NSError * _Nonnull error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:publicParameter];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        [dict addEntriesFromDictionary:parameters];
    }
    
    [manager POST:URLString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block) {
            block(formData);
        }
    } progress:^(NSProgress * _Nonnull progress) {
        if (uploadProgress) {
            uploadProgress(progress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }
    }];
    return manager;
}

+ (nullable AFHTTPSessionManager *)POST:(nonnull NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(id _Nullable responseObject))success
                                failure:(nullable void (^)( NSError * _Nonnull error))failure {
    
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:nil progress:nil success:success failure:failure];
}

@end
