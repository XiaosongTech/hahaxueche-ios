//
//  HHLaunchImageViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHLaunchImageViewController.h"
#import "Masonry.h"
#import "FLAnimatedImage.h"
#import "HHRootViewController.h"


@interface HHLaunchImageViewController ()

@property (nonatomic, strong) FLAnimatedImageView *imageView;
@property (nonatomic, strong) UIImageView *defaultImgView;

@end

@implementation HHLaunchImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.desVC) {
        [self buildGifView];
    } else {
        self.defaultImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaultLaunchImg"]];
        self.defaultImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:self.defaultImgView];
        [self.defaultImgView makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.equalTo(self.view.width);
            make.height.equalTo(self.view.height);
        }];
    }
   
}


- (void)setDesVC:(UIViewController *)desVC {
    _desVC = desVC;
    self.defaultImgView.hidden = YES;
    [self buildGifView];
}

- (void)buildGifView {
    __weak HHLaunchImageViewController *weakSelf = self;
    self.imageView = [[FLAnimatedImageView alloc] init];
    self.imageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
        [weakSelf.imageView stopAnimating];
        [UIApplication sharedApplication].keyWindow.rootViewController = weakSelf.desVC;
    };
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *imgString = [[NSBundle mainBundle] pathForResource:@"launchImage" ofType:@"gif"];
    NSData *imgData = [NSData dataWithContentsOfFile:imgString];
    self.imageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imgData];
    [self.view addSubview:self.imageView];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
}




@end
