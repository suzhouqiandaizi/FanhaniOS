//
//  CustomTextField.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/12.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width -20, bounds.size.height);//更好理解些
    return inset;
}


// 修改文本展示区域，一般跟editingRectForBounds一起重写
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x, bounds.origin.y, (SCREEN_WIDTH_DEVICE-160), bounds.size.height);
    return inset;
}

// 重写来编辑区域，可以改变光标起始位置，以及光标最右到什么地方，placeHolder的位置也会改变
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset;
    if (self.text.length > 0) {
        inset = CGRectMake(bounds.origin.x, bounds.origin.y, (SCREEN_WIDTH_DEVICE-160), bounds.size.height);//更好理解些
    }
    else {
        
        inset = CGRectMake(bounds.origin.x+bounds.size.width / 2, bounds.origin.y, bounds.size.width - bounds.size.width / 2, bounds.size.height);//更好理解些
    }
    return inset;
}

@end
