//
//  AddMemberViewController.m
//  TuyaSmartResidenceSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "AddMemberViewController.h"

@interface AddMemberViewController ()

@property (nonatomic, strong) TuyaResidenceSiteInvitation *request;
@property (nonatomic, strong) TuyaResidenceInvitationResultModel *invitationResultModel;

@property (nonatomic, weak) IBOutlet UITextField *countryCodeTextField;
@property (nonatomic, weak) IBOutlet UITextField *nicknameTextField;
@property (nonatomic, weak) IBOutlet UITextField *accountTextField;
@property (nonatomic, weak) IBOutlet UILabel *invitationCodeLabel;

@end

@implementation AddMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)saveClick:(UIButton *)sender {
    if (!_nicknameTextField.text) return;
    if (!_accountTextField.text) return;;
    
    [self.request addMemberWithSiteId:[Helper getCurrentSiteModel].siteId nickName:_nicknameTextField.text userName:_accountTextField.text isAdmin:NO isAutoAccept:YES success:^{
        [SVProgressHUD showSuccessWithStatus:@"Add Member Successfully"];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)createCodeClick:(id)sender {
    ty_weakify(self)
    TuyaResidenceInvitationCreateRequestModel *model = [[TuyaResidenceInvitationCreateRequestModel alloc] init];
    model.siteId = [Helper getCurrentSiteModel].siteId;
    model.needMsgContent = NO;
    [self.request invitationMemberWithCreateRequestModel:model success:^(TuyaResidenceInvitationResultModel * _Nonnull invitationResultModel) {
        ty_strongify(self)
        self.invitationResultModel = invitationResultModel;
        self.invitationCodeLabel.text = invitationResultModel.invitationCode;
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)reInvitationClick:(id)sender {
    TuyaResidenceInvitationCreateRequestModel *model = [[TuyaResidenceInvitationCreateRequestModel alloc] init];
    model.siteId = [Helper getCurrentSiteModel].siteId;
    model.needMsgContent = YES;
    ty_weakify(self)
    [self.request invitationMemberWithCreateRequestModel:model success:^(TuyaResidenceInvitationResultModel * _Nonnull invitationResultModel) {
        ty_strongify(self)
        self.invitationResultModel = invitationResultModel;
        self.invitationCodeLabel.text = invitationResultModel.invitationCode;
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)deleteInvitationClick:(id)sender {
    NSNumber *invitationID = self.invitationResultModel.invitationId;
    ty_weakify(self)
    [self.request cancelInvitationWithInvitationID:invitationID success:^(BOOL result) {
        ty_strongify(self)
        [SVProgressHUD showSuccessWithStatus:@"Delete Successfully"];
        self.invitationCodeLabel.text = @"";
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (TuyaResidenceSiteInvitation *)request {
    if (!_request) {
        _request = [[TuyaResidenceSiteInvitation alloc] init];
    }
    return _request;
}

@end
