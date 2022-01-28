//
//  UIDLoginOrRegistViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "UIDLoginOrRegistViewController.h"

@interface UIDLoginOrRegistViewController ()

@property (weak, nonatomic) IBOutlet UITextField *countryCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *uidTF;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation UIDLoginOrRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginOrRegistAction:(id)sender {
    [[TuyaSmartUser sharedInstance] loginOrRegisterWithCountryCode:_countryCodeTF.text uid:_uidTF.text authCode:_authCodeTF.text createSite:NO success:^(id result) {
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

@end
