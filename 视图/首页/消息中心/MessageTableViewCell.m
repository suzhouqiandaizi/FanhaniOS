//
//  MessageTableViewCell.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/12.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "GlobalFunction.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    float height = (378/864.0)*(SCREEN_WIDTH_DEVICE - 90);
    [self.showView setFrame:CGRectMake(self.showView.frame.origin.x, self.showView.frame.origin.y, SCREEN_WIDTH_DEVICE - 90, height + 30)];
    addShadowToView(self.showView, 0.2, 5.0f, 5.0f);    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
