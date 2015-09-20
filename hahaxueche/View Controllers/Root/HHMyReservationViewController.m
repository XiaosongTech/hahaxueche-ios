//
//  HHMyReservationViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/7/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHMyReservationViewController.h"
#import "HHAutoLayoutUtility.h"
#import "HHUserAuthenticator.h"
#import "HHScheduleService.h"
#import "HHLoadingView.h"
#import "HHFormatUtility.h"
#import "HHToastUtility.h"
#import "HHTimeSlotSectionTitleView.h"
#import "HHMyReservationTableViewCell.h"
#import "HHTrainingFieldService.h"
#import "HHTrainingField.h"
#import <pop/POP.h>
#import "HHCoachProfileViewController.h"
#import "HHScheduleService.h"
#import "HHFullScreenImageViewController.h"
#import "KLCPopup.h"
#import "UIColor+HHColor.h"
#import "HHStudentService.h"

typedef void (^HHGenericCompletion)();

#define kReservationCellId @"kReservationCellId"

@interface HHMyReservationViewController()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *reservations;
@property (nonatomic, strong) NSArray *groupedReservations;
@property (nonatomic, strong) NSArray *sectionTitles;

@property (nonatomic, strong) HHTrainingField *trainingField;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic)         BOOL shouldLoadMore;
@property (nonatomic)         BOOL isFetching;
@property (nonatomic, strong) UIActionSheet *showCancelActionSheet;
@property (nonatomic, strong) NSIndexPath *cancelCellIndexPath;
@property (nonatomic, strong) KLCPopup *popupView;


@end


@implementation HHMyReservationViewController

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.showCancelActionSheet.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    self.title = NSLocalizedString(@"我的预约",nil);
    self.shouldLoadMore = YES;
    self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    self.reservations = [NSMutableArray array];
    [self initSubviews];
    [[HHTrainingFieldService sharedInstance] fetchTrainingFieldWithId:[HHUserAuthenticator sharedInstance].myCoach.trainingFieldId completion:^(HHTrainingField *field, NSError *error) {
        if (!error) {
            self.trainingField = field;
        }
    }];
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
    [self fetchReservationsWithCompletion:^{
        [[HHLoadingView sharedInstance] hideLoadingView];
    }];

    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"bookSucceed" object:nil];
    
    self.showCancelActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:NSLocalizedString(@"取消预约", nil), nil];
    
}

-(void)updateData {
    [self fetchReservationsWithCompletion:nil];
}

- (void)refreshData {
    __weak HHMyReservationViewController *weakSelf = self;
    [self fetchReservationsWithCompletion:^{
        [weakSelf.refreshControl endRefreshing];
    }];
}

- (void)fetchReservationsWithCompletion:(HHGenericCompletion)completion {
    if (self.isFetching) {
        return;
    }
    __weak HHMyReservationViewController *weakSelf = self;
    self.isFetching = YES;
    [[HHUserAuthenticator sharedInstance] fetchAuthedStudentAgainWithCompletion:^(HHStudent *student, NSError *error) {
        if (!error) {
            [[HHScheduleService sharedInstance] fetchAuthedStudentReservationsWithSkip:0 completion:^(NSArray *objects, NSInteger totalResults, NSError *error) {
                weakSelf.isFetching = NO;
                if (completion) {
                    completion();
                }
                if (!error) {
                    weakSelf.reservations = [NSMutableArray arrayWithArray:objects];
                    weakSelf.sectionTitles = [weakSelf groupReservationsTitles];
                    [weakSelf.tableView reloadData];
                    if (weakSelf.reservations.count >= totalResults) {
                        weakSelf.shouldLoadMore = NO;
                    } else {
                        weakSelf.shouldLoadMore = YES;
                    }
                } else {
                    [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取数据时出错！", nil) isError:YES];
                }
            }];

        }
    }];
   
}

- (void)fetchMoreReservations {
    __weak HHMyReservationViewController *weakSelf = self;
    [[HHScheduleService sharedInstance] fetchAuthedStudentReservationsWithSkip:self.reservations.count completion:^(NSArray *objects, NSInteger totalResults, NSError *error) {
        if (!error) {
            [weakSelf.reservations addObjectsFromArray:objects];
            weakSelf.sectionTitles = [weakSelf groupReservationsTitles];
            [weakSelf.tableView reloadData];
            if (weakSelf.reservations.count >= totalResults) {
                weakSelf.shouldLoadMore = NO;
            } else {
                weakSelf.shouldLoadMore = YES;
            }
        } else {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"获取数据时出错！", nil) isError:YES];
        }
    }];


}


