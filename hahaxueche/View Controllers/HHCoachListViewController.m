//
//  HHCoachListViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/5/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachListViewController.h"
#import "HHAutoLayoutUtility.h"
#import "HHBarButtonItemUtility.h"
#import "HHFloatButton.h"
#import "UIColor+HHColor.h"
#import <pop/POP.h>
#import "HHDropDownButton.h"
#import "UIView+HHRect.h"

typedef enum : NSUInteger {
    SortOptionSmartSort,
    SortOptionLowestPrice,
    SortOptionBestRating,
    SortOptionMostRating,
} SortOption;

typedef enum : NSUInteger {
    CourseTwo,
    CourseThree,
} CourseOption;

#define kSmartSortString @"智能排序"
#define kBestRatingString @"评价最好"
#define kMostRatingString @"评价最多"
#define kLowestPriceString @"价格最低"

#define kCourseTwoString @"科目二"
#define kCourseThreeString @"科目三"



@interface HHCoachListViewController ()

@property (nonatomic, strong) HHFloatButton *floatSortButton;
@property (nonatomic, strong) UIView *overlay;
@property (nonatomic, strong) NSMutableArray *floatButtonsArray;
@property (nonatomic)         SortOption currentSortOption;
@property (nonatomic)         CourseOption currentCourseOption;
@property (nonatomic, strong) HHDropDownButton *firstDropDownButton;
@property (nonatomic, strong) HHDropDownButton *secondDropDownButton;
@property (nonatomic, strong) HHFloatButton *firstSortButton;
@property (nonatomic, strong) HHFloatButton *secondSortButton;
@property (nonatomic, strong) HHFloatButton *thirdSortButton;
@property (nonatomic, strong) UIButton *titleButton;

@end

@implementation HHCoachListViewController

