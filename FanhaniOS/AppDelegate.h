//
//  AppDelegate.h
//  fanhan_iOS
//
//  Created by WangZhenyu on 2020/7/22.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import "CustomFlutterViewController.h"

@interface AppDelegate : FlutterAppDelegate <UIApplicationDelegate, FlutterAppLifeCycleProvider>
@property (strong, nonatomic) CustomNavigationCoutroller *navigationController;
@property (strong, nonatomic) FlutterEngine *flutterEngine;
@property (strong, nonatomic) CustomFlutterViewController *flutterViewCon;

@end

