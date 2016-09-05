//
//  HHShareViewItem.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHShareViewItem.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

static CGFloat const kImageRadius = 25.0f;

@implementation HHShareViewItem

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = kImageRadius;
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        self.titleLabel.textColor = [UIColor HHLightTextGray];
        [self addSubview:self.titleLabel];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(10.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.bottom).offset(5.0f);
        make.centerX.equalTo(self.imageView.centerX);
    }];
}

@end
