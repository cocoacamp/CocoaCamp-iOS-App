//
//  CoreDataManager.m
//  CocoaCamp
//
//  Created by Rusty Zarse on 10/19/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import "CoreDataManager.h"
@interface CoreDataManager (Private)
- (NSString *)applicationDocumentsDirectory;
@end

@implementation CoreDataManager
@synthesize managedObjectContext, persistentStoreCoordinator, managedObjectModel;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        if (![NSThread isMainThread]) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(ownedManagedContextDidChange:)
                                                         name:NSManagedObjectContextDidSaveNotification
                                                       object:[self managedObjectContext]];
        }
    }
    
    return self;
}

#pragma mark - Shared Singleton

+ (CoreDataManager *)sharedUIThreadInstance{
    
    // declare static variable
    static CoreDataManager *shared = nil;
    
    if (!shared && ![NSThread isMainThread]) {
        // ensure initialization happens on the main thread
        [self performSelectorOnMainThread:@selector(sharedUIThreadInstance) withObject:nil waitUntilDone:YES];
    }
    // set up dispatch once macro
    static dispatch_once_t pred;
    
    // initialize one time to enforce singleton
    dispatch_once(&pred, ^{
        // return CoreDataManager
        shared = [[CoreDataManager alloc] init];
    });
    
    return shared;
}

#pragma mark -
#pragma mark Context Change Notification

- (void)mergeBackgroundChangeNotification:(NSNotification *)saveNotification{
    // make sure this is always called on the UI Thread
    // merge to UIThread moc from sent notification on the UI thread
	[[[CoreDataManager sharedUIThreadInstance] managedObjectContext] mergeChangesFromContextDidSaveNotification:saveNotification];
	
}
- (void)ownedManagedContextDidChange:(NSNotification *)saveNotification {
    // assuming that all foreground processes use shared UI moc
    if (![NSThread isMainThread]) {
        [self performSelector:@selector(mergeBackgroundChangeNotification:)
                    onThread:[NSThread mainThread]
                  withObject:saveNotification
               waitUntilDone:NO];
    }	
    
}

#pragma mark - Save

- (BOOL)save{
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error])
    {
        NSLog(@"Save FAILED: %@", [error localizedDescription]);
        NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
        if(detailedErrors != nil && [detailedErrors count] > 0) {
            for(NSError* detailedError in detailedErrors) {
                NSLog(@"  DetailedError: %@", [detailedError userInfo]);
            }
        }
        else {
            NSLog(@"  %@", [error userInfo]);
        }
        return NO;
    }
    return YES;

    
}
#pragma mark - Fetch Request Helpers

- (NSFetchRequest *)fetchRequestForEntityNamed:(NSString *)entityName{
    // create fetch request
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    // set entity and managed object context
	[fetchRequest setEntity:[NSEntityDescription entityForName:entityName 
                                        inManagedObjectContext:[self managedObjectContext]]];
    // simple, eh?
    return fetchRequest;
}

- (NSArray *)resultsForRequest:(NSFetchRequest *)fetchRequest
{
	NSError *error = nil;
	NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (error) {
        // log the error.  This won't be as helpful here as up the stack so 
        // consider calling the other selector from the consuming code
        NSLog( @"[CoreDataManager resultsForRequest] Failed to execute query expecting array result.  Error: %@", 
                   [error userInfo] );
    }
	return results;
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
	NSMutableArray *models = [NSMutableArray array];
	for(NSBundle *bundle in [NSBundle allBundles])
	{
		NSArray *modelPaths = [bundle pathsForResourcesOfType:@"momd" inDirectory:nil];
		for(NSString *modelPath in modelPaths)
		{
			NSURL *momURL = [NSURL fileURLWithPath:modelPath];
            
			NSManagedObjectModel *model = [[[NSManagedObjectModel alloc] initWithContentsOfURL:momURL] autorelease];
			if(model != nil) {
				[models addObject:model];
			}
		}
	}
	
	NSLog(@"Merged a total of %d compiled data models", [models count]);
	
	managedObjectModel = [[NSManagedObjectModel modelByMergingModels:models] retain];
    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"CocoaCamp.sqlite"]];
    NSLog(@"%@",storeUrl);
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        NSLog(@"Error encountered while adding persistent store: %@", error);
    }
    
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error; 
    if(![fm createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:&error]){
        NSLog( @"Couldn't create directory for CoreDataManager applicationDocumentsDirectory at path:%@", basePath);
    }
    
    return basePath;
}




@end
