//
//  TaskObject.m
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/5.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import "TaskObject.h"

@implementation TaskObject

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"taskID" : @"id"
    };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([property.name isEqualToString:@"startTime"]) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [fmt stringFromDate: [NSDate dateWithTimeIntervalSince1970:[oldValue longValue]]];
        return dateString;
    }else if ([property.name isEqualToString:@"sopType"]) {
        if ([oldValue integerValue] == 5004) {
            self.taskClassify = TaskClassify_mix;
        }else if ([oldValue integerValue] == 5005){
            self.taskClassify = TaskClassify_text;
        }else if ([oldValue integerValue] == 5006){
            self.taskClassify = TaskClassify_image;
        }else if ([oldValue integerValue] == 5007){
            self.taskClassify = TaskClassify_voice;
        }else if ([oldValue integerValue] == 5008){
            self.taskClassify = TaskClassify_video;
        }else if ([oldValue integerValue] == 5010){
            self.taskClassify = TaskClassify_transfer;
        }else{
            self.taskClassify = TaskClassify_all;
        }
        return oldValue;
    }
    return oldValue;
}

@end
