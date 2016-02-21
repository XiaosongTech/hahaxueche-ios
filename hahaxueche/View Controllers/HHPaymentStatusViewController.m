//
//  HHPaymentStatusViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/19/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPaymentStatusViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHPaymentStatusTopView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@interface HHPaymentStatusViewController ()

@property (nonatomic, strong) HHPurchasedService *purchasedService;
@property (nonatomic, strong) HHPaymentStatusTopView *topView;

@end

@implementation HHPaymentStatusViewController

- (instancetype)initWithPurchasedService:(HHPurchasedService *)purchasedService {
    self = [super init];
    if (self) {
        self.purchasedService = purchasedService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打款状态";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    [self initSubviews];
}

- (void)initSubviews {
    self.topView = [[HHPaymentStatusTopView alloc] initWithPurchasedService:nil];
    [self.view addSubview:self.topView];
    
    [self makeContraints];
}

- (void)makeContraints {
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.width.equalTo(self.view.width);
        make.left.equalTo(self.view.left);
        make.height.mas_equalTo(180.0f);
    }];
}

#pragma mark Button Actions
- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
