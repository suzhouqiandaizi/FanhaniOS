//
//  CustomNavigationCoutroller.m
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import "CustomNavigationCoutroller.h"
#import "GlobalFunction.h"

@implementation CustomNavigationCoutroller

- (instancetype)init{
    if (self = [super init]) {
        self.fd_fullscreenPopGestureRecognizer.enabled = YES;
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:19.0f]}];
        self.navigationBar.tintColor = [UIColor blackColor];
        self.navigationBar.barStyle = UIBarStyleDefault;
//        self.navigationBar.barTintColor = ThemeColor;
        [self.navigationBar setBackgroundImage:getColorToImage([UIColor whiteColor]) forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:[UIImage new]];
        [self.navigationBar setTranslucent:YES];
        
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
        self.fd_fullscreenPopGestureRecognizer.enabled = YES;
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:19.0f]}];
        self.navigationBar.tintColor = [UIColor blackColor];
        self.navigationBar.barStyle = UIBarStyleDefault;
//        self.navigationBar.barTintColor = ThemeColor;
        [self.navigationBar setBackgroundImage:getColorToImage([UIColor whiteColor]) forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:[UIImage new]];
        [self.navigationBar setTranslucent:YES];
        
    }
    return self;
}

@end
