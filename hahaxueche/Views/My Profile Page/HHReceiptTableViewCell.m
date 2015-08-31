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
#import "HHFormatUtility.h"

#define kAvatarRadius 15.0f
#define kCellTextColor [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1]

@implementation HHReceiptTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.paymentStatusViewArray = [NSMutableArray array];
        [self initSubviews];
       
    }
    return self;
}

- (void)setTransaction:(HHTransaction *)transaction {
    _transaction = transaction;
    [self setupReceiptItems];
    
}

- (void)setPaymentStatus:(HHPaymentStatus *)paymentStatus {
    _paymentStatus = paymentStatus;
    [self setupPaymentStatusView];
}

- (void)setupPaymentStatusView {
    for (int i = 1; i < 6; i++) {
        NSNumber *amount;
        if (i == 1) {
            amount = self.paymentStatus.stageOneAmount;
        } else if (i == 2) {
            amount = self.paymentStatus.stageTwoAmount;
        } else if (i == 3) {
            amount = self.paymentStatus.stageThreeAmount;
        } else if (i == 4) {
            amount = self.paymentStatus.stageFourAmount;
        } else {
            amount = self.paymentStatus.stageFiveAmount;
        }
        HHPaymentStatusView *view = [[HHPaymentStatusView alloc] initWithAmount:amount currentStage:[self.paymentStatus.currentStage integerValue] stage:i];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.payBlock = self.payBlock;
        [self.containerView addSubview:view];
        [self.paymentStatusViewArray addObject:view];
        
        if (i == 1) {
            NSArray *constraints = @[
                                     [HHAutoLayoutUtility verticalNext:view toView:self.secondLine constant:10.0f],
                                     [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:view constant:0],
                                     [HHAutoLayoutUtility setViewHeight:view multiplier:0 constant:30.0f],
                                     [HHAutoLayoutUtility setViewWidth:view multiplier:1.0f constant:0],
                                     
                                     ];
            [self.containerView addConstraints:constraints];
        } else {
            NSArray *constraints = @[
                                     [HHAutoLayoutUtility verticalNext:view toView:self.paymentStatusViewArray[i-2] constant:0],
                                     [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:view constant:0],
                                     [HHAutoLayoutUtility setViewHeight:view multiplier:0 constant:40.0f],
                                     [HHAutoLayoutUtility setViewWidth:view multiplier:1.0f constant:0],
                                     
                                     ];
            [self.containerView addConstraints:constraints];
        }
        

    }
}

- (void)setupReceiptItems {
    if (self.dateTimeView) {
        self.dateTimeView.keyLabel.text = NSLocalizedString(@"下单时间", nil);
        self.dateTimeView.valueLabel.text = [[HHFormatUtility fullDateFormatter] stringFromDate:self.transaction.createdAt];
    } else {
        self.dateTimeView = [[HHReceiptItemView alloc] initWithFrame:CGRectZero keyTitle:NSLocalizedString(@"下单时间", nil) value:[[HHFormatUtility fullDateFormatter] stringFromDate:self.transaction.createdAt]];
        self.dateTimeView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.containerView addSubview:self.dateTimeView];

    }
    
    if (self.receiptNoView) {
        self.receiptNoView.keyLabel.text = NSLocalizedString(@"收据编号", nil);
        self.receiptNoView.valueLabel.text = self.transaction.objectId;

    } else {
        self.receiptNoView = [[HHReceiptItemView alloc] initWithFrame:CGRectZero keyTitle:NSLocalizedString(@"收据编号", nil) value:self.transaction.objectId];
        self.receiptNoView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.containerView addSubview:self.receiptNoView];

    }
    
    if (self.paymentMethodView) {
        self.paymentMethodView.keyLabel.text = NSLocalizedString(@"付款方式", nil);
        self.paymentMethodView.valueLabel.text = self.transaction.paymentMethod;
    } else {
        self.paymentMethodView = [[HHReceiptItemView alloc] initWithFrame:CGRectZero keyTitle:NSLocalizedString(@"付款方式", nil) value:self.transaction.paymentMethod];
        self.paymentMethodView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.containerView addSubview:self.paymentMethodView];

    }
    
    if (self.priceView) {
        self.priceView.keyLabel.text = NSLocalizedString(@"金额", nil);
        self.priceView.valueLabel.text = [[HHFormatUtility moneyFormatter] stringFromNumber:self.transaction.paidPrice];
    } else {
        self.priceView = [[HHReceiptItemView alloc] initWithFrame:CGRectZero keyTitle:NSLocalizedString(@"金额", nil) value:[[HHFormatUtility moneyFormatter] stringFromNumber:self.transaction.paidPrice]];
        self.priceView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.containerView addSubview:self.priceView];
    }
    
    
    
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalNext:self.dateTimeView toView:self.firstLine constant:10.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.dateTimeView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.dateTimeView multiplier:0 constant:20.0f],
                             [HHAutoLayoutUtility setViewWidth:self.dateTimeView multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.receiptNoView toView:self.dateTimeView constant:10.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.receiptNoView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.receiptNoView multiplier:0 constant:20.0f],
                             [HHAutoLayoutUtility setViewWidth:self.receiptNoView multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.paymentMethodView toView:self.receiptNoView constant:10.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.paymentMethodView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.paymentMethodView multiplier:0 constant:20.0f],
                             [HHAutoLayoutUtility setViewWidth:self.paymentMethodView multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.priceView toView:self.paymentMethodView constant:10.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.priceView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.priceView multiplier:0 constant:20.0f],
                             [HHAutoLayoutUtility setViewWidth:self.priceView multiplier:1.0f constant:-20.0f],
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
                             
                             [HHAutoLayoutUtility verticalNext:self.secondLine toView:self.firstLine constant:120.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.secondLine constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.secondLine multiplier:0 constant:1.0f],
                             [HHAutoLayoutUtility setViewWidth:self.secondLine multiplier:1.0f constant:-20.0f],
                             
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
