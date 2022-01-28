//
//  Helper.h
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Helper : NSObject
+ (TuyaResidenceSiteModel *)getCurrentSiteModel;
+ (void)setCurrentSiteModelWithSiteId:(NSString *)siteId;

+ (NSInteger)decimalByBinaryStr:(NSString *)binaryStr;
+ (NSInteger)clockWithTimestamp:(long)timestamp;
@end

NS_ASSUME_NONNULL_END
