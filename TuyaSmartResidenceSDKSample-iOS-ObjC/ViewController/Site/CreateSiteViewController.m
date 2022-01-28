//
//  CreateSiteViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "CreateSiteViewController.h"

@interface CreateSiteViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation CreateSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)saveClick:(UIButton *)sender {
    
    if (self.nameTextField.text.length < 1) {
        self.nameTextField.text = @"NewSite";
    }
    
    
    NSString *siteName = self.nameTextField.text;
    NSString *geoName = @"Shenzhen";
    NSArray *areas = @[];
    double latitude = 22.32;
    double longitude = 114.7;
    
    ty_weakify(self);
    [TuyaResidenceSite createSiteWithName:siteName geoName:geoName rooms:areas latitude:latitude longitude:longitude success:^(long long result) {
        ty_strongify(self);
        
        NSLog(@"siteId:%lld", result);
        [SVProgressHUD showSuccessWithStatus:@"Creat Site Successfully"];
        
        if (![Helper getCurrentSiteModel]) {
            [Helper setCurrentSiteModelWithSiteId:[NSString stringWithFormat:@"%lld", result]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
