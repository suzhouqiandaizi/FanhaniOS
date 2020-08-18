//
//  AppDelegate.m
//  fanhan_ios
//
//  Created by WangZhenyu on 2020/7/22.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#include <MobPush/MobPush.h>
#include <MOBFoundation/MOBFoundation.h>
#include <MOBFoundation/MobSDK+Privacy.h>
#import "AFNetworkReachabilityManager.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import "SharedViewControllers.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <UMCommon/UMCommon.h>

@interface AppDelegate ()<FlutterStreamHandler, WXApiDelegate>{
    NSString *messageToFlutterStr;
    UIView *launchView;
    BOOL firstStart; //启动是否进入界面
}
@property (nonatomic, strong) MPushMessage *message;
@property (nonatomic,copy) FlutterEventSink callBack;

@end

@implementation AppDelegate{
    FlutterPluginAppLifeCycleDelegate *_lifeCycleDelegate;
}


- (instancetype)init {
    if (self = [super init]) {
        _lifeCycleDelegate = [[FlutterPluginAppLifeCycleDelegate alloc] init];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSString *dbPath = [docuPath stringByAppendingPathComponent:@"fanhandata.db"];
//    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
//    [database open];
//    if (![database open]) {
//        NSLog(@"db open fail");
//    }
//    FMResultSet* resultSet = [database executeQuery: @"select * from loginInfo"];
//    //读取table表中所有字段
//    NSMutableDictionary *dict = resultSet.columnNameToIndexMap;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeLaunch) name:@"remove_launch" object:nil];
    
    //注册sharesdk分享
    [self registerShareSDK];
    
    //注册友盟
    [UMConfigure initWithAppkey:@"5e9ff5040cafb2074c000158" channel:@"App Store"];
    
    if([WXApi registerApp:WXAppId universalLink:UNIVERSALLINK]){
        NSLog(@"初始化成功");
    }
   
    [self initMobPush];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.navigationController = [[CustomNavigationCoutroller alloc] init];
    self.window.rootViewController = self.navigationController;
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    launchView = viewController.view;
    launchView.frame = self.window.bounds;
    [self.navigationController.view addSubview:launchView];

    //启动监听网络
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT_DEVICE - 25 - IS_iPhoneX_Bottom, SCREEN_WIDTH_DEVICE, 21)];
    infoLabel.textAlignment = 1;
    infoLabel.text = @"";
    infoLabel.font = [UIFont systemFontOfSize:13.0f];
    infoLabel.textColor = TextColor;
    [launchView addSubview:infoLabel];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];  //开始监听
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (!self->firstStart) {
            if (status == AFNetworkReachabilityStatusNotReachable)
            {
                NSLog(@"无网络");
                infoLabel.text = @"请检查您的网络情况后重新打开APP";
            }else if (status == AFNetworkReachabilityStatusUnknown){
                NSLog(@"未知网络");
                infoLabel.text = @"请检查您的网络情况后重新打开APP";
            }else if ((status == AFNetworkReachabilityStatusReachableViaWWAN)||(status == AFNetworkReachabilityStatusReachableViaWiFi)){
                NSLog(@"有网络");
                [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
                self->firstStart = YES;
                
                self.flutterEngine = [[FlutterEngine alloc] initWithName:@"fanhan.flutter" project:nil];
                [self.flutterEngine runWithEntrypoint:nil];
                [GeneratedPluginRegistrant registerWithRegistry:self.flutterEngine];
                self.flutterViewCon = [[CustomFlutterViewController alloc] initWithEngine:self.flutterEngine nibName:nil bundle:nil];
                [self setFlutterChannel:[self.flutterViewCon registrarForPlugin:@"MobpushPlugin"]];
                [[ActionPushFlutter sharePushFlutter] initMessage];
//                [self performSelector:@selector(removeLaunch) withObject:self afterDelay:6.0];
                
                LoginViewController *viewCon = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                [self.navigationController pushViewController:viewCon animated:NO];
//                [self removeLaunch];
            }
        }
    }];
    
    [self.window makeKeyAndVisible];
    return [_lifeCycleDelegate application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)registerShareSDK{
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        [platformsRegister setupQQWithAppId:@"1107947901" appkey:@"tO18jmF9ZWzStVKh" enableUniversalLink:YES universalLink:@"https://www.fanhantech.com/"];

        [platformsRegister setupWeChatWithAppId:WXAppId appSecret:WXAppSecret universalLink:UNIVERSALLINK];
    }];
}


#pragma mark Universal Link
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

