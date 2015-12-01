//
//  HHCoachAddTimeViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/5/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachAddTimeViewController.h"
#import "UIColor+HHColor.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHAutoLayoutUtility.h"
#import "HHScheduleCellView.h"
#import "HHCoachSchedule.h"
#import "HHUserAuthenticator.h"
#import "HHToastUtility.h"
#import "HHLoadingView.h"
#import "HHFormatUtility.h"
#import <NSDate+DateTools.h>
#import "ActionSheetPicker.h"
#import "KLCPopup.h"
#import "HHScheduleService.h"
#import "HHCourseProgressStore.h"
#import "HHCourseProgress.h"

#define kCellId  @"AddTimeCellId"

@interface HHCoachAddTimeViewController ()

@property (nonatomic, strong) HHScheduleCellView *dateView;
@property (nonatomic, strong) HHScheduleCellView *startTimeView;
@property (nonatomic, strong) HHScheduleCellView *endTimeView;
@property (nonatomic, strong) HHScheduleCellView *courseView;
@property (nonatomic, strong) HHScheduleCellView *progressView;
@property (nonatomic, strong) HHCoachSchedule *schedule;
@property (nonatomic, strong) ActionSheetDatePicker *datePicker;
@property (nonatomic, strong) ActionSheetStringPicker *coursePicker;
@property (nonatomic, strong) ActionSheetStringPicker *courseProgressPicker;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSString *course;
@property (nonatomic, strong) NSNumber *progressNumber;
@property (nonatomic, strong) UILabel *explanationLabel;
@property (nonatomic, strong) KLCPopup *confirmPopup;
@property (nonatomic, strong) NSString *selectedProgressName;

@end

@implementation HHCoachAddTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    self.schedule = [HHCoachSchedule object];
    
    
    
    UIBarButtonItem *backButton = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"left_arrow"] action:@selector(backButtonPressed) target:self];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8.0f;//
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    
    UIBarButtonItem *bookBarButton = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"下一步", nil) action:@selector(confirmTime) target:self isLeft:NO];
    self.navigationItem.rightBarButtonItem = bookBarButton;
    
    
    self.explanationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.explanationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.explanationLabel.textAlignment = NSTextAlignmentLeft;
    self.explanationLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14.0f];
    self.explanationLabel.textColor = [UIColor HHGrayTextColor];
    self.explanationLabel.text = NSLocalizedString(@"注：教练提交信息后将无法修改或删除该时间段，所以请教练再填写完毕后仔细阅读确认。", nil);
    [self.explanationLabel sizeToFit];
    self.explanationLabel.numberOfLines = 0;
    [self.view addSubview:self.explanationLabel];
    
    [self createScheduleView];
    [self autoLayoutSubviews];
}

- (void)createScheduleView {
    self.dateView = [self createCellWithImage:[UIImage imageNamed:@"addtime_calendar"] title:NSLocalizedString(@"添加日期", nil) subTitle:NSLocalizedString(@"选择日期", nil) showLine:YES];
    
    
    self.startTimeView = [self createCellWithImage:[UIImage imageNamed:@"addtime_starttime"] title:NSLocalizedString(@"开始时间", nil) subTitle:NSLocalizedString(@"选择时间", nil) showLine:YES];
    
    self.endTimeView = [self createCellWithImage:[UIImage imageNamed:@"addtime_endtime"] title:NSLocalizedString(@"结束时间", nil) subTitle:NSLocalizedString(@"选择时间", nil) showLine:YES];
    
    self.courseView = [self createCellWithImage:[UIImage imageNamed:@"addtime_class"] title:NSLocalizedString(@"训练科目", nil) subTitle:NSLocalizedString(@"选择科目", nil) showLine:YES];
    
    self.progressView = [self createCellWithImage:[UIImage imageNamed:@"ic_addtime_steps"] title:NSLocalizedString(@"学习阶段", nil) subTitle:NSLocalizedString(@"选择阶段", nil) showLine:NO];
}

