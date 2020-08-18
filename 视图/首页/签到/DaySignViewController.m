//
//  DaySignViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/18.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "DaySignViewController.h"
#import "DaySignHeaderView.h"
#import "TaskItemTableViewCell.h"
#import "TaskObject.h"
#import "RefreshErrorAlertView.h"

@interface DaySignViewController (){
    float                      bgImageViewHeight;
    NSMutableArray             *contentMutArr;
    NSInteger                  pageNum;
    NSInteger                  pageSize;

}
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DaySignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self.navigationItem setHidesBackButton:YES];
    [self.backBtn setFrame:CGRectMake(0, 20 + IS_iPhoneX_Top, 44, 44)];
    bgImageViewHeight = (457/720.0)*SCREEN_WIDTH_DEVICE;
    [self.bgImageView setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, bgImageViewHeight)];
    [self.tableView setFrame:CGRectMake(0, 64 + IS_iPhoneX_Top, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE - IS_iPhoneX_Top - 64)];
    self.titleLabel.text = NSLocalizedString(@"daySignTitle", nil);
    [self.titleLabel setFrame:CGRectMake((SCREEN_WIDTH_DEVICE - 200)/2.0, 20 + IS_iPhoneX_Top, 200, 44)];
    
    self.tableView.tableHeaderView = [[DaySignHeaderView alloc] initItem];
    
    pageNum = 1;
    pageSize = 4;
    contentMutArr = [NSMutableArray array];
    [self requestContent:YES];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backPress {
    [self goBackAction];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset <= 0) {
        CGFloat factor = ((ABS(yOffset)+(bgImageViewHeight ))*SCREEN_WIDTH_DEVICE)/(bgImageViewHeight);
        CGRect f = CGRectMake((SCREEN_WIDTH_DEVICE - factor)/2.0, 0, factor, (bgImageViewHeight)+ABS(yOffset));
        self.bgImageView.frame = f;
    } else {
        if (yOffset < (bgImageViewHeight - 64 -  IS_iPhoneX_Top)) {
            CGRect f = self.bgImageView.frame;
            f.origin.y = -yOffset + (0);
            self.bgImageView.frame = f;
        }
    }
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
    
    [[ServiceRequest sharedService] GET:@"/api/project/list" parameters:dic success:^(id responseObject) {
        [self hideHudAlert];
        if (self->pageNum == 1) {
            [self->contentMutArr removeAllObjects];
        }
        NSArray *arr = [[responseObject objectForKey:@"data"] objectForKey:@"projects"];
        for (int i = 0; i < arr.count; i++) {
            [self->contentMutArr addObject:[TaskObject mj_objectWithKeyValues:[arr objectAtIndex:i]]];
        }
        if (self->contentMutArr.count == 0) {
            self.tableView.tableFooterView = [[RefreshErrorAlertView alloc] initItem:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, 300) withType:LoadErrorTypeNoData withTip:@"暂无任务"];
        }else{
            self.tableView.tableFooterView = nil;
        }
        [self.tableView reloadData];
        
    } failure:^(NSString *error, NSInteger code) {
        [self hideHudAlert];
        if (code == 0) {
            self.tableView.tableFooterView = [[RefreshErrorAlertView alloc] initItem:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, 300) withType:LoadErrorTypeNoNetwork withTip:@"网络错误"];
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
