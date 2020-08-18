//
//  CustomFlutterViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/13.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "CustomFlutterViewController.h"

@interface CustomFlutterViewController ()

@end

@implementation CustomFlutterViewController

- (void)willMoveToParentViewController:(UIViewController *)parent{
    [super willMoveToParentViewController:parent];
    
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        if (self.hideKeyboardHandle) {
            self.hideKeyboardHandle();
        }
    }
}
@end