- (HHScheduleCellView *)createCellWithImage:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTilte showLine:(BOOL)showLine {
    HHScheduleCellView *view = [[HHScheduleCellView alloc] initWithFrame:CGRectZero];
    view.userInteractionEnabled = YES;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view];
    [view setupViewsWithImage:image title:title subTitle:subTilte showLine:showLine];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    [view addGestureRecognizer:tap];
    return view;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterX:self.dateView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.dateView constant:10.0f],
                             [HHAutoLayoutUtility setViewWidth:self.dateView multiplier:1.0f constant:-20.0f],
                             [HHAutoLayoutUtility setViewHeight:self.dateView multiplier:0 constant:50.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.startTimeView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.startTimeView toView:self.dateView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.startTimeView multiplier:1.0f constant:-20.0f],
                             [HHAutoLayoutUtility setViewHeight:self.startTimeView multiplier:0 constant:50.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.endTimeView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.endTimeView toView:self.startTimeView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.endTimeView multiplier:1.0f constant:-20.0f],
                             [HHAutoLayoutUtility setViewHeight:self.endTimeView multiplier:0 constant:50.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.courseView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.courseView toView:self.endTimeView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.courseView multiplier:1.0f constant:-20.0f],
                             [HHAutoLayoutUtility setViewHeight:self.courseView multiplier:0 constant:50.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.progressView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.progressView toView:self.courseView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.progressView multiplier:1.0f constant:-20.0f],
                             [HHAutoLayoutUtility setViewHeight:self.progressView multiplier:0 constant:50.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.explanationLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.explanationLabel toView:self.progressView constant:10.0f],
                             [HHAutoLayoutUtility setViewWidth:self.explanationLabel multiplier:1.0f constant:-20.0f],
                             
                             ];
    [self.view addConstraints:constraints];
}

-(void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmTime {
    if (!self.date || !self.startTime || !self.endTime || !self.course || !self.progressNumber) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"请务必填写所有5项信息", nil) isError:YES];
        return;
    }
    
    if ([self.endTime hoursFrom:self.startTime] < 1.0f) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"开始时间必须小于结束时间，训练时候不得小于1小时！", nil) timeInterval:3.0f isError:YES];
        return;
    }
    
    [self showConfirmPopup];
    
}

- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer {
    __weak HHCoachAddTimeViewController *weakSelf = self;
    NSDate *prefillDate;
    UIView *view = tapRecognizer.view;
    if ([view isEqual:self.dateView]) {
        if (self.date) {
            prefillDate = self.date;
        } else {
            prefillDate = [NSDate date];
        }
      [self showDatePickerWithDoneButtonAction:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        weakSelf.dateView.subTitleLabel.textColor = [UIColor blackColor];
          weakSelf.dateView.subTitleLabel.text = [[HHFormatUtility dateFormatter] stringFromDate:selectedDate];
          weakSelf.date = selectedDate;
      }
                                   prefillDate:prefillDate
                                        origin:self.dateView
                                          mode:UIDatePickerModeDate];
        
    } else if ([view isEqual:self.startTimeView]) {
        if (self.startTime) {
            prefillDate = self.startTime;
        } else {
            prefillDate = [NSDate date];
        }
        [self showDatePickerWithDoneButtonAction:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            weakSelf.startTimeView.subTitleLabel.textColor = [UIColor blackColor];
            weakSelf.startTimeView.subTitleLabel.text = [[HHFormatUtility timeFormatter] stringFromDate:selectedDate];
            weakSelf.startTime = selectedDate;
        }
                                     prefillDate:prefillDate
                                          origin:self.startTimeView
                                            mode:UIDatePickerModeTime];
        
    } else if ([view isEqual:self.endTimeView]) {
       
        if (self.endTime) {
            prefillDate = self.endTime;
        } else {
            prefillDate = [NSDate date];
        }
        [self showDatePickerWithDoneButtonAction:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            weakSelf.endTimeView.subTitleLabel.textColor = [UIColor blackColor];
            weakSelf.endTimeView.subTitleLabel.text = [[HHFormatUtility timeFormatter] stringFromDate:selectedDate];
            weakSelf.endTime = selectedDate;
        }
                                     prefillDate:prefillDate
                                          origin:self.endTimeView
                                            mode:UIDatePickerModeTime];

        
    } else if ([view isEqual:self.courseView]) {
        NSInteger prefillIndex = 0;
        if ([self.course isEqualToString:NSLocalizedString(@"科目二", nil)] || !self.course) {
            prefillIndex = 0;
        } else {
            prefillIndex = 1;
        }
        [self showCoursePickerWithDoneButtonAction:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            weakSelf.courseView.subTitleLabel.textColor = [UIColor blackColor];
            weakSelf.courseView.subTitleLabel.text = selectedValue;
            weakSelf.course = selectedValue;
            
            //reset progress
            weakSelf.progressView.subTitleLabel.textColor = [UIColor HHGrayTextColor];
            weakSelf.progressView.subTitleLabel.text = NSLocalizedString(@"选择阶段", nil);
            weakSelf.progressNumber = nil;

        }
                                           options:@[NSLocalizedString(@"科目二", nil), NSLocalizedString(@"科目三", nil)]
                                            origin:self.courseView
                             initialSelectionIndex:prefillIndex];
    } else if ([view isEqual:self.progressView]) {
        [self buildCourseProgressDataWithCompletion:^(NSArray *courseProgressArray, NSError *error) {
            if ([courseProgressArray count]) {
                NSInteger prefillIndex = 0;
                if (self.progressNumber) {
                    prefillIndex = [self.progressNumber integerValue];
                }
                
                NSMutableArray *progressNameArray = [NSMutableArray array];
                for (HHCourseProgress *courseProgress in courseProgressArray) {
                    [progressNameArray addObject:courseProgress.progressName];
                }
                
                [weakSelf showCourseProgressPickerWithDoneButtonAction:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                    weakSelf.progressView.subTitleLabel.textColor = [UIColor blackColor];
                    weakSelf.progressView.subTitleLabel.text = selectedValue;
                    weakSelf.progressNumber = courseProgressArray[selectedIndex][@"progressNumber"];
                    weakSelf.selectedProgressName = selectedValue;
                } options:progressNameArray origin:self.progressView initialSelectionIndex:prefillIndex];
            } else {
                [HHToastUtility showToastWitiTitle:NSLocalizedString(@"请先选择科目", nil) isError:YES];
            }
        }];
    }
    
}

