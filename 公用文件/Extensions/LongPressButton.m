//
//  LongPressButton.m
//  MianZhuang-SBCEO
//
//  Created by WangZhenyu on 16/3/9.
//  Copyright © 2016年 WangZhenyu. All rights reserved.
//

#import "LongPressButton.h"

@interface LongPressButton ()
@property (nonatomic) NSTimeInterval interval;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic) NSTimeInterval timePassed;
@property (nonatomic, copy) void (^pressingBlock)(NSTimeInterval timePassed, LongPressButton* button);
@property (nonatomic, copy) void (^endBlock)(BOOL cancelled);

@end

@implementation LongPressButton

-(void)stop
{
    [self.timer invalidate];
    self.timePassed = 0;
}

-(void)setPressing:(void (^)(NSTimeInterval, LongPressButton *))pressingBlock touchEnd:(void (^)(BOOL))endBlock invokeInterval:(NSTimeInterval)interval
{
    self.pressingBlock = pressingBlock;
    self.endBlock = endBlock;
    self.interval =interval;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.timePassed = 0;
    [self timesGoBy:nil];
}

-(void) timesGoBy:(NSTimer*) timer
{
    
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(timesGoBy:) userInfo:nil repeats:NO];
    self.timePassed += self.interval;
    self.pressingBlock(self.timePassed, self);
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.timer invalidate];
    self.timePassed = 0;
    self.endBlock(YES);
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.timer invalidate];
    self.timePassed = 0;
    // 判断touches是否在按钮内部
    UITouch *touch = [touches anyObject];
    CGPoint pointone = [touch locationInView:self];
    if(pointone.x>=0 && pointone.x<=self.frame.size.width && pointone.y>=0 && pointone.y <= self.frame.size.height){
        // touch up in side
        self.endBlock(NO);
    }else{
        // touch up out side
        self.endBlock(YES);
    }
}


@end
