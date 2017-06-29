//
//  CalendarDataSource.m
//  CustomiseCollectionViewLayout
//
//  Created by jupyter on 20/6/17.
//  Copyright © 2017 jupyter. All rights reserved.
//

#import "CalendarDataSource.h"
#import "SampleCalendarEvent.h"

@interface CalendarDataSource ()

@property (strong, nonatomic) NSMutableArray *events;

@end


@implementation CalendarDataSource

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _events = [[NSMutableArray alloc] init];
    
    [self generateSampleData];
}

- (void)generateSampleData
{
    for (NSUInteger idx = 0; idx < 20; idx++) {
        SampleCalendarEvent *event = [SampleCalendarEvent randomEvent];
        [self.events addObject:event];
    }
}

#pragma mark - CalendarDataSource

- (id<CalendarEvent>)eventAtIndexPath:(NSIndexPath *)indexPath
{
    return self.events[indexPath.item];
}

- (NSArray *)indexPathsOfEventsBetweenMinDayIndex:(NSInteger)minDayIndex maxDayIndex:(NSInteger)maxDayIndex minStartHour:(NSInteger)minStartHour maxStartHour:(NSInteger)maxStartHour
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    [self.events enumerateObjectsUsingBlock:^(id event, NSUInteger idx, BOOL *stop) {
        if ([event day] >= minDayIndex && [event day] <= maxDayIndex && [event startHour] >= minStartHour && [event startHour] <= maxStartHour) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
            [indexPaths addObject:indexPath];
        }
    }];
    return indexPaths;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.events count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    id<CalendarEvent> event = self.events[indexPath.item];
    CalendarEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarEventCell" forIndexPath:indexPath];
    
    if (self.configureCellBlock) {
        self.configureCellBlock(cell, indexPath, event);
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    
    if (self.configureHeaderViewBlock) {
        self.configureHeaderViewBlock(headerView, kind, indexPath);
    }
    
    return headerView;
}

@end
