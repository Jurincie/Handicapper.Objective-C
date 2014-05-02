//
//  ECMainController.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/23/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import "stdlib.h"
#import <Foundation/Foundation.h>
#import "Constants.h"

@class ECPastLineRecord;
@class ECTrainigRaceRecord;
@class ECTree;

@class ECtracks;
@class ECTrackStats;

@class ECPostStats;
@class ECFirstTurnStats;
@class ECFarTurnStats;
@class ECSprintTurnStats;

@class ECSprintRaceStats;
@class ECTwoTurnRaceStats;
@class ECThreeTurnRaceStats;
@class ECMarathonRaceStats;

@class ECPopulation;
@class ECHandicapper;
@class ECDna;
@class ECRacePayouts;
@class ECBettingResults;


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

- (void)getTracksStatsFromPopulationsPastLines;
- (NSString*)getTrackNameFromTrackId:(NSString*)trackID;
- (NSUInteger)getRaceDxIndexFromString:(NSString*)raceDistanceString;
- (NSArray*)getModeledRaceDistancesForTrackWithID:(NSString*)trackID;
- (NSString*)getStringWithAllClassesAtTrackWithID:(NSString*)trackID;

- (double)getBestTimeForRaceDistanceIndex:(NSUInteger)raceDxIndex
                               atTrackWithId:(NSString*)trackID;

- (NSArray*)getStatDistancesForTrackWithID:(NSString*)trackID;
- (BOOL)isThisFallWord:(NSString*)testWord;
- (BOOL)isThisLineDeclaredNoRace:(NSString*)firstLine;
- (double)getBestRaceTimeAtTrackNamed:(NSString*)trackName
				  atRaceDistanceIndex:(NSUInteger)raceDxIndex;
- (NSString*)getRaceClassStringFromSingleRaceString:(NSString*)singleRaceString;
- (void)editPastLinesAtPath:(NSString*)uneditedPastLinesPath;
- (NSString*)stripHtmlAndWhitespaceFromFileAtPath:(NSString*)originalFileContents;
- (NSString*)modifyPastLineString:(NSString*)originalLine;
- (NSString*)getStringFromArray:(NSArray*)textLinesArray;
- (BOOL)isLineDateLine:(NSString*)testLine;

#pragma track statistics methods
- (void)modelTracks;
- (NSArray*)getClassesForTrackWithId:(NSString*)trackName;
- (void)printNewTrackCouters:(NSArray*)trackCounterArray;

- (ECSprintRaceStats*)getSprintStatsForTrackWithIndex:(NSUInteger)trackIdIndex
                                     withTrackIdArray:(NSArray*)trackIdArray
                                            fromArray:(double*)accumulatedStatsArray
                                      andCounterArray:(int*)accumulatedCounterArray;

- (ECTwoTurnRaceStats*)getTwoTurnStatsForTrackWithIndex:(NSUInteger)trackIdIndex
                                       withTrackIdArray:(NSArray*)trackIdArray
                                              fromArray:(double*)accumulatedStatsArray
                                        andCounterArray:(int*)accumulatedCounterArray;

- (ECThreeTurnRaceStats*)getThreeTurnStatsForTrackWithIndex:(NSUInteger)trackIdIndex
                                           withTrackIdArray:(NSArray*)trackIdArray
                                                  fromArray:(double*)accumulatedStatsArray
                                            andCounterArray:(int*)accumulatedCounterArray;

- (ECMarathonRaceStats*)getMarathonStatsForTrackWithIndex:(NSUInteger)trackIdIndex
                                         withTrackIdArray:(NSArray*)trackIdArray
                                                fromArray:(double*)accumulatedStatsArray
                                          andCounterArray:(int*)accumulatedCounterArray;

- (NSUInteger)getIndexOfTrapPosition:(NSArray*)tokens;
- (BOOL)isThisCharADigit:(char)c;
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
			  trapPosition:(NSUInteger*)entryTrapPosition
		 andFinalPosition:(NSUInteger*)entryFinalPosition;

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
