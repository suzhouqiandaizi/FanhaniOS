//
//  NewbieObject.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/17.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewbieObject : NSObject
@property (assign, nonatomic) NSInteger activityID;
@property (copy, nonatomic) NSString *activityName;
@property (copy, nonatomic) NSString *activityType;
@property (copy, nonatomic) NSString *created;
@property (copy, nonatomic) NSString *descriptionStr;
@property (copy, nonatomic) NSString *income;
@property (copy, nonatomic) NSString *rewardStr;
@property (assign, nonatomic) NSInteger status;
@property (copy, nonatomic) NSString *updated;
@end

NS_ASSUME_NONNULL_END
