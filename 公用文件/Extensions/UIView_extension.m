//
//  UIView.m
//  MianZhuang
//
//  Created by 棉 庄 on 9/15/15.
//  Copyright (c) 2015 mian zhuang. All rights reserved.
//

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, UIViewMoveDirection) {
    UIViewMoveDirectionLeft,
    UIViewMoveDirectionRight,
    UIViewMoveDirectionUp,
    UIViewMoveDirectionDown,
    
};

@implementation UIView (animation)
-(void)ytRotate:(CGFloat)angle withAnimation:(BOOL)animate
{
    if (animate) {
        [UIView animateWithDuration:0.5 //begin animation
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.transform =  CGAffineTransformRotate(self.transform, DEGREES_TO_RADIANS(angle));
                         }
                         completion:^(BOOL finished){
                             
                         }
         ];
    }else{
        self.transform =  CGAffineTransformRotate(self.transform, DEGREES_TO_RADIANS(angle));
    }
}

-(void)ytHeartbeat:(NSTimeInterval)duration
{
    [self ytHeartbeat:duration amplitude:1.5];
}

-(void)ytHeartbeat:(NSTimeInterval) duration amplitude:(double)amplitude
{
    [UIView animateWithDuration:duration //begin animation
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform =  CGAffineTransformScale(self.transform, amplitude, amplitude);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:duration //begin animation
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              self.transform =  CGAffineTransformScale(self.transform, 1.0/amplitude, 1.0/amplitude);
                                          }
                                          completion:^(BOOL finished){
                                              
                                          }
                          ];
                     }
     ];
}

-(void)ytShake:(NSUInteger)times
{
    [self ytShake:times amplitude:10];
}


-(void)ytShake:(NSUInteger)times amplitude:(NSUInteger)amplitude
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.duration = 0.1;
    animation.byValue = @(amplitude);
    animation.autoreverses = YES;
    animation.repeatCount = times;
    [self.layer addAnimation:animation forKey:@"Shake"];
}

@end


@implementation UIView (userinterface)

-(void)ytApplyBorderViewLabelLookAndFeel
{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    self.layer.cornerRadius = 3;
}

-(void)ytApplyPartyIdLabelLookAndFeel
{
    self.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:143.0/255.0 blue:0 alpha:1];
    if ([self isKindOfClass:[UILabel class]]) {
        [(UILabel*)self setTextColor:[UIColor whiteColor]];
        [(UILabel*)self setTextAlignment:NSTextAlignmentCenter];
    }
    self.layer.cornerRadius = 2;
}

-(void)ytApplyBorderViewLookAndFeelStyle2
{
    self.layer.cornerRadius = 2;
}

-(void)ytApplyBatchQualityFlagLabelLookAndFell
{
    self.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:143.0/255.0 blue:0 alpha:1];
    self.clipsToBounds = YES;
    [self.layer setCornerRadius:3];
    if ([self isKindOfClass:[UILabel class]]) {
        [(UILabel*)self setTextColor:[UIColor whiteColor]];
    }
}

-(void)ytMove:(UIViewMoveDirection)direction offset:(CGFloat)offset
{
    switch (direction) {
        case UIViewMoveDirectionDown:
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + offset, self.frame.size.width, self.frame.size.height);
            break;
        case UIViewMoveDirectionUp:
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y  - offset, self.frame.size.width, self.frame.size.height);
            break;
        case UIViewMoveDirectionRight:
            self.frame = CGRectMake(self.frame.origin.x + offset, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
            break;
        case UIViewMoveDirectionLeft:
            self.frame = CGRectMake(self.frame.origin.x - offset, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
            break;
        default:
            break;
    }
}

-(void)ytScale:(CGFloat)multiple
{
     self.transform =  CGAffineTransformScale(self.transform, multiple, multiple);
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"x:%f, y:%f, width:%f, heght:%f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height];
}

-(void)ytSetAccessibility:(NSString *)name value:(NSString *)value
{
    self.isAccessibilityElement = YES;
    if (![self isKindOfClass:[UITextField class]]) {
        self.accessibilityValue = value;
    }
    self.accessibilityLabel = name;
}

@end

@implementation UIView (LSCore)
#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
        
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

@end
