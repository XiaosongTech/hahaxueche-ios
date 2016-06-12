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

static CGFloat const kFieldViewHeight = 40.0f;
static CGFloat const kFieldViewWidth = 280.0f;

@interface HHAccountSetupViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *explanationLabel;
@property (nonatomic, strong) HHTextFieldView *nameField;
@property (nonatomic, strong) HHTextFieldView *cityField;
@property (nonatomic, strong) UIImageView *bachgroudImageView;
@property (nonatomic, strong) HHButton *finishButton;
@property (nonatomic, strong) HHCitySelectView *citySelectView;
@property (nonatomic, strong) HHCity *selectedCity;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) NSString *studentId;
@property (nonatomic, strong) UITextField *promoField;
@property (nonatomic, strong) UIButton *promoButton;

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
    
    self.explanationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.explanationLabel.text = @"请实名注册以便获得更好的服务体验";
    self.explanationLabel.font = [UIFont systemFontOfSize:15.0f];
    self.explanationLabel.textColor = [UIColor whiteColor];
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
    
    self.promoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.promoButton addTarget:self action:@selector(showPromoField) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.promoButton];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"有优惠码 " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor colorWithWhite:1.0f alpha:0.8f], NSParagraphStyleAttributeName:paragraphStyle, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"ic_coupon"];
    textAttachment.bounds = CGRectMake(5.0f, -1.0f, textAttachment.image.size.width, textAttachment.image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString appendAttributedString:attrStringWithImage];
    [self.promoButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    
    [self makeConstraints];
}

#pragma mark - Auto Layout

- (void)makeConstraints {
    
    [self.explanationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(20.0f);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view.width);
    }];
    
    [self.nameField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.explanationLabel.bottom).offset(20.0f);
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
    
    [self.promoButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.finishButton.bottom).offset(15.0f);
        make.centerX.equalTo(self.view.centerX);

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
    [self.view endEditing:YES];
    NSArray *cities = [[HHConstantsStore sharedInstance] getSupporteCities];
    CGFloat height = MAX(300.0f, CGRectGetHeight(self.view.bounds)/2.0f);
    self.citySelectView = [[HHCitySelectView alloc] initWithCities:cities frame:CGRectMake(0, 0, 300.0f, height) selectedCity:self.selectedCity];
    self.citySelectView.completion = ^(HHCity *selectedCity) {
        weakSelf.selectedCity = selectedCity;
        weakSelf.cityField.textField.text = selectedCity.cityName;
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:self.citySelectView];
    [self.popup show];
}

- (void)finishButtonTapped {
    if (![self areAllFieldsValid]) {
        return;
    }
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHStudentService sharedInstance] setupStudentInfoWithStudentId:self.studentId userName:self.nameField.textField.text cityId:self.selectedCity.cityId completion:^(HHStudent *student, NSError *error) {
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
    
    return YES;
}


#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)showPromoField {
    if (self.promoField) {
        [self.promoField becomeFirstResponder];
        return;
    }
    
    self.promoField = [[UITextField alloc] init];
    self.promoField.borderStyle = UITextBorderStyleNone;
    self.promoField.tintColor = [UIColor HHOrange];
    self.promoField.textColor = [UIColor HHOrange];
    self.promoField.textAlignment = NSTextAlignmentCenter;
    self.promoField.returnKeyType = UIReturnKeyDone;
    self.promoField.delegate = self;
    self.promoField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input"]];
    [self.promoField becomeFirstResponder];
    [self.view addSubview:self.promoField];
    
    [self.promoField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promoButton.bottom);
        make.centerX.equalTo(self.view.centerX);
        make.width.mas_equalTo(170.0f);
        make.height.mas_equalTo(40.0f);
    }];
}


@end
