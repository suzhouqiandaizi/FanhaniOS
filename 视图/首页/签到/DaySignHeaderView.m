//
//  DaySignHeaderView.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/18.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "DaySignHeaderView.h"
#import "UIColor+Hexadecimal.h"
#import "GlobalFunction.h"
#import "DaySignRuleAlertView.h"
#import "AppDelegate.h"

@interface DaySignHeaderView()
@property (weak, nonatomic) IBOutlet UIView *lianxuView;
@property (weak, nonatomic) IBOutlet UIView *todayView;
@property (weak, nonatomic) IBOutlet UIImageView *lianxuImageView;
@property (weak, nonatomic) IBOutlet UIImageView *todayImageView;
@property (weak, nonatomic) IBOutlet UILabel *lianxuLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UILabel *lianxuNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *ruleBtn;
@property (weak, nonatomic) IBOutlet UIView *dayView;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UIImageView *titleIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *oneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *threeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fiveImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sixImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sevenImageView;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixLabel;
@property (weak, nonatomic) IBOutlet UILabel *sevenLabel;
@property (weak, nonatomic) IBOutlet UIImageView *threePlusImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fivePlusImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sevenPlusImageView;

@end

@implementation DaySignHeaderView


- (id)initItem{
    self = [[[NSBundle mainBundle] loadNibNamed:@"DaySignHeaderView" owner:self options:nil] lastObject];
    if (self) {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, 274)];
        self.lianxuLabel.text = NSLocalizedString(@"daySignContinuousSignin", nil);
        self.todayLabel.text = NSLocalizedString(@"daySignReceived", nil);
        [self.ruleBtn setTitle:NSLocalizedString(@"daySignRule", nil) forState:UIControlStateNormal];
        self.oneLabel.text = [NSString stringWithFormat:@"1%@", NSLocalizedString(@"daySignDay", nil)];
        self.twoLabel.text = [NSString stringWithFormat:@"2%@", NSLocalizedString(@"daySignDay", nil)];
        self.threeLabel.text = [NSString stringWithFormat:@"3%@", NSLocalizedString(@"daySignDay", nil)];
        self.fourLabel.text = [NSString stringWithFormat:@"4%@", NSLocalizedString(@"daySignDay", nil)];
        self.fiveLabel.text = [NSString stringWithFormat:@"5%@", NSLocalizedString(@"daySignDay", nil)];
        self.sixLabel.text = [NSString stringWithFormat:@"6%@", NSLocalizedString(@"daySignDay", nil)];
        self.sevenLabel.text = [NSString stringWithFormat:@"7%@", NSLocalizedString(@"daySignDay", nil)];
        
        [self.signBtn setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:self.signBtn.bounds.size direction:GradientChangeDirectionLevel startColor:[UIColor colorWithHex:0xff59bbff] endColor:[UIColor colorWithHex:0xff4a88ff]] forState:UIControlStateNormal];
        [self.signBtn setTitle:NSLocalizedString(@"daySignButton", nil) forState:UIControlStateNormal];
        self.signBtn.layer.masksToBounds = YES;
        self.signBtn.layer.cornerRadius = 5.0f;
        
        self.titleIconImageView.layer.masksToBounds = YES;
        self.titleIconImageView.layer.cornerRadius = 2.0f;
        
        [self.lianxuImageView setImage:[UIColor bm_colorGradientChangeWithSize:self.lianxuImageView.bounds.size direction:GradientChangeDirectionLevel startColor:[UIColor colorWithHex:0xffcae576] endColor:[UIColor colorWithHex:0xff91bb6e]]];
        [self.todayImageView setImage:[UIColor bm_colorGradientChangeWithSize:self.todayImageView.bounds.size direction:GradientChangeDirectionLevel startColor:[UIColor colorWithHex:0xff91bbf8] endColor:[UIColor colorWithHex:0xff6c9bf7]]];
        addShadowToView(self.lianxuView, 0.3, 5.0f, 5.0f);
        addShadowToView(self.todayView, 0.3, 5.0f, 5.0f);
        [self.dayView setFrame:CGRectMake(10, self.dayView.frame.origin.y, SCREEN_WIDTH_DEVICE - 20, self.dayView.frame.size.height)];
        addShadowToView(self.dayView, 0.3, 5.0f, 5.0f);
        
        [self.ruleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -
         self.ruleBtn.imageView.frame.size.width, 0, self.ruleBtn.imageView.frame.size.width + 5)];
        [self.ruleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.ruleBtn.titleLabel.bounds.size.width, 0, - self.ruleBtn.titleLabel.bounds.size.width)];
        
        [self requestContent];
    }
    return self;
}

