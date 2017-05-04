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
#import "HHFieldsMapViewController.h"
#import "HHConstantsStore.h"
#import "HHCoachDetailBottomBarView.h"
#import "HHGenericPhoneView.h"
#import "HHStudentService.h"
#import "HHToastManager.h"
#import "HHSupportUtility.h"
#import "HHImageGalleryViewController.h"
#import "HHSchoolBasicInfoTableViewCell.h"

typedef NS_ENUM(NSInteger, SchoolCell) {
    SchoolCellBasic,
    SchoolCellPrice,
    SchoolCellGroupon,
    SchoolCellField,
    SchoolCellReview,
    SchoolCellGetNumber,
    SchoolCellHotSchool,
    SchoolCellCount,
};

static NSString *const kBasicCellID = @"kBasicCellID";


@interface HHDrivingSchoolDetailViewController () <UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) HHDrivingSchool *school;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *schoolImagesView;
@property (nonatomic, strong) HHCoachDetailBottomBarView *bottomBar;

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
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"icon_share"] action:@selector(shareSchool) target:self];
    [self initSubviews];
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-50.0f - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds))];
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
    
    self.bottomBar = [[HHCoachDetailBottomBarView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.tableView.bounds), CGRectGetWidth(self.view.bounds), 50.0f)];
    [self.view addSubview:self.bottomBar];
    
    
    __weak HHDrivingSchoolDetailViewController *weakSelf = self;
    self.bottomBar.tryCoachAction = ^(){
        HHGenericPhoneView *view = [[HHGenericPhoneView alloc] initWithTitle:@"看过训练场才放心" placeHolder:@"输入手机号, 教练立即带你看训练场" buttonTitle:@"预约看场地"];
        view.buttonAction = ^(NSString *number) {
            [[HHStudentService sharedInstance] getPhoneNumber:number coachId:nil schoolId:weakSelf.school.schoolId fieldId:nil eventType:nil eventData:nil completion:^(NSError *error) {
                if (error) {
                    [[HHToastManager sharedManager] showErrorToastWithText:@"提交失败, 请重试"];
                } else {
                    [HHPopupUtility dismissPopup:weakSelf.popup];
                }
                
            }];
        };
        weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
    };
    
    self.bottomBar.supportAction = ^(){
        [weakSelf.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:weakSelf.navigationController] animated:YES];
    };
    
    self.bottomBar.smsAction = ^{
        [[HHSocialMediaShareUtility sharedInstance] showSMS:[NSString stringWithFormat:@"%@, 我在哈哈学车看到您的招生信息, 我想详细了解一下.", weakSelf.school.schoolName] receiver:@[weakSelf.school.consultPhone] attachment:nil inVC:weakSelf];
    };
    
    self.bottomBar.callAction = ^{
        [[HHSupportUtility sharedManager] callSupportWithNumber:weakSelf.school.consultPhone];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHSchoolBasicInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBasicCellID forIndexPath:indexPath];
    [cell setupCellWithSchool:self.school expanded:NO];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 280.0f;
    
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
