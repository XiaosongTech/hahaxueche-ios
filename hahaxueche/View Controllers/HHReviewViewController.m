//
//  HHReviewViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/3/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHReviewViewController.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "HHFullReviewTableViewCell.h"
#import "HHCoachService.h"
#import "HHReviewService.h"

#define kReviewCellId @"kReviewCellId"

@interface HHReviewViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic)         BOOL shouldFetchMore;

@end

@implementation HHReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.shouldFetchMore = YES;
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blur_background"]];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.backgroundImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@个学员评价", nil), [self.coach.totalReviewAmount stringValue]];
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel sizeToFit];
    [self.view addSubview:self.titleLabel];
    
    self.line = [[UIView alloc] initWithFrame:CGRectZero];
    self.line.translatesAutoresizingMaskIntoConstraints = NO;
    self.line.backgroundColor = [UIColor HHGrayLineColor];
    [self.view addSubview:self.line];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HHFullReviewTableViewCell class] forCellReuseIdentifier:kReviewCellId];
    [self.view addSubview:self.tableView];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cancelButton setImage:[UIImage imageNamed:@"x_button"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton sizeToFit];
    [self.view addSubview:self.cancelButton];
    
    [self autoLayoutSubviews];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.initialIndex inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterX:self.backgroundImageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterY:self.backgroundImageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.backgroundImageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.backgroundImageView multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility setCenterX:self.titleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.titleLabel constant:40.0f],
                             [HHAutoLayoutUtility setViewWidth:self.titleLabel multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.line constant:15.0f],
                             [HHAutoLayoutUtility verticalNext:self.line toView:self.titleLabel constant:20.0f],
                             [HHAutoLayoutUtility setViewWidth:self.line multiplier:1.0f constant:-30.0f],
                             [HHAutoLayoutUtility setViewHeight:self.line multiplier:0 constant:0.5f],
                             
                             [HHAutoLayoutUtility setCenterX:self.tableView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.tableView toView:self.line constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.tableView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.tableView constant:-60.0f],
                             
                             
                             [HHAutoLayoutUtility setCenterX:self.cancelButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalNext:self.cancelButton toView:self.tableView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.cancelButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.cancelButton multiplier:0 constant:60.0f],
                             
                             ];
    [self.view addConstraints:constraints];
}


- (void)cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma -mark TableView Delegate & Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHFullReviewTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kReviewCellId forIndexPath:indexPath];
    [cell setupViews:self.reviews[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHReview *review = self.reviews[indexPath.row];
    CGRect rect = [review.comment boundingRectWithSize:CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds])-75.0f, MAXFLOAT)
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{ NSFontAttributeName: [UIFont fontWithName:@"STHeitiSC-Light" size:13.0f]}
                                                                 context:nil];
    return CGRectGetHeight(rect) + 80.0f;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= 0) {
        if (!self.shouldFetchMore) {
            return;
        }
        [[HHReviewService sharedInstance] fetchReviewsForCoach:self.coach.coachId skip:self.reviews.count completion:^(NSArray *objects, NSInteger totalCount, NSError *error) {
            if (!error) {
                [self.reviews addObjectsFromArray:objects];
                if (self.reviews.count == totalCount) {
                    self.shouldFetchMore = NO;
                }
                [self.tableView reloadData];
            }
        }];
    }
}

@end
