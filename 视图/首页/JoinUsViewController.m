//
//  JoinUsViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/18.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "JoinUsViewController.h"
#import "UIColor+Hexadecimal.h"

@interface JoinUsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation JoinUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:19.0f]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE, 64 + IS_iPhoneX_Top) direction:GradientChangeDirectionVertical startColor:[UIColor colorWithHex:0xff2567E7] endColor:[UIColor colorWithHex:0xff427DF6]] forBarMetrics:UIBarMetricsDefault];
    self.title = NSLocalizedString(@"joinUsTitle", nil);
    [self addWhiteBackBtn];
    [self.scrollView setFrame:CGRectMake(0, 64 + IS_iPhoneX_Top, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE - 64 - IS_iPhoneX_Top)];
    float imageHeight = (1531/750.0)*SCREEN_WIDTH_DEVICE;
    [self.imageView setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, imageHeight)];
    self.scrollView.alwaysBounceVertical = YES;
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH_DEVICE, imageHeight)];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
