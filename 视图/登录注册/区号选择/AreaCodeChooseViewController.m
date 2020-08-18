//
//  AreaCodeChooseViewController.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/7/30.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "AreaCodeChooseViewController.h"
#import "AreaCodeChooseTableViewCell.h"

@interface AreaCodeChooseViewController (){
    NSArray *contentArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;

@end

@implementation AreaCodeChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self.tableVIew setFrame:CGRectMake(0, 64 + IS_iPhoneX_Top, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE - 64 - IS_iPhoneX_Top)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countrycode" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    contentArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    [self.tableVIew reloadData];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UITableView datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AreaCodeChooseCell";
    AreaCodeChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AreaCodeChooseTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = [contentArr objectAtIndex:indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@,%@", [dic objectForKey:@"name"], [dic objectForKey:@"value"]];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    NSDictionary *dic = [contentArr objectAtIndex:indexPath.row];
    if (self.RefreshHandle) {
        self.RefreshHandle([dic objectForKey:@"value"]);
    }
    [self goBackAction];
}

@end
