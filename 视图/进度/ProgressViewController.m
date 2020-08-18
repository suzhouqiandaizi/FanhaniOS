//
//  ProgressViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/4.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "ProgressViewController.h"
#import "TabBarView.h"
#import "UIColor+Hexadecimal.h"
#import "TaskItemTableViewCell.h"
#import "TaskObject.h"
#import "RefreshErrorAlertView.h"
#import "MJRefresh.h"

@interface ProgressViewController (){
    TabBarView                 *tabBarView;
    NSInteger                  pageNum;
    NSInteger                  pageSize;
    NSMutableArray             *contentMutArr;
    NSMutableArray             *beanMutArr;
    BOOL                       reload;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tabBarView = [TabBarView sharedTabBarView];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:19.0f]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE, 64 + IS_iPhoneX_Top) direction:GradientChangeDirectionVertical startColor:[UIColor colorWithHex:0xff2567E7] endColor:[UIColor colorWithHex:0xff427DF6]] forBarMetrics:UIBarMetricsDefault];
    self.title = NSLocalizedString(@"tabBarProgress", nil);
    
    pageNum = 1;
    pageSize = 50;
    contentMutArr = [NSMutableArray array];
    beanMutArr = [NSMutableArray array];
    
    [self requestContent:YES];
    //集成上下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    [self.tableView setFrame:CGRectMake(0, 64 + IS_iPhoneX_Top, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE - IS_iPhoneX_Bottom - 55 - 64 - IS_iPhoneX_Top)];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.fd_interactivePopDisabled = YES;
    [self.view addSubview:tabBarView];
    [tabBarView setCurrentViewControllerIndex:2];
    
    if (reload) {
        [self.navigationItem setHidesBackButton:YES];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:19.0f]}];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE, 64 + IS_iPhoneX_Top) direction:GradientChangeDirectionVertical startColor:[UIColor colorWithHex:0xff2567E7] endColor:[UIColor colorWithHex:0xff427DF6]] forBarMetrics:UIBarMetricsDefault];
        [self refreshHeader];
    }else{
        reload = YES;
    }
//    [WZYForeNotification handleRemoteNotification:[NSDictionary dictionary] soundID:1312];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.fd_interactivePopDisabled = NO;
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
    
    [[ServiceRequest sharedService] GET:@"/api/user/inproject/list" parameters:dic success:^(id responseObject) {
        [self hideHudAlert];
        if (self->pageNum == 1) {
            [self.tableView.mj_header endRefreshing];
            [self->contentMutArr removeAllObjects];
            [self->beanMutArr removeAllObjects];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        NSArray *arr = [[responseObject objectForKey:@"data"] objectForKey:@"projects"];
        [self->beanMutArr addObjectsFromArray:arr];
        for (int i = 0; i < arr.count; i++) {
            [self->contentMutArr addObject:[TaskObject mj_objectWithKeyValues:[arr objectAtIndex:i]]];
        }
        if (self->contentMutArr.count == 0) {
            self.tableView.tableFooterView = [[RefreshErrorAlertView alloc] initItem:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, self.tableView.frame.size.height *0.8) withType:LoadErrorTypeNoData withTip:@"暂无任务"];
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
            self.tableView.tableFooterView = [[RefreshErrorAlertView alloc] initItem:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, self.tableView.frame.size.height *0.8) withType:LoadErrorTypeNoNetwork withTip:@"网络错误"];
        }else{
            [self showHUDAlert:error];
        }
    }];
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
    [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"MySubmitsPage" withArguments:
     [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithInteger:[task.taskID integerValue]], @"projectId",
     [NSNumber numberWithInteger:[task.sopType integerValue]], @"sopType",
     user.username, @"username",nil]];
    
}
@end
