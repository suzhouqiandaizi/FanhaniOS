//
//  CoinDetailViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/17.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "CoinDetailViewController.h"

@interface CoinDetailViewController ()

@end

@implementation CoinDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    self.title = NSLocalizedString(@"coinDetailed", nil);
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
