//
//  HomeViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/7/31.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "HomeViewController.h"
#import "SharedViewControllers.h"
#import "AppDelegate.h"
#import "TabBarView.h"
#import "TaskItemTableViewCell.h"
#import "MJRefresh.h"
#import "HomeHeaderView.h"
#import "RefreshErrorAlertView.h"
#import "TaskObject.h"
#import "BannerObject.h"
#import "SearchViewController.h"
#import "MessageViewController.h"
#import "DaySignViewController.h"
#import <UMCommon/MobClick.h>

@interface HomeViewController ()<UIScrollViewDelegate>{
    TabBarView                 *tabBarView;
    NSInteger                  pageNum;
    NSInteger                  pageSize;
    NSMutableArray             *contentMutArr;
    float                      bgImageViewHeight;
    HomeHeaderView             *headerView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic,copy) FlutterEventSink callBack;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *searchBgImageView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tabBarView = [TabBarView sharedTabBarView];
    [self.navigationItem setHidesBackButton:YES];
    self.fd_prefersNavigationBarHidden = YES;

    pageNum = 1;
    pageSize = 50;
    contentMutArr = [NSMutableArray array];
    
    headerView = [[HomeHeaderView alloc] initItem];
    self.tableView.tableHeaderView = headerView;
    
    [self requestContent:YES];
    
    //集成上下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    header.loadingView.color = [UIColor whiteColor];
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    
    [self.topView setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, 54 + IS_iPhoneX_Top + 20)];
    [self.tableView setFrame:CGRectMake(0, self.topView.frame.origin.y + self.topView.frame.size.height, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE - IS_iPhoneX_Bottom - 55 - self.topView.frame.origin.y - self.topView.frame.size.height)];
    bgImageViewHeight = 180 *SCREEN_SCALE + IS_iPhoneX_Top;
    [self.bgImageView setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, bgImageViewHeight)];
    self.searchBgImageView.layer.masksToBounds = YES;
    self.searchBgImageView.layer.cornerRadius = 14.0f;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.fd_interactivePopDisabled = YES;
    [self.view addSubview:tabBarView];
    [tabBarView setCurrentViewControllerIndex:1];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.fd_interactivePopDisabled = NO;
}

- (IBAction)searchPress {
    [MobClick event:@"SY_sousuo"];
    SearchViewController *viewCon = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (IBAction)messagePress {
    [MobClick event:@"SY_xiaoxi"];
    MessageViewController *viewCon = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (IBAction)qiandaoPress {
    [MobClick event:@"SY_qiandao"];
    DaySignViewController *viewCon = [[DaySignViewController alloc] initWithNibName:@"DaySignViewController" bundle:nil];
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (void)refreshHeader{
    pageNum = 1;
    [self requestContent:NO];
}

- (void)refreshFooter{
    pageNum = ++pageNum;
    [self requestContent:NO];
}

- (void)refreshViewCon{
    pageNum = 1;
    [self requestContent:NO];
}

//请求数据
- (void)requestContent:(BOOL)alert{
    if (alert) {
        [self loadingHUDAlert];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:pageNum] forKey:@"page"];
    [dic setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    [dic setObject:[NSNumber numberWithInteger:1] forKey:@"status"];
    [dic setObject:[NSNumber numberWithInteger:2] forKey:@"type"];
    [dic setObject:[NSNumber numberWithInteger:1] forKey:@"permission"];
    [dic setObject:[NSNumber numberWithInteger:0] forKey:@"dataType"];
    
    [[ServiceRequest sharedService] GET:@"/api/project/list" parameters:dic success:^(id responseObject) {
        [self hideHudAlert];
        if (self->pageNum == 1) {
            [self.tableView.mj_header endRefreshing];
            [self->contentMutArr removeAllObjects];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        NSArray *arr = [[responseObject objectForKey:@"data"] objectForKey:@"projects"];
        for (int i = 0; i < arr.count; i++) {
            [self->contentMutArr addObject:[TaskObject mj_objectWithKeyValues:[arr objectAtIndex:i]]];
        }
        if (self->contentMutArr.count == 0) {
            self.tableView.tableFooterView = [[RefreshErrorAlertView alloc] initItem:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, 300) withType:LoadErrorTypeNoData withTip:@"暂无任务"];
            self.tableView.mj_footer.hidden = YES;
        }else{
            self.tableView.tableFooterView = nil;
            self.tableView.mj_footer.hidden = NO;
        }
        if (arr.count < self->pageSize) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
        
    } failure:^(NSString *error, NSInteger code) {
        [self hideHudAlert];
        if (self->pageNum == 1) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        if (code == 0) {
            self.tableView.tableFooterView = [[RefreshErrorAlertView alloc] initItem:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, 300) withType:LoadErrorTypeNoNetwork withTip:@"网络错误"];
        }else{
            [self showHUDAlert:error];
        }
    }];
    
    if (alert) {
        [[ServiceRequest sharedService] GET:@"/api/app/banners" parameters:nil success:^(id responseObject) {
            NSArray *bannerArr = [BannerObject mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            [self->headerView setBanners:bannerArr];
        } failure:^(NSString *error, NSInteger code) {
            
        }];
    }
}

#pragma mark - UITableView datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contentMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TaskItemCell";
    TaskItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskItemTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    TaskObject *task = [contentMutArr objectAtIndex:indexPath.row];
    [cell showContent:task];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    TaskObject *task = [contentMutArr objectAtIndex:indexPath.row];
    UserInfo *user = [UserManger currentLoggedInUser];
    [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"ProjectDetailPage" withArguments:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[task.taskID intValue]], @"projectId", user.username, @"username", nil]];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
    NSLog(@"=========%f", yOffset);
    if (yOffset <= 0) {
        CGFloat factor = ((ABS(yOffset)+(bgImageViewHeight ))*SCREEN_WIDTH_DEVICE)/(bgImageViewHeight);
        CGRect f = CGRectMake((SCREEN_WIDTH_DEVICE - factor)/2.0, 0, factor, (bgImageViewHeight)+ABS(yOffset));
        self.bgImageView.frame = f;
    } else {
        if (yOffset < (bgImageViewHeight + IS_iPhoneX_Top)) {
            CGRect f = self.bgImageView.frame;
            f.origin.y = -yOffset + (0);
            self.bgImageView.frame = f;
        }
    }
}
@end
