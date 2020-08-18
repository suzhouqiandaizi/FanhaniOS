//
//  UserManger.h
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo;
@class UserAccount;
@class UserLogin;

@interface UserManger : NSObject

+ (UserInfo *)getUserWithId:(NSString*)userId;
+ (void)setUser:(UserInfo*)user;
+ (void)deleteUserLoginRecord:(NSString *)username;
+ (UserInfo *)currentLoggedInUser;
+ (void)logoutCurrentUser;
+ (BOOL)hasUserLogged;

+ (UserAccount *)getUserAccountWithId:(NSString*)userId;
+ (void)setUserAccount:(UserAccount*)user;

+ (void)setUserLoginRecord:(UserLoginRecord*)user;
+ (NSDictionary *)getUserLoginedRecord;

@end
