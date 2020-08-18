//
//  ServiceRequest.m
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import "ServiceRequest.h"
#import "AFNetworking.h"
#import "XNBase64.h"
#import "AppDelegate.h"
#import "CustomIOSAlertView.h"
#import "CustomInfoAlertView.h"
#import "GlobalFunction.h"

#define TIMEOUT 20

static NSMutableDictionary *taskMutDic = nil;

@interface ServiceRequest()

/**
 *  ssl证书
 */
@property (nonatomic, strong) NSData *certData;

@end

@implementation ServiceRequest

+(instancetype)sharedService
{
    static dispatch_once_t once;
    static ServiceRequest* shared = nil;
    dispatch_once(&once, ^{
        if ( shared == nil )
        {
            shared = [[ServiceRequest alloc] init];
            taskMutDic = [NSMutableDictionary dictionary];
        }
    });
    
    return shared;
}

+ (AFHTTPSessionManager *)sharedHTTPSession{
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = TIMEOUT;
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        manager.securityPolicy = [self customSecurityPolicy];
    });
    return manager;
}

+ (AFURLSessionManager *)sharedURLSession{
    static dispatch_once_t onceToken2;
    static AFURLSessionManager *urlsession = nil;
    dispatch_once(&onceToken2, ^{
        urlsession = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return urlsession;
}

- (NSData *)certData {
    if (_certData == nil) {
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
        _certData = [NSData dataWithContentsOfFile:cerPath];
    }

    return _certData;
}

//- (AFSecurityPolicy*)customSecurityPolicy {
//    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    policy.validatesDomainName = NO;
//    policy.allowInvalidCertificates = YES;
//    policy.pinnedCertificates = [NSSet setWithObject:[self certData]];
//
//    return policy;
//}

- (void)RequestMethod:(NSString *)method withURL:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSString *, NSInteger code))failure{
    AFHTTPSessionManager *manager = [ServiceRequest sharedHTTPSession];
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:urlStr] absoluteString] parameters:parameters error:nil];
    [request setTimeoutInterval:TIMEOUT];
    [request setValue:currentLocaleLanuage() forHTTPHeaderField:@"Accept-Language"];
    [request setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"Version"];
    [request setValue:@"IOS" forHTTPHeaderField:@"deviceType"];
    
    NSLog(@"*********REQUESTURL:\n%@\n**********", urlStr);
    NSLog(@"=========PARAMETERS:\n%@\n==========", parameters);
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [taskMutDic removeObjectForKey:urlStr];
        if (error) {
            [self showError:error andResponse:response andResponseObject:responseObject failure:failure];
        }else{
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@", dic);
            NSInteger codeEx = [[dic objectForKey:@"code"] integerValue];
            if (codeEx == 0) {
                success(dic);
            }else{
                failure([dic objectForKey:@"message"],codeEx);
            }
            
        }
    }];
    [dataTask resume];
    [taskMutDic setObject:dataTask forKey:urlStr];
}

- (void)RequestJsonMethod:(NSString *)method withURL:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSString *, NSInteger code))failure{
    AFHTTPSessionManager *manager = [ServiceRequest sharedHTTPSession];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeoutInterval:TIMEOUT];
    [request setHTTPMethod:method];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[NSString stringWithFormat:@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[str length]];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: [str dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:currentLocaleLanuage() forHTTPHeaderField:@"Accept-Language"];
    [request setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"Version"];
    [request setValue:@"IOS" forHTTPHeaderField:@"deviceType"];
    NSLog(@"*********REQUESTURL:\n%@\n**********", urlStr);
    NSLog(@"=========PARAMETERS:\n%@\n==========", parameters);
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [taskMutDic removeObjectForKey:urlStr];
        if (error) {
            [self showError:error andResponse:response andResponseObject:responseObject failure:failure];
        }else{
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@", dic);
            NSInteger codeEx = [[dic objectForKey:@"code"] integerValue];
            if (codeEx == 0) {
                success(dic);
            }else{
                failure([dic objectForKey:@"message"],codeEx);
            }
        }
    }];
    [dataTask resume];
    [taskMutDic setObject:dataTask forKey:urlStr];
}

- (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSString *, NSInteger code))failure {
    [self RequestMethod:@"GET" withURL:[[NSString stringWithFormat:@"%@%@", HOSTIP, URLString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters success:success failure:failure];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSString *, NSInteger code))failure {
    [self RequestMethod:@"POST" withURL:[[NSString stringWithFormat:@"%@%@", HOSTIP, URLString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters success:success failure:failure];
}

- (void)POSTCUSTOM:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSString *, NSInteger code))failure {
    [self RequestMethod:@"POST" withURL:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters success:success failure:failure];
}

- (void)PUT:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSString *, NSInteger code))failure {
    [self RequestMethod:@"PUT" withURL:[[NSString stringWithFormat:@"%@%@", HOSTIP, URLString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters success:success failure:failure];
}

- (void)PUTJSON:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSString *, NSInteger code))failure {
    [self RequestJsonMethod:@"PUT" withURL:[[NSString stringWithFormat:@"%@%@", HOSTIP, URLString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters success:success failure:failure];
}

- (void)DELETE:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSString *error, NSInteger code))failure {
    [self RequestMethod:@"DELETE" withURL:[[NSString stringWithFormat:@"%@%@", HOSTIP, URLString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters success:success failure:failure];
}

- (void)DELETEJSON:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSString *error, NSInteger code))failure {
    [self RequestJsonMethod:@"DELETE" withURL:[[NSString stringWithFormat:@"%@%@", HOSTIP, URLString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters success:success failure:failure];
}

- (void)POSTJSON:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSString *, NSInteger code))failure {
    [self RequestJsonMethod:@"POST" withURL:[[NSString stringWithFormat:@"%@%@", HOSTIP, URLString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters success:success failure:failure];
}

- (void)POSTJSON:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error, NSInteger code))failure update:(void (^)(float progress))update{
    AFHTTPSessionManager *manager = [ServiceRequest sharedHTTPSession];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@", HOSTIP, URLString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:TIMEOUT];
    [request setHTTPMethod:@"POST"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[NSString stringWithFormat:@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[str length]];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: [str dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:currentLocaleLanuage() forHTTPHeaderField:@"Accept-Language"];
    [request setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"Version"];
    [request setValue:@"IOS" forHTTPHeaderField:@"deviceType"];
    NSLog(@"*********REQUESTURL:\n%@\n**********", [NSString stringWithFormat:@"%@%@", HOSTIP, URLString]);
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        update(uploadProgress.fractionCompleted);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [taskMutDic removeObjectForKey:[NSString stringWithFormat:@"%@%@", HOSTIP, URLString]];
        if (error) {
            [self showError:error andResponse:response andResponseObject:responseObject failure:failure];
        }else{
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@", dic);
            NSInteger codeEx = [[dic objectForKey:@"code"] integerValue];
            if (codeEx == 0) {
                success(dic);
            }else{
                failure([dic objectForKey:@"message"],codeEx);
            }
        }
    }];
    [dataTask resume];
    [taskMutDic setObject:dataTask forKey:[NSString stringWithFormat:@"%@%@", HOSTIP, URLString]];
}

