//
//  CachingCoordinator.h
//  ExchangeApp
//
//  Created by Hany Nady on 7/24/16.
//  Copyright © 2016 Hany Nady. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol CachingCoordinator <NSObject>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (BOOL)saveContext;
- (BOOL)resetAndSaveContext;
- (NSArray *)getCachedHistoricalData;

@end
