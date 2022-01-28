//
//  Helper.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "Helper.h"

NSString * const kCurrentSiteKey = @"CurrentSite";

@implementation Helper
+ (TuyaResidenceSiteModel *)getCurrentSiteModel {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id value = [defaults objectForKey:kCurrentSiteKey];
    
    if (!value) {
        return nil;
    }
    long long siteId = [value longLongValue];
    
    TuyaResidenceSite *site = [TuyaResidenceSite siteWithSiteId:siteId];
    if (!site) {
        return nil;
    }
    return site.siteModel;
}

+ (void)setCurrentSiteModelWithSiteId:(NSString *)siteId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:siteId forKey:kCurrentSiteKey];
    [defaults synchronize];
}

+ (NSInteger)decimalByBinaryStr:(NSString *)binaryStr {
    
    NSInteger decimal = 0;
    for (int i = 0; i < binaryStr.length; i++) {
        NSString *number = [binaryStr substringWithRange:NSMakeRange(binaryStr.length - i - 1, 1)];
        if ([number isEqualToString:@"1"]) {
            decimal += pow(2, i);
        }
    }
    
    return decimal;
}

+ (NSInteger)clockWithTimestamp:(long)timestamp {
    
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit =  NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmps = [calendar components:unit fromDate:d];
    NSInteger hour = cmps.hour;
    NSInteger minute = cmps.minute;
    NSInteger minutes = hour * 60 + minute;
    
    return minutes;
}

@end
