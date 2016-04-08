//
//  HHBookTrainingViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHBookTrainingViewController.h"
#import "HHNavBarSegmentedControl.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "SwipeView.h"
#import "HHEmptyScheduleCell.h"
#import "HHStudentStore.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHCoachService.h"
#import <UIImageView+WebCache.h>
#import "HHPopupUtility.h"
#import "HHNoCoachView.h"


static NSString *kEmptyCellId = @"emptyCellID";

@interface HHBookTrainingViewController () <UITableViewDataSource, UITableViewDelegate, SwipeViewDataSource, SwipeViewDelegate>

@property (nonatomic, strong) HHNavBarSegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView *coachScheduleTableView;
@property (nonatomic, strong) UITableView *myScheduleTableView;
@property (nonatomic, strong) SwipeView *containerSwipeView;
@property (nonatomic, strong) HHStudent *currentStudent;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic) BOOL hasCoach;

@end

@implementation HHBookTrainingViewController

- (void)dealloc {
    self.containerSwipeView.delegate = nil;
    self.containerSwipeView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"预约学车";
    self.currentStudent = [HHStudentStore sharedInstance].currentStudent;
    
    NSArray *items = @[@"教练课程", @"我的课程"];
    self.segmentedControl = [[HHNavBarSegmentedControl alloc] initWithItems:items];
    self.segmentedControl.frame = CGRectMake(0, 0, ScheduleTypeCount * 70.0f, 30.0f);
    [self.segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];

    self.navigationItem.titleView = self.segmentedControl;
    if (self.currentStudent.currentCoachId) {
        self.hasCoach = YES;
        
    } else {
        self.hasCoach = NO;
    }
    
    
    if (self.hasCoach) {
        [self initSubviews];
    } else {
        [self buildNoCoachView];
    }
}

- (void)initSubviews {
    
    self.containerSwipeView = [[SwipeView alloc] initWithFrame:self.view.frame];
    self.containerSwipeView.delegate = self;
    self.containerSwipeView.dataSource = self;
    self.containerSwipeView.pagingEnabled = YES;
    [self.view addSubview:self.containerSwipeView];
    
    [[HHCoachService sharedInstance] fetchCoachWithId:self.currentStudent.currentCoachId completion:^(HHCoach *coach, NSError *error) {
        if (!error) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:coach.avatarUrl]];
            UIBarButtonItem *imageButton = [[UIBarButtonItem alloc] initWithCustomView:imageView];
            self.navigationItem.rightBarButtonItem = imageButton;
        }
    }];

}

- (UITableView *)buildTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.containerSwipeView.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor HHBackgroundGary];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[HHEmptyScheduleCell class] forCellReuseIdentifier:kEmptyCellId];
    return tableView;
}


#pragma mark SwipeView Delegate & Datasource Methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return ScheduleTypeCount;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    switch (index) {
        case ScheduleTypeCoachSchedule: {
            if (!self.coachScheduleTableView) {
                self.coachScheduleTableView = [self buildTableView];
            }
            
            return self.coachScheduleTableView;
        }
            
        case ScheduleTypeMySchedule: {
            if (!self.myScheduleTableView) {
                self.myScheduleTableView =  [self buildTableView];

            }
            return self.myScheduleTableView;
        }
            
        default: {
            if (!self.coachScheduleTableView) {
                self.coachScheduleTableView = [self buildTableView];
            }
            
            return self.coachScheduleTableView;
        };
    }
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    self.segmentedControl.selectedSegmentIndex = swipeView.currentItemIndex;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return self.containerSwipeView.bounds.size;
}

#pragma mark UITableView Delegate & Datasource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title;
    if ([tableView isEqual:self.coachScheduleTableView]) {
        title = @"目前还没有课程，请耐心等待哦～";
    } else {
        title = @"您还没有已预约的课程，快去教练课程列表选课吧～";
    } 
    HHEmptyScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:kEmptyCellId];
    [cell setupCellWithTitle:title];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetHeight(tableView.bounds);
}

#pragma mark - Others

- (void)buildNoCoachView {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"选择教练" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    button.backgroundColor = [UIColor HHOrange];
    [button addTarget:self action:@selector(jumpToFindCoachVC) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5.0f;
    [self.view addSubview:button];
    
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom).offset(-(20.0f + CGRectGetHeight(self.tabBarController.tabBar.frame)));
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view.width).offset(-40.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    UILabel *subLabel = [[UILabel alloc] init];
    subLabel.text = @"快去寻找属于自己的好教练, 加入他们吧!";
    subLabel.textColor = [UIColor HHLightestTextGray];
    subLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:subLabel];
    
    [subLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(button.top).offset(-20.0f);
        make.centerX.equalTo(self.view.centerX);
    }];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"您还没有选择教练哦~";
    titleLabel.textColor = [UIColor HHLightTextGray];
    titleLabel.font = [UIFont systemFontOfSize:21.0f];
    [self.view addSubview:titleLabel];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(subLabel.top).offset(-10.0f);
        make.centerX.equalTo(self.view.centerX);
    }];

}

- (void)valueChanged:(UISegmentedControl *)segControl {
    if(!self.hasCoach) {
        segControl.selectedSegmentIndex = ScheduleTypeCoachSchedule;
        [self showNoCoachPopup];
        return;
        
    }
    [self.containerSwipeView scrollToPage:segControl.selectedSegmentIndex duration:0.2f];
}


- (void)showNoCoachPopup {
    HHNoCoachView *view = [[HHNoCoachView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 40.0f, 180.0f)];
    [view.okButton addTarget:self action:@selector(dismissPopupView) forControlEvents:UIControlEventTouchUpInside];
    self.popup = [HHPopupUtility createPopupWithContentView:view];
    
    [HHPopupUtility showPopup:self.popup];
    
}

- (void)dismissPopupView {
    [HHPopupUtility dismissPopup:self.popup];
}

- (void)jumpToFindCoachVC {
    self.tabBarController.selectedIndex = 1;
}



@end
