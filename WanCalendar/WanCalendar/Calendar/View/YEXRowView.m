//
//  YEXRowView.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/7.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXRowView.h"

@interface YEXRowView ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *textLabel;

@end

@implementation YEXRowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:235/255.0  green:215/255.0  blue:177/255.0 alpha:1.0];
    }
    return self;
}

-(void)layoutSubviews {
    self.titleLabel.frame = CGRectMake(10, 0, 20, self.height);
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 5, 0, self.width - 40, self.height);
}

-(void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleLabel.text = _title;
}

-(void)setText:(NSString *)text {
    _text = [text copy];
    self.textLabel .text = _text;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"FZXiaoBiaoSong-B05S" size:[UIFont preferredFontForTextStyle:UIFontTextStyleBody].pointSize];
        [self addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}

-(UILabel *)textLabel
{
    if (!_textLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"FZXiaoBiaoSong-B05S" size:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote].pointSize];
        label.numberOfLines = 0;
        [self addSubview:label];
        _textLabel = label;
    }
    return _textLabel;
}

@end
