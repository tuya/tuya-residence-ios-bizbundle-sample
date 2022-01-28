//
//  BizBundleTableViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "BizBundleTableViewController.h"
#import <TuyaSmartBizCore/TuyaSmartBizCore.h>
#import <TYModuleServices/TYModuleServices.h>
#import <TYNavigationController/TYNavigationTopBarProtocol.h>

#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, BizBundleType) {
    PanelBizBundle,
    DeviceDetailBizBundle,
    GroupHandleBizBundle,
};

@interface BizBundleTableViewController () <CBCentralManagerDelegate, TYFamilyProtocol>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) TuyaResidenceAccess *access;
@property (nonatomic, strong) TuyaResidenceSite *site;

@property (nonatomic, strong) CBCentralManager *bleManager;

@end

@implementation BizBundleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *options = @{CBCentralManagerOptionShowPowerAlertKey:@YES};//不弹窗（配置）

    self.bleManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
    [[[CLLocationManager alloc] init] requestWhenInUseAuthorization];
    
    self.cellArray = @[
        @"Activator Biz Bundle",
        @"Panel Biz Bundle",
        @"Device Detail Biz Bundle",
        @"Group Handle Biz Bundle"
    ].copy;
    
    if (@available(iOS 15.0, *)) {
          UINavigationBarAppearance *bar = [UINavigationBarAppearance new];
          bar.backgroundColor = [UIColor whiteColor];
          bar.backgroundEffect = nil;
          self.navigationController.navigationBar.scrollEdgeAppearance = bar;
          self.navigationController.navigationBar.standardAppearance = bar;
    }
    
    [[TuyaSmartBizCore sharedInstance] registerService:@protocol(TYFamilyProtocol) withInstance:self];

}

- (long long)currentFamilyId {
    return self.site.siteId;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.ty_topBarHidden = NO;
    self.ty_topBarAlpha = 1.0;
    self.ty_topBarBackgroundColor = [UIColor whiteColor];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BizBundleCell" forIndexPath:indexPath];
    cell.textLabel.text = _cellArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.site = [TuyaResidenceSite siteWithSiteId:[Helper getCurrentSiteModel].siteId];
    
    __weak __typeof(self)weakSelf = self;
    [_site fetchSiteDetailWithSuccess:^(TuyaResidenceSiteModel * _Nonnull siteModel) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        switch (indexPath.row) {
            case 0: {
                // @"Activator Biz Bundle"
                id<TuyaSmartResidenceActivatorProtocol> impl = [[TuyaSmartBizCore sharedInstance] serviceOfProtocol:@protocol(TuyaSmartResidenceActivatorProtocol)];
                if (impl && [impl respondsToSelector:@selector(gotoActivatorVC)]) {
                    [impl gotoActivatorVC];
                }
            }
                break;
            case 1: {
                // @"Panel Biz Bundle"
                [strongSelf pushToBizBundleWithType:PanelBizBundle];
            }
                break;
                
            case 2: {
                // @"Device Detail Biz Bundle"
                [strongSelf pushToBizBundleWithType:DeviceDetailBizBundle];
            }
                break;
            case 3: {
                // @"Group Handle Biz Bundle"
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"Select Create or Edit" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *createAction = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [strongSelf pushToGroupHandleViewControllerIsCreate:YES];
                }];
                UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [strongSelf pushToGroupHandleViewControllerIsCreate:NO];
                }];
                
                [alertVc addAction:createAction];
                [alertVc addAction:editAction];
                [strongSelf presentViewController:alertVc animated:YES completion:nil];
            }
                break;
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)pushToBizBundleWithType:(BizBundleType)type {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"Select a device or group of devices" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:cancelAction];
    for (TuyaSmartDeviceModel *model in self.site.deviceList) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:model.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            switch (type) {
                case PanelBizBundle:
                    [self pushToPanelViewControllerWithModel:model];
                    break;
                case DeviceDetailBizBundle:
                    [self pushToDeviceDetailViewControllerWithModel:model];
                    break;
                default:
                    break;
            }
        }];
        [alertVc addAction:action];
    }
    for (TuyaSmartGroupModel *model in self.site.groupList) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:model.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            switch (type) {
                case PanelBizBundle:
                    [self pushToGroupPanelViewControllerWithModel:model];
                    break;
                case DeviceDetailBizBundle:
                    [self pushToGroupDeviceDetailViewControllerWithModel:model];
                    break;
                default:
                    break;
            }
        }];
        [alertVc addAction:action];
    }
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)pushToPanelViewControllerWithModel:(TuyaSmartDeviceModel *)model {
    id<TuyaSmartResidencePanelProtocol> impl = [[TuyaSmartBizCore sharedInstance] serviceOfProtocol:@protocol(TuyaSmartResidencePanelProtocol)];
    [impl getPanelViewControllerWithDeviceModel:model initialProps:nil contextProps:nil completionHandler:^(__kindof UIViewController * _Nullable panelViewController, NSError * _Nullable error) {
        [self.navigationController pushViewController:panelViewController animated:YES];
    }];
}

- (void)pushToGroupPanelViewControllerWithModel:(TuyaSmartGroupModel *)model {
    id<TuyaSmartResidencePanelProtocol> impl = [[TuyaSmartBizCore sharedInstance] serviceOfProtocol:@protocol(TuyaSmartResidencePanelProtocol)];
    [impl getPanelViewControllerWithGroupModel:model initialProps:nil contextProps:nil completionHandler:^(__kindof UIViewController * _Nullable panelViewController, NSError * _Nullable error) {
        [self.navigationController pushViewController:panelViewController animated:YES];
    }];
}

- (void)pushToDeviceDetailViewControllerWithModel:(TuyaSmartDeviceModel *)model {
    id<TuyaSmartResidenceDeviceDetailProtocol> impl = [[TuyaSmartBizCore sharedInstance] serviceOfProtocol:@protocol(TuyaSmartResidenceDeviceDetailProtocol)];
    if (impl && [impl respondsToSelector:@selector(gotoDetailViewControllerWithDevice:group:)]) {
        [impl gotoDetailViewControllerWithDevice:model group:nil];
    }
}

- (void)pushToGroupDeviceDetailViewControllerWithModel:(TuyaSmartGroupModel *)model {
    id<TuyaSmartResidenceDeviceDetailProtocol> impl = [[TuyaSmartBizCore sharedInstance] serviceOfProtocol:@protocol(TuyaSmartResidenceDeviceDetailProtocol)];
    if (impl && [impl respondsToSelector:@selector(gotoDetailViewControllerWithDevice:group:)]) {
        [impl gotoDetailViewControllerWithDevice:nil group:model];
    }
}

- (void)pushToGroupHandleViewControllerIsCreate:(BOOL)isCreate {
    id<TuyaSmartResidenceGroupHandleProtocol> impl = [[TuyaSmartBizCore sharedInstance] serviceOfProtocol:@protocol(TuyaSmartResidenceGroupHandleProtocol)];
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"Select a device or group of devices" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:cancelAction];
    
    if (isCreate) {
        for (TuyaSmartDeviceModel *model in self.site.deviceList) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:model.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [impl createGroupWithDeviceId:model.devId completion:^(TYGroupHandleType type) {
                    
                }];
            }];
            [alertVc addAction:action];
        }
    } else {
        for (TuyaSmartGroupModel *model in self.site.groupList) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:model.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [impl editGroupWithGroupId:model.groupId completion:^(TYGroupHandleType type) {
                    
                }];
                
                
            }];
            [alertVc addAction:action];
        }
    }
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
}

@end
