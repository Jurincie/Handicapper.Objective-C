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
#import "Handicapper.h"

@interface ECEvolutionManager : NSObject

@property (assign)              NSUInteger      generationsAlreadyEvolved;
@property (assign)              NSUInteger      trainingGenerationsThisCycle;
@property (nonatomic, strong)   NSString        *trainingSetPath;
@property (nonatomic, strong)   Population      *population;
@property (nonatomic, strong)   NSMutableArray  *workingPopulationMembersDna;

- (void)createNewPopoulationWithName:(NSString*)name
                         initialSize:(NSUInteger)initialSize
                        maxTreeDepth:(NSUInteger)maxTreeDepth
                        minTreeDepth:(NSUInteger)mintreeDepth
                        mutationRate:(float)mutationRate
                            comments:(NSString*)comments;

- (void)createNewHandicappers:(NSUInteger)initialPopSize;
- (Handicapper*)getHandicapperWithPopIndex:(NSUInteger)popIndex;
- (void)trainPopulationForGenerations:(NSUInteger)numberGenerations;
- (NSArray*)testUsingResultFilesAtPath:(NSString*)path;

- (void)replaceOldDnaStringsForChildWithIndex:(NSUInteger)popIndex;
- (void)removeOldDnaTreesForChildWithIndex:(NSUInteger)popIndex;

- (void)createNextGenerationFromFitnessValues:(NSArray*)fitnessArray;

- (void)crossoverMember:(Handicapper*)mother
             withMember:(Handicapper*)father
              forChild1:(Handicapper*)child1
              andChild2:(Handicapper*)child2;

- (void)killBottomHalfOfPopulation;
- (void)createChildren;
- (void)mutatePopulation;

- (TreeNode*)createTreeForStrand:(NSUInteger)dnaStrand
                         atLevel:(NSUInteger)level;
- (TreeNode*)recoverTreeFromString:(NSString*)inString;
- (NSString*)saveTreeToString:(TreeNode*)tree;
- (NSUInteger)getTreeNodeTypeAtLevel:(NSUInteger)level;
- (TreeNode*)copyTree:(TreeNode*)tempTree
              without:(TreeNode*)crossoverNode;

- (NSUInteger)getPastLineVariableForDnaStrand:(NSUInteger)dnaStrand;
- (NSUInteger)getIndexOfComma:(NSString*)inString;
- (NSUInteger)getIndexOfClosedParen:(NSString*)inString;

- (void)updateAndSaveData;
+ (id)sharedManager;

// overflow, underflow and division by zero are ignored here
// to be trapped in evalTree method
double getRand(int max, int granularity);

@end
