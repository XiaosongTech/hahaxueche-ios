//
//  HHScheduleViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/9/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHTimeSlotsViewController.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "HHCoachSchedule.h"
#import "HHFormatUtility.h"
#import "HHTimeSlotTableViewCell.h"
#import "HHTimeSlotSectionTitleView.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHToastUtility.h"
#import "HHStudentService.h"
#import "HHFullScreenImageViewController.h"
#import "HHUserAuthenticator.h"
#import "HHStudentService.h"
#import "HHScheduleService.h"
#import "HHLoadingView.h"

#define kTimeSlotCellIdentifier @"kTimeSlotCellIdentifier"

@interface HHTimeSlotsViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *groupedSchedules;
@property (nonatomic, strong) NSArray *sectionTiltes;
@property (nonatomic, strong) NSMutableArray *selectedSchedules;
@property (nonatomic, strong) NSMutableDictionary *studentsForSchedules;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic)         BOOL canSelectTime;
@property (nonatomic, strong) UISegmentedControl *filterSegmentedControl;
@property (nonatomic, strong) NSMutableArray *schedules;
@property (nonatomic)         BOOL shouldLoadMore;

@end

@implementation HHTimeSlotsViewController

-(void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)setCanSelectTime:(BOOL)canSelectTime {
    _canSelectTime = canSelectTime;
    
}
- (void)fetchSchedules {
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:NSLocalizedString(@"加载中...", nil)];
    [[HHScheduleService sharedInstance] fetchCoachSchedulesWithCoachId:self.coach.coachId skip:self.schedules.count completion:^(NSArray *objects, NSInteger totalResults, NSError *error) {
        [[HHLoadingView sharedInstance] hideLoadingView];
        if (!error) {
            [self.schedules removeAllObjects];
            [self.schedules addObjectsFromArray:objects];
            if (self.schedules.count >= totalResults) {
                self.shouldLoadMore = NO;
            } else {
                self.shouldLoadMore = YES;
            }
            self.sectionTiltes = [self groupSchedulesTitleWithFilter:self.filterSegmentedControl.selectedSegmentIndex];
            [self.tableView reloadData];
            for (HHCoachSchedule *schedule in self.schedules) {
                [[HHStudentService sharedInstance] fetchStudentsForScheduleWithIds:schedule.reservedStudents completion:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        self.studentsForSchedules[schedule.objectId] = objects;
                        [self.tableView reloadData];
                    }
                }];

            }

        } else {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取数据是出错！", nil) isError:YES];
        }
    }];
    
}

- (void)fetchMoreSchedules {
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:NSLocalizedString(@"加载中...", nil)];
    [[HHScheduleService sharedInstance] fetchCoachSchedulesWithCoachId:self.coach.coachId skip:self.schedules.count completion:^(NSArray *objects, NSInteger totalResults, NSError *error) {
        [[HHLoadingView sharedInstance] hideLoadingView];
        if (!error) {
            [self.schedules addObjectsFromArray:objects];
            if (self.schedules.count >= totalResults) {
                self.shouldLoadMore = NO;
            } else {
                self.shouldLoadMore = YES;
            }
            self.sectionTiltes = [self groupSchedulesTitleWithFilter:self.filterSegmentedControl.selectedSegmentIndex];
            [self.tableView reloadData];
            for (HHCoachSchedule *schedule in self.schedules) {
                [[HHStudentService sharedInstance] fetchStudentsForScheduleWithIds:schedule.reservedStudents completion:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        self.studentsForSchedules[schedule.objectId] = objects;
                        [self.tableView reloadData];
                    }
                }];
                
            }
            
        } else {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取数据是出错！", nil) isError:YES];
        }
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    self.title = NSLocalizedString(@"预约时间", nil);
    self.navigationItem.hidesBackButton = YES;
    self.selectedSchedules = [NSMutableArray array];
    self.studentsForSchedules = [NSMutableDictionary dictionary];
    self.schedules = [NSMutableArray array];
    
    UIBarButtonItem *backButton = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"left_arrow"] action:@selector(backButtonPressed) target:self];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8.0f;//
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor =[UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HHTimeSlotTableViewCell class] forCellReuseIdentifier:kTimeSlotCellIdentifier];
    [self.view addSubview:self.tableView];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0f;
    paragraphStyle.alignment = NSTextAlignmentCenter;

    self.confirmButton = [self createButtonWithTitle:nil backgroundColor:[UIColor HHLightGrayBackgroundColor] font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:18.0f] action:@selector(confirmTime)];
    [self.confirmButton setAttributedTitle:[self buildConfirmButtonTitle] forState:UIControlStateNormal];
    self.confirmButton.titleLabel.numberOfLines = 0;
    self.confirmButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.confirmButton.enabled = NO;
    
    if ([self.coach.coachId isEqualToString:[HHUserAuthenticator sharedInstance].currentStudent.myCoachId]) {
        self.canSelectTime = YES;
    } else {
        self.canSelectTime = NO;
    }
    

    
    self.filterSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"全部", nil), NSLocalizedString(@"科目二", nil), NSLocalizedString(@"科目三", nil)]];
    self.filterSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.filterSegmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
    self.filterSegmentedControl.selectedSegmentIndex = 0;
    self.filterSegmentedControl.tintColor = [UIColor HHOrange];
    [self.filterSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:13.0f]} forState:UIControlStateNormal];
    [self.filterSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:13.0f]} forState:UIControlStateSelected];
    [self.view addSubview:self.filterSegmentedControl];
    
    [self fetchSchedules];
    [self autoLayoutSubviews];
}

