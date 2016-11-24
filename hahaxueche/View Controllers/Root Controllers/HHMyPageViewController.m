//
//  HHMyPageViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyPageViewController.h"
#import "HHMyPageUserInfoCell.h"
#import "UIColor+HHColor.h"
#import "HHMyPageCoachCell.h"
#import "HHMyPageSupportCell.h"
#import "HHMyPageHelpCell.h"
#import "HHMyPageLogoutCell.h"
#import "HHMyPageMyCourseScheduleCell.h"
#import "HHMyCoachDetailViewController.h"
#import "HHStudentStore.h"
#import "Masonry.h"
#import "HHIntroViewController.h"
#import "HHSocialMediaShareUtility.h"
#import "HHUserAuthService.h"
#import "HHPaymentStatusViewController.h"
#import "HHFollowedCoachListViewController.h"
#import "HHToastManager.h"
#import "HHCoachService.h"
#import "HHStudentService.h"
#import "HHLoadingViewUtility.h"
#import "HHWebViewController.h"
#import "HHAppInfoViewController.h"
#import "HHMyPageReferCell.h"
#import <Appirater.h>
#import "HHReferFriendsViewController.h"
#import "HHLongImageViewController.h"
#import "SDImageCache.h"
#import "HHEditNameView.h"
#import "HHPopupUtility.h"
#import "HHEditNameView.h"
#import "HHStudentService.h"
#import "HHStudentStore.h"
#import <RSKImageCropper/RSKImageCropper.h>
#import "HHSupportUtility.h"
#import "HHAdvisorView.h"
#import "HHBookTrainingViewController.h"
#import "HHMyPageVoucherCell.h"
#import "HHVouchersViewController.h"
#import "HHMyContractTableViewCell.h"
#import "HHContractViewController.h"
#import "HHPopupUtility.h"
#import "HHGenericTwoButtonsPopupView.h"
#import "HHUploadIDViewController.h"


static NSString *const kUserInfoCell = @"userInfoCell";
static NSString *const kCoachCell = @"coachCell";
static NSString *const kSupportCell = @"supportCell";
static NSString *const kHelpCell = @"helpCell";
static NSString *const kLogoutCell = @"logoutCell";
static NSString *const kReferCell = @"referCell";
static NSString *const kMyCourseScheduleCell = @"kMyCourseScheduleCell";
static NSString *const kVouchereCell = @"kVouchereCell";
static NSString *const kContractCell = @"kContractCell";

static NSString *const kAboutStudentLink = @"http://staging.hahaxueche.net/#/student";
static NSString *const kActivateVoucherProdLink = @"http://m.hahaxueche.com/share/jihuo?";
static NSString *const kActivateVoucherStagingLink = @"http://staging-m.hahaxueche.com/share/jihuo?";

typedef NS_ENUM(NSInteger, MyPageCell) {
    MyPageCellUserInfo,
    MyPageCellRefer,
    MyPageCellCoach,
    MyPageCellVoucher,
    MyPageCellContract,
    MyPageCellMyCourseSchedule,
    MyPageCellSupport,
    MyPageCellHelp,
    MyPageCellLogout,
    MyPageCellCount,
};

@interface HHMyPageViewController() <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *loginSignupButton;
@property (nonatomic, strong) UIActionSheet *avatarOptionsSheet;
@property (nonatomic, strong) HHStudent *currentStudent;

@property (nonatomic, strong) HHCoach *myCoach;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) HHEditNameView *editView;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) HHAdvisor *advisor;

@end

@implementation HHMyPageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的页面";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.currentStudent = [HHStudentStore sharedInstance].currentStudent;
    [self initSubviews];
    if (self.currentStudent.currentCoachId) {
        [[HHCoachService sharedInstance] fetchCoachWithId:self.currentStudent.currentCoachId completion:^(HHCoach *coach, NSError *error) {
            if (!error) {
                self.myCoach = coach;
                [self.tableView reloadData];
            }
        }];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(coachPurchased)
                                                 name:@"coachPurchased"
                                               object:nil];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];

    [[HHStudentService sharedInstance] getMyAdvisorWithCompletion:^(HHAdvisor *advisor, NSError *error) {
        if (!error) {
            self.advisor = advisor;
            [self.tableView reloadData];
        }
    }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_viewed attributes:nil];
}

