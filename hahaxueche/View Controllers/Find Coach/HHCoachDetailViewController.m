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
#import "HHCoachDetailSectionOneCell.h"
#import "HHCoachDetailSectionTwoCell.h"
#import "HHCoachDetailBottomBarView.h"
#import "HHCoachDetailCommentsCell.h"
#import <KLCPopup.h>
#import "HHTryCoachView.h"
#import "HHPopupUtility.h"
#import "HHShareView.h"
#import "HHPriceDetailView.h"
#import "HHSocialMediaShareUtility.h"
#import "HHSingleFieldMapViewController.h"
#import "HHConstantsStore.h"
#import "HHStudentService.h"
#import "HHStudentStore.h"
#import "HHIntroViewController.h"
#import "HHPaymentService.h"
#import "HHToastManager.h"
#import "HHFormatUtility.h"
#import "HHCoachService.h"
#import "HHReviews.h"
#import "HHReview.h"
#import "HHReviewListViewController.h"
#import "HHEventTrackingManager.h"
#import "HHImageGalleryViewController.h"
#import "HHLoadingViewUtility.h"

typedef NS_ENUM(NSInteger, CoachCell) {
    CoachCellDescription,
    CoachCellInfoOne,
    CoachCellInfoTwo,
    CoachCellComments,
    CoachCellCount,
};

static NSString *const kDescriptionCellID = @"kDescriptionCellID";
static NSString *const kInfoOneCellID = @"kInfoOneCellId";
static NSString *const kInfoTwoCellID = @"kInfoTwoCellID";
static NSString *const kCommentsCellID = @"kCommentsCellID";

@interface HHCoachDetailViewController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *coachImagesView;
@property (nonatomic, strong) HHCoach *coach;
@property (nonatomic, strong) NSString *coachId;
@property (nonatomic, strong) HHCoachDetailBottomBarView *bottomBar;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) HHStudent *currentStudent;
@property (nonatomic, strong) HHReviews *reviewsObject;
@property (nonatomic, strong) NSArray *reviews;

@end

@implementation HHCoachDetailViewController

- (instancetype)initWithCoach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.coach = coach;
        self.currentStudent = [HHStudentStore sharedInstance].currentStudent;
    }
    return self;
}

