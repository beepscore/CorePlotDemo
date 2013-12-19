//
//  CPDBarGraphViewController.m
//  CorePlotDemo
//
//  Created by Steve Baker on 12/17/13.
//  Copyright (c) 2013 Beepscore LLC. All rights reserved.
//

#import "CPDBarGraphViewController.h"
#import "CPDConstants.h"
#import "CPDStockPriceStore.h"

@interface CPDBarGraphViewController ()

@end

@implementation CPDBarGraphViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot
                     field:(NSUInteger)fieldEnum
               recordIndex:(NSUInteger)index {
    return [NSDecimalNumber numberWithUnsignedInteger:index];
}

#pragma mark - CPTBarPlotDelegate methods
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
}

@end
