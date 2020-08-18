//
//  LoginViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/7/29.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "LoginViewController.h"
#import "Lottie.h"
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "ForgetPasswordViewController.h"
#import "DHGuidePageHUD.h"
#import "GlobalFunction.h"
#import "RegisterPhoneViewController.h"
#import "RegisterEmailViewController.h"
#import "WXApi.h"
#import "WeChatRegisterViewController.h"
#import "UserLoginRecord.h"
#import "LoginRecordView.h"
#import "LoginPrivacyProtocolView.h"
#import "WebShowViewController.h"
#import "CustomTextField.h"

#define BOOLFORKEY @"dhGuidePage"
@interface LoginViewController ()<UITextFieldDelegate>{
    LOTAnimatedSwitch *loginBtnBgView;
    BOOL    hasLogin;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *nameView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet CustomTextField *nameTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *chooseUserBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *otherLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *loginBtnView;
@property (weak, nonatomic) IBOutlet UIButton *showPasswordBtn;

@property (assign, nonatomic) BOOL        nameInputBool;
@property (assign, nonatomic) BOOL        passwordInputBool;
@property (strong, nonatomic) LoginRecordView        *loginRecordView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.fd_prefersNavigationBarHidden = YES;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
        [DEFAULTS setBool:YES forKey:BOOLFORKEY];
        NSArray *imageNameArray = @[@"guide0.png",@"guide1.png",@"guide2.png"];
        DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE) imageNameArray:imageNameArray buttonIsHidden:NO];
        guidePage.slideInto = YES;
        [self.navigationController.view addSubview:guidePage];
        [DEFAULTS synchronize];
    }
    
    [self.contentView setFrame:CGRectMake(0, IS_iPhoneX_Top + 100 , SCREEN_WIDTH_DEVICE, self.contentView.frame.size.height)];
    [self.bottomView setFrame:CGRectMake(0, SCREEN_HEIGHT_DEVICE - IS_iPhoneX_Bottom - self.bottomView.frame.size.height - 20, SCREEN_WIDTH_DEVICE, self.bottomView.frame.size.height)];
    [self.titleBtn setTitle:[NSString stringWithFormat:@"  %@", NSLocalizedString(@"companyName", nil)] forState:UIControlStateNormal];
    self.nameTextField.placeholder = NSLocalizedString(@"nameTextFieldPlaceholder", nil);
    self.passwordTextField.placeholder = NSLocalizedString(@"passwordTextFieldPlaceholder", nil);
    self.nameView.layer.masksToBounds = YES;
    self.nameView.layer.cornerRadius = 25.0f;
    self.passwordView.layer.masksToBounds = YES;
    self.passwordView.layer.cornerRadius = 25.0f;
    
    [self.otherLoginBtn setTitle:NSLocalizedString(@"otherLoginButton", nil) forState:UIControlStateNormal];
    [self.forgetPasswordBtn setTitle:NSLocalizedString(@"forgetPasswordButton", nil) forState:UIControlStateNormal];
    [self.registerBtn setTitle:NSLocalizedString(@"registerButton", nil) forState:UIControlStateNormal];
    float loginBtnWidth = 80;
    self.loginBtnView.layer.masksToBounds = YES;
    self.loginBtnView.layer.cornerRadius = loginBtnWidth/2.0;
    [self.loginBtnView setFrame:CGRectMake((SCREEN_WIDTH_DEVICE - loginBtnWidth)/2.0, self.loginBtnView.frame.origin.y, loginBtnWidth, loginBtnWidth)];
    loginBtnBgView = [LOTAnimatedSwitch switchNamed:@"data"];
    loginBtnBgView.bounds = CGRectMake(0, 0, loginBtnWidth, loginBtnWidth);
    loginBtnBgView.animationView.loopAnimation = YES;
    [loginBtnBgView.animationView play];
    [self.loginBtnView addSubview:loginBtnBgView];
    [self.loginBtnView bringSubviewToFront:self.loginBtn];
    
    hasLogin = NO;
    self.showPasswordBtn.hidden = YES;
    self.loginBtn.userInteractionEnabled = NO;
    loginBtnBgView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"wx_pay" object:nil];
    
    self.loginRecordView = [[LoginRecordView alloc] initItem:CGRectMake(self.passwordView.frame.origin.x, self.passwordView.frame.origin.y + self.contentView.frame.origin.y, SCREEN_WIDTH_DEVICE - 2 * self.passwordView.frame.origin.x, 0)];
    __weak LoginViewController *viewCon = self;
    self.loginRecordView.ChooseHandle = ^(UserLoginRecord * _Nonnull user) {
        viewCon.nameTextField.text = user.username;
        viewCon.passwordTextField.text = user.password;
        viewCon.nameInputBool = YES;
        viewCon.passwordInputBool = YES;
        [viewCon setLoginBtnClick];
        viewCon.loginRecordView.hidden = YES;
        [viewCon refreshShowLoginRecordView];
    };
    self.loginRecordView.HidenHandle = ^{
        viewCon.loginRecordView.hidden = YES;
        [viewCon refreshShowLoginRecordView];
        viewCon.chooseUserBtn.hidden = YES;
    };
    [self.view addSubview:self.loginRecordView];
    self.loginRecordView.hidden = YES;
    
    UserInfo *user = [UserManger currentLoggedInUser];
    UserLoginRecord *record = user.record;
    if (record) {
        if (record.loginType == 1) {
            [self autoLogin:record];
        }else if (record.loginType == 2) {
            [self autoWechatLogin:record];
        }else{
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"remove_launch" object:nil]];
        }
    }else{
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"remove_launch" object:nil]];
    }
    
    if (![DEFAULTS boolForKey:@"SHOWPRIVACYPROTOCOL"]) {
        LoginPrivacyProtocolView *alertView = [[LoginPrivacyProtocolView alloc] initItem];
        alertView.ClikcHandle = ^(NSString * _Nonnull url) {
            WebShowViewController *viewCon = [[WebShowViewController alloc] initWithNibName:@"WebShowViewController" bundle:nil];
            viewCon.urlStr = url;
            [self.navigationController pushViewController:viewCon animated:YES];
        };
        [self.view addSubview:alertView];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionaryWithDictionary:[UserManger getUserLoginedRecord]];
    [contentDic removeObjectForKey:@"wechat"];
    [contentDic removeObjectForKey:@"quick"];
    if ([contentDic count] > 0) {
        self.chooseUserBtn.hidden = NO;
    }else{
        self.chooseUserBtn.hidden = YES;
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:19.0f]}];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:getColorToImage([UIColor whiteColor]) forBarMetrics:UIBarMetricsDefault];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"remove_launch" object:nil];
}

