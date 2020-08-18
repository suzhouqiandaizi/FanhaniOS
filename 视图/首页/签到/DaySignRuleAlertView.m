//
//  DaySignRuleAlertView.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/18.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "DaySignRuleAlertView.h"

@interface DaySignRuleAlertView()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *alertView;

@end

@implementation DaySignRuleAlertView

- (id)initItem{
    self = [[[NSBundle mainBundle] loadNibNamed:@"DaySignRuleAlertView" owner:self options:nil] lastObject];
    if (self) {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE)];
        self.titleLabel.text = NSLocalizedString(@"daySignRule", nil);
        [self.closeBtn setTitle:NSLocalizedString(@"alertClose", nil) forState:UIControlStateNormal];
        self.alertView.layer.masksToBounds = YES;
        self.alertView.layer.cornerRadius = 5.0f;
        
        self.textView.text = NSLocalizedString(@"daySignRuleContent", nil);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8;// 字体的行间距
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:13],
                                     NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.textView.text attributes:attributes];
        self.textView.attributedText = attributeStr;
        
        CGSize labelSize = [self.textView sizeThatFits:CGSizeMake(SCREEN_WIDTH_DEVICE - 40, MAXFLOAT)];
        [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, labelSize.width, labelSize.height)];
        [self.alertView setFrame:CGRectMake(10, (SCREEN_HEIGHT_DEVICE - 120 - labelSize.height)/2.0, SCREEN_WIDTH_DEVICE - 20, 120 + labelSize.height)];
    }
    return self;
}



- (IBAction)removePress {
    [self removeFromSuperview];
}

@end
