//
//  LoginViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "LoginViewController.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *countryCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)loginClick:(UIButton *)sender {
    
    [self login];
}

- (void)login {
    
    NSString *countryCode = self.countryCodeTF.text;
    NSString *account = self.accountTF.text;
    NSString *password = self.passwordTF.text;
    
    [SVProgressHUD showWithStatus:@"Login..."];
    
    [[TuyaSmartUser sharedInstance] loginByEmail:countryCode email:account password:password success:^{
        
        [SVProgressHUD dismiss];
        [self loginSuccess];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)loginSuccess {
    UIStoryboard *homeSB = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UINavigationController *nav = [homeSB instantiateInitialViewController];
    [[UIApplication sharedApplication] delegate].window.rootViewController = nav;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
