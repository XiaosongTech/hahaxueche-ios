//
//  HHSchoolGenericView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 04/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHSchoolGenericView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHSchoolGenericView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.leftLabel = [[UILabel alloc] init];
        self.leftLabel.textColor = [UIColor HHTextDarkGray];
        self.leftLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.leftLabel];
        [self.leftLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.centerY.equalTo(self.centerY);
        }];
        
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.textColor = [UIColor HHOrange];
        self.rightLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.rightLabel];
        [self.rightLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel.right).offset(5.0f);
            make.centerY.equalTo(self.centerY);
        }];
    }
    return self;
}

- (void)setupViewWithLeftText:(NSString *)leftText rightText:(NSString *)rightText {
    self.leftLabel.text = leftText;
    self.rightLabel.text = rightText;
}

@end
