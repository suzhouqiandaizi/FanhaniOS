//
//  HomeHeaderView.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/4.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "HomeHeaderView.h"
#import "SDCycleScrollView.h"
#import "TaskClassificationViewController.h"
#import "AppDelegate.h"
#import "BannerObject.h"
#import "TaskObject.h"
#import "ShareThirdViewController.h"
#import "NewbieViewController.h"
#import "WebShowViewController.h"
#import "DituiViewController.h"
#import "JoinUsViewController.h"
#import <UMCommon/MobClick.h>

@interface HomeHeaderView()<SDCycleScrollViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,  UIImagePickerControllerDelegate>{
    NSArray             *bannerArr;
}
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhuanxieLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *voiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *hunheLabel;
@property (weak, nonatomic) IBOutlet UILabel *xinshouLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuijianLabel;
@property (weak, nonatomic) IBOutlet UIImageView *homejoinImageView;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIImageView *titleIconImageView;

@end

@implementation HomeHeaderView

- (id)initItem{
    self = [[[NSBundle mainBundle] loadNibNamed:@"HomeHeaderView" owner:self options:nil] lastObject];
    if (self) {
        self.allLabel.text = NSLocalizedString(@"headerAllButton", nil);
        self.videoLabel.text = NSLocalizedString(@"headerVideoButton", nil);
        self.imageLabel.text = NSLocalizedString(@"headerImageButton", nil);
        self.zhuanxieLabel.text = NSLocalizedString(@"headerZhuanXieButton", nil);
        self.textLabel.text = NSLocalizedString(@"headerTextButton", nil);
        self.voiceLabel.text = NSLocalizedString(@"headerVoiceButton", nil);
        self.hunheLabel.text = NSLocalizedString(@"headerHunheButton", nil);
        self.xinshouLabel.text = NSLocalizedString(@"headerXinshouButton", nil);
        self.tuijianLabel.text = NSLocalizedString(@"headerTuijianLabel", nil);
        
        self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        self.bannerView.delegate = self;
        self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentLeft;
        self.bannerView.showPageControl = YES;
        self.bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleEllipse;
        self.bannerView.currentPageDotColor = [UIColor whiteColor];
        self.bannerView.pageDotColor = RGB(154, 154, 154);
        self.bannerView.layer.masksToBounds = YES;
        self.bannerView.layer.cornerRadius = 10.0f;
        [self.bannerView setFrame:CGRectMake(15, self.bannerView.frame.origin.y, SCREEN_WIDTH_DEVICE - 30, 120 * SCREEN_SCALE)];
        [self.btnView setFrame:CGRectMake(0, self.bannerView.frame.origin.y + self.bannerView.frame.size.height + 15, SCREEN_WIDTH_DEVICE, self.btnView.frame.size.height)];
        
        float imageH = (74/650.0) * (SCREEN_WIDTH_DEVICE - 30);
        [self.homejoinImageView setFrame:CGRectMake(15, self.btnView.frame.origin.y + self.btnView.frame.size.height + 15, SCREEN_WIDTH_DEVICE - 30, imageH)];
        self.joinBtn.frame = self.homejoinImageView.frame;
        
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, self.homejoinImageView.frame.origin.y + self.homejoinImageView.frame.size.height + 45)];
        
        self.titleIconImageView.layer.masksToBounds = YES;
        self.titleIconImageView.layer.cornerRadius = 2.0f;
        
    }
    return self;
}

- (IBAction)joinPress {
    [MobClick event:@"SY_jiaruwomen"];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    JoinUsViewController *viewCon = [[JoinUsViewController alloc] initWithNibName:@"JoinUsViewController" bundle:nil];
    [del.navigationController pushViewController:viewCon animated:YES];
}

