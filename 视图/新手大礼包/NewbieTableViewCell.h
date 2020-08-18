//
//  NewbieTableViewCell.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/17.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewbieObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewbieTableViewCell : UITableViewCell

@property (strong, nonatomic) NewbieObject *newbie;
@property (assign, nonatomic) NSInteger index;
@property (copy, nonatomic) void (^RefreshHandle)(void);

- (void)showContent:(NewbieObject *)item;

@end

NS_ASSUME_NONNULL_END
