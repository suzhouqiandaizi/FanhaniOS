//
//  TabBarView.m
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import "TabBarView.h"
#import "AppDelegate.h"
#import "SharedViewControllers.h"

#define BTN_X_OFF               0                           //按钮离顶部以及底部的距离
#define BTN_Y_OFF               0                           //两端按钮离边框的距离
#define BTN_WIDTH               SCREEN_WIDTH_DEVICE/3       //按钮宽度
#define BTN_HEIGHT              55                          //按钮高度

@interface TabBarView(){
}

@property (strong, nonatomic) UIButton                  *btnOne;
@property (strong, nonatomic) UIButton                  *btnTwo;
@property (strong, nonatomic) UIButton                  *btnThree;

@end

@implementation TabBarView

+ (TabBarView *)sharedTabBarView{
    static TabBarView *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[TabBarView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT_DEVICE - BTN_HEIGHT - IS_iPhoneX_Bottom, SCREEN_WIDTH_DEVICE, BTN_HEIGHT + IS_iPhoneX_Bottom)];
        
    });
    return _sharedInstance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        
        // Initialization code
//        self.backgroundColor = [UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1];
        self.backgroundColor = [UIColor whiteColor];
        //添加底部线条
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, 0.5)];
        [lineImageView setBackgroundColor:RGBACOLOR(240, 240, 240, 1)];
        [self addSubview:lineImageView];
        
        float labelY = 30;
        float labelHeight = 22;
        
        if (!self.btnOne) {
            self.btnOne = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.btnOne addTarget:self action:@selector(doBtnOne:) forControlEvents:UIControlEventTouchUpInside];
            self.btnOne.frame = CGRectMake(0, BTN_Y_OFF, BTN_WIDTH, BTN_HEIGHT);
            [self.btnOne setImage:[UIImage imageNamed:@"tabbar_one_n_icon"] forState:UIControlStateNormal];
            [self.btnOne setImage:[UIImage imageNamed:@"tabbar_one_n_icon"] forState:UIControlStateHighlighted];
            [self.btnOne setImage:[UIImage imageNamed:@"tabbar_one_s_icon"] forState:UIControlStateSelected];
            [self.btnOne setImageEdgeInsets:UIEdgeInsetsMake(-16, 0, 0, 0)];
            
            UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.btnOne.frame.origin.x, labelY, self.btnOne.frame.size.width, labelHeight)];
            oneLabel.textColor = RGB(106, 106, 106);
            oneLabel.font = [UIFont systemFontOfSize:11.0f];
            oneLabel.text = NSLocalizedString(@"tabBarHome", nil);
            oneLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:oneLabel];
            
            [self addSubview:self.btnOne];
        }
        
        if (!self.btnTwo) {
            self.btnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.btnTwo addTarget:self action:@selector(doBtnTwo:) forControlEvents:UIControlEventTouchUpInside];
            self.btnTwo.frame = CGRectMake(BTN_WIDTH, BTN_Y_OFF, BTN_WIDTH, BTN_HEIGHT);
            [self.btnTwo setImage:[UIImage imageNamed:@"tabbar_two_n_icon"] forState:UIControlStateNormal];
            [self.btnTwo setImage:[UIImage imageNamed:@"tabbar_two_n_icon"] forState:UIControlStateHighlighted];
            [self.btnTwo setImage:[UIImage imageNamed:@"tabbar_two_s_icon"] forState:UIControlStateSelected];
            [self.btnTwo setImageEdgeInsets:UIEdgeInsetsMake(-16, 0, 0, 0)];

            UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.btnTwo.frame.origin.x, labelY, self.btnTwo.frame.size.width, labelHeight)];
            twoLabel.textColor = RGB(106, 106, 106);
            twoLabel.font = [UIFont systemFontOfSize:11.0f];
            twoLabel.text = NSLocalizedString(@"tabBarProgress", nil);
            twoLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:twoLabel];
            
            [self addSubview:self.btnTwo];
        }
        
        if (!self.btnThree) {
            self.btnThree = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.btnThree addTarget:self action:@selector(doBtnThree:) forControlEvents:UIControlEventTouchUpInside];
            self.btnThree.frame = CGRectMake(BTN_WIDTH * 2, BTN_Y_OFF, BTN_WIDTH, BTN_HEIGHT);
            [self.btnThree setImage:[UIImage imageNamed:@"tabbar_four_n_icon"] forState:UIControlStateNormal];
            [self.btnThree setImage:[UIImage imageNamed:@"tabbar_four_n_icon"] forState:UIControlStateHighlighted];
            [self.btnThree setImage:[UIImage imageNamed:@"tabbar_four_s_icon"] forState:UIControlStateSelected];
            [self.btnThree setImageEdgeInsets:UIEdgeInsetsMake(-16, 0, 0, 0)];

            UILabel *threeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.btnThree.frame.origin.x, labelY, self.btnThree.frame.size.width, labelHeight)];
            threeLabel.textColor = RGB(106, 106, 106);
            threeLabel.font = [UIFont systemFontOfSize:11.0f];
            threeLabel.text = NSLocalizedString(@"tabBarPerson", nil);
            threeLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:threeLabel];
            
            [self addSubview:self.btnThree];
        }
    }
    return self;
}

- (void)setCurrentViewControllerIndex:(NSInteger)index{
    [self.btnOne setSelected:NO];
    [self.btnTwo setSelected:NO];
    [self.btnThree setSelected:NO];
    switch (index) {
        case 1:
            [self.btnOne setSelected:YES];
            break;
        case 2:
            [self.btnTwo setSelected:YES];
            break;
        case 3:
            [self.btnThree setSelected:YES];
            break;
        default:
            break;
    }
}

- (void)doBtnOne:(id)sender {
    if (!self.btnOne.selected) {
        
        HomeViewController *kViewCon = [SharedViewControllers homeViewCon];
        AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if ([del.navigationController.viewControllers containsObject:kViewCon]) {
            [del.navigationController popToViewController:kViewCon animated:NO];
        }else {
            [del.navigationController pushViewController:kViewCon animated:NO];
        }
    }
}

- (void)doBtnTwo:(id)sender {
    if (!self.btnTwo.selected) {
        ProgressViewController *kViewCon = [SharedViewControllers progressViewCon];
        AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if ([del.navigationController.viewControllers containsObject:kViewCon]) {
            [del.navigationController popToViewController:kViewCon animated:NO];
        }else {
            [del.navigationController pushViewController:kViewCon animated:NO];
        }
        
    }
}

- (void)doBtnThree:(id)sender {
    if (!self.btnThree.selected) {
        PersonViewController *kViewCon = [SharedViewControllers personViewCon];
        AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if ([del.navigationController.viewControllers containsObject:kViewCon]) {
            [del.navigationController popToViewController:kViewCon animated:NO];
        }else {
            [del.navigationController pushViewController:kViewCon animated:NO];
        }
    }
}



- (void)loginPress{
}
@end
