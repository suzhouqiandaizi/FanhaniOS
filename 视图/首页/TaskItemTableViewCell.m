//
//  TaskItemTableViewCell.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/4.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "TaskItemTableViewCell.h"
#import "TaskObject.h"

@interface TaskItemTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UIImageView *labelImageView;
@property (weak, nonatomic) IBOutlet UILabel *iconTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation TaskItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showContent:(TaskObject *)task{
    self.titleLabel.text = task.name;
    self.subTitleLabel.text = [NSString stringWithFormat:@"ID:%@  %@:%@", task.taskID, NSLocalizedString(@"publishTitle", nil), task.startTime];
    self.priceLabel.text = task.price;
    NSString *taskClassifyStr = @"";
    if (task.taskClassify == TaskClassify_video) {
        taskClassifyStr = NSLocalizedString(@"headerVideoButton", nil);
        [self.labelImageView setImage:[UIImage imageNamed:@"task_label_blue"]];
        self.iconTextLabel.textColor = RGB(83, 154, 224);
        [self.iconImageView setImage:[UIImage imageNamed:@"task_classify_video"]];
    }else if (task.taskClassify == TaskClassify_text){
        taskClassifyStr = NSLocalizedString(@"headerTextButton", nil);
        [self.labelImageView setImage:[UIImage imageNamed:@"task_label_orange"]];
        self.iconTextLabel.textColor = RGB(234, 161, 110);
        [self.iconImageView setImage:[UIImage imageNamed:@"task_classify_text"]];
    }else if (task.taskClassify == TaskClassify_image){
        taskClassifyStr = NSLocalizedString(@"headerImageButton", nil);
        [self.labelImageView setImage:[UIImage imageNamed:@"task_label_blue"]];
        self.iconTextLabel.textColor = RGB(83, 154, 224);
        [self.iconImageView setImage:[UIImage imageNamed:@"task_classify_image"]];
    }else if (task.taskClassify == TaskClassify_transfer){
        taskClassifyStr = NSLocalizedString(@"headerZhuanXieButton", nil);
        [self.labelImageView setImage:[UIImage imageNamed:@"task_label_green"]];
        self.iconTextLabel.textColor = RGB(113, 211, 188);
        [self.iconImageView setImage:[UIImage imageNamed:@"task_classify_transfer"]];
    }else if (task.taskClassify == TaskClassify_voice){
        taskClassifyStr = NSLocalizedString(@"headerVoiceButton", nil);
        [self.labelImageView setImage:[UIImage imageNamed:@"task_label_orange"]];
        self.iconTextLabel.textColor = RGB(234, 161, 110);
        [self.iconImageView setImage:[UIImage imageNamed:@"task_classify_voice"]];
    }else if (task.taskClassify == TaskClassify_mix){
        taskClassifyStr = NSLocalizedString(@"headerHunheButton", nil);
        [self.labelImageView setImage:[UIImage imageNamed:@"task_label_green"]];
        self.iconTextLabel.textColor = RGB(113, 211, 188);
        [self.iconImageView setImage:[UIImage imageNamed:@"task_classify_mix"]];
    }else {
        taskClassifyStr = NSLocalizedString(@"headerAllButton", nil);
        [self.labelImageView setImage:[UIImage imageNamed:@"task_label_blue"]];
        self.iconTextLabel.textColor = RGB(83, 154, 224);
        [self.iconImageView setImage:[UIImage imageNamed:@"task_classify_image"]];
    }
    self.iconTextLabel.text = taskClassifyStr;
    CGSize labelSize = [taskClassifyStr boundingRectWithSize:CGSizeMake(100, 13) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8.0]} context:nil].size;
    [self.labelView setFrame:CGRectMake(self.labelView.frame.origin.x, self.labelView.frame.origin.y, labelSize.width + 8, self.labelView.frame.size.height)];
    [self.subTitleLabel setFrame:CGRectMake(self.labelView.frame.origin.x + self.labelView.frame.size.width + 8, self.subTitleLabel.frame.origin.y, SCREEN_WIDTH_DEVICE - self.labelView.frame.origin.x - self.labelView.frame.size.width - 8 - 80, self.subTitleLabel.frame.size.height)];
}

@end
