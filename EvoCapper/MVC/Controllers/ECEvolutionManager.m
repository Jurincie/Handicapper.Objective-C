//
//  ECEvolutionManager.m
//  EvoCapper
//
//  Created by Ron Jurincie on 10/23/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

// Since we only want (1) EvolutionManager Ever to be created
// We have made this class a singleton

#import "ECEvolutionManager.h"

@implementation ECEvolutionManager


- (BOOL)createNewPopoulation
{
    NSLog(@"createNewPopulation called in ECEvolutionManager");
    
    return NO;
}

- (void)trainPopulation
{
    NSLog(@"trainPopulation called in ECEvolutionManager");
}

#pragma mark Singleton Methods

+ (id)sharedManager
{
    static ECEvolutionManager *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

- (id)init
{
    
    NSLog(@"ECEVolutionManager.init called");
    
    if (self = [super init])
    {
        
    }
    
    return self;
}

@end
