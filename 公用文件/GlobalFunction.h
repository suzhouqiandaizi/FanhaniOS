//
//  GlobalFunction.h
//  testMessageCenter
//
//  Created by bin.yan on 14-7-22.
//  Copyright (c) 2014年 bin.yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mach/mach_time.h>
#import "XNBase64.h"
#import<CommonCrypto/CommonDigest.h>

#pragma mark ---  MD5加密
static inline NSString *md5EncryptionString(NSString *input){
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}


#pragma mark ---  颜色转图片
static inline UIImage *getColorToImage(UIColor *color){
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/// 获取代码执行时间的函数
static inline CGFloat excuteTime (void (^block)(void))
{
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS)
        return -1.0;
    
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    return (CGFloat)nanos / NSEC_PER_SEC;
}

/// 判断字符串是否全部都是空格
static inline BOOL isStrAllSpace(NSString * str)
{
    if ( str == nil )
        return YES;
    
    const char * pstr = str.UTF8String;
    NSInteger n = strlen(pstr);
    NSInteger i = 0;
    
    for (; i < n; i++ )
    {
        if ( (*(pstr + i) != ' ') && (*(pstr + i) != '\n') )
        {
            break;
        }
    }
    
    if (i == n)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark ---将NSDate转实际时间
static inline NSString * dateTurnTimeStr(NSDate * date){
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    NSDateFormatter * dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormate setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString * cDateStr = [dateFormate stringFromDate:localeDate];
    return cDateStr;
}

static inline BOOL dayEqual(NSString * s, NSString * d)
{
    NSRange range = {0, 10};
    NSString * s_sub = [s substringWithRange:range];
    NSString * d_sub = [d substringWithRange:range];
    
    if ([s_sub isEqualToString:d_sub])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
/// 把2014-08-04 15:12:39类型的字符串转换成14-08-04
static inline NSString * covnertDateStr(NSString * sourceDataStr)
{
    NSDateFormatter * dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateStyle:NSDateFormatterMediumStyle];
    [dateFormate setTimeStyle:NSDateFormatterShortStyle];
    [dateFormate setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate * todayDate = [NSDate date];
    NSString * todayString = [dateFormate stringFromDate:todayDate];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    //今年
    NSString *toYears;
    toYears = [[todayString description] substringToIndex:4];
    
    NSString *dateContent;
    NSDate *currentDate = [dateFormate dateFromString:sourceDataStr];
    NSDate *yesterday = [todayDate dateByAddingTimeInterval: -secondsPerDay];
    NSDate *beforeOfYesterday = [yesterday dateByAddingTimeInterval: -secondsPerDay];
    
    sourceDataStr = [dateFormate stringFromDate:currentDate];
    NSString *dateString = [[sourceDataStr description] substringToIndex:10];
    NSString *dateYears = [[sourceDataStr description] substringToIndex:4];
    [dateFormate setDateFormat:@"yyyy年MM月dd号 HH:mm"];
    NSString *currentdayString = [dateFormate stringFromDate:currentDate];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *beforeOfYesterdayString = [[beforeOfYesterday description] substringToIndex:10];
    
    
    if ([dateYears isEqualToString:toYears]) {//同一年
        //今 昨 前天的时间
        if ([[[sourceDataStr description] substringToIndex:10] isEqualToString:[[todayString description] substringToIndex:10]]){
            NSTimeInterval late = [currentDate timeIntervalSince1970]*1;
            NSTimeInterval now = [todayDate timeIntervalSince1970]*1;
            NSTimeInterval cha = now - late;
            if (cha/3600 < 1) {
                dateContent = [NSString stringWithFormat:@"%f", cha/60];
                dateContent = [dateContent substringToIndex:dateContent.length-7];
                int num= [dateContent intValue];
                if (num <= 1) {
                    dateContent = [NSString stringWithFormat:@"刚刚"];
                }else{
                    dateContent = [NSString stringWithFormat:@"%@分钟前", dateContent];
                }
            }else{
                NSString *time = [[currentdayString description] substringWithRange:(NSRange){12,5}];
                dateContent = [NSString stringWithFormat:@"今天 %@",time];
            }
            return dateContent;
        } else if ([dateString isEqualToString:yesterdayString]){
            NSString *time = [[currentdayString description] substringWithRange:(NSRange){12,5}];
            dateContent = [NSString stringWithFormat:@"昨天 %@",time];
            return dateContent;
        }else if ([dateString isEqualToString:beforeOfYesterdayString]){
            NSString *time = [[currentdayString description] substringWithRange:(NSRange){12,5}];
            dateContent = [NSString stringWithFormat:@"前天 %@",time];
            return dateContent;
        }else{
            //其他时间
            NSString *time2 = [[currentdayString description] substringWithRange:(NSRange){5,12}];
            return time2;
        }
    }else{
        return [[currentdayString description] substringToIndex:11];
    }
    
    
}

/// 把2014-08-04 15:12:39类型的字符串转换成14-08-04
static inline NSString * timeStamp(NSString * sourceDataStr)
{
    NSDateFormatter * dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate * currentDate = [NSDate dateWithTimeIntervalSince1970:[sourceDataStr floatValue]];
    NSString * cDateStr = [dateFormate stringFromDate:currentDate];
    
    return cDateStr;
}

static inline NSString* compareDate(float sourceDataStr){
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
//    //修正8小时之差
    NSDate *date1 = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date1];
    NSDate *localeDate = [date1  dateByAddingTimeInterval: interval];
    
//    NSLog(@"nowdate=%@\nolddate = %@",localeDate,date);
    NSDate *today = localeDate;
    NSDate *yesterday,*beforeOfYesterday;
    //今年
    NSString *toYears;
    
    toYears = [[today description] substringToIndex:4];
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    beforeOfYesterday = [yesterday dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *beforeOfYesterdayString = [[beforeOfYesterday description] substringToIndex:10];
    
    NSDateFormatter * dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormate setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate * currentDate = [[NSDate dateWithTimeIntervalSince1970:sourceDataStr] dateByAddingTimeInterval: interval];
    NSString * cDateStr = [dateFormate stringFromDate:currentDate];
    
    NSString *dateString = [[cDateStr description] substringToIndex:10];
    NSString *dateYears = [[cDateStr description] substringToIndex:4];
    
    NSString *dateContent;
    if ([dateYears isEqualToString:toYears]) {//同一年
        //今 昨 前天的时间
        if ([dateString isEqualToString:todayString]){
            NSTimeInterval late = [currentDate timeIntervalSince1970]*1;
            NSTimeInterval now = [localeDate timeIntervalSince1970]*1;
            NSTimeInterval cha = now - late;
            if (cha/3600 < 1) {
                dateContent = [NSString stringWithFormat:@"%f", cha/60];
                dateContent = [dateContent substringToIndex:dateContent.length-7];
                int num= [dateContent intValue];
                if (num <= 1) {
                    dateContent = [NSString stringWithFormat:@"刚刚"];
                }else{
                    dateContent = [NSString stringWithFormat:@"%@分钟前", dateContent];
                }
            }else{
                NSString *time = [[cDateStr description] substringWithRange:(NSRange){11,5}];
                dateContent = [NSString stringWithFormat:@"今天 %@",time];
            }
            return dateContent;
        } else if ([dateString isEqualToString:yesterdayString]){
            NSString *time = [[cDateStr description] substringWithRange:(NSRange){11,5}];
            dateContent = [NSString stringWithFormat:@"昨天 %@",time];
            return dateContent;
        }else if ([dateString isEqualToString:beforeOfYesterdayString]){
            NSString *time = [[cDateStr description] substringWithRange:(NSRange){11,5}];
            dateContent = [NSString stringWithFormat:@"前天 %@",time];
            return dateContent;
        }else{
            //其他时间
            NSString *time2 = [[cDateStr description] substringWithRange:(NSRange){5,11}];
            return time2;
        }
    }else{
        return dateString;
    }
}

#pragma mark --- 获取UUID

static inline NSString * getUUID(void)
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uniqueId = (__bridge_transfer NSString *)uuidStringRef;
    return uniqueId;
}

#pragma mark --- 去除url后面的随机后缀
static inline NSString * FileDownload_pathWithoutRandomSuffix(NSString * originalStr)
{
    NSRange range = [originalStr rangeOfString:@"?"];
    if( range.location == NSNotFound )
    {
        return originalStr;
    }
    
    NSRange subStrRange = NSMakeRange(0, range.location);
    return [originalStr substringWithRange:subStrRange];
}

#pragma mark --- 修改字符串属性

static inline UILabel *changeLabelAttribute(UILabel *theLab, NSInteger devStart, NSInteger devEnd,UIColor *allColor, UIColor *markColor, float markFontSize, BOOL isBold){
    NSString *tempStr = theLab.text;
    if (!tempStr) {
        return nil;
    }
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    [strAtt addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(0, [strAtt length])];
    if(devStart > 0){
        devStart = devStart - 1;
    }else{
        devStart = 0;
    }
    NSRange startRange = NSMakeRange(devStart, 1);
    NSRange endRangeOne = NSMakeRange(tempStr.length-devEnd, 1);
    if(startRange.location>=endRangeOne.location){
        [theLab setTextColor:allColor];
        return theLab;
    }
    // 更改字符颜色
    NSRange markRange = NSMakeRange(startRange.location+startRange.length, endRangeOne.location-(startRange.location+startRange.length));
    // 更改字符颜色
    [strAtt addAttribute:NSForegroundColorAttributeName value:markColor range:markRange];
    // 更改字体
    if (markFontSize > 0) {
        if (isBold) {
            [strAtt addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:markFontSize] range:markRange];
        }else{
            [strAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:markFontSize] range:markRange];
        }
        
    }
    theLab.attributedText = strAtt;
    return theLab;
}

