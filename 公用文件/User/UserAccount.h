//
//  UserAccount.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/11.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserAccount : NSObject
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *weixin;
@property (copy, nonatomic) NSString *code;
@property (copy, nonatomic) NSString *mail;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *uptype;
@end

NS_ASSUME_NONNULL_END
