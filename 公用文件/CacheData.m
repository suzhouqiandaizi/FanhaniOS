//
//  CacheData.m
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import "CacheData.h"



@implementation CacheData

+ (BOOL)fileExist:(NSString *)fileName{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew = [paths stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileNameNew]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)writeApplicationData:(id)data  writeFileName:(NSString *)fileName
{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fileNameNew])
    {
        [fileManager createDirectoryAtPath:paths withIntermediateDirectories:YES attributes:nil error:nil];
        return [data writeToFile:fileNameNew atomically:YES];//将NSData类型对象data写入文件，文件名为FileName
    }else{
        return [data writeToFile:fileNameNew atomically:YES];
    }
}

+ (BOOL)write:(NSString *)str  writeFileName:(NSString *)fileName
{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fileNameNew])
    {
        [fileManager createDirectoryAtPath:paths withIntermediateDirectories:YES attributes:nil error:nil];
//        return[str writeToFile:fileNameNew atomically:YES];//将NSData类型对象data写入文件，文件名为FileName
        return [str writeToFile:fileNameNew atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else
        return NO;
}

+ (id)readApplicationArr:(NSString *)fileName
{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
    NSArray *myData = [[NSArray alloc] initWithContentsOfFile:fileNameNew];
    return myData;
}

+ (id)readApplicationDic:(NSString *)fileName
{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
    NSDictionary *myData = [[NSDictionary alloc] initWithContentsOfFile:fileNameNew];
    return myData;
}

+ (id)readApplicationData:(NSString *)fileName
{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
    NSData *myData = [[NSData alloc] initWithContentsOfFile:fileNameNew];
    return myData;
}

+ (id)readApplicationStr:(NSString *)fileName
{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
//    NSString *myData = [[NSString alloc] initWithContentsOfFile:fileNameNew];
    NSString *myData = [[NSString alloc] initWithContentsOfFile:fileNameNew encoding:NSUTF8StringEncoding error:nil];
    return myData;
}

+ (void)removeCacheData:(NSString *)fileName
{
    NSString *paths = [NSString stringWithFormat:@"%@", Publication_CacheData_Directory];
    NSString *fileNameNew=[paths stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:fileNameNew error:nil];
}

@end
