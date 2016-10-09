//
//  HistoricalDataItem+CoreDataProperties.h
//  ExchangeApp
//
//  Created by Hany Nady on 7/24/16.
//  Copyright © 2016 Hany Nady. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HistoricalDataItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoricalDataItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *rate;

@end

NS_ASSUME_NONNULL_END
