//
//  YEXMonthViewController.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/7.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXMonthViewController.h"
#import "FSCalendar.h"
#import "YEXReminderViewController.h"
#import "YEXReminderTableVC.h"
#import "YEXReminder.h"
#import "YEXReminderCell.h"

@interface YEXMonthViewController ()<FSCalendarDataSource,FSCalendarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSCalendar *lunarCalendar;
@property (strong, nonatomic) NSArray *lunarChars;

@property (weak, nonatomic) FSCalendar *calendar;
@property (weak, nonatomic) UITableView *bottomContainer;

@property(strong, nonatomic) NSMutableArray <YEXReminder *> *reminders;
@property(strong, nonatomic) NSMutableArray <NSString *> *pathes;

@end

#define kContainerFrame (CGRectMake(0, CGRectGetMaxY(calendar.frame), CGRectGetWidth(self.view.frame), 50))

@implementation YEXMonthViewController

#pragma mark - Life cycle

//+ (void)initialize {
//    if (self == [YEXMonthViewController self]) {
//        
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.navigationItem.title = [self num2CN:[NSString stringWithFormat:@"%ld", (long)[self.calendar yearOfDate:self.currentDate]]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClicked)];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor brownColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor brownColor];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getRemindersWithDate:self.currentDate];
    [self.bottomContainer reloadData];
    [self.calendar reloadData];
}

/**
 *  获取提醒事项数据
 */
-(void)getRemindersWithDate:(NSDate *)date {
    
    [self.reminders removeAllObjects];
    [self.pathes removeAllObjects];
    __weak typeof(self) weakSelf = self;
    //获取document路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //获取fileManager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDateFormatter *dateFormer = [[NSDateFormatter alloc] init];
    dateFormer.dateFormat = @"yyyy-MM-dd";
    //文件夹名字为当天日期，如：2016-06-07
    NSString *fileName = [dateFormer stringFromDate:date];
    //拼接文件夹路径
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    //判断是否存在当天日期文件夹
    if (![fileManager fileExistsAtPath:filePath]) return;
    //遍历当前文件夹
    NSError *error = nil;
    NSArray *pathes = [fileManager contentsOfDirectoryAtPath:filePath error:&error];
    //解档文件
    [pathes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *archivePath = [filePath stringByAppendingPathComponent:obj];
        
        [weakSelf.reminders addObject:[NSKeyedUnarchiver unarchiveObjectWithFile: archivePath]];
        [weakSelf.pathes addObject:archivePath];
    }];
}

#pragma mark - lazyLoading

-(FSCalendar *)calendar
{
    if (!_calendar) {
        CGFloat height = 300;
        FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), height)];
        calendar.backgroundColor = goldColor;
        calendar.dataSource = self;
        calendar.delegate = self;
        calendar.showsPlaceholders = NO;
        calendar.currentPage = self.currentDate;
        calendar.today = self.currentDate;
        calendar.appearance.headerDateFormat = @"MMMM";
        calendar.appearance.titleWeekendColor = [UIColor lightGrayColor];
        calendar.appearance.titleFont = headerFont;
        calendar.appearance.headerTitleFont = headerFont;
        calendar.appearance.weekdayFont = headerFont;
        calendar.appearance.headerTitleColor = [UIColor blackColor];
        calendar.appearance.weekdayTextColor = [UIColor blackColor];
        [self.view addSubview:calendar];
        self.calendar = calendar;
        
    }
    return _calendar;
}

-(UITableView *)bottomContainer
{
    if (!_bottomContainer) {
        UITableView *view = [[UITableView alloc] initWithFrame: (CGRectMake(0, CGRectGetMaxY(self.calendar.frame), CGRectGetWidth(self.view.frame), self.view.height - CGRectGetMaxY(self.calendar.frame)))];
        view.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        view.dataSource = self;
        view.delegate = self;
        [view registerNib:[UINib nibWithNibName:@"YEXReminderCell" bundle:nil] forCellReuseIdentifier:@"YEXReminderCell"];
        view.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:view];
        self.bottomContainer = view;
    }
    return _bottomContainer;
}

-(NSCalendar *)lunarCalendar
{
    if (!_lunarCalendar) {
        _lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        _lunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    }
    return _lunarCalendar;
}

-(NSArray *)lunarChars
{
    if (!_lunarChars) {
        _lunarChars = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二一",@"二二",@"二三",@"二四",@"二五",@"二六",@"二七",@"二八",@"二九",@"三十"];
    }
    return _lunarChars;
}

-(NSMutableArray *)reminders
{
    if (!_reminders) {
        _reminders = [NSMutableArray array];
    }
    return _reminders;
}

-(NSMutableArray *)pathes
{
    if (!_pathes) {
        _pathes = [NSMutableArray array];
    }
    return _pathes;
}

#pragma mark - Target action

-(void)leftButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)rightButtonClicked {
    
    YEXReminderViewController *reminderVC = [[YEXReminderViewController alloc] init];
    reminderVC.currentDate = self.currentDate;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:reminderVC];
    [self.navigationController presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - <FSCalendarDelegate>

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    self.bottomContainer.frame =  (CGRectMake(0, CGRectGetMaxY(self.calendar.frame), CGRectGetWidth(self.view.frame), self.view.height - CGRectGetMaxY(self.calendar.frame)));
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    self.navigationItem.title = [self num2CN:[NSString stringWithFormat:@"%ld", (long)[calendar yearOfDate:calendar.currentPage]]];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    self.currentDate = date;
    [self getRemindersWithDate:self.currentDate];
    [self.bottomContainer reloadData];
}

#pragma mark - <FSCalendarDatesource>

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    
    //获取document路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //获取fileManager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDateFormatter *dateFormer = [[NSDateFormatter alloc] init];
    dateFormer.dateFormat = @"yyyy-MM-dd";
    //文件夹名字为当天日期，如：2016-06-07
    NSString *fileName = [dateFormer stringFromDate:date];
    //拼接文件夹路径
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    //判断是否存在当天日期文件夹
    if (![fileManager fileExistsAtPath:filePath]) return 0;
    //遍历当前文件夹
    NSError *error = nil;
    NSArray *pathes = [fileManager contentsOfDirectoryAtPath:filePath error:&error];
    
    return pathes.count;
}

- (nullable NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date {
    NSInteger day = [self.lunarCalendar components:NSCalendarUnitDay fromDate:date].day;
    return self.lunarChars[day-1];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reminders.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YEXReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YEXReminderCell"];
    cell.reminder = self.reminders[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YEXReminderViewController *reminderVC = [[YEXReminderViewController alloc] init];
    reminderVC.currentDate = self.currentDate;
    reminderVC.reminder = self.reminders[indexPath.row];
    reminderVC.remindePath = self.pathes[indexPath.row];
    [self.navigationController pushViewController:reminderVC animated:YES];
    
}

#pragma mark - someMethods
-(NSString *)num2CN:(NSString *)num {
    NSArray *arrCN = @[@"零",@"壹",@"貳",@"叁",@"肆",@"伍",@"陆",@"七",@"八",@"九"];
    NSMutableString *resultStr = [NSMutableString string];
    for (int i = 0; i < num.length; i ++) {
        NSString *c = [num substringWithRange:NSMakeRange(i, 1)];
        [resultStr appendString:arrCN[c.intValue]];
    }
    return resultStr;
}

@end
