//
//  UIViewController_extentsion.h
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FloatBarType) {
    FloatBarTypeInProgress,
    FloatBarTypeInfo,
    FloatBarTypeError,
    FloatBarTypeNotification
};

@interface UIViewController (custom)
///添加返回按钮
- (void)addBackBtn;
- (void)addWhiteBackBtn;
- (void)addBackBtnTitle:(NSString *)title;

///添加右边按钮，事件自定义
- (UIButton *)addRigthBtn:(NSString *)title;
- (UIButton *)addRigthBtn:(NSString *)title withButtonColor:(UIColor *)colorBtn;
- (UIButton *)addLeftBtn:(NSString *)title;
- (UIButton *)addRigthBtnImage:(NSString *)imageName;
- (void)addRigthBtnImage:(NSString *)imageName withBadge:(NSInteger)badge complete:(void (^)(UIButton *actionBtn, UILabel *badgeLabel))success;
- (void)addRigthBtnTitle:(NSString *)title withBadge:(NSInteger)badge complete:(void (^)(UIButton *actionBtn, UILabel *badgeLabel))success;
- (void)goBackAction;

@end
