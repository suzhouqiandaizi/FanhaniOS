//
//  CustomTextViewAlertView.m
//  ReceiveTask
//
//  Created by 娇娇 on 2020/3/16.
//  Copyright © 2020年 WangZhenyu. All rights reserved.
//

#import "CustomTextViewAlertView.h"

@interface CustomTextViewAlertView ()<UITextViewDelegate>{
    BOOL        editBool;
}
@end
@implementation CustomTextViewAlertView

- (id)initItemTitle:(NSString *)title{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomTextViewAlertView" owner:self options:nil] lastObject];
    if (self) {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE - 40, 148)];
        self.titleLabel.text = title;
        self.contentView.delegate = self;
        editBool = YES;
        self.contentView.textColor = PlaceholderColor;
    }
    return self;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (editBool) {
        editBool = NO;
        textView.text = @"";
        [textView setTextColor:TextColor];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        editBool = YES;
        textView.text = @"请详细描述拒绝任务结果的理由。";
        [textView setTextColor:PlaceholderColor];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    NSInteger textViewLength = [textView.text stringByReplacingCharactersInRange:range withString:text].length;
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    [textView setTextColor:TextColor];
}
@end
