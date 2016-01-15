//
//  HHFindCoachViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHFindCoachViewController.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHButton.h"
#import "HHSliderView.h"
#import "KLCPopup.h"
#import "HHPopupUtility.h"
#import "HHFiltersView.h"
#import "HHCoachFilters.h"
#import "HHSortView.h"

@interface HHFindCoachViewController ()

@property (nonatomic, strong) UIView *topButtonsView;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIView *horizontalLine;

@property (nonatomic, strong) HHButton *filterButton;
@property (nonatomic, strong) HHButton *sortButton;

@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) HHFiltersView *filtersView;
@property (nonatomic, strong) HHCoachFilters *coachFilters;

@property (nonatomic, strong) HHSortView *sortView;
@property (nonatomic) SortOption currentSortOption;

@end

@implementation HHFindCoachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.coachFilters = [[HHCoachFilters alloc] init];
    self.coachFilters.price = @(3000);
    self.coachFilters.distance = @(3);
    self.coachFilters.onlyGoldenCoach = @(1);
    self.coachFilters.licenseType = @(1);
    
    
    self.currentSortOption = SortOptionSmartSort;
    [self initSubviews];
}

- (void)initSubviews {
    self.topButtonsView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topButtonsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topButtonsView];
    
    self.verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.verticalLine.backgroundColor = [UIColor HHLightLineGray];
    [self.topButtonsView addSubview:self.verticalLine];
    
    self.horizontalLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.horizontalLine.backgroundColor = [UIColor HHLightLineGray];
    [self.topButtonsView addSubview:self.horizontalLine];
    
    self.filterButton = [self createTopButtonWithTitle:@"筛选" image:[UIImage imageNamed:@"ic_screen_normal_btn"]];
    [self.filterButton addTarget:self action:@selector(filterTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topButtonsView addSubview:self.filterButton];
    
    self.sortButton = [self createTopButtonWithTitle:@"排序" image:[UIImage imageNamed:@"ic_sort_normal_btn"]];
    [self.sortButton addTarget:self action:@selector(sortTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topButtonsView addSubview:self.sortButton];
    
    [self makeConstraints];
}

- (HHButton *)createTopButtonWithTitle:(NSString *)title image:(UIImage *)image {
    HHButton *button = [[HHButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -10.0f, 0, 20.0f);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, -30.0f);
    return button;
}

- (void)makeConstraints {
    [self.topButtonsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(40.0f);
        make.left.equalTo(self.view.left);
    }];
    
    [self.verticalLine makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topButtonsView);
        make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.height.mas_equalTo(20.0f);
    }];
    
    [self.horizontalLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topButtonsView.bottom);
        make.left.equalTo(self.topButtonsView.left);
        make.width.equalTo(self.topButtonsView.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.filterButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topButtonsView.left);
        make.width.equalTo(self.topButtonsView.width).multipliedBy(0.5f);
        make.height.equalTo(self.topButtonsView);
        make.top.equalTo(self.topButtonsView.top);
    }];
    
    [self.sortButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verticalLine.left);
        make.width.equalTo(self.topButtonsView.width).multipliedBy(0.5f);
        make.height.equalTo(self.topButtonsView);
        make.top.equalTo(self.topButtonsView.top);
    }];
}


#pragma mark - Button Actions 

- (void)filterTapped {
    __weak HHFindCoachViewController *weakSelf = self;
    self.filtersView = [[HHFiltersView alloc] initWithFilters:[self.coachFilters copy] frame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-20.0f, 380.0f)];
    self.filtersView.confirmBlock = ^(HHCoachFilters *filters){
        weakSelf.coachFilters = filters;
        [weakSelf.popup dismiss:YES];
    };
    self.filtersView.cancelBlock = ^(){
        [weakSelf.popup dismiss:YES];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:self.filtersView];
    [HHPopupUtility showPopup:self.popup];
}

- (void)sortTapped {
     __weak HHFindCoachViewController *weakSelf = self;
    self.sortView = [[HHSortView alloc] initWithDefaultSortOption:self.currentSortOption];
    self.sortView.frame = CGRectMake(0, 0, 130.0f, 200.0f);
    self.sortView.selectedOptionBlock = ^(SortOption sortOption){
        weakSelf.currentSortOption = sortOption;
        [weakSelf.popup dismiss:YES];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:self.sortView];
    CGPoint center = CGPointMake(CGRectGetMidX(self.sortButton.frame), 150.0f);
    [HHPopupUtility showPopup:self.popup AtCenter:center inView:self.view];

}

@end
