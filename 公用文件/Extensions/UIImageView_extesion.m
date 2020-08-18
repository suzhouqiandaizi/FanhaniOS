//
//  UIImageView_extesion.m
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import "UIImageView_extesion.h"
#import "AppDelegate.h"
//#import "PeerDetailViewController.h"

@implementation UIImageView (extension)

- (void)addGestureRecognizerHandlePersonDetail{
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleToPersonDetail)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)setPersonId:(NSString *)peopleId{
    self.tag = [peopleId integerValue] + 1000;
}

- (void)handleToPersonDetail{
    NSString *userId = [NSString stringWithFormat:@"%ld", self.tag - 1000];
    if (userId.length > 0) {
//        AppDelegate *del = [[UIApplication sharedApplication] delegate];
//        PeerDetailViewController *viewCon = [[PeerDetailViewController alloc] initWithNibName:@"PeerDetailViewController" bundle:nil];
//        viewCon.peopleId = userId;
//        [del.navigationController pushViewController:viewCon animated:YES];
    }
}

@end
