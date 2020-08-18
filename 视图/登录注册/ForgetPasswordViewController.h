//
//  ForgetPasswordViewController.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/7/30.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LoginRegisterType) {
    LoginRegisterType_default = 0, //登录
    LoginRegisterType_change  = 1, //修改密码
    LoginRegisterType_forgot  = 2, //忘记密码
};
NS_ASSUME_NONNULL_BEGIN

@interface ForgetPasswordViewController : UIViewController
@property (assign, nonatomic) LoginRegisterType type;

@end

NS_ASSUME_NONNULL_END
