//
//  SharedViewControllers.m
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import "SharedViewControllers.h"

@implementation SharedViewControllers

+ (HomeViewController *)homeViewCon{
    static dispatch_once_t once;
    static HomeViewController *kViewCon = nil;
    dispatch_once(&once, ^{
        if (!kViewCon) {
            kViewCon = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        }
    });
    return kViewCon;
}

+ (ProgressViewController *)progressViewCon{
    static dispatch_once_t once;
    static ProgressViewController *kViewCon = nil;
    dispatch_once(&once, ^{
        if (!kViewCon) {
            kViewCon = [[ProgressViewController alloc] initWithNibName:@"ProgressViewController" bundle:nil];
        }
    });
    return kViewCon;
}

+ (PersonViewController *)personViewCon{
    static dispatch_once_t once;
    static PersonViewController *kViewCon = nil;
    dispatch_once(&once, ^{
        if (!kViewCon) {
            kViewCon = [[PersonViewController alloc] initWithNibName:@"PersonViewController" bundle:nil];
        }
    });
    return kViewCon;
}


@end
