//
//  CurrentPriceService.m
//  ExchangeApp
//
//  Created by Hany Nady on 7/24/16.
//  Copyright © 2016 Hany Nady. All rights reserved.
//

#import "CurrentPriceService.h"
#import <AFNetworking/AFNetworking.h>

@interface CurrentPriceService ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *currencyISO;
@property (nonatomic, strong) CurrentPrice *lastFetchedPrice;

@end

@implementation CurrentPriceService

static const NSTimeInterval INTERVAL = 10;

- (instancetype)initWithCurrency:(NSString *)currencyISO delegate:(id<CurrentPriceServiceProtocol>)deleage {
	
	self = [super init];
	if (self) {
		_delegate = deleage;
		_currencyISO = currencyISO;
	}
	return self;
}

- (void)startService {
	
	[self startServiceWithInterval:INTERVAL];
}

- (void)startServiceWithInterval:(NSInteger)interval {
	
	if (self.timer == nil) {
		self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerCalled) userInfo:nil repeats:YES];
		[self.timer fire];
	}
}

- (void)timerCalled {
	
	NSString * urlStr = [NSString stringWithFormat:@"https://api.coindesk.com/v1/bpi/currentprice/%@.json",self.currencyISO];
	NSURL			*url		= [NSURL URLWithString:urlStr];
	NSURLRequest	*request	= [NSURLRequest requestWithURL:url];
	
 
	AFHTTPRequestOperation *operation	= [[AFHTTPRequestOperation alloc] initWithRequest:request];
	operation.responseSerializer		= [AFHTTPResponseSerializer serializer];
	
 
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		NSError* error;
		NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
															 options:kNilOptions
															   error:&error];
		CurrentPrice *newPrice = [self parseGetCurrentPriceFromServerResponse:json];
		if (![self.lastFetchedPrice.rate isEqualToString:newPrice.rate]) {
			
			if ([self.delegate respondsToSelector:@selector(currentPriceDidUpdateTo:)]) {
				[self.delegate currentPriceDidUpdateTo:newPrice];
			}
		}
		self.lastFetchedPrice = newPrice;
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
	}];
 
	
	[operation start];
}

- (void)stopService {
	
	self.timer = nil;
	
}

- (CurrentPrice *)parseGetCurrentPriceFromServerResponse:(NSDictionary *)response {
	
	NSDictionary *bpi = [response objectForKey:@"bpi"];
	NSDictionary *objectData = [bpi objectForKey:self.currencyISO];
	CurrentPrice *currentPrice = [[CurrentPrice alloc] init];
	currentPrice.code = [objectData objectForKey:@"code"];
	currentPrice.currencyDescription = [objectData objectForKey:@"description"];
	currentPrice.rate =[objectData objectForKey:@"rate"];
	return currentPrice;
	
}

- (void)dealloc {
	
	[self stopService];
}
@end