- (void)initSubviews {
    // Guest
    if (![HHStudentStore sharedInstance].currentStudent.studentId) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"你怎么还没登录呀〒▽〒";
        self.titleLabel.textColor = [UIColor HHLightTextGray];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.view addSubview:self.titleLabel];
        
        self.loginSignupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.loginSignupButton setTitle:@"登录或注册" forState:UIControlStateNormal];
        [self.loginSignupButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
        self.loginSignupButton.titleLabel.font = [UIFont systemFontOfSize:25.0f];
        [self.loginSignupButton addTarget:self action:@selector(jumpToIntroVC) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.loginSignupButton];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.centerX);
            make.centerY.equalTo(self.view.centerY).offset(-30.0f);
        }];
        
        
        [self.loginSignupButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view.centerY);
            make.centerX.equalTo(self.view.centerX);
        }];
        
        
    } else {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)- CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds))];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor HHBackgroundGary];
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:self.tableView];
        
        UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0,-480,CGRectGetWidth(self.view.bounds),480)];
        topview.backgroundColor = [UIColor HHOrange];
        
        [self.tableView addSubview:topview];
        
        [self.tableView registerClass:[HHMyPageUserInfoCell class] forCellReuseIdentifier:kUserInfoCell];
        [self.tableView registerClass:[HHMyPageCoachCell class] forCellReuseIdentifier:kCoachCell];
        [self.tableView registerClass:[HHMyPageSupportCell class] forCellReuseIdentifier:kSupportCell];
        [self.tableView registerClass:[HHMyPageHelpCell class] forCellReuseIdentifier:kHelpCell];
        [self.tableView registerClass:[HHMyPageLogoutCell class] forCellReuseIdentifier:kLogoutCell];
        [self.tableView registerClass:[HHMyPageReferCell class] forCellReuseIdentifier:kReferCell];
        [self.tableView registerClass:[HHMyPageMyCourseScheduleCell class] forCellReuseIdentifier:kMyCourseScheduleCell];
        [self.tableView registerClass:[HHMyPageVoucherCell class] forCellReuseIdentifier:kVouchereCell];
        [self.tableView registerClass:[HHMyContractTableViewCell class] forCellReuseIdentifier:kContractCell];
    }
    
}

