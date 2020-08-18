//
//  LoadConfig.m
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import "LoadConfig.h"
#import "CacheData.h"
#import "AppDelegate.h"
#import "SharedViewControllers.h"
#import "MJExtension.h"

#define EXAMINE_HOME               @"EXAMINE_HOME"
#define TOOLS                      @"TOOLS"
#define PERSON                     @"PERSON"
#define BANKAJINDU                 @"BANKAJINDU"
#define APPCONFIG                  @"APPCONFIG"
#define ABOUTOUR                   @"ABOUTOUR"
#define TASKCONFIGRUATION          @"TASKCONFIGRUATION"


@implementation LoadConfig

+ (instancetype)shareStance
{
    static dispatch_once_t onceToken;
    static LoadConfig* shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[LoadConfig alloc] init];
    });
    return shared;
}

///加载用户信息
- (void)loadUserInfo:(BOOL)removeLaunch withUserLoginRecord:(UserLoginRecord *)record{
    __block BOOL hasLoadSuccess = YES;
    //开启多线程请求多个接口后继续下一步
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
           [[ServiceRequest sharedService] GET:@"/api/user/profile" parameters:nil success:^(id responseObject) {
               UserInfo *user = [UserInfo mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
               [DEFAULTS setObject:user.username forKey:USERID];
               [DEFAULTS synchronize];
               user.record = record;
               [UserManger setUser:user];
               dispatch_group_leave(group);
           } failure:^(NSString *error, NSInteger code) {
               hasLoadSuccess = NO;
               dispatch_group_leave(group);
           }];
           
       });
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[ServiceRequest sharedService] GET:@"/api/user/real" parameters:nil success:^(id responseObject) {
            dispatch_group_leave(group);
        } failure:^(NSString *error, NSInteger code) {
            dispatch_group_leave(group);
        }];
        
    });
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[ServiceRequest sharedService] GET:@"/api/security/getaccount" parameters:nil success:^(id responseObject) {
            UserAccount *user = [UserAccount mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            [DEFAULTS setObject:user.username forKey:USERID];
            [DEFAULTS synchronize];
            [UserManger setUserAccount:user];
            dispatch_group_leave(group);
        } failure:^(NSString *error, NSInteger code) {
            hasLoadSuccess = NO;
            dispatch_group_leave(group);
        }];
        
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [del.navigationController.topViewController.view endEditing:YES];
//        if (hasLoadSuccess) {
            HomeViewController *viewCon = [SharedViewControllers homeViewCon];
            [del.navigationController pushViewController:viewCon animated:!removeLaunch];
            if (removeLaunch) {
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"remove_launch" object:nil]];
            }
            [[SharedViewControllers personViewCon] refreshView];
//        }else{
//            [del.navigationController.topViewController showHUDAlert:@"获取用户信息失败"];
//        }
        //登录后cookie单独保存
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *cookieArr = [cookieJar cookies];
        NSHTTPCookie *cookie;
        NSMutableArray *mutArr = [NSMutableArray array];
        for (id c in cookieArr){
            if ([c isKindOfClass:[NSHTTPCookie class]]){
                cookie=(NSHTTPCookie *)c;
                [mutArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:cookie.name, @"name",cookie.value, @"value", nil]];
            }
        }
         if ([NSJSONSerialization isValidJSONObject:mutArr]) {
             NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutArr options:0 error:NULL];
             NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
             [DEFAULTS setObject:jsonStr forKey:@"LOGINCOOKIE"];
             [DEFAULTS synchronize];
         }
    });
}

- (void)exitApp{
    exit(0);
}

@end
