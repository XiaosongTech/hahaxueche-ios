//
//  HHImageGalleryViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 3/15/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHImageGalleryViewController.h"
#import "Masonry.h"
#import "HHImageView.h"

@interface HHImageGalleryViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic) NSInteger currentIndex;

@end

@implementation HHImageGalleryViewController

- (instancetype)initWithURLs:(NSArray *)URLs currentIndex:(NSInteger)currentIndex {
    self = [super init];
    if (self) {
        self.imageURLs = URLs;
        self.currentIndex = currentIndex;
        self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC)];
    [self.view addGestureRecognizer:recognizer];
    
    [self addImageViews];
    
    self.indexLabel = [[UILabel alloc] init];
    self.indexLabel.textColor = [UIColor whiteColor];
    self.indexLabel.font = [UIFont systemFontOfSize:15.0f];
    self.indexLabel.text = [self buildIndexString];
    [self.view addSubview:self.indexLabel];
    
    [self.indexLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.bottom.equalTo(self.view.bottom).offset(-20.0f);
    }];
}

- (void)addImageViews {
    for (int i = 0; i < self.imageURLs.count; i++) {
        if (!self.imageURLs[i] || ![self.imageURLs[i] isKindOfClass:[NSString class]]) {
            continue;
        }
        HHImageView *imageView = [[HHImageView alloc] initWithURL:[NSURL URLWithString:self.imageURLs[i]]];
        [self.scrollView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.scrollView.centerX).multipliedBy(1+i*2);
            make.centerY.equalTo(self.scrollView.centerY);
            make.width.equalTo(self.scrollView.width);
            make.height.equalTo(self.scrollView.height);
        }];
    }
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * self.imageURLs.count, CGRectGetHeight(self.view.bounds));
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)buildIndexString {
    return [NSString stringWithFormat:@"%ld/%ld", self.currentIndex + 1, self.imageURLs.count];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    self.indexLabel.text = [self buildIndexString];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame) * self.currentIndex, 0);
}



@end
