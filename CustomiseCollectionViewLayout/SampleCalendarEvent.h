//
//  SampleCalendarEvent.h
//  CustomiseCollectionViewLayout
//
//  Created by jupyter on 20/6/17.
//  Copyright © 2017 jupyter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarEvent.h"

@interface SampleCalendarEvent : NSObject <CalendarEvent>

+ (instancetype)randomEvent;
+ (instancetype)eventWithTitile:(NSString *)title day:(NSUInteger)day startHour:(NSUInteger)startHour durationInHours:(NSUInteger)durationInHours;

- (instancetype)initWithTitle:(NSString *)title day:(NSUInteger)day startHour:(NSUInteger)startHour durationInHours:(NSUInteger)durationInHours;

@end
