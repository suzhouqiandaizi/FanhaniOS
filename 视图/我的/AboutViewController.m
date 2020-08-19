//
//  AboutViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/12.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "AboutViewController.h"
#import "UIColor+Hexadecimal.h"
#import "WebShowViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:ViewBackgroundColor];
    [self addWhiteBackBtn];
    self.title = NSLocalizedString(@"personMenuAboutOur", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:19.0f]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE, 64 + IS_iPhoneX_Top) direction:GradientChangeDirectionVertical startColor:[UIColor colorWithHex:0xff2567E7] endColor:[UIColor colorWithHex:0xff427DF6]] forBarMetrics:UIBarMetricsDefault];
    
    [self.contentView setFrame:CGRectMake(0, 64 + IS_iPhoneX_Top + 10, SCREEN_WIDTH_DEVICE, self.contentView.frame.size.height)];
    self.versionLabel.text = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    self.oneLabel.text = NSLocalizedString(@"settingAppVersion", nil);
    self.twoLabel.text = NSLocalizedString(@"settingServiceAgreemnet", nil);
    self.threeLabel.text = NSLocalizedString(@"settingPrivacyPolicy", nil);
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)twoPress {
    WebShowViewController *viewCon = [[WebShowViewController alloc] initWithNibName:@"WebShowViewController" bundle:nil];
    viewCon.whiteBackBtn = YES;
    viewCon.urlStr = [NSString stringWithFormat:@"%@/agreement/worker", HOSTURL];
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (IBAction)threePress {
    WebShowViewController *viewCon = [[WebShowViewController alloc] initWithNibName:@"WebShowViewController" bundle:nil];
    viewCon.whiteBackBtn = YES;
    viewCon.urlStr = [NSString stringWithFormat:@"%@/agreement/privacy", HOSTURL];
    [self.navigationController pushViewController:viewCon animated:YES];
}

@end
