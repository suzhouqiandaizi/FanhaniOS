//
//  UserLoginRecord.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/5.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserLoginRecord : NSObject
///用户名
@property (nonatomic, copy) NSString *username;
///用户密码
@property (nonatomic, copy) NSString *password;
///微信oauth
@property (nonatomic, copy) NSString *wxOauth;
///微信openid
@property (nonatomic, copy) NSString *wxOpenId;
///微信token
@property (nonatomic, copy) NSString *wxToken;
///登录方式 1用户名登录 2微信登录 3快捷登录
@property (nonatomic, assign) NSInteger loginType;
@end

NS_ASSUME_NONNULL_END
