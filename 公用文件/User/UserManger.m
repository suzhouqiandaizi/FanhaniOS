//
//  UserManger.m
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import "UserManger.h"
#import "UserInfo.h"
#import "UserLoginRecord.h"
//#import "JPUSHService.h"
#import "LoadConfig.h"

static NSMutableDictionary *usersById = nil;
static NSMutableDictionary *usersAccountById = nil;
static NSMutableDictionary *loginRecordDic = nil;

@implementation UserManger

+ (void)initDictionary{
    if (usersById == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERINFO"];
        if (data != nil) {
            usersById = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        if (usersById == nil) {
            usersById = [NSMutableDictionary dictionary];
        }
    }
}

+ (void)initAccountDictionary{
    if (usersAccountById == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERINFOACCOUNT"];
        if (data != nil) {
            usersAccountById = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        if (usersAccountById == nil) {
            usersAccountById = [NSMutableDictionary dictionary];
        }
    }
}

+ (void)initLoginRecordDictionary{
    if (loginRecordDic == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGINRECORD"];
        if (data != nil) {
            loginRecordDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        if (loginRecordDic == nil) {
            loginRecordDic = [NSMutableDictionary dictionary];
        }
    }
}

+ (UserInfo*)getUserWithId:(NSString*)userId{
    [UserManger initDictionary];
    return [usersById objectForKey:userId];
}

+ (void)setUser:(UserInfo*)user{
    if (user.username == nil) {
        return;
    }
    [UserManger initDictionary];
    [usersById setObject:user forKey:user.username];
    [UserManger saveData];
}

+ (UserAccount *)getUserAccountWithId:(NSString*)userId{
    [UserManger initAccountDictionary];
    return [usersAccountById objectForKey:userId];
}

+ (void)setUserAccount:(UserAccount*)user{
    if (user.username == nil) {
        return;
    }
    [UserManger initAccountDictionary];
    [usersAccountById setObject:user forKey:user.username];
    [UserManger saveAccountData];
}

+ (NSDictionary*)getUserLoginedRecord{
    [UserManger initLoginRecordDictionary];
    return loginRecordDic;
}

///保存用户登录信息
+ (void)setUserLoginRecord:(UserLoginRecord*)user{
    [UserManger initLoginRecordDictionary];
    [loginRecordDic setObject:user forKey:user.username];
    [UserManger saveLoginRecordData];
}

+ (void)deleteUserLoginRecord:(NSString *)username{
    [UserManger initLoginRecordDictionary];
    [loginRecordDic removeObjectForKey:username];
    [UserManger saveLoginRecordData];
}

+ (void)saveData{
    [UserManger initDictionary];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:usersById];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"USERINFO"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveAccountData{
    [UserManger initAccountDictionary];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:usersAccountById];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"USERINFOACCOUNT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveLoginRecordData{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:loginRecordDic];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"LOGINRECORD"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (UserInfo *)currentLoggedInUser{
    if (((NSString *)[DEFAULTS objectForKey:USERID]).length > 0) {
        return [UserManger getUserWithId:[DEFAULTS objectForKey:USERID]];
    }else{
        return nil;
    }
}

+ (UserAccount *)currentLoggedInUserAccount{
    if (((NSString *)[DEFAULTS objectForKey:USERID]).length > 0) {
        return [UserManger getUserAccountWithId:[DEFAULTS objectForKey:USERID]];
    }else{
        return nil;
    }
}

+ (BOOL)hasUserLogged
{
    if (((NSString *)[DEFAULTS objectForKey:USERID]).length > 0) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)logoutCurrentUser
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieStorage cookies]];
    for (id obj in _tmpArray) {
        [cookieStorage deleteCookie:obj];
    }
    [DEFAULTS setObject:@"" forKey:USERID];
    [DEFAULTS synchronize];
//    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
//    } seq:0];
}

@end
