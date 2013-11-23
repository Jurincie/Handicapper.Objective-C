//
//  ECEvolutionController.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/23/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import "stdlib.h"
#import <Foundation/Foundation.h>

@class ECPastLineRecord, ECPopulation, ECHandicapper, ECTrainigRaceRecord, ECTree, ECRacePayouts;

@interface ECEvolutionController : NSObject

@property (assign)				NSUInteger		trainingPopSize;
@property (assign)				NSUInteger		populationSize;
@property (assign)              NSUInteger		generationsEvolved;
@property (assign)              NSUInteger		generationsThisCycle;
@property (nonatomic, strong)   NSString		*trainingSetPath;
@property (nonatomic, strong)   ECPopulation	*population;
@property (nonatomic, strong)   NSArray			*workingPopulationDna;  // an array of arrays of dnaTrees
@property (nonatomic, strong)   NSMutableArray	*rankedPopulation;
@property (nonatomic, strong)	NSSet			*postStatisticsSet;

#pragma sharedMemory and CoreData methods
+ (id)sharedManager;
- (void)updateAndSaveData;

#pragma track statistics methods
- (NSSet*)createPostStatisticsSet;

#pragma darwinian methods
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

- (void)fillWorkingPopulationArrayWithOriginalMembers;
- (void)replaceOldDnaStringsForChildWithIndex:(NSUInteger)popIndex;
- (void)createNextGenerationForPopulation:(ECPopulation*)testPopulation;
- (void)replaceBottomHalfOfPopulationWithNewChildren;
- (void)mutateChildrenForPopulation:(ECPopulation*)pop;
- (void)mutateHandicappersDnaTrees:(ECHandicapper*)futureMutant;
- (void)trainPopulationForGenerations:(NSUInteger)numberGenerations;

- (void)testPopulation:(ECPopulation*)testPopulation
	  includingParents:(BOOL)testChildrenOnly
	belowResultsFolder:(NSString*)path;

- (NSArray*)getWinPredictionsFromPopulation:(ECPopulation*)population
									forRace:(ECTrainigRaceRecord*)raceRecord;

#pragma tree methods
- (ECTree*)createTreeForStrand:(NSUInteger)dnaStrand
					   atLevel:(NSUInteger)level;

- (ECTree*)recoverTreeFromString:(NSString*)inString;
- (NSString*)saveTreeToString:(ECTree*)tree;

- (NSUInteger)getParentIndexFromPopulation:(ECPopulation*)population
				   withOverallFitnessValue:(double)popsSummedFitness;

- (ECTree*)copyTree:(ECTree*)tempTree
		  withoutBranch:(ECTree*)skipThisBranch;

- (ECTree*)copyTree:parent1Root
		replacingNode:crossover1
			 withNode:crossover2;

- (ECTree*)getNodeFromChildAtLevel:(NSUInteger)parent1Level
						   usingTree:(ECTree*)parent2Root;

- (NSUInteger)getTreeNodeTypeAtLevel:(NSUInteger)level;
- (void)freeTree:(ECTree*)node;

- (NSUInteger)getPastLineVariableForDnaStrand:(NSUInteger)dnaStrand;
- (double)getLeafVariableValueForIndex:(NSUInteger)leafVariableIndex
					fromPastLineRecord:(ECPastLineRecord*)pastLineRecord;

- (NSArray*)getPastLinesForEntryFromPastLinesText:(NSString*)pastLinesText;
- (ECPastLineRecord*)getPastLineRecordFromSubArray:(NSArray*)subArray;

- (NSUInteger)getIndexOfComma:(NSString*)inString;
- (NSUInteger)getIndexOfClosedParen:(NSString*)inString;
- (NSArray*)getTrainingRaceRecordsForResultsFileAtPath:(NSString*)resultsFileAtPath;
- (ECTrainigRaceRecord*)getTrainingRaceRecordFromLines:(NSArray*)resultFileLines;

- (NSString*)removeExtraSpacesFromString:(NSString*)originalString;
- (NSUInteger)getIndexOfFirstDateToken:(NSArray*)lineZeroTokens;
- (NSUInteger)getRaceDistanceFromString:(NSString*)raceNumberString;
- (NSString*)getMmSubstringFromSpelledMonth:(NSString*)spelledMonthString;

- (void)useResultLineArray:(NSArray*)tokens
	toGetValueForEntryName:(NSString**)entryNameString
			  postPosition:(NSUInteger*)entryPostPosition
		 andFinishPosition:(NSUInteger*)entryFinishPosition;

- (ECRacePayouts*)getPayoutsUsingArray:(NSArray*)resultFileLineByLine
							 atLineNumber:(NSUInteger)lineNumber;

- (NSArray*)simulateRace:(ECTrainigRaceRecord*)trainingRecord
		   forPopulation:(ECPopulation*)population
	  withStrengthFields:(NSArray*)strengthFields;

- (NSUInteger)simulateRace:(ECTrainigRaceRecord*)trainingRaceRecord
		withEntryStrengths:(NSArray*)entryStrengths;

// overflow, underflow and division by zero are ignored here
// to be trapped in evalTree method
double getRand(int max, int granularity);

@end