//
//  LoginPrivacyProtocolView.m
//  ReceiveTask
//
//  Created by WangZhenyu on 2020/4/1.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "LoginPrivacyProtocolView.h"
#import "UILabel+YBAttributeTextTapAction.h"

@interface LoginPrivacyProtocolView()
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@end

@implementation LoginPrivacyProtocolView

- (id)initItem{
    self = [[[NSBundle mainBundle] loadNibNamed:@"LoginPrivacyProtocolView" owner:self options:nil] lastObject];
    if (self) {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE)];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.textView setContentOffset:CGPointMake(0, 0)];
//        });
        [self.agreeBtn setTitle:NSLocalizedString(@"alertAgreeBtn", nil) forState:UIControlStateNormal];
        [self.refuseBtn setTitle:NSLocalizedString(@"alertRefuseBtn", nil) forState:UIControlStateNormal];
        self.titleLabel.text = NSLocalizedString(@"userServiceAgreemnetAndPrivacyPolicyTitle", nil);
        self.contentLabel.text = NSLocalizedString(@"userServiceAgreemnetAndPrivacyPolicyContent", nil);
        self.showView.layer.masksToBounds = YES;
        self.showView.layer.cornerRadius = 5.0f;
                        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text];
        [text addAttribute:NSForegroundColorAttributeName value:TextColor range:NSMakeRange(0,text.length)];
        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,text.length)];
        [text addAttribute:NSForegroundColorAttributeName value:ThemeColor range:[self.contentLabel.text rangeOfString:@"服务协议"]];
        [text addAttribute:NSForegroundColorAttributeName value:ThemeColor range:[self.contentLabel.text rangeOfString:@"隐私政策"]];
        [text addAttribute:NSForegroundColorAttributeName value:ThemeColor range:[self.contentLabel.text rangeOfString:@"service agreement"]];
        [text addAttribute:NSForegroundColorAttributeName value:ThemeColor range:[self.contentLabel.text rangeOfString:@"privacy policy"]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8;// 字体的行间距
        [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
        self.contentLabel.attributedText = text;
        
        [self.contentLabel yb_addAttributeTapActionWithStrings:@[@"服务协议",@"隐私政策",@"service agreement",@"privacy policy"] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
            if ([string isEqualToString:@"服务协议"] || [string isEqualToString:@"service agreement"]) {
                if (self.ClikcHandle) {
                    self.ClikcHandle([NSString stringWithFormat:@"%@/agreement/worker", HOSTURL]);
                }
            }else{
                if (self.ClikcHandle) {
                    self.ClikcHandle([NSString stringWithFormat:@"%@/agreement/privacy", HOSTURL]);
                }
            }
        }];
        CGSize labelSize = [self.contentLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH_DEVICE - 78, MAXFLOAT)];
        [self.showView setFrame:CGRectMake(25, (SCREEN_HEIGHT_DEVICE - labelSize.height - 180)/2.0, SCREEN_WIDTH_DEVICE - 50, labelSize.height + 180)];
    }
    return self;
}

- (IBAction)removePress {
//    [self removeFromSuperview];
}

- (IBAction)exitPress {
    exit(1);
}

- (IBAction)agreePress {
    [DEFAULTS setBool:YES forKey:@"SHOWPRIVACYPROTOCOL"];
    [DEFAULTS synchronize];
    [self removeFromSuperview];
}

@end