#pragma mark - TableView Delegate & Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MyPageCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak HHMyPageViewController *weakSelf = self;
    switch (indexPath.row) {
        case MyPageCellUserInfo: {
            HHMyPageUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCell];
            cell.paymentViewActionBlock = ^(){
                if ([weakSelf.currentStudent.purchasedServiceArray firstObject]) {
                    HHPaymentStatusViewController *vc = [[HHPaymentStatusViewController alloc] initWithPurchasedService:[weakSelf.currentStudent.purchasedServiceArray firstObject] coach:weakSelf.myCoach];
                    vc.updatePSBlock = ^(HHPurchasedService *updatePS){
                        weakSelf.currentStudent.purchasedServiceArray = @[updatePS];
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:MyPageCellUserInfo inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        [[HHStudentService sharedInstance] fetchStudentWithId:[HHStudentStore sharedInstance].currentStudent.studentId completion:^(HHStudent *student, NSError *error) {
                            [HHStudentStore sharedInstance].currentStudent = student;
                            weakSelf.currentStudent = student;
                            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:MyPageCellUserInfo inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        }];
                    };
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_pay_coach_status_tapped attributes:nil];
                }
                
            };
            cell.avatarViewActionBlock = ^() {
                [weakSelf showImageOptions];
            };
            
            cell.editNameBlock = ^() {
                HHEditNameView *view = [[HHEditNameView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds)-30.0f, 190.0f) name:weakSelf.currentStudent.name];
                [view.buttonsView.leftButton addTarget:weakSelf action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
                [view.buttonsView.rightButton addTarget:weakSelf action:@selector(saveName) forControlEvents:UIControlEventTouchUpInside];
                weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
                [HHPopupUtility showPopup:weakSelf.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutAboveCenter)];
                [view.field becomeFirstResponder];
                
                weakSelf.editView = view;
            };
            [cell setupCellWithStudent:self.currentStudent];
            return cell;
            
        } break;
            
        case MyPageCellRefer: {
            HHMyPageReferCell *cell = [tableView dequeueReusableCellWithIdentifier:kReferCell];
            return cell;
        } break;
            
        case MyPageCellCoach: {
            HHMyPageCoachCell *cell = [tableView dequeueReusableCellWithIdentifier:kCoachCell];
            cell.myCoachView.actionBlock = ^(){
                if ([weakSelf.currentStudent.purchasedServiceArray count]) {
                    HHMyCoachDetailViewController *myCoachVC = [[HHMyCoachDetailViewController alloc] initWithCoach:weakSelf.myCoach];
                    myCoachVC.hidesBottomBarWhenPushed = YES;
                    myCoachVC.updateCoachBlock = ^(HHCoach *coach) {
                        weakSelf.myCoach = coach;
                    };
                    [weakSelf.navigationController pushViewController:myCoachVC animated:YES];
                } else {
                    [[HHToastManager sharedManager] showErrorToastWithText:@"您还没有购买的教练"];
                }
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_my_coach_tapped attributes:nil];
            };
            cell.followedCoachView.actionBlock = ^(){
                HHFollowedCoachListViewController *vc = [[HHFollowedCoachListViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_my_followed_coach_tapped attributes:nil];
            };
            return cell;
        } break;
            
            
        case MyPageCellVoucher: {
            HHMyPageVoucherCell *cell = [tableView dequeueReusableCellWithIdentifier:kVouchereCell];
            cell.myVoucherView.actionBlock = ^() {
                HHVouchersViewController *vc = [[HHVouchersViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;
            
        } break;
            
        case MyPageCellContract: {
            HHMyContractTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kContractCell];
            cell.myContractView.actionBlock = ^() {
                if ([self.currentStudent.purchasedServiceArray count]) {
                    if (![self.currentStudent.uploadedID boolValue]) {
                        //pop up upload id
                        HHGenericTwoButtonsPopupView *view = [[HHGenericTwoButtonsPopupView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds)-30.0f, 200.0f) title:@"友情提醒" subTitle:nil info:[weakSelf buildPopupInfoTextWithString:@"快去上传资料签署专属学员协议吧!"] leftButtonTitle:@"取消" rightButtonTitle:@"去上传"];
                        view.confirmBlock = ^() {
                            [HHPopupUtility dismissPopup:weakSelf.popup];
                            HHUploadIDViewController *vc = [[HHUploadIDViewController alloc] init];
                            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
                            [weakSelf presentViewController:navVC animated:YES completion:nil];
                        };
                        view.cancelBlock = ^() {
                            [HHPopupUtility dismissPopup:weakSelf.popup];
                        };
                        weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
                        [HHPopupUtility showPopup:weakSelf.popup];
                        
                    } else if (![self.currentStudent.signedContract boolValue]) {
                        //pop up sign contract
                        HHGenericTwoButtonsPopupView *view = [[HHGenericTwoButtonsPopupView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds)-30.0f, 200.0f) title:@"友情提醒" subTitle:nil info:[weakSelf buildPopupInfoTextWithString:@"快去签署专属学员协议吧!"] leftButtonTitle:@"取消" rightButtonTitle:@"去签署"];
                        view.confirmBlock = ^() {
                            [HHPopupUtility dismissPopup:weakSelf.popup];
                        };
                        view.cancelBlock = ^() {
                            [HHPopupUtility dismissPopup:weakSelf.popup];
                        };
                        weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
                        [HHPopupUtility showPopup:weakSelf.popup];
                        
                    } else {
                        HHContractViewController *vc = [[HHContractViewController alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController setViewControllers:@[vc] animated:YES];
                    }
                    

                } else {
                    HHGenericTwoButtonsPopupView *view = [[HHGenericTwoButtonsPopupView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds)-30.0f, 220.0f) title:@"友情提醒" subTitle:nil info:[weakSelf buildPopupInfoTextWithString:@"您还没有报名哟~\n快去选选心仪的教练报名学车吧~"] leftButtonTitle:@"取消" rightButtonTitle:@"去逛逛"];
                    view.confirmBlock = ^() {
                        [HHPopupUtility dismissPopup:weakSelf.popup];
                        weakSelf.tabBarController.selectedIndex = 1;
                    };
                    view.cancelBlock = ^() {
                        [HHPopupUtility dismissPopup:weakSelf.popup];
                    };
                    weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
                    [HHPopupUtility showPopup:weakSelf.popup];
                    
                }
            };
            return cell;
        } break;
            
        case MyPageCellMyCourseSchedule: {
            HHMyPageMyCourseScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyCourseScheduleCell];
            cell.myCourseView.actionBlock = ^() {
                HHBookTrainingViewController *vc = [[HHBookTrainingViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_my_course_tapped attributes:nil];
            };
            
            return cell;
                        
        } break;
            
        case MyPageCellSupport: {
            HHMyPageSupportCell *cell = [tableView dequeueReusableCellWithIdentifier:kSupportCell];
            cell.supportOnlineView.actionBlock = ^() {
                [weakSelf.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:weakSelf.navigationController] animated:YES];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_online_support_tapped attributes:nil];
            };
            cell.myAdvisorView.actionBlock = ^() {
                HHAdvisorView *view = [[HHAdvisorView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 20.0f, 240.0f) advisor:self.advisor];
                view.callBlock = ^() {
                    [weakSelf callAdvisor];
                    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_my_advisor_tapped attributes:nil];
                };
                weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
                [HHPopupUtility showPopup:weakSelf.popup];
            };
            return cell;
        } break;
            
        case MyPageCellHelp: {
            HHMyPageHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:kHelpCell];
            
            cell.faqView.actionBlock = ^() {
                HHLongImageViewController *faq = [[HHLongImageViewController alloc] initWithImage:[UIImage imageNamed:@"faq.png"]];
                faq.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:faq animated:YES];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_FAQ_tapped attributes:nil];
            };
            
            cell.appInfoView.actionBlock = ^() {
                HHAppInfoViewController *vc = [[HHAppInfoViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_version_check_tapped attributes:nil];
            };
            cell.rateUsView.actionBlock = ^() {
                [Appirater rateApp];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_rate_us_tapped attributes:nil];
            };
            return cell;
        } break;
          
        case MyPageCellLogout: {
            HHMyPageLogoutCell *cell = [tableView dequeueReusableCellWithIdentifier:kLogoutCell];
            [cell.button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        } break;
            
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        } break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case MyPageCellUserInfo:
            return 280.0f;
            
        case MyPageCellRefer:
            return 60.0f;
            
        case MyPageCellCoach:
            return kTitleViewHeight + kItemViewHeight * 2.0f;
            
        case MyPageCellVoucher:
            return kTopPadding + kTitleViewHeight + kItemViewHeight;
        
        case MyPageCellContract:
            return kTopPadding + kTitleViewHeight + kItemViewHeight;
            
        case MyPageCellMyCourseSchedule:
            return kTopPadding + kTitleViewHeight + kItemViewHeight;
            
        case MyPageCellSupport:
            return kTopPadding + kTitleViewHeight + kItemViewHeight * 2.0f;
            
        case MyPageCellHelp:
            return kTopPadding + kTitleViewHeight + kItemViewHeight * 3.0f;
            
        case MyPageCellLogout:
            return 50 + kTopPadding * 2.0f;
            
        default:
            return 50;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == MyPageCellRefer) {
        HHReferFriendsViewController *vc = [[HHReferFriendsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_refer_tapped attributes:nil];
    }
}

