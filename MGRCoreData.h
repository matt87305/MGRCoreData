//
//  MGRCoreData.h
//  MinimalMessenger
//
//  Created by Matt Rosemeier on 5/3/14.
//  Copyright (c) 2014 Matt Rosemeier. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface MGRCoreData : NSObject
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectContext *backgroundContext;
@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic, readonly) NSString *stackStoreModelName;

- (instancetype)initWithStackStoreModelName:(NSString *)stackStoreModelName;
@end
