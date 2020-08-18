//
//  ServiceRequest.h
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceRequest : NSObject


+(instancetype)sharedService;

- (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error, NSInteger code))failure;

- (void)GETLogin:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *, NSInteger code))failure;

- (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error, NSInteger code))failure;

- (void)POSTCUSTOM:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSString *, NSInteger code))failure;

- (void)PUT:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error, NSInteger code))failure;

- (void)PUTJSON:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSString *, NSInteger code))failure;

- (void)DELETE:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error, NSInteger code))failure;

- (void)DELETEJSON:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSString *error, NSInteger code))failure;

- (void)POSTJSON:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error, NSInteger code))failure;

- (void)POSTJSON:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error, NSInteger code))failure update:(void (^)(float progress))update;

- (void)PUTJSON:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error, NSInteger code))failure update:(void (^)(float progress))update;

- (void)cancelDataTaskForKey:(NSString *)key;

@end
