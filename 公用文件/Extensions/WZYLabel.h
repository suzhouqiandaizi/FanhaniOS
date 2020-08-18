//
//  WZYLabel.h
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZYLabel : UILabel

@property (nonatomic, assign) BOOL shouldGestureRecognizer;
@property (nonatomic, assign) BOOL copyEnable;
@property (nonatomic, assign) BOOL cutEnable;
@property (nonatomic, assign) BOOL pasteEnable;
@property (nonatomic, assign) BOOL yaoqingEnable;
@property (nonatomic, assign) BOOL shareEnable;

@end
