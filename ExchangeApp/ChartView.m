//
//  ChartView.m
//  ExchangeApp
//
//  Created by Hany Nady on 7/24/16.
//  Copyright © 2016 Hany Nady. All rights reserved.
//

#import "ChartView.h"


@interface ChartView ()<ChartViewDelegate,BalloonMarkerDelegate>

@property (weak, nonatomic) IBOutlet LineChartView *graphView;

@end
@implementation ChartView

- (instancetype)initWithChartXValues:(NSArray *) chartXValues andChartYValues:(NSArray *)chartYValues {
	
	self = [[[NSBundle mainBundle] loadNibNamed:@"ChartView" owner:self options:nil] objectAtIndex:0];
	if (self) {
		
		_xAxisValues = chartXValues;
		_yAxisValues = chartYValues;
		[self initChartView];
		[self loadChartData];
		
	}
	return self;
}


- (void) initChartView{
	
	self.graphView.delegate = self;
	
	self.graphView.descriptionText = @"";
	self.graphView.noDataTextDescription = @"You need to provide data for the chart.";
	
	self.graphView.highlightEnabled = YES;
	self.graphView.dragEnabled = YES;
	[self.graphView setScaleEnabled:YES];
	self.graphView.pinchZoomEnabled = YES;
	self.graphView.highlightPerDragEnabled = NO;
	
	ChartYAxis *leftAxis = self.graphView.leftAxis;
	[leftAxis removeAllLimitLines];
	leftAxis.startAtZeroEnabled = YES;
	leftAxis.gridLineDashLengths = @[@5.f, @5.f];
	leftAxis.drawLimitLinesBehindDataEnabled = YES;
	
	self.graphView.rightAxis.enabled = NO;
	
	ChartXAxis *xAxis = self.graphView.xAxis;
	
	[xAxis setLabelPosition:XAxisLabelPositionBottom];
	
	UIColor *ballonBGColor = [UIColor blueColor];
	UIColor *balloonTextColor = [UIColor whiteColor];
	
	BalloonMarker *marker = [[BalloonMarker alloc] initWithColor:ballonBGColor textColor:balloonTextColor font:[UIFont fontWithName:@"Verdana" size:12.0] insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
	marker.minimumSize = CGSizeMake(100.f, 100.f);
	marker.delegate = self;
	marker.parentFrame = self.graphView.bounds;
	
	self.graphView.marker = marker;
	
	self.graphView.legend.form = ChartLegendFormLine;
	[self.graphView animateWithXAxisDuration:2.5 easingOption:ChartEasingOptionEaseInOutQuart];
	
}

- (void) loadChartData{
	
	NSMutableArray *yVals = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < self.yAxisValues.count; i++) {
		
		NSString *stringVal = [self.yAxisValues objectAtIndex:i];
		float val = [stringVal floatValue];
		[yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
	}
	
	UIColor *lineColor = [UIColor redColor];
	
	LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@""];
	
	set1.lineDashLengths = @[@5.f, @2.5f];
	[set1 setColor:lineColor];
	[set1 setCircleColor:UIColor.blackColor];
	set1.lineWidth = 1.f;
	set1.circleRadius = 3.f;
	set1.drawCircleHoleEnabled = YES;
	set1.valueFont = [UIFont systemFontOfSize:5.f];
	set1.fillAlpha = 65/255.f;
	set1.fillColor = UIColor.blackColor;
	
	NSMutableArray *dataSets = [[NSMutableArray alloc] init];
	[dataSets addObject:set1];
	
	LineChartData *data = [[LineChartData alloc] initWithXVals:self.xAxisValues dataSets:dataSets];
	
	self.graphView.data = data;
	self.graphView.legend.enabled = NO;
}

#pragma mark - Balloon Delegate

- (NSString *) getSpecializedDescriptionWithEntryIndex:(NSInteger)entryIndex{
	
	NSString *date = [self.xAxisValues objectAtIndex:entryIndex];
	NSString *exchangeRate = [self.yAxisValues objectAtIndex:entryIndex];
	
	NSString *descriptionString = [NSString stringWithFormat:@"%@ : %@",date, exchangeRate];
	
	return descriptionString;
	
}


@end
