//
//  HHLoadingTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/26/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHLoadingTableViewCell.h"
#import "UIColor+HHColor.h"
#import "HHAutoLayoutUtility.h"


@interface HHLoadingTableViewCell ()

@end

@implementation HHLoadingTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self initSubviews];
            }
    return self;
}

- (void)initSubviews {
    self.loadingLabel = [[UILabel alloc] init];
    self.loadingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.loadingLabel.text = NSLocalizedString(@"正在加载...",nil);
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingLabel.backgroundColor = [UIColor whiteColor];
    self.loadingLabel.font = [UIFont fontWithName:@"SourceHanSansCN-Medium" size:12.0f];
    self.loadingLabel.textColor = [UIColor lightGrayColor];
    self.loadingLabel.layer.cornerRadius = 5.0f;
    self.loadingLabel.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    [self.contentView addSubview:self.loadingLabel];
    [self autoLayoutSubviews];
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterX:self.loadingLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.loadingLabel constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.loadingLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.loadingLabel multiplier:1.0f constant:-8.0f]
                                                          ];
    [self.contentView addConstraints:constraints];
}

@end
