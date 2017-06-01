//
//  HHCoachDetailViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachDetailViewController.h"
#import "UIColor+HHColor.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "ParallaxHeaderView.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHCoachDetailDescriptionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HHCoachDetailSectionTwoCell.h"
#import "HHCoachDetailBottomBarView.h"
#import "HHCoachDetailCommentsCell.h"
#import <KLCPopup.h>
#import "HHPopupUtility.h"
#import "HHShareView.h"
#import "HHSocialMediaShareUtility.h"
#import "HHFieldsMapViewController.h"
#import "HHConstantsStore.h"
#import "HHStudentService.h"
#import "HHStudentStore.h"
#import "HHIntroViewController.h"
#import "HHToastManager.h"
#import "HHFormatUtility.h"
#import "HHCoachService.h"
#import "HHReviews.h"
#import "HHReview.h"
#import "HHReviewListViewController.h"
#import "HHImageGalleryViewController.h"
#import "HHLoadingViewUtility.h"
#import "HHPurchaseConfirmViewController.h"
#import "HHCoachServiceTypeCell.h"
#import "HHCoachFieldCell.h"
#import <pop/POP.h>
#import "HHGenericTwoButtonsPopupView.h"
#import "HHWebViewController.h"
#import "HHFreeTrialUtility.h"
#import "HHCoachPriceDetailViewController.h"
#import "HHGenericOneButtonPopupView.h"
#import "HHPlatformGuardTableViewCell.h"
#import "HHGuardViewController.h"
#import "HHCoachPriceTableViewCell.h"
#import "HHPrepayViewController.h"
#import "HHSupportUtility.h"
#import "HHGenericPhoneView.h"
#import "HHSocialMediaShareUtility.h"
#import "HHDrivingSchoolDetailViewController.h"

typedef NS_ENUM(NSInteger, CoachCell) {
    CoachCellDescription,
    CoachCellPrice,
    CoachCellField,
    CoachCellPlatformGuard,
    CoachCellInfoTwo,
    CoachCellComments,
    CoachCellCount,
};

static NSString *const kDescriptionCellID = @"kDescriptionCellID";
static NSString *const kCoachPriceCellID = @"kCoachPriceCellID";
static NSString *const kTypeCellID = @"kTypeCellID";
static NSString *const kFiledCellID = @"kFiledCellID";
static NSString *const kInfoTwoCellID = @"kInfoTwoCellID";
static NSString *const kCommentsCellID = @"kCommentsCellID";
static NSString *const kGuardCellID = @"kGuardCellID";

static NSString *const kPlatformLink = @"https://m.hahaxueche.com/assurance";
static NSString *const kInsuranceLink = @"https://m.hahaxueche.com/pei-fu-bao";

static NSString *const kInsuranceText = @"赔付宝是一款由平安财险承保量身为哈哈学车定制的一份学车保险。提供了一站式驾考报名、选购保险、保险理赔申诉的平台，全面保障你的学车利益，赔付宝在购买后的次日生效，保期最长为一年";


@interface HHCoachDetailViewController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *coachImagesView;
@property (nonatomic, strong) HHCoach *coach;
@property (nonatomic, strong) NSString *coachId;
@property (nonatomic, strong) HHCoachDetailBottomBarView *bottomBar;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) HHReviews *reviewsObject;
@property (nonatomic, strong) NSArray *reviews;
@property (nonatomic) NSInteger selecteLicenseType;

@property (nonatomic) BOOL liking;
@property (nonatomic) BOOL followed;

@end

@implementation HHCoachDetailViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.coach = coach;
    }
    return self;
}

- (instancetype)initWithCoachId:(NSString *)coachId {
    self = [super init];
    if (self) {
        self.coachId = coachId;
        [[HHCoachService sharedInstance] fetchCoachWithId:self.coachId completion:^(HHCoach *coach, NSError *error) {
            if (!error) {
                self.coach = coach;
            }
        }];
    }
    return self;
}

