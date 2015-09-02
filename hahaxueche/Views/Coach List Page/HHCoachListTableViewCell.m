//
//  HHCoachListTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/10/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachListTableViewCell.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import <pop/POP.h>
#import "UIColor+HHColor.h"
#import <QuartzCore/QuartzCore.h>
#import "HHFormatUtility.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CMPopTipView.h"
#import <MapKit/MapKit.h>


#define kDataViewBackgroundColor [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1]
#define kAvatarRadius 30.0f

@interface HHCoachListTableViewCell ()<CMPopTipViewDelegate>

@end

@implementation HHCoachListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self initSubviews];
        [self autoLayoutSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.dataView = [[UIView alloc] initWithFrame:CGRectZero];
    self.dataView.translatesAutoresizingMaskIntoConstraints = NO;
    self.dataView.backgroundColor = [UIColor whiteColor];
    self.dataView.layer.cornerRadius = 5.0f;
    self.dataView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.dataView];
    
    self.avatarView = [[HHAvatarView alloc] initWithImageURL:nil radius:kAvatarRadius borderColor:[UIColor whiteColor]];
    self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dataView addSubview:self.avatarView];
    
    self.nameLabel = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:15] color:[UIColor blackColor]];
    self.addressLabel = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:12] color:[UIColor grayColor]];
    UITapGestureRecognizer *tapAddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLocation)];
    [self.addressLabel addGestureRecognizer:tapAddress];
    self.addressLabel.userInteractionEnabled = YES;
    self.priceLabel = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:12] color:[UIColor darkTextColor]];
    self.actualPriceLabel = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:16] color:[UIColor HHOrange]];
    
    self.locationPin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_icon"]];
    self.locationPin.translatesAutoresizingMaskIntoConstraints = NO;
    UITapGestureRecognizer *tapPin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLocation)];
    [self.locationPin addGestureRecognizer:tapPin];
    self.locationPin.userInteractionEnabled = YES;
    [self.dataView addSubview:self.locationPin];
    
    self.ratingView = [[HHStarRatingView alloc] initWithFrame:CGRectZero rating:0];
    self.ratingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dataView addSubview:self.ratingView];
    
    NSMutableAttributedString * yearString = [self generateAttributedStringWithString:@"10 " font:[UIFont fontWithName:@"STHeitiSC-Medium" size:14] color:[UIColor blackColor]];
    
    [yearString appendAttributedString:[self generateAttributedStringWithString:NSLocalizedString(@"年教龄", nil) font:[UIFont fontWithName:@"STHeitiSC-Light" size:12] color:[UIColor blackColor]]];
    
    
    self.teachedYearLabel = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:14] color:[UIColor blackColor]];
    
    self.teachedStudentAmount = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:14] color:[UIColor blackColor]];
    
    self.ratingLabel = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:12] color:[UIColor HHOrange]];
}