- (NSMutableAttributedString *)buildConfirmButtonTitle {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"点击提交", nil)
                                                                                          attributes:@{
                                                                                                       NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                                       NSFontAttributeName:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:18.0f],
                                                                                                       NSParagraphStyleAttributeName:paragraphStyle,
                                                                                                       }];
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"\n(%ld个时间被选中)", nil), self.selectedSchedules.count]
                                                                                          attributes:@{
                                                                                                       NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                                       NSFontAttributeName:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:15.0f],
                                                                                                       NSParagraphStyleAttributeName:paragraphStyle,
                                                                                                       }];

    [attributedString1 appendAttributedString:attributedString2];
    return attributedString1;
}

-(void)valueChanged:(UISegmentedControl *)control {
    [self groupSchedulesTitleWithFilter:control.selectedSegmentIndex];
    [self.selectedSchedules removeAllObjects];
    [self.tableView reloadData];
}

- (void)confirmTime {
    if (self.selectedSchedules.count <= 0) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"请先选中至少一个时间段！", nil) isError:YES];
        return;
    }
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)autoLayoutSubviews {
    

    NSArray *constraints = @[
                             
                             [HHAutoLayoutUtility setCenterX:self.filterSegmentedControl multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.filterSegmentedControl constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.filterSegmentedControl multiplier:0 constant:30.0f],
                             [HHAutoLayoutUtility setViewWidth:self.filterSegmentedControl multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.tableView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.tableView toView:self.filterSegmentedControl constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.tableView constant:-50.0f],
                             [HHAutoLayoutUtility setViewWidth:self.tableView multiplier:1.0f constant:0],
                       
                             [HHAutoLayoutUtility setCenterX:self.confirmButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.confirmButton constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.confirmButton multiplier:0 constant:50.0f],
                             [HHAutoLayoutUtility setViewWidth:self.confirmButton multiplier:1.0f constant:0],
                             ];

    [self.view addConstraints:constraints];
}

