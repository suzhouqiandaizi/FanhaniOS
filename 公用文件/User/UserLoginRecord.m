//
//  UserLoginRecord.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/5.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "UserLoginRecord.h"

@implementation UserLoginRecord
- (id)init{
    self = [super init];
    if(self)
    {
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.wxOauth forKey:@"wxOauth"];
    [aCoder encodeObject:self.wxOpenId forKey:@"wxOpenId"];
    [aCoder encodeObject:self.wxToken forKey:@"wxToken"];
    [aCoder encodeInteger:self.loginType forKey:@"loginType"];
    
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.wxOauth = [aDecoder decodeObjectForKey:@"wxOauth"];
        self.wxOpenId = [aDecoder decodeObjectForKey:@"wxOpenId"];
        self.wxToken = [aDecoder decodeObjectForKey:@"wxToken"];
        self.loginType = [aDecoder decodeIntegerForKey:@"loginType"];
    }
    return self;
}

@end