- (void)requestContent{
    
    [[ServiceRequest sharedService] GET:@"/api/sign" parameters:nil success:^(id responseObject) {
        NSInteger continuous = [[[responseObject objectForKey:@"data"] objectForKey:@"continuous"] integerValue];
        self.lianxuNumLabel.text = [NSString stringWithFormat:@"%ld %@", continuous, NSLocalizedString(@"daySignDay", nil)];
        self.lianxuNumLabel = changeLabelAttribute(self.lianxuNumLabel, self.lianxuNumLabel.text.length - [NSLocalizedString(@"daySignDay", nil) length], 0, RGB(144, 186, 110), TextColor, 10.0, YES);
        
        [[ServiceRequest sharedService] GET:@"/api/sign/check" parameters:nil success:^(id responseObjectEx) {
            BOOL signBool = [[responseObjectEx objectForKey:@"data"] boolValue];
            if (signBool) {
                self.todayNumLabel.text = [NSString stringWithFormat:@"%.1f %@", [self returnCoinCount:continuous], NSLocalizedString(@"daySignCoin", nil)];
                [self.signBtn setTitle:NSLocalizedString(@"daySignDoneButton", nil) forState:UIControlStateNormal];
                [self.signBtn setUserInteractionEnabled:NO];
            }else{
                self.todayNumLabel.text = [NSString stringWithFormat:@"0 %@", NSLocalizedString(@"daySignCoin", nil)];
                [self.signBtn setTitle:NSLocalizedString(@"daySignButton", nil) forState:UIControlStateNormal];

            }
            self.todayNumLabel = changeLabelAttribute(self.todayNumLabel, self.todayNumLabel.text.length - [NSLocalizedString(@"daySignCoin", nil) length], 0, RGB(106, 154, 247), TextColor, 10.0, YES);
            if (continuous >= 1) {
                [self.oneImageView setImage:[UIImage imageNamed:@"sign_page_signed"]];
            }
            if (continuous >= 2) {
                [self.twoImageView setImage:[UIImage imageNamed:@"sign_page_signed"]];
            }
            if (continuous >= 3) {
                [self.threeImageView setImage:[UIImage imageNamed:@"sign_page_signed"]];
            }
            if (continuous >= 4) {
                [self.fourImageView setImage:[UIImage imageNamed:@"sign_page_signed"]];
            }
            if (continuous >= 5) {
                [self.fiveImageView setImage:[UIImage imageNamed:@"sign_page_signed"]];
            }
            if (continuous >= 6) {
                [self.sixImageView setImage:[UIImage imageNamed:@"sign_page_signed"]];
            }
            if (continuous >= 7) {
                [self.sevenImageView setImage:[UIImage imageNamed:@"sign_page_signed"]];
            }
            if (continuous == 0) {
                self.oneLabel.text = NSLocalizedString(@"daySignToday", nil);
            }
            if (continuous == 1) {
                if (signBool) {
                    self.oneLabel.text = NSLocalizedString(@"daySignToday", nil);
                }else{
                    self.twoLabel.text = NSLocalizedString(@"daySignToday", nil);
                }
            }
            if (continuous == 2) {
                if (signBool) {
                    self.twoLabel.text = NSLocalizedString(@"daySignToday", nil);
                }else{
                    self.threeLabel.text = NSLocalizedString(@"daySignToday", nil);
                }
            }
            if (continuous == 3) {
                if (signBool) {
                    self.threeLabel.text = NSLocalizedString(@"daySignToday", nil);
                }else{
                    self.fourLabel.text = NSLocalizedString(@"daySignToday", nil);
                }
            }
            if (continuous == 4) {
                if (signBool) {
                    self.fourLabel.text = NSLocalizedString(@"daySignToday", nil);
                }else{
                    self.fiveLabel.text = NSLocalizedString(@"daySignToday", nil);
                }
            }
            if (continuous == 5) {
                if (signBool) {
                    self.fiveLabel.text = NSLocalizedString(@"daySignToday", nil);
                }else{
                    self.sixLabel.text = NSLocalizedString(@"daySignToday", nil);
                }
            }
            if (continuous == 6) {
                if (signBool) {
                    self.sixLabel.text = NSLocalizedString(@"daySignToday", nil);
                }else{
                    self.sevenLabel.text = NSLocalizedString(@"daySignToday", nil);
                }
            }
            if (continuous == 7) {
                self.sevenLabel.text = NSLocalizedString(@"daySignToday", nil);

            }
        } failure:^(NSString *error, NSInteger code) {
            
        }];
        
        
    } failure:^(NSString *error, NSInteger code) {
        
    }];
}

- (IBAction)rulePress {
    DaySignRuleAlertView *alertView = [[DaySignRuleAlertView alloc] initItem];
    [self.window addSubview:alertView];
}

- (IBAction)signPress {
    [self.signBtn setUserInteractionEnabled:NO];
    [[ServiceRequest sharedService] POST:@"/api/sign" parameters:nil success:^(id responseObject) {
        [self requestContent];
    } failure:^(NSString *error, NSInteger code) {
        [self.signBtn setUserInteractionEnabled:YES];
        AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [del.navigationController.topViewController showHUDAlert:error];
    }];
}

- (float)returnCoinCount:(NSInteger)day{
    switch (day) {
        case 1:
            return 1.0;
            break;
        case 2:
            return 1.2;
        break;
        case 3:
            return 1.7;
        break;
        case 4:
            return 1.6;
        break;
        case 5:
            return 2.3;
        break;
        case 6:
            return 2.0;
        break;
        case 7:
            return 1.0;
        break;
        default:
            return 0;
            break;
    }
}
@end
