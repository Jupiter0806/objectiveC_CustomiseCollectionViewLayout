//
//  CalendarViewController.m
//  Calendar
//
//  Created by Ole Begemann on 29.07.13.
//  Copyright (c) 2013 Ole Begemann. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarDataSource.h"
#import "HeaderView.h"
#import "FLCollectionSeparator.h"

@interface CalendarViewController ()

@property (strong, nonatomic) IBOutlet CalendarDataSource *calendarDataSource;

@end

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register NIB for supplementary views
    UINib *headerViewNib = [UINib nibWithNibName:@"HeaderView" bundle:nil];
    [self.collectionView registerNib:headerViewNib forSupplementaryViewOfKind:@"DayRowHeaderView" withReuseIdentifier:@"HeaderView"];
    [self.collectionView registerNib:headerViewNib forSupplementaryViewOfKind:@"HourColumnHeaderView" withReuseIdentifier:@"HeaderView"];
    
    [self.collectionView.collectionViewLayout registerClass:[FLCollectionSeparator class] forDecorationViewOfKind:@"Separator"];
    
    // Define cell and header view configuration
    CalendarDataSource *dataSource = (CalendarDataSource *)self.collectionView.dataSource;
    dataSource.configureCellBlock = ^(CalendarEventCell *cell, NSIndexPath *indexPath, id<CalendarEvent> event) {
        cell.titleLabel.text = event.title;
        cell.event = event;
    };
    dataSource.configureHeaderViewBlock = ^(HeaderView *headerView, NSString *kind, NSIndexPath *indexPath) {
        if ([kind isEqualToString:@"HourColumnHeaderView"]) {
            headerView.titleLabel.text = [NSString stringWithFormat:@"%2d:00", indexPath.item + 1];
        } else if ([kind isEqualToString:@"DayRowHeaderView"]) {
            headerView.titleLabel.text = [NSString stringWithFormat:@"Room %d", indexPath.item + 1];
        }
    };
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleDetailCellTappedTwice:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
}

-(void)handleDetailCellTappedTwice:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    if(indexPath)
        return;
}

@end
