//
//  NewbieTableViewCell.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/17.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "NewbieTableViewCell.h"
#import "UIColor+Hexadecimal.h"
#import "AppDelegate.h"
#import "TaskClassificationViewController.h"
#import "ShareThirdViewController.h"

@interface NewbieTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coinImageView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIImageView *gouImageView;

@end

@implementation NewbieTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 12.0f;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showContent:(NewbieObject *)item{
    self.titleLabel.text = item.activityName;
    self.coinLabel.text = item.rewardStr;
    if (item.status == 3) {
        self.gouImageView.hidden = NO;
        [self.bgImageView setImage:[UIImage imageNamed:@"newbie_task_page_finish"]];
        self.coinLabel.textColor = [UIColor whiteColor];
        [self.sureBtn setTitle:NSLocalizedString(@"newbieFinisButton", nil) forState:UIControlStateNormal];
        [self.sureBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        [self.sureBtn setFrame:CGRectMake(SCREEN_WIDTH_DEVICE - 38 - self.sureBtn.frame.size.width, self.sureBtn.frame.origin.y, self.sureBtn.frame.size.width, self.sureBtn.frame.size.height)];
        [self.coinImageView setFrame:CGRectMake(SCREEN_WIDTH_DEVICE - 25 - self.coinImageView.frame.size.width, self.coinImageView.frame.origin.y, self.coinImageView.frame.size.width, self.coinImageView.frame.size.height)];
    }else{
        self.gouImageView.hidden = YES;
        [self.bgImageView setImage:[UIImage imageNamed:@"newbie_task_page_not_finish"]];
        self.coinLabel.textColor = ThemeColor;
        if (item.status == 2) {
            [self.sureBtn setTitle:NSLocalizedString(@"newbieRewardButton", nil) forState:UIControlStateNormal];
            [self.sureBtn setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(self.sureBtn.frame.size.width, self.sureBtn.frame.size.height) direction:GradientChangeDirectionLevel startColor:[UIColor colorWithHex:0xffeca73e] endColor:[UIColor colorWithHex:0xffeca73e]] forState:UIControlStateNormal];
        }else{
            [self.sureBtn setTitle:NSLocalizedString(@"newbieDoneButton", nil) forState:UIControlStateNormal];
            [self.sureBtn setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(self.sureBtn.frame.size.width, self.sureBtn.frame.size.height) direction:GradientChangeDirectionLevel startColor:[UIColor colorWithHex:0xff59bbff] endColor:[UIColor colorWithHex:0xff4a88ff]] forState:UIControlStateNormal];
        }
        [self.sureBtn setFrame:CGRectMake(SCREEN_WIDTH_DEVICE - 25 - self.sureBtn.frame.size.width, self.sureBtn.frame.origin.y, self.sureBtn.frame.size.width, self.sureBtn.frame.size.height)];
        [self.coinImageView setFrame:CGRectMake(SCREEN_WIDTH_DEVICE - 93 - self.coinImageView.frame.size.width, self.coinImageView.frame.origin.y, self.coinImageView.frame.size.width, self.coinImageView.frame.size.height)];
        
    }
}

- (IBAction)surePress {
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.newbie.status == 0) {
        if (self.index == 0) {
            TaskClassificationViewController *viewCon = [[TaskClassificationViewController alloc] initWithNibName:@"TaskClassificationViewController" bundle:nil];
            [del.navigationController pushViewController:viewCon animated:YES];
        }else if (self.index == 1){
            [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"AuthPage" withArguments:nil];
        }else if (self.index == 2 || self.index == 3 || self.index == 4){
            [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"AccountSettingPage" withArguments:nil];
        }else if (self.index == 5){
            ShareThirdViewController *viewCon = [[ShareThirdViewController alloc] initWithNibName:@"ShareThirdViewController" bundle:nil];
            [del.navigationController pushViewController:viewCon animated:YES];
        }else if (self.index == 6){
            [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"UserProfilePage" withArguments:nil];
        }
    }else if (self.newbie.status == 2){
        [[ServiceRequest sharedService] POSTJSON:@"/api/app/activity/reward" parameters:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:self.newbie.activityID] forKey:@"activityID"] success:^(id responseObject) {
            if (self.RefreshHandle) {
                self.RefreshHandle();
            }
        } failure:^(NSString *error, NSInteger code) {
            [del.navigationController.topViewController showHUDAlert:error];
        }];
    }
    
}

@end
