//
//  HHMyCoachDetailViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyCoachDetailViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "UIColor+HHColor.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "ParallaxHeaderView.h"
#import "HHCoachDetailDescriptionCell.h"
#import "HHMyCoachBasicInfoCell.h"
#import "HHMyPageCoachCell.h"
#import "HHMyCoachCourseInfoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Masonry.h"
#import "HHCoachService.h"
#import "HHLoadingViewUtility.h"
#import "HHSingleFieldMapViewController.h"
#import "HHConstantsStore.h"
#import "HHPopupUtility.h"
#import "HHImageGalleryViewController.h"
#import "HHShareView.h"
#import "HHPopupUtility.h"
#import "HHSocialMediaShareUtility.h"
#import <pop/POP.h>
#import "HHStudentService.h"
#import "HHCoachPriceDetailViewController.h"
#import "HHStudentStore.h"
#import "HHMyCoachPeerCoachesTableViewCell.h"
#import "HHCoachDetailViewController.h"

static NSString *const kDescriptionCellID = @"kDescriptionCellID";
static NSString *const kBasicInfoCellID = @"kBasicInfoCellID";
static NSString *const kCourseInfoCellID = @"kCourseInfoCellID";
static NSString *const kPartnerCoachoCellID = @"kPartnerCoachoCellID";

@interface HHMyCoachDetailViewController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) HHCoach *coach;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *coachImagesView;
@property (nonatomic, strong) UIButton *reviewCoachButton;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic) BOOL liking;
@property (nonatomic) BOOL followed;

@end

@implementation HHMyCoachDetailViewController

- (instancetype)initWithCoach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.coach = coach;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"教练信息";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"icon_share"] action:@selector(shareCoach) target:self];
    [self initSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_coach_page_viewed attributes:nil];
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[HHCoachDetailDescriptionCell class] forCellReuseIdentifier:kDescriptionCellID];
    [self.tableView registerClass:[HHMyCoachBasicInfoCell class] forCellReuseIdentifier:kBasicInfoCellID];
    [self.tableView registerClass:[HHMyCoachCourseInfoCell class] forCellReuseIdentifier:kCourseInfoCellID];
    [self.tableView registerClass:[HHMyCoachPeerCoachesTableViewCell class] forCellReuseIdentifier:kPartnerCoachoCellID];
    
    self.coachImagesView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) * 4.0f/5.0f)];
    self.coachImagesView.delegate = self;
    self.coachImagesView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.coachImagesView.imageURLStringsGroup = self.coach.images;
    self.coachImagesView.autoScroll = NO;
    self.coachImagesView.pageDotColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    self.coachImagesView.currentPageDotColor = [UIColor whiteColor];
    
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithSubView:self.coachImagesView];
    [self.tableView setTableHeaderView:headerView];
    [self.tableView sendSubviewToBack:self.tableView.tableHeaderView];
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}


