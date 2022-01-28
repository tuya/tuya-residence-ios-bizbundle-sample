//
//  ModifySiteInformationViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "ModifySiteInformationViewController.h"

@interface ModifySiteInformationViewController ()
@property (nonatomic, weak) IBOutlet UILabel *currentSiteNameLabel;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *geonameLabel;
@property (nonatomic, weak) IBOutlet UITextField *memberIDTextField;
@property (nonatomic, weak) IBOutlet UITextField *memberNameTextField;

//@property (nonatomic, strong) UITextField *areaTextField;
@property (nonatomic, strong) NSMutableArray *areaArray;
@property (nonatomic, strong) TuyaResidenceSite *site;

@property (nonatomic, weak) IBOutlet UITextField *addRoomTextField;

@end

@implementation ModifySiteInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentSiteNameLabel.text = [NSString stringWithFormat:@"Current Site Name: %@", [Helper getCurrentSiteModel].name];
}


- (IBAction)updateClick:(UIButton *)sender {
    NSString *siteName = self.nameTextField.text;
    NSString *geoname = self.geonameLabel.text;
    double latitude = 22.32;
    double longitude = 114.7;
    
    if (siteName.length < 1) {
        [SVProgressHUD showInfoWithStatus:@"Site name is empty"];
        return;
    }
    if (geoname.length < 1) {
        [SVProgressHUD showInfoWithStatus:@"Geoname is empty"];
        return;
    }
    
    [self.view endEditing:YES];
    
    ty_weakify(self)
    [self.site updateSiteInfoWitSiteName:siteName geoName:geoname latitude:latitude longitude:longitude success:^{
        ty_strongify(self)
        
        [SVProgressHUD showSuccessWithStatus:@"Update Site Info Successfully"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)addRoomeClick:(id)sender {
    if (!_addRoomTextField.text.length) return;
    
    [self.site addSiteRoomWithRoomName:_addRoomTextField.text success:^{
        [SVProgressHUD showSuccessWithStatus:@"Success"];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)transferSite:(id)sender {
    if (!_memberIDTextField.text.length) return;
    
    long long memberId = _memberIDTextField.text.longLongValue;
    [self.site updateSiteMemberInfoWithMemberId:memberId headPicImage:nil memberName:_memberNameTextField.text role:TYSiteRoleType_Owner success:^{
        [SVProgressHUD showSuccessWithStatus:@"Success"];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)deleteClick:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"Delete Site:\"%@\"?", [Helper getCurrentSiteModel].name] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        long long groupUserId = self.site.siteModel.siteId;
        
        [SVProgressHUD showWithStatus:@""];
        ty_weakify(self)
        [self.site removeSiteWithOwnerId:groupUserId success:^{
            ty_strongify(self)
            
            [SVProgressHUD showSuccessWithStatus:@"Delete Site Successfully"];
            [Helper setCurrentSiteModelWithSiteId:@""];
            
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }];
    
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (NSMutableArray *)areaArray {
    if (!_areaArray) {
        _areaArray = [NSMutableArray array];
    }
    return _areaArray;
}

- (TuyaResidenceSite *)site {
    if (!_site) {
        _site = [TuyaResidenceSite siteWithSiteId:[Helper getCurrentSiteModel].siteId];
    }
    
    return _site;
}

@end
