//
//  HHGuardViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 23/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHGuardViewController.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "UIColor+HHColor.h"
#import "HHGuardItemTableViewCell.h"

typedef NS_ENUM(NSInteger, GuardItem) {
    GuardItemCoachVerified,
    GuardItemGoldenCoach,
    GuardItemFreeTrial,
    GuardItemPaymentStages,
    GuardItemInstalments,
    GuardItemCarInsurance,
    GuardItemDeposit,
    GuardItemCount
};

static NSString *const kCellId = @"kCellId";

static NSString *const kCoachText = @"该教练已完成实名认证，已备案。教学技术专业，爱岗敬业，热爱驾培行业，收费透明。";
static NSString *const kGoldenCoachText = @"该教练在平台教学数据与学员评价名列前茅。已通过平台金牌教练认证及培训。";
static NSString *const kFreeTrialText = @"在平台注册的用户都可享有教练一次免费试学的机会。和教练面对面交流，打消你报名前的疑虑。";
static NSString *const kPaymentStagesText = @"教练支持使用分阶段打款，学费将由平台提供担保。在用户确认打款后由平台打款给教练。";
static NSString *const kPaymentInstalmentText = @"教练支持使用分期乐等分期付款。";
static NSString *const kCarInsuranceText = @"该教练拥有可用于教学的车辆，并提供用于教学的训练场地。教练教学所用车辆已购买相关保险。";
static NSString *const kDepositText = @"该教练已缴纳平台保证金。在教学过程中如果产生任何纠纷，在确定为教练责任的情况下平台先行赔付。";

@interface HHGuardViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HHGuardViewController

- (instancetype)initWithCoach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.coach = coach;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"平台保障";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    [self.tableView registerClass:[HHGuardItemTableViewCell class] forCellReuseIdentifier:kCellId];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return GuardItemCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HHGuardItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    switch (indexPath.row) {
        case GuardItemCoachVerified: {
            [cell setupWithIcon:[UIImage imageNamed:@"ic_jiaolianrenzheng2"] title:@"教练认证" subTitle:kCoachText verifiedText:@"已备案"];
        } break;
            
        case GuardItemGoldenCoach: {
            NSString *verifiedText = @"";
            if ([self.coach isGoldenCoach]) {
                verifiedText = @"已认证";
            }
            [cell setupWithIcon:[UIImage imageNamed:@"ic_jinpaijiaolian2"] title:@"金牌教练" subTitle:kGoldenCoachText verifiedText:verifiedText];
            
        } break;
        case GuardItemFreeTrial: {
            [cell setupWithIcon:[UIImage imageNamed:@"ic_mianfeishixue2"] title:@"免费试学" subTitle:kFreeTrialText verifiedText:@"已开通"];
        } break;
        case GuardItemPaymentStages: {
            [cell setupWithIcon:[UIImage imageNamed:@"ic_fenduandakuan2"] title:@"分段打款" subTitle:kPaymentStagesText verifiedText:@"已开通"];
        } break;
        case GuardItemInstalments: {
            [cell setupWithIcon:[UIImage imageNamed:@"ic_fenqidakuan2"] title:@"分期付款" subTitle:kPaymentInstalmentText verifiedText:@"已开通"];
        } break;
        case GuardItemCarInsurance: {
            [cell setupWithIcon:[UIImage imageNamed:@"ic_cheliangbaoxian2"] title:@"车辆保险" subTitle:kCarInsuranceText verifiedText:@"已备案"];
        } break;
        case GuardItemDeposit: {
            NSString *verifiedText = @"";
            if ([self.coach.hasDeposit boolValue]) {
                verifiedText = @"已开通";
            }
            [cell setupWithIcon:[UIImage imageNamed:@"ic_xianxiangpeifu2"] title:@"先行赔付" subTitle:kDepositText verifiedText:verifiedText];
            
        } break;
            
        default:
            break;
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect;
    CGFloat padding = 55.0f;
    switch (indexPath.row) {
        case GuardItemCoachVerified: {
            rect = [kCoachText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-65.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]} context:nil];
            return CGRectGetHeight(rect) + padding;
        };
            
        case GuardItemGoldenCoach: {
            rect = [kGoldenCoachText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-65.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]} context:nil];
            return CGRectGetHeight(rect) + padding;
            
        };
        case GuardItemFreeTrial: {
            rect = [kFreeTrialText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-65.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]} context:nil];
            return CGRectGetHeight(rect) + padding;
        };
        case GuardItemPaymentStages: {
            rect = [kPaymentStagesText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-65.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]} context:nil];
            return CGRectGetHeight(rect) + padding;
        };
        case GuardItemInstalments: {
            rect = [kPaymentInstalmentText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-65.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]} context:nil];
            return CGRectGetHeight(rect) + padding;
        };
        case GuardItemCarInsurance: {
            rect = [kCarInsuranceText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-65.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]} context:nil];
            return CGRectGetHeight(rect) + padding;
        };
        case GuardItemDeposit: {
            rect = [kDepositText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds)-65.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]} context:nil];
            return CGRectGetHeight(rect) + padding;
        } ;
            
        default:
            return 0;
    }
}


- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
