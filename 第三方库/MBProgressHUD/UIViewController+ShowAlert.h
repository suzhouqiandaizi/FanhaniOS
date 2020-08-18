//
//  UIViewController+ShowAlert.h
//  Sponsor
//
//  Created by WangZhenyu on 16/1/24.
//  Copyright © 2016年 unshu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ShowAlert)
///信息提示，默认为1秒
- (void)showHUDAlert:(NSString *)content;
///加载，菊花转
- (void)loadingHUDAlert;
- (void)loadingHUDAlert:(NSString *)content withView:(UIView *)otherView;
- (void)loadingHUDAlertToWindow:(NSString *)content;
///隐藏提示框
- (void)hideHudAlert;

@end
