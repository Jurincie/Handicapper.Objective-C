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
@property (nonatomic, strong)   NSArray			*workingPopulationDna;  // an array of arrays of dnaTrees
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
- (Handicapper*)createNewHandicapperForPopulation:(Population*)population
									forGeneration:(NSUInteger)birthGeneration;
- (NSArray*)createNewDnaByCrossingOverDnaFrom:(Handicapper*)parent1
								  withDnaFrom:(Handicapper*)parent2;
- (TreeNode*)createTreeForStrand:(NSUInteger)dnaStrand
                         atLevel:(NSUInteger)level;
- (TreeNode*)recoverTreeFromString:(NSString*)inString;
- (NSString*)saveTreeToString:(TreeNode*)tree;
- (NSUInteger)getTreeNodeTypeAtLevel:(NSUInteger)level;

- (NSUInteger)getParentIndexFromPopulation:(Population*)population
				   withOverallFitnessValue:(double)popsSummedFitness;

- (TreeNode*)copyTree:(TreeNode*)tempTree
		  withoutNode:(TreeNode*)crossoverNode;
- (TreeNode*)copyTree:parent1Root
	replacingNode:crossover1
	withNode:crossover2;
- (TreeNode*)getNodeFromChildAtLevel:(NSUInteger)parent1Level
						   usingTree:(TreeNode*)parent2Root;
- (void)freeTree:(TreeNode*)node;

- (void)trainPopulationForGenerations:(NSUInteger)numberGenerations;
- (void)testPopulation:(Population*)testPopulation
	  includingParents:(BOOL)testChildrenOnly
 withResultFilesAtPath:(NSString*)path;
- (void)sortRankedPopulation;

- (void)fillWorkingPopulationArrayWithOriginalMembers;
- (void)replaceOldDnaStringsForChildWithIndex:(NSUInteger)popIndex;
- (void)createNextGenerationForPopulation:(Population*)testPopulation;
- (void)replaceBottomHalfOfPopulationWithNewChildren;
- (void)mutateChildrenForPopulation:(Population*)pop;
- (void)mutateHandicappersDnaTrees:(Handicapper*)futureMutant;

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
