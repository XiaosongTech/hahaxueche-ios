//
//  HHProfileSetupViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHProfileSetupViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHSignupOtherInfoViewController.h"
#import "HHButton.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "HHTextFieldView.h"
#import "UIView+HHRect.h"
#import "HHToastUtility.h"
#import "HHStudent.h"
#import "HHUserAuthenticator.h"
#import "HHLoadingView.h"
#import <SDWebImage/UIImageView+WebCache.h>

typedef enum : NSUInteger {
    ImageOptionTakePhoto,
    ImageOptionFromAlbum,
} ImageOption;

@interface HHProfileSetupViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *uploadImageView;
@property (nonatomic, strong) HHTextFieldView *nameTextView;
@property (nonatomic, strong) HHTextFieldView *cityTextView;
@property (nonatomic, strong) UIPickerView *cityPicker;
@property (nonatomic, strong) HHStudent *student;
@property (nonatomic, strong) HHUser *user;
@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, strong) NSString *selectedProvince;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) UILabel *remindLabel;



@end

@implementation HHProfileSetupViewController

- (instancetype)initWithUser:(HHUser *)user {
    self = [super init];
    if (self) {
        self.user = user;
        self.selectedCity = @"武汉市";
        self.selectedProvince = @"湖北省";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHOrange];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *doneButton = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"完成",nil) action:@selector(doneButtonPressed) target:self isLeft:NO];
    self.navigationItem.rightBarButtonItem = doneButton;
    
     UIBarButtonItem *cancelButton = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"取消",nil) action:@selector(cancelButtonPressed) target:self isLeft:YES];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.title = NSLocalizedString(@"个人信息",nil);
    [self initSubviews];
}

- (void)initSubviews {
    [self initUploadIamgeView];
    [self initFieldView];
    [self autolayoutSubviews];
    self.cityTextView.textField.text = NSLocalizedString(@"湖北省-武汉市",nil);
}

- (void)initUploadIamgeView {
    self.uploadImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.uploadImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.uploadImageView.userInteractionEnabled = YES;
    self.uploadImageView.contentMode = UIViewContentModeCenter;
    self.uploadImageView.image = [UIImage imageNamed:@"camera-alt"];
    self.uploadImageView.layer.cornerRadius = 25.0f;
    self.uploadImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.uploadImageView.layer.borderWidth = 1.0f;
    self.uploadImageView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImage)];
    [self.uploadImageView addGestureRecognizer:tapGesture];
    if ([HHUserAuthenticator sharedInstance].currentStudent) {
        self.uploadImageView.contentMode = UIViewContentModeScaleAspectFill;
        AVFile *file = [AVFile fileWithURL:[HHUserAuthenticator sharedInstance].currentStudent.avatarURL];
        NSString *thumbnailString = [file getThumbnailURLWithScaleToFit:YES width:200.0f height:200.0f quality:100 format:@"png"];
        [self.uploadImageView sd_setImageWithURL:[NSURL URLWithString:thumbnailString] placeholderImage:nil];
    }
    [self.view addSubview:self.uploadImageView];

}

- (void)initFieldView {
    self.remindLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.remindLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.remindLabel.text = NSLocalizedString(@"请实名注册并提交真实头像，以便获得更好的服务体验！", nil);
    self.remindLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f];
    self.remindLabel.textColor = [UIColor whiteColor];
    self.remindLabel.numberOfLines = 0;
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.remindLabel];

    
    self.nameTextView = [[HHTextFieldView alloc] initWithPlaceholder:NSLocalizedString(@"姓名",nil)];
    self.nameTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameTextView.textField.keyboardType = UIKeyboardTypeDefault;
    self.nameTextView.textField.delegate = self;
    
    [self.view addSubview:self.nameTextView];
    
    self.cityTextView = [[HHTextFieldView alloc] initWithPlaceholder:NSLocalizedString(@"所在城市",nil)];
    self.cityTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cityTextView.textField setEnabled:NO];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCity)];
    [self.cityTextView addGestureRecognizer:tapGesture];
    [self.view addSubview:self.cityTextView];
    
    if ([HHUserAuthenticator sharedInstance].currentStudent) {
        self.nameTextView.textField.text = [HHUserAuthenticator sharedInstance].currentStudent.fullName;
        self.selectedCity = [HHUserAuthenticator sharedInstance].currentStudent.city;
        self.selectedProvince = [HHUserAuthenticator sharedInstance].currentStudent.province;
        self.cityTextView.textField.text = self.cityTextView.textField.text = [NSString stringWithFormat: NSLocalizedString(@"%@-%@",nil), self.selectedProvince, self.selectedCity];
    }
}

- (void)autolayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.remindLabel constant:40.0f],
                             [HHAutoLayoutUtility setCenterX:self.remindLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.remindLabel multiplier:1.0f constant:-100.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.uploadImageView toView:self.remindLabel constant:20.0f],
                             [HHAutoLayoutUtility setCenterX:self.uploadImageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.uploadImageView multiplier:0 constant:50.0f],
                             [HHAutoLayoutUtility setViewHeight:self.uploadImageView multiplier:0 constant:50.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.nameTextView toView:self.uploadImageView constant:10.0f],
                             [HHAutoLayoutUtility setCenterX:self.nameTextView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.nameTextView multiplier:1.0f constant:-80.0f],
                             [HHAutoLayoutUtility setViewHeight:self.nameTextView multiplier:0 constant:40.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.cityTextView toView:self.nameTextView constant:10.0f],
                             [HHAutoLayoutUtility setCenterX:self.cityTextView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.cityTextView multiplier:1.0f constant:-80.0f],
                             [HHAutoLayoutUtility setViewHeight:self.cityTextView multiplier:0 constant:40.0f],
                             
                             
                             ];
    [self.view addConstraints:constraints];

}

