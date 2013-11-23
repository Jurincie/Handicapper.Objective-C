//
//  ECAppDelegate.m
//  EvoCapper
//
//  Created by Ron Jurincie on 10/22/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import "ECAppDelegate.h"

@implementation ECAppDelegate

@synthesize persistentStoreCoordinator  = _persistentStoreCoordinator;
@synthesize managedObjectModel          = _managedObjectModel;
@synthesize managedObjectContext        = _managedObjectContext;
@synthesize evolutionManager            = _evolutionManager;
@synthesize currentPopulation           = _currentPopulation;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.evolutionManager = [[ECEvolutionController alloc] init];
}

// Returns the directory the application uses to store the Core Data store file.
//This code uses a directory named "co.Pixley.EvoCapper" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager  = [NSFileManager defaultManager];
    NSURL *appSupportURL        = [[fileManager URLsForDirectory:NSApplicationSupportDirectory
                                                       inDomains:NSUserDomainMask] lastObject];
    
    return [appSupportURL URLByAppendingPathComponent:@"co.Pixley.EvoCapper"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel)
    {
        return _managedObjectModel;
    }
	
    NSURL *modelURL     = [[NSBundle mainBundle] URLForResource:@"EvoCapper"
                                                  withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator,
//having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator)
    {
        return _persistentStoreCoordinator;
    }

    NSManagedObjectModel *mom = [self managedObjectModel];

    if (!mom)
    {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }

    NSFileManager *fileManager          = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory    = [self applicationFilesDirectory];
    NSError *error                      = nil;
    NSDictionary *properties            = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey]
                                                                                     error:&error];

    if (!properties)
    {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError)
        {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path]
                        withIntermediateDirectories:YES attributes:nil
                                              error:&error];
        }
        
        if (!ok)
        {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    else
    {
        if (![properties[NSURLIsDirectoryKey] boolValue])
        {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            [dict setValue:failureDescription
                    forKey:NSLocalizedDescriptionKey];
            
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN"
                                        code:101
                                    userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            
            return nil;
        }
    }

    NSURL *url                          = [applicationFilesDirectory URLByAppendingPathComponent:@"EvoCapper.storedata"];
    NSPersistentStoreCoordinator *crdr  = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];

    if (![crdr addPersistentStoreWithType:NSXMLStoreType
                            configuration:nil
                                      URL:url
                                  options:nil
                                    error:&error])
    {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }

    _persistentStoreCoordinator = crdr;

    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext)
    {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];

    if (!coordinator)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
      
        [dict setValue:@"Failed to initialize the store"
                forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file."
                forKey:NSLocalizedFailureReasonErrorKey];
      
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN"
                                             code:9999
                                         userInfo:dict];
      
        [[NSApplication sharedApplication] presentError:error];
        
        return nil;
    }

    _managedObjectContext = [[NSManagedObjectContext alloc] init];

    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case,
// the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save:
// message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSLog(@"Stop / Save Button Tapped");

    NSError *error = nil;

    if (![[self managedObjectContext] commitEditing])
    {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }

    if (![[self managedObjectContext] save:&error])
    {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.

    if (!_managedObjectContext)
    {
        return NSTerminateNow;
    }

    if (![[self managedObjectContext] commitEditing])
    {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }

    if (![[self managedObjectContext] hasChanges])
    {
        return NSTerminateNow;
    }

    NSError *error = nil;
    if (![[self managedObjectContext] save:&error])
    {
        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        
        if (result)
        {
            return NSTerminateCancel;
        }
        
        NSAlert *alert          = [[NSAlert alloc] init];
        NSString *question      = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?",
                                                    @"Quit without saves error question message");
        NSString *info          = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save",
                                                    @"Quit without saves error question info");
        NSString *quitButton    = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton  = NSLocalizedString(@"Cancel", @"Cancel button title");
       
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn)
        {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}


// Custon code

- (IBAction)createNewPopulationButtonTapped:(id)sender
{
	if(self.currentPopulation)
	{
		
	}

    NSLog(@"Create New Population Button Tapped");

    // resent a modal window to get user input for new population values

	self.evolutionManager.populationSize = 16;

    [self.evolutionManager createNewPopoulationWithName:@"Test Name"
                                            initialSize:self.evolutionManager.populationSize
                                           maxTreeDepth:8
                                           minTreeDepth:5
                                           mutationRate:.01
                                               comments:@"Initial Population TEST 1.0.0"];

    self.currentPopulation = self.evolutionManager.population;
	
    // FIX: now add this new population to the coreData database
}

- (IBAction)trainPopulationButtonTapped:(id)sender
{
    NSLog(@"Train Population Button Tapped");

    [self.evolutionManager trainPopulationForGenerations:2];
}

@end
