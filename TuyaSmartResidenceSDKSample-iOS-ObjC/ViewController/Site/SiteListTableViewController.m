//
//  SiteListTableViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "SiteListTableViewController.h"

@interface SiteListTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SiteListTableViewController

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SiteListCell" forIndexPath:indexPath];
    
    TuyaResidenceSiteModel *siteModel = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Site Name: %@", siteModel.name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    TuyaResidenceSiteModel *siteModel = self.dataArray[indexPath.row];
    TuyaResidenceSite *site = [TuyaResidenceSite siteWithSiteId:siteModel.siteId];
    
    [self showDetailWithSite:site]; 
}

- (void)showDetailWithSite:(TuyaResidenceSite *)site {
    NSMutableString *info = [NSMutableString string];
    [info appendString:@"site ID: "];
    [info appendFormat:@"%lld\n", site.siteModel.siteId];
    [info appendString:@"site name: "];
    [info appendFormat:@"%@\n", site.siteModel.name];
    [info appendString:@"city name: "];
    [info appendFormat:@"%@\n", site.siteModel.geoName];
    
    for (TuyaResidenceRoomModel *areaModel in site.roomList) {
        [info appendString:@"area name: "];
        [info appendFormat:@"%@\n", areaModel.name];
    }

    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Site Information" message:info preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", @"") style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:closeAction];

    [self presentViewController:alertViewController animated:YES completion:nil];
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
