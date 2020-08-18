//
//  PersonViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/4.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "PersonViewController.h"
#import "TabBarView.h"
#import "GlobalFunction.h"
#import "UIColor+Hexadecimal.h"
#import "SRRefreshView.h"
#import "SDCycleScrollView.h"
#import "CustomIOSAlertView.h"
#import "CustomInfoAlertView.h"
#import "UIImageView+WebCache.h"
#import "AboutViewController.h"
#import "ShareThirdViewController.h"
#import "NewbieViewController.h"
#import "CoinDetailViewController.h"
#import "DaySignViewController.h"
#import <UMCommon/MobClick.h>

@interface PersonViewController ()<SRRefreshDelegate, SDCycleScrollViewDelegate, UIGestureRecognizerDelegate>{
    TabBarView                 *tabBarView;
    float                      bgImageViewHeight;
    BOOL                       reload;
}
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *medalBtn;
@property (weak, nonatomic) IBOutlet UIImageView *medalLine;
@property (weak, nonatomic) IBOutlet UIButton *authBtn;
@property (weak, nonatomic) IBOutlet UIView *coinView;
@property (weak, nonatomic) IBOutlet UIImageView *coinLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *coinTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneDot;
@property (weak, nonatomic) IBOutlet UILabel *twoDot;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *conversionLabel;
@property (nonatomic, strong) SRRefreshView         *slimeView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *coinTixianBtn;
@property (weak, nonatomic) IBOutlet UIButton *coinBillBtn;
@property (weak, nonatomic) IBOutlet UIButton *coinMingxiBtn;
@property (weak, nonatomic) IBOutlet UILabel *menuSettingLabel;
@property (weak, nonatomic) IBOutlet UILabel *menuAboutLabel;
@property (weak, nonatomic) IBOutlet UILabel *menuNoiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *menuFeedbackLabel;
@property (weak, nonatomic) IBOutlet UILabel *menuKefuLabel;
@property (weak, nonatomic) IBOutlet UILabel *menuLogoutLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    tabBarView = [TabBarView sharedTabBarView];
    [self.navigationItem setHidesBackButton:YES];
    
    bgImageViewHeight = 180 + IS_iPhoneX_Top;
    [self.bgImageView setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, bgImageViewHeight)];
    [self.scrollView setFrame:CGRectMake(0, 20 + IS_iPhoneX_Top, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE - IS_iPhoneX_Bottom - 55 - IS_iPhoneX_Top - 20)];
    self.scrollView.alwaysBounceVertical = YES;
    [self.scrollView addSubview:self.slimeView];
    
    NSString *medalStr = NSLocalizedString(@"personMedalBtn", nil);
    CGSize labelSize = [medalStr boundingRectWithSize:CGSizeMake(200, MAX_INPUT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size;
    [self.medalBtn setFrame:CGRectMake(self.medalBtn.frame.origin.x, self.medalBtn.frame.origin.y, labelSize.width, self.medalBtn.frame.size.height)];
    [self.medalBtn setTitle:medalStr forState:UIControlStateNormal];
    [self.medalLine setFrame:CGRectMake(self.medalLine.frame.origin.x, self.medalLine.frame.origin.y, labelSize.width, 1)];
    
    NSString *authStr = NSLocalizedString(@"personAuthenticationBtn", nil);
    labelSize = [authStr boundingRectWithSize:CGSizeMake(200, MAX_INPUT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size;
    [self.authBtn setFrame:CGRectMake(SCREEN_WIDTH_DEVICE - labelSize.width - 26, self.authBtn.frame.origin.y, labelSize.width + 26, self.authBtn.frame.size.height)];
    [self.authBtn setTitle:authStr forState:UIControlStateNormal];
    [self.authBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -
     self.authBtn.imageView.frame.size.width, 0, self.authBtn.imageView.frame.size.width)];
    [self.authBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.authBtn.titleLabel.bounds.size.width, 0, - self.authBtn.titleLabel.bounds.size.width - 5)];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: self.authBtn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(13,13)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.authBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    self.authBtn.layer.mask = maskLayer;
    
    addShadowToView(self.coinView, 0.3, 10.0f, 10.0f);
    
    [self.coinLogoImageView setImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE, 64 + IS_iPhoneX_Top) direction:GradientChangeDirectionVertical startColor:[UIColor colorWithHex:0xffDE9B3D] endColor:[UIColor colorWithHex:0xffF7C56F]]];
    self.coinLogoImageView.layer.masksToBounds = YES;
    self.coinLogoImageView.layer.cornerRadius = 9.0f;
    
    self.oneDot.layer.masksToBounds = YES;
    self.oneDot.layer.cornerRadius = 2.0f;
    self.twoDot.layer.masksToBounds = YES;
    self.twoDot.layer.cornerRadius = 2.0f;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 5.0f;
    
    self.coinTitleLabel.text = NSLocalizedString(@"personCoinSurplusTitle", nil);
    self.conversionLabel.text = NSLocalizedString(@"personCoinConversion", nil);
    self.totalLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"personCoinTotal", nil), @"0"];
    [self.coinTixianBtn setTitle:NSLocalizedString(@"personCoinWithdrawal", nil) forState:UIControlStateNormal];
    [self.coinMingxiBtn setTitle:NSLocalizedString(@"personCoinDetailed", nil) forState:UIControlStateNormal];
    [self.coinBillBtn setTitle:NSLocalizedString(@"personCoinBill", nil) forState:UIControlStateNormal];
    self.menuSettingLabel.text = NSLocalizedString(@"personMenuSetting", nil);
    self.menuAboutLabel.text = NSLocalizedString(@"personMenuAboutOur", nil);
    self.menuNoiseLabel.text = NSLocalizedString(@"personMenuNoiseDetection", nil);
    self.menuFeedbackLabel.text = NSLocalizedString(@"personMenuFeedback", nil);
    self.menuKefuLabel.text = NSLocalizedString(@"personMenuCustomerService", nil);
    self.menuLogoutLabel.text = NSLocalizedString(@"personMenuLogout", nil);
    
    [self showBanner];
    
    [self.menuView setFrame:CGRectMake(20, self.bannerView.frame.origin.y + self.bannerView.frame.size.height + 10, SCREEN_WIDTH_DEVICE - 40, self.menuView.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH_DEVICE, self.menuView.frame.origin.y + self.menuView.frame.size.height + 55)];
    
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapToUserInfo)];
    tapRecognize.numberOfTapsRequired = 1;
    tapRecognize.delegate = self;
    [tapRecognize setEnabled :YES];
    [tapRecognize delaysTouchesBegan];
    [tapRecognize cancelsTouchesInView];
    [self.headerImageView addGestureRecognizer:tapRecognize];
    
    UITapGestureRecognizer *tapRecognize2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapToUserInfo)];
    tapRecognize2.numberOfTapsRequired = 1;
    tapRecognize2.delegate = self;
    [tapRecognize2 setEnabled :YES];
    [tapRecognize2 delaysTouchesBegan];
    [tapRecognize2 cancelsTouchesInView];
    [self.nameLabel addGestureRecognizer:tapRecognize2];
    
    if (!reload) {
        [self showUserInfo:NO];
        [self requestBalance];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.fd_interactivePopDisabled = YES;
    [self.view addSubview:tabBarView];
    [tabBarView setCurrentViewControllerIndex:3];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (reload) {
        [self refreshView];
    }else{
        reload = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.fd_interactivePopDisabled = NO;
}

- (void)refreshView{
    [self showUserInfo:YES];
    [self requestBalance];
}

- (void)showUserInfo:(BOOL)reload{
    if (reload) {
        [[ServiceRequest sharedService] GET:@"/api/user/profile" parameters:nil success:^(id responseObject) {
            UserInfo *user = [UserInfo mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            UserInfo *lastUser = [UserManger currentLoggedInUser];
            user.record = lastUser.record;
            [DEFAULTS setObject:user.username forKey:USERID];
            [DEFAULTS synchronize];
            [UserManger setUser:user];
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar]];
            self.nameLabel.text = user.username;
        } failure:^(NSString *error, NSInteger code) {
        }];
    }else{
        UserInfo *user = [UserManger currentLoggedInUser];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar]];
        self.nameLabel.text = user.username;
    }
    
}