- (void)showDatePickerWithDoneButtonAction:(ActionDateDoneBlock)action prefillDate:(NSDate *)prefillDate origin:(UIView *)origin mode:(UIDatePickerMode)mode {
    self.datePicker = [[ActionSheetDatePicker alloc] initWithTitle:NSLocalizedString(@"选择时间", nil)
                                                    datePickerMode:mode
                                                      selectedDate:prefillDate
                                                         doneBlock:action
                                                       cancelBlock:nil
                                                            origin:origin];
    self.datePicker.tapDismissAction = TapActionCancel;
    if (mode == UIDatePickerModeDate) {
        self.datePicker.minimumDate = [NSDate date];
    }
    
    if (mode == UIDatePickerModeTime) {
        self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];

    } else if (mode == UIDatePickerModeDate ){
        self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    }
    
    UIButton *cancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"取消", nil)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor HHGrayTextColor] range:NSMakeRange(0, 2)];
    [cancelButton setAttributedTitle:attrString forState:UIControlStateNormal];
    [cancelButton sizeToFit];
    [self.datePicker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    UIButton *doneButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString *attrDoneString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"确认", nil)];
    [attrDoneString addAttribute:NSForegroundColorAttributeName value:[UIColor HHOrange] range:NSMakeRange(0, 2)];
    [doneButton setAttributedTitle:attrDoneString forState:UIControlStateNormal];
    [doneButton sizeToFit];
    [self.datePicker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    
    [self.datePicker showActionSheetPicker];
}

