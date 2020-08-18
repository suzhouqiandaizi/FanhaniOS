//
//  WeChatRegisterBindViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/7/31.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "WeChatRegisterBindViewController.h"
#import "UIColor+Hexadecimal.h"
#import "AreaCodeChooseViewController.h"

@interface WeChatRegisterBindViewController (){
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
@property (weak, nonatomic) IBOutlet UIButton *hasAccountButton;

@property (strong, nonatomic) NSTimer     *timer;
@property (assign, nonatomic) NSInteger   count;

@end

@implementation WeChatRegisterBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self.scrollView setFrame:CGRectMake(0, IS_iPhoneX_Top + 100 , SCREEN_WIDTH_DEVICE, self.scrollView.frame.size.height)];
    
    self.phoneTextField.placeholder = NSLocalizedString(@"phoneNumber", nil);
    self.codeTextField.placeholder = NSLocalizedString(@"verificationCode", nil);
    [self.codeBtn setTitle:NSLocalizedString(@"sendVerificationCode", nil) forState:UIControlStateNormal];
    [self.sureBtn setTitle:NSLocalizedString(@"bindInfo", nil) forState:UIControlStateNormal];
    if (self.type == 1) {
        self.titleLabel.text = NSLocalizedString(@"pleaseInputYourPhonenumber", nil);
        self.hasAccountButton.hidden = YES;
    }else{
        self.titleLabel.text = NSLocalizedString(@"bindUsername", nil);
        self.hasAccountButton.hidden = NO;
        NSString *buttonStr = NSLocalizedString(@"noAccountAndBind", nil);
        CGSize labelSize = [buttonStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE, MAX_INPUT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size;
        [self.hasAccountButton setFrame:CGRectMake(SCREEN_WIDTH_DEVICE - labelSize.width - 25, self.hasAccountButton.frame.origin.y, labelSize.width, self.hasAccountButton.frame.size.height)];
        [self.hasAccountButton setTitle:buttonStr forState:UIControlStateNormal];
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
}

- (IBAction)hasAccountPress {
    [self goBackAction];
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
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%@-%@", currentAreaCode, self.phoneTextField.text] forKey:@"user"];
    [dic setObject:self.codeTextField.text forKey:@"code"];
    [[ServiceRequest sharedService] GET:@"/api/auth/check/code" parameters:dic success:^(id responseObject) {

        NSMutableDictionary *item = [NSMutableDictionary dictionary];
        [item setObject:self.codeTextField.text forKey:@"code"];
        [item setObject:[NSString stringWithFormat:@"%@-%@", self->currentAreaCode, self.phoneTextField.text] forKey:@"phone"];
        [item setObject:self.oauthStr forKey:@"oauth"];
        [item setObject:self.openIDStr forKey:@"openID"];
        [item setObject:self.tokenStr forKey:@"token"];
        if (self.usernameStr) {
            [item setObject:self.usernameStr forKey:@"username"];
        }
        [[ServiceRequest sharedService] POSTJSON:@"/api/user/oauth/third/bind" parameters:item success:^(id responseObject) {
            [self hideHudAlert];
            UserLoginRecord *user = [[UserLoginRecord alloc] init];
            user.loginType = 2;
            user.username = @"wechat";
            user.wxOauth = self.oauthStr;
            user.wxToken = self.tokenStr;
            user.wxOpenId = self.openIDStr;
            [UserManger setUserLoginRecord:user];
            [[LoadConfig shareStance] loadUserInfo:NO withUserLoginRecord:user];
        } failure:^(NSString *error, NSInteger code) {
            [self showHUDAlert:error];
        }];
        
    } failure:^(NSString *error, NSInteger code) {
        [self showHUDAlert:error];
    }];
    
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
