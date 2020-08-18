//
//  UIViewController_extentsion.m
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//
#import "UIViewController_extentsion.h"

#define FLOATBAR_HEIGHT 70
#define TAG_FLOATBAR 6000
#define TAG_FLOATBAR_CONTAINER 6001
#define TIMEINTERVAL 3

@implementation UIViewController(custom)

//添加返回按钮
- (void)addBackBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 44, 44);
    [btn setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    if (IOS11_OR_LATER) {
        btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -12 *SCREEN_WIDTH_DEVICE /375.0,0,0)];
    }
    UIBarButtonItem *btn_left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_left, nil];
}

//添加白色返回按钮
- (void)addWhiteBackBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 44, 44);
    [btn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    if (IOS11_OR_LATER) {
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 1 *SCREEN_WIDTH_DEVICE /375.0,0,0)];
    }
    UIBarButtonItem *btn_left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_left, nil];
}

//添加左边边按钮
- (UIButton *)addLeftBtn:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 20 + title.length * 15.0f, 40);
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btn setTitle:[NSString stringWithFormat:@"%@", title] forState:UIControlStateNormal];
    if (IOS11_OR_LATER) {
        btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -5 *SCREEN_WIDTH_DEVICE /375.0,0,0)];
    }
    UIBarButtonItem *btn_left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_left, nil];
    return btn;
}

//添加右边按钮
- (UIButton *)addRigthBtn:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 20 + title.length * 15.0f, 40);
    [btn setTitleColor:ThemeColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btn setTitle:[NSString stringWithFormat:@"%@", title] forState:UIControlStateNormal];
    if (IOS11_OR_LATER) {
        btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -5 *SCREEN_WIDTH_DEVICE /375.0,0,0)];
    }
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
    return btn;
}

- (UIButton *)addRigthBtn:(NSString *)title withButtonColor:(UIColor *)colorBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 20 + title.length * 15.0f, 40);
    [btn setTitleColor:colorBtn forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btn setTitle:[NSString stringWithFormat:@"%@", title] forState:UIControlStateNormal];
    if (IOS11_OR_LATER) {
        btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -5 *SCREEN_WIDTH_DEVICE /375.0,0,0)];
    }
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
    return btn;
}

//添加右边按钮
- (UIButton *)addRigthBtnImage:(NSString *)imageName{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 40, 40);
    [btn setTitleColor:ThemeColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if (IOS11_OR_LATER) {
        btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -5 *SCREEN_WIDTH_DEVICE /375.0,0,0)];
    }
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
    return btn;
}

//添加右边按钮
- (void)addRigthBtnImage:(NSString *)imageName withBadge:(NSInteger)badge complete:(void (^)(UIButton *actionBtn, UILabel *badgeLabel))success{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 40, 40);
    [btn setTitleColor:ThemeColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [view addSubview:btn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, 18, 18)];
    label.backgroundColor = RGB(234, 98, 98);
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:11.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = label.frame.size.height / 2.0;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.hidden = YES;
    [view addSubview:label];
    
    if (IOS11_OR_LATER) {
        btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -5 *SCREEN_WIDTH_DEVICE /375.0,0,0)];
    }
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:view];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
    
    success(btn, label);
}

//添加有文字的返回按钮
- (void)addBackBtnTitle:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 25 + title.length * 15.0f, 40);
    [btn setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [btn setTitle:[NSString stringWithFormat:@" %@", title] forState:UIControlStateNormal];
    [btn setTitleColor:ThemeColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    if (IOS11_OR_LATER) {
        btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -5 *SCREEN_WIDTH_DEVICE /375.0,0,0)];
    }
    UIBarButtonItem *btn_left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -5.5;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_left, nil];
}

//添加右边按钮
- (void)addRigthBtnTitle:(NSString *)title withBadge:(NSInteger)badge complete:(void (^)(UIButton *actionBtn, UILabel *badgeLabel))success{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 32, 40);
    btn.frame = CGRectMake(0, 0, 48, 40);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btn setTitle:[NSString stringWithFormat:@"%@", title] forState:UIControlStateNormal];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 48,  40)];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width - 14, 13, 14, 14)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:9.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = label.frame.size.height / 2.0;
    label.adjustsFontSizeToFitWidth = YES;
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor whiteColor].CGColor;
    label.minimumScaleFactor = 0.5;
    label.text = [NSString stringWithFormat:@"%ld", (long)badge];
    label.hidden = YES;
    [view addSubview:label];
    [view addSubview:btn];
    
    if (IOS11_OR_LATER) {
        btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -5 *SCREEN_WIDTH_DEVICE /375.0,0,0)];
    }
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:view];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
    
    success(btn, label);
}

- (void)goBackAction{
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
