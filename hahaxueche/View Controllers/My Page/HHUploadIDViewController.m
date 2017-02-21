//
//  HHUploadIDViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 23/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHUploadIDViewController.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHUploadIdView.h"
#import <TTTAttributedLabel.h>
#import "HHSupportUtility.h"
#import "HHPopupUtility.h"
#import "HHGenericTwoButtonsPopupView.h"
#import "HHGenericOneButtonPopupView.h"
#import "HHToastManager.h"
#import "HHReferFriendsViewController.h"
#import "HHSignContractViewController.h"
#import "HHStudentService.h"
#import "HHLoadingViewUtility.h"
#import "HHConstantsStore.h"
#import "NSNumber+HHNumber.h"
#import "HHContractViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"

static NSString *const kLabelText = @"请上传您的身份证信息，我们将会生成您的哈哈学车专属学员电子协议，该协议将在您的学车途中保障您的利益，同时也有助于教练尽快开展教学活动！若不上传您的真实信息，我们将无法保障您的合法权益！";
static NSString *const kSecurityText = @"*请确保您的二代身份证处于有效期内\n**所有信息已经经过加密处理, 保证您的信息安全";
static NSString *const kSupportText = @"对协议有任何疑问可致电客服热线400-001-6006\n或点击联系在线客服";

@interface HHUploadIDViewController () <TTTAttributedLabelDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) HHUploadIdView *faceView;
@property (nonatomic, strong) HHUploadIdView *backView;
@property (nonatomic, strong) UILabel *securityLabel;
@property (nonatomic, strong) TTTAttributedLabel *supportLabel;
@property (nonatomic, strong) UIButton *uploadButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIActionSheet *imgActionSheet;

@property (nonatomic, strong) UIImage *faceImg;
@property (nonatomic, strong) UIImage *backImg;

@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *idNumField;

@property (nonatomic) BOOL isFaceViewTapped;

@property (nonatomic) BOOL faceImgUploadSucceed;
@property (nonatomic) BOOL backImgUploadSucceed;

@end

@implementation HHUploadIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传身份信息";
    self.isFaceViewTapped = NO;
    self.view.backgroundColor = [UIColor colorWithRed:1.00 green:0.98 blue:0.95 alpha:1.00];
    [self initSubviews];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithTitle:@"协议模板" titleColor:[UIColor whiteColor] action:@selector(showTemplate) target:self isLeft:NO];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithTitle:@"手动填写" titleColor:[UIColor whiteColor] action:@selector(showIdInputView) target:self isLeft:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:upload_id_page_viewed attributes:nil];
}

- (void)initSubviews {
    self.scrollView  = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 10.0f;
    style.headIndent = 10.0f;
    style.tailIndent = -10.0f;
    style.lineSpacing = 5.0f;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:kLabelText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:style}];
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    
    self.topContainerView = [[UIView alloc] init];
    self.topContainerView.backgroundColor = [UIColor HHOrange];
    self.topContainerView.layer.masksToBounds = YES;
    self.topContainerView.layer.cornerRadius = 5.0f;
    [self.scrollView addSubview:self.topContainerView];
    [self.topContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.top.equalTo(self.scrollView.top).offset(20.0f);
        make.width.equalTo(self.scrollView.width).offset(-40.0f);
        make.height.mas_equalTo(CGRectGetHeight(rect) + 40.0f);

    }];

    
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.attributedText = string;
    self.topLabel.numberOfLines = 0;
    self.topLabel.backgroundColor = [UIColor HHOrange];
    [self.topContainerView addSubview:self.topLabel];
    [self.topLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topContainerView);
        make.width.equalTo(self.topContainerView.width).offset(-10.0f);
    }];
    
    __weak HHUploadIDViewController *weakSelf = self;
    self.faceView = [[HHUploadIdView alloc] initWithText:@"点击上传\n身份证\n正面" image:[UIImage imageNamed:@"idcard_a"]];
    self.faceView.actionBlock = ^() {
        weakSelf.isFaceViewTapped = YES;
        [weakSelf showImageOptionsWithTitle:@"上传身份证正面"];
    };
    [self.scrollView addSubview:self.faceView];
    [self.faceView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.top.equalTo(self.topContainerView.bottom).offset(20.0f);
        make.width.equalTo(self.scrollView.width).offset(-40.0f);
        make.height.mas_equalTo(150.0f);
    }];
    
    self.backView = [[HHUploadIdView alloc] initWithText:@"点击上传\n身份证\n反面" image:[UIImage imageNamed:@"idcard_b"]];
    self.backView.actionBlock = ^() {
        weakSelf.isFaceViewTapped = NO;
        [weakSelf showImageOptionsWithTitle:@"上传身份证反面"];
    };
    [self.scrollView addSubview:self.backView];
    [self.backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.top.equalTo(self.faceView.bottom).offset(20.0f);
        make.width.equalTo(self.scrollView.width).offset(-40.0f);
        make.height.mas_equalTo(150.0f);
    }];
    
    self.securityLabel = [[UILabel alloc] init];
    self.securityLabel.text = kSecurityText;
    self.securityLabel.numberOfLines = 0;
    self.securityLabel.textColor = [UIColor HHOrange];
    self.securityLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.scrollView addSubview:self.securityLabel];
    [self.securityLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.top.equalTo(self.backView.bottom).offset(20.0f);
        make.width.equalTo(self.scrollView.width).offset(-40.0f);
    }];
    
    self.uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.uploadButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [self.uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.uploadButton.backgroundColor = [UIColor HHOrange];
    self.uploadButton.layer.masksToBounds = YES;
    [self.uploadButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.uploadButton.layer.cornerRadius = 25.0f;
    [self.scrollView addSubview:self.uploadButton];
    [self.uploadButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView.centerX);
        make.top.equalTo(self.securityLabel.bottom).offset(30.0f);
        make.height.mas_equalTo(50.0f);
        make.width.equalTo(self.scrollView.width).offset(-80.0f);
    }];
    
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.cancelButton setTitle:@"稍后提交" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor HHLightTextGray] forState:UIControlStateNormal];
    self.cancelButton.backgroundColor = [UIColor clearColor];
    [self.cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.cancelButton];
    [self.cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView.centerX);
        make.top.equalTo(self.uploadButton.bottom).offset(5.0f);
    }];
    
    self.supportLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.supportLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName:[UIColor HHOrange]};
    self.supportLabel.numberOfLines = 0;
    self.supportLabel.delegate = self;
    self.supportLabel.textAlignment = NSTextAlignmentCenter;
    self.supportLabel.attributedText = [self buildAttributeString];
    [self.scrollView addSubview:self.supportLabel];
    [self.supportLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(20.0f);
        make.top.equalTo(self.cancelButton.bottom).offset(30.0f);
        make.width.equalTo(self.scrollView.width).offset(-40.0f);
    }];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.supportLabel
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-20.0f]];
    
}

