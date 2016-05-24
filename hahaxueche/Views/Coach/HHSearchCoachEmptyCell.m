//
//  HHSearchCoachEmptyCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 5/24/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSearchCoachEmptyCell.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHSearchCoachEmptyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] init];
        label.text = @"抱歉, 没有找到教练";
        label.textColor = [UIColor HHLightTextGray];
        label.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:label];
        
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return  self;
}

@end
