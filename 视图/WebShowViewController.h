//
//  AboutOurViewController.h
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebShowViewController : UIViewController

@property (copy, nonatomic) NSString *urlStr;
@property (copy, nonatomic) NSString *shareURL;
@property (copy, nonatomic) NSString *shareTitle;
@property (copy, nonatomic) NSString *shareContent;
@property (copy, nonatomic) UIImage *shareIcon;
@property (assign, nonatomic) BOOL whiteBackBtn;
@end
