//
//  NSString_extesion.h
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (extension)

- (BOOL)isValidCellphoneNumber;
- (BOOL)isValidEmailAddress;
+ (NSString *)UUIDString;
+ (BOOL)ytIsEmpty:(NSString*) string;
+ (NSString *)moneyChange:(double)amount;
+ (NSString *)qixianChange:(NSInteger)time;

@end
