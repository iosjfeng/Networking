//
//  NetworkManager.h
//  JFNetworking
//
//  Created by JiFeng on 2017/4/5.
//  Copyright © 2017年 Terminator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetWorkManager : NSObject

+ (void)setupPublicParameter;
+ (void)updateLongitude:(double)longitude latitude:(double)latitude;
+ (void)updateUserInfo;

+ (nullable AFHTTPSessionManager *)GET:(nonnull NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *_Nullable downloadProgress)) downloadProgress
                               success:(nullable void (^)(id _Nullable responseObject))success
                               failure:(nullable void (^)(NSError *_Nonnull error))failure;

+ (nullable AFHTTPSessionManager *)GET:(nonnull NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(id _Nullable responseObject))success
                               failure:(nullable void (^)(NSError *_Nonnull error))failure;

+ (nullable AFHTTPSessionManager *)POST:(nonnull NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> _Nullable formData))block
                               progress:(nullable void (^)(NSProgress *_Nonnull uploadProgress)) uploadProgress
                                success:(nullable void (^)(id _Nullable responseObject))success
                                failure:(nullable void (^)( NSError *_Nonnull error))failure;

+ (nullable AFHTTPSessionManager *)POST:(nonnull NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(id _Nullable responseObject))success
                                failure:(nullable void (^)( NSError *_Nonnull error))failure;


@end
