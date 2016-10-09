//
//  ViewController.m
//  ExchangeApp
//
//  Created by Hany Nady on 7/23/16.
//  Copyright © 2016 Hany Nady. All rights reserved.
//

#import "ViewController.h"
#import "HistoricalDataProvider.h"
#import "CurrentPriceService.h"
#import "MBProgressHUD.h"
#import "ChartView.h"


const NSInteger secondsPerDay = 24 * 60 * 60;


@interface ViewController () <CurrentPriceServiceProtocol>

@property (weak, nonatomic) IBOutlet UIView *chartContainerView;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceValueLabel;

@property (nonatomic, strong) MBProgressHUD	*loadingView;
@property (nonatomic, strong) HistoricalDataProvider *dataProvider;
@property (nonatomic, strong) CurrentPriceService *currentPriceService;
@property (nonatomic, strong) ChartView *chartView;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder:aDecoder];
	if (self) {
		_dataProvider = [[HistoricalDataProvider alloc] init];
		_currentPriceService = [[CurrentPriceService alloc] initWithCurrency:kCurrencyISO delegate:self];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSArray *cachedData = [self.dataProvider getCachedHistoricalData];
	if (cachedData.count) {
		[self loadChartViewWithHistoricalList:cachedData];
	}
	[self fetchHistoricalData];
	[self.currentPriceService startService];
}

- (void)fetchHistoricalData {
	
	self.loadingView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	self.loadingView.mode = MBProgressHUDModeAnnularDeterminate;
	self.loadingView.labelText = @"Loading";
	[self.dataProvider getHistoricalDataForCurrency:kCurrencyISO
											   from:[[NSDate date] dateByAddingTimeInterval:- 28 *secondsPerDay]
												 to:[NSDate date]
									   successBlock:^(NSArray *historicalList) {
										   
										   self.loadingView.hidden = YES;
										   [self loadChartViewWithHistoricalList:historicalList];

									   }
									   failureBlock:^(NSError *error) {
										   self.loadingView.hidden = YES;
									   }];
	
}

- (void)viewDidLayoutSubviews {
	
	[super viewDidLayoutSubviews];
	self.chartView.frame = self.chartContainerView.frame;
}

- (void)loadChartViewWithHistoricalList:(NSArray *)historicalList {
	
	NSArray *datesAsDates = [self sortedDatesArray:[historicalList valueForKey:@"date"]];

	NSArray *arrayOfDatesAsStrings = [self datesStringForChartFromArr:datesAsDates];
	self.chartView = [[ChartView alloc] initWithChartXValues:arrayOfDatesAsStrings andChartYValues:[historicalList valueForKey:@"rate"]];
	self.chartView.frame = self.chartContainerView.frame;
	[self.chartContainerView addSubview:self.chartView];
}

- (NSArray *)sortedDatesArray:(NSArray *)originalArr {
	
	NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
	return [originalArr sortedArrayUsingDescriptors:@[descriptor]];
}

- (NSArray *)datesStringForChartFromArr:(NSArray *)datesArray {
	
	NSMutableArray *arrayOfDatesAsStrings = [[NSMutableArray alloc] init];
	for (NSDate* dateAsDate in datesArray) {
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"dd/MM"];
		
		NSString *dateAsStr = [dateFormat stringFromDate:dateAsDate];
		
		[arrayOfDatesAsStrings addObject:dateAsStr];
	}
	return arrayOfDatesAsStrings;
}

#pragma mark CurrentPriceServiceProtocol methods 

- (void)currentPriceDidUpdateTo:(CurrentPrice *)currentPrice {
	
	self.currentPriceValueLabel.text = currentPrice.rate;
}
@end
