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
#import "HHPriceDetailView.h"
#import "HHPopupUtility.h"
#import "HHImageGalleryViewController.h"
#import "HHShareView.h"
#import "HHPopupUtility.h"
#import "HHSocialMediaShareUtility.h"


static NSString *const kDescriptionCellID = @"kDescriptionCellID";
static NSString *const kBasicInfoCellID = @"kBasicInfoCellID";
static NSString *const kCourseInfoCellID = @"kCourseInfoCellID";

@interface HHMyCoachDetailViewController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) HHCoach *coach;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *coachImagesView;
@property (nonatomic, strong) UIButton *reviewCoachButton;
@property (nonatomic, strong) KLCPopup *popup;

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
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_mycoach_sharecoach"] action:@selector(shareCoach) target:self];
    [self initSubviews];
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
    return CoachCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak HHMyCoachDetailViewController *weakSelf = self;
    switch (indexPath.row) {
        case CoachCellDescription: {
            HHCoachDetailDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:kDescriptionCellID forIndexPath:indexPath];
            [cell setupCellWithCoach:weakSelf.coach];
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
            [cell setupCellWithCoach:weakSelf.coach];
            cell.feeDetailView.actionBlock = ^() {
                HHCity *city = [[HHConstantsStore sharedInstance] getAuthedUserCity];
                CGFloat height = 190.0f + (city.cityFixedFees.count + 1) * 50.0f;
                HHPriceDetailView *priceView = [[HHPriceDetailView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(weakSelf.view.bounds)-20.0f, height) title:@"价格明细" totalPrice:weakSelf.coach.price showOKButton:YES];
                priceView.cancelBlock = ^() {
                    [HHPopupUtility dismissPopup:weakSelf.popup];
                };
                weakSelf.popup = [HHPopupUtility createPopupWithContentView:priceView];
                [HHPopupUtility showPopup:weakSelf.popup];

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
            
        case CoachCellBasicInfo: {
            return kTopPadding + kTitleViewHeight + 2.0f * kItemViewHeight;
        }
            
        case CoachCellCourseInfo: {
            return kTopPadding * 2.0f+ kTitleViewHeight + 4.0f * kItemViewHeight;
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
        switch (selecteItem) {
            case SocialMediaQQFriend: {
                [[HHSocialMediaShareUtility sharedInstance] shareCoach:weakSelf.coach shareType:ShareTypeQQ];
            } break;
                
            case SocialMediaWeibo: {
                [[HHSocialMediaShareUtility sharedInstance] shareCoach:weakSelf.coach shareType:ShareTypeWeibo];
            } break;
                
            case SocialMediaWeChatFriend: {
                [[HHSocialMediaShareUtility sharedInstance] shareCoach:weakSelf.coach shareType:ShareTypeWeChat];
            } break;
                
            case SocialMediaWeChaPYQ: {
                [[HHSocialMediaShareUtility sharedInstance] shareCoach:weakSelf.coach shareType:ShareTypeWeChatTimeLine];
            } break;
                
            default:
                break;
        }
    };
    weakSelf.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
    [HHPopupUtility showPopup:weakSelf.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
    
}

#pragma mark - Others

- (CGRect)getDescriptionTextSizeWithText:(NSString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-40.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                     context:nil];
    return rect;
}

@end
