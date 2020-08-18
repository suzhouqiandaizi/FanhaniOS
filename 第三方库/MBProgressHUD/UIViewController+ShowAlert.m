//
//  UIViewController+ShowAlert.m
//  Sponsor
//
//  Created by WangZhenyu on 16/1/24.
//  Copyright © 2016年 unshu.com. All rights reserved.
//

#import "UIViewController+ShowAlert.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (ShowAlert)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHUDAlert:(NSString *)content{
    [self hideHudAlert];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = content;
    hud.margin = 20.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
    [hud hideAnimated:YES afterDelay:2.5f];
    [self setHUD:hud];
}

- (void)loadingHUDAlert{
    [self hideHudAlert];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
//    hud.label.text =  NSLocalizedString(@"alertLoading", nil);
    [self setHUD:hud];
}

- (void)loadingHUDAlert:(NSString *)content withView:(UIView *)otherView{
    [self hideHudAlert];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:otherView animated:YES];
    hud.userInteractionEnabled = NO;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
    hud.label.text =  content;
    [self setHUD:hud];
}

- (void)hideHudAlert{
    [[self HUD] hideAnimated:YES];
}

- (void)loadingHUDAlertToWindow:(NSString *)content{
    [self hideHudAlert];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text =  content;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
    [self setHUD:hud];
}

@end
