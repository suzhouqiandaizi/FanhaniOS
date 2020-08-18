//
//  TaskObject.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/5.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TaskClassify) {
    TaskClassify_all        = 0, //全部
    TaskClassify_text       = 1, //文本任务
    TaskClassify_video      = 2, //视频任务
    TaskClassify_image      = 3, //图片任务
    TaskClassify_transfer   = 4, //转写任务
    TaskClassify_voice      = 5, //语音任务
    TaskClassify_mix        = 6, //混合任务
    TaskClassify_new        = 7, //新手任务
};

@interface TaskObject : NSObject

@property (assign, nonatomic) TaskClassify taskClassify;
//任务分类：1-个人项目，2-团队项目
@property (copy, nonatomic) NSString *category;
//数据类型：0-全部，1-语音，2-图片，3-文本，4-视频
@property (copy, nonatomic) NSString *dataType;
@property (copy, nonatomic) NSString *gclifetime;
//任务id
@property (copy, nonatomic) NSString *taskID;
@property (copy, nonatomic) NSString *keepTime;
@property (copy, nonatomic) NSString *managerName;
@property (copy, nonatomic) NSString *maxCheckTime;
@property (copy, nonatomic) NSString *maxLayer;
@property (copy, nonatomic) NSString *maxlifetime;
@property (copy, nonatomic) NSString *name;
//权限类型：0-全部，1-有权限，2-无权限
@property (copy, nonatomic) NSString *permission;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *recycleTime;
@property (copy, nonatomic) NSString *reportTime;
@property (copy, nonatomic) NSString *salaryType;
//sop类型：5005-文本采集，5006-图片采集，5004-混合采集，5008-视频采集，5007-音频采集，5010-语音转写
@property (copy, nonatomic) NSString *sopType;
@property (copy, nonatomic) NSString *startTime;
//状态：1-进行中 2 暂停的项目 0 未发布的项目 8 已完成的项目
@property (copy, nonatomic) NSString *status;
//自检状态
@property (copy, nonatomic) NSString *status4QC;
/*
 未发布的项目
 0 新建的项目
1 完成了profile
2 完成了业务类型
3 完成了质检报价
7 审核中
8 审核失败
9 审核通过
 进行中的项目
 10 进行中
 11 即将结束
 12 质检中
 13 返修中
 */
@property (copy, nonatomic) NSString *subStatus;
//类型：0-全部，1-标注，2-采集
@property (copy, nonatomic) NSString *type;
@end

NS_ASSUME_NONNULL_END
