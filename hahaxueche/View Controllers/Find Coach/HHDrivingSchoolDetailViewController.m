//
//  HHDrivingSchoolDetailViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 04/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHDrivingSchoolDetailViewController.h"
#import "UIColor+HHColor.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "ParallaxHeaderView.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HHPopupUtility.h"
#import "HHShareView.h"
#import "HHSocialMediaShareUtility.h"
#import "HHConstantsStore.h"
#import "HHCoachDetailBottomBarView.h"
#import "HHGenericPhoneView.h"
#import "HHStudentService.h"
#import "HHToastManager.h"
#import "HHSupportUtility.h"
#import "HHImageGalleryViewController.h"
#import "HHSchoolBasicInfoTableViewCell.h"
#import "HHCoachService.h"
#import "HHLoadingViewUtility.h"
#import "HHFieldsMapViewController.h"
#import "HHGenericPhoneView.h"
#import "HHSchoolPriceTableViewCell.h"
#import "HHCoachPriceDetailViewController.h"
#import "HHSchoolGrouponTableViewCell.h"
#import "HHSchoolFieldTableViewCell.h"
#import "HHWebViewController.h"
#import "HHSchoolReviewTableViewCell.h"
#import "HHReviewListViewController.h"
#import "HHGetNumberTableViewCell.h"
#import "HHHotSchoolsTableViewCell.h"
#import "HHEventTrackingManager.h"

typedef NS_ENUM(NSInteger, SchoolCell) {
    SchoolCellBasic,
    SchoolCellPrice,
    SchoolCellField,
    SchoolCellGetNumber,
    SchoolCellReview,
    SchoolCellHotSchool,
    SchoolCellCount,
};

static NSString *const kBasicCellID = @"kBasicCellID";
static NSString *const kPriceCellID = @"kPriceCellID";
static NSString *const kGrouponCellID = @"kGrouponCellID";
static NSString *const kFieldCellId = @"kFieldCellId";
static NSString *const kReviewCellId = @"kReviewCellId";
static NSString *const kGetNumCellId = @"kGetNumCellId";
static NSString *const kHotSchoolCellId = @"kHotSchoolCellId";

@interface HHDrivingSchoolDetailViewController () <UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) HHDrivingSchool *school;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *schoolImagesView;
@property (nonatomic, strong) HHCoachDetailBottomBarView *bottomBar;
@property (nonatomic) BOOL desExpanded;

@property (nonatomic, strong) HHReviews *reviewsObject;

@end

@implementation HHDrivingSchoolDetailViewController

