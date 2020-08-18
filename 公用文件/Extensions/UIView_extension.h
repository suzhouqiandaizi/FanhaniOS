//
//  UIView.h
//  MianZhuang
//
//  Created by 棉 庄 on 9/15/15.
//  Copyright (c) 2015 mian zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIViewMoveDirection) {
    UIViewMoveDirectionLeft,
    UIViewMoveDirectionRight,
    UIViewMoveDirectionUp,
    UIViewMoveDirectionDown,
    
};

@interface UIView (animation)
-(void) ytRotate:(CGFloat) angle withAnimation:(BOOL) animate;
-(void) ytHeartbeat:(NSTimeInterval) duration;
-(void) ytHeartbeat:(NSTimeInterval) duration amplitude:(double)amplitude;

-(void) ytShake:(NSUInteger) times;
-(void) ytShake:(NSUInteger) times amplitude:(NSUInteger)amplitude;

@end


@interface UIView (userinterface)

-(void) ytApplyBorderViewLabelLookAndFeel;
-(void) ytApplyBorderViewLookAndFeelStyle2;
-(void) ytApplyBatchQualityFlagLabelLookAndFell;
-(void) ytApplySubmitButtonLookAndFeel;
-(void) ytApplyPartyIdLabelLookAndFeel;

-(void) ytMove:(UIViewMoveDirection)direction offset:(CGFloat) offset;
-(void) ytScale:(CGFloat)multiple;
-(NSString *)description;

-(void) ytSetAccessibility:(NSString*)name value:(NSString*)value;
@end

@interface UIView (LSCore)

#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;

@end
