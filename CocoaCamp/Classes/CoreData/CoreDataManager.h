//
//  CoreDataManager.h
//  CocoaCamp
//
//  Created by Rusty Zarse on 10/19/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

@property(retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(retain, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(retain, nonatomic) NSManagedObjectModel *managedObjectModel;

- (BOOL)save;

- (NSFetchRequest *)fetchRequestForEntityNamed:(NSString *)entityName;
- (NSArray *)resultsForRequest:(NSFetchRequest *)fetchRequest;


+ (CoreDataManager *)sharedUIThreadInstance;
@end