- (instancetype)initWithCoachId:(NSString *)coachId {
    self = [super init];
    if (self) {
        self.coachId = coachId;
        self.currentStudent = [HHStudentStore sharedInstance].currentStudent;
        [[HHCoachService sharedInstance] fetchCoachWithId:self.coachId completion:^(HHCoach *coach, NSError *error) {
            if (!error) {
                self.coach = coach;
                [self.tableView reloadData];
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
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"教练详情";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
    [self initSubviews];
    
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-50.0f - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.coachImagesView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200.0f)];
    self.coachImagesView.delegate = self;
    self.coachImagesView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.coachImagesView.imageURLStringsGroup = self.coach.images;
    self.coachImagesView.autoScroll = NO;
    
    [self.tableView registerClass:[HHCoachDetailDescriptionCell class] forCellReuseIdentifier:kDescriptionCellID];
    [self.tableView registerClass:[HHCoachDetailSectionOneCell class] forCellReuseIdentifier:kInfoOneCellID];
    [self.tableView registerClass:[HHCoachDetailSectionTwoCell class] forCellReuseIdentifier:kInfoTwoCellID];
    [self.tableView registerClass:[HHCoachDetailCommentsCell class] forCellReuseIdentifier:kCommentsCellID];
    
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithSubView:self.coachImagesView];
    [self.tableView setTableHeaderView:headerView];
    [self.tableView sendSubviewToBack:self.tableView.tableHeaderView];

    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.bottomBar = [[HHCoachDetailBottomBarView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.tableView.bounds), CGRectGetWidth(self.view.bounds), 50.0f) followed:NO];
    [self.view addSubview:self.bottomBar];
    
    
    __weak HHCoachDetailViewController *weakSelf = self;
    self.bottomBar.shareAction = ^(){
        HHShareView *shareView = [[HHShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds), 0)];
        shareView.dismissBlock = ^() {
            [HHPopupUtility dismissPopup:weakSelf.popup];
        };
        shareView.actionBlock = ^(SocialMedia selecteItem) {
            switch (selecteItem) {
                case SocialMediaQQFriend: {
                    [HHSocialMediaShareUtility shareToQQFriendsWithSuccess:nil Fail:nil];
                } break;
                    
                case SocialMediaQQZone: {
                    [HHSocialMediaShareUtility shareToQQZoneWithSuccess:nil Fail:nil];
                } break;
                    
                case SocialMediaWeChatFriend: {
                    [HHSocialMediaShareUtility shareToWeixinSessionWithSuccess:nil Fail:nil];
                } break;
                    
                case SocialMediaWeChaPYQ: {
                    [HHSocialMediaShareUtility shareToWeixinTimelineWithSuccess:nil Fail:nil];
                } break;
                    
                default:
                    break;
            }
        };
        weakSelf.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
        [HHPopupUtility showPopup:weakSelf.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
    };
    
    self.bottomBar.followAction = ^(){
        if (!weakSelf.currentStudent.studentId) {
            [weakSelf showLoginSignupAlertView];
            return ;
        }
        
        [[HHCoachService sharedInstance] followCoach:weakSelf.coach.userId completion:^(NSError *error) {
            if (!error) {
                weakSelf.bottomBar.followed = YES;
            }
            
        }];
    };
    
    self.bottomBar.unFollowAction = ^(){
        if (!weakSelf.currentStudent.studentId) {
            [weakSelf showLoginSignupAlertView];
            return ;
        }
        
        [[HHCoachService sharedInstance] unfollowCoach:weakSelf.coach.userId completion:^(NSError *error) {
            if (!error) {
                weakSelf.bottomBar.followed = NO;
            }
        }];
    };
    
    self.bottomBar.tryCoachAction = ^(){
        HHTryCoachView *tryCoachView = [[HHTryCoachView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 20.0f, 420.0f)];
        tryCoachView.cancelBlock = ^(){
            [HHPopupUtility dismissPopup:weakSelf.popup];
        };
        tryCoachView.confirmBlock = ^(NSString *name, NSString *number, NSDate *firstDate, NSDate *secDate) {
            [[HHCoachService sharedInstance] tryCoachWithId:weakSelf.coach.coachId
                                                         name:name
                                                       number:number
                                                    firstDate:[[HHFormatUtility fullDateFormatter] stringFromDate:firstDate]
                                                   secondDate:[[HHFormatUtility fullDateFormatter] stringFromDate:secDate]
                                                   completion:^(NSError *error) {
                if (!error) {
                    [[HHEventTrackingManager sharedManager] sendEventWithId:kDidTryCoachEventId attributes:@{@"student_id":weakSelf.currentStudent.studentId, @"coach_id":weakSelf.coach.coachId}];
                    [[HHToastManager sharedManager] showSuccessToastWithText:@"免费试学预约成功！教练会尽快联系您！"];
                    [HHPopupUtility dismissPopup:weakSelf.popup];
                } else {
                     [[HHToastManager sharedManager] showErrorToastWithText:@"预约失败，请重试！"];
                }
            }];
        };
        weakSelf.popup = [HHPopupUtility createPopupWithContentView:tryCoachView];
        [HHPopupUtility showPopup:weakSelf.popup];
    };
    
    self.bottomBar.purchaseCoachAction = ^(){
        if (!weakSelf.currentStudent.studentId) {
            [weakSelf showLoginSignupAlertView];
            return ;
        }
        
        [[HHCoachService sharedInstance] unfollowCoach:weakSelf.coach.userId completion:nil];
        
        HHCity *city = [[HHConstantsStore sharedInstance] getAuthedUserCity];
        CGFloat height = 190.0f + (city.cityFixedFees.count + 1) * 50.0f;
        HHPriceDetailView *priceView = [[HHPriceDetailView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds)-20.0f, height) title:@"付款明细" totalPrice:weakSelf.coach.price showOKButton:NO];
        
        priceView.cancelBlock = ^() {
            [HHPopupUtility dismissPopup:weakSelf.popup];
        };
        
        priceView.confirmBlock = ^(){
            [HHPopupUtility dismissPopup:weakSelf.popup];
            [[HHPaymentService sharedInstance] payWithCoachId:weakSelf.coach.coachId studentId:weakSelf.currentStudent.studentId inController:weakSelf completion:^(BOOL succeed) {
                if (succeed) {
                    [weakSelf fetchStudentAfterPurchase];
                    [[HHEventTrackingManager sharedManager] sendEventWithId:kDidPurchaseCoachServiceEventId attributes:@{@"student_id":weakSelf.currentStudent.studentId, @"coach_id":weakSelf.coach.coachId}];
                } else {
                    [[HHToastManager sharedManager] showErrorToastWithText:@"抱歉，支付失败或者您取消了支付。请重试！"];
                }
            }];
            
        };
        weakSelf.popup = [HHPopupUtility createPopupWithContentView:priceView];
        [HHPopupUtility showPopup:weakSelf.popup];

    };
    
    [[HHCoachService sharedInstance] checkFollowedCoach:self.coach.userId completion:^(BOOL followed) {
        weakSelf.bottomBar.followed = followed;
    }];
    
}