- (void)initSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HHMyReservationTableViewCell class] forCellReuseIdentifier:kReservationCellId];
    [self.view addSubview:self.tableView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(showCancel:)];
    longPress.minimumPressDuration = 0.6;
    longPress.delegate = self;
    [self.tableView addGestureRecognizer:longPress];
    
    [self autolayoutSubview];
}

-(void)showCancel:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    
    self.cancelCellIndexPath = [self.tableView indexPathForRowAtPoint:point];
    if (!self.cancelCellIndexPath) {
        return;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.showCancelActionSheet showInView:self.view];
    }
}

- (void)autolayoutSubview {
    NSArray *constraints  = @[
                              [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.tableView constant:0],
                              [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.tableView constant:0],
                              [HHAutoLayoutUtility setViewWidth:self.tableView multiplier:1.0f constant:0],
                              [HHAutoLayoutUtility setViewHeight:self.tableView multiplier:1.0f constant:0],
                              ];
    
    [self.view addConstraints:constraints];
    
}

- (NSArray *)groupReservationsTitles {
    NSMutableArray *array = [NSMutableArray array];
    NSArray *filteredArray = self.reservations;

    if (filteredArray.count < 1) {
        self.reservations = nil;
        return nil;
    }
    HHCoachSchedule *firstSchedule = [filteredArray firstObject];
    NSDate *previousDate = firstSchedule.startDateTime;
    NSMutableArray *currentGroup = [NSMutableArray array];
    [currentGroup addObject:firstSchedule];
    if (filteredArray.count == 1) {
        self.groupedReservations = @[currentGroup];
    } else {
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
        self.groupedReservations = array;
    }
    
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < self.groupedReservations.count; i++) {
        HHCoachSchedule *schedule = [self.groupedReservations[i] firstObject];
        NSString *date = [[HHFormatUtility fullDateFormatter] stringFromDate:schedule.startDateTime];
        NSString *title = [NSString stringWithFormat:@"%@ (%@)", date, [[HHFormatUtility weekDayFormatter] stringFromDate:schedule.startDateTime]];
        [titles addObject:title];
    }
    return titles;
}



#pragma mark Tableview Delagate & Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupedReservations.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HHTimeSlotSectionTitleView *view = [[HHTimeSlotSectionTitleView alloc] initWithTitle:self.sectionTitles[section]];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.groupedReservations.count) {
        NSArray *reservations = self.groupedReservations[section];
        return reservations.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak HHMyReservationViewController *weakSelf = self;
    HHMyReservationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kReservationCellId forIndexPath:indexPath];
    HHCoachSchedule *reservation = self.groupedReservations[indexPath.section][indexPath.row];
    cell.reservation = reservation;
    cell.students = [NSMutableArray arrayWithArray:reservation.fullStudents];;
    [cell setupViews];
    
    cell.avatarActionBlock = ^(HHStudent *student){
        HHFullScreenImageViewController *vc = [[HHFullScreenImageViewController alloc] initWithImageURL:[NSURL URLWithString:student.avatarURL] title:student.fullName];
        [weakSelf.tabBarController presentViewController:vc animated:YES completion:nil];
    };
    
    cell.nameButtonBlock = ^(){
        HHCoachProfileViewController *coachProfileVC =  [[HHCoachProfileViewController alloc] initWithCoach:[HHUserAuthenticator sharedInstance].myCoach];
        [weakSelf.navigationController pushViewController:coachProfileVC animated:YES];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.8f, 0.8f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.springBounciness = 15.f;
    [cell.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}


#pragma mark ScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= 0) {
        if (!self.shouldLoadMore) {
            return;
        }
        [self fetchMoreReservations];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet isEqual:self.showCancelActionSheet]) {
        if (buttonIndex == 0) {
            self.popupView = [KLCPopup popupWithContentView:[self createPopupContentView]];
            [self.popupView show];
        }
    }
}