- (IBAction)loginPress {
    [self loadingHUDAlert];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.nameTextField.text forKey:@"user"];
    [dic setObject:md5EncryptionString(self.passwordTextField.text) forKey:@"password"];
    [[ServiceRequest sharedService] POSTJSON:@"/api/auth/login" parameters:dic success:^(id responseObject) {
        [self hideHudAlert];
        UserLoginRecord *user = [[UserLoginRecord alloc] init];
        user.loginType = 1;
        user.username = self.nameTextField.text;
        user.password = self.passwordTextField.text;
        [UserManger setUserLoginRecord:user];
        [[LoadConfig shareStance] loadUserInfo:NO withUserLoginRecord:user];
    } failure:^(NSString *error, NSInteger code) {
        [self showHUDAlert:error];
    }];
}

- (IBAction)showPasswordPress {
    self.showPasswordBtn.selected = !self.showPasswordBtn.selected;
    self.passwordTextField.secureTextEntry = !self.showPasswordBtn.selected;
}

- (IBAction)chooseUserPress {
    self.loginRecordView.hidden = !self.loginRecordView.hidden;
    [self refreshShowLoginRecordView];
}

- (void)refreshShowLoginRecordView{
    if (self.loginRecordView.hidden) {
        self.passwordView.hidden = NO;
        self.loginBtnView.hidden = NO;
        [UIView
        animateWithDuration:0.3
        animations:^{
            self.chooseUserBtn.imageView.transform = CGAffineTransformMakeRotation(2*M_PI);
        }completion:^(BOOL finished) {
            
        }];
    }else{
        [self.view endEditing:YES];
        self.passwordView.hidden = YES;
        self.loginBtnView.hidden = YES;
        [self.loginRecordView showContent];
        [UIView
        animateWithDuration:0.3
        animations:^{
            self.chooseUserBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }completion:^(BOOL finished) {
            
        }];
    }
}

