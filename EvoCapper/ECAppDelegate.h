//
//  ECAppDelegate.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/22/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ECMainController.h"
#import "ECPopulation.h"
#import "Constants.h"

@interface ECAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator	*persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel			*managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext			*managedObjectContext;

@property (strong, nonatomic) ECMainController	*evolutionManager;
@property (strong, nonatomic) ECPopulation			*currentPopulation;

- (IBAction)trainPopulationButtonTapped:(id)sender;
- (IBAction)startButtonTapped:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)buildTrackStatisticsButtonTapped:(id)sender;
- (IBAction)editPastLinesButtonTapped:(id)sender;
- (IBAction)buildTrackStatsFromPastLinesButtonTapped:(id)sender;

- (NSArray*)getNewPopulationInformation;
- (void)saveManagedObjectState;

@end
