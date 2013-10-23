//
//  ECEvolutionManager.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/23/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECEvolutionManager : NSObject

- (BOOL)createNewPopoulation;
- (void)trainPopulation;

+ (id)sharedManager;

@end
