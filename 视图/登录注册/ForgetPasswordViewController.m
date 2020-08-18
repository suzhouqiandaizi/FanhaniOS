//
//  ForgetPasswordViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/7/30.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "UIColor+Hexadecimal.h"
#import "GlobalFunction.h"
#import "AreaCodeChooseViewController.h"
#import "SetNewPasswordViewController.h"

@interface ForgetPasswordViewController (){
    NSString *currentAreaCode;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *areaCoedBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (strong, nonatomic) NSTimer     *timer;
@property (assign, nonatomic) NSInteger   count;
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self.scrollView setFrame:CGRectMake(0, IS_iPhoneX_Top + 100 , SCREEN_WIDTH_DEVICE, self.scrollView.frame.size.height)];
    self.titleLabel.text = NSLocalizedString(@"pleaseInputYourPhonenumber", nil);
    self.phoneTextField.placeholder = NSLocalizedString(@"phoneNumber", nil);
    self.codeTextField.placeholder = NSLocalizedString(@"verificationCode", nil);
    [self.codeBtn setTitle:NSLocalizedString(@"sendVerificationCode", nil) forState:UIControlStateNormal];
    if (self.type == LoginRegisterType_forgot) {
        [self.sureBtn setTitle:NSLocalizedString(@"nextButton", nil) forState:UIControlStateNormal];
    }else{
        [self.sureBtn setTitle:NSLocalizedString(@"loginButton", nil) forState:UIControlStateNormal];
    }
    
    self.phoneView.layer.masksToBounds = YES;
    self.phoneView.layer.cornerRadius = 3.0f;
    self.phoneView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.phoneView.layer.borderWidth = 0.5f;
    self.codeView.layer.masksToBounds = YES;
    self.codeView.layer.cornerRadius = 3.0f;
    self.codeView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.codeView.layer.borderWidth = 0.5f;
    
    [self.sureBtn setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE - 50, 44) direction:GradientChangeDirectionLevel startColor:[UIColor colorWithHex:0xff59bbff] endColor:[UIColor colorWithHex:0xff4a88ff]] forState:UIControlStateNormal];
    [self.codeBtn setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(125, 44) direction:GradientChangeDirectionLevel startColor:[UIColor colorWithHex:0xff59bbff] endColor:[UIColor colorWithHex:0xff4a88ff]] forState:UIControlStateNormal];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 3.0f;
    
    currentAreaCode = @"86";
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)surePress {
    if (self.phoneTextField.text.length == 0) {
        [self showHUDAlert:NSLocalizedString(@"alertInputPhone", nil)];
        return;
    }
    if (self.codeTextField.text.length == 0) {
        [self showHUDAlert:NSLocalizedString(@"alertInputCode", nil)];
        return;
    }
    [self loadingHUDAlert];
    
    if (self.type == LoginRegisterType_forgot) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSString stringWithFormat:@"%@-%@", currentAreaCode, self.phoneTextField.text] forKey:@"user"];
        [dic setObject:self.codeTextField.text forKey:@"code"];
        [[ServiceRequest sharedService] GET:@"/api/auth/check/code" parameters:dic success:^(id responseObject) {
            [self hideHudAlert];
            SetNewPasswordViewController *viewCon = [[SetNewPasswordViewController alloc] initWithNibName:@"SetNewPasswordViewController" bundle:nil];
            viewCon.phoneStr = [NSString stringWithFormat:@"%@-%@", self->currentAreaCode, self.phoneTextField.text];
            [self.navigationController pushViewController:viewCon animated:YES];
        } failure:^(NSString *error, NSInteger code) {
            [self showHUDAlert:error];
        }];
    }else{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSString stringWithFormat:@"%@-%@", currentAreaCode, self.phoneTextField.text] forKey:@"phone"];
        [dic setObject:self.codeTextField.text forKey:@"code"];
        [[ServiceRequest sharedService] POSTJSON:@"/api/login/quick" parameters:dic success:^(id responseObject) {
            [self hideHudAlert];
            UserLoginRecord *user = [[UserLoginRecord alloc] init];
            user.loginType = 3;
            user.username = @"quick";
            [UserManger setUserLoginRecord:user];
            [[LoadConfig shareStance] loadUserInfo:NO withUserLoginRecord:user];
        } failure:^(NSString *error, NSInteger code) {
            [self showHUDAlert:error];
        }];
    }
    
}

- (IBAction)areaCodePress {
    AreaCodeChooseViewController *viewCon = [[AreaCodeChooseViewController alloc] initWithNibName:@"AreaCodeChooseViewController" bundle:nil];
    viewCon.RefreshHandle = ^(NSString * _Nonnull item) {
        self->currentAreaCode = item;
        [self.areaCoedBtn setTitle:[NSString stringWithFormat:@"+%@", item] forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (IBAction)codePress {
    if (self.phoneTextField.text.length == 0) {
        [self showHUDAlert:NSLocalizedString(@"alertInputPhone", nil)];
        return;
    }
    
    [self.codeBtn setTitle:NSLocalizedString(@"gettingCode", nil) forState:UIControlStateNormal];
    self.codeBtn.userInteractionEnabled = NO;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%@-%@", currentAreaCode, self.phoneTextField.text] forKey:@"user"];
    [[ServiceRequest sharedService] GET:@"/api/auth/send/code" parameters:dic success:^(id responseObject) {
        self.count = 60;
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(updateTime)
                                               userInfo:nil
                                                repeats:YES];
    } failure:^(NSString *error, NSInteger code) {
        [self showHUDAlert:error];
        [self.codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        self.codeBtn.userInteractionEnabled = YES;
    }];
}

#pragma mark 更新时间
-(void)updateTime
{
    self.count--;
    if (self.count > 0) {
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)self.count] forState:UIControlStateNormal];
        self.codeBtn.userInteractionEnabled = NO;
        return;
    }
    else{
        self.codeBtn.userInteractionEnabled = YES;
        [self.codeBtn setTitle:NSLocalizedString(@"againSendCode", nil) forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