#pragma mark - TableView Delegate & Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.coach.peerCoaches count] > 0) {
        return CoachCellCount;
    }
    
    return CoachCellCount - 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak HHMyCoachDetailViewController *weakSelf = self;
    switch (indexPath.row) {
        case CoachCellDescription: {
            HHCoachDetailDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:kDescriptionCellID forIndexPath:indexPath];
            cell.likeBlock = ^(UIButton *likeButton, UILabel *likeCountLabel) {
                [weakSelf likeOrUnlikeCoachWithButton:likeButton label:likeCountLabel];
            };
            
            cell.followBlock = ^() {
                [weakSelf followUnfollowCoach];
            };

            [cell setupCellWithCoach:weakSelf.coach followed:weakSelf.followed];
            return cell;
        }
            
        case CoachCellBasicInfo: {
            HHMyCoachBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kBasicInfoCellID forIndexPath:indexPath];
            [cell setupCellWithCoach:weakSelf.coach];
            cell.phoneNumberView.actionBlock = ^() {
                NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",weakSelf.coach.cellPhone]];
                if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                    [[UIApplication sharedApplication] openURL:phoneUrl];
                }
            };
            
            cell.addressView.actionBlock = ^() {
                HHSingleFieldMapViewController *vc = [[HHSingleFieldMapViewController alloc] initWithField:[weakSelf.coach getCoachField]];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        }
            
        case CoachCellCourseInfo: {
            HHMyCoachCourseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCourseInfoCellID forIndexPath:indexPath];
            [cell setupCellWithStudent:[HHStudentStore sharedInstance].currentStudent];
            cell.feeDetailView.actionBlock = ^() {
                HHPurchasedService *ps = [[HHStudentStore sharedInstance].currentStudent.purchasedServiceArray firstObject];
                HHCoachPriceDetailViewController *vc = [[HHCoachPriceDetailViewController alloc] initWithCoach:weakSelf.coach productType:[ps.productType integerValue]];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        }
        case CoachCellPartnerCoaches: {
            HHMyCoachPeerCoachesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPartnerCoachoCellID forIndexPath:indexPath];
            if (weakSelf.coach.peerCoaches.count > 0) {
                [cell setupWithCoach:weakSelf.coach];
                cell.coachAction = ^(NSInteger index){
                    HHCoach *coach = self.coach.peerCoaches[index];
                    HHCoachDetailViewController *detailVC = [[HHCoachDetailViewController alloc] initWithCoachId:coach.coachId];
                    detailVC.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:detailVC animated:YES];
                };
            }
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
            
        case CoachCellBasicInfo: {
            return kTopPadding + kTitleViewHeight + 2.0f * kItemViewHeight;
        }
            
        case CoachCellCourseInfo: {
            if (self.coach.peerCoaches.count == 0) {
                return kTopPadding * 2.0 + kTitleViewHeight + 2.0f * kItemViewHeight;
            }
            return kTopPadding + kTitleViewHeight + 2.0f * kItemViewHeight;
        }
            
        case CoachCellPartnerCoaches: {
            if (self.coach.peerCoaches.count == 0) {
                return 0;
            }
            return kTopPadding * 2.0f+ kTitleViewHeight + self.coach.peerCoaches.count * 70.0f;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView]) {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:self.tableView.contentOffset];
    }
}


#pragma mark Button Actions

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareCoach {
    __weak HHMyCoachDetailViewController *weakSelf = self;
    HHShareView *shareView = [[HHShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0)];
    shareView.dismissBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    shareView.actionBlock = ^(SocialMedia selecteItem) {
        if (selecteItem == SocialMediaMessage) {
            [HHPopupUtility dismissPopup:weakSelf.popup];
        }
        [[HHSocialMediaShareUtility sharedInstance] shareCoach:weakSelf.coach shareType:selecteItem inVC:weakSelf resultCompletion:^(BOOL succceed) {
            if (succceed) {
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_coach_page_share_coach_succeed attributes:@{@"coach_id":self.coach.coachId, @"channel":[[HHSocialMediaShareUtility sharedInstance] getChannelNameWithType:selecteItem]}];
            }
        }];
    };
    weakSelf.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
    [HHPopupUtility showPopup:weakSelf.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:my_coach_page_share_coach_tapped attributes:@{@"coach_id":self.coach.coachId}];
}

#pragma mark - Others

- (CGRect)getDescriptionTextSizeWithText:(NSString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-40.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}
                                     context:nil];
    return rect;
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
            if (self.updateCoachBlock) {
                self.updateCoachBlock(self.coach);
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
    
}

- (void)setFollowed:(BOOL)followed {
    _followed = followed;
    [self.tableView reloadData];
}

- (void)followUnfollowCoach {
    if (self.followed) {
        [[HHCoachService sharedInstance] unfollowCoach:self.coach.userId completion:^(NSError *error) {
            if (!error) {
                self.followed = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kUnfollowCoach" object:@{@"coachId":self.coach.coachId}];
            }
        }];
    } else {
        [[HHCoachService sharedInstance] followCoach:self.coach.userId completion:^(NSError *error) {
            if (!error) {
                self.followed = YES;
            }
            
        }];
    }
}

@end
