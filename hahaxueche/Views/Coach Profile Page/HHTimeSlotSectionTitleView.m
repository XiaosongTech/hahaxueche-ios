//
//  HHTimeSlotSectionTitleView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/9/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHTimeSlotSectionTitleView.h"
#import "UIColor+HHColor.h"
#import "UIView+HHRect.h"

@implementation HHTimeSlotSectionTitleView

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        [self setFrameWithHeight:40.0f];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor HHGrayTextColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont fontWithName:@"SourceHanSansCN-Medium" size:16.0f];
        [self.titleLabel sizeToFit];
        [self.titleLabel setFrameWithOrigin:CGPointMake(10.0f, 4.0f)];
        [self.titleLabel setFrameWithHeight:40.0f];
        self.backgroundColor = [UIColor HHLightGrayBackgroundColor];
        [self addSubview:self.titleLabel];
        
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_time_title_left"]];
        [self.imageView setFrame:CGRectMake(0, 15.0f, 5.0f, 18.0f)];
        [self addSubview:self.imageView];
        
    }
    return self;
}




@end