//注意：微信和QQ回调方法用的是同一个，这里注意判断resp类型来区别分享来源
- (void)onResp:(id)resp{

    if([resp isKindOfClass:[SendMessageToWXResp class]]){//微信回调
        
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;

        if(response.errCode == WXSuccess){
            //目前分享回调只会走成功
            NSLog(@"分享完成");
        }
    }else if([resp isKindOfClass:[SendAuthResp class]]){//判断是否为授权登录类

        SendAuthResp *req = (SendAuthResp *)resp;
        if([req.state isEqualToString:@"wx_oauth_authorization_state"]){//微信授权成功
            NSNotification *notification = [NSNotification notificationWithName:@"wx_pay" object:req];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }else if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]){
        
        WXLaunchMiniProgramResp *req = (WXLaunchMiniProgramResp *)resp;
        NSLog(@"%@", req.extMsg);// 对应JsApi navigateBackApplication中的extraData字段数据
    }
}

// 收到通知回调
- (void)didReceiveMessage:(NSNotification *)notification
{
    
    MPushMessage *message = notification.object;
    // 推送相关参数获取示例请在各场景回调中对参数进行处理
    NSString *body = message.notification.body;
    NSString *title = message.notification.title;
    NSString *subtitle = message.notification.subTitle;
    NSInteger badge = message.notification.badge;
    NSString *sound = message.notification.sound;
    NSLog(@"收到通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge:%ld,\nsound:%@,\n}",body, title, subtitle, (long)badge, sound);
    switch (message.messageType)
    {
        case MPushMessageTypeCustom:
        {// 自定义消息回调
            NSLog(@"%@", body);
        }
            break;
        case MPushMessageTypeAPNs:
        {// APNs回调
            if (self.callBack)
            {
                NSDictionary *userInfo = message.notification.userInfo;
                NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
                [resultDict setObject:[userInfo objectForKey:@"target"] forKey:@"target"];
                [resultDict setObject:[userInfo objectForKey:@"type"] forKey:@"type"];
                // 回调结果
                NSString *resultDictStr = [MOBFJson jsonStringFromObject:resultDict];
                self.callBack(resultDictStr);
            }
            
        }
            break;
        case MPushMessageTypeLocal:
        {// 本地通知回调
            NSString *body = message.notification.body;
            NSString *title = message.notification.title;
            NSString *subtitle = message.notification.subTitle;
            NSInteger badge = message.notification.badge;
            NSString *sound = message.notification.sound;
            NSLog(@"收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge:%ld,\nsound:%@,\n}",body, title, subtitle, (long)badge, sound);
        }
            break;
        case MPushMessageTypeClicked:
        {// 点击通知回调
            NSDictionary *userInfo = message.notification.userInfo;
            NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
            [resultDict setObject:[userInfo objectForKey:@"target"] forKey:@"target"];
            [resultDict setObject:[userInfo objectForKey:@"type"] forKey:@"type"];
            // 回调结果
            messageToFlutterStr = [MOBFJson jsonStringFromObject:resultDict];
            if (self.callBack)
            {
                self.callBack(messageToFlutterStr);
                messageToFlutterStr = nil;
            }
        }
        default:
            break;
    }
    
}