- (void)requestBalance{
    [[ServiceRequest sharedService] GET:@"/api/user/balance" parameters:nil success:^(id responseObject){
        if ([currentLocaleLanuage() isEqualToString:@"zh"]) {
            self.coinLabel.text = [NSString stringWithFormat:@"%ld个", (long)[[[responseObject objectForKey:@"data"] objectForKey:@"balance"] integerValue]];
            self.coinLabel = changeLabelAttribute(self.coinLabel, self.coinLabel.text.length - 1, 0, TextColor, TextColor, 14.0, YES);
        }else{
            self.coinLabel.text = [NSString stringWithFormat:@"%ld", [[[responseObject objectForKey:@"data"] objectForKey:@"balance"] integerValue]];
        }
        NSLog(@"%@", currentLocaleLanuage());
    } failure:^(NSString *error, NSInteger code) {
        
    }];
}

- (void)handleTapToUserInfo{
    [MobClick event:@"WD_gerenxinxi"];
    [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"UserProfilePage" withArguments:nil];    
}

- (void)showBanner{
    float imageH = (95/640.0) * (SCREEN_WIDTH_DEVICE - 40);
    [self.bannerView setFrame:CGRectMake(20, self.bannerView.frame.origin.y, SCREEN_WIDTH_DEVICE - 40, imageH + 22)];
    self.bannerView.imageHeight = imageH;
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleEllipse;
    self.bannerView.currentPageDotColor = RGB(37, 103, 231);
    self.bannerView.pageDotColor = RGB(154, 154, 154);
    self.bannerView.showPageControl = YES;
    self.bannerView.hidden = NO;
    self.bannerView.delegate = self;
    self.bannerView.localizationImageNamesGroup = [NSArray arrayWithObjects:[UIImage imageNamed:@"person_banner_one"],[UIImage imageNamed:@"person_banner_two"], nil];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (index == 0) {
        [MobClick event:@"WD_ban_laxin"];
        ShareThirdViewController *viewCon = [[ShareThirdViewController alloc] initWithNibName:@"ShareThirdViewController" bundle:nil];
        [self.navigationController pushViewController:viewCon animated:YES];
    }else if (index == 1){
        [MobClick event:@"WD_ban_dalibao"];
        NewbieViewController *viewCon = [[NewbieViewController alloc] initWithNibName:@"NewbieViewController" bundle:nil];
        [self.navigationController pushViewController:viewCon animated:YES];
    }
}

