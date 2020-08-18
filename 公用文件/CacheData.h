//
//  CacheData.h
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheData : NSObject

+ (BOOL)fileExist:(NSString *)fileName;
+ (BOOL)writeApplicationData:(id)data  writeFileName:(NSString *)fileName;
+ (id)readApplicationArr:(NSString *)fileName;
+ (id)readApplicationDic:(NSString *)fileName;
+ (id)readApplicationStr:(NSString *)fileName;
+ (id)readApplicationData:(NSString *)fileName;
+ (void)removeCacheData:(NSString *)fileName;
+ (BOOL)write:(NSString *)str  writeFileName:(NSString *)fileName;
@end
