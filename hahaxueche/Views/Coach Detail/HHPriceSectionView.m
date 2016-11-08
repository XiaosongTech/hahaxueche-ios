//
//  HHPriceSectionView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 29/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPriceSectionView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHPriceItemView.h"
#import "HHPersonalCoachPrice.h"

@implementation HHPriceSectionView

- (instancetype)initWithTitle:(NSString *)title price:(NSNumber *)price VIPPrice:(NSNumber *)VIPPrice {
    self = [super init];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor HHOrange];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20.0f);
            make.top.equalTo(self.top).offset(15.0f);
        }];
        
        self.questionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.questionButton.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [self.questionButton setTitle:@"?" forState:UIControlStateNormal];
        [self.questionButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
        [self.questionButton setBackgroundColor:[UIColor HHBackgroundGary]];
        self.questionButton.layer.masksToBounds = YES;
        self.questionButton.layer.borderColor = [UIColor HHLightLineGray].CGColor;
        self.questionButton.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        self.questionButton.layer.cornerRadius = 3.0f;
        [self.questionButton addTarget:self action:@selector(questionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.questionButton];
        [self.questionButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.right).offset(5.0f);
            make.centerY.equalTo(self.titleLabel.centerY);
            make.width.mas_equalTo(15.0f);
            make.height.mas_equalTo(15.0f);
        }];
        
        if ([price floatValue] > 0 && [VIPPrice floatValue] > 0) {
            HHPriceItemView *item = [[HHPriceItemView alloc] init];
            [item setupWithPrice:price productText:@"超值班" detailText:@"四人一车, 高性价比" priceColor:[UIColor HHDarkOrange] showBotLine:YES];
            [self addSubview:item];
            [item makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.top).offset(35.0f);
                make.left.equalTo(self.titleLabel.left);
                make.right.equalTo(self.right);
                make.height.mas_equalTo(50.0f);
            }];
            
            HHPriceItemView *item2 = [[HHPriceItemView alloc] init];
            [item2 setupWithPrice:VIPPrice productText:@"VIP班" detailText:@"一人一车, 极速拿证" priceColor:[UIColor colorWithRed:1.00 green:0.80 blue:0.21 alpha:1.00] showBotLine:NO];
            [self addSubview:item2];
            [item2 makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(item.bottom);
                make.left.equalTo(self.titleLabel.left);
                make.right.equalTo(self.right);
                make.height.mas_equalTo(50.0f);
            }];
        } else if ([price floatValue] > 0) {
            HHPriceItemView *item = [[HHPriceItemView alloc] init];
            [item setupWithPrice:price productText:@"超值班" detailText:@"四人一车, 高性价比" priceColor:[UIColor HHDarkOrange] showBotLine:NO];
            [self addSubview:item];
            [item makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.top).offset(35.0f);
                make.left.equalTo(self.titleLabel.left);
                make.right.equalTo(self.right);
                make.height.mas_equalTo(50.0f);
            }];
        } else {
            HHPriceItemView *item2 = [[HHPriceItemView alloc] init];
            [item2 setupWithPrice:VIPPrice productText:@"VIP班" detailText:@"一人一车, 极速拿证" priceColor:[UIColor colorWithRed:1.00 green:0.80 blue:0.21 alpha:1.00] showBotLine:NO];
            [self addSubview:item2];
            [item2 makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.top).offset(35.0f);
                make.left.equalTo(self.titleLabel.left);
                make.right.equalTo(self.right);
                make.height.mas_equalTo(50.0f);
            }];
        }
    }
    
    self.botLine = [[UIView alloc] init];
    self.botLine.backgroundColor = [UIColor HHLightLineGray];
    [self addSubview:self.botLine];
    [self.botLine makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.width);
        make.left.equalTo(self.left);
        make.bottom.equalTo(self.bottom);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    return self;
}

- (instancetype)initWithTitle:(NSString *)title prices:(NSArray *)prices {
    self = [super init];
    if (self) {
        self.priceViewArray = [NSMutableArray array];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor HHOrange];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20.0f);
            make.top.equalTo(self.top).offset(15.0f);
        }];
        
        self.questionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.questionButton.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [self.questionButton setTitle:@"?" forState:UIControlStateNormal];
        [self.questionButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
        [self.questionButton setBackgroundColor:[UIColor HHBackgroundGary]];
        self.questionButton.layer.masksToBounds = YES;
        self.questionButton.layer.borderColor = [UIColor HHLightLineGray].CGColor;
        self.questionButton.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        self.questionButton.layer.cornerRadius = 3.0f;
        [self.questionButton addTarget:self action:@selector(questionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.questionButton];
        [self.questionButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.right).offset(5.0f);
            make.centerY.equalTo(self.titleLabel.centerY);
            make.width.mas_equalTo(15.0f);
            make.height.mas_equalTo(15.0f);
        }];
        
        for (HHPriceItemView *view in self.priceViewArray) {
            [view removeFromSuperview];
        }
        
        [self.priceViewArray removeAllObjects];
        
        int i = 0;
        for (HHPersonalCoachPrice *price in prices) {
            BOOL showBotLine = YES;
            if (i == prices.count - 1) {
                showBotLine = NO;
            }
            HHPriceItemView *item = [[HHPriceItemView alloc] init];
            [item setupWithPrice:price.price productText:[NSString stringWithFormat:@"%@小时", [price.duration stringValue]] detailText:price.des priceColor:[UIColor HHOrange] showBotLine:showBotLine];
            [self addSubview:item];
            [self.priceViewArray addObject:item];
            
            [item makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.top).offset(35.0f + i * 50.0f);
                make.left.equalTo(self.left);
                make.width.equalTo(self.width);
                make.height.mas_equalTo(50.0f);
            }];
            i++;
        }
        
        self.botLine = [[UIView alloc] init];
        self.botLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.botLine];
        [self.botLine makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.width);
            make.left.equalTo(self.left);
            make.bottom.equalTo(self.bottom);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];

    }
    return self;
}

- (void)questionButtonTapped {
    if (self.questionAction) {
        self.questionAction();
    }
}

@end
