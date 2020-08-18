//
//  CustomFlutterViewController.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/13.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomFlutterViewController : FlutterViewController
@property (copy, nonatomic) void (^hideKeyboardHandle)(void);
@end

NS_ASSUME_NONNULL_END
