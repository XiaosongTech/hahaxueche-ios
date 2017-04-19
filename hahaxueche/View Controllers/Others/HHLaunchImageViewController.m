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


@interface HHLaunchImageViewController ()

@property (nonatomic, strong) FLAnimatedImageView *imageView;

@end

@implementation HHLaunchImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[FLAnimatedImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *imgString = [[NSBundle mainBundle] pathForResource:@"launchImage" ofType:@"gif"];
    NSData *imgData = [NSData dataWithContentsOfFile:imgString];
    self.imageView.animationDuration = 2.5f;
    self.imageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imgData];
    self.imageView.animationRepeatCount = 1;
    [self.view addSubview:self.imageView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
}

- (void)setupRootVC:(UIViewController *)vc {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Here your non-main thread.
        [NSThread sleepForTimeInterval:2.5f];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Here you returns to main thread.
            [UIApplication sharedApplication].keyWindow.rootViewController = vc;
        });
    });
}

@end
