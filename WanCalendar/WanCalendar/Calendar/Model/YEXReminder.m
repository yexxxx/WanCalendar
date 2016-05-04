//
//  YEXReminder.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/2.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXReminder.h"
#import "NSObject+YEXArchive.h"

@implementation YEXReminder


-(UIColor *)lineColor {
    if ([self.category isEqualToString:@"家庭"]) {
        return [UIColor cyanColor];
    }else if ([self.category isEqualToString:@"宠物"]) {
        return [UIColor orangeColor];
    }else if ([self.category isEqualToString:@"购物"]) {
        return [UIColor redColor];
    }
    else if ([self.category isEqualToString:@"缴费"]) {
        return [UIColor greenColor];
    }
    else if ([self.category isEqualToString:@"聚会"]) {
        return [UIColor yellowColor];
    }
    else if ([self.category isEqualToString:@"旅游"]) {
        return [UIColor yellowColor];
    }
    else if ([self.category isEqualToString:@"情人"]) {
        return [UIColor cyanColor];
    }
    else if ([self.category isEqualToString:@"工作"]) {
        return [UIColor purpleColor];
    }
    return nil;
}

#pragma mark - archive
- (NSArray *)ignoredNames {
    return nil;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self decode:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self encode:aCoder];
}

@end