- (void)PUTJSON:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error, NSInteger code))failure update:(void (^)(float progress))update{
    AFHTTPSessionManager *manager = [ServiceRequest sharedHTTPSession];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@", HOSTIP, URLString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setTimeoutInterval:TIMEOUT];
    [request setHTTPMethod:@"PUT"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str=[NSString stringWithFormat:@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[str length]];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: [str dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:currentLocaleLanuage() forHTTPHeaderField:@"Accept-Language"];
    [request setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"Version"];
    [request setValue:@"IOS" forHTTPHeaderField:@"deviceType"];
    NSLog(@"*********REQUESTURL:\n%@\n**********", [NSString stringWithFormat:@"%@%@", HOSTIP, URLString]);
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        update(uploadProgress.fractionCompleted);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [taskMutDic removeObjectForKey:[NSString stringWithFormat:@"%@%@", HOSTIP, URLString]];
        if (error) {
            [self showError:error andResponse:response andResponseObject:responseObject failure:failure];
        }else{
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@", dic);
            NSInteger codeEx = [[dic objectForKey:@"code"] integerValue];
            if (codeEx == 0) {
                success(dic);
            }else{
                failure([dic objectForKey:@"message"],codeEx);
            }
        }
    }];
    [dataTask resume];
    [taskMutDic setObject:dataTask forKey:[NSString stringWithFormat:@"%@%@", HOSTIP, URLString]];
}

- (void)cancelDataTaskForKey:(NSString *)key{
    NSString *keyStr = [NSString stringWithFormat:@"%@%@", HOSTIP, key];
    if ([taskMutDic objectForKey:keyStr]) {
        NSURLSessionDataTask *dataTask = [taskMutDic objectForKey:keyStr];
        [dataTask cancel];
        [taskMutDic removeObjectForKey:keyStr];
    }
}

- (void)showError:(NSError *)error andResponse:(NSURLResponse *)operation andResponseObject:(id)responseObject failure:(void (^)(NSString *, NSInteger code))failure {
    NSLog(@"=================%@==============", error);
    if (responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSInteger code = ((NSHTTPURLResponse *)operation).statusCode;
        NSLog(@"%@", dic);
        if (code == 401) {
//            failure(@"用户授权失败，请重新登录",code);
            AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [del.navigationController.topViewController hideHudAlert];
            CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
            [alertView setContainerView:[[CustomInfoAlertView alloc] initItem:@"用户授权失败，请重新登录" withTitle:@"提示"]];
            [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"重新登录", nil]];
            [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
                [alertView close];
                [UserManger logoutCurrentUser];
                [del.navigationController popToRootViewControllerAnimated:NO];
//                if (buttonIndex == 0) {
//                }else{
//                    LoginViewController *viewCon = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//                    viewCon.RefreshHandle = ^(){
//
//                    };
//                    CustomNavigationCoutroller *navCon = [[CustomNavigationCoutroller alloc] initWithRootViewController:viewCon];
//                    [del.navigationController presentViewController:navCon animated:YES completion:nil];
//                }
                
            }];
            [alertView setUseMotionEffects:true];
            [alertView show];
        }else if ([dic count] > 0){
            failure([dic objectForKey:@"error_message"],code);
        }else if (code == 409) {
            failure([dic objectForKey:@"error_message"],code);
        }else if (code == 404){
            failure(@"未找到内容",code);
        }else{
            [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                switch (status) {
                    case AFNetworkReachabilityStatusNotReachable:
                        failure(ISNONETWORK,code);
                        break;
                    case AFNetworkReachabilityStatusUnknown:
                        failure(ISBADNETWORK,code);
                        break;
                    default:
                        failure(ISSERVIECCRASH,-1);
                        break;
                }
            }];
            [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        }
    }else{
        if ([error code] == -999) {
            
        }else if ([error code] == -1001){
            failure(TIMEOUTINFO,-1001);
        }else{
            [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                switch (status) {
                    case AFNetworkReachabilityStatusNotReachable:
                        failure(ISNONETWORK,0);
                        break;
                    case AFNetworkReachabilityStatusUnknown:
                        failure(ISBADNETWORK,0);
                        break;
                    default:
                        failure(ISSERVIECCRASH,-1);
                        break;
                }
            }];
            [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        }
    }
}

@end
