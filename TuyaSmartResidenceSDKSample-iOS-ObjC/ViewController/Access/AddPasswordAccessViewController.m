//
//  AddPasswordAccessViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "AddPasswordAccessViewController.h"

@interface AddPasswordAccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentSiteLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *passwordTypeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TuyaResidenceAccess *access;
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedDeviceIdArray;
@end

@implementation AddPasswordAccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentSiteLabel.text = [NSString stringWithFormat:@"Current Site: %@", [Helper getCurrentSiteModel].name];
    
    [self setupView];
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

- (void)setupView {
    [self.passwordTypeButton setTitle:@"Temporary Password" forState:UIControlStateNormal];
    [self.passwordTypeButton setTitle:@"Periodicity Password" forState:UIControlStateSelected];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddPasswordAccessCell" forIndexPath:indexPath];
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)passwordTypeClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)addPasswordAccessClick:(UIButton *)sender {
    
    NSString *password = self.passwordTextField.text;
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
    if (password.length != 6) {
        [SVProgressHUD showInfoWithStatus:@"Please enter the 6-digit password"];
        return;
    }
    
    BOOL isPeriodicitypassword = self.passwordTypeButton.selected;
    
    TuyaResidencePasswordInfoModel *passwordInfo = [[TuyaResidencePasswordInfoModel alloc] init];
    passwordInfo.authType = isPeriodicitypassword ? TuyaResidencePasswordAuthTypePeriodic : TuyaResidencePasswordAuthTypeTemporary;
    passwordInfo.authName = [NSString stringWithFormat:@"%@-password", nickname];
    passwordInfo.passwordValue = self.passwordTextField.text;
    passwordInfo.effectiveTime = (long)([[NSDate date] timeIntervalSince1970] * 1000);
    passwordInfo.invalidTime = (long)(([[NSDate date] timeIntervalSince1970] + 432000) * 1000); // Within 5 days
    passwordInfo.scheduleRepeat = 0;
    
    // Activation Plan
    BOOL activationPlan = YES; //NO;
    if (isPeriodicitypassword && activationPlan) {
        
        passwordInfo.scheduleRepeat = 1;
        TuyaResidencePasswordScheduleModel *schedule = [[TuyaResidencePasswordScheduleModel alloc] init];
        // "09:10" -> 550
        schedule.startClock = 9 * 60 + 10;
        // "21:00" -> 1260
        schedule.endClock = 21 * 60;
        // all week -> "1111111"
        schedule.weekDay = [Helper decimalByBinaryStr:@"1111111"];
        passwordInfo.schedule = schedule;
    }

    
    TuyaResidencePasswordUserModel *userModel = [[TuyaResidencePasswordUserModel alloc] init];
    userModel.username = userName;
    userModel.nickname = nickname;
    NSArray *userList = @[userModel];
    
    TuyaResidenceAddPasswordAccessModel *reqModel = [[TuyaResidenceAddPasswordAccessModel alloc] init];
    reqModel.siteId = [Helper getCurrentSiteModel].siteId;
    reqModel.deviceIdList = deviceIdList;
    reqModel.passwordInfo = passwordInfo;
    reqModel.userList = userList;
    
    ty_weakify(self);
    [self.access addPasswordAccessWithModel:reqModel success:^{
        ty_strongify(self);
        
        [SVProgressHUD showSuccessWithStatus:@"Add Password Access Successfully"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
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
