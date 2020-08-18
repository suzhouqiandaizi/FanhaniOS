//
//  WZYLabel.m
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import "WZYLabel.h"
#import "AppDelegate.h"

@implementation WZYLabel

- (void)setShouldGestureRecognizer:(BOOL)shouldGestureRecognizer{
    if (shouldGestureRecognizer) {
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)]];
    }
}

- (void)longPressGestureRecognized:(UIGestureRecognizer *) gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // 让label成为第一响应者
        [self becomeFirstResponder];
        // 获得菜单
        UIMenuController *menu = [UIMenuController sharedMenuController];
        // 设置菜单内容，显示中文，所以要手动设置app支持中文
        menu.menuItems = @[
                           [[UIMenuItem alloc] initWithTitle:@"复制邀请码" action:@selector(yaoqing:)],
                           [[UIMenuItem alloc] initWithTitle:@"分享给好友" action:@selector(share:)],
                           ];
        
        // 菜单最终显示的位置
        [menu setTargetRect:self.bounds inView:self];
        // 显示菜单
        [menu setMenuVisible:YES animated:YES];
    }
}

#pragma mark - UIMenuController相关
/**
 * 让Label具备成为第一响应者的资格
 */
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

/**
 * 通过第一响应者的这个方法告诉UIMenuController可以显示什么内容
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ( (action == @selector(copy:) && self.copyEnable) // 需要有文字才能支持复制
        || (action == @selector(cut:) && self.cutEnable) // 需要有文字才能支持剪切
        || (action == @selector(paste:) && self.pasteEnable)
        || (action == @selector(yaoqing:) && self.yaoqingEnable)
        || (action == @selector(share:) && self.shareEnable)) return YES;
    
    return NO;
}

#pragma mark - 监听MenuItem的点击事件
- (void)cut:(UIMenuController *)menu
{
    // 将label的文字存储到粘贴板
    [UIPasteboard generalPasteboard].string = self.text;
    // 清空文字
    self.text = nil;
}

- (void)copy:(UIMenuController *)menu
{
    // 将label的文字存储到粘贴板
    [UIPasteboard generalPasteboard].string = self.text;
}

- (void)paste:(UIMenuController *)menu
{
    // 将粘贴板的文字赋值给label
    self.text = [UIPasteboard generalPasteboard].string;
}

- (void)yaoqing:(UIMenuController *)menu
{
    [UIPasteboard generalPasteboard].string = self.text;
}

- (void)share:(UIMenuController *)menu
{
//    AppDelegate *del = [[UIApplication sharedApplication] delegate];
//    [del.navigationController.topViewController.view.window addSubview:[[ShareView alloc] initItemContent:[NSString stringWithFormat:@"快来使用邀请码%@，注册史上最牛的俱乐部，惊喜等着您！", self.text] withUrl:nil]];
}

@end
