//
//  HHAccountSetupViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/1/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHAccountSetupViewController.h"
#import "HHTextFieldView.h"
#import "UIColor+HHColor.h"
#import "HHButton.h"
#import "Masonry.h"
#import "HHPopupUtility.h"
#import "HHCitySelectView.h"
#import "HHConstantsStore.h"
#import "HHCity.h"
#import "HHUserAuthService.h"
#import "HHToastManager.h"
#import "HHRootViewController.h"
#import "HHLoadingViewUtility.h"
#import "HHStudentService.h"


static CGFloat const avatarViewRadius = 50.0f;
static CGFloat const kFieldViewHeight = 40.0f;
static CGFloat const kFieldViewWidth = 280.0f;

@interface HHAccountSetupViewController () <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *explanationLabel;
@property (nonatomic, strong) HHTextFieldView *nameField;
@property (nonatomic, strong) HHTextFieldView *cityField;
@property (nonatomic, strong) UIImageView *bachgroudImageView;
@property (nonatomic, strong) HHButton *finishButton;
@property (nonatomic, strong) UIActionSheet *avatarOptionsSheet;
@property (nonatomic, strong) UIImage *selectedAvatarImage;
@property (nonatomic, strong) HHCitySelectView *citySelectView;
@property (nonatomic, strong) HHCity *selectedCity;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) NSString *studentId;

@end

@implementation HHAccountSetupViewController

- (instancetype)initWithStudentId:(NSString *)studentId {
    self = [super init];
    if (self) {
        self.studentId = studentId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor HHOrange];
    
    [self initSubviews];
}

- (void)initSubviews {
    
    self.bachgroudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"onboard_bg"]];
    [self.view addSubview:self.bachgroudImageView];
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.image = [UIImage imageNamed:@"ic_avatar_btn"];
    self.avatarImageView.contentMode = UIViewContentModeCenter;
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    self.avatarImageView.layer.cornerRadius = avatarViewRadius;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageOptions)];
    [self.avatarImageView addGestureRecognizer:tapRecognizer];
    [self.view addSubview:self.avatarImageView];
    
    self.explanationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.explanationLabel.text = @"请实名注册并提交真实头像\n以便获得更好的服务体验";
    self.explanationLabel.font = [UIFont systemFontOfSize:15.0f];
    self.explanationLabel.textColor = [UIColor HHLightOrange];
    self.explanationLabel.numberOfLines = 0;
    self.explanationLabel.textAlignment = NSTextAlignmentCenter;
    [self.explanationLabel sizeToFit];
    [self.view addSubview:self.explanationLabel];
    
    self.nameField = [[HHTextFieldView alloc] initWithPlaceHolder:@"输入您的姓名"];
    self.nameField.layer.cornerRadius = kFieldViewHeight/2.0f;
    self.nameField.textField.returnKeyType = UIReturnKeyDone;
    self.nameField.textField.delegate = self;
    [self.view addSubview:self.nameField];
    
    UIImageView *triangle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_triangle"]];
    triangle.contentMode = UIViewContentModeCenter;
    self.cityField = [[HHTextFieldView alloc] initWithPlaceHolder:@"选择您的所在地" rightView:triangle showSeparator:NO];
    self.cityField.layer.cornerRadius = kFieldViewHeight/2.0f;
    self.cityField.textField.enabled = NO;
    self.cityField.userInteractionEnabled = YES;
    UITapGestureRecognizer *cityTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCitySelectorView)];
    [self.cityField addGestureRecognizer:cityTapRecognizer];
    [self.view addSubview:self.cityField];
    
    self.finishButton = [[HHButton alloc] init];
    [self.finishButton HHWhiteBorderButton];
    self.finishButton.layer.cornerRadius = kFieldViewHeight/2.0f;
    [self.finishButton addTarget:self action:@selector(finishButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.finishButton setTitle:@"开始学车之旅" forState:UIControlStateNormal];
    [self.view addSubview:self.finishButton];
    
    [self makeConstraints];
}

#pragma mark - Auto Layout

