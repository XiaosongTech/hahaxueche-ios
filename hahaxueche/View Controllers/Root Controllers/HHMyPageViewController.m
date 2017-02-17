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
#import <Appirater.h>
#import "HHReferFriendsViewController.h"
#import "HHLongImageViewController.h"
#import "SDImageCache.h"
#import "HHPopupUtility.h"
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
#import "HHSignContractViewController.h"
#import "HHGuardCardTableViewCell.h"
#import "HHGuardCardViewController.h"


static NSString *const kUserInfoCell = @"userInfoCell";
static NSString *const kCoachCell = @"coachCell";
static NSString *const kSupportCell = @"supportCell";
static NSString *const kHelpCell = @"helpCell";
static NSString *const kLogoutCell = @"logoutCell";
static NSString *const kMyCourseScheduleCell = @"kMyCourseScheduleCell";
static NSString *const kVouchereCell = @"kVouchereCell";
static NSString *const kContractCell = @"kContractCell";
static NSString *const kGuardCardCell = @"kGuardCardCell";


typedef NS_ENUM(NSInteger, MyPageCellSectionOne) {
    MyPageCellSectionOneUserInfo,
    MyPageCellSectionOneCount,
};

typedef NS_ENUM(NSInteger, MyPageCellSectionTwo) {
    MyPageCellSectionTwoCoach,
    MyPageCellSectionTwoVoucher,
    MyPageCellSectionTwoGuardCard,
    MyPageCellSectionTwoContract,
    MyPageCellSectionTwoCourseSchedule,
    MyPageCellSectionTwoSupport,
    MyPageCellSectionTwoHelp,
    MyPageCellSectionTwoLogout,
    MyPageCellSectionTwoCount,
};

@interface HHMyPageViewController() <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *loginSignupButton;
@property (nonatomic, strong) UIActionSheet *avatarOptionsSheet;
@property (nonatomic, strong) HHStudent *currentStudent;

@property (nonatomic, strong) HHCoach *myCoach;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) HHAdvisor *advisor;
@property (nonatomic) BOOL isLoggedIn;
@property (nonatomic, strong) UIView *referView;

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
    self.isLoggedIn = [self.currentStudent isLoggedIn];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(studentUpdated)
                                                 name:@"studentUpdated"
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
    [self.tableView registerClass:[HHMyPageMyCourseScheduleCell class] forCellReuseIdentifier:kMyCourseScheduleCell];
    [self.tableView registerClass:[HHMyPageVoucherCell class] forCellReuseIdentifier:kVouchereCell];
    [self.tableView registerClass:[HHMyContractTableViewCell class] forCellReuseIdentifier:kContractCell];
    [self.tableView registerClass:[HHGuardCardTableViewCell class] forCellReuseIdentifier:kGuardCardCell];
}

