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
@class ECTrackStats, ECRaceDistanceStats, ECPostStats, ECFirstTurnStats, ECTopOFStretchStats;

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

- (NSArray*)getUnmodeledTracksStatsFromPopulationsPastLines:(NSString*)modifiedPastLinesPath;

- (NSArray*)processTrackAtPath:(NSString*)modifiedResultsFolderPath
			  withDxStatsArray:(double*)statsArray
		andDxStatsCounterArray:(int*)counterArray
	   winTimeAccumulatorArray:(double*)winTimeAccumulatorArray
	 placeTimeAccumulatorArray:(double*)placeTimeAccumulatorArray
	  showTimeAccumulatorArray:(double*)showTimeAccumulatorArray
	  numRacesAccumulatorArray:(int*)numRacesAccumulatorArray
				 andClassArray:(NSArray*)classArray;

- (void)processRace:(NSString*)singleRaceString
			 ofType:(NSUInteger)resultFileType
withStatisticsArray:(double*)dxStatsAccumulatorArray
	andCounterArray:(int*)dxStatsRaceCounterArray
	   winTimeArray:(double*)winTimeAccumulatorArray
	  showTimeArray:(double*)showTimeAccumulatorArray
	  numRacesArray:(int*)raceCounterArray
	 forRaceDxIndex:(NSUInteger)raceDxIndex
	usingClassArray:(NSArray*)classArray
	   atTrackNamed:(NSString*)trackName;

- (void)loadWosrtAndBestTimesFromArray:(NSArray*)worstAndBestTimesArray
					 intoDistanceStats:(NSOrderedSet*)distanceStats;

- (BOOL)isThisLineDeclaredNoRace:(NSString*)firstLine;
- (double)getBestRaceTimeAtTrackNamed:(NSString*)trackName
				  atRaceDistanceIndex:(NSUInteger)raceDxIndex;

- (double)getBestTimeThisRaceFromString:(NSString*)singleRaceString;

- (double)getWorstRaceTimeAtTrackNamed:(NSString*)trackName
				   atRaceDistanceIndex:(NSUInteger)raceDxIndex;

- (NSUInteger)getNumberLinesToAddForResultScenerioFrom:(NSArray*)lines
											   atIndex:(NSUInteger)index;

- (void)editPastLinesAtPath:(NSString*)uneditedPastLinesPath;
- (NSString*)stripHtmlAndWhitespaceFromFileAtPath:(NSString*)originalFileContents;
- (NSString*)modifyPastLineString:(NSString*)originalLine;
- (NSString*)getStringFromArray:(NSArray*)textLinesArray;

#pragma track statistics methods
- (void)modelTracks;
- (ECTrackStats*)getStatsForTrackAtPath:(NSString*)trackName;
- (NSArray*)getClassesForTrackNamed:(NSString*)trackName;


- (void)addStatsForEntryAtPost:(NSUInteger)postPosition
		   withbreakAtPosition:(NSUInteger)breakPosition
			 firstTurnPosition:(NSUInteger)firstTurnPosition
		  topOfStretchPosition:(NSUInteger)topOfStretchPosition
				 finalPosition:(NSUInteger)finalPosition
				  withRaceTime:(double)raceTimeForEntry
				 atRaceDxIndex:(NSUInteger)raceDxIndex
	  withStatAccumulatorArray:(double*)statAccumulatorArray
		   andRaceCounterArray:(int*)raceCounterArray;


- (NSOrderedSet*)getDistanceStatsFromArray:(double*)statsAccumulatorArray
						   andCounterArray:(int*)raceCountrerArray;

- (NSMutableOrderedSet*)getClassStatsFromWinTimesArray:(double*)accumulatedWinTimesArray
									   placeTimesArray:(double*)accumulatedPlaceTimesArray
										showTimesArray:(double*)accumulatedShowTimesArray
									  raceCounterArray:(int*)raceCounterArray
										  forTrackName:(NSString*)trackName
										 andTrackStats:(ECTrackStats*)trackStats;

- (NSUInteger)getIndexOfPostPosition:(NSArray*)tokens;
- (BOOL)isThisCharADigit:(char)c;
- (BOOL)isThisADecimalWord:(NSString*)word;
- (void)printStatArrays:(double*)statsAccumulatorArray
		andCounterArray:(int*)raceCounterArray;

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
- (NSUInteger)getRaceDxFromString:(NSString*)raceNumberString;
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
