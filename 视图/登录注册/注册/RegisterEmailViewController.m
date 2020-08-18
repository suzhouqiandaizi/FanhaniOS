//
//  RegisterEmailViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/7/30.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "RegisterEmailViewController.h"
#import "UIColor+Hexadecimal.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "WebShowViewController.h"
#import "RegisterInputCodeViewController.h"

@interface RegisterEmailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleTwoLabel;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@end

@implementation RegisterEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self.scrollView setFrame:CGRectMake(0, IS_iPhoneX_Top + 100 , SCREEN_WIDTH_DEVICE, self.scrollView.frame.size.height)];
    [self.bottomView setFrame:CGRectMake(0, SCREEN_HEIGHT_DEVICE - self.bottomView.frame.size.height - 8 - IS_iPhoneX_Bottom, SCREEN_WIDTH_DEVICE, self.bottomView.frame.size.height)];
    self.titleLabel.text = NSLocalizedString(@"welcomeInfo", nil);
    self.titleTwoLabel.text = NSLocalizedString(@"pleaseInputYourEmail", nil);
    self.emailTextField.placeholder = NSLocalizedString(@"emailInfo", nil);
    [self.sureBtn setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE - 50, 44) direction:GradientChangeDirectionLevel startColor:[UIColor colorWithHex:0xff59bbff] endColor:[UIColor colorWithHex:0xff4a88ff]] forState:UIControlStateNormal];
    [self.sureBtn setTitle:NSLocalizedString(@"nextButton", nil) forState:UIControlStateNormal];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 3.0f;
    self.emailView.layer.masksToBounds = YES;
    self.emailView.layer.cornerRadius = 3.0f;
    self.emailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.emailView.layer.borderWidth = 0.5f;
        
    self.bottomLabel.text = NSLocalizedString(@"userServiceAgreemnetAndPrivacyPolicy", nil);
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.bottomLabel.text];
    [text addAttribute:NSForegroundColorAttributeName value:ThemeColor range:[self.bottomLabel.text rangeOfString:@"服务协议"]];
    [text addAttribute:NSForegroundColorAttributeName value:ThemeColor range:[self.bottomLabel.text rangeOfString:@"隐私政策"]];
    [text addAttribute:NSForegroundColorAttributeName value:ThemeColor range:[self.bottomLabel.text rangeOfString:@"service agreement"]];
    [text addAttribute:NSForegroundColorAttributeName value:ThemeColor range:[self.bottomLabel.text rangeOfString:@"privacy policy"]];
    NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc] init];
    sty.alignment = NSTextAlignmentCenter;
    [text addAttribute:NSParagraphStyleAttributeName value:sty range:NSMakeRange(0, text.length)];
    
    self.bottomLabel.attributedText = text;
    CGSize labelSize = [self.bottomLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE - 88, MAX_INPUT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]} context:nil].size;
//    [self.bottomLabel setFrame:CGRectMake((SCREEN_WIDTH_DEVICE - labelSize.width)/2.0, (self.bottomView.frame.size.height - labelSize.height)/2.0, labelSize.width, labelSize.height)];
    [self.agreeBtn setFrame:CGRectMake(((SCREEN_WIDTH_DEVICE - labelSize.width)/2) - self.agreeBtn.frame.size.width + 12, 0, self.agreeBtn.frame.size.width, self.agreeBtn.frame.size.height)];
    
    [self.bottomLabel yb_addAttributeTapActionWithStrings:@[@"服务协议",@"隐私政策",@"service agreement",@"privacy policy"] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        WebShowViewController *viewCon = [[WebShowViewController alloc] initWithNibName:@"WebShowViewController" bundle:nil];
        if ([string isEqualToString:@"服务协议"] || [string isEqualToString:@"service agreement"]) {
            viewCon.urlStr = [NSString stringWithFormat:@"%@/agreement/worker", HOSTURL];
            }else{
                viewCon.urlStr = [NSString stringWithFormat:@"%@/agreement/privacy", HOSTURL];
            }
        [self.navigationController pushViewController:viewCon animated:YES];
    }];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)agreePress {
    self.agreeBtn.selected = !self.agreeBtn.selected;
}


- (IBAction)surePress {
    if (self.emailTextField.text.length == 0) {
        [self showHUDAlert:NSLocalizedString(@"pleaseInputYourEmail", nil)];
        return;
    }
    if (!self.agreeBtn.selected) {
        [self showHUDAlert:NSLocalizedString(@"alertShowAgreeServiceAgreemnetAndPrivacyPolicy", nil)];
        return;
    }
    [self loadingHUDAlert];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.emailTextField.text forKey:@"email"];
    [[ServiceRequest sharedService] GET:@"/api/auth/check/email" parameters:dic success:^(id responseObject) {
        [self hideHudAlert];
        RegisterInputCodeViewController *viewCon = [[RegisterInputCodeViewController alloc] initWithNibName:@"RegisterInputCodeViewController" bundle:nil];
        viewCon.content = self.emailTextField.text;
        [self.navigationController pushViewController:viewCon animated:YES];
    } failure:^(NSString *error, NSInteger code) {
        [self showHUDAlert:error];
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
