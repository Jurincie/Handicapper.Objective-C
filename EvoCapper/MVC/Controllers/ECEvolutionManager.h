//
//  ECEvolutionManager.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/23/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import "stdlib.h"
#import <Foundation/Foundation.h>
#import "ECPopulation.h"
#import "Constants.h"
#import "ECTreeNode.h"
#import "ECHandicapper.h"
#import "ECRaceRecord.h"
#import "ECTrainigRaceRecord.h"

@class PastLineRecord;

@interface ECEvolutionManager : NSObject

@property (assign)				NSUInteger		currentPopSize;
@property (assign)              NSUInteger		generationsEvolved;
@property (assign)              NSUInteger		generationsThisCycle;
@property (nonatomic, strong)   NSString		*trainingSetPath;
@property (nonatomic, strong)   ECPopulation	*population;
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

- (ECHandicapper*)createNewHandicapperForPopulation:(ECPopulation*)population
									forGeneration:(NSUInteger)birthGeneration;

- (NSArray*)createNewDnaByCrossingOverDnaFrom:(ECHandicapper*)parent1
								  withDnaFrom:(ECHandicapper*)parent2;

- (ECTreeNode*)createTreeForStrand:(NSUInteger)dnaStrand
                         atLevel:(NSUInteger)level;

- (ECTreeNode*)recoverTreeFromString:(NSString*)inString;
- (NSString*)saveTreeToString:(ECTreeNode*)tree;

- (NSUInteger)getParentIndexFromPopulation:(ECPopulation*)population
				   withOverallFitnessValue:(double)popsSummedFitness;

- (ECTreeNode*)copyTree:(ECTreeNode*)tempTree
		  withoutBranch:(ECTreeNode*)skipThisBranch;

- (ECTreeNode*)copyTree:parent1Root
		replacingNode:crossover1
			 withNode:crossover2;

- (ECTreeNode*)getNodeFromChildAtLevel:(NSUInteger)parent1Level
						   usingTree:(ECTreeNode*)parent2Root;

- (NSUInteger)getTreeNodeTypeAtLevel:(NSUInteger)level;
- (void)freeTree:(ECTreeNode*)node;

- (void)trainPopulationForGenerations:(NSUInteger)numberGenerations;

- (void)testPopulation:(ECPopulation*)testPopulation
	  includingParents:(BOOL)testChildrenOnly
 withResultFilesAtPath:(NSString*)path;

- (void)fillWorkingPopulationArrayWithOriginalMembers;
- (void)replaceOldDnaStringsForChildWithIndex:(NSUInteger)popIndex;
- (void)createNextGenerationForPopulation:(ECPopulation*)testPopulation;
- (void)replaceBottomHalfOfPopulationWithNewChildren;
- (void)mutateChildrenForPopulation:(ECPopulation*)pop;
- (void)mutateHandicappersDnaTrees:(ECHandicapper*)futureMutant;

- (double)getLeafVariableValueForIndex:(NSUInteger)leafVariableIndex
					fromPastLineRecord:(PastLineRecord*)pastLineRecord;

- (NSArray*)getWinPredictionsFromPopulation:(ECPopulation*)population
									forRace:(ECRaceRecord*)raceRecord
							startingAtIndex:(NSUInteger) startIndex;

- (BOOL)isThisALongLineOfUnderscores:(NSString*)inString;
- (BOOL)isThisADateString:(NSString*)word;
- (BOOL)isThisAValidWeightString:(NSString*)word;
- (BOOL)isThisAValidTimeString:(NSString*)word;

- (ECTrainigRaceRecord*)getRaceRecordFromLines:(NSArray*)resultFileLines;

- (NSUInteger)getPastLineVariableForDnaStrand:(NSUInteger)dnaStrand;
- (NSUInteger)getIndexOfComma:(NSString*)inString;
- (NSUInteger)getIndexOfClosedParen:(NSString*)inString;
- (NSArray*)getRaceRecordsForResultsFileAtPath:(NSString*)resultsFileAtPath;
- (NSUInteger)getWinningPostFromRaceRecord:(ECRaceRecord*)thisRaceRecord;
- (NSInteger)getFinishPositionFromResultLine:(NSArray*)tokens;

- (NSString*)removeExtraSpacesFromString:(NSString*)originalString;
- (NSUInteger)getIndexOfFirstTokenDescribingDateInArray:(NSArray*)lineZeroTokens;
- (NSUInteger)getRaceDistanceFromString:(NSString*)raceNumberString;
- (NSString*)getMmSubstringFromSpelledMonth:(NSString*)spelledMonthString;

- (void)useResultLineArray:(NSArray*)tokens
	toGetValueForEntryName:(NSString**)entryNameString
			  postPosition:(NSUInteger*)entryPostPosition
		 andFinishPosition:(NSUInteger*)entryFinishPosition;

- (ECRacePayouts*)getPayoutsUsingArray:(NSArray*)resultFileLineByLine
							 atLineNumber:(NSUInteger)lineNumber;

// overflow, underflow and division by zero are ignored here
// to be trapped in evalTree method
double getRand(int max, int granularity);

@end