- (void)showCoursePickerWithDoneButtonAction:(ActionStringDoneBlock)action options:(NSArray *)options origin:(UIView *)origin initialSelectionIndex:(NSInteger)initialSelectionIndex {
    self.coursePicker = [[ActionSheetStringPicker alloc] initWithTitle:NSLocalizedString(@"选择科目", nil)
                                                                  rows:options
                                                      initialSelection:initialSelectionIndex
                                                             doneBlock:action
                                                           cancelBlock:nil
                                                                origin:origin];
    self.coursePicker.tapDismissAction = TapActionCancel;
    UIButton *cancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"取消", nil)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor HHGrayTextColor] range:NSMakeRange(0, 2)];
    [cancelButton setAttributedTitle:attrString forState:UIControlStateNormal];
    [cancelButton sizeToFit];
    [self.coursePicker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    UIButton *doneButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString *attrDoneString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"确认", nil)];
    [attrDoneString addAttribute:NSForegroundColorAttributeName value:[UIColor HHOrange] range:NSMakeRange(0, 2)];
    [doneButton setAttributedTitle:attrDoneString forState:UIControlStateNormal];
    [doneButton sizeToFit];
    [self.coursePicker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    
    [self.coursePicker showActionSheetPicker];
}

- (void)showCourseProgressPickerWithDoneButtonAction:(ActionStringDoneBlock)action options:(NSArray *)options origin:(UIView *)origin initialSelectionIndex:(NSInteger)initialSelectionIndex {
    self.courseProgressPicker = [[ActionSheetStringPicker alloc] initWithTitle:NSLocalizedString(@"选择阶段", nil)
                                                                  rows:options
                                                      initialSelection:initialSelectionIndex
                                                             doneBlock:action
                                                           cancelBlock:nil
                                                                origin:origin];
    self.courseProgressPicker.tapDismissAction = TapActionCancel;
    UIButton *cancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"取消", nil)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor HHGrayTextColor] range:NSMakeRange(0, 2)];
    [cancelButton setAttributedTitle:attrString forState:UIControlStateNormal];
    [cancelButton sizeToFit];
    [self.courseProgressPicker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    UIButton *doneButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString *attrDoneString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"确认", nil)];
    [attrDoneString addAttribute:NSForegroundColorAttributeName value:[UIColor HHOrange] range:NSMakeRange(0, 2)];
    [doneButton setAttributedTitle:attrDoneString forState:UIControlStateNormal];
    [doneButton sizeToFit];
    [self.courseProgressPicker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    
    [self.courseProgressPicker showActionSheetPicker];
}



- (NSDate *)combineDate:(NSDate *)date withTime:(NSDate *)time {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:
                             NSGregorianCalendar];
    
    unsigned unitFlagsDate = NSYearCalendarUnit | NSMonthCalendarUnit
    |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [gregorian components:unitFlagsDate
                                                    fromDate:date];
    unsigned unitFlagsTime = NSHourCalendarUnit | NSMinuteCalendarUnit
    |  NSSecondCalendarUnit;
    NSDateComponents *timeComponents = [gregorian components:unitFlagsTime
                                                    fromDate:time];
    
    [dateComponents setSecond:[timeComponents second]];
    [dateComponents setHour:[timeComponents hour]];
    [dateComponents setMinute:[timeComponents minute]];
    
    NSDate *combDate = [gregorian dateFromComponents:dateComponents];   
    
    return combDate;
}


