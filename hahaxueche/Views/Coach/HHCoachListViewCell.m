//
//  HHCoachListViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCoachListViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIView+HHRect.h"
#import "HHFormatUtility.h"
#import "NSNumber+HHNumber.h"
#import <UIImageView+WebCache.h>

static CGFloat const kAvatarRadius = 30.0f;

@implementation HHCoachListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return  self;
}

- (void)initSubviews {
    self.avatarView = [[UIImageView alloc] init];
    self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarView.layer.cornerRadius = kAvatarRadius;
    self.avatarView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.avatarView];
    
    self.nameLabel = [self createLabelWithFont:[UIFont systemFontOfSize:20.0f] textColor:[UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1]];
    [self.nameLabel sizeToFit];
    [self.contentView addSubview:self.nameLabel];
    
    self.goldenCoachIcon = [[UIImageView alloc] init];
    self.goldenCoachIcon.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:self.goldenCoachIcon];
    
    self.trainingYearLabel = [self createLabelWithFont:[UIFont systemFontOfSize:16.0f] textColor:[UIColor HHLightTextGray]];
    [self.trainingYearLabel sizeToFit];
    [self.contentView addSubview:self.trainingYearLabel];
    
    self.priceLabel = [self createLabelWithFont:[UIFont systemFontOfSize:20.0f] textColor:[UIColor HHOrange]];
    [self.priceLabel sizeToFit];
    [self.contentView addSubview:self.priceLabel];
    
    self.marketPriceLabel = [[UILabel alloc] init];;
    [self.contentView addSubview:self.marketPriceLabel];
    
    self.starRatingView = [[HHStarRatingView alloc] initWithInteraction:NO];
    self.starRatingView.value = 5.0;
    [self.contentView addSubview:self.starRatingView];
    
    self.ratingLabel = [self createLabelWithFont:[UIFont systemFontOfSize:14.0f] textColor:[UIColor HHOrange]];
    [self.contentView addSubview:self.ratingLabel];
    
    self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat insetAmount = 5.0f;
    self.mapButton.imageEdgeInsets = UIEdgeInsetsMake(0, -insetAmount, 0, insetAmount);
    self.mapButton.titleEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, -insetAmount);
    self.mapButton.contentEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, insetAmount);
    [self.mapButton setImage:[UIImage imageNamed:@"ic_list_local_btn"] forState:UIControlStateNormal];
    [self.mapButton setTitleColor:[UIColor HHLightTextGray] forState:UIControlStateNormal];
    self.mapButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.mapButton sizeToFit];
    [self.mapButton addTarget:self action:@selector(mapButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.mapButton];
    
    self.mapView = [[MAMapView alloc] init];
    self.mapView.hidden = YES;
    self.mapView.delegate = self;
    self.mapView.layer.cornerRadius = 5.0f;
    self.mapView.layer.masksToBounds = YES;
    self.mapView.layer.borderColor = [UIColor HHOrange].CGColor;
    self.mapView.layer.borderWidth = 2.0f/[UIScreen mainScreen].scale;
    self.mapView.userInteractionEnabled = NO;
    [self.contentView addSubview:self.mapView];
    [self.contentView bringSubviewToFront:self.mapView];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor HHLightLineGray];
    [self.contentView addSubview:self.bottomLine];
    
    [self makeConstraints];
    
}

- (void)makeConstraints {
    [self.avatarView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(20.0f);
        make.left.equalTo(self.contentView.left).offset(15.0f);
        make.width.mas_equalTo(kAvatarRadius * 2.0f);
        make.height.mas_equalTo(kAvatarRadius * 2.0f);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.right).offset(15.0f);
        make.top.equalTo(self.contentView.top).offset(16.0f);
    }];
    
    [self.starRatingView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.top.equalTo(self.nameLabel.bottom).offset(3.0f);
        make.height.mas_equalTo(20.0f);
        make.width.mas_equalTo(100.0f);
    }];
    
    [self.ratingLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starRatingView.right).offset(3.0f);
        make.centerY.equalTo(self.starRatingView.centerY);
    }];
    
    [self.mapButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left).offset(3.0f);
        make.top.equalTo(self.starRatingView.bottom).offset(5.0f);
    }];
    
    [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatarView.centerY).offset(-12.0f);
        make.right.equalTo(self.contentView.right).offset(-15.0f);
    }];
    
    [self.marketPriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatarView.centerY).offset(12.0f);
        make.right.equalTo(self.contentView.right).offset(-15.0f);
    }];
    
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapButton.bottom).offset(5.0f);
        make.left.equalTo(self.contentView.left).offset(15.0f);
        make.width.equalTo(self.contentView.width).offset(-30.0f);
        make.height.mas_equalTo(200.0f);
    }];
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom);
        make.left.equalTo(self.avatarView.right).offset(15.0f);
        make.right.equalTo(self.contentView.right);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
}


- (UILabel *)createLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)mapButtonTapped {
    if (self.mapButtonBlock) {
        self.mapButtonBlock();
    }

    MACoordinateRegion mapRegion;
    mapRegion.span.latitudeDelta = 0.05;
    mapRegion.span.longitudeDelta = 0.05;
    mapRegion.center = CLLocationCoordinate2DMake([self.field.latitude doubleValue], [self.field.longitude doubleValue]);
    
    [self.mapView setRegion:mapRegion animated: YES];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([self.field.latitude doubleValue], [self.field.longitude doubleValue]) animated:NO];
    
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([self.field.latitude doubleValue], [self.field.longitude doubleValue]);
    pointAnnotation.title = self.field.name;
    pointAnnotation.subtitle = self.field.address;
    [self.mapView addAnnotation:pointAnnotation];
}

- (void)setupCellWithCoach:(HHCoach *)coach field:(HHField *)field {
    self.field = field;
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f分",[coach.averageRating floatValue]];;
    [self.mapButton setTitle:[field cityAndDistrict] forState:UIControlStateNormal];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:coach.avatarUrl]];
    self.nameLabel.text = coach.name;
    self.trainingYearLabel.text = [NSString stringWithFormat:@"%@年教龄", [coach.experienceYear stringValue]];
    if ([coach isGoldenCoach]) {
        self.goldenCoachIcon.hidden = NO;
        self.goldenCoachIcon.image = [UIImage imageNamed:@"ic_auth_golden"];
        [self.goldenCoachIcon remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.right).offset(3.0f);
            make.centerY.equalTo(self.nameLabel.centerY);
        }];
        
        [self.trainingYearLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goldenCoachIcon.right).offset(3.0f);
            make.bottom.equalTo(self.nameLabel.bottom);
        }];
    } else {
         self.goldenCoachIcon.hidden = YES;
        [self.trainingYearLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.right).offset(5.0f);
            make.bottom.equalTo(self.nameLabel.bottom);
        }];
    }
    self.starRatingView.value = [coach.averageRating floatValue];
    
    
    self.priceLabel.text = [coach.price generateMoneyString];
    
    self.marketPriceLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:[coach.marketPrice generateMoneyString] attributes:@{NSStrikethroughStyleAttributeName:@(1), NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    
    [self.marketPriceLabel sizeToFit];
}

#pragma mark - MapView Delegate Methods

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    } else {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (!annotationView) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"ic_map_local_choseon"];
        annotationView.canShowCallout = YES;
        return annotationView;
        
    }
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (MAAnnotationView *view in views) {
        if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
            continue;
        }
        [mapView selectAnnotation:view.annotation animated:NO];
    }
}


@end