- (NSMutableAttributedString *)buildAttributeString {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5.0f;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:kSupportText attributes:@{NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSFontAttributeName:[UIFont systemFontOfSize:13.0f], NSParagraphStyleAttributeName:style}];
    
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:[kSupportText rangeOfString:@"400-001-6006"]];
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:[kSupportText rangeOfString:@"在线客服"]];
    
    [self.supportLabel addLinkToURL:[NSURL URLWithString:@"callSupport"] withRange:[kSupportText rangeOfString:@"400-001-6006"]];
    [self.supportLabel addLinkToURL:[NSURL URLWithString:@"onlineSupport"] withRange:[kSupportText rangeOfString:@"在线客服"]];
    
    return attrString;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([url.absoluteString isEqualToString:@"callSupport"]) {
        [[HHSupportUtility sharedManager] callSupport];
    } else {
        [self.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:self.navigationController] animated:YES];
    }
}

#pragma mark - UIActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if ([info objectForKey:@"UIImagePickerControllerOriginalImage"]) {
        if (self.isFaceViewTapped) {
            self.faceImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        } else {
            self.backImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
        
    }
    
    if (self.isFaceViewTapped) {
        [[HHLoadingViewUtility sharedInstance] showLoadingViewWithText:@"上传中!"];
        [[HHStudentService sharedInstance] uploadIDCardWithImage:self.faceImg side:@(0) completion:^(NSString *imgURL) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            if (imgURL) {
                [[HHToastManager sharedManager] showSuccessToastWithText:@"上传成功!"];
                self.faceView.imgView.contentMode = UIViewContentModeScaleToFill;
                self.faceView.imgView.image = self.faceImg;
                self.faceImgUploadSucceed = YES;
            } else {
                [[HHToastManager sharedManager] showErrorToastWithText:@"上传失败! 请检查图片是否包含身份证的所有信息, 然后重新上传!"];
                self.faceImg = nil;
            }
        }];
    } else if (self.backImg) {
        
        [[HHLoadingViewUtility sharedInstance] showLoadingViewWithText:@"上传中!"];
        [[HHStudentService sharedInstance] uploadIDCardWithImage:self.backImg side:@(1) completion:^(NSString *imgURL) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            if (imgURL) {
                [[HHToastManager sharedManager] showSuccessToastWithText:@"上传成功!"];
                self.backView.imgView.contentMode = UIViewContentModeScaleToFill;
                self.backView.imgView.image = self.backImg;
                self.backImgUploadSucceed = YES;
            } else {
                [[HHToastManager sharedManager] showErrorToastWithText:@"上传失败! 请检查图片是否包含身份证的所有信息, 然后重新上传!"];
                self.backImg = nil;
            }
        }];

    }
    
}

