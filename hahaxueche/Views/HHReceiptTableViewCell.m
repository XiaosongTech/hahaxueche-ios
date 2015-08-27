//
//  HHReceiptTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/26/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHReceiptTableViewCell.h"
#import "HHAutoLayoutUtility.h"
#import "HHUserAuthenticator.h"
#import "UIColor+HHColor.h"
#import "HHReceiptItemView.h"
#import "HHFormatUtility.h"

#define kAvatarRadius 15.0f
#define kCellTextColor [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1]

@implementation HHReceiptTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self initSubviews];
       
    }
    return self;
}

- (void)setTransaction:(HHTransaction *)transaction {
    _transaction = transaction;
    [self setupReceiptItems];
    
}

- (void)setupReceiptItems {

    HHReceiptItemView *dateTimeView = [[HHReceiptItemView alloc] initWithFrame:CGRectZero keyTitle:NSLocalizedString(@"下单时间", nil) value:[[HHFormatUtility fullDateFormatter] stringFromDate:self.transaction.createdAt]];
    dateTimeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:dateTimeView];
    
    HHReceiptItemView *receiptNoView = [[HHReceiptItemView alloc] initWithFrame:CGRectZero keyTitle:NSLocalizedString(@"收据编号", nil) value:self.transaction.objectId];
    receiptNoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:receiptNoView];
    
    HHReceiptItemView *paymentMethodView = [[HHReceiptItemView alloc] initWithFrame:CGRectZero keyTitle:NSLocalizedString(@"付款方式", nil) value:self.transaction.paymentMethod];
    paymentMethodView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:paymentMethodView];
    
    HHReceiptItemView *priceView = [[HHReceiptItemView alloc] initWithFrame:CGRectZero keyTitle:NSLocalizedString(@"金额", nil) value:[[HHFormatUtility moneyFormatter] stringFromNumber:self.transaction.paidPrice]];
    priceView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:priceView];
    
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalNext:dateTimeView toView:self.firstLine constant:10.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:dateTimeView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:dateTimeView multiplier:0 constant:20.0f],
                             [HHAutoLayoutUtility setViewWidth:dateTimeView multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility verticalNext:receiptNoView toView:dateTimeView constant:10.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:receiptNoView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:receiptNoView multiplier:0 constant:20.0f],
                             [HHAutoLayoutUtility setViewWidth:receiptNoView multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility verticalNext:paymentMethodView toView:receiptNoView constant:10.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:paymentMethodView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:paymentMethodView multiplier:0 constant:20.0f],
                             [HHAutoLayoutUtility setViewWidth:paymentMethodView multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility verticalNext:priceView toView:paymentMethodView constant:10.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:priceView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:priceView multiplier:0 constant:20.0f],
                             [HHAutoLayoutUtility setViewWidth:priceView multiplier:1.0f constant:-20.0f],
                             ];
    [self.containerView addConstraints:constraints];
}


- (void)initSubviews {
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 5.0f;
    self.containerView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.containerView];
    
    self.avatarView = [[HHAvatarView alloc] initWithImageURL:[HHUserAuthenticator sharedInstance].myCoach.avatarURL radius:kAvatarRadius borderColor:[UIColor whiteColor]];
    self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.avatarView];
    
    self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nameButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nameButton addTarget:self action:@selector(nameButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *nameString = [NSString stringWithFormat:@"%@ 教练", [HHUserAuthenticator sharedInstance].myCoach.fullName];
    NSMutableAttributedString *attrNameString = [[NSMutableAttributedString alloc] initWithString:nameString];
    [attrNameString addAttributes:@{
                                    NSFontAttributeName:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:15.0f],
                                    NSForegroundColorAttributeName:[UIColor HHClickableBlue],
                                    }
                            range:NSMakeRange(0, nameString.length - 2)];
    
    [attrNameString addAttributes:@{
                                    NSFontAttributeName:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13.0f],
                                    NSForegroundColorAttributeName:kCellTextColor,
                                    }
                            range:NSMakeRange(nameString.length - 2, 2)];
    
    [self.nameButton setAttributedTitle:attrNameString forState:UIControlStateNormal];
    [self.containerView addSubview:self.nameButton];
    
    self.firstLine = [self createLine];
    self.secondLine = [self createLine];
    
    
    [self autoLayoutSubviews];
}

- (void)nameButtonTapped {
    if (self.nameButtonActionBlock) {
        self.nameButtonActionBlock();
    }
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.containerView constant:8.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.containerView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.containerView multiplier:1.0f constant:-8.0f],
                             [HHAutoLayoutUtility setViewWidth:self.containerView multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.avatarView constant:10.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.avatarView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.avatarView multiplier:0 constant:kAvatarRadius*2],
                             [HHAutoLayoutUtility setViewWidth:self.avatarView multiplier:0 constant:kAvatarRadius*2],
                             
                             [HHAutoLayoutUtility setCenterY:self.nameButton toView:self.avatarView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.nameButton toView:self.avatarView constant:10.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.firstLine toView:self.avatarView constant:10.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.firstLine constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.firstLine multiplier:0 constant:1.0f],
                             [HHAutoLayoutUtility setViewWidth:self.firstLine multiplier:1.0f constant:-20.0f],
                             
                             ];
    [self.contentView addConstraints:constraints];
    
}

- (UILabel *)createLabelWithFont:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = font;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    [self.containerView addSubview:label];
    return label;
}

- (UIView *)createLine {
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor HHGrayLineColor];
    [self.containerView addSubview:line];
    return line;
}

@end
