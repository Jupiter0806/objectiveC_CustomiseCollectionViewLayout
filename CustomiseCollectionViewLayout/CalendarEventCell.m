//
//  CalendarEventCell.m
//  CustomiseCollectionViewLayout
//
//  Created by jupyter on 19/6/17.
//  Copyright © 2017 jupyter. All rights reserved.
//

#import "CalendarEventCell.h"

@implementation CalendarEventCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0.7 alpha:1] CGColor];
}

- (IBAction)showTapped:(id)sender {
   NSLog(@"%@", [NSString stringWithFormat:@"%@: Day %ld - Hour %ld - Duration %ld", _event.title, (long)_event.day, (long)_event.startHour, (long)_event.durationInHours]);

}
@end
