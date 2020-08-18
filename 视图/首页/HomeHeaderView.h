//
//  HomeHeaderView.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/4.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeHeaderView : UIView
- (id)initItem;
- (void)setBanners:(NSArray *)arr;
@property (weak, nonatomic) IBOutlet UIView *topView;
@end

NS_ASSUME_NONNULL_END
