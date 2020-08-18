//
//  MessageViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/12.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "MessageViewController.h"
#import "UIColor+Hexadecimal.h"
#import "MJRefresh.h"
#import "UIColor+Hexadecimal.h"
#import "RefreshErrorAlertView.h"
#import "MessageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WebShowViewController.h"

@interface MessageViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSInteger                  pageNum;
    NSInteger                  pageSize;
    NSMutableArray             *contentMutArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addWhiteBackBtn];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:19.0f]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE, 64 + IS_iPhoneX_Top) direction:GradientChangeDirectionVertical startColor:[UIColor colorWithHex:0xff2567E7] endColor:[UIColor colorWithHex:0xff427DF6]] forBarMetrics:UIBarMetricsDefault];
    self.title = NSLocalizedString(@"messageTitle", nil);
    
    pageNum = 1;
    pageSize = 50;
    contentMutArr = [NSMutableArray array];
    
    [self requestContent:YES];
    
    //集成上下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    [self.tableView setFrame:CGRectMake(0, 64 + IS_iPhoneX_Top, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE - 64 - IS_iPhoneX_Top)];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc{
    [[ServiceRequest sharedService] cancelDataTaskForKey:@"/api/tips/link"];
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
    //api/tips?subject=link
    [[ServiceRequest sharedService] GET:@"/api/tips/link" parameters:nil success:^(id responseObject) {
        [self hideHudAlert];
        if (self->pageNum == 1) {
            [self.tableView.mj_header endRefreshing];
            [self->contentMutArr removeAllObjects];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        NSArray *arr = [responseObject objectForKey:@"data"];
        [self->contentMutArr addObjectsFromArray:arr];
        if (self->contentMutArr.count == 0) {
            self.tableView.tableFooterView = [[RefreshErrorAlertView alloc] initItem:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, self.tableView.frame.size.height *0.8) withType:LoadErrorTypeNoData withTip:@"暂无消息"];
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
    static NSString *cellIdentifier = @"MessageCell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = [contentMutArr objectAtIndex:indexPath.row];
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"cover"]]];
    cell.contentLabel.text = [dic objectForKey:@"title"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ((378/864.0)*(SCREEN_WIDTH_DEVICE - 90))+30+15+8;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    NSDictionary *dic = [contentMutArr objectAtIndex:indexPath.row];
    WebShowViewController *viewCon = [[WebShowViewController alloc] initWithNibName:@"WebShowViewController" bundle:nil];
    viewCon.urlStr = [dic objectForKey:@"content"];
    viewCon.whiteBackBtn = YES;
    [self.navigationController pushViewController:viewCon animated:YES];
}


@end
