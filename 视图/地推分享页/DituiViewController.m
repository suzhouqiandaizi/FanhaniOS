//
//  DituiViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/17.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "DituiViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

@interface DituiViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation DituiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.fd_prefersNavigationBarHidden = YES;
    [self.backBtn setFrame:CGRectMake(0, 20 + IS_iPhoneX_Top, 44, 44)];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)goBackPress {
    [self goBackAction];
}

- (IBAction)sharePress {
    if (![ShareSDK isClientInstalled:SSDKPlatformSubTypeWechatSession]) {
        [self showHUDAlert:NSLocalizedString(@"alertInstallWechatError", nil)];
        return;
    }
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:nil
    images:@[@"https://s301.fanhantech.com/ditui_share_img.png"]
       url:nil
     title:nil
      type:SSDKContentTypeAuto];
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        NSLog(@"%ld",(long)error.code);
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [self showHUDAlert:NSLocalizedString(@"alertShareSuccess", nil)];
                [[ServiceRequest sharedService] POSTJSON:@"/api/app/activity/reward" parameters:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:8] forKey:@"activityID"] success:^(id responseObject) {
                } failure:^(NSString *error, NSInteger code) {
                    [self showHUDAlert:error];
                }];
                break;
            }
            case SSDKResponseStateFail:
            {
                [self showHUDAlert:NSLocalizedString(@"alertShareFail", nil)];
                break;
            }
            default:
                break;
        }
    }];
}

@end