#pragma mark --- 替换字符串。例如150****7225

static inline NSString *replaceStringWithAsterisk(NSString *originalStr, NSInteger startLocation, NSInteger lenght)
{
    NSString *newStr = originalStr;
    for (int i = 0; i < lenght; i++) {
        NSRange range = NSMakeRange(startLocation, 1);
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@"*"];
        startLocation ++;
    }
    return newStr;
}


#pragma mark --- 在给UIVIEW添加阴影

static inline void addShadowToView(UIView *view, float shadowOpacity, CGFloat shadowRadius, CGFloat cornerRadius){
    //////// shadow /////////
    CALayer *shadowLayer = [CALayer layer];
//    shadowLayer.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, SCREEN_WIDTH_DEVICE - 20, view.frame.size.height);
    shadowLayer.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    
    shadowLayer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = CGSizeMake(0, 0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    
    //////// cornerRadius /////////
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [view.superview.layer insertSublayer:shadowLayer below:view.layer];
}
static inline NSString *reSizeImageData(UIImage *sourceImage, CGFloat maxImageSize, CGFloat  maxSizeWithKB){
    if (maxSizeWithKB <= 0.0) maxSizeWithKB = 1024.0;
    if (maxImageSize <= 0.0) maxImageSize = 1024.0;
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    CGFloat tempHeight = newSize.height / maxImageSize;
    CGFloat tempWidth = newSize.width / maxImageSize;
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    CGFloat sizeOriginKB = imageData.length / 1024.0;
    CGFloat resizeRate = 0.9;
    while (sizeOriginKB > maxSizeWithKB && resizeRate > 0.1) {
        imageData = UIImageJPEGRepresentation(newImage,resizeRate);
        sizeOriginKB = imageData.length / 1024.0;
        resizeRate -= 0.1;
    }
    return [imageData base64EncodedString];
}

static inline NSString *currentLocaleLanuage(void){
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLocaleLanguageCode;
    if (languages.count>0) {
        currentLocaleLanguageCode = languages.firstObject;
        if ([currentLocaleLanguageCode hasPrefix:@"en"]) {
            currentLocaleLanguageCode = @"en";
        }
        else if ([currentLocaleLanguageCode hasPrefix:@"zh"]) {
            currentLocaleLanguageCode = @"zh";
        }
        else {
            currentLocaleLanguageCode = @"en";
        }
    }
    else {
        currentLocaleLanguageCode = @"en";
    }
    return currentLocaleLanguageCode;
}


@interface GlobalFunction : NSObject

@end