- (NSMutableAttributedString *)generateAttributedStringWithString:(NSString *)title font:(UIFont *)font color:(UIColor *)color {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

- (UILabel *)createLabelWithFont:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = font;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    [self.dataView addSubview:label];
    return label;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.dataView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.dataView constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.dataView multiplier:1.0f constant:-8.0f],
                             [HHAutoLayoutUtility setViewWidth:self.dataView multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.avatarView constant:10.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.avatarView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.avatarView multiplier:0 constant:kAvatarRadius*2],
                             [HHAutoLayoutUtility setViewWidth:self.avatarView multiplier:0 constant:kAvatarRadius*2],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.nameLabel constant:12.0f],
                             [HHAutoLayoutUtility horizontalNext:self.nameLabel toView:self.avatarView constant:10.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.locationPin constant:10.0f],
                             [HHAutoLayoutUtility horizontalNext:self.locationPin toView:self.nameLabel constant:8.0f],
                             [HHAutoLayoutUtility setViewHeight:self.locationPin multiplier:0 constant:17.5f],
                             [HHAutoLayoutUtility setViewWidth:self.locationPin multiplier:0 constant:11.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.addressLabel constant:13.0f],
                             [HHAutoLayoutUtility horizontalNext:self.addressLabel toView:self.locationPin constant:4.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.actualPriceLabel constant:11.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.actualPriceLabel constant:-10.0f],
                             [HHAutoLayoutUtility verticalNext:self.priceLabel toView:self.actualPriceLabel constant:3.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.priceLabel constant:-10.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.ratingView toView:self.nameLabel constant:6.0f],
                             [HHAutoLayoutUtility horizontalNext:self.ratingView toView:self.avatarView constant:9.0f],
                             [HHAutoLayoutUtility setViewHeight:self.ratingView multiplier:0 constant:15.0f],
                             [HHAutoLayoutUtility setViewWidth:self.ratingView multiplier:0 constant:90.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.ratingLabel toView:self.ratingView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.ratingLabel toView:self.ratingView constant:5.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.teachedYearLabel toView:self.ratingView constant:8.0f],
                             [HHAutoLayoutUtility horizontalNext:self.teachedYearLabel toView:self.avatarView constant:10.0f],

                             [HHAutoLayoutUtility setCenterY:self.teachedStudentAmount toView:self.teachedYearLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.teachedStudentAmount toView:self.teachedYearLabel constant:15.0f],
                             
                            ];
    [self.contentView addConstraints:constraints];
}

- (void)showLocation {
    if (self.addressBlock) {
        self.addressBlock();
    }
}

- (void)setupCellWithCoach:(HHCoach *)coach {
    AVFile *file = [AVFile fileWithURL:coach.avatarURL];
    NSString *thumbnailString = [file getThumbnailURLWithScaleToFit:YES width:kAvatarRadius * 4 height:kAvatarRadius * 4 quality:100 format:@"png"];
    [self.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:thumbnailString] placeholderImage:nil];
    
    self.nameLabel.text = coach.fullName;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[[HHFormatUtility moneyFormatter] stringFromNumber:coach.price]];
    [attributeString addAttributes:@{NSStrikethroughStyleAttributeName:@(1), NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:12], NSForegroundColorAttributeName:[UIColor darkTextColor]} range:NSMakeRange(0, [attributeString length])];
    self.priceLabel.attributedText = attributeString;;
    self.actualPriceLabel.text = [[HHFormatUtility moneyFormatter] stringFromNumber:coach.actualPrice];
    self.ratingView.value =[coach.averageRating floatValue];
    self.ratingLabel.text = [[HHFormatUtility floatFormatter] stringFromNumber:coach.averageRating];;
    
    NSMutableAttributedString * yearString = [self generateAttributedStringWithString:coach.experienceYear font:[UIFont fontWithName:@"STHeitiSC-Medium" size:14] color:[UIColor blackColor]];
    [yearString appendAttributedString:[self generateAttributedStringWithString:NSLocalizedString(@"年教龄", nil) font:[UIFont fontWithName:@"STHeitiSC-Light" size:12] color:[UIColor blackColor]]];
    self.teachedYearLabel.attributedText = yearString;
    
    NSMutableAttributedString * studentAmountString = [self generateAttributedStringWithString:NSLocalizedString(@"累计通过", nil) font:[UIFont fontWithName:@"STHeitiSC-Light" size:12] color:[UIColor blackColor]];
    [studentAmountString appendAttributedString:[self generateAttributedStringWithString:[coach.passedStudentAmount stringValue] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:14] color:[UIColor blackColor]]];
    [studentAmountString appendAttributedString:[self generateAttributedStringWithString:NSLocalizedString(@"名学员",nil) font:[UIFont fontWithName:@"STHeitiSC-Light" size:12] color:[UIColor blackColor]]];
    self.teachedStudentAmount.attributedText = studentAmountString;
}

- (void)setupAddressViewWithTitle:(NSString *)title {
    self.addressLabel.text = title;
}


@end