- (IBAction)otherLoginPress {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancelButton", nil) style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *phoneType = [UIAlertAction actionWithTitle:NSLocalizedString(@"phoneLoginType", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ForgetPasswordViewController *viewCon = [[ForgetPasswordViewController alloc] initWithNibName:@"ForgetPasswordViewController" bundle:nil];
        viewCon.type = LoginRegisterType_default;
        [self.navigationController pushViewController:viewCon animated:YES];
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:phoneType];
    if ([ShareSDK isClientInstalled:SSDKPlatformSubTypeWechatSession]) {
        UIAlertAction *wechatType = [UIAlertAction actionWithTitle:NSLocalizedString(@"wechatLoginType", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self wechatAuthAction];
        }];
        [alertVC addAction:wechatType];
    }
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (IBAction)forgetPasswordPress {
    ForgetPasswordViewController *viewCon = [[ForgetPasswordViewController alloc] initWithNibName:@"ForgetPasswordViewController" bundle:nil];
    viewCon.type = LoginRegisterType_forgot;
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (IBAction)registerPress {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancelButton", nil) style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *phoneType = [UIAlertAction actionWithTitle:NSLocalizedString(@"phoneRegisterType", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RegisterPhoneViewController *viewCon = [[RegisterPhoneViewController alloc] initWithNibName:@"RegisterPhoneViewController" bundle:nil];
        [self.navigationController pushViewController:viewCon animated:YES];
    }];
    UIAlertAction *emailType = [UIAlertAction actionWithTitle:NSLocalizedString(@"emailRegisterType", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RegisterEmailViewController *viewCon = [[RegisterEmailViewController alloc] initWithNibName:@"RegisterEmailViewController" bundle:nil];
        [self.navigationController pushViewController:viewCon animated:YES];
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:phoneType];
    [alertVC addAction:emailType];

    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark---uitextfieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.loginRecordView.hidden = YES;
    self.passwordView.hidden = NO;
    self.loginBtnView.hidden = NO;
    [self refreshShowLoginRecordView];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.loginRecordView.hidden = YES;
    self.passwordView.hidden = NO;
    self.loginBtnView.hidden = NO;
    [self refreshShowLoginRecordView];
    if (textField == self.nameTextField) {
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 0) {
            self.nameInputBool = YES;
        }else{
            self.nameInputBool = NO;
        }
    }else if (textField == self.passwordTextField){
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 0) {
            self.passwordInputBool = YES;
            self.showPasswordBtn.hidden = NO;
        }else{
            self.passwordInputBool = NO;
            self.showPasswordBtn.hidden = YES;
        }
    }
    [self setLoginBtnClick];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (textField == self.nameTextField) {
        self.nameInputBool = NO;
    }else if (textField == self.passwordTextField){
        self.passwordInputBool = NO;
    }
    self.loginBtn.userInteractionEnabled = NO;
    loginBtnBgView.hidden = YES;
    self.showPasswordBtn.hidden = YES;
    return YES;
}

- (void)setLoginBtnClick{
    if (self.nameInputBool && self.passwordInputBool) {
        self.loginBtn.userInteractionEnabled = YES;
        loginBtnBgView.hidden = NO;
    }else{
        self.loginBtn.userInteractionEnabled = NO;
        loginBtnBgView.hidden = YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.loginRecordView.hidden = YES;
    self.passwordView.hidden = NO;
    self.loginBtnView.hidden = NO;
    [self refreshShowLoginRecordView];
    [self.view endEditing:YES];
}

#pragma mark---微信登录
- (void)wechatAuthAction{
    if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.state = @"wx_oauth_authorization_state";//用于保持请求和回调的状态，授权请求或原样带回
        req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
        //发送请求
        [WXApi sendReq:req completion:^(BOOL success) {
            NSLog(@"唤起微信:%@", success ? @"成功" : @"失败");
        }];
    }else{
        [self showHUDAlert:@"未安装微信应用或版本过低"];
    }
}

