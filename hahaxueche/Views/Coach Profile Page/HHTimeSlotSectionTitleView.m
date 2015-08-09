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
        [self setFrameWithHeight:30.0f];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor HHGrayTextColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont fontWithName:@"SourceHanSansCN-Medium" size:15.0f];
        [self.titleLabel sizeToFit];
        [self.titleLabel setFrameWithOrigin:CGPointMake(10.0f, ((CGRectGetHeight(self.bounds) - CGRectGetHeight(self.titleLabel.bounds))/2) + 4.0f)];
        [self addSubview:self.titleLabel];
        
    }
    return self;
}




@end