#pragma mark - Others

- (NSMutableAttributedString *)buildGuestString {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"您还没有登陆, 请先" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:@"登陆或注册" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle, NSLinkAttributeName:@"fakeString"}];
    
    [attributedString appendAttributedString:attributedString2];
    
    return attributedString;
}

- (void)logout {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您确认要退出？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[HHUserAuthService sharedInstance] logOutWithCompletion:^(NSError *error) {
            if (!error) {
                HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
                UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:introVC];
                [self presentViewController:navVC animated:YES completion:nil];
            }
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消返回" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showImageOptions {
    self.avatarOptionsSheet = [[UIActionSheet alloc] initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取", @"拍照", nil];
    [self.avatarOptionsSheet showInView:self.view];
}

- (void)coachPurchased {
    self.currentStudent = [HHStudentStore sharedInstance].currentStudent;
    if (self.currentStudent.currentCoachId) {
        [[HHCoachService sharedInstance] fetchCoachWithId:self.currentStudent.currentCoachId completion:^(HHCoach *coach, NSError *error) {
            if (!error) {
                self.myCoach = coach;
                [self.tableView reloadData];
            }
        }];
    }
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
        self.selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    
    if (self.selectedImage) {
        
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:self.selectedImage];
        imageCropVC.delegate = self;
        imageCropVC.view.backgroundColor = [UIColor whiteColor];
        imageCropVC.moveAndScaleLabel.text = @"裁切图片";
        imageCropVC.hidesBottomBarWhenPushed = YES;
        [imageCropVC.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [imageCropVC.chooseButton setTitle:@"确认" forState:UIControlStateNormal];
        [self.navigationController pushViewController:imageCropVC animated:NO];
    }

}

- (void)jumpToIntroVC {
    HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
    introVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:introVC animated:YES];
}

