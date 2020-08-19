//
//  CoinDetailViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/17.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "CoinDetailViewController.h"
#import "SGPagingView.h"
#import "CoinTableViewController.h"
#import "UIColor+Hexadecimal.h"

@interface CoinDetailViewController ()<SGPageTitleViewDelegate, SGPageContentViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation CoinDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    self.title = NSLocalizedString(@"coinDetailed", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:19.0f]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE, 64 + IS_iPhoneX_Top) direction:GradientChangeDirectionVertical startColor:[UIColor colorWithHex:0xff2567E7] endColor:[UIColor colorWithHex:0xff427DF6]] forBarMetrics:UIBarMetricsDefault];
    [self addWhiteBackBtn];
    
    [self setupPageView];
    // Do any additional setup after loading the view from its nib.
}


- (void)setupPageView {
    NSArray *arrayID = [NSMutableArray arrayWithObjects:NSLocalizedString(@"detailedStatement", nil),NSLocalizedString(@"dailyStatement", nil), nil];
    NSMutableArray *viewConMutArr = [NSMutableArray array];
    NSMutableArray *titleMutArr = [NSMutableArray array];
    for (NSInteger i = 0; i < arrayID.count ; i++) {
        CoinTableViewController *viewCon = [[CoinTableViewController alloc] initWithNibName:@"CoinTableViewController" bundle:nil];
        viewCon.selectedIndex = i;
        [viewConMutArr addObject:viewCon];
        [titleMutArr addObject:[arrayID objectAtIndex:i]];
    }
    CGFloat contentViewHeight = SCREEN_HEIGHT_DEVICE - 64 - IS_iPhoneX_Top;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 64 + IS_iPhoneX_Top, SCREEN_WIDTH_DEVICE, contentViewHeight) parentVC:self childVCs:viewConMutArr];
    self.pageContentView.delegatePageContentView = self;
    [self.view addSubview:self.pageContentView];
    
    /// pageTitleView
//    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 64 + IS_iPhoneX_Top, SCREEN_WIDTH_DEVICE, 40) delegate:self titleNames:titleMutArr];
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, 250, 40) delegate:self titleNames:titleMutArr];
    self.pageTitleView.titleColorStateNormal = TextColor;
    self.pageTitleView.titleColorStateSelected = ThemeColor;
    self.pageTitleView.isShowIndicator = NO;
    self.pageTitleView.isShowBottomSeparator = NO;
    self.pageTitleView.indicatorHeight = 4.0f;
    self.pageTitleView.isOpenTitleTextZoom = NO;
    [self.pageTitleView setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:self.pageTitleView];
    self.navigationItem.titleView = self.pageTitleView;
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)endDeceleratingPageContentView:(SGPageContentView *)pageContentView targetIndex:(NSInteger)targetIndex{
    [self.pageTitleView setPageEndDeceleratingwithTargetIndex:targetIndex];
}

@end
