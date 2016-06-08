//
//  YEXReminderCell.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/3.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXReminderCell.h"
#import "YEXReminder.h"

@interface YEXReminderCell ()

@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation YEXReminderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setReminder:(YEXReminder *)reminder {
    _reminder = reminder;
    self.titleLabel.text = reminder.title;
    self.locationLabel.text = reminder.location;
    self.beginTimeLabel.text = [reminder.beginDate componentsSeparatedByString:@" "][1];
    self.endTimeLabel.text = [reminder.endDate componentsSeparatedByString:@" "][1];
    self.lineView.backgroundColor = [reminder lineColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
