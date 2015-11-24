//
//  HHQRCodeScannerViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 11/24/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import "HHQRCodeScannerViewController.h"
#import "UIColor+HHColor.h"
#import "HHAutoLayoutUtility.h"
#import "UIImage+HHImage.h"

@implementation HHQRCodeScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self drawScanView];
    [self performSelector:@selector(startScan) withObject:nil afterDelay:0.2];
}

- (void)drawScanView {
    CGRect rect = self.view.frame;
    rect.origin = CGPointMake(0, 0);
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    style.photoframeLineW = 2;
    style.photoframeAngleW = 18;
    style.photoframeAngleH = 18;
    style.isNeedShowRetangle = YES;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_None;
    style.colorAngle = [UIColor HHOrange];
    style.colorRetangleLine = [UIColor clearColor];
    
    self.qRScanView = [[LBXScanView alloc]initWithFrame:rect style:style];
    [self.view addSubview:self.qRScanView];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.cancelButton.backgroundColor = [UIColor HHOrange];
    [self.cancelButton addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    [self.qRScanView addSubview:self.cancelButton];
    
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.cancelButton constant:0],
                             [HHAutoLayoutUtility setCenterX:self.cancelButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.cancelButton multiplier:0 constant:40.0f],
                             [HHAutoLayoutUtility setViewWidth:self.cancelButton multiplier:1.0f constant:0]
                             ];
    [self.view addConstraints:constraints];


    [self.qRScanView startDeviceReadyingWithText:@"相机启动中"];
}

- (void)startScan {
    if ( ![LBXScanWrapper isGetCameraPermission] ) {
        [self.qRScanView stopDeviceReadying];
        
        [self showAccessError];
        return;
    }
    
    self.scanObj = [[LBXScanWrapper alloc]initWithPreView:self.view
                                          ArrayObjectType:nil
                                                  success:self.resultBlock];
    
    [self.scanObj startScan];
    [self.qRScanView stopDeviceReadying];
    [self.qRScanView startScanAnimation];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self.scanObj stopScan];
    [self.qRScanView stopScanAnimation];
}

- (void)showAccessError {
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"我们需要相机权限", nil)
                                                     message:NSLocalizedString(@"请到设置隐私中开启本程序相机权限", nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"知道了", ni)
                                           otherButtonTitles: nil];
    [alert show];
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
