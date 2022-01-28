//
//  QueryViewController.h
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, APICode) {
    APICodeQueryAppAccess = 100,
    APICodeQueryPsswordAccess = 101,
    APICodeCheckAccessAuthorization = 102,
    APICodeCheckAccessAccount = 103,
    APICodeQueryAppAccessUserDetail = 104,
    APICodeQueryAppAccessPassRecord = 105,
    APICodeQueryAppAccessTotal = 106,
    APICodeUpdateAppAccess = 107,
    APICodeAddAppAccessDevice = 108,
    APICodeRemoveAppAccessDevice = 109,
    APICodeRemoveAppAccess = 110,
    APICodeQueryPasswordAccessUserDetail = 112,
    APICodeQueryPasswordAccessPassRecord = 113,
    APICodeQueryPasswordAccessTotal = 114,
    APICodeAddPasswordAccessDevice = 115,
    APICodeRemovePasswordAccessDevice = 116,
    APICodeRemovePasswordAccess = 117,
    APICodeUpdatePasswordAccessValidity = 119,
    APICodeUpdatePasswordAccessNickname = 120,
};

NS_ASSUME_NONNULL_BEGIN

@interface QueryViewController : UIViewController
@property (nonatomic, assign) APICode apiCode;
@end

NS_ASSUME_NONNULL_END
