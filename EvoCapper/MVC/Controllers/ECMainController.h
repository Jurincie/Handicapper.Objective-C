//
//  ECMainController.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/23/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import "stdlib.h"
#import <Foundation/Foundation.h>

@class ECPastLineRecord, ECPopulation, ECHandicapper, ECTrainigRaceRecord, ECTree, ECRacePayouts;
@class ECTrackStats, ECRaceDistanceStats, ECPostStats, ECFirstTurnStats, ECFarTurnStatistics;

@interface ECMainController : NSObject

@property (assign)				NSUInteger		trainingPopSize;
@property (assign)				NSUInteger		populationSize;
@property (assign)              NSUInteger		generationsEvolved;
@property (assign)              NSUInteger		generationsThisCycle;
@property (nonatomic, strong)   NSString		*trainingSetPath;
@property (nonatomic, strong)   ECPopulation	*population;
@property (nonatomic, strong)   NSArray			*workingPopulationDna;  // an array of arrays of dnaTrees
@property (nonatomic, strong)   NSMutableArray	*rankedPopulation;
@property (nonatomic, strong)	NSOrderedSet	*postStatisticsSet;

#pragma sharedMemory and CoreData methods
+ (id)sharedManager;

+ (void)updateAndSaveData;

#pragma traverse
- (void)processDirectoryAtPath:(NSString*)directoryPath
			  withDxStatsArray:(double*)statsArray
		andDxStatsCounterArray:(int*)counterArray
	   winTimeAccumulatorArray:(double*)averageWinTimeAccumulatorArray
	  showTimeAccumulatorArray:(double*)averageShowTimeAccumulatorArray
	  numRacesAccumulatorArray:(int*)numRacesAccumulatorArray
				 andClassArray:(NSArray*)classArray;

- (void)processStatsFromResultFile:(NSString*)resultFilePath
			   withStatisticsArray:(double*)statsArray
				   andCounterArray:(int*)counterArray
					 andClassArray:(NSArray*)classArray;

- (BOOL)isThisLineDeclaredNoRace:(NSString*)firstLine;



#pragma track statistics methods

- (void)setStatsForTrack:(ECTrackStats*)track;
- (NSArray*)getClassesForTrack:(NSString*)trackName;

- (void)processRace:(NSString*)singleRaceString
			 ofType:(NSUInteger)resultFileType
withStatisticsArray:(double*)statsAccumulatorArray
	andCounterArray:(int*)statsCounterArray
	   winTimeArray:(double*)averageRaceTimeAccumulatorArray
	  showTimeArray:(double*)averageWinningRaceTimeAccumulatorArray
	  numRacesArray:(int*)raceCounterArray
   withMaxTimeForDx:(double)maxTimeForDistance
	 forRaceDxIndex:(NSUInteger)raceDxIndex
	usingClassArray:(NSArray*)classArray;

- (NSOrderedSet*)getDistanceStatsFromArray:(double*)statsAccumulatorArray
						   andCounterArray:(int*)statsCountrerArray;

- (NSOrderedSet*)getClassStatsFromWinTimesArray:(double*)accumulatedShowTimesArray
								 showTimesArray:(double*)accumulatedWinTimesArray
							   raceCounterArray:(int*)raceCounterArray
								   forTrackName:(NSString*)trackName
								  andTrackStats:(ECTrackStats*)trackStats;

- (NSUInteger)getIndexOfPostPosition:(NSArray*)tokens;
- (BOOL)isThisCharADigit:(char)c;
- (BOOL)isThisADecimalWord:(NSString*)word;
- (void)printArrayWith:(double*)statsAccumulatorArray;

#pragma darwinian methods
- (void)createNewPopoulationWithName:(NSString*)name
						 initialSize:(NSUInteger)initialSize
						maxTreeDepth:(NSUInteger)maxTreeDepth
						minTreeDepth:(NSUInteger)mintreeDepth
						mutationRate:(float)mutationRate
							comments:(NSString*)comments
							andTrackName:(NSString*)trackName;


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
- (NSString*)getRaceDistanceStringFromString:(NSString*)fileNameString;

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
