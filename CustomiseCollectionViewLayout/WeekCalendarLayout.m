//
//  WeekCalendarLayout.m
//  CustomiseCollectionViewLayout
//
//  Created by jupyter on 20/6/17.
//  Copyright © 2017 jupyter. All rights reserved.
//

#import "WeekCalendarLayout.h"
#import "CalendarDataSource.h"

static const NSUInteger DaysPerWeek = 6;
static const NSUInteger HoursPerDay = 24;
static const CGFloat HorizontalSpacing = 10;

static const CGFloat HourHeaderHeight = 50;
static const CGFloat HourHeaderWidth = 100;

static const CGFloat DayHeaderHeight = 40;
static const CGFloat DayHeaderWidth = 50;

static const CGFloat WidthPerHour = 100;
static const CGFloat HeightPerHour = 50;

@interface WeekCalendarLayout ()

@end

@implementation WeekCalendarLayout

#pragma mark - UICollectionViewLayout Implementation

- (CGSize)collectionViewContentSize
{
    // Don't scroll horizontally
    CGFloat contentWidth = DayHeaderWidth + (WidthPerHour * HoursPerDay);
//        CGFloat contentWidth = self.collectionView.bounds.size.width;
    
    // Scroll vertically to display a full day
    CGFloat contentHeight = self.collectionView.bounds.size.width;
    
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 1. Create an empty mutable array to contain all the layout attributes.
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    // 2. Find indexPaths of all cells located in the rectangle
    //      and apply the layoutAttributesForItemAtIndexPath
    NSArray *visibleIndexPaths = [self indexPathsOfItemsInRect:rect];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    // Supplementary views
    // 3. Find indexPaths of all other cells like supplementary views and doraction view
    //       and get its attributes.
    NSArray *dayHeaderViewIndexPaths = [self indexPathsOfDayHeaderViewsInRect:rect];
    for (NSIndexPath *indexPath in dayHeaderViewIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"DayRowHeaderView" atIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    NSArray *hourHeaderViewIndexPaths = [self indexPathsOfHourHeaderViewsInRect:rect];
    for (NSIndexPath *indexPath in hourHeaderViewIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"HourColumnHeaderView" atIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    NSArray *visibleIndexPathsS = [self indexPathsOfSeparatorsInRect:rect]; // will implement below
    for (NSIndexPath *indexPath in visibleIndexPathsS) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForDecorationViewOfKind:@"Separator" atIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDataSource *dataSource = self.collectionView.dataSource;
    id<CalendarEvent> event = [dataSource eventAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = [self frameForEvent:event];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    CGFloat totalWidth = [self collectionViewContentSize].width;
    if ([kind isEqualToString:@"DayRowHeaderView"]) {
//        attributes.frame = CGRectMake(HourHeaderWidth + (widthPerDay * indexPath.item), 0, widthPerDay, DayHeaderHeight);
        
        UICollectionView * const cv = self.collectionView;
        CGPoint const contentOffset = cv.contentOffset;
        CGPoint nextHeaderOrigin = CGPointMake(INFINITY, INFINITY);
        
        if (indexPath.section+1 < [cv numberOfSections]) {
            UICollectionViewLayoutAttributes *nextHeaderAttributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section+1]];
            nextHeaderOrigin = nextHeaderAttributes.frame.origin;
        }
        attributes.frame = CGRectMake(MIN(MAX(contentOffset.x, attributes.frame.origin.x), nextHeaderOrigin.x - CGRectGetWidth(attributes.frame)), (HourHeaderHeight + DayHeaderHeight * indexPath.item), DayHeaderWidth * 3, DayHeaderHeight);
        attributes.zIndex = 10;
    } else if ([kind isEqualToString:@"HourColumnHeaderView"]) {
//        CGFloat availableWidth = totalWidth - HourHeaderWidth;
//        CGFloat widthPerDay = availableWidth / DaysPerWeek;
        attributes.frame = CGRectMake((DayHeaderWidth + HourHeaderWidth / 2 + HourHeaderWidth * indexPath.item), 0, HourHeaderWidth, HourHeaderHeight);
        
//        attributes.frame = CGRectMake(0, DayHeaderHeight + HeightPerHour * indexPath.item, totalWidth, HeightPerHour);
        attributes.zIndex = 10;
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
//    CGRect oldBounds = self.collectionView.bounds;
//    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
//        return YES;
//    }
//    return NO;
    return YES;
}


#pragma mark - Helpers

- (NSArray *)indexPathsOfSeparatorsInRect:(CGRect)rect
{
    
    NSInteger firstCellIndexToShow = floorf(rect.origin.x / WidthPerHour);
    NSInteger lastCellIndexToShow = floorf((rect.origin.x + [self collectionViewContentSize].width - DayHeaderWidth) / WidthPerHour);
    
//    NSInteger countOfItems = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    NSInteger countOfItems = 24;
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (int i = MAX(firstCellIndexToShow, 0); i <= lastCellIndexToShow; i++) {
        if (i < countOfItems) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    return indexPaths;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
//    CGFloat decorationOffset = (indexPath.row + 1) * WidthPerHour + indexPath.row * 2;
    CGFloat decorationOffset = DayHeaderWidth + (indexPath.row * HourHeaderWidth) + (HourHeaderWidth / 1.2);
    layoutAttributes.frame = CGRectMake(decorationOffset, HourHeaderHeight , 1, DayHeaderHeight * (DaysPerWeek + 1));
    layoutAttributes.zIndex = -1;
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath {
    UICollectionViewLayoutAttributes *layoutAttributes =  [self layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:decorationIndexPath];
    return layoutAttributes;
}

- (NSArray *)indexPathsOfItemsInRect:(CGRect)rect
{
    NSInteger minVisibleDay = [self dayIndexFromXCoordinate:CGRectGetMinX(rect)];
    NSInteger maxVisibleDay = [self dayIndexFromXCoordinate:CGRectGetMaxX(rect)];
    NSInteger minVisibleHour = [self hourIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxVisibleHour = [self hourIndexFromYCoordinate:CGRectGetMaxY(rect)];
    
    //    NSLog(@"rect: %@, days: %d-%d, hours: %d-%d", NSStringFromCGRect(rect), minVisibleDay, maxVisibleDay, minVisibleHour, maxVisibleHour);
    
    CalendarDataSource *dataSource = self.collectionView.dataSource;
    NSArray *indexPaths = [dataSource indexPathsOfEventsBetweenMinDayIndex:minVisibleDay maxDayIndex:maxVisibleDay minStartHour:minVisibleHour maxStartHour:maxVisibleHour];
    return indexPaths;
}

- (NSInteger)dayIndexFromXCoordinate:(CGFloat)xPosition
{
    CGFloat contentWidth = [self collectionViewContentSize].width - HourHeaderWidth;
    CGFloat widthPerDay = contentWidth / DaysPerWeek;
    NSInteger dayIndex = MAX((NSInteger)0, (NSInteger)((xPosition - HourHeaderWidth) / widthPerDay));
    return dayIndex;
}

- (NSInteger)hourIndexFromYCoordinate:(CGFloat)yPosition
{
    NSInteger hourIndex = MAX((NSInteger)0, (NSInteger)((yPosition - DayHeaderHeight) / HeightPerHour));
    return hourIndex;
}

- (NSArray *)indexPathsOfDayHeaderViewsInRect:(CGRect)rect
{
    if (CGRectGetMinY(rect) > DayHeaderHeight) {
        return [NSArray array];
    }
    
    NSInteger minDayIndex = [self dayIndexFromXCoordinate:CGRectGetMinX(rect)];
    NSInteger maxDayIndex = [self dayIndexFromXCoordinate:CGRectGetMaxX(rect)];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger idx = minDayIndex; idx <= maxDayIndex; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

- (NSArray *)indexPathsOfHourHeaderViewsInRect:(CGRect)rect
{
    if (CGRectGetMinX(rect) > HourHeaderWidth) {
        return [NSArray array];
    }
    
    NSInteger minHourIndex = [self hourIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxHourIndex = [self hourIndexFromYCoordinate:CGRectGetMaxY(rect)];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger idx = minHourIndex; idx <= maxHourIndex; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

- (CGRect)frameForEvent:(id<CalendarEvent>)event
{
    CGFloat totalWidth = [self collectionViewContentSize].width - HourHeaderWidth;
    CGFloat widthPerDay = totalWidth / DaysPerWeek;
    
    CGRect frame = CGRectZero;
    frame.origin.x = DayHeaderWidth + WidthPerHour * (event.startHour + 0.79);
    frame.origin.y = HourHeaderHeight + DayHeaderHeight * event.day;
    
    frame.size.width = event.durationInHours * WidthPerHour;
    frame.size.height = DayHeaderHeight;
    
    frame = CGRectInset(frame, HorizontalSpacing/2.0, 0);
    return frame;
}


@end
