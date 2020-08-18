//
//  CustomSuccessAlertView.h
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomInfoAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (id)initItem:(NSString *)info withTitle:(NSString *)title;
@end
