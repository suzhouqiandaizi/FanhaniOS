//
//  WeChatRegisterViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/7/31.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "WeChatRegisterViewController.h"
#import "UIColor+Hexadecimal.h"
#import "WeChatRegisterBindViewController.h"

@interface WeChatRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *hasAccountButton;
@end

@implementation WeChatRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self.scrollView setFrame:CGRectMake(0, IS_iPhoneX_Top + 100 , SCREEN_WIDTH_DEVICE, self.scrollView.frame.size.height)];
    self.titleLabel.text = NSLocalizedString(@"wechatRegisterBind", nil);
    self.nameTextField.placeholder = NSLocalizedString(@"usernameConstraint", nil);
    NSString *buttonStr = NSLocalizedString(@"hasAccountAndBind", nil);
    CGSize labelSize = [buttonStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE, MAX_INPUT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size;
    [self.hasAccountButton setFrame:CGRectMake(SCREEN_WIDTH_DEVICE - labelSize.width - 25, self.hasAccountButton.frame.origin.y, labelSize.width, self.hasAccountButton.frame.size.height)];
    [self.hasAccountButton setTitle:buttonStr forState:UIControlStateNormal];
    [self.sureBtn setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE - 50, 44) direction:GradientChangeDirectionLevel startColor:[UIColor colorWithHex:0xff59bbff] endColor:[UIColor colorWithHex:0xff4a88ff]] forState:UIControlStateNormal];
    [self.sureBtn setTitle:NSLocalizedString(@"nextButton", nil) forState:UIControlStateNormal];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 3.0f;
    self.nameView.layer.masksToBounds = YES;
    self.nameView.layer.cornerRadius = 3.0f;
    self.nameView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.nameView.layer.borderWidth = 0.5f;
    
    
}
- (IBAction)hasAccountPress {
    WeChatRegisterBindViewController *viewCon = [[WeChatRegisterBindViewController alloc] initWithNibName:@"WeChatRegisterBindViewController" bundle:nil];
    viewCon.oauthStr = self.oauthStr;
    viewCon.openIDStr = self.openIDStr;
    viewCon.tokenStr = self.tokenStr;
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (IBAction)surePress {
    if (self.nameTextField.text.length > 30 || self.nameTextField.text.length < 5) {
        [self showHUDAlert:NSLocalizedString(@"alertUsernameLengthError", nil)];
        return;
    }
    if (![self checkUserName:self.nameTextField.text]) {
        [self showHUDAlert:NSLocalizedString(@"usernameConstraint", nil)];
        return;
    }
    [self loadingHUDAlert];
    NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
    [dicOne setObject:self.nameTextField.text forKey:@"username"];
    [[ServiceRequest sharedService] GET:@"/api/auth/check/username" parameters:dicOne success:^(id responseObject) {
        [self hideHudAlert];
        WeChatRegisterBindViewController *viewCon = [[WeChatRegisterBindViewController alloc] initWithNibName:@"WeChatRegisterBindViewController" bundle:nil];
        viewCon.type = 1;
        viewCon.oauthStr = self.oauthStr;
        viewCon.openIDStr = self.openIDStr;
        viewCon.tokenStr = self.tokenStr;
        viewCon.usernameStr = self.nameTextField.text;
        [self.navigationController pushViewController:viewCon animated:YES];
    } failure:^(NSString *error, NSInteger code) {
        [self showHUDAlert:error];
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)checkUserName:(NSString *)userName
{
    //判断是否以字母开头
    NSString *regex =  @"^[a-zA-Z][a-zA-Z0-9_-]*$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pre evaluateWithObject:userName];
    if (!isMatch) {
        return NO;
    }
    return YES;
}
@end