- (void)dismissPopup {
    [self.editView.field resignFirstResponder];
    [HHPopupUtility dismissPopup:self.popup];
}

- (void)saveName {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHStudentService sharedInstance] setupStudentInfoWithStudentId:[HHStudentStore sharedInstance].currentStudent.studentId userName:self.editView.field.text cityId:[HHStudentStore sharedInstance].currentStudent.cityId promotionCode:nil completion:^(HHStudent *student, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error) {
            self.currentStudent = student;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:MyPageCellUserInfo inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [HHPopupUtility dismissPopup:self.popup];
            [[HHToastManager sharedManager] showSuccessToastWithText:@"设置成功"];
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了, 请重试!"];
        }
    }];
    
}

// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect {
    self.selectedImage = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
    
    [self uploadAvatar];
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle {
    
    self.selectedImage = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
    [self uploadAvatar];
}

- (void)uploadAvatar {
    [[HHLoadingViewUtility sharedInstance] showLoadingViewWithText:@"上传图片中"];
    [[HHStudentService sharedInstance] uploadStudentAvatarWithImage:self.selectedImage completion:^(HHStudent *student, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (error) {
            [[HHToastManager sharedManager] showErrorToastWithText:@"上传失败，请您重试！"];
        } else {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:MyPageCellUserInfo inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [HHStudentStore sharedInstance].currentStudent = student;
            self.currentStudent = student;
            [self.tableView reloadData];
        }
    }];
}

- (void)callAdvisor {
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",self.advisor.phoneNumber]];
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}

- (NSMutableAttributedString *)buildPopupInfoTextWithString:(NSString *)string {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.lineSpacing = 5.0f;
    return [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:style}];
}


@end
