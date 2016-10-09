//
//  HistoricalDataProvider.h
//  ExchangeApp
//
//  Created by Hany Nady on 7/23/16.
//  Copyright © 2016 Hany Nady. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CachingCoordinator.h"

@interface HistoricalDataProvider : NSObject


- (instancetype)initWithCachingCoordinator:(id<CachingCoordinator>)cachingCoordinator;

- (void)getHistoricalDataForCurrency:(NSString *)currencyISO
								from:(NSDate *)startDate
								  to:(NSDate *)endDate
						successBlock:(void (^)(NSArray *historyList))successBlock
						failureBlock:(void (^)( NSError *error))failureBlock;

- (NSArray *)getCachedHistoricalData;

@end
