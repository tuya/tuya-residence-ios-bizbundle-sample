//
//  AddAppAccessViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "AddAppAccessViewController.h"

@interface AddAppAccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentSiteLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TuyaResidenceAccess *access;
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedDeviceIdArray;

@end

@implementation AddAppAccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentSiteLabel.text = [NSString stringWithFormat:@"Current Site: %@", [Helper getCurrentSiteModel].name];
    
    [self fetchDeviceData];
}

- (void)fetchDeviceData {
    TuyaResidenceSiteModel *model = [Helper getCurrentSiteModel];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    ty_weakify(self)
    [self.access fetchDeviceListWithSiteId:model.siteId success:^(NSArray<TuyaSmartDeviceModel *> * _Nonnull devices) {
        ty_strongify(self)
        [SVProgressHUD dismiss];
        
        if (devices) {
            self.dataArray = [NSMutableArray arrayWithArray:devices];
            [self.tableView reloadData];
        }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddAppAccessCell" forIndexPath:indexPath];
    
    TuyaSmartDeviceModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", model.name];
    
    cell.accessoryType = [self.selectedDeviceIdArray containsObject:model.devId] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    TuyaSmartDeviceModel *model = self.dataArray[indexPath.row];
    NSString *deviceId = model.devId;
    if ([self.selectedDeviceIdArray containsObject:deviceId]) {
        [self.selectedDeviceIdArray removeObject:deviceId];
    } else {
        [self.selectedDeviceIdArray addObject:deviceId];
    }
    
    [self.tableView reloadData];
}


- (IBAction)addAppAccessClick:(UIButton *)sender {
    NSString *userName = self.accountTextField.text;
    NSString *nickname = self.nicknameTextField.text;
    NSArray *deviceIdList = self.selectedDeviceIdArray;
    
    if (userName.length < 1) {
        [SVProgressHUD showInfoWithStatus:@"Email Address is empty"];
        return;
    }
    if (nickname.length < 1) {
        [SVProgressHUD showInfoWithStatus:@"Nickname is empty"];
        return;
    }
    if (deviceIdList.count < 1) {
        [SVProgressHUD showInfoWithStatus:@"Device list is empty"];
        return;
    }
    
    
    TuyaResidenceAddAppAccessModel *reqModel = [[TuyaResidenceAddAppAccessModel alloc] init];
    reqModel.siteId = [Helper getCurrentSiteModel].siteId;
    reqModel.username = userName;
    reqModel.nickname = nickname;
    reqModel.deviceIdList = deviceIdList;
    reqModel.startTime = -1;
    reqModel.endTime = -1;
    reqModel.userType = TuyaResidenceAccessUserTypeMember;
    
    ty_weakify(self);
    [self.access addAppAccessWithModel:reqModel success:^(BOOL result) {
        ty_strongify(self);
        
        [SVProgressHUD showSuccessWithStatus:@"Add App Access Successfully"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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

- (NSMutableArray<NSString *> *)selectedDeviceIdArray {
    if (!_selectedDeviceIdArray) {
        _selectedDeviceIdArray = [NSMutableArray array];
    }
    return _selectedDeviceIdArray;
}
@end
