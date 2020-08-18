//
//  BannerObject.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/5.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerObject : NSObject
@property (assign, nonatomic) NSInteger action;
@property (copy, nonatomic) NSString *created;
@property (copy, nonatomic) NSString *bannerID;
@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *locale;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *params;
@property (copy, nonatomic) NSString *seq;
@property (copy, nonatomic) NSString *target;
@property (copy, nonatomic) NSString *updated;
@property (copy, nonatomic) NSString *valid;
@end

NS_ASSUME_NONNULL_END
