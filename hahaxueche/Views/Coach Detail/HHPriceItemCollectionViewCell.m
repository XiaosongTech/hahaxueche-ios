//
//  HHPriceItemCollectionViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 24/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPriceItemCollectionViewCell.h"
#import "Masonry.h"

@implementation HHPriceItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.label = [[UILabel alloc] init];
        self.label.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:self.label];
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.equalTo(self.contentView.width);
            make.height.equalTo(self.contentView.height);
        }];
    }
    return self;
}

@end
