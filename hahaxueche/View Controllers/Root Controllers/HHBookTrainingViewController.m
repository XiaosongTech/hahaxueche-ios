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


static NSString *kEmptyCellId = @"emptyCellID";

@interface HHBookTrainingViewController () <UITableViewDataSource, UITableViewDelegate, SwipeViewDataSource, SwipeViewDelegate>

@property (nonatomic, strong) HHNavBarSegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView *courseScheduleTableView;
@property (nonatomic, strong) UITableView *bookedScheduleTableView;
@property (nonatomic, strong) UITableView *finishedScheduleTableView;
@property (nonatomic, strong) SwipeView *containerView;
@property (nonatomic, strong) HHStudent *currentStudent;

@end

@implementation HHBookTrainingViewController

- (void)dealloc {
    self.containerView.delegate = nil;
    self.containerView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHBackgroundGary];
    self.title = @"预约学车";
    self.currentStudent = [HHStudentStore sharedInstance].currentStudent;
    if (self.currentStudent.currentCoachId) {
        [self initSubviews];
    } else {
        [self buildNoCoachView];
    }
}

- (void)initSubviews {
    NSArray *items = @[@"新课程", @"已预约", @"已完成"];
    self.segmentedControl = [[HHNavBarSegmentedControl alloc] initWithItems:items];
    self.segmentedControl.frame = CGRectMake(0, 0, ScheduleTypeCount * 70.0f, 30.0f);
    self.navigationItem.titleView = self.segmentedControl;
    
    self.containerView = [[SwipeView alloc] initWithFrame:self.view.frame];
    self.containerView.delegate = self;
    self.containerView.dataSource = self;
    self.containerView.pagingEnabled = YES;
    [self.view addSubview:self.containerView];
    
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.containerView.bounds];
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
        case ScheduleTypeAll: {
            if (!self.courseScheduleTableView) {
                self.courseScheduleTableView = [self buildTableView];
            }
            
            return self.courseScheduleTableView;
        }
            
        case ScheduleTypeBooked: {
            if (!self.bookedScheduleTableView) {
                self.bookedScheduleTableView =  [self buildTableView];

            }
            return self.bookedScheduleTableView;
        }
            
        case ScheduleTypeFinished: {
            if (!self.finishedScheduleTableView) {
                self.finishedScheduleTableView = [self buildTableView];
            }
            return self.finishedScheduleTableView;
        }
            
        default: {
            if (!self.courseScheduleTableView) {
                self.courseScheduleTableView = [self buildTableView];
            }
            
            return self.courseScheduleTableView;
        };
    }
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    self.segmentedControl.selectedSegmentIndex = swipeView.currentItemIndex;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return self.containerView.bounds.size;
}

#pragma mark UITableView Delegate & Datasource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title;
    if ([tableView isEqual:self.courseScheduleTableView]) {
        title = @"目前还没有课程，请耐心等待哦～";
    } else if ([tableView isEqual:self.bookedScheduleTableView]) {
        title = @"您还没有已预约的课程，快去教练课程列表选课吧～";
    } else {
        title = @"您还没有已完成的课程，请再接再厉！";
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
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor HHBackgroundGary];
    [self.view addSubview:view];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_nolist_bk_pic"]];
    [view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor HHLightTextGray];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"您还没有选择教练哦～\n快去寻找教练，开启愉快的学车之旅吧～";
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:titleLabel];
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.centerX);
        make.centerY.equalTo(view.centerY).offset(-60.0f);
    }];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.centerX);
        make.centerY.equalTo(view.centerY).offset(20.0f);
        make.width.equalTo(view.width).offset(-40.0f);
    }];

}


@end
