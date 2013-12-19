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
    
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    self.hostView.hostedGraph = graph;
    
    // 2 - Configure the graph
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainBlackTheme]];
    graph.paddingBottom = 30.0f;
    graph.paddingLeft  = 30.0f;
    graph.paddingTop    = -1.0f;
    graph.paddingRight  = -5.0f;
    
    // 3 - Set up styles
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    
    // 4 - Set up title
    NSString *title = @"Portfolio Prices: April 23 - 27, 2012";
    graph.title = title;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -16.0f);
    
    // 5 - Set up plot space
    CGFloat xMin = 0.0f;
    CGFloat xMax = [[[CPDStockPriceStore sharedInstance] datesInWeek] count];
    CGFloat yMin = 0.0f;
    CGFloat yMax = 800.0f;  // should determine dynamically based on max price
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
}

-(void)configurePlots {
    // 1 - Set up the three plots
    self.aaplPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO];
    self.aaplPlot.identifier = CPDTickerSymbolAAPL;
    self.googPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor greenColor] horizontalBars:NO];
    self.googPlot.identifier = CPDTickerSymbolGOOG;
    self.msftPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
    self.msftPlot.identifier = CPDTickerSymbolMSFT;

    // 2 - Set up line style
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor = [CPTColor lightGrayColor];
    barLineStyle.lineWidth = 0.5;

    // 3 - Add plots to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    CGFloat barX = CPDBarInitialX;
    NSArray *plots = [NSArray arrayWithObjects:self.aaplPlot, self.googPlot, self.msftPlot, nil];
    for (CPTBarPlot *plot in plots) {
        plot.dataSource = self;
        plot.delegate = self;
        plot.barWidth = CPTDecimalFromDouble(CPDBarWidth);
        plot.barOffset = CPTDecimalFromDouble(barX);
        plot.lineStyle = barLineStyle;
        [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
        barX += CPDBarWidth;
    }
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
    return [[[CPDStockPriceStore sharedInstance] datesInWeek] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot
                     field:(NSUInteger)fieldEnum
               recordIndex:(NSUInteger)index {
    
    if ((fieldEnum == CPTBarPlotFieldBarTip) && (index < [[[CPDStockPriceStore sharedInstance] datesInWeek] count])) {
        if ([plot.identifier isEqual:CPDTickerSymbolAAPL]) {
            return [[[CPDStockPriceStore sharedInstance] weeklyPrices:CPDTickerSymbolAAPL] objectAtIndex:index];
        } else if ([plot.identifier isEqual:CPDTickerSymbolGOOG]) {
            return [[[CPDStockPriceStore sharedInstance] weeklyPrices:CPDTickerSymbolGOOG] objectAtIndex:index];
        } else if ([plot.identifier isEqual:CPDTickerSymbolMSFT]) {
            return [[[CPDStockPriceStore sharedInstance] weeklyPrices:CPDTickerSymbolMSFT] objectAtIndex:index];
        }
    }
    return [NSDecimalNumber numberWithUnsignedInteger:index];
}

#pragma mark - CPTBarPlotDelegate methods
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
}

@end
