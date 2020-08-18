
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import "NSString_extesion.h"

@implementation NSString (extension)


+(NSString *)UUIDString
{
    // Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    // Get the string representation of CFUUID object.
    NSString *uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
    CFRelease(uuidObject);
    NSMutableString* string = [NSMutableString stringWithString:uuidStr];
    [string replaceOccurrencesOfString:@"-" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, string.length)];
    return [NSString stringWithString:string];
}


-(BOOL)isValidCellphoneNumber
{
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

-(BOOL)isValidEmailAddress
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

+(BOOL) ytIsEmpty:(NSString *)string
{
    if (string) {
        if (string.length == 0) {
            return YES;
        }
        return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
    }
    return YES;
}

+ (NSString *)moneyChange:(double)amount{
    if (amount >= 10000 * 10000) {
        return [NSString stringWithFormat:@"%g亿", amount/10000.0/10000.0];
    }else if (amount >= 10000) {
        return [NSString stringWithFormat:@"%g万", amount/10000.0];
    }else{
        return [NSString stringWithFormat:@"%g元", amount];
    }
}

+ (NSString *)qixianChange:(NSInteger)time{
    if (time <= 12) {
        return [NSString stringWithFormat:@"%ld个月", (long)time];
    }else{
        return [NSString stringWithFormat:@"%ld年", (long)(time/12)];
    }
}
@end
