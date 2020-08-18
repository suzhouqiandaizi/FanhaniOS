//
//  BannerObject.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/5.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "BannerObject.h"

@implementation BannerObject
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"bannerID" : @"id"
    };
}
@end
