//
//  UIColor+Hexadecimal.h
//  Applications
//
//  Created by Ignacio on 6/7/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSUInteger{
    GradientChangeDirectionLevel,                               //水平方向渐变
    GradientChangeDirectionVertical,                           //垂直方向渐变
    GradientChangeDirectionUpwardDiagonalLine,    //主对角线方向渐变
    GradientChangeDirectionDownDiagonalLine,       //副对角线方向渐变
}GradientChangeDirection;

@interface UIColor (Hexadecimal)

+ (UIColor *)colorWithHex:(long)hexColor;

+ (UIColor *)colorWithHex:(long)hexColor alpha:(CGFloat)alpha;

+ (UIImage *)bm_colorGradientChangeWithSize:(CGSize)size
 direction:(GradientChangeDirection)direction
startColor:(UIColor*)startcolor
  endColor:(UIColor*)endColor;
@end
