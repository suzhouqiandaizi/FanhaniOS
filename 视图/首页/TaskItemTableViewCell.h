//
//  TaskItemTableViewCell.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/4.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskObject;

NS_ASSUME_NONNULL_BEGIN

@interface TaskItemTableViewCell : UITableViewCell
- (void)showContent:(TaskObject *)task;
@end

NS_ASSUME_NONNULL_END
