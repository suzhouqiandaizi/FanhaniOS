//
//  WeChatRegisterBindViewController.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/7/31.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeChatRegisterBindViewController : UIViewController
@property (assign, nonatomic) NSInteger type; //0已有账号直接绑定 1未注册绑定
@property (strong, nonatomic) NSString *oauthStr;
@property (strong, nonatomic) NSString *openIDStr;
@property (strong, nonatomic) NSString *tokenStr;
@property (strong, nonatomic) NSString *usernameStr;
@end

NS_ASSUME_NONNULL_END
