//
//  MessageTableViewCell.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/12.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

NS_ASSUME_NONNULL_END