- (void)showConfirmPopup {
    UIView *confirmTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 40.0f, 280.0f)];
    confirmTimeView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [self createLabelWithTitle:NSLocalizedString(@"您要添加到时间段和科目为：", nil) font:[UIFont fontWithName:@"STHeitiSC-Medium" size:16.0f] textColor:[UIColor blackColor]];
    [confirmTimeView addSubview:titleLabel];

    
    NSString *timeString = [NSString stringWithFormat:@"%@ %@ 到 %@\n %@（%@）", [[HHFormatUtility fullDateFormatter] stringFromDate:self.date], [[HHFormatUtility timeFormatter] stringFromDate:self.startTime], [[HHFormatUtility timeFormatter] stringFromDate:self.endTime], self.course, self.selectedProgressName];
    
    UILabel *timeLabel = [self createLabelWithTitle:timeString font:[UIFont fontWithName:@"STHeitiSC-Medium" size:16.0f] textColor:[UIColor HHOrange]];
    timeLabel.numberOfLines = 0;
    [confirmTimeView addSubview:timeLabel];
    
    UIButton *confirmTimeButton = [self createButtonWithText:NSLocalizedString(@"确认提交", nil) textColor:[UIColor whiteColor] bgColor:[UIColor HHOrange] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:16.0f] action:@selector(submitNewSchedule)];
    
    [confirmTimeView addSubview:confirmTimeButton];
    
    UIButton *cancelButton = [self createButtonWithText:NSLocalizedString(@"返回", nil) textColor:[UIColor whiteColor] bgColor:[UIColor HHBlueButtonColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:16.0f] action:@selector(dismissPopupView)];
    [confirmTimeView addSubview:cancelButton];
    
    UILabel *warningLabel = [self createLabelWithTitle:NSLocalizedString(@"确认提交后到信息将无法修改或删除，教练提交信息时请务必仔细确认", nil) font:[UIFont fontWithName:@"STHeitiSC-Medium" size:14.0f] textColor:[UIColor colorWithRed:0.91 green:0.59 blue:0.58 alpha:1]];
    warningLabel.numberOfLines = 0;
    [confirmTimeView addSubview:timeLabel];
    
    [confirmTimeView addSubview:warningLabel];
    
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:titleLabel constant:20.0f],
                             [HHAutoLayoutUtility setCenterX:titleLabel multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:timeLabel toView:titleLabel constant:15.0f],
                             [HHAutoLayoutUtility setCenterX:timeLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:timeLabel multiplier:1.0f constant:-40.0f],
                             
                             [HHAutoLayoutUtility verticalNext:confirmTimeButton toView:timeLabel constant:25.0f],
                             [HHAutoLayoutUtility setCenterX:confirmTimeButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:confirmTimeButton multiplier:0 constant:40.0f],
                             [HHAutoLayoutUtility setViewWidth:confirmTimeButton multiplier:1.0f constant:-40.0f],
                             
                             [HHAutoLayoutUtility verticalNext:cancelButton toView:confirmTimeButton constant:10.0f],
                             [HHAutoLayoutUtility setCenterX:cancelButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:cancelButton multiplier:0 constant:40.0f],
                             [HHAutoLayoutUtility setViewWidth:cancelButton multiplier:1.0f constant:-40.0f],
                             
                             [HHAutoLayoutUtility verticalNext:warningLabel toView:cancelButton constant:10.0f],
                             [HHAutoLayoutUtility setCenterX:warningLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:warningLabel multiplier:1.0f constant:-40.0f],
                             
                             ];
    
    [confirmTimeView addConstraints:constraints];

    
    self.confirmPopup = [KLCPopup popupWithContentView:confirmTimeView];
    [self.confirmPopup showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];
    
}

- (void)submitNewSchedule {
    __weak HHCoachAddTimeViewController *weakSelf = self;
    self.schedule = [HHCoachSchedule object];
    self.schedule.coachId = [HHUserAuthenticator sharedInstance].currentCoach.coachId;
    self.schedule.startDateTime = [self combineDate:self.date withTime:self.startTime];
    self.schedule.endDateTime = [self combineDate:self.date withTime:self.endTime];
    self.schedule.course = self.course;
    self.schedule.progressNumber = self.progressNumber;
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:nil];
    
    [[HHScheduleService sharedInstance] submitSchedule:self.schedule completion:^(BOOL succeed, NSError *error) {
        [[HHLoadingView sharedInstance] hideLoadingView];
        if (succeed) {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"提交成功！", nil) timeInterval:1.0f isError:NO];
            if (weakSelf.successCompletion) {
                weakSelf.successCompletion();
            }

        } else {
             [HHToastUtility showToastWitiTitle:NSLocalizedString(@"提交失败！本次提交的时间可能与之前提交的时间冲突，请仔细检查！", nil) timeInterval:3.0f isError:YES];
        }
         [weakSelf dismissPopupView];
    }];
}

- (void)dismissPopupView {
    [self.confirmPopup dismiss:YES];
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


- (UILabel *)createLabelWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.textColor = textColor;
    [label sizeToFit];
    return label;
}


- (void)buildCourseProgressDataWithCompletion:(HHCourseProgressCompletionBlock)completion {
    if (![self.course length]) {
        if (completion) {
            completion(nil, nil);
        }
    } else {
        [[HHCourseProgressStore sharedInstance] filterCourseProgressArrayWithCournseName:self.course Completion:^(NSArray *courseProgressArray, NSError *error) {
            if (completion) {
                completion (courseProgressArray, error);
            }
        }];
    }
}

@end
