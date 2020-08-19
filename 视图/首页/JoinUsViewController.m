//
//  JoinUsViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/18.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "JoinUsViewController.h"
#import "UIColor+Hexadecimal.h"
#import "UIActionSheet+Blocks.h"

@interface JoinUsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation JoinUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:19.0f]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIColor bm_colorGradientChangeWithSize:CGSizeMake(SCREEN_WIDTH_DEVICE, 64 + IS_iPhoneX_Top) direction:GradientChangeDirectionVertical startColor:[UIColor colorWithHex:0xff2567E7] endColor:[UIColor colorWithHex:0xff427DF6]] forBarMetrics:UIBarMetricsDefault];
    self.title = NSLocalizedString(@"joinUsTitle", nil);
    [self addWhiteBackBtn];
    [self.scrollView setFrame:CGRectMake(0, 64 + IS_iPhoneX_Top, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE - 64 - IS_iPhoneX_Top)];
    float imageHeight = (1531/750.0)*SCREEN_WIDTH_DEVICE;
    [self.imageView setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, imageHeight)];
    self.scrollView.alwaysBounceVertical = YES;
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH_DEVICE, imageHeight)];
    
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imglongTapClick:)];
    [self.imageView addGestureRecognizer:longTap];
    // Do any additional setup after loading the view from its nib.
}


 -(void)imglongTapClick:(UILongPressGestureRecognizer*)gesture{
     if(gesture.state==UIGestureRecognizerStateBegan){
         [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:NSLocalizedString(@"cancelButton", nil) destructiveButtonTitle:nil otherButtonTitles:@[NSLocalizedString(@"joinusSaveImage", nil)] tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
             if (buttonIndex==0) {
                 UIImageView *currentImageView = (UIImageView *)gesture.view;
                 UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
             }
         }];
     }
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [self showHUDAlert:NSLocalizedString(@"joinusSaveImageSuccess", nil)];
    }else{
        [self showHUDAlert:NSLocalizedString(@"joinusSaveImageFail", nil)];
    }
}

@end
