//
//  HistoricalDataProvider.m
//  ExchangeApp
//
//  Created by Hany Nady on 7/23/16.
//  Copyright © 2016 Hany Nady. All rights reserved.
//

#import "HistoricalDataProvider.h"
#import "CachingCoordinatorImpl.h"
#import "HistoricalDataItem.h"
#import "NSDate+API.h"
#import <AFNetworking/AFNetworking.h>

@interface HistoricalDataProvider ()

@property (nonatomic, strong) id<CachingCoordinator> cachingCoordinator;

@end

@implementation HistoricalDataProvider


- (instancetype)init {
	
	self = [self initWithCachingCoordinator:[[CachingCoordinatorImpl alloc] init]];
	
	return self;
}

- (instancetype)initWithCachingCoordinator:(id<CachingCoordinator>)cachingCoordinator;{
	
	self = [super init];
	if (self) {
		_cachingCoordinator = cachingCoordinator;
	}
	return self;
}

- (void)getHistoricalDataForCurrency:(NSString *)currencyISO
								from:(NSDate *)startDate
								  to:(NSDate *)endDate
						successBlock:(void (^)(NSArray *historyList))successBlock
						failureBlock:(void (^)( NSError *error))failureBlock {
	
	NSString * urlStr = [NSString stringWithFormat:@"https://api.coindesk.com/v1/bpi/historical/close.json?start=%@&end=%@&currency=%@",[startDate getAPIFormat],[endDate getAPIFormat],currencyISO];
	NSURL			*url		= [NSURL URLWithString:urlStr];
	NSURLRequest	*request	= [NSURLRequest requestWithURL:url];
	
 
	AFHTTPRequestOperation *operation	= [[AFHTTPRequestOperation alloc] initWithRequest:request];
	operation.responseSerializer		= [AFHTTPResponseSerializer serializer];
 
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		NSError* error;
		NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
															 options:kNilOptions
															   error:&error];
		id response = [self parseGetHestoricalDataResponse:json];
		[self.cachingCoordinator resetAndSaveContext];
		if (error) {
			failureBlock(error);
		} else {
			successBlock(response);
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		failureBlock(error);
	}];
 
	
	[operation start];
}

- (NSArray *)getCachedHistoricalData {
	
	return [self.cachingCoordinator getCachedHistoricalData];
}
- (NSArray *)parseGetHestoricalDataResponse:(id)response {
	
	NSDictionary *rawData = [response objectForKey:@"bpi"];
	
	NSMutableArray *parsedList = [[NSMutableArray alloc] init];
	
	for (NSString *date in rawData.allKeys) {
		
		HistoricalDataItem *item = [NSEntityDescription insertNewObjectForEntityForName:(NSStringFromClass([HistoricalDataItem class])) inManagedObjectContext:self.cachingCoordinator.managedObjectContext];
		
		
		item.date = [NSDate dateFromDateString:date];
		item.rate = [rawData objectForKey:date];
		
		[parsedList addObject:item];
	}
	
	return parsedList;
}
	
@end
