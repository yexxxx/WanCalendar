//
//  YEXDayViewController.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/3/31.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXDayViewController.h"
#import "YEXYearViewController.h"
#import "YEXMonthViewController.h"
#import "YEXNetAPI.h"
#import "YEXDayScrollView.h"
#import "YEXLunarDay.h"
#import "YEXLoginViewController.h"
#import "YEXUserViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "YEXNotesTableVC.h"

@interface YEXDayViewController ()

@property(nonatomic, weak)YEXDayScrollView *dayView;

@property (weak, nonatomic) UIButton *loginButton;
@property (weak, nonatomic) UIButton *shareButton;

@end

@implementation YEXDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dayView];
    __weak typeof(self) weakSelf = self;
    [[YEXNetAPI netAPI] getDataWithType:YEXNetTypeDay andDate:[NSDate date] success:^(id responseObject) {
        if ([responseObject[@"reason"] isEqualToString:@"Success"]) {
            YEXLunarDay *lunarDay = [YEXLunarDay lunarDayWithDict:responseObject[@"result"][@"data"]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                weakSelf.dayView.lunarDay = lunarDay;
                weakSelf.dayView.lunarToday = lunarDay;
            });
        }else{
            [SVProgressHUD showInfoWithStatus:responseObject[@"reason"]];
        }
    } failure:^(NSError *error) {
         [SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
    }];
    [self loginButton];
    [self shareButton];
    
    //模糊效果
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = CGRectMake(0, 0, 200, 200);
//    [self.view addSubview:effectView];
    // Do any additional setup after loading the view.
}

-(YEXDayScrollView *)dayView
{
    if (!_dayView) {
        YEXDayScrollView *view = [[YEXDayScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
         __weak typeof(self) weakSelf = self;
        view.swipeBlock = ^(NSDate *date) {
            YEXNotesTableVC *noteVC = [[YEXNotesTableVC alloc] init];
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:noteVC];
            noteVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [weakSelf presentViewController:navVC animated:YES completion:nil];
        };
        view.tapBlock =  ^(NSDate *date) {
            YEXMonthViewController *monthVC = [[YEXMonthViewController alloc] init];
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:monthVC];
            monthVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            monthVC.currentDate = date;
            [weakSelf presentViewController:navVC animated:YES completion:nil];
        };
        [self.view addSubview:view];
        _dayView = view;
    }
    return _dayView;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    self.view.backgroundColor = [self randomColor];
}
-(UIColor *)randomColor {
    CGFloat red   = arc4random() % 255 / 255.0;
    CGFloat green = arc4random() % 255 / 255.0;
    CGFloat blue  = arc4random() % 255 / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyLoading

-(UIButton *)loginButton
{
    if (!_loginButton) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 20, 20)];
        [button addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"personal_setting_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"personal_setting_pre"] forState:UIControlStateSelected];
        [self.view addSubview:button];
        _loginButton = button;
        
    }
    return _loginButton;
}

-(UIButton *)shareButton
{
    if (!_shareButton) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 30 , 30, 20, 20)];
        [button addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"share_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"share_pressed"] forState:UIControlStateSelected];
        [self.view addSubview:button];
//        [self.view bringSubviewToFront:button];
        _shareButton = button;
        
    }
    return _shareButton;
}

#pragma mark - target-action

-(void)loginButtonClicked {
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (bUser) {
        YEXUserViewController *userVC = [[YEXUserViewController alloc] init];
        userVC.userName = bUser.username;
        [self presentViewController:userVC animated:YES completion:nil];
    }else{
        YEXLoginViewController *loginVC = [[YEXLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
}

-(void)shareButtonClicked {
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSString *shareStr = [NSString stringWithFormat:@"%@农历%@ \r宜：%@ \r忌：%@",self.dayView.lunarDay.lunarYear,self.dayView.lunarDay.lunar,self.dayView.lunarDay.suit,self.dayView.lunarDay.avoid];
    
    // 定制新浪微博的分享内容
    [shareParams SSDKSetupSinaWeiboShareParamsByText:shareStr title:nil image:nil url:nil latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    [ShareSDK showShareActionSheet:nil
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           
                           break;
                       }
                       default:
                           break;
                   }
               }];
    
}

@end