- (void)setCoach:(HHCoach *)coach {
    _coach = coach;
    [[HHCoachService sharedInstance] fetchReviewsWithUserId:self.coach.userId completion:^(HHReviews *reviews, NSError *error) {
        if (!error) {
            self.reviewsObject = reviews;
            self.reviews = reviews.reviews;
            self.coachImagesView.imageURLStringsGroup = coach.images;
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"教练详情";
    self.selecteLicenseType = 1;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"icon_share"] action:@selector(shareCoach) target:self];
    [self initSubviews];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *coachId = self.coach.coachId;
    if (!coachId) {
        coachId = self.coachId;
    }
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_viewed attributes:@{@"coach_id":coachId}];
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-50.0f - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.coachImagesView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) * 3.0f/5.0f)];
    self.coachImagesView.delegate = self;
    self.coachImagesView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.coachImagesView.imageURLStringsGroup = self.coach.images;
    self.coachImagesView.pageDotColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    self.coachImagesView.currentPageDotColor = [UIColor whiteColor];
    self.coachImagesView.autoScroll = NO;
    
    [self.tableView registerClass:[HHCoachDetailDescriptionCell class] forCellReuseIdentifier:kDescriptionCellID];
    [self.tableView registerClass:[HHCoachPriceTableViewCell class] forCellReuseIdentifier:kCoachPriceCellID];
    [self.tableView registerClass:[HHCoachServiceTypeCell class] forCellReuseIdentifier:kTypeCellID];
    [self.tableView registerClass:[HHCoachFieldCell class] forCellReuseIdentifier:kFiledCellID];
    [self.tableView registerClass:[HHCoachDetailSectionTwoCell class] forCellReuseIdentifier:kInfoTwoCellID];
    [self.tableView registerClass:[HHCoachDetailCommentsCell class] forCellReuseIdentifier:kCommentsCellID];
    [self.tableView registerClass:[HHPlatformGuardTableViewCell class] forCellReuseIdentifier:kGuardCellID];
    
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithSubView:self.coachImagesView];
    [self.tableView setTableHeaderView:headerView];
    [self.tableView sendSubviewToBack:self.tableView.tableHeaderView];

    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.bottomBar = [[HHCoachDetailBottomBarView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.tableView.bounds), CGRectGetWidth(self.view.bounds), 50.0f)];
    [self.view addSubview:self.bottomBar];
    
    
    __weak HHCoachDetailViewController *weakSelf = self;    
    self.bottomBar.tryCoachAction = ^(){
        HHGenericPhoneView *view = [[HHGenericPhoneView alloc] initWithTitle:@"看过训练场才放心" placeHolder:@"输入手机号, 教练立即带你看训练场" buttonTitle:@"预约看场地"];
        view.buttonAction = ^(NSString *number) {
            [[HHStudentService sharedInstance] getPhoneNumber:number coachId:weakSelf.coach.coachId schoolId:[weakSelf.coach getCoachDrivingSchool].schoolId fieldId:[weakSelf.coach getCoachField].fieldId eventType:nil eventData:nil completion:^(NSError *error) {
                if (error) {
                    [[HHToastManager sharedManager] showErrorToastWithText:@"提交失败, 请重试"];
                } else {
                    [HHPopupUtility dismissPopup:weakSelf.popup];
                }
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_free_trial_confirmed attributes:@{@"coach_id":weakSelf.coach.coachId}];

            }];
        };
        weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
        [HHPopupUtility showPopup:weakSelf.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutAboveCenter)];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_free_trial_tapped attributes:@{@"coach_id":weakSelf.coach.coachId}];
    };
    
    self.bottomBar.supportAction = ^(){
       [weakSelf.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:weakSelf.navigationController] animated:YES];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_online_support_tapped attributes:nil];
    };
    
    self.bottomBar.smsAction = ^{
       [[HHSocialMediaShareUtility sharedInstance] showSMS:[NSString stringWithFormat:@"%@教练, 我在哈哈学车看到您的招生信息, 我想详细了解一下.", weakSelf.coach.name] receiver:@[weakSelf.coach.consultPhone] attachment:nil inVC:weakSelf];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_text_tapped attributes:nil];
    };
    
    self.bottomBar.callAction = ^{
        [[HHSupportUtility sharedManager] callSupportWithNumber:weakSelf.coach.consultPhone];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_phone_support_tapped attributes:nil];
    };
    
    [[HHCoachService sharedInstance] checkFollowedCoach:self.coach.userId completion:^(BOOL followed) {
        weakSelf.followed = followed;
    }];
    
}

