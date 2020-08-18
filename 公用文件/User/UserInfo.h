//
//  UserInfo.h
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class UserLoginRecord;

@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *education;
@property (nonatomic, copy) NSString *ethnicity;
@property (copy, nonatomic) NSString *gender;
@property (copy, nonatomic) NSString *income;
@property (copy, nonatomic) NSString *industry;
@property (copy, nonatomic) NSString *language;
@property (copy, nonatomic) NSString *marital;
@property (copy, nonatomic) NSString *motherLanguage;
@property (copy, nonatomic) NSString *nationality;
@property (copy, nonatomic) NSString *profileComplete;
@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *username;

@property (strong, nonatomic) UserLoginRecord *record;
@end
