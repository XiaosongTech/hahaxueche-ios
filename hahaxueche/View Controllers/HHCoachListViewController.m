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

@interface HHCoachListViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UILabel *label;

@end

@implementation HHCoachListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"找教练";
    self.view.backgroundColor = [UIColor clearColor];
    [self initSubviews];
}

-(void)initSubviews {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    //[self.view addSubview:self.searchBar];
    
    self.navigationItem.rightBarButtonItem = [HHBarButtonItemUtility buttonItemWithImage:[UIImage imageNamed:@"location"] action:nil];
    
    //[self autoLayoutSubviews];
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.searchBar constant:10.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.searchBar constant:5.0f],
                             [HHAutoLayoutUtility setViewWidth:self.searchBar multiplier:1.0f constant:-10.0f],
                             ];
    [self.view addConstraints:constraints];
}





@end