- (void)setFollowed:(BOOL)followed {
    _followed = followed;
    [self.tableView reloadData];
}

#pragma mark - TableView Delegate & Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CoachCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak HHCoachDetailViewController *weakSelf = self;
    switch (indexPath.row) {
        case CoachCellDescription: {
            HHCoachDetailDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:kDescriptionCellID forIndexPath:indexPath];
            cell.likeBlock = ^(UIButton *likeButton, UILabel *likeCountLabel) {
                if ([[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
                    [weakSelf likeOrUnlikeCoachWithButton:likeButton label:likeCountLabel];
                } else {
                    [weakSelf showIntroPopup];
                }

            };
            cell.followBlock = ^() {
                [weakSelf followUnfollowCoach];
            };
            
            cell.drivingSchoolBlock = ^(HHDrivingSchool *school) {
                HHDrivingSchoolDetailViewController *vc = [[HHDrivingSchoolDetailViewController alloc] initWithSchool:school];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            [cell setupCellWithCoach:self.coach followed:weakSelf.followed];
            return cell;
        }
            
        case CoachCellPrice: {
            HHCoachPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCoachPriceCellID forIndexPath:indexPath];
            cell.questionMarkBlock = ^(NSInteger type) {
                NSString *text = @"C1为手动挡小型车驾照，取得了C1类驾驶证的人可以驾驶C2类车。";
                CGFloat height = 200.0f;
                NSString *title = @"什么是C1手动挡?";
                if (type == 2) {
                    height = 250.0f;
                    title = @"什么是C2自动挡?";
                    text = @"C2为自动挡小型车驾照，取得了C2类驾驶证的人不可以驾驶C1类车。C2驾照培训费要稍贵于C1照。费用的差别主要是由于C2自动挡教练车数量比较少，使用过程中维修费用比较高所致。";
                };
                
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.lineSpacing = 3.0f;
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:style}];
                HHGenericOneButtonPopupView *view = [[HHGenericOneButtonPopupView alloc] initWithTitle:title info:attString];
                view.cancelBlock = ^() {
                    [HHPopupUtility dismissPopup:weakSelf.popup];
                };
                weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
                [HHPopupUtility showPopup:weakSelf.popup];

            };
            
            cell.selectedBlock = ^(NSInteger type) {
                weakSelf.selecteLicenseType = type;
                [weakSelf.tableView reloadData];
            };
            
            cell.purchaseBlock = ^(CoachProductType type) {
                HHPurchaseConfirmViewController *vc = [[HHPurchaseConfirmViewController alloc] initWithCoach:weakSelf.coach selectedType:type];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_purchase_tapped attributes:nil];

            };
            
            cell.depositBlock = ^{
                [weakSelf deposit];
            };
            
            cell.priceDetailBlock = ^(CoachProductType type) {
                HHCoachPriceDetailViewController *vc = [[HHCoachPriceDetailViewController alloc] initWithCoach:weakSelf.coach productType:type];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_price_detail_tapped attributes:nil];
            };
            [cell setupCellWithCoach:self.coach selectedType:self.selecteLicenseType];
            return cell;
        }
            
        case CoachCellField: {
            HHCoachFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:kFiledCellID forIndexPath:indexPath];
            cell.fieldBlock = ^() {
                HHFieldsMapViewController *vc = [[HHFieldsMapViewController alloc] initWithFields:[HHConstantsStore sharedInstance].fields selectedField:[weakSelf.coach getCoachField]];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_field_tapped attributes:@{@"coach_id":weakSelf.coach.coachId}];

            };
            [cell setupCellWithField:[self.coach getCoachField]];
            return cell;
        }
            
        case CoachCellPlatformGuard: {
            HHPlatformGuardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGuardCellID forIndexPath:indexPath];
            cell.actionBlock = ^() {
                HHGuardViewController *vc =  [[HHGuardViewController alloc] initWithCoach:weakSelf.coach];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            };
            [cell setupCellWithCoach:self.coach];
            return cell;
        }
            
        case CoachCellInfoTwo: {
            HHCoachDetailSectionTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoTwoCellID forIndexPath:indexPath];
            [cell setupWithCoach:self.coach];
            cell.coachesListCell.peerCoachTappedAction = ^(NSInteger index) {
                HHCoach *coach = self.coach.peerCoaches[index];
                HHCoachDetailViewController *detailVC = [[HHCoachDetailViewController alloc] initWithCoachId:coach.coachId];
                detailVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:detailVC animated:YES];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_co_coach_tapped attributes:nil];
            };
            return cell;
        }
            
        case CoachCellComments: {
            HHCoachDetailCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentsCellID forIndexPath:indexPath];
            [cell setupCellWithCoach:self.coach reviews:self.reviews];
            cell.tapBlock = ^() {
                HHReviewListViewController *vc = [[HHReviewListViewController alloc] initWithReviews:weakSelf.reviewsObject coach:weakSelf.coach];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_comment_tapped attributes:@{@"coach_id":weakSelf.coach.coachId}];
            };
            return cell;
        }
            
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case CoachCellDescription: {
            return CGRectGetHeight([self getDescriptionTextSizeWithText:self.coach.bio]) + 75.0f;
        }
            
        case CoachCellPrice: {
            CGFloat height = 136.0f;
            if (self.selecteLicenseType == 1) {
                if ([self.coach.price floatValue] > 0) {
                    height = height + 85.0f * 2;
                }
                
                if ([self.coach.VIPPrice floatValue] > 0) {
                    height = height + 85.0f;
                }
                
                if ([self.coach.isCheyouWuyou boolValue]) {
                    return  136.0f + 85.0f;
                }
            } else {
                if ([self.coach.c2Price floatValue] > 0) {
                    height = height + 85.0f * 2;
                }
                
                if ([self.coach.c2VIPPrice floatValue] > 0) {
                    height = height + 85.0f;
                }
            }
            return height;
        }
            
        case CoachCellField: {
            return 126.0f;
        }
            
        case CoachCellPlatformGuard: {
            return 141.0f;
        }
            
            
        case CoachCellInfoTwo: {
            CGFloat height = 195.0f;
            if ([self.coach.peerCoaches count]) {
                height = height + 70.0f * self.coach.peerCoaches.count + 36.0f;
            }
            return height ;
        }
            
        case CoachCellComments: {
            CGFloat height = 130.0f;
            if (self.reviews.count >= 3) {
                return height + 90 * 3;
            } else if (self.reviews.count < 3 && self.reviews.count > 0){
                return height + 90 * self.reviews.count;
            } else {
                return height;
            }
        }
            
        default: {
            return 0;
        }
    }
    
}

