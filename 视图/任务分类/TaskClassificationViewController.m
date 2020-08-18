//
//  TaskClassificationViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/4.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "TaskClassificationViewController.h"
#import "FTPopOverMenu.h"
#import "TaskItemTableViewCell.h"
#import "MJRefresh.h"
#import "UIColor+Hexadecimal.h"
#import "TaskObject.h"
#import "RefreshErrorAlertView.h"

@interface TaskClassificationViewController (){
    NSInteger                  chooseFenlei;
    NSInteger                  chooseQuanxian;
    NSInteger                  pageNum;
    NSInteger                  pageSize;
    NSMutableArray             *contentMutArr;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *fenleiBtn;
@property (weak, nonatomic) IBOutlet UIButton *quanxianBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *fenleiDot;
@property (nonatomic, strong) NSArray<FTPopOverMenuModel *> *fenleiObjectArray;
@property (nonatomic, strong) NSArray<FTPopOverMenuModel *> *quanxianObjectArray;

@end

@implementation TaskClassificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addWhiteBackBtn];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:19.0f]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE, 64 + IS_iPhoneX_Top) direction:GradientChangeDirectionVertical startColor:[UIColor colorWithHex:0xff2567E7] endColor:[UIColor colorWithHex:0xff427DF6]] forBarMetrics:UIBarMetricsDefault];
    self.title = NSLocalizedString(@"taskTitle", nil);
             
    pageNum = 1;
    pageSize = 50;
    contentMutArr = [NSMutableArray array];
    
    [self.topView setFrame:CGRectMake(0, 64 + IS_iPhoneX_Top, SCREEN_WIDTH_DEVICE, self.topView.frame.size.height)];
    
    if (self.classify != TaskClassify_all) {
        [self.fenleiBtn setTitle:[NSString stringWithFormat:@"  %@", [self returnTaskClassifyName]] forState:UIControlStateNormal];
        chooseFenlei = self.classify;
    }else{
        [self.fenleiBtn setTitle:[NSString stringWithFormat:@"  %@", NSLocalizedString(@"taskClassificationInfo", nil)] forState:UIControlStateNormal];
        chooseFenlei = TaskClassify_all;
    }
    
    chooseQuanxian = 0;
    
    [self.quanxianBtn setTitle:NSLocalizedString(@"taskClassificationPermission", nil) forState:UIControlStateNormal];

    self.fenleiObjectArray = @[[[FTPopOverMenuModel alloc] initWithTitle:NSLocalizedString(@"taskClassificationAll", nil) image:nil selected:NO],
    [[FTPopOverMenuModel alloc] initWithTitle:NSLocalizedString(@"taskClassificationText", nil) image:nil selected:NO],
    [[FTPopOverMenuModel alloc] initWithTitle:NSLocalizedString(@"taskClassificationVideo", nil) image:nil selected:NO],
    [[FTPopOverMenuModel alloc] initWithTitle:NSLocalizedString(@"taskClassificationImage", nil) image:nil selected:NO],
    [[FTPopOverMenuModel alloc] initWithTitle:NSLocalizedString(@"taskClassificationTransfer", nil) image:nil selected:NO],
    [[FTPopOverMenuModel alloc] initWithTitle:NSLocalizedString(@"taskClassificationVoice", nil) image:nil selected:NO],
    [[FTPopOverMenuModel alloc] initWithTitle:NSLocalizedString(@"taskClassificationMix", nil) image:nil selected:NO]];
    FTPopOverMenuModel *selectModel = [self.fenleiObjectArray objectAtIndex:self.classify];
    selectModel.selected = YES;
    
    self.quanxianObjectArray = @[[[FTPopOverMenuModel alloc] initWithTitle:NSLocalizedString(@"taskClassificationAll", nil) image:nil selected:NO],
                                 [[FTPopOverMenuModel alloc] initWithTitle:NSLocalizedString(@"taskClassificationHasPermission", nil) image:nil selected:NO],
    [[FTPopOverMenuModel alloc] initWithTitle:NSLocalizedString(@"taskClassificationNOPermission", nil) image:nil selected:NO]];
    
    [self.quanxianBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -
        self.quanxianBtn.imageView.frame.size.width, 0, self.quanxianBtn.imageView.frame.size.width)];
       [self.quanxianBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.quanxianBtn.titleLabel.bounds.size.width, 0, - self.quanxianBtn.titleLabel.bounds.size.width - 5)];
    
    [self requestContent:YES];
    
    //集成上下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    [self.tableView setFrame:CGRectMake(0, self.topView.frame.origin.y + self.topView.frame.size.height, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE - self.topView.frame.origin.y - self.topView.frame.size.height)];

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
    [dic setObject:[NSNumber numberWithInteger:chooseQuanxian] forKey:@"permission"];
    [dic setObject:[NSNumber numberWithInteger:0] forKey:@"dataType"];
    [dic setObject:[NSNumber numberWithInteger:[self returnSopType]] forKey:@"sopType"];
    
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

