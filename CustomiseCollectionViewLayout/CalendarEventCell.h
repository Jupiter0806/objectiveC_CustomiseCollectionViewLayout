//
//  CalendarEventCell.h
//  CustomiseCollectionViewLayout
//
//  Created by jupyter on 19/6/17.
//  Copyright © 2017 jupyter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarEvent.h"

@interface CalendarEventCell : UICollectionViewCell

@property (weak, nonatomic) id<CalendarEvent> event;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)showTapped:(id)sender;

@end
