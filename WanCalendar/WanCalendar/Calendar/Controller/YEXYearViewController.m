//
//  YEXYearViewController.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/3/31.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXYearViewController.h"

@interface YEXYearViewController ()

@end

@implementation YEXYearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//     Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
