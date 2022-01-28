//
//  ResetViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "ResetViewController.h"

@interface ResetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *countryCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@end

@implementation ResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)codeClick:(UIButton *)sender {
    [[TuyaSmartUser sharedInstance] sendVerifyCodeWithUserName:self.accountTF.text region:[[TuyaSmartUser sharedInstance] getDefaultRegionWithCountryCode:self.countryCodeTF.text] countryCode:self.countryCodeTF.text type:3 success:^{
        [SVProgressHUD showSuccessWithStatus:@"Verification Code Sent Successfully"];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)resetClick:(UIButton *)sender {
    [[TuyaSmartUser sharedInstance] resetPasswordByEmail:self.countryCodeTF.text email:self.accountTF.text newPassword:self.passwordTF.text code:self.codeTF.text success:^{
        [SVProgressHUD showSuccessWithStatus:@"Password Reset Successfully"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
