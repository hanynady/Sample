//
//  CurrentPriceService.h
//  ExchangeApp
//
//  Created by Hany Nady on 7/24/16.
//  Copyright © 2016 Hany Nady. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentPrice.h"

@protocol CurrentPriceServiceProtocol <NSObject>

- (void)currentPriceDidUpdateTo:(CurrentPrice *)currentPrice;

@end


@interface CurrentPriceService : NSObject

@property (nonatomic, weak) id<CurrentPriceServiceProtocol> delegate;

- (instancetype)initWithCurrency:(NSString *)currencyISO delegate:(id<CurrentPriceServiceProtocol>)deleage;

- (void)startService;
- (void)startServiceWithInterval:(NSInteger)interval;
- (void)stopService;

@end
