//
//  HHPriceItemCollectionViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 24/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPriceItemCollectionViewCell.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHPriceItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.label = [[UILabel alloc] init];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.numberOfLines = 1;
        self.label.font = [UIFont systemFontOfSize:13.0f];
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.minimumScaleFactor = 0.5;
        self.label.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.label];
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.equalTo(self.contentView.width).offset(-10.0f);
            make.height.equalTo(self.contentView.height);
        }];
        
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor =[UIColor HHLightLineGray].CGColor;
    }
    return self;
}

@end
