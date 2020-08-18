//
//  CustomSuccessAlertView.m
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//
#import "CustomSuccessAlertView.h"

@interface CustomSuccessAlertView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CustomSuccessAlertView

- (id)initItem:(NSString *)info{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomSuccessAlertView" owner:self options:nil] lastObject];
    if (self) {
        [self setFrame:CGRectMake(0, 0, 280, 93)];
        self.titleLabel.text = info;
    }
    return self;
}

@end
