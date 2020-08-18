//
//  LongPressButton.h
//  MianZhuang-SBCEO
//
//  Created by WangZhenyu on 16/3/9.
//  Copyright © 2016年 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LongPressButton : UIButton
-(void) setPressing:(void (^)(NSTimeInterval timePassed, LongPressButton* button))pressingBlock touchEnd:(void (^)(BOOL cancelled))endBlock invokeInterval:(NSTimeInterval)interval;
-(void) stop;
@end