- (void)setBanners:(NSArray *)arr{
    if (arr.count > 0) {
        bannerArr = arr;
        NSMutableArray *banners = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++) {
            BannerObject *object = [arr objectAtIndex:i];
            [banners addObject:object.image];
        }
        self.bannerView.hidden = NO;
        self.bannerView.imageURLStringsGroup = banners;
    }else{
//        self.bannerView.hidden = YES;
    }
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld广告", index + 1);
    BannerObject *banner = [bannerArr objectAtIndex:index];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (banner.action == 1) {
        if ([banner.target isEqualToString:@"NewbieTaskPage"]) {
            NewbieViewController *viewCon = [[NewbieViewController alloc] initWithNibName:@"NewbieViewController" bundle:nil];
            [del.navigationController pushViewController:viewCon animated:YES];
        }else if ([banner.target isEqualToString:@"SharePage"]){
            ShareThirdViewController *viewCon = [[ShareThirdViewController alloc] initWithNibName:@"ShareThirdViewController" bundle:nil];
            [del.navigationController pushViewController:viewCon animated:YES];
        }else if ([banner.target isEqualToString:@"FeedbackPage"]){
            [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"FeedbackPage" withArguments:nil];
        }else if ([banner.target isEqualToString:@"ComplaintPage"]){
            [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"FeedbackPage" withArguments:nil];
        }else if ([banner.target isEqualToString:@"DiTuiSharePage"]){
            DituiViewController *viewCon = [[DituiViewController alloc] initWithNibName:@"DituiViewController" bundle:nil];
            [del.navigationController pushViewController:viewCon animated:YES];
        }else if ([banner.target isEqualToString:@"NewGuidePage"]){
            [MobClick event:@"SY_ban_yindao"];
            [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"NewGuidePage" withArguments:nil];
        }
        //SY_ban_bangdan
    }else if (banner.action == 2){
        WebShowViewController *viewCon = [[WebShowViewController alloc] initWithNibName:@"WebShowViewController" bundle:nil];
        viewCon.urlStr = banner.target;
        viewCon.whiteBackBtn = YES;
        [del.navigationController pushViewController:viewCon animated:YES];
    }
}

- (IBAction)allPress {
    [MobClick event:@"SY_class_quanbu"];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    TaskClassificationViewController *viewCon = [[TaskClassificationViewController alloc] initWithNibName:@"TaskClassificationViewController" bundle:nil];
    viewCon.classify = TaskClassify_all;
    [del.navigationController pushViewController:viewCon animated:YES];
}

- (IBAction)videoPress {
    [MobClick event:@"SY_class_shipin"];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    TaskClassificationViewController *viewCon = [[TaskClassificationViewController alloc] initWithNibName:@"TaskClassificationViewController" bundle:nil];
    viewCon.classify = TaskClassify_video;
    [del.navigationController pushViewController:viewCon animated:YES];
}

- (IBAction)imagePress {
    [MobClick event:@"SY_class_tupian"];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    TaskClassificationViewController *viewCon = [[TaskClassificationViewController alloc] initWithNibName:@"TaskClassificationViewController" bundle:nil];
    viewCon.classify = TaskClassify_image;
    [del.navigationController pushViewController:viewCon animated:YES];
}

- (IBAction)zhuanxiePress {
    [MobClick event:@"SY_class_zhuanxie"];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    TaskClassificationViewController *viewCon = [[TaskClassificationViewController alloc] initWithNibName:@"TaskClassificationViewController" bundle:nil];
    viewCon.classify = TaskClassify_transfer;
    [del.navigationController pushViewController:viewCon animated:YES];
}

- (IBAction)textPress {
    [MobClick event:@"SY_class_wenzi"];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    TaskClassificationViewController *viewCon = [[TaskClassificationViewController alloc] initWithNibName:@"TaskClassificationViewController" bundle:nil];
    [del.navigationController pushViewController:viewCon animated:YES];
}

- (IBAction)voicePress {
    [MobClick event:@"SY_class_yuyin"];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    TaskClassificationViewController *viewCon = [[TaskClassificationViewController alloc] initWithNibName:@"TaskClassificationViewController" bundle:nil];
    viewCon.classify = TaskClassify_voice;
    [del.navigationController pushViewController:viewCon animated:YES];
}

- (IBAction)hunhePress {
    [MobClick event:@"SY_class_hunhe"];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    TaskClassificationViewController *viewCon = [[TaskClassificationViewController alloc] initWithNibName:@"TaskClassificationViewController" bundle:nil];
    viewCon.classify = TaskClassify_mix;
    [del.navigationController pushViewController:viewCon animated:YES];
}

- (IBAction)xinshouPress {
    [MobClick event:@"SY_class_xinshou"];
    [[ActionPushFlutter sharePushFlutter] goFlutterPage:@"NewGuidePage" withArguments:nil];
}

@end
