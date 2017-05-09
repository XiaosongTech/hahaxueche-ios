//
//  HHSchoolReviewTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 08/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHDrivingSchool.h"
#import "HHReviews.h"

typedef void (^HHReviewsBlock)();

@interface HHSchoolReviewTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) HHDrivingSchool *school;
@property (nonatomic, strong) NSMutableArray *reviewViewArray;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) HHReviewsBlock reviewsBlock;

- (void)setupCellWithSchool:(HHDrivingSchool *)school reviews:(HHReviews *)reviews;


@end
