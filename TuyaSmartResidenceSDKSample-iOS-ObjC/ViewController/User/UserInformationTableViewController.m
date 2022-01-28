//
//  UserInformationTableViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "UserInformationTableViewController.h"

@interface UserInformationTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nickameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeZonelLabel;

@property (nonatomic, strong) UITextField *nameTextField;

@end

@implementation UserInformationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetData];
}

- (void)resetData {
    self.nickameLabel.text = [[TuyaSmartUser sharedInstance] nickname];
    self.emailLabel.text = [[TuyaSmartUser sharedInstance] email];
    self.countryCodeLabel.text = [[TuyaSmartUser sharedInstance] countryCode];
    self.timeZonelLabel.text = [[TuyaSmartUser sharedInstance] timezoneId];

}

#pragma mark - Table view data delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Change Nickname" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"New Nickname";
            
            self.nameTextField = textField;
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.nameTextField = nil;
        }];
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            ty_weakify(self);
            [[TuyaSmartUser sharedInstance] updateNickname:self.nameTextField.text success:^{
                ty_strongify(self);
                
                self.nickameLabel.text = self.nameTextField.text;
                self.nameTextField = nil;
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];

            
        }];
        
        [alertController addAction:saveAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
