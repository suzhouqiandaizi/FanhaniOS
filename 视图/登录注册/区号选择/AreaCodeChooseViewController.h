//
//  AreaCodeChooseViewController.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/7/30.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AreaCodeChooseViewController : UIViewController
@property (copy, nonatomic) void (^RefreshHandle)(NSString *item);
@end

NS_ASSUME_NONNULL_END
