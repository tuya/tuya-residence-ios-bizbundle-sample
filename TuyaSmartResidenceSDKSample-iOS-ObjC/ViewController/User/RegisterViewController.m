//
//  RegisterViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "RegisterViewController.h"


@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *countryCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)codeClick:(UIButton *)sender {
    
    [[TuyaSmartUser sharedInstance] sendVerifyCodeWithUserName:self.accountTF.text region:[[TuyaSmartUser sharedInstance] getDefaultRegionWithCountryCode:self.countryCodeTF.text] countryCode:self.countryCodeTF.text type:1 success:^{
        [SVProgressHUD showSuccessWithStatus:@"Verification Code Sent Successfully"];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}

- (IBAction)registerClick:(UIButton *)sender {
    
    [SVProgressHUD showWithStatus:@"Register..."];
    
    [[TuyaSmartUser sharedInstance] registerByEmail:self.countryCodeTF.text email:self.accountTF.text password:self.passwordTF.text code:self.codeTF.text success:^{
        [SVProgressHUD showSuccessWithStatus:@"Register Successfully"];

        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
