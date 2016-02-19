//
//  HHMyCoachDetailViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHMyCoachDetailViewController.h"
#import "HHCoach.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "UIColor+HHColor.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "ParallaxHeaderView.h"
#import "PBViewController.h"
#import "PBViewControllerDataSource.h"
#import "PBImageScrollerViewController.h"
#import "PBViewControllerDelegate.h"
#import "HHCoachDetailDescriptionCell.h"
#import "HHMyCoachBasicInfoCell.h"
#import "HHMyPageCoachCell.h"
#import "HHMyCoachCourseInfoCell.h"
#import "HHMyCoachPartnerCoachCell.h"


static NSString *const kDescriptionCellID = @"kDescriptionCellID";
static NSString *const kBasicInfoCellID = @"kBasicInfoCellID";
static NSString *const kCourseInfoCellID = @"kCourseInfoCellID";
static NSString *const kPartnersCellId = @"kPartnersCellId";

@interface HHMyCoachDetailViewController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, UIScrollViewDelegate,PBViewControllerDataSource, PBViewControllerDelegate>

@property (nonatomic, strong) HHCoach *coach;
@property (nonatomic, strong) NSString *coachId;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *coachImagesView;

@end

@implementation HHMyCoachDetailViewController

- (instancetype)initWithCoachId:(NSString *)coachId {
    self = [super init];
    if (self) {
        self.coachId = coachId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"教练信息";
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
    [self initSubviews];
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-50.0f - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[HHCoachDetailDescriptionCell class] forCellReuseIdentifier:kDescriptionCellID];
    [self.tableView registerClass:[HHMyCoachBasicInfoCell class] forCellReuseIdentifier:kBasicInfoCellID];
    [self.tableView registerClass:[HHMyCoachCourseInfoCell class] forCellReuseIdentifier:kCourseInfoCellID];
    [self.tableView registerClass:[HHMyCoachPartnerCoachCell class] forCellReuseIdentifier:kPartnersCellId];
    
    self.coachImagesView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200.0f)];
    self.coachImagesView.delegate = self;
    self.coachImagesView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.coachImagesView.imageURLStringsGroup = @[@"https://i.ytimg.com/vi/eOifa1WrOnQ/maxresdefault.jpg",@"https://i.ytimg.com/vi/eOifa1WrOnQ/maxresdefault.jpg"];
    self.coachImagesView.autoScroll = NO;
    
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
    
    switch (indexPath.row) {
        case CoachCellDescription: {
            HHCoachDetailDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:kDescriptionCellID forIndexPath:indexPath];
            [cell setupCellWithCoach:nil];
            return cell;
        }
            
        case CoachCellBasicInfo: {
            HHMyCoachBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kBasicInfoCellID forIndexPath:indexPath];
            return cell;
        }
            
        case CoachCellCourseInfo: {
            HHMyCoachCourseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCourseInfoCellID forIndexPath:indexPath];
            return cell;
        }
            
        case CoachCellPartnerCoach: {
            HHMyCoachPartnerCoachCell *cell = [tableView dequeueReusableCellWithIdentifier:kPartnersCellId forIndexPath:indexPath];
            [cell setupWithCoachList:nil];
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
            NSString *text = @"ddshfkashjfhaskdhakjhfjashskhkfhsajkhdfjakshdjfaddkhfkshkjdfhjsfsjhfdkjshdkfhkasdhfjkashdkfhakshdfjkahsdfhakhfjahdkjahkdsjh";
            
            
            return CGRectGetHeight([self getDescriptionTextSizeWithText:text]) + 50.0f;
        }
            
        case CoachCellBasicInfo: {
            return kTopPadding + kTitleViewHeight + 2.0f * kItemViewHeight;
        }
            
        case CoachCellCourseInfo: {
            return kTopPadding + kTitleViewHeight + 4.0f * kItemViewHeight;
        }
            
        case CoachCellPartnerCoach: {
            return 140.0f + 36.0f + 15.0f;
        }
            
        default: {
            return 0;
        }
    }
    
}

#pragma mark SDCycleScrollViewDelegate Method

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    PBViewController *pbViewController = [PBViewController new];
    pbViewController.pb_dataSource = self;
    pbViewController.pb_delegate = self;
    [pbViewController setInitializePageIndex:index];
    pbViewController.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:pbViewController animated:YES completion:nil];
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:self.tableView.contentOffset];
    }
}


#pragma mark Button Actions

- (void)dismissVC {
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

@end
