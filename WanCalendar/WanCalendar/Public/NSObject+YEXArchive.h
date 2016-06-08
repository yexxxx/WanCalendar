//
//  NSObject+YEXArchive.h
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/3.
//  Copyright © 2016年 yex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YEXArchive)

- (NSArray *)ignoredNames;
- (void)encode:(NSCoder *)aCoder;
- (void)decode:(NSCoder *)aDecoder;

@end