#pragma mark - TableView Delegate & Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return MyPageCellSectionOneCount;
    } else {
        return MyPageCellSectionTwoCount;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak HHMyPageViewController *weakSelf = self;
    if (indexPath.section == 0) {
        HHMyPageUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCell];
        cell.paymentViewActionBlock = ^(){
            if (!weakSelf.isLoggedIn) {
                [weakSelf showLoginAlert];
                return;
            }
            if ([weakSelf.currentStudent.purchasedServiceArray firstObject]) {
                HHPaymentStatusViewController *vc = [[HHPaymentStatusViewController alloc] initWithPurchasedService:[weakSelf.currentStudent.purchasedServiceArray firstObject] coach:weakSelf.myCoach];
                vc.updatePSBlock = ^(HHPurchasedService *updatePS){
                    weakSelf.currentStudent.purchasedServiceArray = @[updatePS];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:MyPageCellSectionOneUserInfo inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    [[HHStudentService sharedInstance] fetchStudentWithId:[HHStudentStore sharedInstance].currentStudent.studentId completion:^(HHStudent *student, NSError *error) {
                        [HHStudentStore sharedInstance].currentStudent = student;
                        weakSelf.currentStudent = student;
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:MyPageCellSectionOneUserInfo inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                };
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_pay_coach_status_tapped attributes:nil];
            }
            
        };
        cell.avatarViewActionBlock = ^() {
            if (!weakSelf.isLoggedIn) {
                [weakSelf showLoginAlert];
            } else {
                [weakSelf showImageOptions];
            }
            
        };
        
        cell.editNameBlock = ^() {
            if (!weakSelf.isLoggedIn) {
                [weakSelf showLoginAlert];
            } else {
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"修改姓名"
                                                      message:nil
                                                      preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:@"取消"
                                               style:UIAlertActionStyleCancel
                                               handler:nil];
                
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:@"确认"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action) {
                                               NSString *name = alertController.textFields.firstObject.text;
                                               [self saveName:name];
                                           }];
                
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"输入新用户名";
                    textField.returnKeyType = UIReturnKeyDone;
                }];
                
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
        };
        if (self.isLoggedIn) {
            [cell setupCellWithStudent:self.currentStudent];
        } else {
            [cell setupCellWithStudent:nil];
        }
        
        return cell;

    } else {
        switch (indexPath.row) {
            case MyPageCellSectionTwoCoach: {
                HHMyPageCoachCell *cell = [tableView dequeueReusableCellWithIdentifier:kCoachCell];
                cell.myCoachView.actionBlock = ^(){
                    if (!weakSelf.isLoggedIn) {
                        [weakSelf showLoginAlert];
                        return;
                    }
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
                    if (!weakSelf.isLoggedIn) {
                        [weakSelf showLoginAlert];
                        return;
                    }
                    HHFollowedCoachListViewController *vc = [[HHFollowedCoachListViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_my_followed_coach_tapped attributes:nil];
                };
                return cell;
            } break;
                
                
            case MyPageCellSectionTwoVoucher: {
                HHMyPageVoucherCell *cell = [tableView dequeueReusableCellWithIdentifier:kVouchereCell];
                cell.myVoucherView.actionBlock = ^() {
                    HHVouchersViewController *vc = [[HHVouchersViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                };
                return cell;
                
            } break;
                
                
            case MyPageCellSectionTwoGuardCard: {
                HHGuardCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGuardCardCell];
                cell.courseOneFourView.actionBlock = ^() {
                    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_course_guard_tapped attributes:nil];
                    HHGuardCardViewController *vc = [[HHGuardCardViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                };
                return cell;
            }
            case MyPageCellSectionTwoContract: {
                HHMyContractTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kContractCell];
                cell.myContractView.actionBlock = ^() {
                    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_contract_tapped attributes:nil];
                    if (!weakSelf.isLoggedIn) {
                        [weakSelf showLoginAlert];
                        return;
                    }
                    if ([self.currentStudent.purchasedServiceArray count]) {
                        if (!self.currentStudent.idCard) {
                            //pop up upload id
                            HHGenericTwoButtonsPopupView *view = [[HHGenericTwoButtonsPopupView alloc] initWithTitle:@"友情提醒" info:[weakSelf buildPopupInfoTextWithString:@"快去上传资料签署专属学员协议吧!"] leftButtonTitle:@"取消" rightButtonTitle:@"去上传"];
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
                            
                        } else if (!self.currentStudent.agreementURL || [self.currentStudent.agreementURL isEqualToString:@""]) {
                            //pop up sign contract
                            HHGenericTwoButtonsPopupView *view = [[HHGenericTwoButtonsPopupView alloc] initWithTitle:@"友情提醒" info:[weakSelf buildPopupInfoTextWithString:@"快去签署专属学员协议吧!"] leftButtonTitle:@"取消" rightButtonTitle:@"去签署"];
                            view.confirmBlock = ^() {
                                [HHPopupUtility dismissPopup:weakSelf.popup];
                                HHSignContractViewController *vc = [[HHSignContractViewController alloc] initWithURL:nil];
                                UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
                                [weakSelf presentViewController:navVC animated:YES completion:nil];
                            };
                            view.cancelBlock = ^() {
                                [HHPopupUtility dismissPopup:weakSelf.popup];
                            };
                            weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
                            [HHPopupUtility showPopup:weakSelf.popup];
                            
                        } else {
                            HHContractViewController *vc = [[HHContractViewController alloc] init];
                            vc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        
                        
                    } else {
                        HHGenericTwoButtonsPopupView *view = [[HHGenericTwoButtonsPopupView alloc] initWithTitle:@"友情提醒" info:[weakSelf buildPopupInfoTextWithString:@"您还没有报名哟~\n快去选选心仪的教练报名学车吧~"] leftButtonTitle:@"取消" rightButtonTitle:@"去逛逛"];
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
                
            case MyPageCellSectionTwoCourseSchedule: {
                HHMyPageMyCourseScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyCourseScheduleCell];
                cell.myCourseView.actionBlock = ^() {
                    if (!weakSelf.isLoggedIn) {
                        [weakSelf showLoginAlert];
                        return;
                    }
                    HHBookTrainingViewController *vc = [[HHBookTrainingViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_my_course_tapped attributes:nil];
                };
                
                return cell;
                
            } break;
                
            case MyPageCellSectionTwoSupport: {
                HHMyPageSupportCell *cell = [tableView dequeueReusableCellWithIdentifier:kSupportCell];
                cell.supportOnlineView.actionBlock = ^() {
                    [weakSelf.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:weakSelf.navigationController] animated:YES];
                    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_online_support_tapped attributes:nil];
                };
                cell.myAdvisorView.actionBlock = ^() {
                    if (!weakSelf.isLoggedIn) {
                        HHWebViewController *vc = [[HHWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://m.hahaxueche.com/share/zhaoguwen"]];
                        vc.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    } else {
                        HHAdvisorView *view = [[HHAdvisorView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 20.0f, 240.0f) advisor:self.advisor];
                        view.callBlock = ^() {
                            [weakSelf callAdvisor];
                            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_my_advisor_tapped attributes:nil];
                        };
                        weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
                        [HHPopupUtility showPopup:weakSelf.popup];
                        
                    }
                };
                return cell;
            } break;
                
            case MyPageCellSectionTwoHelp: {
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
                
            case MyPageCellSectionTwoLogout: {
                HHMyPageLogoutCell *cell = [tableView dequeueReusableCellWithIdentifier:kLogoutCell];
                if (!self.isLoggedIn) {
                    [cell.button addTarget:self action:@selector(jumpToIntroVC) forControlEvents:UIControlEventTouchUpInside];
                    [cell.button setTitle:@"注册/登录" forState:UIControlStateNormal];
                    [cell.button setTitleColor:[UIColor HHConfirmGreen] forState:UIControlStateNormal];
                } else {
                    [cell.button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
                    [cell.button setTitle:@"退出账号" forState:UIControlStateNormal];
                    [cell.button setTitleColor:[UIColor HHCancelRed] forState:UIControlStateNormal];
                }
                return cell;
                
            } break;
                
            default: {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                return cell;
            } break;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 280.0f;
    } else {
        switch (indexPath.row) {
                
            case MyPageCellSectionTwoCoach:
                return kTitleViewHeight + kItemViewHeight * 2.0f;
                
            case MyPageCellSectionTwoGuardCard:
                return kTopPadding + kTitleViewHeight + kItemViewHeight;
                
            case MyPageCellSectionTwoVoucher:
                return kTopPadding + kTitleViewHeight + kItemViewHeight;
                
            case MyPageCellSectionTwoContract:
                return kTopPadding + kTitleViewHeight + kItemViewHeight;
                
            case MyPageCellSectionTwoCourseSchedule:
                return kTopPadding + kTitleViewHeight + kItemViewHeight;
                
            case MyPageCellSectionTwoSupport:
                return kTopPadding + kTitleViewHeight + kItemViewHeight * 2.0f;
                
            case MyPageCellSectionTwoHelp:
                return kTopPadding + kTitleViewHeight + kItemViewHeight * 3.0f;
                
            case MyPageCellSectionTwoLogout:
                return 50 + kTopPadding * 2.0f;
                
            default:
                return 50;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 60.0f;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return [self buildReferView];
    }
    return nil;
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
                [self jumpToIntroVC];
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
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:introVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)dismissPopup {
    [HHPopupUtility dismissPopup:self.popup];
}

- (void)saveName:(NSString *)newName {
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHStudentService sharedInstance] setupStudentInfoWithStudentId:[HHStudentStore sharedInstance].currentStudent.studentId userName:newName cityId:[HHStudentStore sharedInstance].currentStudent.cityId promotionCode:nil completion:^(HHStudent *student, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error) {
            self.currentStudent = student;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:MyPageCellSectionOneUserInfo inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:MyPageCellSectionOneUserInfo inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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


- (void)studentUpdated {
    [[HHStudentService sharedInstance] fetchStudentWithId:self.currentStudent.studentId completion:^(HHStudent *student, NSError *error) {
        if (!error) {
            self.currentStudent = student;
            [self.tableView reloadData];
        }
    }];
    
}

- (void)showLoginAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册/登录后查看更多板块" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去注册/登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self jumpToIntroVC];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UIView *)buildReferView {
    if (self.referView) {
        return self.referView;
    } else {
        self.referView = [self getReferView];
        return self.referView;
    }
    
}

- (UIView *)getReferView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor HHOrange];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.text = @"邀请好友平分¥400！邀请越多，奖励越多！";
    [view addSubview:label];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_xiaoha"]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imgView];
    
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.bottom);
        make.right.equalTo(view.right).offset(-15.0f);
    }];
    
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(view.left).offset(15.0f);
        make.right.equalTo(imgView.left).offset(-10.0f);
    }];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToReferVC)];
    [view addGestureRecognizer:tapRec];
    
    
    return view;
}

- (void)jumpToReferVC {
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_page_refer_tapped attributes:nil];
    HHReferFriendsViewController *vc = [[HHReferFriendsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
