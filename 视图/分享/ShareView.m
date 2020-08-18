//
//  ShareView.m
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import "ShareView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "AppDelegate.h"
#import "CustomActivity.h"

@interface ShareView(){
    NSString *urlStr;
    NSString *contentStr;
    NSString *titleStr;
    UIImage *shareImage;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *pengyouquanBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation ShareView


- (id)initItemContent:(NSString *)content withTitle:(NSString *)title withUrl:(NSString *)url withShareicon:(UIImage *)image{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:self options:nil] lastObject];
    if (self) {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE)];
        
        self.titleLabel.text = NSLocalizedString(@"shareAlertTitle", nil);
        [self.cancelBtn setTitle:NSLocalizedString(@"cancelButton", nil) forState:UIControlStateNormal];
        [self.qqBtn setTitle:NSLocalizedString(@"shareAlertQQButton", nil) forState:UIControlStateNormal];
        [self.weixinBtn setTitle:NSLocalizedString(@"shareAlertWxButton", nil) forState:UIControlStateNormal];
        [self.pengyouquanBtn setTitle:NSLocalizedString(@"shareAlertSessionButton", nil) forState:UIControlStateNormal];
        [self.weiboBtn setTitle:NSLocalizedString(@"shareAlertMoreButton", nil) forState:UIControlStateNormal];
        
        [self.bottomView setFrame:CGRectMake(0, SCREEN_HEIGHT_DEVICE, SCREEN_WIDTH_DEVICE, 232 + IS_iPhoneX_Bottom)];
        [UIView animateWithDuration:0.3 animations:^{
            [self.bottomView setFrame:CGRectMake(0, SCREEN_HEIGHT_DEVICE - 232 - IS_iPhoneX_Bottom, SCREEN_WIDTH_DEVICE, 232 + IS_iPhoneX_Bottom)];
        }];
        contentStr = content;
        titleStr = title;
        urlStr = url;
        shareImage = [UIImage imageNamed:@"shareicon"];
        self.qqBtn.enabled = [ShareSDK isClientInstalled:SSDKPlatformSubTypeQQFriend];
        self.pengyouquanBtn.enabled = [ShareSDK isClientInstalled:SSDKPlatformSubTypeWechatSession];
        self.weixinBtn.enabled = [ShareSDK isClientInstalled:SSDKPlatformSubTypeWechatSession];
        NSInteger i = 1;
        if (self.qqBtn.enabled) {
            i++;
        }
        if (self.pengyouquanBtn.enabled) {
            i++;
        }
        if (self.weixinBtn.enabled) {
            i++;
        }
        float btnWidth = 80;
        float btnHeight = 132;
        float orignY = 50;
        float orignX = (SCREEN_WIDTH_DEVICE - 80 * i)/(i + 1);
        float separate = orignX;
        if (!self.qqBtn.enabled) {
            self.qqBtn.hidden = YES;
        }else{
            self.qqBtn.hidden = NO;
            [self.qqBtn setFrame:CGRectMake(orignX, orignY, btnWidth, btnHeight)];
            orignX = orignX + btnWidth + separate;
        }
        if (!self.weixinBtn.enabled) {
            self.weixinBtn.hidden = YES;
        }else{
            self.weixinBtn.hidden = NO;
            [self.weixinBtn setFrame:CGRectMake(orignX, orignY, btnWidth, btnHeight)];
            orignX = orignX + btnWidth + separate;
        }
        if (!self.pengyouquanBtn.enabled) {
            self.pengyouquanBtn.hidden = YES;
        }else{
            self.pengyouquanBtn.hidden = NO;
            [self.pengyouquanBtn setFrame:CGRectMake(orignX, orignY, btnWidth, btnHeight)];
            orignX = orignX + btnWidth + separate;
        }
        [self.weiboBtn setFrame:CGRectMake(orignX, orignY, btnWidth, btnHeight)];
        
    }
    return self;
}

- (IBAction)removePress {
    [UIView animateWithDuration:0.2 animations:^{
        [self.bottomView setFrame:CGRectMake(0, SCREEN_HEIGHT_DEVICE, SCREEN_WIDTH_DEVICE, 232 + IS_iPhoneX_Bottom)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)qqPress {
    [self shareType:SSDKPlatformSubTypeQQFriend];
}

- (IBAction)weiboPress {
    [self shareType:SSDKPlatformTypeSinaWeibo];
}

- (IBAction)pengyouquanPress {
    [self shareType:SSDKPlatformSubTypeWechatTimeline];
}

- (IBAction)weixinhaoyouPress {
    [self shareType:SSDKPlatformSubTypeWechatSession];
}

- (void)shareType:(SSDKPlatformType)type{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (type == SSDKPlatformSubTypeWechatTimeline) {
        [shareParams SSDKSetupShareParamsByText:nil
                                         images:@[shareImage]
                                            url:[NSURL URLWithString:urlStr]
                                          title:contentStr
                                           type:SSDKContentTypeAuto];
    }else if (type == SSDKPlatformTypeSinaWeibo){
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@", contentStr, urlStr]
                                         images:@[shareImage]
                                            url:[NSURL URLWithString:urlStr]
                                          title:titleStr
                                           type:SSDKContentTypeAuto];
    }else{
        [shareParams SSDKSetupShareParamsByText:contentStr
                                         images:@[shareImage]
                                            url:[NSURL URLWithString:urlStr]
                                          title:titleStr
                                           type:SSDKContentTypeAuto];
    }
    
    
    
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        NSLog(@"%ld",(long)error.code);
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [del.navigationController.topViewController showHUDAlert:NSLocalizedString(@"alertShareSuccess", nil)];
                [self removeFromSuperview];
                break;
            }
            case SSDKResponseStateFail:
            {
                [del.navigationController.topViewController  showHUDAlert:NSLocalizedString(@"alertShareFail", nil)];
                [self removeFromSuperview];
                break;
            }
            default:
                [self removeFromSuperview];
                break;
        }
    }];
}
- (IBAction)copyPress {
    
    // 1、设置分享的内容，并将内容添加到数组中
    NSString *shareText = titleStr;
    UIImage *shareImage = [UIImage imageNamed:@"shareicon"];
    NSURL *shareUrl = [NSURL URLWithString:urlStr];
    NSArray *activityItemsArray = @[shareText,shareImage,shareUrl];
    
    // 自定义的CustomActivity，继承自UIActivity
    CustomActivity *customActivity = [[CustomActivity alloc]initWithTitle:shareText ActivityImage:[UIImage imageNamed:@"shareicon"] URL:shareUrl ActivityType:@"Custom"];
    NSArray *activityArray = @[customActivity];
    
    // 2、初始化控制器，添加分享内容至控制器
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItemsArray applicationActivities:activityArray];
    activityVC.modalInPopover = YES;
    // 3、设置回调
    UIActivityViewControllerCompletionWithItemsHandler itemsBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        NSLog(@"activityType == %@",activityType);
        if (completed == YES) {
            NSLog(@"completed");
        }else{
            NSLog(@"cancel");
        }
    };
    activityVC.completionWithItemsHandler = itemsBlock;
    // 4、调用控制器
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [del.navigationController.topViewController presentViewController:activityVC animated:YES completion:nil];
}

- (void)OnCopyLink
{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    //pasteboard.string = [NSString stringWithFormat:@"%@ %@",strContent,urlString];
    pasteboard.string = urlStr;
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [del.navigationController.topViewController showHUDAlert:@"复制成功，粘贴分享给好友"];
}

@end
