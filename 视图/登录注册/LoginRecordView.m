//
//  LoginRecordView.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/5.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "LoginRecordView.h"
#import "LoginRecordTableViewCell.h"
#import "UserLoginRecord.h"

@interface LoginRecordView()<UITableViewDelegate, UITableViewDataSource>{
    NSMutableDictionary *contentDic;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LoginRecordView


- (id)initItem:(CGRect)rect{
    self = [[[NSBundle mainBundle] loadNibNamed:@"LoginRecordView" owner:self options:nil] lastObject];
    if (self) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 15.0f;
        [self setFrame:rect];
    }
    return self;
}

- (void)showContent{
    contentDic = [NSMutableDictionary dictionaryWithDictionary:[UserManger getUserLoginedRecord]];
    [contentDic removeObjectForKey:@"wechat"];
    [contentDic removeObjectForKey:@"quick"];
    NSInteger count = contentDic.allKeys.count;
    if (count == 0) {
        if (self.HidenHandle) {
            self.HidenHandle();
        }
    }else{
        if (count >= 5) {
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 50 * 5)];
        }else{
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 50 * contentDic.allKeys.count)];
        }
        
        [self.tableView reloadData];
    }
    
}


#pragma mark - UITableView datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contentDic.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LoginRecordCell";
    LoginRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LoginRecordTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.RefreshHandle = ^{
        [self showContent];
        [self.tableView reloadData];
    };
    UserLoginRecord *user = [contentDic objectForKey:[contentDic.allKeys objectAtIndex:indexPath.row]];
    cell.titleLabel.text = user.username;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if (self.ChooseHandle) {
        UserLoginRecord *user = [contentDic objectForKey:[contentDic.allKeys objectAtIndex:indexPath.row]];
        self.ChooseHandle(user);
    }
}
@end