- (instancetype)initWithSchool:(HHDrivingSchool *)school {
    self = [super init];
    if (self) {
        self.school = school;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"驾校详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"icon_share"] action:@selector(shareSchool) target:self];
    
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[HHCoachService sharedInstance] fetchDrivingSchoolWithId:self.school.schoolId completion:^(HHDrivingSchool *school, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error) {
            self.school = school;
            [self initSubviews];
        }
    }];
    
    [[HHCoachService sharedInstance] fetchDrivingSchoolReviewsWithId:self.school.schoolId completion:^(HHReviews *reviews, NSError *error) {
        if (!error) {
            self.reviewsObject = reviews;
            [self.tableView reloadData];
        }
    }];
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-50.0f)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.schoolImagesView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) * 3.0f/5.0f)];
    self.schoolImagesView.delegate = self;
    self.schoolImagesView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.schoolImagesView.imageURLStringsGroup = self.school.images;
    self.schoolImagesView.pageDotColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    self.schoolImagesView.currentPageDotColor = [UIColor whiteColor];
    self.schoolImagesView.autoScroll = NO;
    
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithSubView:self.schoolImagesView];
    [self.tableView setTableHeaderView:headerView];
    [self.tableView sendSubviewToBack:self.tableView.tableHeaderView];
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerClass:[HHSchoolBasicInfoTableViewCell class] forCellReuseIdentifier:kBasicCellID];
    [self.tableView registerClass:[HHSchoolPriceTableViewCell class] forCellReuseIdentifier:kPriceCellID];
    [self.tableView registerClass:[HHSchoolGrouponTableViewCell class] forCellReuseIdentifier:kGrouponCellID];
    [self.tableView registerClass:[HHSchoolFieldTableViewCell class] forCellReuseIdentifier:kFieldCellId];
    [self.tableView registerClass:[HHSchoolReviewTableViewCell class] forCellReuseIdentifier:kReviewCellId];
    [self.tableView registerClass:[HHGetNumberTableViewCell class] forCellReuseIdentifier:kGetNumCellId];
    [self.tableView registerClass:[HHHotSchoolsTableViewCell class] forCellReuseIdentifier:kHotSchoolCellId];
    
    self.bottomBar = [[HHCoachDetailBottomBarView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.tableView.bounds), CGRectGetWidth(self.view.bounds), 50.0f)];
    [self.view addSubview:self.bottomBar];
    
    
    __weak HHDrivingSchoolDetailViewController *weakSelf = self;
    self.bottomBar.tryCoachAction = ^(){
        HHGenericPhoneView *view = [[HHGenericPhoneView alloc] initWithTitle:@"看过训练场才放心" placeHolder:@"输入手机号, 教练立即带你看训练场" buttonTitle:@"预约看场地"];
        view.buttonAction = ^(NSString *number) {
            [[HHStudentService sharedInstance] getPhoneNumber:number coachId:nil schoolId:weakSelf.school.schoolId fieldId:nil eventType:@(3) eventData:@{@"driving_school_id":weakSelf.school.schoolId} completion:^(NSError *error) {
                if (error) {
                    [[HHToastManager sharedManager] showErrorToastWithText:@"提交失败, 请重试"];
                } else {
                    [HHPopupUtility dismissPopup:weakSelf.popup];
                    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_bot_free_trial_confirmed attributes:nil];
                }
                
            }];
        };
        weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
        [HHPopupUtility showPopup:weakSelf.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutAboveCenter)];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_bot_free_trial_tapped attributes:nil];
    };
    
    self.bottomBar.supportAction = ^(){
        [weakSelf.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:weakSelf.navigationController] animated:YES];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_bot_online_support_tapped attributes:nil];
    };
    
    self.bottomBar.smsAction = ^{
        [[HHSocialMediaShareUtility sharedInstance] showSMS:[NSString stringWithFormat:@"%@, 我在哈哈学车看到您的招生信息, 我想详细了解一下.", weakSelf.school.schoolName] receiver:@[weakSelf.school.consultPhone] attachment:nil inVC:weakSelf];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_bot_SMS_tapped attributes:nil];
    };
    
    self.bottomBar.callAction = ^{
        [[HHSupportUtility sharedManager] callSupportWithNumber:weakSelf.school.consultPhone];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_bot_call_school_tapped attributes:nil];
    };

}