- (void)makeConstraints {
    [self.avatarImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(30.0f);
        make.centerX.equalTo(self.view.centerX);
        make.width.mas_equalTo(avatarViewRadius * 2.0f);
        make.height.mas_equalTo(avatarViewRadius * 2.0f);
    }];
    
    [self.explanationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.bottom).offset(15.0f);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view.width);
    }];
    
    [self.nameField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.explanationLabel.bottom).offset(30.0f);
        make.centerX.equalTo(self.view.centerX);
        make.width.mas_equalTo(kFieldViewWidth);
        make.height.mas_equalTo(kFieldViewHeight);
    }];
    
    [self.cityField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameField.bottom).offset(15.0f);
        make.centerX.equalTo(self.view.centerX);
        make.width.mas_equalTo(kFieldViewWidth);
        make.height.mas_equalTo(kFieldViewHeight);
    }];
    
    [self.finishButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityField.bottom).offset(15.0f);
        make.centerX.equalTo(self.view.centerX);
        make.width.mas_equalTo(kFieldViewWidth);
        make.height.mas_equalTo(kFieldViewHeight);
    }];
    
    [self.bachgroudImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.centerY);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
}

#pragma mark - Button Actions 

- (void)showCitySelectorView {
    __weak HHAccountSetupViewController *weakSelf = self;
    [self.nameField.textField resignFirstResponder];
    [[HHConstantsStore sharedInstance] getConstantsWithCompletion:^(HHConstants *constants) {
        if ([constants.cities count]) {
            CGFloat height = MAX(300.0f, CGRectGetHeight(self.view.bounds)/2.0f);
            self.citySelectView = [[HHCitySelectView alloc] initWithCities:constants.cities frame:CGRectMake(0, 0, 300.0f, height) selectedCity:self.selectedCity];
            self.citySelectView.completion = ^(HHCity *selectedCity) {
                weakSelf.selectedCity = selectedCity;
                weakSelf.cityField.textField.text = selectedCity.cityName;
                [HHPopupUtility dismissPopup:weakSelf.popup];
            };
            self.popup = [HHPopupUtility createPopupWithContentView:self.citySelectView];
            [self.popup show];
            
        }
    }];
}

- (void)finishButtonTapped {
    if (![self areAllFieldsValid]) {
        return;
    }
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHUserAuthService sharedInstance] setupStudentInfoWithStudentId:self.studentId userName:self.nameField.textField.text cityId:self.selectedCity.cityId avatarURL:nil completion:^(HHStudent *student, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error) {
            HHRootViewController *rootVC = [[HHRootViewController alloc] init];
            [self presentViewController:rootVC animated:YES completion:nil];
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了，请重试！"];
        }
    }];
    
}

- (BOOL)areAllFieldsValid {
    if (!self.selectedCity.cityId) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请选择您所在城市"];
        return NO;
    }
    if (![self.nameField.textField.text length]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请填写您的名字"];
        return NO;
    }
    
    if (!self.selectedAvatarImage) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请选择上传的头像"];
        return NO;
    }
    return YES;
}

- (void)showImageOptions {
    [self.nameField.textField resignFirstResponder];
    self.avatarOptionsSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取", @"拍照", nil];
    [self.avatarOptionsSheet showInView:self.view];
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.nameField.textField]) {
        [self.nameField.textField resignFirstResponder];
    }
    return YES;
}


#pragma mark - UIActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([actionSheet isEqual:self.avatarOptionsSheet]) {
        switch (buttonIndex) {
            case 0: {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePickerController.delegate = self;
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                }
                
            } break;
                
            case 1: {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.delegate = self;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    imagePicker.allowsEditing = NO;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }
            } break;
                
            default:
                break;
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if ([info objectForKey:@"UIImagePickerControllerOriginalImage"]) {
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.avatarImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.selectedAvatarImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    
    if (self.selectedAvatarImage) {
        [[HHLoadingViewUtility sharedInstance] showLoadingViewWithText:@"上传图片中"];
        [[HHStudentService sharedInstance] uploadStudentAvatarWithImage:self.selectedAvatarImage completion:^(HHStudent *student, NSError *error) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            if (error) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"上传失败，请您重试！"];
                self.selectedAvatarImage = nil;
                self.avatarImageView.image = [UIImage imageNamed:@"ic_avatar_btn"];
                self.avatarImageView.contentMode = UIViewContentModeCenter;
            }
        }];
    }
    
}
@end