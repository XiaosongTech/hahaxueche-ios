//
//  HHClusterAnnotionView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 17/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHClusterAnnotionView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHClusterAnnotionView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 60.0f, 60.0f);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 30.0f;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 2.0f/[UIScreen mainScreen].scale;
        self.backgroundColor = [UIColor colorWithRed:0.99 green:0.34 blue:0.35 alpha:0.8f];
        
        self.countLabel = [[UILabel alloc] init];
        self.countLabel.textColor = [UIColor whiteColor];
        self.countLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.countLabel];
        [self.countLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.centerY).offset(3.0f);
            make.centerX.equalTo(self.centerX);
        }];
        
        self.zoneLabel = [[UILabel alloc] init];
        self.zoneLabel.textColor = [UIColor whiteColor];
        self.zoneLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.zoneLabel];
        [self.zoneLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.centerY);
            make.centerX.equalTo(self.centerX);
        }];
        
        UITapGestureRecognizer *tagRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        [self addGestureRecognizer:tagRec];
    }
    return self;
}

- (void)viewTapped {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

@end
