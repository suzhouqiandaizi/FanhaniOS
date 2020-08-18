//
//  CustomSuccessAlertView.m
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import "CustomInfoAlertView.h"

@interface CustomInfoAlertView()


@end

@implementation CustomInfoAlertView

- (id)initItem:(NSString *)info withTitle:(NSString *)title{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomInfoAlertView" owner:self options:nil] lastObject];
    if (self) {
        [self setFrame:CGRectMake(0, 0, 280, 120)];
        self.contentLabel.text = info;
        self.titleLabel.text = title;
    }
    return self;
}

@end
