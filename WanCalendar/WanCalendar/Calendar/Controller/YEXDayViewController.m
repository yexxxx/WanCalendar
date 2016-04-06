//
//  YEXDayViewController.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/3/31.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXDayViewController.h"
#import "YEXYearViewController.h"
#import "YEXNetAPI.h"
#import "YEXDayScrollView.h"

@interface YEXDayViewController ()

@property(nonatomic, weak)YEXDayScrollView *dayView;

@end

@implementation YEXDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dayView];
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
        
        [self.view addSubview:view];
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[YEXNetAPI netAPI] getDataWithType:YEXNetTypeYear andDate:[NSDate date] success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    YEXYearViewController *yearVC = [[YEXYearViewController alloc] init];
    [self presentViewController:yearVC animated:yearVC completion:nil];
}

@end
