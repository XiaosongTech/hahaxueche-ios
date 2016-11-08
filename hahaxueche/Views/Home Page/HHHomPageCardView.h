//
//  HHHomPageCardView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHHomePageItemView.h"

typedef void (^HHHomePageItemBlock)();

@interface HHHomPageCardView : UIView

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title subTitle:(NSMutableAttributedString *)subTitle bigIcon:(UIImage *)bigIcon items:(NSArray *)items dotColor:(UIColor *)dotColor;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *bigIconView;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) HHHomePageItemView *firstItem;
@property (nonatomic, strong) HHHomePageItemView *secItem;
@property (nonatomic, strong) HHHomePageItemView *thirdItem;
@property (nonatomic, strong) HHHomePageItemView *forthItem;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) UIView *botContainerView;

@property (nonatomic, strong) HHHomePageItemBlock tapAction;

@end