- (IBAction)showMedalPress {
    [MobClick event:@"WD_xunzhang"];
    UserInfo *user = [UserManger currentLoggedInUser];
    [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"SkillsPage" withArguments:[NSDictionary dictionaryWithObject:user.avatar forKey:@"headImage"]];
}

- (IBAction)qiandaoPress {
    [MobClick event:@"WD_qiandao"];
    DaySignViewController *viewCon = [[DaySignViewController alloc] initWithNibName:@"DaySignViewController" bundle:nil];
    [self.navigationController pushViewController:viewCon animated:YES];}

- (IBAction)authPress {
    [MobClick event:@"WD_shiming"];
    UserInfo *user = [UserManger currentLoggedInUser];
    [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"AuthPage" withArguments:[NSDictionary dictionaryWithObject:user.avatar forKey:@"headImage"]];
}

- (IBAction)tixianPress {
    [MobClick event:@"WD_wallet_tixian"];
    [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"CashSelectPage" withArguments:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:[self.coinLabel.text integerValue]] forKey:@"balance"]];
}

- (IBAction)zhangdanPress {
    [MobClick event:@"WD_wallet_zhangdan"];
    [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"WithdrawLogPage" withArguments:nil];
}

- (IBAction)mingxiPress:(id)sender {
//    CoinDetailViewController *viewCon = [[CoinDetailViewController alloc] initWithNibName:@"CoinDetailViewController" bundle:nil];
//    [self.navigationController pushViewController:viewCon animated:YES];
    [MobClick event:@"WD_wallet_mingxi"];
    [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"IncomePage" withArguments:nil];
}


- (IBAction)settingPress {
    [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"AccountSettingPage" withArguments:nil];
}

- (IBAction)aboutPress {
    AboutViewController *viewCon = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (IBAction)noisePress {
    [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"NoiseMeterPage" withArguments:nil];
}

- (IBAction)feedbackPress {
    [MobClick event:@"WD_yijian"];
    [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"FeedbackPage" withArguments:nil];
}

- (IBAction)kefuPress {
    [MobClick event:@"WD_kefu"];
    UserInfo *user = [UserManger currentLoggedInUser];
    [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"CustomerServicePage" withArguments:[NSDictionary dictionaryWithObject:user.avatar forKey:@"headImage"]];
}

- (IBAction)logoutPress {
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    [alertView setContainerView:[[CustomInfoAlertView alloc] initItem:NSLocalizedString(@"alertLogout", nil) withTitle:NSLocalizedString(@"alertInfoTitle", nil)]];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:NSLocalizedString(@"cancelButton", nil),NSLocalizedString(@"alertExit", nil), nil]];
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [alertView close];
        if (buttonIndex == 0) {
            
        }else{
            [UserManger logoutCurrentUser];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    
    [alertView setUseMotionEffects:true];
    [self.view endEditing:YES];
    [alertView show];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_slimeView scrollViewDidScroll];
    CGFloat yOffset = scrollView.contentOffset.y;
    
    NSLog(@"=========%f", yOffset);
    if (yOffset <= 0) {
        CGFloat factor = ((ABS(yOffset)+(bgImageViewHeight ))*SCREEN_WIDTH_DEVICE)/(bgImageViewHeight);
        CGRect f = CGRectMake((SCREEN_WIDTH_DEVICE - factor)/2.0, 0, factor, (bgImageViewHeight)+ABS(yOffset));
        self.bgImageView.frame = f;
    } else {
//        if (yOffset < (bgImageViewHeight + IS_iPhoneX_Top)) {
            CGRect f = self.bgImageView.frame;
            f.origin.y = -yOffset + (0);
            self.bgImageView.frame = f;
//        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate
//刷新消息列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
//    [self showContentView];
    [_slimeView endRefresh];
}

- (SRRefreshView *)slimeView
{
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor whiteColor];
        _slimeView.slime.skinColor = [UIColor lightGrayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 0;
        _slimeView.slime.shadowColor = [UIColor clearColor];
        _slimeView.backgroundColor = [UIColor clearColor];
    }
    
    return _slimeView;
}


@end
