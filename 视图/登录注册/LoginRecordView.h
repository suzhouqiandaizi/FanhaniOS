//
//  LoginRecordView.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/5.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginRecordView : UIView
- (id)initItem:(CGRect)rect;
- (void)showContent;
@property (copy, nonatomic) void (^ChooseHandle)(UserLoginRecord *user);
@property (copy, nonatomic) void (^HidenHandle)(void);
@end

NS_ASSUME_NONNULL_END
