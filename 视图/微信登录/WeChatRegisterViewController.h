//
//  WeChatRegisterViewController.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/7/31.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeChatRegisterViewController : UIViewController

@property (strong, nonatomic) NSString *oauthStr;
@property (strong, nonatomic) NSString *openIDStr;
@property (strong, nonatomic) NSString *tokenStr;

@end

NS_ASSUME_NONNULL_END
