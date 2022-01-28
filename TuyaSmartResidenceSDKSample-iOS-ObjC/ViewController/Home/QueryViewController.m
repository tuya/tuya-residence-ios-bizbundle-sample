//
//  QueryViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "QueryViewController.h"

@interface QueryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentSiteLabel;
@property (weak, nonatomic) IBOutlet UITextView *jsonTextView;
@property (nonatomic, strong) TuyaResidenceAccess *access;
@end

@implementation QueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentSiteLabel.text = [NSString stringWithFormat:@"Current Site: %@", [Helper getCurrentSiteModel].name];
    
    [self fetchData];
}

- (void)fetchData {
    
    long long siteId = [Helper getCurrentSiteModel].siteId;
    
    ty_weakify(self)
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    switch (self.apiCode) {
        case APICodeQueryAppAccess:
        {
            [self.access fetchAppAccessListWithSiteId:siteId effective:YES pageNo:1 pageSize:20 success:^(NSArray<TuyaResidenceAppAccessModel *> * _Nonnull userList) {
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = [NSString stringWithFormat:@"%@", [userList yy_modelToJSONObject]];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
        }
            break;
        case APICodeQueryPsswordAccess:
        {
            [self.access fetchPasswordAccessListWithSiteId:siteId effective:YES pageNo:1 pageSize:20 success:^(NSArray<TuyaResidencePasswordAccessModel *> * _Nonnull accessPasswordList) {
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = [NSString stringWithFormat:@"%@", [accessPasswordList yy_modelToJSONObject]];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
        case APICodeCheckAccessAuthorization:
        {
             
            NSString *username = @"xxx@mail.com"; // account
            
            [self.access checkAccessAuthorizationWithSiteId:siteId userName:username success:^(TuyaResidenceAccessMemberType result) {
                ty_strongify(self)
                
                NSString *memberTypeText = nil;
                switch (result) {
                    case TuyaResidenceAccessMemberTypeUnregistered:
                    {
                        memberTypeText = @"Unregistered User";
                    }
                        break;
                    case TuyaResidenceAccessMemberTypeSiteMember:
                    {
                        memberTypeText = @"Site Member";
                    }
                        break;
                    case TuyaResidenceAccessMemberTypeAccessMember:
                    {
                        memberTypeText = @"Access Member";
                    }
                        break;
                        
                    default:
                        break;
                }
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = [NSString stringWithFormat:@"%@: %@", username, memberTypeText];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
        case APICodeCheckAccessAccount:
        {
            NSString *username = @"xxx@mail.com"; // account
            [self.access checkAccessAccountWithUserName:username success:^(BOOL result) {
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = [NSString stringWithFormat:@"%@: %@", username, result ? @"Already Registered" : @"Unregistered"];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
        
        case APICodeQueryAppAccessUserDetail:
        {
            
            NSString *accessUserId = @""; //accessUserId from API: fetchAppAccessListWithSiteId
            
            [self.access fetchAppAccessUserDetailWithSiteId:siteId accessUserId:accessUserId success:^(TuyaResidenceAppAccessDetailModel * _Nonnull userDetail) {
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = [NSString stringWithFormat:@"%@", [userDetail yy_modelToJSONObject]];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
            
        case APICodeQueryAppAccessPassRecord:
        {
            
            NSString *accessUserId = @""; //accessUserId from API: fetchAppAccessListWithSiteId
            
            [self.access fetchAppAccessPassRecordWithSiteId:siteId accessUserId:accessUserId pageNo:1 pageSize:20 success:^(NSArray<TuyaResidenceAccessRecordModel *> * _Nonnull accessUserRecordList) {
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = [NSString stringWithFormat:@"%@", [accessUserRecordList yy_modelToJSONObject]];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
            
        case APICodeQueryAppAccessTotal:
        {
            
            BOOL effective = YES; //NO;
            
            [self.access fetchAppAccessTotalWithSiteId:siteId effective:effective success:^(NSInteger total) {
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = [NSString stringWithFormat:@"Total: %ld", total];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
            
        case APICodeUpdateAppAccess:
        {
            
            NSString *accessUserId = @""; //accessUserId from API: fetchAppAccessListWithSiteId
            NSString *nickname = @"xxx";
            TuyaResidenceAccessUserType userType = TuyaResidenceAccessUserTypeAdmin; //TuyaResidenceAccessUserTypeMember;
            long startTime = -1; //[[NSDate date] timeIntervalSince1970] * 1000;
            long endTime =  -1; //([[NSDate date] timeIntervalSince1970] + 864000) * 1000;
            
            [self.access updateAppAccessWithSiteId:siteId accessUserId:accessUserId nickName:nickname userType:userType startTime:startTime endTime:endTime success:^{
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = @"Update Successfully";
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
            
        case APICodeAddAppAccessDevice:
        {
            
            NSString *accessUserId = @""; //accessUserId from API: fetchAppAccessListWithSiteId
            NSArray<NSString *> *deviceIdList = @[@""]; //deviceId from API: fetchDeviceListWithSiteId
            
            [self.access addAppAccessDeviceWithSiteId:siteId accessUserId:accessUserId deviceIdList:deviceIdList success:^{
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = @"Add App Access Device Successfully";
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
            
        case APICodeRemoveAppAccessDevice:
        {
            
            NSString *accessUserId = @""; //accessUserId from API: fetchAppAccessListWithSiteId
            NSString *deviceId = @""; //deviceId from API: fetchDeviceListWithSiteId
            
            [self.access removeAppAccessDeviceWithSiteId:siteId accessUserId:accessUserId deviceId:deviceId success:^{
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = @"Remove App Access Device Successfully";
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
            
        case APICodeRemoveAppAccess:
        {
            
            NSString *accessUserId = @""; //accessUserId from API: fetchAppAccessListWithSiteId
            
            [self.access removeAppAccessWithSiteId:siteId accessUserId:accessUserId success:^{
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = @"Remove App Access Successfully";
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
            
        case APICodeQueryPasswordAccessUserDetail:
        {
            
            NSString *authGroupId = @""; // authGroupId from API: fetchPasswordAccessListWithSiteId
            
            [self.access fetchPasswordAccessUserDetailWithSiteId:siteId authGroupId:authGroupId success:^(TuyaResidencePasswordAccessModel * _Nonnull accessPasswordModel) {
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = [NSString stringWithFormat:@"%@", [accessPasswordModel yy_modelToJSONObject]];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
         
        case APICodeQueryPasswordAccessPassRecord:
        {
            
            NSString *authGroupId = @""; // authGroupId from API: fetchPasswordAccessListWithSiteId
            
            [self.access fetchPasswordAccessPassRecordWithSiteId:siteId authGroupId:authGroupId pageNo:1 pageSize:20 success:^(NSArray<TuyaResidenceAccessRecordModel *> * _Nonnull accessUserRecordList) {
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = [NSString stringWithFormat:@"%@", [accessUserRecordList yy_modelToJSONObject]];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
            
        case APICodeQueryPasswordAccessTotal:
        {
            
            BOOL effective = YES; //NO;
            
            [self.access fetchPasswordAccessTotalWithSiteId:siteId effective:effective success:^(NSInteger total) {
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = [NSString stringWithFormat:@"Total: %ld", total];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
            
        case APICodeAddPasswordAccessDevice:
        {
            
            NSString *authGroupId = @""; // authGroupId from API: fetchPasswordAccessListWithSiteId
            NSArray<NSString *> *deviceIdList = @[@""]; //deviceId from API: fetchDeviceListWithSiteId
            
            [self.access addPasswordAccessDeviceWithSiteId:siteId authGroupId:authGroupId deviceIdList:deviceIdList success:^{
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = @"Add Password Access Device Successfully";
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
            
        case APICodeRemovePasswordAccessDevice:
        {
            
            NSString *authGroupId = @""; // authGroupId from API: fetchPasswordAccessListWithSiteId
            NSString *deviceId = @""; //deviceId from API: fetchDeviceListWithSiteId
            
            // fetch the device information
            TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:deviceId];
            BOOL isDeviceOnline = device.deviceModel.isOnline;
            NSLog(@"isDeviceOnline:%@ %d", device.deviceModel, isDeviceOnline);
            
            [self.access removePasswordAccessDeviceWithSiteId:siteId authGroupId:authGroupId deviceId:deviceId success:^{
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = @"Remove Password Access Device Successfully";
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
            
        case APICodeRemovePasswordAccess:
        {
             
            NSString *authGroupId = @""; // authGroupId from API: fetchPasswordAccessListWithSiteId
            
            [self.access removePasswordAccessWithSiteId:siteId authGroupId:authGroupId success:^{
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = @"Remove Password Access Successfully";
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
            
        case APICodeUpdatePasswordAccessValidity:
        {
             
            NSString *authGroupId = @""; // authGroupId from API: fetchPasswordAccessListWithSiteId
            TuyaResidenceBasePasswordInfoModel *doorModel = [[TuyaResidenceBasePasswordInfoModel alloc] init];
            doorModel.authType = TuyaResidencePasswordAuthTypeTemporary;
            doorModel.authName = @"xxx";
            doorModel.effectiveTime = (long)([[NSDate date] timeIntervalSince1970] * 1000);
            doorModel.invalidTime = (long)(([[NSDate date] timeIntervalSince1970] + 864000) * 1000); // Within 10 days
            doorModel.scheduleRepeat = 0;
            
            NSArray<NSString *> *deviceIdList = @[@""]; //deviceId from API: fetchDeviceListWithSiteId
            
            for(NSString *deviceId in deviceIdList) {
                // fetch the device information
                TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:deviceId];
                BOOL isDeviceOnline = device.deviceModel.isOnline;
                NSLog(@"isDeviceOnline:%@ %d", device.deviceModel, isDeviceOnline);
            }
            
            [self.access updatePasswordAccessValidityWithSiteId:siteId authGroupId:authGroupId doorPassword:doorModel deviceIdList:deviceIdList success:^{
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = @"Update Successfully";
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
            
        case APICodeUpdatePasswordAccessNickname:
        {
             
            NSString *authGroupId = @""; // authGroupId from API: fetchPasswordAccessListWithSiteId
            NSString *nickname = @"xxx";
            
            [self.access updatePasswordAccessNicknameWithSiteId:siteId authGroupId:authGroupId nickName:nickname success:^{
                ty_strongify(self)
                
                [SVProgressHUD dismiss];
                self.jsonTextView.text = @"Update Successfully";
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
            
            break;
        }
            
        default:
            break;
    }
}

- (TuyaResidenceAccess *)access {
    if (!_access) {
        _access = [[TuyaResidenceAccess alloc] init];
    }
    return _access;
}

@end
