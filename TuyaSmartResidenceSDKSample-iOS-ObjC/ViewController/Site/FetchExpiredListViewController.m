//
//  FetchExpiredListViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "FetchExpiredListViewController.h"

@interface FetchExpiredListViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentSiteNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TuyaResidenceSite *site;

@end

@implementation FetchExpiredListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentSiteNameLabel.text = [NSString stringWithFormat:@"Current Site Name: %@", [Helper getCurrentSiteModel].name];
    
    [self fetchData];
}

- (void)fetchData {
    
    ty_weakify(self)
    [SVProgressHUD showWithStatus:@"Loading..."];
    [self.site fetchExpiredListWithPageSize:20 pageNo:1 success:^(NSArray<TuyaResidenceExpiredAuthorModel *> *list) {
        ty_strongify(self)
        [SVProgressHUD dismiss];
        
        if (list) {
            self.dataArray = [NSMutableArray arrayWithArray:list];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FetchExpiredListCell" forIndexPath:indexPath];
    
    TuyaResidenceExpiredAuthorModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@", model.projectName, model.spaceFullName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (TuyaResidenceSite *)site {
    if (!_site) {
        long long siteId = [Helper getCurrentSiteModel].siteId;
        _site = [TuyaResidenceSite siteWithSiteId:siteId];
    }
    
    return _site;
}
@end
