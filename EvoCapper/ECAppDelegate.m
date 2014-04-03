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
    self.evolutionManager = [[ECMainController alloc] init];
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
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).",
																		[applicationFilesDirectory path]];
            
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
- (IBAction)editPastLinesButtonTapped:(id)sender
{
	NSString *uneditedPastLinePath = @"/Users/ronjurincie/Desktop/Project Ixtlan/Dogs/Unedited Past Lines";
	
	[self.evolutionManager editPastLinesAtPath:uneditedPastLinePath];
}

- (IBAction)buildTrackStatisticsButtonTapped:(id)sender
{
	// check to see if ECTracks object exists in CoreData
	NSError *error					= nil;
	NSFetchRequest *fetchRequest	= [[NSFetchRequest alloc] init];
	NSEntityDescription *entity		= [NSEntityDescription entityForName:@"ECTracks"
												  inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest
																	   error:&error];
	
	if(fetchedObjects.count > 0)
	{
		// tracks object already exists
	
	}
	else
	{
		[self.evolutionManager modelTracks];
	}
}

- (IBAction)startButtonTapped:(id)sender
{
	// check to see if coreData has any populations
	NSError *error					= nil;
	BOOL oneOrMorePopulationsExist	= YES;
	BOOL selectOldPopulation		= NO;
	NSArray *newPopulationStrings	= nil;

	NSFetchRequest *fetchRequest	= [[NSFetchRequest alloc] init];
	NSEntityDescription *entity		= [NSEntityDescription entityForName:@"ECHandicapperPopulation"
												  inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];

	NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest
																	   error:&error];
				
	if(fetchedObjects.count > 0)
	{
		oneOrMorePopulationsExist = YES;
	}
	
	if(oneOrMorePopulationsExist)
	{
		// present NSAlert with options:
		//	createNewPopulation
		//	openExistingPopulation
		NSAlert *alert = [NSAlert alertWithMessageText:@"EvoCapper"
										 defaultButton:@"Create New Population"
									   alternateButton:@"Open Existing Population"
										   otherButton:nil
							 informativeTextWithFormat:@"Select or create a new population:"];
	
		if([alert runModal] == NSAlertFirstButtonReturn)
		{
			selectOldPopulation = YES;
		}
	}
	
	if(selectOldPopulation)
	{
	
	}
	else
	{
		// prompt user for new population fields
		newPopulationStrings		= [self getNewPopulationInformation];
		NSString *populationName	= [newPopulationStrings objectAtIndex:0];
		NSUInteger initialSize		= [[newPopulationStrings objectAtIndex:1] unsignedIntegerValue];
		NSUInteger maxTreeDepth		= [[newPopulationStrings objectAtIndex:2] unsignedIntegerValue];
		NSUInteger minTreeDepth		= [[newPopulationStrings objectAtIndex:3] unsignedIntegerValue];
		double mutationRate			= [[newPopulationStrings objectAtIndex:4] doubleValue];
		NSString *comments			= [newPopulationStrings objectAtIndex:5];
		
		
		[self.evolutionManager createNewPopoulationWithName:populationName
												initialSize:initialSize
											   maxTreeDepth:maxTreeDepth
											   minTreeDepth:minTreeDepth
											   mutationRate:mutationRate
												   comments:comments];
		
		self.currentPopulation = self.evolutionManager.population;
	}

	[self saveManagedObjectState];
}

- (void)saveManagedObjectState
{
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

- (NSArray*)getNewPopulationInformation
{
	NSMutableArray *newPopulationStrings = [NSMutableArray new];
	
	
	NSString *populationName	= nil;
	NSUInteger initialSize		= 0;
	NSUInteger maxTreeDepth		= 0;
	NSUInteger minTreeDepth		= 0;
	double mutationRate			= 0.0;
	NSString *commentString		= nil;
	
	[newPopulationStrings addObject:populationName];
	[newPopulationStrings addObject:[NSString stringWithFormat:@"%lu", initialSize]];
	[newPopulationStrings addObject:[NSString stringWithFormat:@"%lu", maxTreeDepth]];
	[newPopulationStrings addObject:[NSString stringWithFormat:@"%lu", minTreeDepth]];
	[newPopulationStrings addObject:[NSString stringWithFormat:@"%lf", mutationRate]];
	[newPopulationStrings addObject:commentString];
		
	if(initialSize == 0 || initialSize > kMaximumPopulationSize ||
	   maxTreeDepth == 0  || maxTreeDepth > kMaximumTreeDepth ||
	   minTreeDepth == 0  || minTreeDepth > kTopMinimumTreeDepth || minTreeDepth >= maxTreeDepth ||
	   mutationRate == 0  || mutationRate > kMaximumMutationRate)
	{
		// bad data sends nil string on return
		[newPopulationStrings removeAllObjects];
		newPopulationStrings = nil;
	}
	
	return newPopulationStrings;
}

- (IBAction)buildTrackStatsFromPastLinesButtonTapped:(id)sender
{
	NSLog(@"buildTrackStatsFromPastLines Button Tapped");
	
	[self.evolutionManager getUnmodeledTracksStatsFromPopulationsPastLines:@"/Users/ronjurincie/Desktop/Project Ixtlan/Dogs/Past Lines Library"];

}

- (IBAction)trainPopulationButtonTapped:(id)sender
{
    NSLog(@"Train Population Button Tapped");

    [self.evolutionManager trainPopulationForGenerations:2];
}

@end