- (void)doneButtonPressed {
    if (!self.originalImage && ![HHUserAuthenticator sharedInstance].currentStudent.avatarURL) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"请选择头像",nil) isError:YES];
        return;
    }
    if ([self.nameTextView.textField.text isEqualToString: @""]) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"请填写名字",nil) isError:YES];
        return;
    }
    if (!self.selectedCity || !self.selectedProvince) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"请选择所在城市和省份",nil) isError:YES];
        return;
    }
    [self.nameTextView.textField resignFirstResponder];
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:NSLocalizedString(@"加载中",nil)];
    
    AVFile *imageFile = [AVFile fileWithData:UIImagePNGRepresentation([self normalizedImage:self.originalImage] )];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"图片上传失败！",nil) isError:YES];
            [[HHLoadingView sharedInstance] hideLoadingView];
        } else {
            self.student.avatarURL = imageFile.url;
            [HHUserAuthenticator sharedInstance].currentStudent.avatarURL = imageFile.url;
            [self.student saveInBackground];
        }
    }];
    
    if ([HHUserAuthenticator sharedInstance].currentStudent) {
        self.student = [[HHUserAuthenticator sharedInstance].currentStudent mutableCopy];
        self.student.fullName = self.nameTextView.textField.text;
        self.student.city = self.selectedCity;
        self.student.province = self.selectedProvince;
        [self.student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [[HHLoadingView sharedInstance] hideLoadingView];
            if (!error) {
                [HHToastUtility showToastWitiTitle:@"更新成功！" isError:NO];
                [self dismissViewControllerAnimated:YES completion:nil];
               
            } else {
                [HHToastUtility showToastWitiTitle:@"更新失败！" isError:YES];
            }
        }];
        
    } else {
        self.student = [HHStudent object];
        self.student.fullName = self.nameTextView.textField.text;
        self.student.city = self.selectedCity;
        self.student.province = self.selectedProvince;
        [[HHUserAuthenticator sharedInstance] signupWithUser:self.user completion:^(NSError *error) {
            if (!error) {
                [[HHUserAuthenticator sharedInstance] createStudentWithStudent:self.student completion:^(NSError *error) {
                    [[HHLoadingView sharedInstance] hideLoadingView];
                    if (!error) {
                        HHSignupOtherInfoViewController *otherInfoVC = [[HHSignupOtherInfoViewController alloc] init];
                        otherInfoVC.student = self.student;
                        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:otherInfoVC];
                        [self presentViewController:navVC animated:YES completion:nil];
                    } else {
                        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"创建账户失败！",nil) isError:YES];
                    }
                }];
                
            } else {
                [[HHLoadingView sharedInstance] hideLoadingView];
                [HHToastUtility showToastWitiTitle:NSLocalizedString(@"创建账户失败！",nil) isError:YES];
            }
        }];

    }
   
}

- (void)cancelButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImage {
    [self.nameTextView.textField resignFirstResponder];
    if (self.cityPicker) {
        [self.cityPicker removeFromSuperview];
        self.cityPicker = nil;
    }
    
    NSString *actionSheetTitle = NSLocalizedString(@"上传头像",nil);
    NSString *other1 = NSLocalizedString(@"拍摄",nil);
    NSString *other2 = NSLocalizedString(@"从相册选择",nil);
    NSString *cancelTitle = NSLocalizedString(@"取消",nil);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, nil];
    
    [actionSheet showInView:self.view];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.nameTextView.textField]) {
        if (self.cityPicker) {
            [self.cityPicker removeFromSuperview];
            self.cityPicker = nil;
        }
        self.cityTextView.divideLine.backgroundColor = [UIColor HHTransparentWhite];
        self.nameTextView.divideLine.backgroundColor = [UIColor whiteColor];
    }
   
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.nameTextView.divideLine.backgroundColor = [UIColor HHTransparentWhite];
}

- (void)selectCity {
    [self.nameTextView.textField resignFirstResponder];
    self.cityTextView.divideLine.backgroundColor = [UIColor whiteColor];
    if (!self.cityPicker) {
        self.cityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)-200.0f, CGRectGetWidth(self.view.bounds), 200.0f)];
    }
    
     self.cityPicker.delegate = self;
     self.cityPicker.showsSelectionIndicator = YES;
    [self.view addSubview: self.cityPicker];
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 1;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44.0f;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(pickerView.bounds), 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20.0f];
    if (component == 0) {
        label.text = @"湖北省";
    } else {
        label.text = @"武汉市";
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case ImageOptionTakePhoto:{
            [self showImagePickerView:UIImagePickerControllerSourceTypeCamera];
        }
            break;
            
        case ImageOptionFromAlbum:{
            [self showImagePickerView:UIImagePickerControllerSourceTypePhotoLibrary];
        }
            break;
            
        default:
            break;
    }
}

- (void)showImagePickerView:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.navigationBar.tintColor = [UIColor whiteColor];
    picker.navigationItem.title = NSLocalizedString(@"头像照片",nil);
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.originalImage = info[UIImagePickerControllerEditedImage];
    if(!self.originalImage) {
        self.originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
     self.uploadImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.uploadImageView.image = self.originalImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (UIImage *)normalizedImage:(UIImage *)image {
    if (image == UIImageOrientationUp) {
        return image;
    }
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

@end
