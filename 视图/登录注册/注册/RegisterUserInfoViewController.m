//
//  RegisterUserInfoViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/7/31.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "RegisterUserInfoViewController.h"
#import "UIColor+Hexadecimal.h"
#import "GlobalFunction.h"

@interface RegisterUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *oneTextField;
@property (weak, nonatomic) IBOutlet UITextField *twoTextField;
@property (weak, nonatomic) IBOutlet UITextField *threeTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@end

@implementation RegisterUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackBtn];
    [self.scrollView setFrame:CGRectMake(0, IS_iPhoneX_Top + 100 , SCREEN_WIDTH_DEVICE, self.scrollView.frame.size.height)];
    self.titleLabel.text = NSLocalizedString(@"pleaseInputYourNameAndPassword", nil);
    self.oneTextField.placeholder = NSLocalizedString(@"usernameConstraint", nil);
    self.twoTextField.placeholder = NSLocalizedString(@"setPasswordTextFieldPlaceholder", nil);
    self.threeTextField.placeholder = NSLocalizedString(@"setNewAgainPasswordTextFieldPlaceholder", nil);
    [self.sureBtn setTitle:NSLocalizedString(@"agreeAgreemnetButton", nil) forState:UIControlStateNormal];
    
    self.oneView.layer.masksToBounds = YES;
    self.oneView.layer.cornerRadius = 3.0f;
    self.oneView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.oneView.layer.borderWidth = 0.5f;
    self.twoView.layer.masksToBounds = YES;
    self.twoView.layer.cornerRadius = 3.0f;
    self.twoView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.twoView.layer.borderWidth = 0.5f;
    self.threeView.layer.masksToBounds = YES;
    self.threeView.layer.cornerRadius = 3.0f;
    self.threeView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.threeView.layer.borderWidth = 0.5f;
    
    [self.sureBtn setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE - 50, 44) direction:GradientChangeDirectionLevel startColor:[UIColor colorWithHex:0xff59bbff] endColor:[UIColor colorWithHex:0xff4a88ff]] forState:UIControlStateNormal];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 3.0f;
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)surePress {
    if (self.oneTextField.text.length > 30 || self.oneTextField.text.length < 5) {
        [self showHUDAlert:NSLocalizedString(@"alertUsernameLengthError", nil)];
        return;
    }
    if (![self checkUserName:self.oneTextField.text]) {
        [self showHUDAlert:NSLocalizedString(@"usernameConstraint", nil)];
        return;
    }
    if (self.twoTextField.text.length < 6) {
        [self showHUDAlert:NSLocalizedString(@"alertInputPasswordError", nil)];
        return;
    }
    if (self.threeTextField.text.length == 0) {
        [self showHUDAlert:NSLocalizedString(@"alertInputAgainPassword", nil)];
        return;
    }
    if (![self.threeTextField.text isEqualToString:self.twoTextField.text]) {
        [self showHUDAlert:NSLocalizedString(@"alertInputAgainPasswordError", nil)];
        return;
    }
    
    [self loadingHUDAlert];
    NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
    [dicOne setObject:self.oneTextField.text forKey:@"username"];
    [[ServiceRequest sharedService] GET:@"/api/auth/check/username" parameters:dicOne success:^(id responseObject) {
        NSMutableDictionary *dicTwo = [[NSMutableDictionary alloc] init];
        [dicTwo setObject:self.oneTextField.text forKey:@"username"];
        [dicTwo setObject:md5EncryptionString(self.twoTextField.text) forKey:@"password"];
        [dicTwo setObject:self.content forKey:@"user"];
        [dicTwo setObject:self.codeStr forKey:@"code"];
        [[ServiceRequest sharedService] POSTJSON:@"/api/auth/register" parameters:dicTwo success:^(id responseObject) {
            [self showHUDAlert:NSLocalizedString(@"alertRegisterSuccess", nil)];
            [self performSelector:@selector(goHomeViewCon) withObject:self afterDelay:1.5f];
        } failure:^(NSString *error, NSInteger code) {
            [self showHUDAlert:error];
        }];
    } failure:^(NSString *error, NSInteger code) {
        [self showHUDAlert:error];
    }];
}

- (void)goHomeViewCon{
    UserLoginRecord *user = [[UserLoginRecord alloc] init];
    user.loginType = 1;
    user.username = self.oneTextField.text;
    user.password = self.twoTextField.text;
    [UserManger setUserLoginRecord:user];
    [[LoadConfig shareStance] loadUserInfo:NO withUserLoginRecord:user];
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
