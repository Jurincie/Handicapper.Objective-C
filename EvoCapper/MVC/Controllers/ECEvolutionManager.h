//
//  ECEvolutionManager.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/23/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import "stdlib.h"
#import <Foundation/Foundation.h>
#import "Population.h"
#import "Constants.h"
#import "TreeNode.h"

@interface ECEvolutionManager : NSObject

@property (assign)              NSUInteger  generationsAlreadyEvolved;
@property (assign)              NSUInteger  trainingGenerationsThisCycle;
@property (nonatomic, strong)   NSString    *trainingSetPath;
@property (nonatomic, strong)   Population  *population;

- (void)createNewPopoulationWithName:(NSString*)name
                         initialSize:(NSUInteger)initialSize
                        maxTreeDepth:(NSUInteger)maxTreeDepth
                        minTreeDepth:(NSUInteger)mintreeDepth
                        mutationRate:(float)mutationRate
                            comments:(NSString*)comments;

- (NSSet*)createNewHandicappers:(NSUInteger)initialPopSize;
- (NSString*)createRandomDnaStrandForStrand:(NSUInteger)strandNumber;
- (TreeNode*)createTreeForStrand:(NSUInteger)dnaStrand
                         atLevel:(NSUInteger)level;
- (TreeNode*) recoverTreeFromString:(NSString*)inString;
- (NSString*) saveTreeToString:(TreeNode*)tree;
- (NSUInteger)getPastLineVariableForDnaStrand:(NSUInteger)dnaStrand;
- (NSUInteger)getIndexOfComma:(NSString*)inString;
- (NSUInteger) getIndexOfClosedParen:(NSString*)inString;

- (void)trainPopulation:(Population*)poplation
         forGenerations:(NSUInteger)numberGenerationsToTrain;
- (void)updateAndSaveData;
+ (id)sharedManager;

@end
