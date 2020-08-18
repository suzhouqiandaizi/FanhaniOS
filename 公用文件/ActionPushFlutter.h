//
//  ActionPushFlutter.h
//  FanhaniOS
//
//  Created by WangZhenyu on 2020/8/12.
//  Copyright © 2020 WangZhenyu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActionPushFlutter : NSObject
+ (ActionPushFlutter *)sharePushFlutter;
- (void)goFlutterPage:(NSString *)pageName withArguments:(NSDictionary *__nullable)arguments;
///防止首次push flutter出现闪屏等问题
- (void)initFlutterPage;
- (void)initMessage;
@end

NS_ASSUME_NONNULL_END
