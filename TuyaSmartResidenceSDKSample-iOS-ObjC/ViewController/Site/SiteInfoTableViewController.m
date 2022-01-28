//
//  SiteInfoTableViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "SiteInfoTableViewController.h"
#import <TuyaSmartResidenceKit/TuyaResidenceSiteMemberModel.h>

@interface SiteInfoTableViewController ()

@property (nonatomic, strong) TuyaResidenceSite *site;

@property (nonatomic, strong) NSMutableArray *roomArray;
@property (nonatomic, strong) NSMutableArray *residenceArray;
@property (nonatomic, strong) TuyaResidenceSiteMemberModel *currentMember;

@end

@implementation SiteInfoTableViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.roomArray = [NSMutableArray array];
    self.residenceArray = [NSMutableArray array];

    [self fetchData];
}

- (void)fetchData {
    ty_weakify(self);
    [self.site fetchSiteRoomCountWithSuccess:^(id result) {
        ty_strongify(self);
        if (result) {
            self.roomArray = result[@"rooms"];
            
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    [self.site fetchSiteResidentListWithSuccess:^(NSArray<TuyaResidenceSiteMemberModel *> * _Nonnull list) {
        ty_strongify(self);
        self.residenceArray = list.mutableCopy;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    [self.site fetchSiteDetailWithSuccess:^(TuyaResidenceSiteModel * _Nonnull siteModel) {
        NSAssert(siteModel, @"failure");
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    [self.site fetchLoginedSiteMemberInfoWithSuccess:^(TuyaResidenceSiteMemberModel * _Nonnull model) {
        ty_strongify(self);
        self.currentMember = model;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _roomArray.count;
    } else if (section == 1) {
        return _residenceArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SiteInfoCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSString *text;
    if (indexPath.section == 0) {
        NSString *name = _roomArray[indexPath.row][@"name"];
        text = name;
    } else if (indexPath.section == 1) {
        TuyaResidenceSiteMemberModel *model = _residenceArray[indexPath.row];
        text = model.name;
    } else {
        text = [NSString stringWithFormat:@"Name: %@,  Is Admin: %@", _currentMember.name, _currentMember.role == TYSiteRoleType_Member ? @"YES" : @"NO"];
    }
    
    cell.textLabel.text = text;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Room";
    } else if (section == 1) {
        return @"Residence";
    } else {
        return @"Current Member";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"remove memeber" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            TuyaResidenceSiteMemberModel *model = self.residenceArray[indexPath.row];
            ty_weakify(self)
            [self.site removeMemberWithMemberId:model.memberId success:^{
                ty_strongify(self)
                [self.residenceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TuyaResidenceSiteMemberModel *temp = obj;
                    if (temp.memberId == model.memberId) {
                        [self.residenceArray removeObjectAtIndex:idx];
                    }
                }];
                [self.tableView reloadData];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertViewController addAction:confirm];
        [alertViewController addAction:cancel];
        [self presentViewController:alertViewController animated:YES completion:nil];
    }
}

- (TuyaResidenceSite *)site {
    if (!_site) {
        long long siteId = [Helper getCurrentSiteModel].siteId;
        _site = [TuyaResidenceSite siteWithSiteId:siteId];
    }
    
    return _site;
}

@end