- (void)fetchStudentAfterPurchase {
    if (![[HHLoadingViewUtility sharedInstance] isVisible]) {
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
    }
    [[HHStudentService sharedInstance] fetchStudentWithId:[HHStudentStore sharedInstance].currentStudent.studentId completion:^(HHStudent *student, NSError *error) {
        if ([student.purchasedServiceArray count]) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            [[HHToastManager sharedManager] showSuccessToastWithText:@"支付成功! 请到我的页面查看具体信息."];
            [HHStudentStore sharedInstance].currentStudent = student;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"coachPurchased" object:nil];
        } else {
            [self fetchStudentAfterPurchase];
        }
        
    }];
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
            [cell setupCellWithCoach:self.coach];
            return cell;
        }
            
        case CoachCellInfoOne: {
            HHCoachDetailSectionOneCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoOneCellID forIndexPath:indexPath];
            cell.priceCellAction = ^() {
                HHCity *city = [[HHConstantsStore sharedInstance] getAuthedUserCity];
                CGFloat height = 190.0f + (city.cityFixedFees.count + 1) * 50.0f;
                HHPriceDetailView *priceView = [[HHPriceDetailView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds)-20.0f, height) title:@"价格明细" totalPrice:weakSelf.coach.price showOKButton:YES];
                priceView.cancelBlock = ^() {
                    [HHPopupUtility dismissPopup:weakSelf.popup];
                };
                weakSelf.popup = [HHPopupUtility createPopupWithContentView:priceView];
                [HHPopupUtility showPopup:weakSelf.popup];

            };
            cell.addressCellAction = ^() {
                HHSingleFieldMapViewController *vc = [[HHSingleFieldMapViewController alloc] initWithField:[[HHConstantsStore sharedInstance] getFieldWithId:self.coach.fieldId]];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            [cell setupWithCoach:self.coach field:[[HHConstantsStore sharedInstance] getFieldWithId:self.coach.fieldId]];
            return cell;
        }
            
        case CoachCellInfoTwo: {
            HHCoachDetailSectionTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoTwoCellID forIndexPath:indexPath];
            [cell setupWithCoach:self.coach];
            cell.coachesListCell.peerCoachTappedAction = ^(NSInteger index) {
                HHCoach *coach = self.coach.peerCoaches[index];
                HHCoachDetailViewController *detailVC = [[HHCoachDetailViewController alloc] initWithCoachId:coach.coachId];
                [weakSelf.navigationController pushViewController:detailVC animated:YES];
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
            return CGRectGetHeight([self getDescriptionTextSizeWithText:self.coach.bio]) + 50.0f;
        }
            
        case CoachCellInfoOne: {
            return 195.0f;
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
    [self.navigationController popViewControllerAnimated:YES];
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


@end
