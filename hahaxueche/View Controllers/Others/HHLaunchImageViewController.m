//
//  HHLaunchImageViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHLaunchImageViewController.h"
#import "Masonry.h"

@interface HHLaunchImageViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation HHLaunchImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageNamed:@"launchImage"];
    [self.view addSubview:self.imageView];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] init];
    self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.imageView addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    [self.indicatorView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageView);
        make.width.mas_equalTo(50.0f);
        make.height.mas_equalTo(50.0f);
    }];
}

@end
