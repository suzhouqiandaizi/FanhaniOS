//
//  LoginRecordTableViewCell.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/5.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "LoginRecordTableViewCell.h"

@implementation LoginRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deletePress {
    [UserManger deleteUserLoginRecord:self.titleLabel.text];
    if (self.RefreshHandle) {
        self.RefreshHandle();
    }
}
@end
