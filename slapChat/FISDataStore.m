//
//  FISDataStore.m
//  playingWithCoreData
//
//  Created by Joe Burgess on 6/27/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISDataStore.h"
#import "Recipient.h"

@implementation FISDataStore
@synthesize managedObjectContext = _managedObjectContext;

#pragma mark - Singleton

+ (instancetype)sharedDataStore {
    static FISDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[FISDataStore alloc] init];
    });

    return _sharedDataStore;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"slapChat.sqlite"];
    
    NSError *error = nil;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"slapChat" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Fetch/Save

- (void)fetchData
{
    NSFetchRequest *recipientsRequest = [NSFetchRequest fetchRequestWithEntityName:@"Recipient"];

    NSSortDescriptor *nameSorter = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    recipientsRequest.sortDescriptors = @[nameSorter];

    self.recipients = [self.managedObjectContext executeFetchRequest:recipientsRequest error:nil];

    if ([self.recipients count] == 0) {
        [self generateTestData];
    }
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Test data

- (void)generateTestData
{
    Message *messageOne = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    
    messageOne.content = @"Message 1";
    messageOne.createdAt = [NSDate date];
    
    Message *messageTwo = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    messageTwo.content = @"Message 2";
    messageTwo.createdAt = [NSDate date];
    
    Message *messageThree = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    
    messageThree.content = @"Message 3";
    messageThree.createdAt = [NSDate date];
    
    Recipient *recipient1 = [NSEntityDescription insertNewObjectForEntityForName:@"Recipient" inManagedObjectContext:self.managedObjectContext];
    recipient1.name = @"Jason Klondike";
    [recipient1 addMessagesObject:messageOne];
    
    Recipient *recipient2 = [NSEntityDescription insertNewObjectForEntityForName:@"Recipient" inManagedObjectContext:self.managedObjectContext];
    recipient2.name = @"Gracelyn Skye";
    [recipient2 addMessages:[NSSet setWithArray:@[messageTwo, messageThree]]];
    
    
    [self saveContext];
    [self fetchData];
}

#pragma mark - Helpers

- (Message *)createMessage
{
    return [Message messageWithContext:self.managedObjectContext];
}
@end