#pragma mark SDCycleScrollViewDelegate Method

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    HHImageGalleryViewController *galleryVC = [[HHImageGalleryViewController alloc] initWithURLs:self.coach.images currentIndex:index];
    [self presentViewController:galleryVC animated:YES completion:nil];
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:self.tableView.contentOffset];
    }
}

#pragma mark - Button Actions

- (void)popupVC {
    if ([self.navigationController.viewControllers count] == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }

}


#pragma mark - Others 

- (CGRect)getDescriptionTextSizeWithText:(NSString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-40.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                     context:nil];
    return rect;
}

- (void)showLoginSignupAlertView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请先登陆或者注册" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"现在就去" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        HHIntroViewController *introVC = [[HHIntroViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:introVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)showIntroPopup {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 8.0f;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"您只有注册登录后\n才可以点赞教练哦~" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
    HHGenericTwoButtonsPopupView *view = [[HHGenericTwoButtonsPopupView alloc] initWithTitle:@"请登录" info:attributedString leftButtonTitle:@"知道了" rightButtonTitle:@"去登录"];
    self.popup = [HHPopupUtility createPopupWithContentView:view];
    view.confirmBlock = ^() {
        HHIntroViewController *vc = [[HHIntroViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    };
    view.cancelBlock = ^() {
        [HHPopupUtility dismissPopup:self.popup];
    };
    [HHPopupUtility showPopup:self.popup];
}


- (void)likeOrUnlikeCoachWithButton:(UIButton *)button label:(UILabel *)label {
    if (self.liking) {
        return;
    }
    self.liking = YES;
    NSNumber *like;
    if ([self.coach.liked boolValue]) {
        like = @(0);
    } else {
        like = @(1);
    }
    
    [[HHStudentService sharedInstance] likeOrUnlikeCoachWithId:self.coach.coachId like:like completion:^(HHCoach *coach, NSError *error) {
        self.liking = NO;
        if (!error) {
            self.coach = coach;
            if (self.coachUpdateBlock) {
                self.coachUpdateBlock(self.coach);
            }
            if ([coach.liked boolValue]) {
                POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
                sprintAnimation.animationDidStartBlock = ^(POPAnimation *anim) {
                    [button setImage:[UIImage imageNamed:@"ic_list_best_click"] forState:UIControlStateNormal];
                };
                sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(10, 10)];
                sprintAnimation.springBounciness = 20.f;
                [button pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
            } else {
                [button setImage:[UIImage imageNamed:@"ic_list_best_unclick"] forState:UIControlStateNormal];
            }
            label.text = [coach.likeCount stringValue];
           
        }
    }];
    
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_like_unlike_tapped attributes:@{@"coach_id":self.coach.coachId, @"like":like}];
    
}

