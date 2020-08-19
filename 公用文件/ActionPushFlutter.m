//
//  ActionPushFlutter.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/12.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "ActionPushFlutter.h"
#import "AppDelegate.h"

@interface ActionPushFlutter()<FlutterStreamHandler>

@property (nonatomic,copy) FlutterEventSink callBack;

@end

@implementation ActionPushFlutter

+ (ActionPushFlutter *)sharePushFlutter{
    
    static dispatch_once_t pred;
    static ActionPushFlutter *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[ActionPushFlutter alloc]init];
    });
    return shared;
}

- (void)goFlutterPage:(NSString *)pageName withArguments:(NSDictionary *)arguments{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FlutterMethodChannel * methodChannel = [FlutterMethodChannel methodChannelWithName:@"RouteChannel" binaryMessenger:del.flutterViewCon];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:pageName forKey:@"pageName"];
    if (arguments) {
        [dic setObject:arguments forKey:@"params"];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:NULL];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    [methodChannel invokeMethod:pageName arguments:[NSDictionary dictionaryWithObject:jsonStr forKey:@"routeParams"]];
    //   监听 Flutter 回调回来的参数
    [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
            if ([call.method isEqualToString:@"popPage"]) {
                [del.flutterViewCon.navigationController popViewControllerAnimated:YES];
            }
    }];
    del.flutterViewCon.fd_prefersNavigationBarHidden = YES;
    del.flutterViewCon.hideKeyboardHandle = ^{
        if (self.callBack) {
            self.callBack(@"hideKeyboard");
        }
    };
    [del.navigationController pushViewController:del.flutterViewCon animated:YES];
}

- (void)initFlutterPage{
//    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    FlutterMethodChannel * methodChannel = [FlutterMethodChannel methodChannelWithName:@"RouteChannel" binaryMessenger:del.flutterViewCon];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:@"BlankPage" forKey:@"pageName"];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:NULL];
//    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    [methodChannel invokeMethod:@"" arguments:[NSDictionary dictionaryWithObject:jsonStr forKey:@"routeParams"]];
//    [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
//            if ([call.method isEqualToString:@"popPage"]) {
//                [del.flutterViewCon.navigationController popViewControllerAnimated:NO];
//            }
//    }];
//    del.flutterViewCon.fd_prefersNavigationBarHidden = YES;
}

- (void)initMessage{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FlutterEventChannel *evenChannal = [FlutterEventChannel eventChannelWithName:@"RouteChannel_Receiver" binaryMessenger:del.flutterViewCon];
    [evenChannal setStreamHandler:self];
}

#pragma mark - FlutterStreamHandler Protocol
- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events
{
    self.callBack = events;
    return nil;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments
{
    return nil;
}
@end
