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

@property (nonatomic, strong) IBOutlet CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTBarPlot *aaplPlot;
@property (nonatomic, strong) CPTBarPlot *googPlot;
@property (nonatomic, strong) CPTBarPlot *msftPlot;
@property (nonatomic, strong) CPTPlotSpaceAnnotation *priceAnnotation;

-(IBAction)aaplSwitched:(id)sender;
-(IBAction)googSwitched:(id)sender;
-(IBAction)msftSwitched:(id)sender;

@end

@implementation CPDBarGraphViewController

CGFloat const CPDBarWidth = 0.25f;
CGFloat const CPDBarInitialX = 0.25f;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initPlot];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Chart behavior
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)configureHost {

    // I couldn't instantiate CPTGraphHostingView in storyboard,
    // I think because class doesn't use ARC and can't mix.
    // parentRect will place view approximately as desired
    // then use auto layout constraints to adjust view
    CGRect parentRect = CGRectMake(0, 80, 400, 160);
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc]
                     initWithFrame:parentRect];
    
    // http://commandshift.co.uk/blog/2013/01/31/visual-format-language-for-autolayout/
    [self.hostView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.hostView];

    NSNumber *tabBarHeight = [NSNumber
                              numberWithInt:self.tabBarController.tabBar.bounds.size.height];
    NSDictionary *metrics = @{@"tabBarHeight": tabBarHeight,
                              @"switchHeight": @50};

    NSDictionary *viewsDictionary = @{@"view": self.view,
                                      @"hostView": self.hostView};

    NSArray *horizontalConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"|[hostView]|"
                                      options:NSLayoutFormatAlignAllCenterX
                                      metrics:metrics
                                      views:viewsDictionary];

    [self.view addConstraints:horizontalConstraints];

    NSArray *verticalConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:|-switchHeight-[hostView]-tabBarHeight-|"
                                      options:NSLayoutFormatAlignAllCenterX
                                      metrics:metrics
                                      views:viewsDictionary];

    [self.view addConstraints:verticalConstraints];

    self.hostView.allowPinchScaling = NO;
}

-(void)configureGraph {
}

-(void)configurePlots {
}

-(void)configureAxes {
}

-(void)hideAnnotation:(CPTGraph *)graph {
}

#pragma mark - IBActions
-(IBAction)aaplSwitched:(id)sender {
}

-(IBAction)googSwitched:(id)sender {
}

-(IBAction)msftSwitched:(id)sender {
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
