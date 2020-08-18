//
//  ShareThirdViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/13.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "ShareThirdViewController.h"
#import "UIColor+Hexadecimal.h"
#import "ShareView.h"

@interface ShareThirdViewController (){
    float                      bgImageViewHeight;
    NSString                   *contentStr;
    NSString                   *titleStr;
    NSString                   *urlStr;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;

@end

@implementation ShareThirdViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.fd_prefersNavigationBarHidden = YES;
    [self.backBtn setFrame:CGRectMake(0, 20 + IS_iPhoneX_Top, 44, 44)];
    [self.scrollView setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE)];
    bgImageViewHeight = (864/1080.0)*SCREEN_WIDTH_DEVICE;
    [self.bgImageView setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, bgImageViewHeight)];
    
    self.stepsLabel.text = NSLocalizedString(@"shareParticipationSteps", nil);
    self.oneLabel.text = NSLocalizedString(@"shareInviteFriends", nil);
    self.twoLabel.text = NSLocalizedString(@"shareSignUpAndComplete", nil);
    self.threeLabel.text = NSLocalizedString(@"shareGetAllRewards", nil);
    self.ruleLabel.text = NSLocalizedString(@"shareRules", nil);
    [self.sureBtn setTitle:NSLocalizedString(@"shareInviteButton", nil) forState:UIControlStateNormal];
    self.textView.text = NSLocalizedString(@"shareRulesContent", nil);
    
    [self.sureBtn setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(130, 40) direction:GradientChangeDirectionLevel startColor:[UIColor colorWithHex:0xfff2c958] endColor:[UIColor colorWithHex:0xffe4853a]] forState:UIControlStateNormal];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 20.0f;
    
    self.scrollView.alwaysBounceVertical = YES;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13],
                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.textView.text attributes:attributes];
    self.textView.attributedText = attributeStr;
    
    CGSize labelSize = [self.textView sizeThatFits:CGSizeMake(SCREEN_WIDTH_DEVICE - 30, MAXFLOAT)];
    [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, labelSize.width, labelSize.height)];
    [self.contentView setFrame:CGRectMake(0, bgImageViewHeight, SCREEN_WIDTH_DEVICE, self.textView.frame.origin.y + self.textView.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH_DEVICE, self.contentView.frame.size.height + bgImageViewHeight + 20)];
 
    contentStr = @"海量任务，丰厚奖励，你还在等什么？";
    titleStr = @"【泛函沃客】邀请好友，一起来赚零花钱";
    urlStr = @"";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[ServiceRequest sharedService] GET:@"/api/user/invite" parameters:nil success:^(id responseObject) {
        self->urlStr = [responseObject objectForKey:@"data"];
    } failure:^(NSString *error, NSInteger code) {
        
    }];
}

- (void)dealloc{
    [[ServiceRequest sharedService] cancelDataTaskForKey:@"/api/user/invite"];
}


- (IBAction)surePrerss {
    if (urlStr.length > 0) {
        ShareView *shareView = [[ShareView alloc] initItemContent:contentStr withTitle:titleStr withUrl:urlStr withShareicon:nil];
        [self.view.window addSubview:shareView];
    }else{
        [self showHUDAlert:@"分享失败"];
    }
    
}

- (IBAction)backPress {
    [self goBackAction];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
    NSLog(@"=========%f", yOffset);
    if (yOffset <= 0) {
        CGFloat factor = ((ABS(yOffset)+(bgImageViewHeight ))*SCREEN_WIDTH_DEVICE)/(bgImageViewHeight);
        CGRect f = CGRectMake((SCREEN_WIDTH_DEVICE - factor)/2.0, 0, factor, (bgImageViewHeight)+ABS(yOffset));
        self.bgImageView.frame = f;
    } else {
        CGRect f = self.bgImageView.frame;
        f.origin.y = -yOffset + (0);
        self.bgImageView.frame = f;
    }
}
@end