- (NSArray *)groupSchedulesTitleWithFilter:(TimeSlotFilter)filter {
    NSMutableArray *array = [NSMutableArray array];
    NSArray *filteredArray = self.schedules;
    switch (filter) {
        case TimeSlotFilterCourseTwo: {
            filteredArray = [filteredArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(course == %@)", NSLocalizedString(@"科目二", nil)]];
        }
            break;
        case TimeSlotFilterCourseThree: {
            filteredArray = [filteredArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(course == %@)", NSLocalizedString(@"科目三", nil)]];
        }
            break;
            
        default:
            break;
    }

    HHCoachSchedule *firstSchedule = [filteredArray firstObject];
    NSDate *previousDate = firstSchedule.startDateTime;
    NSMutableArray *currentGroup = [NSMutableArray array];
    [currentGroup addObject:firstSchedule];
    for (int i = 1; i < filteredArray.count; i++) {
        HHCoachSchedule *schedule = filteredArray[i];
        if ([[[HHFormatUtility dateFormatter] stringFromDate:schedule.startDateTime] isEqualToString:[[HHFormatUtility dateFormatter] stringFromDate:previousDate]]) {
            [currentGroup addObject:schedule];
        } else {
            [array addObject:currentGroup];
            currentGroup = [NSMutableArray array];
            [currentGroup addObject:schedule];
        }
        if (i == filteredArray.count - 1) {
            [array addObject:currentGroup];
        }
    }
    self.groupedSchedules = array;
    
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < self.groupedSchedules.count; i++) {
        HHCoachSchedule *schedule = [self.groupedSchedules[i] firstObject];
        NSString *date = [[HHFormatUtility fullDateFormatter] stringFromDate:schedule.startDateTime];
        NSString *title = [NSString stringWithFormat:@"%@\n%@", date, [[HHFormatUtility weekDayFormatter] stringFromDate:schedule.startDateTime]];
        [titles addObject:title];
    }
    return titles;
}


#pragma -mark TableView Delegate & DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.groupedSchedules.count) {
        return self.groupedSchedules.count;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHTimeSlotTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTimeSlotCellIdentifier forIndexPath:indexPath];
    HHCoachSchedule *schedule = (HHCoachSchedule *)self.groupedSchedules[indexPath.section][indexPath.row];
    cell.schedule = schedule;
    __weak HHTimeSlotsViewController *weakSelf = self;
    __weak HHTimeSlotTableViewCell *weakCell = cell;
    cell.block = ^(HHStudent *student) {
        HHFullScreenImageViewController *vc = [[HHFullScreenImageViewController alloc] initWithImageURL:[NSURL URLWithString:student.avatarURL] title:student.fullName];
        [weakSelf.tabBarController presentViewController:vc animated:YES completion:nil];
    };
    
    cell.emptyAvatarblock = ^(void){
        [weakSelf handleCellSelection:weakCell indexPath:indexPath];
    };
    
    if ([self.selectedSchedules containsObject:schedule]) {
        cell.selectedIndicatorView.hidden = NO;
        [cell.containerView bringSubviewToFront:cell.selectedIndicatorView];
    } else {
        cell.selectedIndicatorView.hidden = YES;
    }
    [cell setupViews];
    cell.students = self.studentsForSchedules[schedule.objectId];
    [cell setupAvatars];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.groupedSchedules.count) {
        NSArray *schedules = self.groupedSchedules[section];
        return schedules.count;
    } else {
        return 0;
    }
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HHTimeSlotSectionTitleView *view = [[HHTimeSlotSectionTitleView alloc] initWithTitle:self.sectionTiltes[section]];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 118.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HHTimeSlotTableViewCell *cell = (HHTimeSlotTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [self handleCellSelection:cell indexPath:indexPath];
}

- (void)handleCellSelection:(HHTimeSlotTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (!self.canSelectTime) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"确认教练并付款后才能预约时间!", nil) isError:YES];
        return;
    }
    HHCoachSchedule *schedule = (HHCoachSchedule *)self.groupedSchedules[indexPath.section][indexPath.row];
    if ([schedule.reservedStudents containsObject:[HHUserAuthenticator sharedInstance].currentStudent.studentId]) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"已成功预约此时间段, 无需再预约！", nil) isError:YES];
        return;
    }
    
    if (schedule.reservedStudents.count == 4) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"该时间段人数已满（每个时间段最多4名学员）", nil) isError:YES];
        return;
    }
    
    if (self.selectedSchedules.count > 4)
    
    if (cell.selectedIndicatorView.hidden) {
        cell.selectedIndicatorView.hidden = NO;
        [cell.containerView bringSubviewToFront:cell.selectedIndicatorView];
        [self.selectedSchedules addObject:schedule];
        [self changeConfirmButtonTitle];
        
    } else {
        cell.selectedIndicatorView.hidden = YES;
        [self.selectedSchedules removeObject:schedule];
        [self changeConfirmButtonTitle];
    }

}

- (void)changeConfirmButtonTitle {
    [self.confirmButton setAttributedTitle:[self buildConfirmButtonTitle] forState:UIControlStateNormal];
    if (self.selectedSchedules.count == 0) {
        self.confirmButton.enabled = NO;
        self.confirmButton.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    } else {
        self.confirmButton.enabled = YES;
        self.confirmButton.backgroundColor = [UIColor HHOrange];
    }
}

- (UIButton *)createButtonWithTitle:(NSString *)title backgroundColor:(UIColor *)bgColor font:(UIFont *)font action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setBackgroundColor:bgColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

#pragma mark Hide TabBar

- (BOOL)hidesBottomBarWhenPushed {
    return (self.navigationController.topViewController == self);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= 0) {
        if (!self.shouldLoadMore) {
            return;
        }
        [self fetchMoreSchedules];
    }
}


@end
