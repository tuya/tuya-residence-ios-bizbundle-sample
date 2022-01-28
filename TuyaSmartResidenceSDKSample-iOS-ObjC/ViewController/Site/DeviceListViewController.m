//
//  DeviceListViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "DeviceListViewController.h"

@interface DeviceListViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentSiteLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TuyaResidenceAccess *access;
@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentSiteLabel.text = [NSString stringWithFormat:@"Current Site: %@", [Helper getCurrentSiteModel].name];
    
    [self fetchData];
}

- (void)fetchData {
    TuyaResidenceSiteModel *model = [Helper getCurrentSiteModel];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    [self.access fetchDeviceListWithSiteId:model.siteId success:^(NSArray<TuyaSmartDeviceModel *> * _Nonnull devices) {

        if (devices) {
            self.dataArray = [NSMutableArray arrayWithArray:devices];
            [self.tableView reloadData];
        }
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceListCell" forIndexPath:indexPath];
    
    TuyaSmartDeviceModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", model.name];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (TuyaResidenceAccess *)access {
    if (!_access) {
        _access = [[TuyaResidenceAccess alloc] init];
    }
    return _access;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
