//
//  RefreshErrorAlertView.h
//  ReceiveTask
//
//  Created by WangZhenyu on 2019/12/20.
//  Copyright © 2019 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LoadErrorTypeNoNetwork,      //没有网络
    LoadErrorTypeRequest,        //请求接口 后台报错
    LoadErrorTypeNoData,         //当前页面没有数据
    LoadLocationError           //无法定位
} LoadErrorType;

NS_ASSUME_NONNULL_BEGIN

@interface RefreshErrorAlertView : UIView
- (id)initItem:(CGRect)frame withType:(LoadErrorType)type withTip:(NSString *)tipStr;
- (id)initItem:(CGRect)frame withType:(LoadErrorType)type withTip:(NSString *)tipStr refresh:(void (^)(RefreshErrorAlertView *))refresh;
@property (strong, nonatomic) void (^RefreshHandle)(RefreshErrorAlertView *);
@end

NS_ASSUME_NONNULL_END
