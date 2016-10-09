//
//  CachingCoordinatorImpl.m
//  ExchangeApp
//
//  Created by Hany Nady on 7/24/16.
//  Copyright © 2016 Hany Nady. All rights reserved.
//

#import "CachingCoordinatorImpl.h"
#import "HistoricalDataItem.h"

@implementation CachingCoordinatorImpl


#pragma mark - Core Data stack

@synthesize managedObjectContext			= _managedObjectContext;
@synthesize privatemanagedObjectContext		= _privatemanagedObjectContext;
@synthesize managedObjectModel				= _managedObjectModel;
@synthesize persistentStoreCoordinator		= _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
	// The directory the application uses to store the Core Data store file. This code uses a directory named "Number26.ExchangeApp" in the application's documents directory.
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
	// The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
	if (_managedObjectModel != nil) {
		return _managedObjectModel;
	}
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ExchangeApp" withExtension:@"momd"];
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	// The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
	if (_persistentStoreCoordinator != nil) {
		return _persistentStoreCoordinator;
	}
	
	// Create the coordinator and store
	
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ExchangeApp.sqlite"];
	NSError *error = nil;
	NSString *failureReason = @"There was an error creating or loading the application's saved data.";
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
		// Report any error we got.
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
		dict[NSLocalizedFailureReasonErrorKey] = failureReason;
		dict[NSUnderlyingErrorKey] = error;
		error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
		// Replace this with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
	
	NSManagedObjectContext *privateContext = self.privatemanagedObjectContext;
	
	if (privateContext != nil) {
		
		static dispatch_once_t onceTokenForCoreDataMainMOCSetup;
		
		dispatch_once(&onceTokenForCoreDataMainMOCSetup, ^{
			_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
			[_managedObjectContext setParentContext:privateContext];
		});
		
	}
	
	return _managedObjectContext;
}

- (NSManagedObjectContext *) privatemanagedObjectContext {
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		
		static dispatch_once_t onceTokenForCoreDataMasterMOCSetup;
		
		dispatch_once(&onceTokenForCoreDataMasterMOCSetup, ^{
			_privatemanagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
			[_privatemanagedObjectContext setPersistentStoreCoordinator: coordinator];
		});
		
	}
	
	return _privatemanagedObjectContext;
	
}

#pragma mark - Core Data Saving support

- (BOOL)resetAndSaveContext {
	
	[self deleteStoredData];
	return [self saveContext];
}

- (BOOL)saveContext {
	
	__block NSManagedObjectContext *privateContext =  [self privatemanagedObjectContext];
	
	__block NSError *error = nil;
	
	if ([_managedObjectContext hasChanges]) {
		
		[_managedObjectContext performBlock:^{
			
			[_managedObjectContext save:&error];
			
			if (error) {
				NSLog(@"Error in saving changes to Temporary Context:%@",error);
			}
			
			if ([privateContext hasChanges]) {
				
				[privateContext performBlock:^{
					[privateContext save:&error];
					
					if (error) {
						NSLog(@"Error in committing changes to DB:%@",error);
					}
				}];
			}
			
		}];
	}
	
	return !error;
}

- (void)deleteStoredData {
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	NSError *deleteError = nil;
	[request setEntity:[NSEntityDescription entityForName:(NSStringFromClass([HistoricalDataItem class])) inManagedObjectContext:self.managedObjectContext]];
	NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
	[self.persistentStoreCoordinator executeRequest:delete withContext:self.managedObjectContext error:&deleteError];
}

#pragma mark - Search methods

- (NSArray *)getCachedHistoricalData {
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	NSError *fetchError = nil;
	[request setEntity:[NSEntityDescription entityForName:(NSStringFromClass([HistoricalDataItem class])) inManagedObjectContext:self.managedObjectContext]];
	return [self.managedObjectContext executeFetchRequest:request error:&fetchError];
}

@end
