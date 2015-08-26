//
//  HHReviewTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/2/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHStarRatingView.h"
#import <Foundation/Foundation.h>

typedef void (^ReviewTapped)(NSInteger index);

@interface HHReviewTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HHStarRatingView *ratingView;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSArray *reviews;
@property (nonatomic, strong) NSMutableArray *reviewViewsArray;
@property (nonatomic, strong) ReviewTapped reviewTappedBlock;

- (void)setupRatingView:(NSNumber *)rating;
- (void)setupReviewViews:(NSArray *)reviews;




@end
