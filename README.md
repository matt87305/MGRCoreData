MGRCoreData
===========

A Core Data Stack manager class to keep Core Data functionality out of the AppDelegate, a place where it does not belong.


MGRCoreData will allow the creation of multiple sqlite-persisted Core Data stacks (binary and XML are currently not supported).  Simply add the .m and .h files to your project, instantiate MGRCoreData, create your .xcdatamodel, as you normally would, and initialize the stack with the data model name.  The NSManagedObjectContext for the stack, and its NSPersistentStoreCoordinator are all created for you via one init method / built-in accessors:

- (instancetype)initWithStackStoreModelName:(NSString *)stackStoreModelName;





