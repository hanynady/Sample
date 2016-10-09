//
//  CachingCoordinatorImpl.h
//  ExchangeApp
//
//  Created by Hany Nady on 7/24/16.
//  Copyright © 2016 Hany Nady. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CachingCoordinator.h"

@interface CachingCoordinatorImpl : NSObject <CachingCoordinator>

@property (readonly, strong, nonatomic) NSManagedObjectContext *privatemanagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
