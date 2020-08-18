//
//  RefreshErrorAlertView.m
//  ReceiveTask
//
//  Created by WangZhenyu on 2019/12/20.
//  Copyright © 2019 WangZhenyu. All rights reserved.
//

#import "RefreshErrorAlertView.h"

@interface RefreshErrorAlertView()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;

@end

@implementation RefreshErrorAlertView

- (id)initItem:(CGRect)frame withType:(LoadErrorType)type withTip:(NSString *)tipStr{
    self = [[[NSBundle mainBundle] loadNibNamed:@"RefreshErrorAlertView" owner:self options:nil] lastObject];
    if (self) {
        [self setFrame:frame];
        
        self.tipLabel.text = tipStr;
        if (type == LoadErrorTypeNoNetwork) {
            self.contentImageView.image = [UIImage imageNamed:@"ic_empty"];
        }else if (type == LoadErrorTypeRequest){
            self.refreshBtn.hidden = NO;
            self.refreshBtn.layer.masksToBounds = YES;
            self.refreshBtn.layer.cornerRadius = 5.0f;
            self.refreshBtn.layer.borderColor = ThemeColor.CGColor;
            self.refreshBtn.layer.borderWidth = 0.5f;
            self.contentImageView.image = [UIImage imageNamed:@"ic_empty"];
        }else{
            self.contentImageView.image = [UIImage imageNamed:@"ic_empty"];
        }
    }
    return self;
}

- (id)initItem:(CGRect)frame withType:(LoadErrorType)type withTip:(NSString *)tipStr refresh:(void (^)(RefreshErrorAlertView *))refresh{
    self = [[[NSBundle mainBundle] loadNibNamed:@"RefreshErrorAlertView" owner:self options:nil] lastObject];
    if (self) {
        [self setFrame:frame];
        
        self.tipLabel.text = tipStr;
        if (type == LoadErrorTypeNoNetwork) {
            self.contentImageView.image = [UIImage imageNamed:@"refreshtableview_nonetwork"];
        }else if (type == LoadErrorTypeRequest){
            self.refreshBtn.hidden = NO;
            self.refreshBtn.layer.masksToBounds = YES;
            self.refreshBtn.layer.cornerRadius = 5.0f;
            self.refreshBtn.layer.borderColor = ThemeColor.CGColor;
            self.refreshBtn.layer.borderWidth = 0.5f;
            self.contentImageView.image = [UIImage imageNamed:@"refreshtableview_requesterror"];
        }else if (type == LoadLocationError){
            self.refreshBtn.hidden = NO;
            self.refreshBtn.layer.masksToBounds = YES;
            self.refreshBtn.layer.cornerRadius = 5.0f;
            self.refreshBtn.layer.borderColor = ThemeColor.CGColor;
            self.refreshBtn.layer.borderWidth = 0.5f;
            [self.refreshBtn setTitle:@"重新定位" forState:UIControlStateNormal];
            self.contentImageView.image = [UIImage imageNamed:@"locationerror"];
        }else{
            self.contentImageView.image = [UIImage imageNamed:@"refreshtableview_defaultnodata"];
        }
        
        self.RefreshHandle = refresh;
    }
    return self;
}

- (IBAction)refreshPress {
    if (self.RefreshHandle) {
        self.RefreshHandle(self);
    }
}
@end