- (UIView *)createPopupContentView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 60.0f, 290.0f)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [self createLableWithText:NSLocalizedString(@"您确定取消以下预约？", nil) font:[UIFont fontWithName:@"STHeitiSC-Light" size:14.0f] textColor:[UIColor blackColor]];
    
    HHCoachSchedule *schedule = self.groupedReservations[self.cancelCellIndexPath.section][self.cancelCellIndexPath.row];
    NSString *subtitile = [NSString stringWithFormat:@"%@(%@)\n%@ 到 %@", [[HHFormatUtility fullDateFormatter] stringFromDate:schedule.startDateTime], [[HHFormatUtility weekDayFormatter] stringFromDate:schedule.startDateTime], [[HHFormatUtility timeFormatter] stringFromDate:schedule.startDateTime], [[HHFormatUtility timeFormatter] stringFromDate:schedule.endDateTime]];
    UILabel *subtitleLabel = [self createLableWithText:subtitile font:[UIFont fontWithName:@"STHeitiSC-Light" size:16.0f] textColor:[UIColor blackColor]];
    subtitleLabel.numberOfLines = 0;
    UIButton *confirmCancelButton = [self createButtonWithText:NSLocalizedString(@"确认取消", nil) textColor:[UIColor whiteColor] bgColor:[UIColor HHOrange] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:16.0f] action:@selector(cancelAppointment)];
    
    UIButton *dismissButton = [self createButtonWithText:NSLocalizedString(@"返回", nil) textColor:[UIColor whiteColor] bgColor:[UIColor HHBlueButtonColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:16.0f] action:@selector(dismissPopupView)];
    
    UILabel *explanationLabel = [self createLableWithText:NSLocalizedString(@"如确认取消，您将无法在此时间段练车。", nil) font:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f] textColor:[UIColor HHGrayTextColor]];
    
    
    [contentView addSubview:titleLabel];
    [contentView addSubview:subtitleLabel];
    [contentView addSubview:confirmCancelButton];
    [contentView addSubview:dismissButton];
    [contentView addSubview:explanationLabel];
    
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:titleLabel constant:30.0f],
                             [HHAutoLayoutUtility setCenterX:titleLabel multiplier:1.0f constant:0],

                             [HHAutoLayoutUtility verticalNext:subtitleLabel toView:titleLabel constant:20.0f],
                             [HHAutoLayoutUtility setCenterX:subtitleLabel multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:confirmCancelButton toView:subtitleLabel constant:30.0f],
                             [HHAutoLayoutUtility setCenterX:confirmCancelButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:confirmCancelButton multiplier:0 constant:40.0f],
                             [HHAutoLayoutUtility setViewWidth:confirmCancelButton multiplier:1.0f constant:-40.0f],
                             
                             [HHAutoLayoutUtility verticalNext:dismissButton toView:confirmCancelButton constant:15.0f],
                             [HHAutoLayoutUtility setCenterX:dismissButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:dismissButton multiplier:0 constant:40.0f],
                             [HHAutoLayoutUtility setViewWidth:dismissButton multiplier:1.0f constant:-40.0f],
                             
                             [HHAutoLayoutUtility verticalNext:explanationLabel toView:dismissButton constant:30.0f],
                             [HHAutoLayoutUtility setCenterX:explanationLabel multiplier:1.0f constant:0],
                             
                             ];

    [contentView addConstraints:constraints];
    return contentView;
}

- (void)cancelAppointment {
    [self.popupView dismiss:YES];
    __weak HHMyReservationViewController *weakSelf = self;
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:NSLocalizedString(@"取消中...", nil)];
    [[HHScheduleService sharedInstance] cancelAppointmentWithSchedule:self.groupedReservations[self.cancelCellIndexPath.section][self.cancelCellIndexPath.row] completion:^(BOOL succeed, NSError *error) {
        [[HHLoadingView sharedInstance] hideLoadingView];
        if (succeed) {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"取消成功", nil) isError:NO];
            [weakSelf.reservations removeObject:self.groupedReservations[self.cancelCellIndexPath.section][self.cancelCellIndexPath.row]];
            weakSelf.sectionTitles = [self groupReservationsTitles];
            [weakSelf.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelSucceed" object:self];
        } else {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"取消失败", nil) isError:YES];
        }
    }];
}

- (void)dismissPopupView {
    [self.popupView dismiss:YES];
}

-(UILabel *)createLableWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = textColor;
    [label sizeToFit];
    return label;
}

-(UIButton *)createButtonWithText:(NSString *)text textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor font:(UIFont *)font action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = bgColor;
    button.titleLabel.font = font;
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma -mark Hide TabBar
- (BOOL)hidesBottomBarWhenPushed {
    return NO;
}

@end
