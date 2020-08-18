//
//  LoginRecordTableViewCell.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/5.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (copy, nonatomic) void (^RefreshHandle)(void);
@end

NS_ASSUME_NONNULL_END
