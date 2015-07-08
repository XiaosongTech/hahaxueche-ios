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

typedef enum : NSUInteger {
    SortOptionSmartSort,
    SortOptionLowestPrice,
    SortOptionBestRating,
    SortOptionMostRating,
} SortOption;

#define kSmartSortString @"智能排序"
#define kBestRatingString @"评价最好"
#define kMostRatingString @"评价最多"
#define kLowestPriceString @"价格最低"


@interface HHCoachListViewController ()

@property (nonatomic, strong) HHFloatButton *floatSortButton;
@property (nonatomic, strong) UIView *overlay;
@property (nonatomic, strong) NSMutableArray *floatButtonsArray;
@property (nonatomic)         SortOption currentSortOption;

@end

@implementation HHCoachListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"找教练";
    self.view.backgroundColor = [UIColor clearColor];
    [self initSubviews];
}

-(void)initSubviews {
    
    self.overlay = [[UIView alloc] initWithFrame:CGRectZero];
    self.overlay.translatesAutoresizingMaskIntoConstraints = 0;
    [self.overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    self.overlay.hidden = YES;
    [self.view addSubview:self.overlay];
    
    [self initFloatButtons];
    [self autoLayoutSubviews];
}

- (void)initFloatButtons {
    
    self.currentSortOption = SortOptionSmartSort;
    HHFloatButton *firstButton = [[HHFloatButton alloc] initWithTitle:kLowestPriceString frame:CGRectMake(CGRectGetWidth(self.view.bounds)-100.0f, CGRectGetHeight(self.view.bounds)-90.0f, 90, 25) backgroundColor:[UIColor whiteColor]];
    [firstButton addTarget:self action:@selector(floatButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstButton];
    
    HHFloatButton *secondButton = [[HHFloatButton alloc] initWithTitle:kBestRatingString frame:CGRectMake(CGRectGetWidth(self.view.bounds)-100.0f, CGRectGetHeight(self.view.bounds)-90.0f, 90, 25) backgroundColor:[UIColor whiteColor]];
    [secondButton addTarget:self action:@selector(floatButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secondButton];
    
    HHFloatButton *thirdButton = [[HHFloatButton alloc] initWithTitle:kMostRatingString frame:CGRectMake(CGRectGetWidth(self.view.bounds)-100.0f, CGRectGetHeight(self.view.bounds)-90.0f, 90, 25) backgroundColor:[UIColor whiteColor]];
    [thirdButton addTarget:self action:@selector(floatButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:thirdButton];
    
    self.floatSortButton = [[HHFloatButton alloc] initWithTitle:kSmartSortString frame:CGRectMake(CGRectGetWidth(self.view.bounds)-100.0f, CGRectGetHeight(self.view.bounds)-90.0f, 90, 25) backgroundColor:[UIColor HHOrange]];
    [self.view addSubview:self.floatSortButton];
    [self.floatSortButton addTarget:self action:@selector(popupFloatButtons) forControlEvents:UIControlEventTouchUpInside];
    
    self.floatButtonsArray = [NSMutableArray arrayWithArray:@[self.floatSortButton, firstButton, secondButton, thirdButton]];
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.overlay constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.overlay constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.overlay multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.overlay multiplier:1.0f constant:0],
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
    if (self.overlay.hidden) {
        self.overlay.hidden = NO;
        [self floatButtonAnimateUp:YES];
    } else {
        self.overlay.hidden = YES;
        [self floatButtonAnimateUp:NO];
    
    }
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
        springAnimation.delegate=self;
        [button pop_addAnimation:springAnimation forKey:@"floatButtonPopup"];
        i++;
    }
}



@end