#pragma mark -微信结果回调
-(void)getOrderPayResult:(NSNotification *)notification{
    SendAuthResp *req = notification.object;
    [self getWeiXinOpenId:req.code];
}

//通过code获取access_token，openid，unionid
- (void)getWeiXinOpenId:(NSString *)code{
    /*
     appid    是    应用唯一标识，在微信开放平台提交应用审核通过后获得
     secret    是    应用密钥AppSecret，在微信开放平台提交应用审核通过后获得
     code    是    填写第一步获取的code参数
     grant_type    是    填authorization_code
     */
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAppId,WXAppSecret,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data1 = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        
        if (!data1) {
            [self showHUDAlert:@"微信授权失败"];
            return ;
        }
        
        // 授权成功，获取token、openID字典
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"token、openID字典===%@",dic);
        NSString *access_token = dic[@"access_token"];
        NSString *openid= dic[@"openid"];
        
        //         获取微信用户信息
        [self getUserInfoWithAccessToken:access_token WithOpenid:openid];
        
    });
}

-(void)getUserInfoWithAccessToken:(NSString *)access_token WithOpenid:(NSString *)openid
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 获取用户信息失败
            if (!data) {
                [self showHUDAlert:@"微信授权失败"];
                return ;
            }
            // 获取用户信息字典
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //用户信息中没有access_token 我将其添加在字典中
            [dic setValue:access_token forKey:@"token"];
            [self requestWeChatLogin:dic];
        });
    });
}

- (void)requestWeChatLogin:(NSDictionary *)dic{
    [self loadingHUDAlert];
    NSMutableDictionary *item = [NSMutableDictionary dictionary];
    [item setObject:@"weixin" forKey:@"oauth"];
    [item setObject:[dic objectForKey:@"openid"] forKey:@"openID"];
    [item setObject:[dic objectForKey:@"token"] forKey:@"token"];
    [[ServiceRequest sharedService] POSTJSON:@"/api/user/oauth/third/login" parameters:item success:^(id responseObject) {
        [self hideHudAlert];
        UserLoginRecord *user = [[UserLoginRecord alloc] init];
        user.loginType = 2;
        user.username = @"wechat";
        user.wxOauth = @"weixin";
        user.wxToken = [dic objectForKey:@"token"];
        user.wxOpenId = [dic objectForKey:@"openid"];
        [UserManger setUserLoginRecord:user];
        [[LoadConfig shareStance] loadUserInfo:NO withUserLoginRecord:user];
    } failure:^(NSString *error, NSInteger code) {
        [self showHUDAlert:error];
        if (code == 10014) {
            WeChatRegisterViewController *viewCon = [[WeChatRegisterViewController alloc] initWithNibName:@"WeChatRegisterViewController" bundle:nil];
            viewCon.oauthStr = @"weixin";
            viewCon.openIDStr = [dic objectForKey:@"openid"];
            viewCon.tokenStr = [dic objectForKey:@"token"];
            [self.navigationController pushViewController:viewCon animated:YES];
        }
    }];
}

- (void)autoLogin:(UserLoginRecord *)record{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:record.username forKey:@"user"];
    [dic setObject:md5EncryptionString(record.password) forKey:@"password"];
    [[ServiceRequest sharedService] POSTJSON:@"/api/auth/login" parameters:dic success:^(id responseObject) {
        [[LoadConfig shareStance] loadUserInfo:YES withUserLoginRecord:record];
    } failure:^(NSString *error, NSInteger code) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"remove_launch" object:nil]];
    }];
}

- (void)autoWechatLogin:(UserLoginRecord *)record{
    NSMutableDictionary *item = [NSMutableDictionary dictionary];
    [item setObject:record.wxOauth forKey:@"oauth"];
    [item setObject:record.wxOpenId forKey:@"openID"];
    [item setObject:record.wxToken forKey:@"token"];
    [[ServiceRequest sharedService] POSTJSON:@"/api/user/oauth/third/login" parameters:item success:^(id responseObject) {
        [[LoadConfig shareStance] loadUserInfo:YES withUserLoginRecord:record];
    } failure:^(NSString *error, NSInteger code) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"remove_launch" object:nil]];
    }];
}

@end