- (void)showImageOptionsWithTitle:(NSString *)title {
    self.imgActionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取", @"拍照", nil];
    [self.imgActionSheet showInView:self.view];
}

- (void)cancelButtonTapped {
    __weak HHUploadIDViewController *weakSelf = self;
    HHGenericTwoButtonsPopupView *view = [[HHGenericTwoButtonsPopupView alloc] initWithTitle:@"友情提醒" info:[self buildPopupInfoTextWithString:@"如果不上传合您的信息, \n我们将无法保证您的合法权益!"] leftButtonTitle:@"稍后上传" rightButtonTitle:@"继续上传"];
    view.confirmBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:upload_id_page_popup_confirm_tapped attributes:nil];
    };
    view.cancelBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:upload_id_page_popup_cancel_tapped attributes:nil];
        [weakSelf showSharePopup];
    };
    weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
    [HHPopupUtility showPopup:weakSelf.popup];
    
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:upload_id_page_cancel_tapped attributes:nil];
    
}

- (void)confirmButtonTapped {
    if (!self.faceImg || !self.backImg) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请先上传身份证正反面"];
        return;
    }
    [[HHLoadingViewUtility sharedInstance] showLoadingViewWithText:@"图片处理中..."];
    [[HHStudentService sharedInstance] getAgreementURLWithCompletion:^(NSURL *url, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error && url) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"studentUpdated" object:nil];
            HHSignContractViewController *vc = [[HHSignContractViewController alloc] initWithURL:url];
            [self.navigationController setViewControllers:@[vc] animated:YES];
        } else {
            if ([error.localizedFailureReason isEqual:@(40026)]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"身份证正面识别失败, 请重新拍摄并上传!"];
            } else if ([error.localizedFailureReason isEqual:@(40028)]) {
                [[HHToastManager sharedManager] showErrorToastWithText:@"身份证信息无效, 请确保使用真实的第二代身份证!"];
            } else {
                [[HHToastManager sharedManager] showErrorToastWithText:@"上传失败, 请重试!"];
            }
        }
    }];
    
    
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:upload_id_page_confirm_tapped attributes:nil];
    
}

- (void)showSharePopup {
    __weak HHUploadIDViewController *weakSelf = self;
    HHGenericOneButtonPopupView *view = [[HHGenericOneButtonPopupView alloc] initWithTitle:@"推荐好友" info:[self buildPopupInfoTextWithString:[NSString stringWithFormat:@"恭喜您！报名成功，现在分享<学车大礼包>给好友吧, 好友报名学车立减%@元, 还有科一挂科险！", [[[HHConstantsStore sharedInstance] getCityRefereeBonus] generateMoneyString]]]];
    [view.buttonView.okButton setTitle:@"分享得现金" forState:UIControlStateNormal];
    view.cancelBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
        HHReferFriendsViewController *vc = [[HHReferFriendsViewController alloc] init];
        [weakSelf.navigationController setViewControllers:@[vc] animated:YES];
    };
    weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
    weakSelf.popup.shouldDismissOnContentTouch = NO;
    weakSelf.popup.shouldDismissOnBackgroundTouch = NO;
    [HHPopupUtility showPopup:weakSelf.popup];
}

- (NSMutableAttributedString *)buildPopupInfoTextWithString:(NSString *)string {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    style.lineSpacing = 5.0f;
    return [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:style}];
}


- (void)showTemplate {
    HHContractViewController *vc = [[HHContractViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES completion:nil];

}


- (void)showIdInputView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入您的真实姓名和身份证号码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.idNumField.text isEqualToString:@""] || [self.nameField.text isEqualToString:@""]) {
            [[HHToastManager sharedManager] showErrorToastWithText:@"请填写真实姓名和身份证号码"];
        } else {
            [[HHLoadingViewUtility sharedInstance] showLoadingViewWithText:@"验证中..."];
            [[HHStudentService sharedInstance] verifyIdWithNumber:self.idNumField.text name:self.nameField.text completion:^(NSError *error) {
                if (!error) {
                    [[HHStudentService sharedInstance] getAgreementURLWithCompletion:^(NSURL *url, NSError *error) {
                        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                        if (!error && url) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"studentUpdated" object:nil];
                            HHSignContractViewController *vc = [[HHSignContractViewController alloc] initWithURL:url];
                            [self.navigationController setViewControllers:@[vc] animated:YES];
                        } else {
                            [[HHToastManager sharedManager] showErrorToastWithText:@"获取失败"];
                        }
                    }];

                } else {
                    [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
                    [[HHToastManager sharedManager] showErrorToastWithText:@"实名认证失败, 请确认真实姓名和身份证号码信息!"];
                }
            }];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
         self.nameField = textField;
         textField.placeholder = @"真实姓名";
     }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        self.idNumField = textField;
         textField.placeholder = @"身份证号码";
     }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
