//
//  TabBarView.h
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarView : UIView

+ (TabBarView *)sharedTabBarView;

- (void)setCurrentViewControllerIndex:(NSInteger)indexn;

@end
