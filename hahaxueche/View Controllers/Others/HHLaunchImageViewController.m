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
@property (nonatomic) BOOL finishedLoop;

@end

@implementation HHLaunchImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildGifView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (!self.desVC) {
            HHRootViewController *rootVC = [[HHRootViewController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
        }
        
    });
}


- (void)setDesVC:(UIViewController *)desVC {
    _desVC = desVC;
    if (self.finishedLoop) {
        [UIApplication sharedApplication].keyWindow.rootViewController = self.desVC;
    }
}

- (void)buildGifView {
    __weak HHLaunchImageViewController *weakSelf = self;
    self.imageView = [[FLAnimatedImageView alloc] init];
    self.imageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
        weakSelf.finishedLoop = YES;
        [weakSelf.imageView stopAnimating];
        if (weakSelf.desVC) {
            [UIApplication sharedApplication].keyWindow.rootViewController = weakSelf.desVC;
        }
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
