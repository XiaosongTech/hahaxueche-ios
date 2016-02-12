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
#import "PBViewController.h"
#import "PBViewControllerDataSource.h"
#import "PBImageScrollerViewController.h"
#import "PBViewControllerDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HHCoachDetailSectionOneCell.h"
#import "HHCoachDetailSectionTwoCell.h"
#import "HHCoachDetailBottomBarView.h"

typedef NS_ENUM(NSInteger, CoachCell) {
    CoachCellDescription,
    CoachCellInfoOne,
    CoachCellInfoTwo,
    //CoachCellComments,
    CoachCellCount,
};

static NSString *const kDescriptionCellID = @"kDescriptionCellID";
static NSString *const kInfoOneCellID = @"kInfoOneCellId";
static NSString *const kInfoTwoCellID = @"kInfoTwoCellID";
static NSString *const kCommentsCellID = @"kCommentsCellID";

@interface HHCoachDetailViewController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, UIScrollViewDelegate,PBViewControllerDataSource, PBViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *coachImagesView;
@property (nonatomic, strong) HHCoach *coach;
@property (nonatomic, strong) HHCoachDetailBottomBarView *bottomBar;

@end

@implementation HHCoachDetailViewController

- (instancetype)initWithCoach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.coach = coach;
    }
    return self;
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
    self.coachImagesView.imageURLStringsGroup = @[@"https://i.ytimg.com/vi/eOifa1WrOnQ/maxresdefault.jpg",@"https://i.ytimg.com/vi/eOifa1WrOnQ/maxresdefault.jpg"];
    self.coachImagesView.autoScroll = NO;
    
    [self.tableView registerClass:[HHCoachDetailDescriptionCell class] forCellReuseIdentifier:kDescriptionCellID];
    [self.tableView registerClass:[HHCoachDetailSectionOneCell class] forCellReuseIdentifier:kInfoOneCellID];
    [self.tableView registerClass:[HHCoachDetailSectionTwoCell class] forCellReuseIdentifier:kInfoTwoCellID];
    
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithSubView:self.coachImagesView];
    [self.tableView setTableHeaderView:headerView];
    [self.tableView sendSubviewToBack:self.tableView.tableHeaderView];

    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.bottomBar = [[HHCoachDetailBottomBarView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.tableView.bounds), CGRectGetWidth(self.view.bounds), 50.0f)];
    [self.view addSubview:self.bottomBar];
    
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
        } break;
            
        case CoachCellInfoOne: {
            HHCoachDetailSectionOneCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoOneCellID forIndexPath:indexPath];
            [cell setupWithCoach:nil];
            return cell;
        } break;
            
        case CoachCellInfoTwo: {
            HHCoachDetailSectionTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoTwoCellID forIndexPath:indexPath];
            [cell setupWithCoach:nil];
            return cell;
        } break;
            
//        case CoachCellComments: {
//            UITableViewCell *cell = [[UITableViewCell alloc] init];
//            return cell;
//        } break;
            
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        } break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case CoachCellDescription: {
            NSString *text = @"ddshfkashjfhaskdhakjhfjashskhkfhsajkhdfjakshdjfaddkhfkshkjdfhjsfsjhfdkjshdkfhkasdhfjkashdkfhakshdfjkahsdfhakhfjahdkjahkdsjh";
            
            
            return CGRectGetHeight([self getDescriptionTextSizeWithText:text]) + 50.0f;
        } break;
            
        case CoachCellInfoOne: {
            return 195.0f;
        } break;
            
        case CoachCellInfoTwo: {
            return 195.0f + 140.0f + 36.0f;
        } break;
            
//        case CoachCellComments: {
//            return 100.0f;
//        } break;
            
        default: {
            return 0;
        } break;
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

#pragma mark - Button Actions

- (void)popupVC {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PBViewControllerDataSource

- (NSInteger)numberOfPagesInViewController:(PBViewController *)viewController {
    return 2;
}

- (void)viewController:(PBViewController *)viewController presentImageView:(UIImageView *)imageView forPageAtIndex:(NSInteger)index {
    NSArray *images = @[@"https://i.ytimg.com/vi/eOifa1WrOnQ/maxresdefault.jpg",@"https://i.ytimg.com/vi/eOifa1WrOnQ/maxresdefault.jpg"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:images[index]]];
}

#pragma mark - PBViewControllerDelegate

- (void)viewController:(PBViewController *)viewController didSingleTapedPageAtIndex:(NSInteger)index presentedImage:(UIImage *)presentedImage {
    [viewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