#pragma mark SDCycleScrollViewDelegate Method

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    HHImageGalleryViewController *galleryVC = [[HHImageGalleryViewController alloc] initWithURLs:self.school.images currentIndex:index];
    [self presentViewController:galleryVC animated:YES completion:nil];
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView]) {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:self.tableView.contentOffset];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return SchoolCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak HHDrivingSchoolDetailViewController *weakSelf = self;
    
    switch (indexPath.row) {
        case SchoolCellBasic: {
            HHSchoolBasicInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBasicCellID forIndexPath:indexPath];
            [cell setupCellWithSchool:self.school];
            cell.showMoreLessBlock = ^(BOOL expand) {
                weakSelf.desExpanded = expand;
                [weakSelf.tableView reloadData];
            };
            
            cell.fieldBlock = ^() {
                HHFieldsMapViewController *vc = [[HHFieldsMapViewController alloc] initWithFields:self.school.fields selectedField:nil];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_check_fields_tapped attributes:nil];
            };
            
            cell.priceNotifBlock = ^(){
                HHGenericPhoneView *view = [[HHGenericPhoneView alloc] initWithTitle:@"我们将为您保密个人信息!" placeHolder:@"填写手机号, 立即订阅降价通知" buttonTitle:@"立即订阅"];
                view.buttonAction = ^(NSString *number) {
                    [[HHStudentService sharedInstance] getPhoneNumber:number coachId:nil schoolId:weakSelf.school.schoolId fieldId:nil eventType:@(6) eventData:@{@"driving_school_id":weakSelf.school.schoolId} completion:^(NSError *error) {
                        if (error) {
                            [[HHToastManager sharedManager] showErrorToastWithText:@"提交失败, 请重试"];
                        } else {
                            [HHPopupUtility dismissPopup:weakSelf.popup];
                            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_price_notification_confirmed attributes:nil];
                        }
                    }];
                };
                weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
                [HHPopupUtility showPopup:weakSelf.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutAboveCenter)];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_price_notification_tapped attributes:nil];
            };
            return cell;
        } 
            
        case SchoolCellPrice: {
            HHSchoolPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPriceCellID forIndexPath:indexPath];
            cell.priceBlock = ^(NSInteger index) {
                HHCoach *coach = [[HHCoach alloc] init];
                coach.price = weakSelf.school.lowestPrice;
                coach.consultPhone = weakSelf.school.consultPhone;
                coach.VIPPrice = weakSelf.school.lowestVIPPrice;
            
                HHCoachPriceDetailViewController *vc = [[HHCoachPriceDetailViewController alloc] initWithCoach:coach productType:index rightButtonTitle:@"联系驾校"];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_price_detail_tapped attributes:nil];
            };
            cell.callBlock = ^{
                [[HHSupportUtility sharedManager] callSupportWithNumber:weakSelf.school.consultPhone];
            };
            
            cell.notifPriceBlock = ^{
                HHGenericPhoneView *view = [[HHGenericPhoneView alloc] initWithTitle:@"我们将为您保密个人信息!" placeHolder:@"填写手机号, 立即订阅降价通知" buttonTitle:@"立即订阅"];
                view.buttonAction = ^(NSString *number) {
                    [[HHStudentService sharedInstance] getPhoneNumber:number coachId:nil schoolId:weakSelf.school.schoolId fieldId:nil eventType:@(6) eventData:@{@"driving_school_id":weakSelf.school.schoolId} completion:^(NSError *error) {
                        if (error) {
                            [[HHToastManager sharedManager] showErrorToastWithText:@"提交失败, 请重试"];
                        } else {
                            [HHPopupUtility dismissPopup:weakSelf.popup];
                            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_price_notification_confirmed attributes:nil];
                        }
                    }];
                };
                weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
                [HHPopupUtility showPopup:weakSelf.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutAboveCenter)];
            };
            [cell setupCellWithSchool:self.school];
            return cell;
        }
          
        case SchoolCellField: {
            HHSchoolFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFieldCellId forIndexPath:indexPath];
            cell.fieldBlock = ^(HHField *field) {
                HHFieldsMapViewController *vc = [[HHFieldsMapViewController alloc] initWithFields:weakSelf.school.fields selectedField:field];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            cell.checkFieldBlock = ^(HHField *field) {
                HHGenericPhoneView *view = [[HHGenericPhoneView alloc] initWithTitle:@"看过训练场才放心" placeHolder:@"输入手机号, 教练立即带你看训练场" buttonTitle:@"预约看场地"];
                view.buttonAction = ^(NSString *number) {
                    [[HHStudentService sharedInstance] getPhoneNumber:number coachId:nil schoolId:weakSelf.school.schoolId fieldId:field.fieldId eventType:@(4) eventData:@{@"driving_school_id":weakSelf.school.schoolId, @"field_id":field.fieldId} completion:^(NSError *error) {
                        if (error) {
                            [[HHToastManager sharedManager] showErrorToastWithText:@"提交失败, 请重试"];
                        } else {
                            [HHPopupUtility dismissPopup:weakSelf.popup];
                            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_see_field_confirmed attributes:nil];
                        }
                        
                    }];
                };
                weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
                [HHPopupUtility showPopup:weakSelf.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutAboveCenter)];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_see_field_tapped attributes:nil];

            };
            
            cell.sendAddressBlock = ^(HHField *field) {
                HHGenericPhoneView *view = [[HHGenericPhoneView alloc] initWithTitle:@"轻松定位训练场" placeHolder:@"输入手机号, 立即接收详细地址" buttonTitle:@"发我定位"];
                view.buttonAction = ^(NSString *number) {
                    [[HHStudentService sharedInstance] getPhoneNumber:number coachId:nil schoolId:weakSelf.school.schoolId fieldId:field.fieldId eventType:@(5) eventData:@{@"driving_school_id":weakSelf.school.schoolId, @"field_id":field.fieldId} completion:^(NSError *error) {
                        if (error) {
                            [[HHToastManager sharedManager] showErrorToastWithText:@"提交失败, 请重试!"];
                        } else {
                            [HHPopupUtility dismissPopup:self.popup];
                            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:map_view_page_locate_confirmed attributes:nil];
                        }
                    }];
                };
                self.popup = [HHPopupUtility createPopupWithContentView:view];
                [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutAboveCenter)];
            };
            [cell setupCellWithSchool:self.school];
            return cell;
        }
            
        case SchoolCellReview: {
            HHSchoolReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReviewCellId forIndexPath:indexPath];
            cell.reviewsBlock = ^{
                HHReviewListViewController *vc = [[HHReviewListViewController alloc] initWithReviews:weakSelf.reviewsObject school:weakSelf.school];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_more_review_tapped attributes:nil];
            };
            [cell setupCellWithSchool:self.school reviews:self.reviewsObject];
            return cell;
        }
            
        case SchoolCellGetNumber: {
            HHGetNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGetNumCellId forIndexPath:indexPath];
            cell.confirmBlock = ^(NSString *phoneNum) {
                [[HHStudentService sharedInstance] getPhoneNumber:phoneNum coachId:nil schoolId:weakSelf.school.schoolId fieldId:nil eventType:@(7) eventData:@{@"driving_school_id":weakSelf.school.schoolId} completion:^(NSError *error) {
                    if (error) {
                        [[HHToastManager sharedManager] showErrorToastWithText:@"提交失败, 请重试"];
                    } else {
                        [HHPopupUtility dismissPopup:weakSelf.popup];
                        [[HHToastManager sharedManager] showSuccessToastWithText:@"提交成功! 工作人员会马上联系您!"];
                        [self.view endEditing:YES];
                        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_get_groupon_confirmed attributes:nil];
                    }
                    
                }];
            };
            cell.scrollBlock = ^{
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:SchoolCellGetNumber inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            };
            return cell;
        }
        case SchoolCellHotSchool: {
            HHHotSchoolsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHotSchoolCellId forIndexPath:indexPath];
            cell.schoolBlock = ^(NSInteger index) {
                HHDrivingSchool *school = [[HHConstantsStore sharedInstance] getDrivingSchools][index];
                HHDrivingSchoolDetailViewController *vc = [[HHDrivingSchoolDetailViewController alloc] initWithSchool:school];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:school_detail_hot_school_tapped attributes:@{@"index":@(index)}];
            };
            return cell;
        }
            
        default:
            break;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == SchoolCellBasic) {
        if (self.desExpanded) {
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.alignment = NSTextAlignmentNatural;
            paraStyle.lineSpacing = 7.0;
            
            CGRect rect = [self.school.bio boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-30.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paraStyle} context:nil];
            return (CGRectGetHeight(rect) + 180.0f + 60.0f);
        } else {
            return 280.0f;
        }
    } else if (indexPath.row == SchoolCellPrice) {
        if ([self.school.lowestVIPPrice floatValue] > 0) {
            return 60.0f + 2 * 85.0f;
        } else {
            return 60.0f + 1 * 85.0f;
        }
    } else if (indexPath.row == SchoolCellField) {
        NSInteger count = MIN(self.school.fields.count, 3);
        return 110.0f + count * 100.0f;
        
    } else if (indexPath.row == SchoolCellReview) {
        NSInteger count = MIN(self.reviewsObject.reviews.count, 3);
        return 110.0f + count * 90.0f;
    } else if (indexPath.row == SchoolCellGetNumber) {
        return 115.0f;
    } else {
        return 140.0f;
    }
    
}

- (void)popupVC {
    if ([self.navigationController.viewControllers count] == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)shareSchool {
    __weak HHDrivingSchoolDetailViewController *weakSelf = self;
    HHShareView *shareView = [[HHShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0)];
    
    shareView.dismissBlock = ^() {
        [HHPopupUtility dismissPopup:self.popup];
    };
    shareView.actionBlock = ^(SocialMedia selecteItem) {
        if (selecteItem == SocialMediaMessage) {
            [HHPopupUtility dismissPopup:weakSelf.popup];
        }
        [[HHSocialMediaShareUtility sharedInstance] shareSchool:self.school shareType:selecteItem inVC:weakSelf resultCompletion:^(BOOL succceed) {
            if (succceed) {
                //[[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_share_coach_succeed attributes:@{@"coach_id":self.coach.coachId, @"channel": [[HHSocialMediaShareUtility sharedInstance] getChannelNameWithType:selecteItem]}];
            }
        }];
        
    };
    self.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}


@end