- (void)applicationDidEnterBackground:(UIApplication*)application {
//    [_lifeCycleDelegate applicationDidEnterBackground:application];
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication*)application {
//    [_lifeCycleDelegate applicationWillEnterForeground:application];
     [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillResignActive:(UIApplication*)application {
//    [_lifeCycleDelegate applicationWillResignActive:application];
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication*)application {
//    [_lifeCycleDelegate applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication*)application {
//    [_lifeCycleDelegate applicationWillTerminate:application];
}
    
- (void)application:(UIApplication*)application didRegisterUserNotificationSettings:(UIUserNotificationSettings*)notificationSettings {
    [_lifeCycleDelegate application:application didRegisterUserNotificationSettings:notificationSettings];
}
    
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    [_lifeCycleDelegate application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
    
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [_lifeCycleDelegate application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}
    
- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id>*)options {
    [WXApi handleOpenURL:url delegate:self];
    return [_lifeCycleDelegate application:application openURL:url options:options];
}
    
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url {
    [WXApi handleOpenURL:url delegate:self];
    return [_lifeCycleDelegate application:application handleOpenURL:url];
}
    
- (BOOL)application:(UIApplication*)application
            openURL:(NSURL*)url
  sourceApplication:(NSString*)sourceApplication
         annotation:(id)annotation {
    [WXApi handleOpenURL:url delegate:self];
    return [_lifeCycleDelegate application:application
                                   openURL:url
                         sourceApplication:sourceApplication
                                annotation:annotation];
}
    
- (void)application:(UIApplication*)application
performActionForShortcutItem:(UIApplicationShortcutItem*)shortcutItem
  completionHandler:(void (^)(BOOL succeeded))completionHandler NS_AVAILABLE_IOS(9_0) {
    [_lifeCycleDelegate application:application
       performActionForShortcutItem:shortcutItem
                  completionHandler:completionHandler];
}
    
- (void)application:(UIApplication*)application
handleEventsForBackgroundURLSession:(nonnull NSString*)identifier
  completionHandler:(nonnull void (^)(void))completionHandler {
    [_lifeCycleDelegate application:application
handleEventsForBackgroundURLSession:identifier
                  completionHandler:completionHandler];
}
    
- (void)application:(UIApplication*)application
performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [_lifeCycleDelegate application:application performFetchWithCompletionHandler:completionHandler];
}
    
- (void)addApplicationLifeCycleDelegate:(NSObject<FlutterPlugin>*)delegate {
    [_lifeCycleDelegate addDelegate:delegate];
}

#pragma mark - Flutter
    // Returns the key window's rootViewController, if it's a FlutterViewController.
    // Otherwise, returns nil.
- (FlutterViewController*)rootFlutterViewController {
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([viewController isKindOfClass:[FlutterViewController class]]) {
        return (FlutterViewController*)viewController;
    }
    return nil;
}

- (void)setFlutterChannel:(NSObject<FlutterPluginRegistrar>*)registry{
    FlutterEventChannel *evenChannal = [FlutterEventChannel eventChannelWithName:@"mobpush_receiver" binaryMessenger:[registry messenger]];
    [evenChannal setStreamHandler:self];
    
    FlutterMethodChannel *messageChannel = [FlutterMethodChannel methodChannelWithName:@"FanhanTech/NativeBridgeFlutter" binaryMessenger:[registry messenger]];
    [messageChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
            // call.method 获取 flutter 给回到的方法名，要匹配到 channelName 对应的多个 发送方法名，一般需要判断区分
            // call.arguments 获取到 flutter 给到的参数，（比如跳转到另一个页面所需要参数）
            // result 是给flutter的回调 , 只能回调一次
            NSLog(@"flutter 给到我：\nmethod=%@ \narguments = %@",call.method,call.arguments);
            if ([call.method isEqualToString:@"closeLaunch"]) {
                [self removeLaunch];
            }else if ([call.method isEqualToString:@"exitApp"]){
                exit(0);
            }else if ([call.method isEqualToString:@"loadCookies"]){
                //给flutter发送cookie
                if (result) {
                    result([DEFAULTS objectForKey:@"LOGINCOOKIE"]);
                }
            }else if ([call.method isEqualToString:@"popPage"]) {
                [self.flutterViewCon.navigationController popViewControllerAnimated:YES];
            }else if ([call.method isEqualToString:@"setPopGestureEnabled"]) {
                self.flutterViewCon.fd_interactivePopDisabled = ![call.arguments boolValue];
            }else if ([call.method isEqualToString:@"deleteAccount"]) {
                [UserManger logoutCurrentUser];
            }else if ([call.method isEqualToString:@"goLogin"]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
}

- (void)removeLaunch{
    [[ActionPushFlutter sharePushFlutter] initFlutterPage];
    if (launchView) {
        self->launchView.alpha = 0.0f;
        [self->launchView removeFromSuperview];
        self->launchView = nil;
    }
}

#pragma mark - FlutterStreamHandler Protocol
- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events
{
    self.callBack = events;
    if (messageToFlutterStr) {
        self.callBack(messageToFlutterStr);
        messageToFlutterStr = nil;
    }
    return nil;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments
{
    return nil;
}

#pragma mark ---初始化MobPush
- (void)initMobPush{
    #ifdef DEBUG
        [MobPush setAPNsForProduction:NO];
    #else
        [MobPush setAPNsForProduction:YES];
    #endif

    //MobPush推送设置（获得角标、声音、弹框提醒权限）
    MPushNotificationConfiguration *configuration = [[MPushNotificationConfiguration alloc] init];
    configuration.types = MPushAuthorizationOptionsBadge | MPushAuthorizationOptionsSound | MPushAuthorizationOptionsAlert;
    [MobPush setupNotification:configuration];
    [MobPush getRegistrationID:^(NSString *registrationID, NSError *error) {
        NSLog(@"++++++++%@", registrationID);
    }];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"NotAPNsShowForeground"])
    {
        // 设置后，应用在前台时不展示通知横幅、角标、声音。（iOS 10 以后有效，iOS 10 以前本来就不展示）
        [MobPush setAPNsShowForegroundType:MPushAuthorizationOptionsNone];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessage:) name:MobPushDidReceiveMessageNotification object:nil];
    [MobSDK uploadPrivacyPermissionStatus:YES onResult:^(BOOL success) {
        NSLog(@"-------------->上传结果：%d",success);
    }];
}

@end
