//
//  SetNewPasswordViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/7/30.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "SetNewPasswordViewController.h"
#import "UIColor+Hexadecimal.h"
#import "GlobalFunction.h"

@interface SetNewPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *oneTextField;
@property (weak, nonatomic) IBOutlet UITextField *twoTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@end

@implementation SetNewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self.scrollView setFrame:CGRectMake(0, IS_iPhoneX_Top + 100 , SCREEN_WIDTH_DEVICE, self.scrollView.frame.size.height)];
    self.titleLabel.text = NSLocalizedString(@"setNewPassword", nil);
    self.oneTextField.placeholder = NSLocalizedString(@"setNewPasswordTextFieldPlaceholder", nil);
    self.twoTextField.placeholder = NSLocalizedString(@"setNewAgainPasswordTextFieldPlaceholder", nil);
    [self.sureBtn setTitle:NSLocalizedString(@"resetPasswordButton", nil) forState:UIControlStateNormal];
    
    self.oneView.layer.masksToBounds = YES;
    self.oneView.layer.cornerRadius = 3.0f;
    self.oneView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.oneView.layer.borderWidth = 0.5f;
    self.twoView.layer.masksToBounds = YES;
    self.twoView.layer.cornerRadius = 3.0f;
    self.twoView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.twoView.layer.borderWidth = 0.5f;
    
    [self.sureBtn setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE - 50, 44) direction:GradientChangeDirectionLevel startColor:[UIColor colorWithHex:0xff59bbff] endColor:[UIColor colorWithHex:0xff4a88ff]] forState:UIControlStateNormal];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 3.0f;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)surePress {
    if (self.oneTextField.text.length == 0) {
        [self showHUDAlert:NSLocalizedString(@"alertInputNewPassword", nil)];
        return;
    }
    if (self.oneTextField.text.length < 6) {
        [self showHUDAlert:NSLocalizedString(@"alertInputPasswordError", nil)];
        return;
    }
    if (self.twoTextField.text.length == 0) {
        [self showHUDAlert:NSLocalizedString(@"alertInputAgainPassword", nil)];
        return;
    }
    if (![self.oneTextField.text isEqualToString:self.twoTextField.text]) {
        [self showHUDAlert:NSLocalizedString(@"alertInputAgainPasswordError", nil)];
        return;
    }
    [self loadingHUDAlert];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:md5EncryptionString(self.oneTextField.text) forKey:@"password"];
    [dic setObject:self.phoneStr forKey:@"phone"];
    [[ServiceRequest sharedService] POSTJSON:@"/api/password/new" parameters:dic success:^(id responseObject) {
        [self showHUDAlert:NSLocalizedString(@"alertSuccess", nil)];
        [self performSelector:@selector(goBackToRootViewCon) withObject:self afterDelay:1.5f];
    } failure:^(NSString *error, NSInteger code) {
        [self showHUDAlert:error];
    }];
}

- (void)goBackToRootViewCon{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
