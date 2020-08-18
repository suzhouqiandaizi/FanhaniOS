//
//  LoginPrivacyProtocolView.h
//  ReceiveTask
//
//  Created by WangZhenyu on 2020/4/1.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginPrivacyProtocolView : UIView
- (id)initItem;
@property (copy, nonatomic) void (^ClikcHandle)(NSString *url);

@end

NS_ASSUME_NONNULL_END
