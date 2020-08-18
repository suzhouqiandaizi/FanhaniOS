//
//  UIColor+Hexadecimal.m
//  Applications
//
//  Created by Ignacio on 6/7/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "UIColor+Hexadecimal.h"

@implementation UIColor (Hexadecimal)

+ (UIColor *)colorWithHex:(long)hexColor {
    CGFloat red = ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0f;
    CGFloat green = ((CGFloat)((hexColor & 0xFF00) >> 8))/255.0f;
    CGFloat blue = ((CGFloat)(hexColor & 0xFF))/255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(CGFloat)alpha{
    CGFloat red = ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0f;
    CGFloat green = ((CGFloat)((hexColor & 0xFF00) >> 8))/255.0f;
    CGFloat blue = ((CGFloat)(hexColor & 0xFF))/255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIImage *)bm_colorGradientChangeWithSize:(CGSize)size
                                     direction:(GradientChangeDirection)direction
                                    startColor:(UIColor*)startcolor
                                      endColor:(UIColor*)endColor {
    if(CGSizeEqualToSize(size,CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame=CGRectMake(0,0, size.width, size.height);
    CGPoint startPoint =CGPointZero;
    if (direction == GradientChangeDirectionDownDiagonalLine) {
        startPoint =CGPointMake(0.0,1.0);
    }
    gradientLayer.startPoint= startPoint;
    CGPoint endPoint = CGPointZero;
    switch(direction) {
        case GradientChangeDirectionLevel:
            endPoint =CGPointMake(1.0,0.0);
            break;
        case GradientChangeDirectionVertical:
            endPoint =CGPointMake(0.0,1.0);
            break;
        case GradientChangeDirectionUpwardDiagonalLine:
            endPoint =CGPointMake(1.0,1.0);
            break;
        case GradientChangeDirectionDownDiagonalLine:
            endPoint =CGPointMake(1.0,0.0);
            break;
        default:
            break;
    }
    gradientLayer.endPoint= endPoint;
    gradientLayer.colors=@[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
