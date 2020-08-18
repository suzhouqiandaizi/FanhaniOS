//
//  CustomTextViewAlertView.h
//  ReceiveTask
//
//  Created by 娇娇 on 2020/3/16.
//  Copyright © 2020年 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTextViewAlertView : UIView
- (id)initItemTitle:(NSString *)title;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentView;

@end

NS_ASSUME_NONNULL_END
