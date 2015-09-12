//
//  HHCoachStudentProfileCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/7/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachStudentProfileCell.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation HHCoachStudentProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.nameButton setAttributedTitle:nil forState:UIControlStateNormal];
        self.nameButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18.0f];
        [self.nameButton setTitleColor:[UIColor HHDarkGrayTextColor] forState:UIControlStateNormal];
        self.nameButton.enabled = NO;
        
        self.phoneNumberButton = [[UIButton alloc] initWithFrame:CGRectZero];
        self.phoneNumberButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.phoneNumberButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15.0f];
        [self.phoneNumberButton setTitleColor:[UIColor HHClickableBlue] forState:UIControlStateNormal];
        [self.phoneNumberButton addTarget:self action:@selector(phoneNumberButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.phoneNumberButton];
        
        NSArray *constraints = @[
                                 [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.phoneNumberButton constant:-10.0f],
                                 [HHAutoLayoutUtility setCenterY:self.phoneNumberButton toView:self.nameButton multiplier:1.0f constant:0],
                                 ];
        [self.contentView addConstraints:constraints];
        
        
    }
    return self;
}

- (void)phoneNumberButtonTapped {
    if (self.callStudentBlock) {
        self.callStudentBlock();
    }
}

- (void)setStudent:(HHStudent *)student {
    [self.phoneNumberButton setTitle:student.phoneNumber forState:UIControlStateNormal];
    [self.nameButton setTitle:student.fullName forState:UIControlStateNormal];
    [self.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:student.avatarURL] placeholderImage:nil];
    
    [self.phoneNumberButton sizeToFit];
    [self.nameButton sizeToFit];
}

@end
