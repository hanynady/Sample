//
//  CurrentPrice.h
//  ExchangeApp
//
//  Created by Hany Nady on 7/24/16.
//  Copyright © 2016 Hany Nady. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentPrice : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *currencyDescription;
@property (nonatomic, assign) NSString *rate;

@end