- (IBAction)quanxianPress {
    self.quanxianBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    FTPopOverMenuConfiguration *config = [FTPopOverMenuConfiguration defaultConfiguration];
    config.menuWidth = 120;
    config.textColor = RGB(104, 104, 104);
    config.textAlignment = NSTextAlignmentCenter;
    config.separatorColor = [UIColor whiteColor];
    config.backgroundColor = UIColor.whiteColor;
    config.borderColor = [UIColor whiteColor];
    config.selectedTextColor = RGB(0, 79, 184);
    config.shadowColor = [UIColor lightGrayColor];
    config.shadowOpacity = 0.3f;
    config.shadowRadius  = 5.0f;
    config.coverBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    config.menuCornerRadius = 10.f;
    config.separatorInset = UIEdgeInsetsMake(0, 15.f, 0, 15.f);
    config.selectedCellBackgroundColor = RGB(240, 240, 240);
    config.horizontalMargin = 10.f;
    [FTPopOverMenu showForSender:self.quanxianBtn
                   withMenuArray:self.quanxianObjectArray
                    imageArray:nil
                 configuration:config
                     doneBlock:^(NSInteger selectedIndex) {
        FTPopOverMenuModel *model = [self.quanxianObjectArray objectAtIndex:selectedIndex];
        self->chooseQuanxian = selectedIndex;
        [self.quanxianBtn setTitle:model.title forState:UIControlStateNormal];
        [self.quanxianBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -
         self.quanxianBtn.imageView.frame.size.width, 0, self.quanxianBtn.imageView.frame.size.width)];
        [self.quanxianBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.quanxianBtn.titleLabel.bounds.size.width, 0, - self.quanxianBtn.titleLabel.bounds.size.width - 5)];
        [self requestContent:YES];
        [self.quanxianBtn setTitle:model.title forState:UIControlStateNormal];
            self.quanxianBtn.imageView.transform = CGAffineTransformMakeRotation(2*M_PI);
                 }dismissBlock:^{
                     self.quanxianBtn.imageView.transform = CGAffineTransformMakeRotation(2*M_PI);
                           }];
}

- (IBAction)fenleiPres {
    FTPopOverMenuConfiguration *config = [FTPopOverMenuConfiguration defaultConfiguration];
    config.menuWidth = 120;
    config.textColor = RGB(104, 104, 104);
    config.textAlignment = NSTextAlignmentCenter;
    config.separatorColor = [UIColor whiteColor];
    config.backgroundColor = UIColor.whiteColor;
    config.borderColor = [UIColor whiteColor];
    config.selectedTextColor = RGB(0, 79, 184);
    config.shadowColor = [UIColor lightGrayColor];
    config.shadowOpacity = 0.3f;
    config.shadowRadius  = 5.0f;
    config.coverBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    config.menuCornerRadius = 10.f;
    config.separatorInset = UIEdgeInsetsMake(0, 15.f, 0, 15.f);
    config.selectedCellBackgroundColor = RGB(240, 240, 240);
    config.horizontalMargin = 10.f;
    [FTPopOverMenu showForSender:self.fenleiDot
                   withMenuArray:self.fenleiObjectArray
                    imageArray:nil
                 configuration:config
                     doneBlock:^(NSInteger selectedIndex) {
        FTPopOverMenuModel *model = [self.fenleiObjectArray objectAtIndex:selectedIndex];
        self->chooseFenlei = selectedIndex;
        [self.fenleiBtn setTitle:[NSString stringWithFormat:@"  %@", model.title] forState:UIControlStateNormal];
        [self requestContent:YES];
                 }dismissBlock:^{
                           }];
}

- (NSString *)returnTaskClassifyName{
    if (self.classify == TaskClassify_text) {
        return NSLocalizedString(@"taskClassificationText", nil);
    }else if (self.classify == TaskClassify_video){
        return NSLocalizedString(@"taskClassificationVideo", nil);
    }else if (self.classify == TaskClassify_image){
        return NSLocalizedString(@"taskClassificationImage", nil);
    }else if (self.classify == TaskClassify_transfer){
        return NSLocalizedString(@"taskClassificationTransfer", nil);
    }else if (self.classify == TaskClassify_voice){
        return NSLocalizedString(@"taskClassificationVoice", nil);
    }else if (self.classify == TaskClassify_mix){
        return NSLocalizedString(@"taskClassificationMix", nil);
    }else if (self.classify == TaskClassify_new){
        return NSLocalizedString(@"taskClassificationNew", nil);
    }else{
        return NSLocalizedString(@"taskClassificationAll", nil);
    }
}

- (NSInteger)returnSopType{
    if (chooseFenlei == TaskClassify_text) {
        return 5005;
    }else if (chooseFenlei == TaskClassify_video) {
        return 5008;
    }else if (chooseFenlei == TaskClassify_image) {
        return 5006;
    }else if (chooseFenlei == TaskClassify_transfer) {
        return 5010;
    }else if (chooseFenlei == TaskClassify_voice) {
        return 5007;
    }else if (chooseFenlei == TaskClassify_mix) {
        return 5004;
    }else if (chooseFenlei == TaskClassify_new) {
        return 0;
    }else{
        return 0;
    }
}
@end
