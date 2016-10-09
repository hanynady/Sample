//
//  NSDate+API.m
//  ExchangeApp
//
//  Created by Hany Nady on 7/24/16.
//  Copyright © 2016 Hany Nady. All rights reserved.
//

#import "NSDate+API.h"

NSString *dateFormate = @"YYYY-MM-dd";

@implementation NSDate (API)

- (NSString *)getAPIFormat {
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:dateFormate];
	
	return [formatter stringFromDate:self];
	
}

+ (NSDate *)dateFromDateString:(NSString *)dateString {
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:dateFormate];
	return [formatter dateFromString:dateString];
}

@end
