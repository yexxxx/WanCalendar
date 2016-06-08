//
//  YEXNote.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/29.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXNote.h"
#import "NSObject+YEXArchive.h"

@implementation YEXNote

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
