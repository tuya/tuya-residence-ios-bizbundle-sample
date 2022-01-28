//
//  CurrentSiteTableViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "CurrentSiteTableViewController.h"

@interface CurrentSiteTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CurrentSiteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchData];
}

- (void)fetchData {
    [SVProgressHUD showWithStatus:@"Loading..."];

    [TuyaResidenceSite fetchSiteListWithSuccess:^(NSArray<TuyaResidenceSiteModel *> * _Nonnull homes) {
        [SVProgressHUD dismiss];
        
        if (homes) {
            self.dataArray = [NSMutableArray arrayWithArray:homes];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrentSiteCell" forIndexPath:indexPath];

    TuyaResidenceSiteModel *siteModel = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Site Name: %@", siteModel.name];
    
    if ([Helper getCurrentSiteModel].siteId == siteModel.siteId) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TuyaResidenceSiteModel *model = self.dataArray[indexPath.row];
    if ([Helper getCurrentSiteModel].siteId == model.siteId) {
        return;
    }

    [Helper setCurrentSiteModelWithSiteId:[NSString stringWithFormat:@"%lld", model.siteId]];
    
    [self.tableView reloadData];
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
