//
//  NSDate+API.h
//  ExchangeApp
//
//  Created by Hany Nady on 7/24/16.
//  Copyright © 2016 Hany Nady. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (API)

- (NSString *)getAPIFormat;

+ (NSDate *)dateFromDateString:(NSString *)dateString;



@end
