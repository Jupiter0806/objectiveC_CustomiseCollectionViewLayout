//
//  CalendarEvent.h
//  CustomiseCollectionViewLayout
//
//  Created by jupyter on 20/6/17.
//  Copyright © 2017 jupyter. All rights reserved.
//

#ifndef CalendarEvent_h
#define CalendarEvent_h


#endif /* CalendarEvent_h */

#import <Foundation/Foundation.h>

@protocol CalendarEvent <NSObject>

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger day;
@property (assign, nonatomic) NSInteger startHour;
@property (assign, nonatomic) NSInteger durationInHours;

@end
