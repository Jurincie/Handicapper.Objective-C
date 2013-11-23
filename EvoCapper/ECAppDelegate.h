//
//  ECAppDelegate.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/22/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ECEvolutionController.h"
#import "ECPopulation.h"

@interface ECAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator	*persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel			*managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext			*managedObjectContext;

@property (strong, nonatomic) ECEvolutionController	*evolutionManager;
@property (strong, nonatomic) ECPopulation			*currentPopulation;

- (IBAction)createNewPopulationButtonTapped:(id)sender;
- (IBAction)trainPopulationButtonTapped:(id)sender;

- (IBAction)saveAction:(id)sender;

@end
