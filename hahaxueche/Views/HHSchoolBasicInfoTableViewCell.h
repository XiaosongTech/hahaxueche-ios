//
//  HHSchoolBasicInfoTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 04/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import "HHDrivingSchool.h"
#import "HHSchoolGenericView.h"

typedef void (^HHSchoolBasicBlock)();
typedef void (^HHSchoolBasicExpandBlock)(BOOL expand);

@interface HHSchoolBasicInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *consultNumLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *priceNotiLabel;
@property (nonatomic, strong) FLAnimatedImageView *bellView;
@property (nonatomic, strong) UILabel *fieldLabel;
@property (nonatomic, strong) UILabel *checkFieldLabel;
@property (nonatomic, strong) UILabel *schoolDesTitleLabel;
@property (nonatomic, strong) UILabel *schoolDesLabel;

@property (nonatomic, strong) UIView *firstSecView;
@property (nonatomic, strong) UIView *secSecView;
@property (nonatomic, strong) UIView *thirdSecView;
@property (nonatomic, strong) UIView *forthSecView;
@property (nonatomic, strong) UIView *fifthSecView;

@property (nonatomic, strong) HHDrivingSchool *school;

@property (nonatomic, strong) HHSchoolGenericView *passRateView;
@property (nonatomic, strong) HHSchoolGenericView *satisView;
@property (nonatomic, strong) HHSchoolGenericView *coachCountView;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *desTitleLabel;
@property (nonatomic, strong) UIButton *showMoreLessButton;

@property (nonatomic) BOOL expanded;

@property (nonatomic, strong) HHSchoolBasicExpandBlock showMoreLessBlock;
@property (nonatomic, strong) HHSchoolBasicBlock fieldBlock;
@property (nonatomic, strong) HHSchoolBasicBlock priceNotifBlock;

- (void)setupCellWithSchool:(HHDrivingSchool *)school;

@end
