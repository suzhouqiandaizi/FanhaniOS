//
//  LoadConfig.h
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface LoadConfig : NSObject

+ (instancetype)shareStance;

///加载APP配置文件
- (void)loadConfigSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))fail;
- (NSDictionary *)getConfig;

///加载用户信息
- (void)loadUserInfo:(BOOL)removeLaunch withUserLoginRecord:(UserLoginRecord *)record;

- (NSArray *)getTaskHomeCategory;
- (NSArray *)getTaskClassify;
- (NSArray *)getTaskOptioins;

///加载关于我们内容
- (void)loadAboutSuccess:(void (^)(NSDictionary *))success;
- (NSDictionary *)getAbout;

///加载用户收益情况
- (void)loadAccountSuccess:(void (^)(NSDictionary *))success;
- (NSDictionary *)getAccount;
@end
