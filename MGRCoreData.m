//
//  MGRCoreData.m
//  MinimalMessenger
//
//  Created by Matt Rosemeier on 5/3/14.
//  Copyright (c) 2014 Matt Rosemeier. All rights reserved.
//

#import "MGRCoreData.h"
@import CoreData;

@interface MGRCoreData ()
@property (strong, nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readwrite) NSManagedObjectContext *backgroundContext;
@property (strong, nonatomic, readwrite) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic, readwrite) NSString *stackStoreModelName;
@end

@implementation MGRCoreData

- (instancetype)initWithStackStoreModelName:(NSString *)stackStoreModelName
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _stackStoreModelName = stackStoreModelName;
    
    return self;
}


- (NSManagedObjectContext *)backgroundContext {
    if (_backgroundContext != nil) {
        return _backgroundContext;
    }
    
    _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    //You actually want the background context to create the main one
    _backgroundContext.parentContext = self.managedObjectContext;
    
    return _backgroundContext;
}


// Lazy Accessor Returns the managed object context for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

//Lazy Accessor Returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.stackStoreModelName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Lazy Accessor Returns the persistent store coordinator for the application.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    //Check the backing instance variable for nil
    if (_persistentStoreCoordinator != nil) {
        //if it exists, return it
        return _persistentStoreCoordinator;
    }
    
    //if it doesn't, lets create one
    
    //File name
    NSString *pathComponent = [self.stackStoreModelName stringByAppendingPathExtension:@"sqlite"];
    
    //Where to save
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:pathComponent];
    
    NSError *error;
    
    //Create store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        //lets abort
        abort();
    }
    
    //return
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
