//
//  NewbieViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/14.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "NewbieViewController.h"
#import "NewbieObject.h"
#import "NewbieTableViewCell.h"

@interface NewbieViewController (){
    float                      bgImageViewHeight;
    NSArray                    *contentArr;
    BOOL                       reload;
}
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgLineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *ruleIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *newbieBtn;

@end

@implementation NewbieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.fd_prefersNavigationBarHidden = YES;
    [self.backBtn setFrame:CGRectMake(0, 20 + IS_iPhoneX_Top, 44, 44)];
    [self.scrollView setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE)];
    
    [self.newbieBtn setTitle:NSLocalizedString(@"newbieGuide", nil) forState:UIControlStateNormal];
   
    self.ruleLabel.text = NSLocalizedString(@"shareRules", nil);
    
    bgImageViewHeight = (1900.0/720)*SCREEN_WIDTH_DEVICE;
    [self.bgImageView setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, bgImageViewHeight)];
    [self.bgLineImageView setFrame:CGRectMake(0, bgImageViewHeight, SCREEN_WIDTH_DEVICE, 1000)];
    self.scrollView.alwaysBounceVertical = YES;

    [self requestContent];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (reload) {
        [self requestContent];
    }else{
        reload = YES;
    }
}

- (void)dealloc{
    [[ServiceRequest sharedService] cancelDataTaskForKey:@"/api/app/activity/beginner/list"];
}


- (void)requestContent{
    self.ruleIconImageView.hidden = YES;
    self.ruleLabel.hidden = YES;
    self.textView.hidden = YES;
    [[ServiceRequest sharedService] POST:@"/api/app/activity/beginner/list" parameters:nil success:^(id responseObject) {
        self->contentArr = [NewbieObject mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
        [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, SCREEN_WIDTH_DEVICE, self->contentArr.count * 50)];
        [self.tableView reloadData];
        self.ruleIconImageView.hidden = NO;
        self.ruleLabel.hidden = NO;
        self.textView.hidden = NO;
        [self.ruleIconImageView setFrame:CGRectMake(self.ruleIconImageView.frame.origin.x, self.tableView.frame.origin.y + self.tableView.frame.size.height + 40, self.ruleIconImageView.frame.size.width, self.ruleIconImageView.frame.size.height)];
        [self.ruleLabel setFrame:CGRectMake(self.ruleLabel.frame.origin.x, self.tableView.frame.origin.y + self.tableView.frame.size.height + 33, self.ruleLabel.frame.size.width, self.ruleLabel.frame.size.height)];
        
        NSMutableString *mutStr = [NSMutableString string];
        for (int i = 0; i < self->contentArr.count; i++) {
            NewbieObject *object = [self->contentArr objectAtIndex:i];
            [mutStr appendString:[NSString stringWithFormat:@"%d、", i + 1]];
            [mutStr appendString:object.descriptionStr];
            [mutStr appendString:@"\n"];
        }
        self.textView.text = mutStr;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8;// 字体的行间距
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:13],
                                     NSForegroundColorAttributeName:[UIColor whiteColor],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.textView.text attributes:attributes];
        self.textView.attributedText = attributeStr;

        CGSize labelSize = [self.textView sizeThatFits:CGSizeMake(SCREEN_WIDTH_DEVICE - 30, MAXFLOAT)];
        [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, self.ruleLabel.frame.origin.y + self.ruleLabel.frame.size.height + 1, labelSize.width, labelSize.height)];
        float contentViewY = (585/720.0)*SCREEN_WIDTH_DEVICE;
        [self.contentView setFrame:CGRectMake(0, contentViewY, SCREEN_WIDTH_DEVICE, self.textView.frame.origin.y + self.textView.frame.size.height)];
        [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH_DEVICE, self.contentView.frame.size.height + contentViewY + 20)];
    } failure:^(NSString *error, NSInteger code) {
    }];
}


#pragma mark - UITableView datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NewbieCell";
    NewbieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewbieTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.RefreshHandle = ^{
        [self requestContent];
    };
    NewbieObject *item = [contentArr objectAtIndex:indexPath.row];
    cell.index = indexPath.row;
    cell.newbie = item;
    [cell showContent:item];
    return cell;
}


- (IBAction)backPress {
    [self goBackAction];
}

- (IBAction)newbiePress {
    [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"NewGuidePage" withArguments:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset <= 0) {
        CGFloat factor = ((ABS(yOffset)+(bgImageViewHeight ))*SCREEN_WIDTH_DEVICE)/(bgImageViewHeight);
        CGRect f = CGRectMake((SCREEN_WIDTH_DEVICE - factor)/2.0, 0, factor, (bgImageViewHeight)+ABS(yOffset));
        self.bgImageView.frame = f;
    } else {
        CGRect f = self.bgImageView.frame;
        f.origin.y = -yOffset + (0);
        self.bgImageView.frame = f;
        
        CGRect f2 = self.bgImageView.frame;
        f2.origin.y = -yOffset + f.size.height;
        self.bgLineImageView.frame = f2;
    }
}


@end
