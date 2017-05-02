//
//  HHDrivingSchoolListViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 02/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHDrivingSchoolListViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"


@implementation HHDrivingSchoolListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return  self;
}

- (void)initSubviews {
    
}

- (void)setupCellWithSchool:(HHDrivingSchool *)school {
    
}

@end
