//
//  ECAppDelegate.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/22/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ECEvolutionManager.h"

@interface ECAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) ECEvolutionManager *evolutionManager;

- (IBAction)saveAction:(id)sender;

- (IBAction)createNewPopulationButtonTapped:(id)sender;
- (IBAction)trainPopulationButtonTapped:(id)sender;

@end