- (void)openWebPage:(NSURL *)url {
    HHWebViewController *webVC = [[HHWebViewController alloc] initWithURL:url];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    
}

- (void)shareCoach {
    __weak HHCoachDetailViewController *weakSelf = self;
    HHShareView *shareView = [[HHShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0)];
    
    shareView.dismissBlock = ^() {
        [HHPopupUtility dismissPopup:self.popup];
    };
    shareView.actionBlock = ^(SocialMedia selecteItem) {
        if (selecteItem == SocialMediaMessage) {
            [HHPopupUtility dismissPopup:weakSelf.popup];
        }
        [[HHSocialMediaShareUtility sharedInstance] shareCoach:self.coach shareType:selecteItem inVC:weakSelf resultCompletion:^(BOOL succceed) {
            if (succceed) {
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_share_coach_succeed attributes:@{@"coach_id":self.coach.coachId, @"channel": [[HHSocialMediaShareUtility sharedInstance] getChannelNameWithType:selecteItem]}];
            }
        }];
        
    };
    self.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_share_coach_tapped attributes:@{@"coach_id":self.coach.coachId}];
}

- (void)followUnfollowCoach {
    if (self.followed) {
        if (![[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
            [self showLoginPopupForFollow];
            return ;
        }
        [[HHCoachService sharedInstance] unfollowCoach:self.coach.userId completion:^(NSError *error) {
            if (!error) {
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_follow_unfollow_tapped attributes:@{@"coach_id":self.coach.coachId, @"follow":@(!self.followed)}];
                self.followed = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kUnfollowCoach" object:@{@"coachId":self.coach.coachId}];
            }
        }];
        
    } else {
        if (![[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
            [self showLoginPopupForFollow];
            return ;
        }
    
        [[HHCoachService sharedInstance] followCoach:self.coach.userId completion:^(NSError *error) {
            if (!error) {
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_follow_unfollow_tapped attributes:@{@"coach_id":self.coach.coachId, @"follow":@(!self.followed)}];
                self.followed = YES;
            }
            
        }];

    }
}

- (void)showLoginPopupForFollow {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 8.0f;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"注册登录后, 才可以关注教练哦~\n注册获得更多教练咨询!~" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
    HHGenericTwoButtonsPopupView *view = [[HHGenericTwoButtonsPopupView alloc] initWithTitle:@"请登录" info:attributedString leftButtonTitle:@"知道了" rightButtonTitle:@"去登录"];
    self.popup = [HHPopupUtility createPopupWithContentView:view];
    view.confirmBlock = ^() {
        HHIntroViewController *vc = [[HHIntroViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    };
    view.cancelBlock = ^() {
        [HHPopupUtility dismissPopup:self.popup];
    };
    [HHPopupUtility showPopup:self.popup];
}

- (void)deposit {
    HHPrepayViewController *vc = [[HHPrepayViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:coach_detail_page_deposit_tapped attributes:nil];
}

@end