- (void)setCurrentCourseOption:(CourseOption)currentCourseOption {
    _currentCourseOption = currentCourseOption;
    
    NSString *courseSting = nil;
    switch (self.currentCourseOption) {
        case CourseTwo: {
            courseSting = kCourseTwoString;
        }
            break;
            
        case CourseThree: {
            courseSting = kCourseThreeString;
        }
            break;
            
        default:{
            courseSting = kCourseTwoString;
        }
            break;
    }
    
    if (!self.title) {
        self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.titleButton setTitle:[NSString stringWithFormat:@"教练 (%@)", courseSting] forState:UIControlStateNormal];
        self.titleButton.titleLabel.font = [UIFont fontWithName:@"SourceHanSansSC-Medium" size:16];
        [self.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleButton setTitleColor:[UIColor HHOrange] forState:UIControlStateHighlighted];
        self.titleButton.backgroundColor = [UIColor clearColor];
        [self.titleButton sizeToFit];
        [self.titleButton addTarget:self action:@selector(titleViewPressed) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = self.titleButton;
    } else {
        [self.titleButton setTitle:[NSString stringWithFormat:@"教练 (%@)", courseSting] forState:UIControlStateNormal];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.currentCourseOption = CourseTwo;
    [self initSubviews];
}

-(void)initSubviews {

    [self initFloatButtons];
    [self initDropdownButtons];
    [self autoLayoutSubviews];
}


- (void)titleViewPressed {
    [self dropDownButtonAnimateDown:self.firstDropDownButton.hidden button:self.firstDropDownButton];
    [self dropDownButtonAnimateDown:self.secondDropDownButton.hidden button:self.secondDropDownButton];
}

- (void)initDropdownButtons {
    self.firstDropDownButton = [self createDropDownButtonWithTitle:kCourseTwoString];
    self.secondDropDownButton = [self createDropDownButtonWithTitle:kCourseThreeString];
    
}

- (HHDropDownButton *)createDropDownButtonWithTitle:(NSString *)title {
    HHDropDownButton *button = [[HHDropDownButton alloc] initWithTitle:title frame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0f)];
    button.hidden = YES;
    [button addTarget:self action:@selector(dropDownButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:button];
    return button;
}

- (void)dropDownButtonPressed:(id)sender {
    HHDropDownButton *button = sender;
    if ([button.titleLabel.text isEqualToString:kCourseTwoString]) {
        self.currentCourseOption = CourseTwo;
    } else {
        self.currentCourseOption = CourseThree;
    }
    [self dropDownButtonAnimateDown:NO button:self.firstDropDownButton];
    [self dropDownButtonAnimateDown:NO button:self.secondDropDownButton];
}


- (void)initFloatButtons {
    
    self.currentSortOption = SortOptionSmartSort;
    
    self.firstSortButton = [self createFloatButtonWithTitle:kLowestPriceString];
    
    self.secondSortButton = [self createFloatButtonWithTitle:kBestRatingString];
    
    self.thirdSortButton = [self createFloatButtonWithTitle:kMostRatingString];
    
    self.floatSortButton = [[HHFloatButton alloc] initWithTitle:kSmartSortString frame:CGRectMake(CGRectGetWidth(self.view.bounds)-100.0f, CGRectGetHeight(self.view.bounds)-90.0f, 90, 25) backgroundColor:[UIColor HHOrange]];
    [self.view addSubview:self.floatSortButton];
    [self.floatSortButton addTarget:self action:@selector(popupFloatButtons) forControlEvents:UIControlEventTouchUpInside];
    
    self.floatButtonsArray = [NSMutableArray arrayWithArray:@[self.floatSortButton, self.firstSortButton, self.secondSortButton, self.thirdSortButton]];
}

- (HHFloatButton *)createFloatButtonWithTitle:(NSString *)title {
    HHFloatButton *button = [[HHFloatButton alloc] initWithTitle:title frame:CGRectMake(CGRectGetWidth(self.view.bounds)-100.0f, CGRectGetHeight(self.view.bounds)-90.0f, 90, 25) backgroundColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(floatButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             
                             ];
    [self.view addConstraints:constraints];
}

- (void)floatButtonPressed:(id)sender {
    HHFloatButton *button = sender;
    NSString *buttonTitle = button.titleLabel.text;
    [button setTitle:self.floatSortButton.titleLabel.text forState:UIControlStateNormal];
    [self.floatSortButton setTitle:buttonTitle forState:UIControlStateNormal];
    self.currentSortOption = [self stringToEnum:buttonTitle];
    [self popupFloatButtons];
}

- (SortOption)stringToEnum:(NSString *)string {
    SortOption selectedOption = SortOptionSmartSort;
    
    if ([string isEqualToString:kSmartSortString]) {
        selectedOption = SortOptionSmartSort;
        
    } else if ([string isEqualToString:kMostRatingString]) {
        selectedOption = SortOptionMostRating;
        
    } else if ([string isEqualToString:kLowestPriceString]) {
        selectedOption = SortOptionLowestPrice;
        
    } else if ([string isEqualToString:kBestRatingString]) {
        selectedOption = SortOptionBestRating;
    }
    
    return selectedOption;

}

- (void)popupFloatButtons {
    if (self.overlay) {
        [self.overlay removeFromSuperview];
        self.overlay = nil;
        [self floatButtonAnimateUp:NO];
    } else {
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        [self.overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayTapped)];
        [self.overlay addGestureRecognizer:recognizer];
        [self.view insertSubview:self.overlay belowSubview:self.firstSortButton];
        [self floatButtonAnimateUp:YES];
    
    }
}

- (void)overlayTapped {
    [self popupFloatButtons];
}

- (void)floatButtonAnimateUp:(BOOL)isUp {
    int i =0;
    for (HHFloatButton *button in self.floatButtonsArray) {
        POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
        springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
        CGRect newFrame = button.frame;
        if (isUp) {
            newFrame.origin.y = newFrame.origin.y - 50.0f * i;
             springAnimation.springBounciness = 10.0f;
        } else {
            newFrame.origin.y = newFrame.origin.y + 50.0f * i;
             springAnimation.springBounciness = 0;
        }
        springAnimation.toValue = [NSValue valueWithCGRect:newFrame];
        springAnimation.name = @"floatButtonPopup";
        springAnimation.delegate = self;
        [button pop_addAnimation:springAnimation forKey:@"floatButtonPopup"];
        i++;
    }
}

- (void)dropDownButtonAnimateDown:(BOOL)isDown button:(HHDropDownButton *)button {
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    CGFloat offsetY = 0;
    if ([button isEqual:self.firstDropDownButton]) {
        offsetY = 64.0f;
    } else {
        offsetY = 64.0f * 2;
    }
    CGRect newFrame = button.frame;
    if (isDown) {
        newFrame.origin.y = newFrame.origin.y + offsetY;
        springAnimation.springBounciness = 10.0f;
    } else {
        newFrame.origin.y = newFrame.origin.y - offsetY;
        springAnimation.springBounciness = 0;
    }
    springAnimation.toValue = [NSValue valueWithCGRect:newFrame];
    springAnimation.name = @"floatButtonPopup";
    springAnimation.delegate = self;
    [button pop_addAnimation:springAnimation forKey:@"dropDown"];
    button.hidden = !button.hidden;

}



@end
