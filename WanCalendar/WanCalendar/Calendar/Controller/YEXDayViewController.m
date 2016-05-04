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

@interface YEXDayViewController ()

@property(nonatomic, weak)YEXDayScrollView *dayView;


@end

@implementation YEXDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dayView];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    __weak typeof(self) weakSelf = self;
    [[YEXNetAPI netAPI] getDataWithType:YEXNetTypeDay andDate:[NSDate date] success:^(id responseObject) {
        if ([responseObject[@"reason"] isEqualToString:@"Success"]) {
            YEXLunarDay *lunarDay = [YEXLunarDay lunarDayWithDict:responseObject[@"result"][@"data"]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                weakSelf.dayView.lunarDay = lunarDay;
                weakSelf.dayView.lunarToday = lunarDay;
            });
//            self.dayView.lunarDay = lunarDay;
        }else{
            [SVProgressHUD showInfoWithStatus:responseObject[@"reason"]];
        }
    } failure:^(NSError *error) {
         [SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
    }];
    
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

@end
