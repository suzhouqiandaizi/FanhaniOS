//
//  CoinTableViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/19.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "CoinTableViewController.h"
#import "MJRefresh.h"
#import "CoinTableViewCell.h"
#import "RefreshErrorAlertView.h"

@interface CoinTableViewController (){
    NSInteger                  pageNum;
    NSInteger                  pageSize;
    NSMutableArray             *contentMutArr;
    BOOL                       againReload;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CoinTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageNum = 1;
    pageSize = 50;
    contentMutArr = [NSMutableArray array];
    
    [self requestContent:YES];
    
    //集成上下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    
    // Do any additional setup after loading the view from its nib.
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
    static NSString *cellIdentifier = @"CoinCell";
    CoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CoinTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];

}


@end
