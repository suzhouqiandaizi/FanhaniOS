//
//  SearchViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/12.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "SearchViewController.h"
#import "UIColor+Hexadecimal.h"
#import "TaskItemTableViewCell.h"
#import "MJRefresh.h"
#import "RefreshErrorAlertView.h"
#import "TaskObject.h"

@interface SearchViewController (){
    NSInteger                  pageNum;
    NSInteger                  pageSize;
    NSMutableArray             *contentMutArr;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *searchBgImageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.fd_prefersNavigationBarHidden = YES;
    [self.topView setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, 64 + IS_iPhoneX_Top)];
    self.searchBgImageView.layer.masksToBounds = YES;
    self.searchBgImageView.layer.cornerRadius = 14.0f;
    [self.textField becomeFirstResponder];
    self.textField.returnKeyType = UIReturnKeySearch;
    [self.bgImageView setImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE, 64 + IS_iPhoneX_Top) direction:GradientChangeDirectionVertical startColor:[UIColor colorWithHex:0xff2567E7] endColor:[UIColor colorWithHex:0xff427DF6]]];
    
    pageNum = 1;
    pageSize = 50;
    contentMutArr = [NSMutableArray array];
    
    //集成上下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    self.tableView.hidden = YES;
    [self.tableView setFrame:CGRectMake(0, self.topView.frame.origin.y + self.topView.frame.size.height, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE - self.topView.frame.origin.y - self.topView.frame.size.height)];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc{
    [[ServiceRequest sharedService] cancelDataTaskForKey:@"/api/project/list"];
}

- (IBAction)goBackPress {
    [self goBackAction];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0) {
        self.tableView.hidden = NO;
        pageNum = 1;
        [self requestContent:YES];
        [self.textField resignFirstResponder];
    }
    return YES;
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
    [dic setObject:self.textField.text forKey:@"search"];
    
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
    [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"ProjectDetailPage" withArguments:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[task.taskID intValue]], @"projectId", user.username, @"username", nil]];
}
@end
