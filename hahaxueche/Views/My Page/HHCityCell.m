//
//  HHCityCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/6/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCityCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHCityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.label = [[UILabel alloc] init];
        self.label.textColor = [UIColor HHTextDarkGray];
        self.label.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.label];
        
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(20.0f);
            make.centerY.equalTo(self.contentView.centerY);
        }];
        
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = [UIColor HHLightLineGray];
        [self.contentView addSubview:self.line];
        
        [self.line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left);
            make.bottom.equalTo(self.contentView.bottom);
            make.width.equalTo(self.contentView.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
        
    }
    return self;
}


@end
