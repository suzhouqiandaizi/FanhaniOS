//
//  SharedViewControllers.h
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "HomeViewController.h"
#import "ProgressViewController.h"
#import "PersonViewController.h"

@interface SharedViewControllers : NSObject

+ (HomeViewController *)homeViewCon;
+ (ProgressViewController *)progressViewCon;
+ (PersonViewController *)personViewCon;

@end
