//
//  HHSortOptionView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/15/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSortOptionView.h"

@implementation HHSortOptionView

- (instancetype)initWithTilte:(NSString *)title image:(UIImage *)image highlightImage:(UIImage *)highlightImage {
    self = [super init];
    if (self) {
        self.image = image;
        self.highlightImage = highlightImage;
        
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.titleLabel sizeToFit];
        [self addSubview:self.titleLabel];
        
        [self makeConstraints];
    }
    
    return self;
}

- (void)makeConstraints {
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.centerY.equalTo(self.centerY);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right);
        make.centerY.equalTo(self.imageView.centerY);
    }];
}

- (void)setupView:(BOOL)highlight {
    if (highlight) {
        self.imageView.image = self.highlightImage;
        self.titleLabel.textColor = [UIColor HHOrange];
    } else {
        self.imageView.image = self.image;
        self.titleLabel.textColor = [UIColor HHLightTextGray];
    }
}



@end
