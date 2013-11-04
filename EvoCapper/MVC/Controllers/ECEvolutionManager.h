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
#import "RaceRecord.h"

@interface ECEvolutionManager : NSObject

@property (assign)				NSUInteger		currentPopSize;
@property (assign)              NSUInteger		generationsEvolved;
@property (assign)              NSUInteger		trainingGenerationsThisCycle;
@property (nonatomic, strong)   NSString		*trainingSetPath;
@property (nonatomic, strong)   Population		*population;
@property (nonatomic, strong)   NSArray			*workingPopulationMembersDna;  // an array of arrays of dnaTrees
@property (nonatomic, strong)   NSMutableArray	*rankedPopulation;

+ (id)sharedManager;
- (void)updateAndSaveData;

- (void)createNewPopoulationWithName:(NSString*)name
                         initialSize:(NSUInteger)initialSize
                        maxTreeDepth:(NSUInteger)maxTreeDepth
                        minTreeDepth:(NSUInteger)mintreeDepth
                        mutationRate:(float)mutationRate
                            comments:(NSString*)comments;

- (NSMutableArray*)createNewHandicappers;
- (TreeNode*)createTreeForStrand:(NSUInteger)dnaStrand
                         atLevel:(NSUInteger)level;
- (TreeNode*)recoverTreeFromString:(NSString*)inString;
- (NSString*)saveTreeToString:(TreeNode*)tree;
- (NSUInteger)getTreeNodeTypeAtLevel:(NSUInteger)level;
- (TreeNode*)copyTree:(TreeNode*)tempTree
              without:(TreeNode*)crossoverNode;


- (void)trainPopulationForGenerations:(NSUInteger)numberGenerations;
- (void)testPopulation:(Population*)testPopulation
         includingParents:(BOOL)testChildrenOnly
     withResultFilesAtPath:(NSString*)path;

- (void)fillWorkingPopulationArray;
- (void)replaceOldDnaStringsForChildWithIndex:(NSUInteger)popIndex;
- (void)removeOldDnaTreesForChildWithIndex:(NSUInteger)popIndex;
- (void)createNextGenerationForPopulation:(Population*)testPopulation;

- (void)crossoverMember:(Handicapper*)mother
             withMember:(Handicapper*)father
              forChild1:(Handicapper*)child1
              andChild2:(Handicapper*)child2;

- (void)replaceBottomHalfOfPopulationWithNewChildren;
- (void)mutatePopulation:(Population*)pop;

- (NSArray*)getWinPredictionsFromPopulation:(Population*)population
									forRace:(RaceRecord*)raceRecord
							startingAtIndex:(NSUInteger) startIndex;

- (NSUInteger)getPastLineVariableForDnaStrand:(NSUInteger)dnaStrand;
- (NSUInteger)getIndexOfComma:(NSString*)inString;
- (NSUInteger)getIndexOfClosedParen:(NSString*)inString;

- (BOOL)isThisADirectory:(NSString*)path;
- (NSArray*)getRaceRecordsForResultsFileAtPath:(NSString*)resultsFileAtPath;
- (NSUInteger)getWinningPostFromRaceRecord:(RaceRecord*)thisRaceRecord;

// overflow, underflow and division by zero are ignored here
// to be trapped in evalTree method
double getRand(int max, int granularity);

@end
