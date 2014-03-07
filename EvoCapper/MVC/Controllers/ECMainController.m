//
//  ECMainController.m
//  EvoCapper
//
//  Created by Ron Jurincie on 10/23/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

// Since we only want (1) EvolutionManager Ever to be created
// We have made this class a singleton

#define MOC [[NSApp delegate]managedObjectContext]

#import "ECMainController.h"
#import "Constants.h"
#import "ECPopulation.h"
#import "ECEntry.h"
#import "ECTree.h"
#import "ECHandicapper.h"
#import "ECRaceRecord.h"
#import "ECTrainigRaceRecord.h"
#import "ECPastLineRecord.h"
#import "ECPostStats.h"
#import "ECTrackStats.h"
#import "ECFirstTurnStats.h"
#import "ECTopOFStretchStats.h"
#import "ECClassStats.h"
#import "NSString+ECStringValidizer.h"
#import "ECTrackStats.h"
#import "ECRaceDistanceStats.h"

#define kLineBuffer 20
#define kWorstRealisticTime 43.00

@implementation ECMainController

@synthesize trainingPopSize			= _trainingPopSize;
@synthesize populationSize			= _populationSize;
@synthesize population				= _population;
@synthesize generationsEvolved		= _generationsEvolved;
@synthesize generationsThisCycle	= _generationsThisCycle;
@synthesize workingPopulationDna	= _workingPopulationDna;
@synthesize rankedPopulation		= _rankedPopulation;


#pragma sharedMemory and CoreData methods
+ (id)sharedManager
{
    static ECMainController *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{sharedManager = [[self alloc] init];});
    
    return sharedManager;
}

+ (void)updateAndSaveData
{
	NSError *error = nil;
	
    if (![MOC commitEditing])
	{
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
	}
	
    if (![MOC save:&error])
	{
        [[NSApplication sharedApplication] presentError:error];
	}
}

#pragma track statistics methods

- (NSArray*)getClassesForTrackNamed:(NSString*)trackName
{
	NSArray *classNames = nil;
	
	if([trackName isEqualToString:@"Daytona Beach"])
	{
		classNames = [NSArray arrayWithObjects:@"M", @"E", @"D", @"C", @"B", @"A",
												@"T", @"TM", @"TE", @"TD", @"TC", @"TB", @"TA",
												@"SD", @"SA", nil];
	}
	else if([trackName isEqualToString:@"Derby Lane"])
	{
		classNames = [NSArray arrayWithObjects:@"M", @"D", @"C", @"B", @"A",
									@"TM", @"TD", @"TC", @"TB", @"TA",
									@"S", nil];
	}
	else if([trackName isEqualToString:@"Ebro"])
	{
		classNames = [NSArray arrayWithObjects:@"M", @"J", @"D", @"C", @"B", @"A",
									@"T", @"TJ", @"TD", @"TC", @"TB", @"TA",
									@"S", @"SD", @"SC", @"SB", @"SA", nil];
	}
	else if([trackName isEqualToString:@"Flagler"])
	{
		classNames = [NSArray arrayWithObjects:@"M", @"D", @"C", @"B", @"A",
									@"TD", @"TC", @"TB", @"TA",
									@"S", @"SM", @"SD", @"SC", @"SB", @"SA", nil];
	}
	else if([trackName isEqualToString:@"Gulf"])
	{
		classNames = [NSArray arrayWithObjects:@"M", @"J", @"D", @"C", @"B", @"A", @"AA",
									@"TJ", @"TD", @"TC", @"TB", @"TA", @"TAA",
									@"SA", @"SAA", nil];
	}
	else if([trackName isEqualToString:@"Mardi Gras"])
	{
		classNames = [NSArray arrayWithObjects:@"M", @"D", @"C", @"B", @"A",
									 @"T", @"TM", @"TD", @"TC", @"TB", @"TA",
									@"S", @"SM", @"SC", @"SA", nil];
	}
	else if([trackName isEqualToString:@"Naples - Fort Meyers"])
	{
		classNames = [NSArray arrayWithObjects:@"M", @"D", @"C", @"B", @"A",
									@"TD", @"TC", @"TB", @"TA",
									@"S", @"SA", nil];
	}
	else if([trackName isEqualToString:@"Orange Park"])
	{
		classNames = [NSArray arrayWithObjects:@"M", @"D", @"C", @"B", @"A",
									@"TM", @"TD", @"TC", @"TB", @"TA",
									@"SD", @"SC", @"SB", @"SA", nil];
	}
	else if([trackName isEqualToString:@"Palm Beach"])
	{
		classNames = [NSArray arrayWithObjects:@"M", @"J", @"D", @"C", @"B", @"A",
									@"T", @"TJ", @"TD", @"TC", @"TB", @"TA",
									@"S", @"SJ", @"SD", @"SC", @"SB", @"SA", @"SAT", nil];
	}
	else if([trackName isEqualToString:@"Sanford-Orlando"])
	{
		classNames = [NSArray arrayWithObjects:@"M", @"J", @"E", @"D", @"C", @"B", @"A",
									@"T", @"TJ", @"TE", @"TD", @"TC", @"TB", @"TA",
									@"S", @"SC", @"SB", @"SA", nil];
	}
	else if([trackName isEqualToString:@"Sarasota"])
	{
		classNames = [NSArray arrayWithObjects:@"M", @"E", @"D", @"C", @"B", @"A",
									@"T", @"TM", @"TE", @"TD", @"TC", @"TB", @"TA", nil];
	}
	else if([trackName isEqualToString:@"Southland"])
	{
		classNames = [NSArray arrayWithObjects:@"M", @"D", @"C", @"B", @"A", @"AA",
									@"T", @"TM", @"TD", @"TC", @"TB", @"TA", @"TAA",
									@"S", @"SD",  @"SC", @"SB", @"SA", @"SAA", nil];
	}
	else if([trackName isEqualToString:@"Tri-State"])
	{
		classNames = [NSArray arrayWithObjects:@"M", @"D", @"C", @"B", @"A", @"AA",
									@"TD", @"TC", @"TB", @"TA", @"TAA",
									@"SB", @"SA", @"SAA", nil];
	}
	else if([trackName isEqualToString:@"Wheeling"])
	{
		classNames = [NSArray arrayWithObjects:@"M", @"D", @"C", @"B", @"A", @"AA",
									@"TD", @"TC", @"TB", @"TA", @"TAA",
									@"SC", @"SB", @"SA", @"SAA", nil];
	}
	else if([trackName isEqualToString:@"WheelingSmall"])
	{
		classNames = [NSArray arrayWithObjects:@"M", @"D", @"C", @"B", @"A", @"AA",
					  @"TD", @"TC", @"TB", @"TA", @"TAA",
					  @"SC", @"SB", @"SA", @"SAA", nil];
	}
	else
	{
		NSLog(@"Bad track name: %@", trackName);
		exit(0);
	}
	
	
	return classNames;
}

- (double)getBestTimeThisRaceFromString:(NSString*)singleRaceString
{
	double bestTime		= 100.00;
	NSArray *lines		= [singleRaceString componentsSeparatedByString:@"\n"];
	NSString *thisLine	= nil;
	NSUInteger index	= 0;
	double entriesRaceTime;
	
	for(thisLine in lines)
	{
		if([thisLine hasSuffix:@"CHART:"])
		{
			break;
		}
		
		index++;
	}
	
	// loop here
	while(index < lines.count - kLineBuffer)
	{
		// ignore empty lines
		thisLine = lines[++index];
		
		while (thisLine.length == 0 || [thisLine isEqualToString:@" "])
		{
			thisLine = lines[++index];
		}
		
		index += 6;
		
		thisLine		= lines[index];
		entriesRaceTime	= [thisLine doubleValue];
		
		if(entriesRaceTime != 0.0 && entriesRaceTime < 25.00)
		{
			NSLog(@"Bad best time: %lf", entriesRaceTime);
			entriesRaceTime = entriesRaceTime;
		}
		else if(entriesRaceTime > 0.00 && entriesRaceTime < bestTime)
		{
			bestTime = entriesRaceTime;
		}
		
		
		index += 3;
	}
	
	return bestTime;
}

- (double)getBestRaceTimeAtTrackNamed:(NSString*)trackName
				  atRaceDistanceIndex:(NSUInteger)raceDxIndex
{
	double best = 0.00;
	
	return best;
}

- (double)getWorstRaceTimeAtTrackNamed:(NSString*)trackName
				   atRaceDistanceIndex:(NSUInteger)raceDxIndex
{
	double best = 0.00;
	
	return best;
}

- (double)getWorstTimeThisRaceFromString:(NSString*)singleRaceString
{
	double worstTime		= 0.00;
	NSArray *lines			= [singleRaceString componentsSeparatedByString:@"\n"];
	NSString *thisLine		= nil;
	NSUInteger index		= 0;
	double entriesRaceTime	= 0.00;
	
	for(thisLine in lines)
	{
		if([thisLine hasSuffix:@"CHART:"])
		{
			break;
		}
		
		index++;
	}
	
	// loop here
	while(index < lines.count - kLineBuffer)
	{
		// ignore empty lines
		thisLine = lines[++index];
		
		while (thisLine.length == 0 || [thisLine isEqualToString:@" "])
		{
			thisLine = lines[++index];
		}
		
		index += 6;
		
		thisLine		= lines[index];
		entriesRaceTime	= [thisLine doubleValue];
		
		
		if(entriesRaceTime > kWorstRealisticTime)
		{
			NSLog(@"Big Bad Time: %lf", entriesRaceTime);
			entriesRaceTime = entriesRaceTime;
		}
		
		if(entriesRaceTime > worstTime  && entriesRaceTime < kWorstRealisticTime)
		{
			worstTime = entriesRaceTime;
		}
		
		index += 3;
	}
	
	return worstTime;
}

- (NSArray*)processTrackAtPath:(NSString*)modifiedResultsFolderPath
			  withDxStatsArray:(double*)statsArray
		andDxStatsCounterArray:(int*)counterArray
	   winTimeAccumulatorArray:(double*)winTimeAccumulatorArray
	 placeTimeAccumulatorArray:(double*)placeTimeAccumulatorArray
	  showTimeAccumulatorArray:(double*)showTimeAccumulatorArray
	  numRacesAccumulatorArray:(int*)numRacesAccumulatorArray
				 andClassArray:(NSArray*)classArray
{
	NSString *fileName				= nil;
	NSError *error					= nil;
	NSFileManager *localFileManager	= [NSFileManager defaultManager];
	NSArray *folderContents			= [localFileManager contentsOfDirectoryAtPath:modifiedResultsFolderPath
																			error:&error];
	NSString *trackName		= nil;
	double bestTime2Turns	= 100.00;
	double worstTime2Turns	= 0.00;
	double bestTime3Turns	= 100.00;
	double worstTime3Turns	= 0.00;

	for(NSString *yearFolderName in folderContents)
	{
		if([yearFolderName hasSuffix:@".DS_Store"])
		{
			continue;
		}
		
		NSString *folderPath					= [NSString stringWithFormat:@"%@%@/",modifiedResultsFolderPath, yearFolderName];
		NSDirectoryEnumerator *yearEnumerator	= [localFileManager enumeratorAtPath:folderPath];
		
		while(fileName = [yearEnumerator nextObject])
		{
			if([fileName hasSuffix:@".DS_Store"])
			{
				continue;
			}
			
			NSString *filePath			= [NSString stringWithFormat:@"%@%@", folderPath, fileName];
			NSString *singleRaceString	= [NSString stringWithContentsOfFile:filePath
																	encoding:NSStringEncodingConversionAllowLossy
																		error:&error];

			if(fileName.length < 8)
			{
				continue;
			}
			
			NSString *raceDxString	= [self getRaceDistanceStringFromString:fileName];
			
			if([raceDxString isEqualToString:@"Bad File"])
			{
				// delete this file
				[localFileManager removeItemAtPath:filePath
											 error:&error];
											 
				continue;
			}
			
			NSUInteger raceDx		= 0;
			NSUInteger raceDxIndex	= kNoIndex;
			
			if([raceDxString isEqualToString:@"5.16"] || [raceDxString isEqualToString:@"5-16"])
			{
				raceDx = 550;
			}
			else if([raceDxString isEqualToString:@"3.8"] || [raceDxString isEqualToString:@"3-8"])
			{
				raceDx = 660;
			}
			else if([raceDxString characterAtIndex:1] == '.' || [raceDxString characterAtIndex:1] == '-')
			{
				raceDx = 0;
			}
			else
			{
				raceDx = [raceDxString integerValue];
			}
			
			switch (raceDx)
			{
				case 545:
				case 548:
				case 550:
				case 583:
					
					raceDxIndex = 0;
					break;
				
				case 660:
				case 677:
				case 678:
					
					raceDxIndex = 1;
					break;
									
				default:
					break;
			}
		
				// skip any races other than 548 and 678
			if(raceDxIndex >= kNumberRaceDistances || raceDxIndex == kNoIndex)
			{
				NSLog(@"skipping: %lu distance race", (unsigned long)raceDx);
			
				continue;
			}
				
			NSLog(@"%@", fileName);
			NSString *prefix	= [modifiedResultsFolderPath substringToIndex:modifiedResultsFolderPath.length - 17];
			trackName = [prefix lastPathComponent];
			
//			[self processRace:singleRaceString
//					   ofType:1
//		  withStatisticsArray:statsArray
//			  andCounterArray:counterArray
//				 winTimeArray:winTimeAccumulatorArray
//				showTimeArray:showTimeAccumulatorArray
//				numRacesArray:numRacesAccumulatorArray
//			   forRaceDxIndex:raceDxIndex
//			  usingClassArray:classArray
//			  atTrackNamed:trackName];

			double thisRaceBest		= [self getBestTimeThisRaceFromString:singleRaceString];
			double thisRaceWorst	= [self getWorstTimeThisRaceFromString:singleRaceString];
			
			switch(raceDxIndex)
			{
				case 0:
				{
					if(thisRaceBest < bestTime2Turns)
					{
						bestTime2Turns = thisRaceBest;
					}
					if(thisRaceWorst > worstTime2Turns)
					{
						worstTime2Turns = thisRaceWorst;
					}
					
					break;
				}
				
				case 1:
				{
					if(thisRaceBest < bestTime3Turns)
					{
						bestTime3Turns = thisRaceBest;
					}
					if(thisRaceWorst > worstTime3Turns)
					{
						worstTime3Turns = thisRaceWorst;
					}
					
					break;
				}
				
				default:
				
					break;
			}
			
			NSLog(@"thisRaceBest: %lf    worst: %lf", thisRaceBest, thisRaceWorst);
		}
	}
	
	NSLog(@"TRACK: %@", trackName);
	
	NSLog(@"best time 2 turns: %lf", bestTime2Turns);
	NSLog(@"worst time 2 turns: %lf", worstTime2Turns);
	
	NSLog(@"best time 3 turns: %lf", bestTime3Turns);
	NSLog(@"worst time 3 turns: %lf", worstTime3Turns);
	
	NSMutableArray *worstAndBestTimesArray = [NSMutableArray new];
	
	NSNumber *twoTurnBestTime	= [NSNumber numberWithDouble:bestTime2Turns];
	NSNumber *twoTurnDnfTime	= [NSNumber numberWithDouble:worstTime2Turns];
	NSNumber *threeTurnBestTime	= [NSNumber numberWithDouble:bestTime3Turns];
	NSNumber *threeTurnDnfTime	= [NSNumber numberWithDouble:worstTime3Turns];
	
	[worstAndBestTimesArray addObject:twoTurnBestTime];
	[worstAndBestTimesArray addObject:twoTurnDnfTime];
	[worstAndBestTimesArray addObject:threeTurnBestTime];
	[worstAndBestTimesArray addObject:threeTurnDnfTime];
	
	return worstAndBestTimesArray;
}


- (BOOL)isThisLineDeclaredNoRace:(NSString*)firstLine
{
	NSString *modifiedFirstLine		= [self removeExtraSpacesFromString:firstLine];
	NSArray *words					= [modifiedFirstLine componentsSeparatedByString:@" "];
	NSString *lastWord				= [words objectAtIndex:words.count-1];
	NSString *nextToLastWord		= [words objectAtIndex:words.count-2];
	NSString *secondFromLastWord	= [words objectAtIndex:words.count-3];
	BOOL answer						= NO;
	
	if([secondFromLastWord isEqualToString:@"Declared"] &&
	[nextToLastWord isEqualToString:@"No"] &&
	[lastWord isEqualToString:@"Race"])
	{
		answer = YES;
	}
	
	return answer;
}

- (void)processRace:(NSString*)singleRaceString
			 ofType:(NSUInteger)resultFileType
withStatisticsArray:(double*)dxStatsAccumulatorArray
	andCounterArray:(int*)dxStatsRaceCounterArray
	   winTimeArray:(double*)winTimeAccumulatorArray
	  showTimeArray:(double*)showTimeAccumulatorArray
	  numRacesArray:(int*)raceCounterArray
	 forRaceDxIndex:(NSUInteger)raceDxIndex
	usingClassArray:(NSArray*)classArray
	   atTrackNamed:(NSString*)trackName
{
	// assign zero to all fields, so that falling at any point is covered
	NSUInteger postPosition			= 0;
	NSUInteger breakPosition		= 0;
	NSUInteger firstTurnPosition	= 0;
	NSUInteger topOfStretchPosition	= 0;
	NSUInteger finishPosition		= 0;
	double finishRaceTime			= 0.0;
	double timeForWinner			= 0.0;
	double timeForShowFinisher		= 0.0;
	NSUInteger classIndex			= 0;
	NSUInteger arrayIndex			= 0;
	
	if(resultFileType < 1 || resultFileType > 2)
	{
		NSLog(@"bad file type");
		return;
	}
	
	// redundant check here
	if(raceDxIndex >= kNumberRaceDistances)
	{
		NSLog(@"bad raceDx");
		return;
	}
	
	double dnfTime = [self getWorstRaceTimeAtTrackNamed:trackName
									atRaceDistanceIndex:raceDxIndex];
	
	if(resultFileType == kNormalResultFileType)
	{
		// ignorelines upt to line containint "CHART:"
		NSArray *lines		= [singleRaceString componentsSeparatedByString:@"\n"];
		NSString *thisLine	= nil;
		NSUInteger index	= 0;
		
		for(thisLine in lines)
		{
			if([thisLine hasSuffix:@"CHART:"])
			{
				break;
			}
			
			index++;
		}
		
		// loop here
		while(index < lines.count - kLineBuffer)
		{
			// ignore empty lines
			thisLine = lines[++index];
			
			while (thisLine.length == 0 || [thisLine isEqualToString:@" "])
			{
				thisLine = lines[++index];
			}
			
			// we ignore dog name (since its not relevant to track stats)
			NSString *dogName	= lines[index];
			thisLine			= lines[++index];
			postPosition		= [thisLine integerValue];
			
			if(postPosition > 0)
			{
				breakPosition			= kMaximumNumberEntries + 1;
				firstTurnPosition		= kMaximumNumberEntries + 1;
				topOfStretchPosition	= kMaximumNumberEntries + 1;
				finishPosition			= kMaximumNumberEntries + 1;
			}
			else
			{
				NSLog(@"post position number error");
				return; // means ignore race
			}
			
			thisLine		= lines[++index];
			breakPosition	= [thisLine integerValue];
			thisLine		= lines[++index];
			
			if(thisLine.length > 1)
			{
				NSString *substring = [thisLine substringToIndex:1];
				firstTurnPosition	= [substring integerValue];
			}
			else
			{
				firstTurnPosition = [thisLine integerValue];
			}
			
			thisLine = lines[++index];
		
			if(thisLine.length > 1)
			{
				NSString *substring		= [thisLine substringToIndex:1];
				topOfStretchPosition	= [substring integerValue];
			}
			else
			{
				topOfStretchPosition = [thisLine integerValue];
			}
		
			thisLine = lines[++index];
			
			if(thisLine.length > 1)
			{
				NSString *substring = [thisLine substringToIndex:1];
				finishPosition		= [substring integerValue];
			}
			else
			{
				finishPosition = [thisLine integerValue];
			}
		
			thisLine		= lines[++index];
			finishRaceTime	= [thisLine doubleValue];
			
			if(finishRaceTime < 25.00 || finishRaceTime > 40.00)
			{
				finishRaceTime = dnfTime;
			}
	
			if(finishPosition == 1)
			{
				// get class stats here from first entries entrysRaceLineResultsString
				timeForWinner		= finishRaceTime;
				index				+= 2;
				NSString *raceClass	= lines[index];
				classIndex			= [classArray indexOfObject:raceClass];
				arrayIndex			= (raceDxIndex * classArray.count) + classIndex;
			}
			else if(finishPosition == 3)
			{
				timeForShowFinisher	= finishRaceTime;
			}
				
			NSLog(@"%@: %lu %lu %lu %lu %lu %lf", dogName,
					(unsigned long)postPosition,
					(unsigned long)breakPosition,
					(unsigned long)firstTurnPosition,
					(unsigned long)topOfStretchPosition,
					(unsigned long)finishPosition, finishRaceTime);
		
			[self addStatsForEntryAtPost:postPosition
					 withbreakAtPosition:breakPosition
					   firstTurnPosition:firstTurnPosition
					topOfStretchPosition:topOfStretchPosition
						   finalPosition:finishPosition
							withRaceTime:finishRaceTime
						   atRaceDxIndex:raceDxIndex
				withStatAccumulatorArray:dxStatsAccumulatorArray
					 andRaceCounterArray:dxStatsRaceCounterArray];
			
			
			index += 3;
		}
	
		NSLog(@"%@", [classArray objectAtIndex:raceDxIndex]);
	
		double accumulatedWinTimesThisClassAndDx	= winTimeAccumulatorArray[arrayIndex];
		accumulatedWinTimesThisClassAndDx			+= timeForWinner;
		winTimeAccumulatorArray[arrayIndex]			= accumulatedWinTimesThisClassAndDx;
		double accumulatedShowTimesThisClassAndDx	= showTimeAccumulatorArray[arrayIndex];
		accumulatedShowTimesThisClassAndDx			+= timeForShowFinisher;
		showTimeAccumulatorArray[arrayIndex]		= accumulatedShowTimesThisClassAndDx;
	}
}

- (void)addStatsForEntryAtPost:(NSUInteger)postPosition
		   withbreakAtPosition:(NSUInteger)breakPosition
			 firstTurnPosition:(NSUInteger)firstTurnPosition
		  topOfStretchPosition:(NSUInteger)topOfStretchPosition
				 finalPosition:(NSUInteger)finalPosition
				  withRaceTime:(double)raceTimeForEntry
				 atRaceDxIndex:(NSUInteger)raceDxIndex
	  withStatAccumulatorArray:(double*)statAccumulatorArray
		   andRaceCounterArray:(int*)raceCounterArray
{
	
	if(postPosition == 0 || postPosition > kMaximumNumberEntries)
	{
		NSLog(@"post position number error");
		return;
	}
	if(firstTurnPosition == 0 || firstTurnPosition > kMaximumNumberEntries)
	{
		NSLog(@"1st turn position number error");
		return;
	}
	if(topOfStretchPosition == 0 || topOfStretchPosition > kMaximumNumberEntries)
	{
		NSLog(@"2nd turn position number error");
		return;
	}
	if(finalPosition == 0 || finalPosition > kMaximumNumberEntries)
	{
		NSLog(@"finish position number error");
		return;
	}
	
	NSUInteger postPositionIndex			= postPosition - 1;
	NSUInteger firstTurnPositionIndex		= firstTurnPosition - 1;
	NSUInteger topOfStretchPositionIndex	= topOfStretchPosition - 1;
	
	NSUInteger mainOffset = (raceDxIndex * kNumberRaceDistances * kNumberStatFields) + (postPositionIndex * kNumberStatFields);
	
	if(breakPosition == 0)	// based on post position
	{
		breakPosition = kMaximumNumberEntries;
	}
	
	NSUInteger index							= mainOffset + kBreakPositionFromPostStatField;
	double accumulatedBreakValuesAtDxAndPost	= statAccumulatorArray[index];
	accumulatedBreakValuesAtDxAndPost			+= breakPosition;
	statAccumulatorArray[index]					= accumulatedBreakValuesAtDxAndPost;
	
	NSUInteger numberRaces = raceCounterArray[index];
	numberRaces++;
	raceCounterArray[index] = (int)numberRaces;
	
	if(firstTurnPosition == 0)	// based on post position
	{
		firstTurnPosition = kMaximumNumberEntries;
	}
		
	index									= mainOffset + kFirstTurnPositionFromPostStatField;
	double accumulatedFTValuesAtDxAndPost	= statAccumulatorArray[index];
	accumulatedFTValuesAtDxAndPost			+= firstTurnPosition;
	statAccumulatorArray[index]				= accumulatedFTValuesAtDxAndPost;

	numberRaces = raceCounterArray[index];
	numberRaces++;
	raceCounterArray[index] = (int)numberRaces;
	
	if(finalPosition == 0)	// based on post position
	{
		finalPosition = kMaximumNumberEntries;
	}

	index												= mainOffset + kFinishPositionFromPostStatField;
	double accumulatedFinalPositionValuesForDxAndPost	= statAccumulatorArray[index];
	accumulatedFinalPositionValuesForDxAndPost			+= finalPosition;
	statAccumulatorArray[index]							= accumulatedFinalPositionValuesForDxAndPost;
	
	numberRaces = raceCounterArray[index];
	numberRaces++;
	raceCounterArray[index] = (int)numberRaces;
	
	if(raceTimeForEntry == 0.0)	// based on post position
	{
		NSLog(@"no race time");
	}
	else
	{
		NSUInteger index								= mainOffset + kFinishTimeFromPostStatField;
		double finishTimeAccumulatedValueAtDxAndPost	= statAccumulatorArray[index];
		finishTimeAccumulatedValueAtDxAndPost			+= raceTimeForEntry;
		statAccumulatorArray[index]						= finishTimeAccumulatedValueAtDxAndPost;
		
		NSUInteger numberRaces = raceCounterArray[index];
		numberRaces++;
		raceCounterArray[index] = (int)numberRaces;
	}
			
	
	if(topOfStretchPositionIndex == 0)	// based on 1st turn position
	{
		topOfStretchPosition = kMaximumNumberEntries;
	}
	
	mainOffset = (raceDxIndex * kNumberRaceDistances * kNumberStatFields) + (firstTurnPositionIndex * kNumberStatFields);
	
	index											= mainOffset + kTopOFStretchPositionFromFirstTurnStatField;
	double accumulatedTosValueFromFtPositionAndDx	= statAccumulatorArray[index];
	accumulatedTosValueFromFtPositionAndDx			+= topOfStretchPosition;
	statAccumulatorArray[index]						= accumulatedTosValueFromFtPositionAndDx;
	
	numberRaces = raceCounterArray[index];
	numberRaces++;
	raceCounterArray[index] = (int)numberRaces;
	
	
	if(finalPosition == 0)	// based on top of stretch position
	{
		finalPosition = kMaximumNumberEntries;
	}
	
	mainOffset = (raceDxIndex * kNumberRaceDistances * kNumberStatFields) + (topOfStretchPositionIndex * kNumberStatFields);
	
	index												= mainOffset + kFinishPositionFromTopOfStretchStatField;
	double accumulatedFinalPositonsFromTosPositionAndDx	= statAccumulatorArray[index];
	accumulatedFinalPositonsFromTosPositionAndDx		+= finalPosition;
	statAccumulatorArray[index]							= accumulatedFinalPositonsFromTosPositionAndDx;
	
	numberRaces = raceCounterArray[index];
	numberRaces++;
	raceCounterArray[index] = (int)numberRaces;
}

- (void)modelTracks
{
	NSError *error					= nil;
	NSFileManager *localFileManager	= [NSFileManager defaultManager];
	NSString *modeledTracksFolder	= @"/Users/ronjurincie/Desktop/Project Ixtlan/Tracks/Modeled Tracks/";
	NSArray *trackFoldersToProcess	= [localFileManager contentsOfDirectoryAtPath:modeledTracksFolder
																		    error:&error];
	
	for(NSString *modeledTrackFolder in trackFoldersToProcess)
	{
		if([modeledTrackFolder hasSuffix:@".DS_Store"])
		{
			continue;
		}
	
		NSString *pathToModeledTrackFolder = [NSString stringWithFormat:@"%@%@", modeledTracksFolder, modeledTrackFolder];
	
		[self getStatsForTrackAtPath:pathToModeledTrackFolder];
	}
	
	[ECMainController updateAndSaveData];
}

- (ECTrackStats*)getStatsForTrackAtPath:(NSString*)modeledTrackFolderPath
{
	// Each raceClass 2-Turn and 3-Turn stats are kept for:
	//	averageWinTime and averageShowTime
	ECTrackStats *trackStats = [NSEntityDescription insertNewObjectForEntityForName:@"ECTrackStats"
															 inManagedObjectContext:MOC];
	// Distance Stats
	NSUInteger dxArraySize = kNumberRaceDistances * kMaximumNumberEntries * kNumberStatFields;
	
	int		dxRaceCounterArray[dxArraySize];
	double	dxStatsAccumulatorArray[dxArraySize];
	
	// initialize accumulators to zero
	for(int index = 0; index < dxArraySize; index++)
	{
		dxStatsAccumulatorArray[index]	= 0.0;
		dxRaceCounterArray[index]		= 0.0;
	}
	
	// Class Stats
	// post by post average times and average win times
	NSString *trackName			= [modeledTrackFolderPath lastPathComponent];
	NSArray *raceClassArray		= [self getClassesForTrackNamed:trackName];
	NSUInteger classArraySize	= kNumberRaceDistances * raceClassArray.count;
	
	double	winTimeAccumulatorArray[classArraySize];
	double	placeTimeAccumulatorArray[classArraySize];
	double	showTimeAccumulatorArray[classArraySize];
	int		raceCounterArray[classArraySize];
	
	// initialize accumulators to zero
	for(int index = 0; index < classArraySize; index++)
	{
		raceCounterArray[index]				= 0;
		winTimeAccumulatorArray[index]		= 0.0;
		placeTimeAccumulatorArray[index]	= 0.0;
		showTimeAccumulatorArray[index]		= 0.0;
		
	}
	
	NSString *modeledTracksModifiedResultsFolderPath	= [NSString stringWithFormat:@"%@/Modified Results/", modeledTrackFolderPath];
	NSArray *tracksWorstAndBestTimesArray				= nil;
	
	if(0)
	{
	tracksWorstAndBestTimesArray = [self processTrackAtPath:modeledTracksModifiedResultsFolderPath
										   withDxStatsArray:dxStatsAccumulatorArray
									 andDxStatsCounterArray:dxRaceCounterArray
									winTimeAccumulatorArray:winTimeAccumulatorArray
								  placeTimeAccumulatorArray:placeTimeAccumulatorArray
								   showTimeAccumulatorArray:showTimeAccumulatorArray
								   numRacesAccumulatorArray:raceCounterArray
											andClassArray:raceClassArray];
	}

	NSString *modifiedPastLinesPath			= @"/Users/ronjurincie/Desktop/Project Ixtlan/Dogs/Modified Past Lines/";
	NSArray *worstAndBestFromPastLinesArray = [self getUnmodeledTracksStatsFromPopulationsPastLines:modifiedPastLinesPath];
	
	
//	[self printStatArrays:dxStatsAccumulatorArray
//		  andCounterArray:dxRaceCounterArray];
	
	NSOrderedSet *classStats = [self getClassStatsFromWinTimesArray:winTimeAccumulatorArray
													placeTimesArray:placeTimeAccumulatorArray
													 showTimesArray:showTimeAccumulatorArray
												   raceCounterArray:raceCounterArray
													   forTrackName:trackName
													  andTrackStats:trackStats];
				
	NSOrderedSet *distanceStats	= [self getDistanceStatsFromArray:dxStatsAccumulatorArray
												  andCounterArray:dxRaceCounterArray];
				
	[self loadWosrtAndBestTimesFromArray:tracksWorstAndBestTimesArray
					   intoDistanceStats:distanceStats];
				
	
	[self loadWosrtAndBestTimesFromArray:worstAndBestFromPastLinesArray
					   intoDistanceStats:distanceStats];
	
	trackStats.raceDistanceStats	= distanceStats;
	trackStats.classStats			= classStats;
	
	return trackStats;
}

- (NSArray*)getUnmodeledTracksStatsFromPopulationsPastLines:(NSString*)modifiedPastLinesPath
{
	// for starters just return array of ALL track unique track abbreviations with their number of past lines
	// i.e. DB 33232

	NSMutableArray *unmodeledTrackAbbreviations	= [NSMutableArray new];
	NSMutableArray *modeledTrackAbbreviations	= [NSMutableArray new];
	NSError *error								= nil;
	NSString *trackAbbreviation					= nil;
	NSUInteger raceCounterArray[100];
	NSUInteger newTrackNumber					= 0;
	
	for(int index = 0; index < 100; index++)
	{
		raceCounterArray[index] = 0;
	}
	
	// FIX: the abbreviations above are a guess at at actual abbreviations
	[modeledTrackAbbreviations addObject:@"DB"];
	[modeledTrackAbbreviations addObject:@"EB"];
	[modeledTrackAbbreviations addObject:@"FL"];
	[modeledTrackAbbreviations addObject:@"MG"];
	[modeledTrackAbbreviations addObject:@"NP"];
	[modeledTrackAbbreviations addObject:@"PB"];
	[modeledTrackAbbreviations addObject:@"OR"];
	[modeledTrackAbbreviations addObject:@"SA"];
	[modeledTrackAbbreviations addObject:@"DB"];
	[modeledTrackAbbreviations addObject:@"SO"];
	[modeledTrackAbbreviations addObject:@"TS"];
	[modeledTrackAbbreviations addObject:@"WH"];
	
	NSFileManager *fileManager		= [NSFileManager defaultManager];
	NSArray *subDirectories			= [fileManager contentsOfDirectoryAtPath:modifiedPastLinesPath
																	   error:&error];
				
	for(NSString *subDirectoryName in subDirectories)
	{
		if([subDirectoryName hasSuffix:@".DS_Store"])
		{
			continue;
		}
		
		NSUInteger pageBufferLines				= 59;
		NSUInteger linesBetweenAbbreviations	= 38;
		NSString *folderPath					= [NSString stringWithFormat:@"%@%@", modifiedPastLinesPath, subDirectoryName];
		NSString *fileName						= nil;
		NSDirectoryEnumerator *dogEnumerator	= [fileManager enumeratorAtPath:folderPath];
		
		while(fileName = [dogEnumerator nextObject])
		{
			if([fileName hasSuffix:@".DS_Store"])
			{
				continue;
			}
		
			NSString *fullFilePath	= [NSString stringWithFormat:@"%@/%@", folderPath, fileName];
			NSString *fileContents	= [NSString stringWithContentsOfFile:fullFilePath
															    encoding:NSStringEncodingConversionAllowLossy
																   error:&error];
			
			NSLog(@"%@", fileName);
			
			// iterate fileContents
			NSArray *lines		= [fileContents componentsSeparatedByString:@"\n"];
			NSUInteger index	= 2;
			
			while(index < lines.count)
			{
				NSString *trackIdentifier = [lines objectAtIndex:index];
				
				// Fix break breaks
				if([trackIdentifier isEqualToString:@"\r"])
				{
					index += pageBufferLines;
					trackIdentifier = [lines objectAtIndex:index];
				}
				
				if([unmodeledTrackAbbreviations containsObject:trackIdentifier])
				{
					NSUInteger thisTrackNumber = [unmodeledTrackAbbreviations indexOfObject:trackIdentifier];
					raceCounterArray[thisTrackNumber]++;
				}
				else
				{
					[unmodeledTrackAbbreviations addObject:trackIdentifier];
					newTrackNumber++;
					
					// HACK: since unsigned ints can't start at -1, fix initial occurance after incrementing
					if(index == 2)
					{
						newTrackNumber = 0;
					}
				}
				
				NSUInteger numberReplayBufferLines = [self getNumberLinesToAddForResultScenerioFrom:lines
																							atIndex:index];
												
				index += numberReplayBufferLines;
				index += linesBetweenAbbreviations;
			}
		}
	}
	
	NSMutableArray *unmodeledTrackAbbreviationsWithCount;
	
	// HACK: rather than create a structure or class
	//			for each trackAbb:
	//				simply crate a strings with "trackAbb:raceCount"
	//				and add to unmodeledTrackAbbreviationsWithCount array
	for(NSUInteger index = 0; index < unmodeledTrackAbbreviations.count; index++)
	{
		NSString *trackAbbreviation = [unmodeledTrackAbbreviations objectAtIndex:index];
		NSUInteger numRaces			= raceCounterArray[index];
		NSString *numRacesString	= [NSString stringWithFormat:@"%lu", numRaces];
		NSString *combinedString	= [NSString stringWithFormat:@"%@:%@", trackAbbreviation, numRacesString];
		
		[unmodeledTrackAbbreviationsWithCount addObject:combinedString];
	}
	
	return unmodeledTrackAbbreviationsWithCount;
}

- (NSUInteger)getNumberLinesToAddForResultScenerioFrom:(NSArray*)lines
											   atIndex:(NSUInteger)index
{
	NSUInteger numLinesToAdd	= 0;
	NSUInteger scenerioA_Count	= 47;
	NSUInteger scenerioA_Buffer	= 7;
	NSUInteger scenerioB_Count	= 45;
	NSUInteger scenerioB_Buffer	= 7;
	
	// check each possible scenerio
	NSUInteger testLineNumber = index + scenerioA_Count;
	
	if(testLineNumber < lines.count)
	{
		NSString *testWord = [lines objectAtIndex:testLineNumber];
		
		if([testWord hasSuffix:@"Result"])
		{
			numLinesToAdd = scenerioA_Buffer;
		}
		else
		{
			testLineNumber = index + scenerioB_Count;
			
			if(testLineNumber < lines.count)
			{
				NSString *testWord = [lines objectAtIndex:testLineNumber];
				
				if([testWord hasSuffix:@"Result"])
				{
					numLinesToAdd = scenerioB_Buffer;
				}
			}
		}
	}
	
	if(numLinesToAdd > 0)
	{
		NSLog(@"ccc");
	}
	
	return numLinesToAdd;
}


- (void)printStatArrays:(double*)statsAccumulatorArray
		andCounterArray:(int*)raceCounterArray
{
	for(int index  = 0; index < kNumberRaceDistances * kMaximumNumberEntries * kNumberStatFields; index++)
	{
		double value = statsAccumulatorArray[index];
		int numRaces = raceCounterArray[index];
		
		NSLog(@"raceCounter[%i]: %i		%lf", index, numRaces,  value);
	}
		
	NSLog(@"\n");
}

- (void)editPastLinesAtPath:(NSString*)uneditedPastLinesPath
{
	NSString *strippedFolderPath	= @"/Users/ronjurincie/Desktop/Project Ixtlan/Dogs/Stripped Past Lines";
	NSFileManager *fileManager		= [NSFileManager defaultManager];
	NSError *error					= nil;
	NSArray *folderContents			= [fileManager contentsOfDirectoryAtPath:uneditedPastLinesPath
																		error:&error];

	for(NSString *fileName in folderContents)
	{
		if([fileName hasSuffix:@".DS_Store"])
		{
			continue;
		}
		
		NSString *fullFilePath	= [NSString stringWithFormat:@"%@/%@", uneditedPastLinesPath, fileName];
		NSString *fileContents	= [NSString stringWithContentsOfFile:fullFilePath
															encoding:NSStringEncodingConversionAllowLossy
															  error:&error];
				
		if(fileContents.length == 0)
		{
			NSLog(@"EMPTY FILE: %@", fullFilePath);
			continue;
		}

		// standardize all to smallCase
		NSString *lowerCaseName			= [fileName lowercaseString];
		NSString *newFilePath			= [NSString stringWithFormat:@"%@/%@.txt", strippedFolderPath, lowerCaseName];
		NSString *strippedFileContents	= [self stripHtmlAndWhitespaceFromFileAtPath:fileContents];
		
		if(strippedFileContents.length == 0)
		{
			NSLog(@"EMPTY Stripped FILE: %@", newFilePath);
			exit(1);
		}
		
		error = nil;
		
		[strippedFileContents writeToFile:newFilePath
							   atomically:YES
								 encoding:NSUTF8StringEncoding
									error:&error];
				
		if(error)
		{
			NSLog(@"error writing stripped file to new location");
			exit(1);
		}
		
		NSLog(@"%@", fileName);
	}
}

- (NSString*)stripHtmlAndWhitespaceFromFileAtPath:(NSString*)originalFileContentsString
{
	NSError *error							= nil;
	NSMutableString *mutableFileContents	= [originalFileContentsString mutableCopy];
	NSMutableArray *modifiedFileLines		= [NSMutableArray new];
	NSString *startingTargetString			= @"    <td nowrap class= ";
	
	// prior to splitting original string use NSRegularExpression class to:
	//	strip unwanted /r's and /n's at beginning of string
	
	NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"^(\n, ,\t,\r)+"
																			options:NSRegularExpressionCaseInsensitive
																			  error:&error];

	[regex1 replaceMatchesInString:mutableFileContents
						   options:NSMatchingAnchored
							 range:NSMakeRange(0, mutableFileContents.length)
					  withTemplate:@""];
				
	NSArray *fileLines			= [mutableFileContents componentsSeparatedByString:@"\n"];
	BOOL foundStartingLine		= NO;
	BOOL foundEmptyLine			= NO;
	NSUInteger index			= 0;
	NSString *thisModifiedLine	= nil;

	while(index < fileLines.count - 1)
	{
		foundStartingLine = NO;
		
		// start looking for startingLine
		while(foundStartingLine == NO && index < fileLines.count - 1)
		{
			NSString *thisLine = [fileLines objectAtIndex:++index];

			if([thisLine hasPrefix:startingTargetString])
			{
				foundStartingLine	= YES;
				thisModifiedLine	= [self modifyPastLineString:thisLine];
				
				// add this track and date line
				[modifiedFileLines addObject: thisModifiedLine];
			
				// skip line ahead
				index++;
			}
		}
	
		// modify all lines and copy to srrippedFileContentsArray until whiteSpace encountered
		foundEmptyLine = NO;

		while(foundEmptyLine == NO && index < fileLines.count -1)
		{
			NSString *thisLine = [fileLines objectAtIndex:++index];
	
			if(thisLine.length < 3)
			{
				foundEmptyLine = YES;
				
				// go ahead and write 1 empey line to array
				[modifiedFileLines addObject:@""];
			}
			else
			{
				thisModifiedLine = [self modifyPastLineString:thisLine];
				
				[modifiedFileLines addObject:thisModifiedLine];
			}
		}
	}
	
	NSString *strippedFileContents = [self getStringFromArray:[modifiedFileLines copy]];
		
	return  strippedFileContents;
}

- (NSString*)modifyPastLineString:(NSString*)originalLine
{
	NSMutableString *modifiedLine	= [originalLine mutableCopy];
	NSError *error					= nil;
	
	NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"^.*\">"
																			options:NSRegularExpressionAnchorsMatchLines
																			  error:&error];
				
	// line type 1
	[regex1 replaceMatchesInString:modifiedLine
						   options:NSMatchingAnchored
							 range:NSMakeRange(0, modifiedLine.length)
					  withTemplate:@""];
			
	// line type 2
	if([originalLine isEqualToString:modifiedLine])
	{
		NSRegularExpression *regex4 = [NSRegularExpression regularExpressionWithPattern:@"^.*<.+nowrap>"
																				options:NSRegularExpressionAnchorsMatchLines
																				  error:&error];
		[regex4 replaceMatchesInString:modifiedLine
							   options:NSMatchingAnchored
								 range:NSMakeRange(0, modifiedLine.length)
						  withTemplate:@""];
	}
	
	// line thpe 3
	if([originalLine isEqualToString:modifiedLine])
	{
		NSRegularExpression *regex5 = [NSRegularExpression regularExpressionWithPattern:@"^.*<.+nowrap align = right>"
																				options:NSRegularExpressionAnchorsMatchLines
																				  error:&error];
		[regex5 replaceMatchesInString:modifiedLine
							   options:NSMatchingAnchored
								 range:NSMakeRange(0, modifiedLine.length)
						  withTemplate:@""];
	}
	
	NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:@"<.+>"
																			options:NSRegularExpressionAnchorsMatchLines
																			  error:&error];
	
	NSRegularExpression *regex3 = [NSRegularExpression regularExpressionWithPattern:@".nbsp."
																			options:NSRegularExpressionAnchorsMatchLines
																			  error:&error];

	[regex2 replaceMatchesInString:modifiedLine
						   options:NSMatchingWithoutAnchoringBounds
							 range:NSMakeRange(0, modifiedLine.length)
					  withTemplate:@""];

	[regex3 replaceMatchesInString:modifiedLine
						   options:NSMatchingWithoutAnchoringBounds
							 range:NSMakeRange(0, modifiedLine.length)
					  withTemplate:@""];

			
	return modifiedLine;
}

- (NSString*)getStringFromArray:(NSArray*)textLinesArray
{
	NSMutableString *fileContents = [NSMutableString new];
	
	for(NSUInteger index = 0; index < textLinesArray.count; index++)
	{
		NSString *stringToAdd = [textLinesArray objectAtIndex:index];
		
		[fileContents appendString:stringToAdd];
		[fileContents appendString:@"\n"];
	}
	
	return fileContents;
}

- (void)loadWosrtAndBestTimesFromArray:(NSArray*)worstAndBestTimesArray
					 intoDistanceStats:(NSOrderedSet*)distanceStats
{
	NSNumber *dnfTime3Turns		= [worstAndBestTimesArray objectAtIndex:0];
	NSNumber *dnfTime2Turns		= [worstAndBestTimesArray objectAtIndex:1];
	NSNumber *bestTime3Turns	= [worstAndBestTimesArray objectAtIndex:2];
	NSNumber *bestTime2Turns	= [worstAndBestTimesArray objectAtIndex:3];

	ECRaceDistanceStats *twoTurnRaceDxStats		= [distanceStats objectAtIndex:0];
	ECRaceDistanceStats *threeTurnRaceDxStats	= [distanceStats objectAtIndex:1];
	
	twoTurnRaceDxStats.bestTime2Turns	= bestTime2Turns;
	twoTurnRaceDxStats.dnfTime2Turns	= dnfTime2Turns;
	threeTurnRaceDxStats.bestTime2Turns	= bestTime3Turns;
	threeTurnRaceDxStats.dnfTime2Turns	= dnfTime3Turns;
}

- (NSUInteger)getIndexOfPostPosition:(NSArray*)tokens
{
	// return 0 if dnf situation is encountered
	// otherwise return the index of the post postion word
	
	/*
	 NORMAL EXAMPLE:
	 King Tarik 74½ 3 6 8 7 5 3½ 31.44 8.00 Blocked 1st-went Wide
	 
	 DNF EXAMPLES:
	 (1)	 Deco Alamo Rojo      2 0 0    0    8       94.00 -----
	 (2)	 Hessian Soldier  73½ 7 6 7    7    7       91.00 9.90  Collided 1st Turn-fell
	 (3)	 Bow Sassy Circle 59½ 2 2 8    8    8       92.00 4.10  Clipped 1st Turn-fell
	 
	 Use first char of word to find first number
	 */

	NSUInteger index	= 0;
	char firstCharacter	= '?';
	
	for(; index < tokens.count; index++)
	{
		NSString *word = [tokens objectAtIndex:index];
		firstCharacter = [word characterAtIndex:0];
		
		if([self isThisCharADigit:firstCharacter])
		{
			if([NSString isThisAValidWeightString:word] == NO)
			{
				// see DNF EXAMPLE (1) above
				index = 0;
			}
			else
			{
				// post should otherwise be the next word
				index++;
			}
			
			break;
		}
	}
	
	return index;
}

- (NSMutableOrderedSet*)getClassStatsFromWinTimesArray:(double*)accumulatedWinTimesArray
									   placeTimesArray:(double*)accumulatedPlaceTimesArray
										showTimesArray:(double*)accumulatedShowTimesArray
									  raceCounterArray:(int*)raceCounterArray
										  forTrackName:(NSString*)trackName
										 andTrackStats:(ECTrackStats*)trackStats
{
	NSMutableOrderedSet *classStats = [NSMutableOrderedSet new];
	NSArray *raceClassArray			= [self getClassesForTrackNamed:trackName];
	NSUInteger arraySize			= raceClassArray.count * kNumberRaceDistances;
	double averageWinTime2Turns		= 0.0;
	double averagePlaceTime2Turns	= 0.0;
	double averageShowTime2Turns	= 0.0;
	double averageWinTime3Turns		= 0.0;
	double averagePlaceTime3Turns	= 0.0;
	double averageShowTime3Turns	= 0.0;
	NSUInteger raceClassIndex		= 0;
	NSString *className				= nil;
	
	for(NSUInteger index = 0; index < arraySize; index++)
	{
		ECClassStats *newClassStats = [NSEntityDescription insertNewObjectForEntityForName:@"ECClassStats"
																 inManagedObjectContext:MOC];
		raceClassIndex	= index < raceClassArray.count ? index : index - raceClassArray.count;
		className		= [raceClassArray objectAtIndex:raceClassIndex];
		
		if(index < raceClassArray.count)  // 2 turn races
		{
			NSUInteger num2TurnRacesThisClass = raceCounterArray[index];
			
			if(num2TurnRacesThisClass > 0)
			{
				double accumulatedWinTimes2Turns	= accumulatedWinTimesArray[index];
				double accumulatedPlaceTimes2Turns	= accumulatedPlaceTimesArray[index];
				double accumulatedShowTimes2Turns	= accumulatedShowTimesArray[index];
				averageWinTime2Turns				= accumulatedWinTimes2Turns / num2TurnRacesThisClass;
				averagePlaceTime2Turns				= accumulatedPlaceTimes2Turns / num2TurnRacesThisClass;
				averageShowTime2Turns				= accumulatedShowTimes2Turns / num2TurnRacesThisClass;
			}
			
			raceClassIndex = 0;
		}
		else	// 3 turn races
		{
			NSUInteger num3TurnRacesThisClass = raceCounterArray[index];

			if(num3TurnRacesThisClass > 0)
			{
				double accumulatedWinTimes3Turns	= accumulatedWinTimesArray[index];
				double accumulatedPlaceTimes3Turns	= accumulatedPlaceTimesArray[index];
				double accumulatedShowTimes3Turns	= accumulatedShowTimesArray[index];
				averageWinTime3Turns				= accumulatedWinTimes3Turns / num3TurnRacesThisClass;
				averagePlaceTime3Turns				= accumulatedPlaceTimes3Turns / num3TurnRacesThisClass;
				averageShowTime3Turns				= accumulatedShowTimes3Turns / num3TurnRacesThisClass;
			}
			
			raceClassIndex = 1;
		}
				
		newClassStats.raceClass					= trackName;
		newClassStats.trackStats				= trackStats;
		newClassStats.averageWinTime2Turns		= [NSNumber numberWithDouble:averageWinTime2Turns];
		newClassStats.averageWinTime3Turns		= [NSNumber numberWithDouble:averageWinTime3Turns];
		newClassStats.averagePlaceTime2Turns	= [NSNumber numberWithDouble:averageShowTime2Turns];
		newClassStats.averagePlaceTime3Turns	= [NSNumber numberWithDouble:averageShowTime3Turns];
		newClassStats.averageShowTime2Turns		= [NSNumber numberWithDouble:averageShowTime2Turns];
		newClassStats.averageShowTime3Turns		= [NSNumber numberWithDouble:averageShowTime3Turns];
		newClassStats.raceClassIndex			= [NSNumber numberWithInt:raceClassIndex];
		
		[classStats addObject:newClassStats];
	}
	
	return classStats;
}

- (NSOrderedSet*)getDistanceStatsFromArray:(double*)accumulatedStatsArray
						   andCounterArray:(int*)accumulatedCounterArray
{
	int raceCounterAtDx						= 0;
	double statValue						= 0.0;
	double breakAverageFromPost				= 0.0;
	double firstTurnAverageFromPost			= 0.0;
	double finishPositionAverageFromPost	= 0.0;
	double finishTimeAverageFromPost		= 0.0;
	double farTurnAverageFromFirstTurn		= 0.0;
	double finishPositionAverageFromFarTurn	= 0.0;
				
	ECPostStats *twoTurnPost_1 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *twoTurnPost_2 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *twoTurnPost_3 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *twoTurnPost_4 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *twoTurnPost_5 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *twoTurnPost_6 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *twoTurnPost_7 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *twoTurnPost_8 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *twoTurnPost_9 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	
	ECPostStats *threeTurnPost_1 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *threeTurnPost_2 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *threeTurnPost_3 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *threeTurnPost_4 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *threeTurnPost_5 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *threeTurnPost_6 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *threeTurnPost_7 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *threeTurnPost_8 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *threeTurnPost_9 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	
	ECFirstTurnStats *twoTurnFtPos_1 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	ECFirstTurnStats *twoTurnFtPos_2 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	ECFirstTurnStats *twoTurnFtPos_3 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	ECFirstTurnStats *twoTurnFtPos_4 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	ECFirstTurnStats *twoTurnFtPos_5 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	ECFirstTurnStats *twoTurnFtPos_6 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	ECFirstTurnStats *twoTurnFtPos_7 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	ECFirstTurnStats *twoTurnFtPos_8 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	ECFirstTurnStats *twoTurnFtPos_9 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	
	ECFirstTurnStats *threeTurnFtPos_1 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	ECFirstTurnStats *threeTurnFtPos_2 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	ECFirstTurnStats *threeTurnFtPos_3 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	ECFirstTurnStats *threeTurnFtPos_4 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	ECFirstTurnStats *threeTurnFtPos_5 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	ECFirstTurnStats *threeTurnFtPos_6 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	ECFirstTurnStats *threeTurnFtPos_7 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	ECFirstTurnStats *threeTurnFtPos_8 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	ECFirstTurnStats *threeTurnFtPos_9 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
	
	ECTopOFStretchStats *twoTurnTosPos_1 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	ECTopOFStretchStats *twoTurnTosPos_2 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	ECTopOFStretchStats *twoTurnTosPos_3 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	ECTopOFStretchStats *twoTurnTosPos_4 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	ECTopOFStretchStats *twoTurnTosPos_5 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	ECTopOFStretchStats *twoTurnTosPos_6 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	ECTopOFStretchStats *twoTurnTosPos_7 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	ECTopOFStretchStats *twoTurnTosPos_8 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	ECTopOFStretchStats *twoTurnTosPos_9 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	
	ECTopOFStretchStats *threeTurnTosPos_1 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	ECTopOFStretchStats *threeTurnTosPos_2 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	ECTopOFStretchStats *threeTurnTosPos_3 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	ECTopOFStretchStats *threeTurnTosPos_4 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	ECTopOFStretchStats *threeTurnTosPos_5 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	ECTopOFStretchStats *threeTurnTosPos_6 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	ECTopOFStretchStats *threeTurnTosPos_7 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	ECTopOFStretchStats *threeTurnTosPos_8 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	ECTopOFStretchStats *threeTurnTosPos_9 = [NSEntityDescription insertNewObjectForEntityForName:@"ECTopOfStretchStats" inManagedObjectContext:MOC];
	
	NSArray *postStats548	= [[NSArray alloc] initWithObjects:twoTurnPost_1, twoTurnPost_2, twoTurnPost_3, twoTurnPost_4, twoTurnPost_5, twoTurnPost_6, twoTurnPost_7, twoTurnPost_8, twoTurnPost_9, nil];
	NSArray *ftStats548		= [[NSArray alloc] initWithObjects:twoTurnFtPos_1, twoTurnFtPos_2, twoTurnFtPos_3, twoTurnFtPos_4, twoTurnFtPos_5, twoTurnFtPos_6, twoTurnFtPos_7, twoTurnFtPos_8, twoTurnFtPos_9, nil];
	NSArray *tosStats548	= [[NSArray alloc] initWithObjects:twoTurnTosPos_1, twoTurnTosPos_2, twoTurnTosPos_3, twoTurnTosPos_4, twoTurnTosPos_5, twoTurnTosPos_6, twoTurnTosPos_7, twoTurnTosPos_8, twoTurnTosPos_9, nil];
	
	NSArray *postStats678	= [[NSArray alloc] initWithObjects:threeTurnPost_1, threeTurnPost_2, threeTurnPost_3, threeTurnPost_4, threeTurnPost_5, threeTurnPost_6, threeTurnPost_7, threeTurnPost_8,  threeTurnPost_9,nil];
	NSArray *ftStats678		= [[NSArray alloc] initWithObjects:threeTurnFtPos_1, threeTurnFtPos_2, threeTurnFtPos_3, threeTurnFtPos_4, threeTurnFtPos_5, threeTurnFtPos_6, threeTurnFtPos_7, threeTurnFtPos_8,  threeTurnFtPos_9, nil];
	NSArray *tosStats678	= [[NSArray alloc] initWithObjects:threeTurnTosPos_1, threeTurnTosPos_2, threeTurnTosPos_3, threeTurnTosPos_4, threeTurnTosPos_5, threeTurnTosPos_6, threeTurnTosPos_7, threeTurnTosPos_8, threeTurnTosPos_9, nil];

	ECRaceDistanceStats *twoTurnRaceStats	= [NSEntityDescription insertNewObjectForEntityForName:@"ECRaceDistanceStats"
																			inManagedObjectContext:MOC];
	ECRaceDistanceStats *threeTurnRaceStats = [NSEntityDescription insertNewObjectForEntityForName:@"ECRaceDistanceStats"
																			inManagedObjectContext:MOC];

	twoTurnRaceStats.postStats			= [[NSOrderedSet alloc] initWithArray:postStats548];
	twoTurnRaceStats.firstTurnStats		= [[NSOrderedSet alloc] initWithArray:ftStats548];
	twoTurnRaceStats.topOfStretchStats	= [[NSOrderedSet alloc] initWithArray:tosStats548];
	
	threeTurnRaceStats.postStats			= [[NSOrderedSet alloc] initWithArray:postStats678];
	threeTurnRaceStats.firstTurnStats		= [[NSOrderedSet alloc] initWithArray:ftStats678];
	threeTurnRaceStats.topOfStretchStats	= [[NSOrderedSet alloc] initWithArray:tosStats678];
	
	NSOrderedSet *raceDxStatsSet = [[NSOrderedSet alloc] initWithObjects:twoTurnRaceStats, threeTurnRaceStats, nil];
	
	// iterate through arrays
	for(int raceDxIndex = 0; raceDxIndex < kNumberRaceDistances; raceDxIndex++)
	{
		ECRaceDistanceStats *dxStats = [raceDxStatsSet objectAtIndex:raceDxIndex];
		
		for(int positionIndex = 0; positionIndex < kMaximumNumberEntries; positionIndex++)
		{
			ECPostStats *postStats			= [dxStats.postStats objectAtIndex:positionIndex];
			ECFirstTurnStats *ftStats		= [dxStats.firstTurnStats objectAtIndex:positionIndex];
			ECTopOFStretchStats *tosStats	= [dxStats.topOfStretchStats objectAtIndex:positionIndex];
			
			// calculate and assign average values for each post
			for(int fieldNumber = 0; fieldNumber < kNumberStatFields; fieldNumber++)
			{
				// get the counter for this fieldNumber at this postIndex for this raceDxIndex
				int index		= (raceDxIndex * (kMaximumNumberEntries * kNumberStatFields)) + (positionIndex * kNumberStatFields) + fieldNumber;
				raceCounterAtDx	= accumulatedCounterArray[index];
				statValue		= accumulatedStatsArray[index];
				
				// get the statAccumulator this fieldNumber at this postIndex for this raceDxIndex
				switch (fieldNumber)
				{
					case 0:
						breakAverageFromPost = statValue / raceCounterAtDx;
						break;
					
					case 1:
						firstTurnAverageFromPost = statValue / raceCounterAtDx;
						break;
					
					case 2:
						finishPositionAverageFromPost = statValue / raceCounterAtDx;
						break;
						
					case 3:
						finishTimeAverageFromPost = statValue / raceCounterAtDx;
						break;
					
					case 4:
						farTurnAverageFromFirstTurn = statValue / raceCounterAtDx;
						break;
					
					case 5:
						finishPositionAverageFromFarTurn = statValue / raceCounterAtDx;
						break;
					
					default:
						NSLog(@"bad field number");
						break;
				}
			}
			
			postStats.breakPositionAverage		= [NSNumber numberWithDouble:breakAverageFromPost];
			postStats.firstTurnPositionAverage	= [NSNumber numberWithDouble:firstTurnAverageFromPost];
			postStats.finishPositionAverage		= [NSNumber numberWithDouble:finishPositionAverageFromPost];
			ftStats.averagePositionFarTurn		= [NSNumber numberWithDouble:farTurnAverageFromFirstTurn];
			tosStats.averageFinishPosition		= [NSNumber numberWithDouble:finishPositionAverageFromFarTurn];
		}
	}

	return raceDxStatsSet;
}

- (BOOL)isThisCharADigit:(char)c
{
	BOOL answer = NO;
	
	if(c >= '0' && c <= '9')
	{
		answer = YES;
	}
	
	return answer;
}

- (BOOL)isThisADecimalWord:(NSString*)word
{
	BOOL answer = NO;
	
	
	
	return answer;
}

#pragma custom class methods

- (id)init
{
    NSLog(@"ECEVolutionManager.init called");
    
    if (self = [super init])
    {
        // seed random number generator here ONLY
        time_t seed = time(NULL);
        srand((unsigned) time(&seed));
        
        self.population = nil;
    }
    
    return self;
}


- (void)createNewPopoulationWithName:(NSString*)populationName
						 initialSize:(NSUInteger)initialSize
						maxTreeDepth:(NSUInteger)maxTreeDepth
						minTreeDepth:(NSUInteger)mintreeDepth
						mutationRate:(float)mutationRate
							comments:(NSString*)comments
{
    NSLog(@"createNewPopulation called in ECEvolutionManager");
	
	self.generationsEvolved = [self.population.generationNumber unsignedIntegerValue];
    self.population			= [NSEntityDescription insertNewObjectForEntityForName:@"HandicapperPopulation"
															inManagedObjectContext:MOC];
		
	if(self.population)
	{
		self.populationSize				= initialSize;
		self.population.populationName	= populationName;
        self.population.initialSize		= [NSNumber numberWithInteger:initialSize];
        self.population.minTreeDepth	= [NSNumber numberWithInteger:mintreeDepth];
        self.population.maxTreeDepth	= [NSNumber numberWithInteger:maxTreeDepth];
        self.population.genesisDate		= [NSDate date];
        self.population.mutationRate	= [NSNumber numberWithDouble:mutationRate];
	}

	self.rankedPopulation = [self createNewHandicappers];
	
	[self fillWorkingPopulationArrayWithOriginalMembers];
}


- (void)fillWorkingPopulationArrayWithOriginalMembers
{
	// fill the workingPopulationMembersDna with
	// arrays of each members trees created from their string form
	self.workingPopulationDna	= [NSMutableArray new];
	NSMutableArray *dnaTrees	= [NSMutableArray new];
	NSUInteger populationSize	= [self.population.initialSize unsignedIntegerValue];

	for(int popIndex = 0; popIndex < populationSize; popIndex++)
	{
		ECHandicapper *tempHandicapper	= self.rankedPopulation[popIndex];
		NSArray *thisMembersDnaTrees	= [NSArray arrayWithObjects:[self recoverTreeFromString:tempHandicapper.classStrengthTree],
																	[self recoverTreeFromString:tempHandicapper.breakPositionStrengthTree],
																	[self recoverTreeFromString:tempHandicapper.breakSpeedStrengthTree],
																	[self recoverTreeFromString:tempHandicapper.firstTurnPositionStrengthTree],
																	[self recoverTreeFromString:tempHandicapper.firstTurnSpeedStrengthTree],
																	[self recoverTreeFromString:tempHandicapper.topOfStretchPositionStrengthTree],
																	[self recoverTreeFromString:tempHandicapper.topOfStretchSpeedStrengthTree],
																	[self recoverTreeFromString:tempHandicapper.finalRaceStrengthTree],
																	[self recoverTreeFromString:tempHandicapper.earlySpeedRelevanceTree],
																	[self recoverTreeFromString:tempHandicapper.otherRelevanceTree],
																	nil];
				
		[dnaTrees addObject:thisMembersDnaTrees];
   }
   
	self.workingPopulationDna = [dnaTrees copy];
}

- (void)trainPopulationForGenerations:(NSUInteger)numberGenerations
{
    NSLog(@"trainPopulation called in ECEvolutionManager");

	if(nil == self.population)
	{
		// use NSAlert to deal with this
		NSAlert *alert          = [[NSAlert alloc] init];
		NSString *question      = NSLocalizedString(@"Create New Population", @"Cancel");
		NSString *quitButton    = NSLocalizedString(@"OK", @"");
		NSString *info			= NSLocalizedString(@"No population has been selected.",
													@"Tap the Create New Population button or Select Population button?");
				
		[alert setMessageText:question];
		[alert setInformativeText:info];
		[alert addButtonWithTitle:quitButton];
		
		[alert runModal];
	
		return;
	}
		
	self.generationsThisCycle	= numberGenerations;
	NSString *resultFolderPath	= @"FIX: ME";
	
	for(NSUInteger localGenNumber = 0; localGenNumber < numberGenerations; localGenNumber++)
    {
		self.trainingPopSize	= self.populationSize / 2;
		BOOL testAllMembers		= NO;

		if(localGenNumber == 0) // FIX: check for user requesting entire pop testing (
								//	if database changed, or incubator changed, for example
		{
			self.trainingPopSize	= self.populationSize;
			testAllMembers			= YES;
		}
	
        [self testPopulation:self.population
			includingParents:testAllMembers
		  belowResultsFolder:resultFolderPath];
    
        [self createNextGenerationForPopulation:self.population];
    }
    
    [ECMainController updateAndSaveData];
	
	NSLog(@"trainPopulation finished");
}


   
- (void)testPopulation:(ECPopulation*)population
	  includingParents:(BOOL)parentsToo
	belowResultsFolder:(NSString *)resultFolderPath
{
	// self.workingPopulation array MUST be sorted at this point with:
	//	chldren occupying BOTTOM HALF of array with their indices
	
	NSUInteger startIndex					= self.populationSize - self.trainingPopSize;
	NSFileManager *localFileManager			= [NSFileManager defaultManager];
	NSDirectoryEnumerator *dirEnumerator	= [localFileManager enumeratorAtPath:resultFolderPath];
	NSString *fileName						= nil;
	BOOL isDirectory						= NO;
	
    while(fileName = [dirEnumerator nextObject])
    {
		NSString *fullFilePath = [NSString stringWithFormat:@"%@/%@", resultFolderPath, fileName];
		
		if([localFileManager fileExistsAtPath:fullFilePath
								  isDirectory:&isDirectory] && isDirectory)
		{
			[self testPopulation:population
				includingParents:parentsToo
		   belowResultsFolder:fullFilePath];
		}
		else
		{
			if([fileName isEqualToString:@".DS_Store"])
			{
				continue;
			}
			
			NSArray *raceRecordsForThisEvent = [self getTrainingRaceRecordsForResultsFileAtPath:fullFilePath];
		
			for(ECTrainigRaceRecord *trainingRaceRecord in raceRecordsForThisEvent)
			{
				NSArray *winBetsArray = [self getWinPredictionsFromPopulation:population
																	  forRace:trainingRaceRecord];
				// iterate handicappers array
				NSUInteger incrementedTotal;
				
				for(NSUInteger index = startIndex; index < self.populationSize; index++)
				{
					ECHandicapper *handicapper	= [self.rankedPopulation objectAtIndex:index];
					incrementedTotal			= [handicapper.numberWinBets unsignedIntegerValue] + 1;
					handicapper.numberWinBets	= [NSNumber numberWithInt:incrementedTotal];
				
					// only increment numberWinBetWinners if handicapper predicted winner correctly
					if(trainingRaceRecord.winningPost == [[winBetsArray objectAtIndex:index] unsignedIntegerValue])
					{
						incrementedTotal				= [handicapper.numberWinBetWinners unsignedIntegerValue] + 1;
						handicapper.numberWinBetWinners	= [NSNumber numberWithInt:incrementedTotal];
					}
				}
			}
		}
    }
}

//- (BOOL)analyzeRace
//{
//	NSUInteger start, end, count;
//	
//	ECHandicapper *handicapper;
//	NSNumber *postNumber;
//	NSInvocationOperation *analyzePostOp;
//	
//	BOOL result					= YES;
//	NSOperationQueue *opQueue	= [NSOperationQueue new];
//	
//	[opQueue setMaxConcurrentOperationCount:4];
//	
//	///////////////////////////////////////
//	// loop thorugh ALL POSSIBLE entries //
//	///////////////////////////////////////
//	for(NSUInteger post = 1; post <= kMaximumNumberEntries; post++)
//	{
//		ECEntry *entry = [[theRaceModel greyhoundEntries] objectAtIndex:post-1];
//		
//		// skip this entry if no unscratched entry at this post
//	}
//		
//	[opQueue waitUntilAllOperationsAreFinished];
//	
//	return result;
//}



- (NSArray*)getTrainingRaceRecordsForResultsFileAtPath:(NSString*)resultsFileAtPath
{
	// this method returns an array of ECRaceRecord objects (1 per race)
	// we are reading lines from result file now it looks like this (without the line numbers):
	//		1  <html>
	//		2  <head>
	//		3  <title> Rosnet,Inc - Greyhound Racing</title>
	//		4  </head>
	//		5  </head>
	//		6  <body bgcolor="#FFFFFF" text="#000000" vlink="#00FF00" link="#FFFF00">
	//		7  <font face=Arial Narrow size=3>
	//		8  <pre>
	//		9  ____________________________________________________________________________________________________________________________________
	//		10  DERBY LANE                   Wednesday Nov 05 2008 Afternoon   Race 1    Grade  C   (548)  Time: 31.19
	//		11  ____________________________________________________________________________________________________________________________________
	//		12  Don't Sell Short 64  1 5 1 2  1 2  1 1½    31.19 *2.30 Grabbed Lead 1st Turn
	//		13  Dancin Maddox    68½ 2 8 3    3    2 1½    31.30 12.90 Just Up For Place-midt
	//		14  Jt Gold N Silver 75½ 8 3 7    5    3 2     31.31 13.70 Trying Hard-showed Rl
	//		15  Kiowa Manley     71  5 1 2    2    4 2½    31.37 2.50  Factor To Stretch-ins
	//		16  King Tarik       74½ 3 6 8    7    5 3½    31.44 8.00  Blocked 1st-went Wide
	//		17  Good Luck Charm  61  4 7 4    4    6 4     31.49 9.50  Some Erly Gain-crwdd
	//		18  Cold B Be Happy  72  7 2 6    6    7 4½    31.50 3.50  Cls Qtrs Both Turns-rl
	//		19  Forego Cide      78  6 4 5    8    8 10    31.91 9.90  Went Wide 1st Tn-faded
	//		20  Alderson Kennel's BD. F 2/17/2006 Dodgem By Design x Sunberry
	//		21  1 Don't Sell Short  6.60    4.20    2.60     Quin        (1-2)        $45.60
	//		22  2 Dancin Maddox             10.80   8.00     Perf        (1-2)        $85.80
	//		23  8 Jt Gold N Silver                  4.80     Tri          (1-2-8)     $417.80
	//		24  5 Kiowa Manley                               Super       (1-2-8-5)   $4,246.40
	//		25

	BOOL isThisANewRecord	= NO;
	NSMutableArray *records	= [NSMutableArray new];
	NSError *error			= nil;
	NSString *fileContents	= [NSString stringWithContentsOfFile:resultsFileAtPath
													    encoding:NSStringEncodingConversionAllowLossy
														   error:&error];

	NSArray *fileContentsLineByLine = [fileContents componentsSeparatedByString:@"\n"];
	
	// skip html meta lines
	NSUInteger startIndex = 8;
	
	// takes us to the attendance line
	NSUInteger endIndex	= fileContentsLineByLine.count - 4;
	
	// iterate through file line by line
	// looking for start of each new race
	for(NSUInteger i = startIndex; i < endIndex; i++)
	{
		NSString *thisLine		= [fileContentsLineByLine objectAtIndex:i];
		NSString *twoLinesAhead	= [fileContentsLineByLine objectAtIndex:i+2];
		
		if([NSString isThisALongLineOfUnderscores:thisLine] && [NSString isThisALongLineOfUnderscores:twoLinesAhead])
		{
			// reset
			isThisANewRecord = NO;
			
			// create thisRaceLineByLine and add the line starting with trackName (lines 10)
			NSMutableArray *thisRaceLineByLine = [NSMutableArray new];
		
			[thisRaceLineByLine	addObject:[fileContentsLineByLine objectAtIndex:i+1]];
			
			// skips 2nd longLine...
			NSUInteger thisRaceLineNumber = 3;
			
			// loop until next race start found
			while(i + thisRaceLineNumber < endIndex)
			{
				thisLine			= [fileContentsLineByLine objectAtIndex:i + thisRaceLineNumber++];
				isThisANewRecord	= [NSString isThisALongLineOfUnderscores:thisLine];
				
				if(isThisANewRecord)
				{
					break;  // new record found
				}
				
				else
				{
					[thisRaceLineByLine addObject:thisLine];
				}
			}
			
			// load raceRecord fields form these lines
			ECTrainigRaceRecord	*trainingRaceRecord = [self getTrainingRaceRecordFromLines:thisRaceLineByLine];
			
			// add new raceRecord to records array
			[records addObject:trainingRaceRecord];
			
			// increment i so we don't reread this race
			i += thisRaceLineNumber - 2;
		}
	}
	
	// ok to return the mutableArray since an immutable copy is made for the return
	return records;
}

- (ECTrainigRaceRecord*)getTrainingRaceRecordFromLines:(NSArray*)resultFileLineByLine
{


	// Derby Lane ONLY
	
	//Line #	^
	//	0:		DERBY LANE                   Wednesday Nov 05 2008 Afternoon   Race 2    Grade  D   (548)  Time: 30.97
	//	1:		Curler Ron G     70½ 7 2 1 3  1 4  1 3½    30.97 3.50  Won With Ease-inside
	//	2:		Ww's Arcadia     60  4 3 2    2    2 3½    31.21 4.90  Held Place Safe-rail
	//	3:		Jamie M Grodeki  61½ 6 4 5    4    3 5     31.32 5.90  Swung Wide 1st-gaining
	//  4:		Silver Fang      67  1 8 4    3    4 6½    31.43 3.90  Outfinished-inside
	//	5:		Dust Doll        65  5 5 8    8    5 7½    31.50 7.30  Blocked 1st-some Gain
	//	6:		El Witty         64  2 6 6    6    6 8     31.51 16.60 No Room Erly-wide 2nd
	//	7:		Top Cat Hotshot  63  3 7 7    7    7 8½    31.57 33.00 Impeded 1st-forced Wd
	//	8:		Hamparsum        65½ 8 1 3    5    8 9     31.58 *2.40 Cls Qtrs 2nd Tn-faded
	//	9:		Floyd & Porter Kennel's Bd. M 3/31/2007 Lonesome Cry x Trayton's Baby
	//	10:		7 Curler Ron G      9.00    4.40    2.60     Quin        (4-7)        $21.80
	//	11:		4 Ww's Arcadia              13.80   3.80     Perf        (7-4)        $90.20
	//	12:		6 Jamie M Grodeki                   3.00     Tri          (7-4-6)     $178.60
	//	13:		1 Silver Fang                                Super       (7-4-6-1)   $720.60
	//	14:		Double |(1-7) | $45.80
	//
	
	// fill race record with using lines above as template
	
	//	- trackName
	//	- raceDate
	//	- raceClass
	//	- raceNumber
	//	- raceDistance
	//	- entryNames with postPositions
		
	NSString *modifiedLine		= [self removeExtraSpacesFromString:[resultFileLineByLine objectAtIndex:0]];
	NSArray *lineZeroTokens		= [modifiedLine componentsSeparatedByString:@" "];
	NSUInteger firstDateToken	= [self getIndexOfFirstDateToken:lineZeroTokens];
	
	if(firstDateToken == 0)
	{
		NSLog(@"error getting index start of date token");
		exit(1);
	}
	
	// get track Name
	NSMutableString *trackName = [NSMutableString new];
	
	for(NSUInteger index = 0; index < firstDateToken; index++)
	{
		// add a space " " character unless initial word
		if(index > 0)
		{
			[trackName appendString:@" "];
		}
	
		NSString *word = [lineZeroTokens objectAtIndex:index];
	
		[trackName appendString:word];
	}
	
	// jump through some hoops to create NSDate object
	NSString *yyyySubstring	= [lineZeroTokens objectAtIndex:firstDateToken + 3];
	NSString *monthName		= [lineZeroTokens objectAtIndex:firstDateToken + 1];
	NSString *mmSubstring	= [self getMmSubstringFromSpelledMonth:monthName];
	NSString *ddSubstring	= [lineZeroTokens objectAtIndex:firstDateToken + 2];
	NSString *suffix		= @" 10:00:00 +0600";
	NSString *dateString	= [NSString stringWithFormat:@"%@-%@-%@%@", yyyySubstring, mmSubstring, ddSubstring, suffix];
	NSDate *raceDate		= [NSDate dateWithString:dateString];
	NSString *raceClass		= [lineZeroTokens objectAtIndex:firstDateToken + 8];
	NSUInteger raceNumber	= [[lineZeroTokens objectAtIndex:firstDateToken + 6] integerValue];
	NSUInteger raceDx		= [self getRaceDxFromString:[lineZeroTokens objectAtIndex:firstDateToken + 9]];
	double winningTime		= [[lineZeroTokens objectAtIndex:firstDateToken + 11] doubleValue];

// iterate through resultFileLineByLine filling in entryNamesArray and postOddsArray
	NSMutableArray *namesByPostArray	= [NSMutableArray new];
	NSMutableArray *finishByPostArray	= [NSMutableArray new];

	NSUInteger lineNumber	= 0;
	BOOL isThisKennelLine	= NO;
		
	// fill arrays with strings @"empty post"
	for(NSUInteger index = 0; index < kMaximumNumberEntries; index++)
	{
		[namesByPostArray addObject:@"Empty Post"];
		[finishByPostArray addObject:@"Empty Post"];
	}
	
	// replace @"Empty Post" strings with name and odds for each post
	while(1)
	{
		NSString *resultFileLine	= [resultFileLineByLine objectAtIndex:++lineNumber];
		modifiedLine				= [self removeExtraSpacesFromString:resultFileLine];
		isThisKennelLine			= [NSString isThisWinningKennelLine:modifiedLine];

		if(isThisKennelLine)
		{
			break;
		}
		
		NSArray *tokens = [modifiedLine componentsSeparatedByString:@" "];
		
		NSString *entryName			= nil;
		NSUInteger postNumber		= 0;
		NSUInteger finishPosition	= 0;
		
		[self useResultLineArray:tokens
		  toGetValueForEntryName:&entryName
					postPosition:&postNumber
					andFinishPosition:&finishPosition];
				
		NSNumber *finishPositionNumber = [NSNumber numberWithInteger:finishPosition];
				
		[finishByPostArray replaceObjectAtIndex:postNumber-1
									 withObject:finishPositionNumber];
				
		[namesByPostArray replaceObjectAtIndex:postNumber-1
									withObject:entryName];
	}
	
	ECRaceResults *results	= [[ECRaceResults alloc] initWithFinishPositionsArray:finishByPostArray];
	results.winningTime		= winningTime;
	ECRacePayouts *payouts	= [self getPayoutsUsingArray:resultFileLineByLine
										   atLineNumber:++lineNumber];
				
	ECTrainigRaceRecord *record = [[ECTrainigRaceRecord alloc] initRecordAtTrack:trackName
																	  onRaceDate:raceDate
																   forRaceNumber:raceNumber
																	 inRaceClass:raceClass
																  atRaceDiatance:raceDx
																 withWinningPost:results.winningPost
														andEntryNamesByPostArray:namesByPostArray
															   resultingInPayout:payouts];
				
	return record;
}

- (void)useResultLineArray:(NSArray*)tokens
	toGetValueForEntryName:(NSString**)entryNameString
			  postPosition:(NSUInteger*)entryPostPosition
			  andFinishPosition:(NSUInteger*)entryFinishPosition
{
	/* result line EXAMPLE:
	
	Backwood Ethel   62½ 1 1 1 3  1 3  1 5     31.05 *0.80 Increasing Lead-inside
	Hallo See Me     63½ 2 2 2    2    2 5     31.42 8.30  Evenly To Place-midtrk
	...
	
	*/
	
	NSMutableString *entryName	= [NSMutableString new];
	NSUInteger finishPosition	= 0;
	NSUInteger index			= 0;
	
	for(; index < tokens.count; index++)
	{
		NSString *word = [tokens objectAtIndex:index];
			
		if([word doubleValue] > 0.0)
		{
			*entryNameString = entryName;
			break;
		}
		
		if(index > 0)	// add a " " character after initial character
		{
			[entryName appendString:@" "];
		}
		
		[entryName appendString:word];
	}
	
	// post position is always 2 words after name ends
	index++;
	NSUInteger post		= [[tokens objectAtIndex:index] integerValue];
	*entryPostPosition	= post;
	
	// finish position is usually 4 words later
	NSUInteger finishPositionIndex = index + 4;

	// if this entry is in first (at first turn) add word for placesInLead
	NSUInteger placeAtFirstTurn = [[tokens objectAtIndex:++index] integerValue];
	
	if(placeAtFirstTurn == 1)
	{
		finishPositionIndex++;
		index++;
	}
	
	// if this entry is in first (at top of stretch)  add word for placesInLead
	
	NSUInteger placeAtTopOfStretch = [[tokens objectAtIndex:index + 1] integerValue];
	
	if(placeAtTopOfStretch == 1)
	{
		finishPositionIndex++;
	}
	
	finishPosition			= [[tokens objectAtIndex:finishPositionIndex] integerValue];
	*entryFinishPosition	= finishPosition;
}

- (ECRacePayouts*)getPayoutsUsingArray:(NSArray*)resultFileLineByLine
						  atLineNumber:(NSUInteger)lineNumber
{
	// FIX: initially only concerned with win Payout
	//		eventually get all payouts properly
	ECRacePayouts *racePayout = [[ECRacePayouts alloc] init];
	
	NSString *payoutLine	= [resultFileLineByLine objectAtIndex:lineNumber];
	NSString *modifiedLine	= [self removeExtraSpacesFromString:payoutLine];
	NSArray *tokens			= [modifiedLine componentsSeparatedByString:@" "];
	
	// since word[0] is postValue start search at word[1]
	for(NSUInteger index = 1; index < tokens.count; index++)
	{
		NSString *word = [tokens objectAtIndex:index];
		
		if([word doubleValue] > 0.0)
		{
			if([NSString isThisWinPayoutString:word] == YES)
			{
				double winPayout		= [word doubleValue];
				racePayout.winPayout	= winPayout;
				break;
			}
		}
	}
	
	return racePayout;
}


- (NSString*)getMmSubstringFromSpelledMonth:(NSString*)spelledMonthString
{
	NSString *mmSubstring			= nil;
	NSString *spelledMonthSubstring = [spelledMonthString substringToIndex:3];
	
	if([spelledMonthSubstring isEqualToString:@"Jan"])
	{
		mmSubstring = @"01";
	}
	else if([spelledMonthSubstring isEqualToString:@"Feb"])
	{
		mmSubstring = @"02";
	}
	else if([spelledMonthSubstring isEqualToString:@"Mar"])
	{
		mmSubstring = @"03";
	}
	else if([spelledMonthSubstring isEqualToString:@"Apr"])
	{
		mmSubstring = @"04";
	}
	else if([spelledMonthString isEqualToString:@"May"])
	{
		mmSubstring = @"05";
	}
	else if([spelledMonthSubstring isEqualToString:@"Jun"])
	{
		mmSubstring = @"06";
	}
	else if([spelledMonthSubstring isEqualToString:@"Jul"])
	{
		mmSubstring = @"07";
	}
	else if([spelledMonthSubstring isEqualToString:@"Aug"])
	{
		mmSubstring = @"08";
	}
	else if([spelledMonthSubstring isEqualToString:@"Sep"])
	{
		mmSubstring = @"09";
	}
	else if([spelledMonthSubstring isEqualToString:@"Oct"])
	{
		mmSubstring = @"10";
	}
	else if([spelledMonthSubstring isEqualToString:@"Nov"])
	{
		mmSubstring = @"11";
	}
	else if([spelledMonthSubstring isEqualToString:@"Dec"])
	{
		mmSubstring = @"12";
	}

	return mmSubstring;
}

- (NSString*)getRaceDistanceStringFromString:(NSString*)fileNameString
{
	NSUInteger index		= 0;
	NSString *raceDxString	= @"Bad File";
	
	for(index = 0; index < fileNameString.length; index++)
	{
		if([fileNameString characterAtIndex:index] == '-')
		{
			break;
		}
	}
	
	if(index < fileNameString.length - 2)
	{
		raceDxString = [fileNameString substringFromIndex:index + 1];
	}
	
	return raceDxString;
}

- (NSUInteger)getRaceDxFromString:(NSString*)raceNumberString
{
	NSString *prefix				= [raceNumberString substringToIndex:4];
	NSString *stringWithoutParens	= [prefix substringFromIndex:1];
	NSUInteger distanceOfRaceinFeet = [stringWithoutParens integerValue];
	
	return distanceOfRaceinFeet;
}

- (NSString*)removeExtraSpacesFromString:(NSString*)originalString
{
    NSString *returnString = nil;
    
    while ([originalString rangeOfString:@"  "].location != NSNotFound)
	{
        originalString = [originalString stringByReplacingOccurrencesOfString:@"  "
                                                                   withString:@" "];
	}
    
     NSString *strippedString = [NSString stringWithString:originalString];
	
	// now strip last 2 chars if they are " \r"
	if([strippedString characterAtIndex:strippedString.length-1] == '\r')
	{
		returnString = [strippedString substringToIndex:strippedString.length - 2];
	}
	else
	{
		returnString = strippedString;
	}
    
    return returnString;
}

- (NSUInteger)getIndexOfFirstDateToken:(NSArray*)lineZeroTokens
{
	NSUInteger index = 0;
	
	for(index = 0; index < lineZeroTokens.count; index++)
	{
		NSString *word = [lineZeroTokens objectAtIndex:index];
		
		if([word isEqualToString:@"Monday"]		||
			[word isEqualToString:@"Tuesday"]	||
			[word isEqualToString:@"Wednesday"] ||
			[word isEqualToString:@"Thursday"]	||
			[word isEqualToString:@"Friday"]	||
			[word isEqualToString:@"Saturday"]	||
			[word isEqualToString:@"Sunday"])
		{
			break;
		}
	}
	
	return index;
}


- (NSArray*)getWinPredictionsFromPopulation:(ECPopulation*)population
									forRace:(ECTrainigRaceRecord*)trainingRaceRecord
{
	NSArray *winPredictionsArray = nil;
	
	// create a 2D array to track each handicappers 8 entrys (automatically initialized to zero)
	NSMutableArray *strengthFieldsArray = [NSMutableArray new];
	NSUInteger startIndex				= self.populationSize - self.trainingPopSize;
	
	// iterate through each entry accumulating values for population
	for(NSString *entryName in trainingRaceRecord.postEntries)
	{
		ECEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"ECEntry"
													   inManagedObjectContext:MOC];
		entry.name = entryName;
		
		// get past Lines from subdirectory of :/Users/ronjurincie/Desktop/Greyhound Central/Modified Dog Histories/
		
		// obtain subdirectory name from first char in entryName
		NSString *parentDirectoryName	= @"/Users/ronjurincie/Desktop/Greyhound Central/Modified Dog Histories";
		NSString *sudDirectoryName		= [entryName substringToIndex:1];
		NSString *pastLinesFilePath		= [NSString stringWithFormat:@"%@/%@/%@", parentDirectoryName, sudDirectoryName, entryName];
		NSError *error;
	
		NSString *pastLinesFileContents	= [NSString stringWithContentsOfFile:pastLinesFilePath
																	encoding:NSStringEncodingConversionAllowLossy
																	   error:&error];
		NSArray *pastRaceLinesForEntry	= [self getPastLinesForEntryFromPastLinesText:pastLinesFileContents];
		
		for(ECPastLineRecord *pastLine in pastRaceLinesForEntry)
		{
			/***********************************
			
				Multiprocess Here
				devoting 1 core per Handicapper
				
			************************************/
			
			for(NSUInteger index = startIndex; index < self.populationSize; index++)
			{
			
			}

		}
		
	}

	winPredictionsArray = [self simulateRace:trainingRaceRecord
							   forPopulation:population
						  withStrengthFields:strengthFieldsArray];
		
	// NOTE: wait here until all members have made their predictions

	return winPredictionsArray;
}

- (NSArray*)getPastLinesForEntryFromPastLinesText:(NSString*)pastLinesFileConents
{
	// create a mutable array to fill with ECPastLineRecord objects
	NSMutableArray *pastLineArray = [NSMutableArray new];

	// create an array by splitting pastLinesText string on '\n' chars
	NSArray *pastLinesFileLineByLine = [pastLinesFileConents componentsSeparatedByString:@"\n"];
	
	// Note: ther are 24 or 25 lines per record
	//			Depending on whether there is a "Replay" suffix to testLineNumber string
	
	NSUInteger lineNumber		= 0;
	NSUInteger testLineNumber	= 22;
	NSRange subRange;
	NSUInteger avoidEOFBuffer	= 5;
	
	while (lineNumber < pastLinesFileLineByLine.count - avoidEOFBuffer)
	{
		// create a new pastLineSubArray
		NSString *testString = [pastLinesFileLineByLine objectAtIndex:testLineNumber];
	
		if([testString hasSuffix:@"Replay"])
		{
			subRange	= NSMakeRange(lineNumber, 24);
			lineNumber	+= 25;
		}
		else
		{
			subRange	= NSMakeRange(lineNumber, 23);
			lineNumber	+= 24;
		}
		
		// reset testLineNumber
		testLineNumber						= lineNumber + 22;
		NSArray *subArray					= [pastLinesFileLineByLine subarrayWithRange:subRange];
		ECPastLineRecord *pastLineRecord	= [self getPastLineRecordFromSubArray:subArray];
	
		[pastLineArray addObject:pastLineRecord];
	}
	
	return pastLineArray;
}

- (ECPastLineRecord*)getPastLineRecordFromSubArray:(NSArray*)pastLineArray
 {
	ECPastLineRecord *pastLineRecord = [ECPastLineRecord new];
	
	// get date and matinee? from line[0]
	NSString *lineZero		= [pastLineArray objectAtIndex:0];
	NSString *datePrefix	= [lineZero substringToIndex:9];
	NSString *dateSuffix	= @" 10:00:00 +0600";
	NSString *dateString	= [NSString stringWithFormat:@"%@%@", datePrefix, dateSuffix];
	NSDate *pastLineDate	= [NSDate dateWithString:dateString];
	NSString *tempString	= [lineZero substringFromIndex:10];
	
	pastLineRecord.isMatinee		= [tempString characterAtIndex:0] == 'm' ? YES:NO;
	pastLineRecord.foundTrouble		= NO;
	pastLineRecord.wasScratched		= NO;
	pastLineRecord.didNotFinish		= NO;
	pastLineRecord.ranInside		= NO;
		pastLineRecord.ranOutside	= NO;
 	pastLineRecord.raceDate			= pastLineDate;
	pastLineRecord.trackName		= [pastLineArray objectAtIndex:1];
	pastLineRecord.raceDistance		= [[pastLineArray objectAtIndex:2] integerValue];
	pastLineRecord.raceClass		= [pastLineArray objectAtIndex:17];
	pastLineRecord.trackConditions	= [pastLineArray objectAtIndex:3];
	pastLineRecord.winningTime		= [[pastLineArray objectAtIndex:4] doubleValue];
	pastLineRecord.weight			= [[pastLineArray objectAtIndex:5] integerValue];
	pastLineRecord.postPosition		= [[pastLineArray objectAtIndex:6] integerValue];
	pastLineRecord.comments			= [pastLineArray objectAtIndex:16];
	pastLineRecord.numberEntries	= [[pastLineArray objectAtIndex:21] integerValue];
	
	pastLineRecord.breakPosition = [[pastLineArray objectAtIndex:7] integerValue];
	
	if(pastLineRecord.breakPosition == 0)
	{
		pastLineRecord.didNotFinish = YES;
	}
	else
	{
		pastLineRecord.firstTurnPosition = [[pastLineArray objectAtIndex:8] integerValue];
		
		if(pastLineRecord.firstTurnPosition == 0)
		{
			pastLineRecord.didNotFinish = YES;
		}
		else
		{
			pastLineRecord.lengthsLeadFirstTurn	= [[pastLineArray objectAtIndex:9] integerValue];
			
			if(pastLineRecord.firstTurnPosition != 1)
			{
				pastLineRecord.lengthsLeadFirstTurn *= -1;  // not in lead then this must be a negative value
			}
			
			pastLineRecord.deltaPosition1		= pastLineRecord.breakPosition - pastLineRecord.firstTurnPosition;
			pastLineRecord.topOfStretchPosition	= [[pastLineArray objectAtIndex:10] integerValue];
			
			if(pastLineRecord.topOfStretchPosition == 0)
			{
				pastLineRecord.didNotFinish = YES;
			}
			else
			{
				pastLineRecord.lengthsLeadTopOfStretch	= [[pastLineArray objectAtIndex:11] integerValue];
				
				if(pastLineRecord.topOfStretchPosition != 1)
				{
					pastLineRecord.lengthsLeadTopOfStretch *= -1;  // not in lead then this must be a negative value
				}
				
				pastLineRecord.deltaLengths1	= pastLineRecord.lengthsLeadFirstTurn - pastLineRecord.lengthsLeadTopOfStretch;
				pastLineRecord.deltaPosition2	= pastLineRecord.firstTurnPosition - pastLineRecord.topOfStretchPosition;
				pastLineRecord.finishPosition	= [[pastLineArray objectAtIndex:12] integerValue];

				if(pastLineRecord.finishPosition == 0)
				{
					pastLineRecord.didNotFinish = YES;
				}
				else
				{
					pastLineRecord.lengthsLeadFinish	= [[pastLineArray objectAtIndex:13] integerValue];
					
					if(pastLineRecord.finishPosition != 1)
					{
						pastLineRecord.lengthsLeadFinish *= -1;  // not in lead then this must be a negative value
					}
					
					pastLineRecord.entryTime		= [[pastLineArray objectAtIndex:14] doubleValue];
					pastLineRecord.winOdds			= [[pastLineArray objectAtIndex:15] doubleValue];
					pastLineRecord.deltaPosition3	= pastLineRecord.topOfStretchPosition - pastLineRecord.finishPosition;
					pastLineRecord.deltaLengths2	= pastLineRecord.lengthsLeadTopOfStretch - pastLineRecord.lengthsLeadFinish;
				}
			}
		}
	}
	
	[self processCommentsForPastLineRecord:pastLineRecord];
	
	return pastLineRecord;
}

- (void)processCommentsForPastLineRecord:(ECPastLineRecord*)pastLineRecord
{
	// FIX: print up list of unique words used in comments field for every dogs pastLines
	//		use list to compile more complete list of keyWords below

	// Note: MANY times words are combined with a hyphen:
	// e.g.: Erly-caught-plc, Stretch-in, Improvement-rail
	// splitting these words to create multiple words to check
	
	// create arrays here of key words we are looking for in comments string
	NSArray *collisionWords = [NSArray arrayWithObjects:@"fell", @"trouble", @"collided", @"bumped", @"hit", @"blocked",
															@"blocke", @"crowded", @"bounced", @"jammed", @"knocked", @"shut", @"shuffled", nil];
	NSArray *indsideWords	= [NSArray arrayWithObjects:@"rail", @"inside", @"insid", @"in", @"ins", nil];
	NSArray *outsideWords	= [NSArray arrayWithObjects:@"outside", @"out", @"wide", @"wd", nil];
	NSArray *midtrackWords	= [NSArray arrayWithObjects:@"midtrack", @"mid", @"midt", nil];
	NSArray *scratchedWords	= [NSArray arrayWithObjects:@"scratched", @"scr", nil];
	NSArray *dnfWords		= [NSArray arrayWithObjects:@"fell", @"dnf", nil];

	// Note: MANY times words are combined with a hyphen:
	// e.g.: Erly-caught-plc, Stretch-in, Improvement-rail
	// replace @"-" sttrings with @" " strings
	// split line on @" "
	
	NSString *tokens = [pastLineRecord.comments stringByReplacingOccurrencesOfString:@"-"
																		  withString:@" "];
	NSArray *words = [tokens componentsSeparatedByString:@" "];
	
	for(NSString *word in words)
	{
		NSString *lowerCaseWord = [word lowercaseString];
	
		if([collisionWords containsObject:lowerCaseWord])
		{
			pastLineRecord.foundTrouble = YES;
		}
		
		if([indsideWords containsObject:lowerCaseWord])
		{
			pastLineRecord.ranInside = YES;
		}
	
		if([midtrackWords containsObject:lowerCaseWord])
		{
			pastLineRecord.ranMidtrack = YES;
		}
		
		if([outsideWords containsObject:lowerCaseWord])
		{
			pastLineRecord.ranOutside = YES;
		}
	
		if([scratchedWords containsObject:lowerCaseWord])
		{
			pastLineRecord.wasScratched = YES;
		}
	
		if([dnfWords containsObject:lowerCaseWord])
		{
			pastLineRecord.didNotFinish = YES;
		}
	}
}


- (NSArray*)simulateRace:(ECTrainigRaceRecord*)trainingRaceRecord
		   forPopulation:(ECPopulation*)population
	  withStrengthFields:(NSArray*)strengthFieldsArray
{
	NSMutableArray *winPostPredictionsArray = [NSMutableArray new];
	
	/***********************************
	 
	 Multiprocess Here: Devoting 1 core per Handicapper
	 
	 ************************************/
	 
	 // iterate through population
	NSUInteger startIndex	= 0;
	NSUInteger endIndex		= self.populationSize;
	
	if(self.trainingPopSize != self.populationSize)
	{
		startIndex = self.trainingPopSize;
	}
	
	for(NSUInteger index = startIndex; index < endIndex; index++)
	{
		NSArray *thisHandicappersStrengthFields = [strengthFieldsArray objectAtIndex:index];

		NSInteger predictedWinningPost = [self simulateRace:trainingRaceRecord
										 withEntryStrengths:thisHandicappersStrengthFields];

		[winPostPredictionsArray addObject:[NSNumber numberWithUnsignedInteger:predictedWinningPost]];
	}

	return winPostPredictionsArray;
}

- (NSUInteger)simulateRace:(ECTrainigRaceRecord*)trainingRaceRecord
		withEntryStrengths:(NSArray*)entryStrengths
{
		NSUInteger postOfPredictedWinner = 0;
		
		return postOfPredictedWinner;
}

                       
- (void)createNextGenerationForPopulation:(ECPopulation*)testPopulation
{
   	// increment generation counter
	NSUInteger plusOneInt				= [self.population.generationNumber unsignedIntegerValue] + 1;
	NSNumber *incrementedGenNumber		= [NSNumber numberWithUnsignedInteger:plusOneInt];
	self.population.generationNumber	= incrementedGenNumber;
	
	// rerank population
	[self rankPopulationVia:self.rankedPopulation];
	
	// remove and release worst performing half of pop
	// and replace them with children crossed over by best performing half
	[self replaceBottomHalfOfPopulationWithNewChildren];
	
	// now mutate
	[self mutateChildrenForPopulation:self.population];
}

- (void)rankPopulationVia:(NSMutableArray*)sortingArray
{
	// sort population
	// sort rankedPopulation based on [numberOfWinBetWinners / numberWinBets] for now...
	NSSortDescriptor *discript	= [[NSSortDescriptor alloc] initWithKey:@"numberOfWinBetWinners"
															 ascending:YES];
	NSArray *descriptorArray	= [NSArray arrayWithObjects:discript, nil];
	NSArray *rankedArray		= [self.rankedPopulation sortedArrayUsingDescriptors:descriptorArray];
	
	[sortingArray removeAllObjects];
	[sortingArray addObjectsFromArray:rankedArray];
}

- (void)replaceBottomHalfOfPopulationWithNewChildren
{
	NSInteger halfwayIndex = self.populationSize / 2;

    // iterate bottom half of rankedPopulation removing all handicappers
	for(NSInteger index = self.populationSize - 1; index >= halfwayIndex; index--)
	{
		ECHandicapper *dyingHandicapper = [self.rankedPopulation objectAtIndex:index];
		
		// remove handicapper from rankedPopulationArray
		[self.rankedPopulation removeObject:dyingHandicapper];
		
		// remove dyingHandicapper managedObject from data store
		[MOC deleteObject:dyingHandicapper];
	}
	
	// create new bottom half of rankedPop by crossing over dnaTrees form remaining half of pop
	for(NSInteger index = halfwayIndex ; index < self.populationSize; index++)
	{
		ECHandicapper *newHandicapper = [self createNewHandicapperForPopulation:self.population
																  forGeneration:[self.population.generationNumber unsignedIntegerValue]];
				
		[self.rankedPopulation addObject:newHandicapper];
	}
}

- (ECHandicapper*)createNewHandicapperForPopulation:(ECPopulation*)population
									  forGeneration:(NSUInteger)birthGeneration
{
	// get 2 UNIQUE parents
	// based on selection method
	double summedFitnessForPopulation = 0.0;
	switch (kSelectionMethod)
	{
		case kSuaredFitnessSelection:
			// FIX: not implemented
			// simply skip to kLinearFitnessSelection
			
		case kLinearFitnessSelection:
		{
			for(NSUInteger popIndex = 0; popIndex <  self.populationSize / 2; popIndex++)
			{
				ECHandicapper *tempHandicapper	= [self.rankedPopulation objectAtIndex:popIndex];
				double tempFitness				= (double)[tempHandicapper.numberWinBetWinners unsignedIntegerValue] /
													(double)[tempHandicapper.numberWinBets unsignedIntegerValue];
				summedFitnessForPopulation		+= tempFitness;
			}
			
			break;
		}
		
		default:
			break;
	}
	
	NSUInteger parent1Index	= [self getParentIndexFromPopulation:self.population
										 withOverallFitnessValue:summedFitnessForPopulation];
	NSUInteger parent2Index	= parent1Index;

	while(parent2Index == parent1Index)
	{
		parent2Index = [self getParentIndexFromPopulation:self.population
								  withOverallFitnessValue:summedFitnessForPopulation];
	}
	
	ECHandicapper *parent1 = [self.rankedPopulation objectAtIndex:parent1Index];
	ECHandicapper *parent2 = [self.rankedPopulation objectAtIndex:parent2Index];
	
	ECHandicapper *newHandicapper = [NSEntityDescription insertNewObjectForEntityForName:@"Handicapper"
																inManagedObjectContext:MOC];
	
	newHandicapper.numberWinBets		= [NSNumber numberWithInteger:0];
	newHandicapper.numberWinBetWinners	= [NSNumber numberWithInteger:0];
	newHandicapper.amountBetOnWinBets	= [NSNumber numberWithDouble:0.0];
	
	NSArray *newChildsDnaTreesArray = [self createNewDnaByCrossingOverDnaFrom:parent1
																  withDnaFrom:parent2];
	
	newHandicapper.classStrengthTree				= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kClassDnaStrand]];
	newHandicapper.breakPositionStrengthTree		= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kBreakPositionDnaStrand]];
	newHandicapper.breakSpeedStrengthTree			= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kBreakSpeedDnaStrand]];
	newHandicapper.firstTurnPositionStrengthTree	= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kFirstTurnPositionDnaStrand]];
	newHandicapper.firstTurnSpeedStrengthTree		= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kFirstTurnSpeedDnaStrand]];
	newHandicapper.topOfStretchPositionStrengthTree	= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kTopOfStretchPositionDnaStrand]];
	newHandicapper.topOfStretchSpeedStrengthTree	= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kTopOfStretchSpeedDnaStrand]];
	newHandicapper.finalRaceStrengthTree			= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kFinalStrengthDnaStrand]];
	newHandicapper.earlySpeedRelevanceTree			= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kEarlySpeedRelevanceDnaStrand]];
	newHandicapper.otherRelevanceTree				= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kOtherRelevanceDnaStrand]];
		
	return newHandicapper;
}

- (NSUInteger)getParentIndexFromPopulation:(ECPopulation*)population
				   withOverallFitnessValue:(double)popsFitness
{
	// orgy type does not specify unique parent
	if(kReproductionType == kOrgyMethod)
	{
		return NOT_AN_INDEX; // orgy method does NOT require unique parents
	}

	// parents are chosen based on kReproductionType and kSelection

	NSUInteger parentIndex				= NOT_AN_INDEX;
	NSUInteger magnifiedSummedFitness	= (NSUInteger)(popsFitness * 10000);
	NSUInteger intTarget				= rand() % magnifiedSummedFitness;
	double targetValue					= (double)intTarget / 10000.0;
	double fitnessAccumulator			= 0.0;
	
	// roll through popoulation getting index for parent
	switch (kSelectionMethod)
	{
		case kSuaredFitnessSelection:
		
			// not implemented
			// so do not break - simply fall through to linearFitnessSelection
		
		case kLinearFitnessSelection:
				
			for(NSUInteger popIndex = 0; popIndex < self.populationSize / 2; popIndex++)
			{
				ECHandicapper *handicapper	= [self.rankedPopulation objectAtIndex:popIndex];
				double winningPercentage	= [handicapper.numberWinBetWinners unsignedIntegerValue] /
												[handicapper.numberWinBets doubleValue];
				fitnessAccumulator			+= winningPercentage;
			
				if(targetValue < fitnessAccumulator)
				{
					parentIndex = popIndex;
					break;
				}
			}
			
			break;
		
		default:
			break;
	}
	
	return parentIndex;
}

- (void)mutateChildrenForPopulation:(ECPopulation*)pop
{
    NSLog(@"mutateChildrenForPopulation: called");
	
	for(NSUInteger popIndex = self.populationSize / 2; popIndex < self.populationSize; popIndex++)
	{
		// mutate selected members
		double threshold = (double) (rand() % 100) / 100.0;
		
		if(threshold < [self.population.mutationRate doubleValue])
		{
			// mutate this member
			[self mutateHandicappersDnaTrees:[self.rankedPopulation objectAtIndex:popIndex]];
		}
	}
}

- (void)mutateHandicappersDnaTrees:(ECHandicapper*)futureMutant
{
	// FIX: implement
}


- (NSArray*)createNewDnaByCrossingOverDnaFrom:(ECHandicapper*)parent1
								  withDnaFrom:(ECHandicapper*)parent2
{
    NSUInteger parent1Index     = [parent1.rank unsignedIntegerValue];
    NSUInteger parent2Index     = [parent2.rank unsignedIntegerValue];
	NSUInteger parent1Level		= 0;
    NSUInteger traverseMoves	= 0;
	
    BOOL grandparent1UsingRightChild = YES;
	
	NSMutableArray*childDnaArray	= [NSMutableArray new];
    ECTree *parent1Root			= nil;
    ECTree *parent2Root			= nil;
	
	ECTree *crossover1			= nil;
    ECTree *crossover2			= nil;
    ECTree *crossover1Parent		= nil;
	
	for(NSUInteger strandNumber = 0; strandNumber < kNumberDnaStrands; strandNumber++)
	{
        // identify motherCrossoverNode
        traverseMoves = rand() % ([self.population.maxTreeDepth unsignedIntegerValue] * 2);
       
         if(traverseMoves < 2)
        {
            traverseMoves = 2;
        }

        parent1Level	= 0;
        parent1Root     = self.workingPopulationDna[parent1Index][strandNumber];
		parent2Root		= self.workingPopulationDna[parent2Index][strandNumber];
		
        // randomly traverse parent1 tree to find crossover node and parent and direction
		
        // identifing parent1 crossover node
        crossover1Parent	= nil;
		crossover1		= parent1Root;
		
        for(NSUInteger moveNumber = 0; moveNumber < traverseMoves; moveNumber++)
        {
			parent1Level++;

            if(crossover1.rightBranch && rand() % 2)
            {
                crossover1Parent			= crossover1;
                crossover1					= crossover1.rightBranch;
				grandparent1UsingRightChild = YES;
            }
            else if(crossover1.leftBranch)
            {
                crossover1Parent			= crossover1;
                crossover1					= crossover1.leftBranch;
				grandparent1UsingRightChild = NO;

            }
            else	// reached a leaf --> goto root
            {
				grandparent1UsingRightChild = NO;
                parent1Level		= 0;
                crossover1			= parent1Root;
                crossover1Parent	= nil;
            }
			
			// avoid ending up at root node
			if(moveNumber == traverseMoves - 1 && crossover1 == parent1Root)
			{
				traverseMoves++;
			}
        }
    
		// when ending up back at root move down a level
        if(nil == crossover1 || crossover1 == parent1Root)
        {
            NSLog(@"crossover error alpha1");
            exit(1);
        }
        
        // identify parent2 crossover node
		crossover2 = [self getNodeFromChildAtLevel:parent1Level
										 usingTree:parent2Root];
				
		if(nil == crossover2)
		{
			NSLog(@"error finding parent2 grandparent node");
			exit(1);
		}
	
		for(NSUInteger dnaStrandNumber = 0; dnaStrandNumber < kNumberDnaStrands; dnaStrandNumber++)
		{
			[childDnaArray addObject:[self copyTree:parent1Root
									  replacingNode:crossover1
									  withNode:crossover2]];
		}
	}
	
	return childDnaArray;
}

- (ECTree*)copyTree:parentRoot
		replacingNode:replaceThisNode
			 withNode:replacementNode
{
	if(nil == parentRoot)
	{
		return nil;
	}
	
	ECTree *newTree   = nil;
    ECTree *tempNode  = parentRoot;
	
	if(tempNode.functionPtr &&
       tempNode.leafVariableIndex == NOT_AN_INDEX &&
       tempNode.leafConstant == NOT_A_CONSTANT)
	{
        newTree = [[ECTree alloc] initWithFunctionPointerIndex:tempNode.functionIndex];
		
		// traverse left branch first
		if(tempNode.leftBranch == replaceThisNode)
		{
			newTree.leftBranch = [self copyTree:replacementNode
								  replacingNode:nil
									   withNode:nil];
		}
		else
		{
			newTree.leftBranch = [self copyTree:tempNode.leftBranch
								  replacingNode:replaceThisNode
									   withNode:replacementNode];
		}
	
		// now traverse right branch
		if(tempNode.rightBranch == replaceThisNode)
		{
			newTree.rightBranch = [self copyTree:replacementNode
								   replacingNode:nil
										withNode:nil];
		}
		else
		{
			newTree.rightBranch = [self copyTree:tempNode.leftBranch
								   replacingNode:replaceThisNode
										withNode:replacementNode];
		}
	}
    else if(tempNode.leafConstant != NOT_A_CONSTANT)
	{
        newTree = [[ECTree alloc] initWithConstantValue:tempNode.leafConstant];
	}
    else if(tempNode.leafVariableIndex != NOT_AN_INDEX)
	{
        newTree = [[ECTree alloc] initWithRaceVariable:tempNode.leafVariableIndex];
	}
    else
	{
        NSLog(@"copy tree error");
        exit(1);
	}
	
	return newTree;
}

- (ECTree*)getNodeFromChildAtLevel:(NSUInteger)parent1Level
						   usingTree:(ECTree*)parent2Root
{
	ECTree *crossoverFromParent2 = nil;

	return crossoverFromParent2;
}
- (double)evalTree:(ECTree*)treeNode
	usingVariables:(NSMutableArray*)dataArray
			atPost:(NSUInteger)postPosition
{
	double returnVal = 0.0;
	
	if(postPosition > kMaximumNumberEntries)
		{
		NSLog(@"eval tree post error 1");
		exit(1);
		}
	
	if(treeNode.functionPtr)
		{
		double leftBranchVal = [self evalTree:treeNode.leftBranch
							   usingVariables:dataArray
									   atPost:postPosition];
		
		if(leftBranchVal == 00000)
			{
			return 00000;
			}
		
		if(treeNode.rightBranch)
			{
			double rightBranchVal = [self evalTree:treeNode.rightBranch
									usingVariables:dataArray
											atPost:postPosition];
			
			if(leftBranchVal == 00000)
				{
				return 00000;
				}
			
			returnVal = treeNode.functionPtr(leftBranchVal, rightBranchVal);
			}
		else
			{
			returnVal = treeNode.functionPtr(leftBranchVal);
			}
		}
	else if(treeNode.leafConstant != NOT_A_CONSTANT)
		{
		returnVal = treeNode.leafConstant;
		}
	else
		{
		// get value for this race variable
		if(treeNode.leafVariableIndex == NOT_AN_INDEX)
			{
			NSLog(@"eval tree error alpha");
			exit(1);
			}
		else
			{
			returnVal = [self getLeafVariableValueForIndex:treeNode.leafVariableIndex
										fromPastLineRecord:nil];
			}
		}
	
	if(returnVal == 00000)
		{
		return 00000;
		}
	
	return returnVal;
}


- (double)getLeafVariableValueForIndex:(NSUInteger)leafVariableIndex
					fromPastLineRecord:(ECPastLineRecord*)pastLineRecord
{
	double returnValue = 0.0;
	
	return returnValue;
}



- (void)replaceOldDnaStringsForChildWithIndex:(NSUInteger)popIndex
{
    // Since dnaTrees are stored as strings in coreData data model
    // need to copy just edited trees to appropriate strings
    ECHandicapper *changedHandicapper = nil;
    
	changedHandicapper.classStrengthTree				= self.workingPopulationDna[popIndex][0];
    changedHandicapper.breakPositionStrengthTree		= self.workingPopulationDna[popIndex][1];
    changedHandicapper.breakSpeedStrengthTree           = self.workingPopulationDna[popIndex][2];
    changedHandicapper.firstTurnPositionStrengthTree	= self.workingPopulationDna[popIndex][3];
    changedHandicapper.firstTurnSpeedStrengthTree		= self.workingPopulationDna[popIndex][4];
    changedHandicapper.topOfStretchPositionStrengthTree	= self.workingPopulationDna[popIndex][5];
    changedHandicapper.topOfStretchSpeedStrengthTree	= self.workingPopulationDna[popIndex][6];
	changedHandicapper.finalRaceStrengthTree			= self.workingPopulationDna[popIndex][7];
    changedHandicapper.earlySpeedRelevanceTree			= self.workingPopulationDna[popIndex][8];
    changedHandicapper.otherRelevanceTree				= self.workingPopulationDna[popIndex][9];
}


- (void)freeTree:(ECTree*)node
{
	
	if(nil == node)
	{
		return;
	}
	
	[self freeTree:node.leftBranch];
	node.leftBranch = nil;
	
	[self freeTree:node.rightBranch];
	node.rightBranch = nil;
	
	[self freeTree:node];
	node = nil;

}

- (ECTree*)copyTree:(ECTree*)parentRoot
 withoutBranch:(ECTree*)skipThisBranch
{
	ECTree *newTree   = nil;
    ECTree *tempNode  = parentRoot;
	
	if(tempNode.functionPtr &&
       tempNode.leafVariableIndex == NOT_AN_INDEX &&
       tempNode.leafConstant == NOT_A_CONSTANT)
	{
        newTree = [[ECTree alloc] initWithFunctionPointerIndex:tempNode.functionIndex];

        if(tempNode.leftBranch == skipThisBranch)
        {
            newTree.leftBranch = nil;
        }
        else
        {
            newTree.leftBranch = [self copyTree:tempNode.leftBranch
								  withoutBranch:skipThisBranch];
        }
        
        if(tempNode.rightBranch)
        {
            if(tempNode.rightBranch == skipThisBranch)
            {
                newTree.rightBranch = nil;
            }
            else
            {
                newTree.rightBranch = [self copyTree:tempNode.rightBranch
										withoutBranch:skipThisBranch];
            }
        }
    }
    else if(tempNode.leafConstant != NOT_A_CONSTANT)
    {
        newTree = [[ECTree alloc] initWithConstantValue:tempNode.leafConstant];
    }
    else if(tempNode.leafVariableIndex != NOT_AN_INDEX)
    {
        newTree = [[ECTree alloc] initWithRaceVariable:tempNode.leafVariableIndex];
    }
    else
    {
        NSLog(@"copy tree error");
        exit(1);
    }
	
	return newTree;
}


- (NSMutableArray*)createNewHandicappers
{
    NSMutableSet *handicappersSet	= [NSMutableSet new];
    NSArray *immutableArray			= nil;
	
    // create initial population
    for(int popIndex = 0; popIndex < self.populationSize; popIndex++)
    {
        ECHandicapper *newbie = [NSEntityDescription insertNewObjectForEntityForName:@"IndividualHandicapper"
                                                            inManagedObjectContext: MOC];
		
		NSLog(@"Population Index:%i:", popIndex);
    
        // iterate through dnaStrands
        for(int strandNumber = 0; strandNumber < kNumberDnaStrands; strandNumber++)
        {
            // iterate through dnaStrands
            int rootLevel = 0;
        
			// since these relevance trees have fewer variables
			// make these dnaTrees shallower by starting rootLevel higher up
            if(strandNumber == 6)
            {
                rootLevel = 1;
            }
            else if(strandNumber == 7)
            {
                rootLevel = 2;
            }
            
            // don't worry about trees, will rebuild trees later from the strings below
            NSString *dnaString = [self saveTreeToString:[self createTreeForStrand:strandNumber
                                                                           atLevel:rootLevel]];
            switch (strandNumber)
            {
                case kClassDnaStrand:
                    newbie.classStrengthTree = dnaString;
                    break;
                    
                case kBreakPositionDnaStrand:
                    newbie.breakPositionStrengthTree = dnaString;
                    break;
                    
                case kBreakSpeedDnaStrand:
                    newbie.breakSpeedStrengthTree = dnaString;
                    break;
                    
                case kFirstTurnPositionDnaStrand:
                    newbie.firstTurnPositionStrengthTree = dnaString;
                    break;
                    
                case kFirstTurnSpeedDnaStrand:
                    newbie.firstTurnSpeedStrengthTree = dnaString;
                    break;
                    
                case kTopOfStretchPositionDnaStrand:
                    newbie.topOfStretchPositionStrengthTree = dnaString;
                    break;
                    
                case kTopOfStretchSpeedDnaStrand:
                    newbie.topOfStretchSpeedStrengthTree = dnaString;
                    break;
				
                case kFinalStrengthDnaStrand:
					newbie.finalRaceStrengthTree = dnaString;
					break;
				
                case kEarlySpeedRelevanceDnaStrand:
                    newbie.earlySpeedRelevanceTree = dnaString;
                    break;
				
                case kOtherRelevanceDnaStrand:
					newbie.otherRelevanceTree = dnaString;
					break;
				
                default:
                    break;
            }
            
            NSLog(@"%i: %@", popIndex, dnaString);
        }
        
        newbie.birthGeneration  = self.population.generationNumber;
        newbie.rank				= [NSNumber numberWithInteger:popIndex];
        
        [handicappersSet addObject:newbie];
    }
    
    [self.population addIndividualHandicappers:[handicappersSet copy]];
	
	return [immutableArray mutableCopy];
}

- (ECTree*)createTreeForStrand:(NSUInteger)dnaStrand
                         atLevel:(NSUInteger)level
{
	// tree is made of TreeNodes
	// as we get deeper into the tree increase probability of leaf node
    level++;
    
    ECTree *newNode   = nil;
	NSUInteger nodeType = [self getTreeNodeTypeAtLevel:level];
    
    switch (nodeType)
    {
        case kFunctionNode:
        {
            NSUInteger functionNumber = rand() % kNumberFunctions;
            
            // FIX: for now do NOT use quadratic nodes
            // make 9% of function nodes quadratic Iff they are low enough in tree
            // if(rand() % 11 == 10 && level < [[self.population maxTreeDepth] unsignedIntegerValue] - 2)
            if(0)
            {
                newNode = [self getQuadraticNodeAtLevel:level
                                              forStrand:dnaStrand];
            }
            else
            {
                newNode = [[ECTree alloc] initWithFunctionPointerIndex:functionNumber];
            }
            
            newNode.rightBranch  = nil;
            newNode.leftBranch   = nil;
            
            if(functionNumber < kNumberTwoArgFuncs)
            {
                newNode.rightBranch = [self createTreeForStrand:dnaStrand
														atLevel:level];
            }
            
            // Always make left child
            newNode.leftBranch = [self createTreeForStrand:dnaStrand
												   atLevel:level];
            
            break;
        }
            
        case kVariableNode:
        {
            NSUInteger arrayIndex   = [self getPastLineVariableForDnaStrand:dnaStrand];
            newNode                 = [[ECTree alloc] initWithRaceVariable:arrayIndex];
            
            break;
        }
        case kConstantNode:
        {
            double c    = getRand(kRandomRange, kRandomGranularity);
            newNode     = [[ECTree alloc] initWithConstantValue:c];
            
            break;
        }
            
        case kUndefinedNode:
        {
            NSLog(@"Node definition error");
            
            break;
        }
    }
    
	return newNode;
}


- (NSUInteger)getTreeNodeTypeAtLevel:(NSUInteger)level
{
    NSUInteger nodeType = kUndefinedNode;
    
    if(level < [self.population.minTreeDepth integerValue])
	{
		nodeType = kFunctionNode;
	}
	else if(level == [self.population.maxTreeDepth integerValue])
	{
		// MUST be a leaf node
		if(rand() % 2)
		{
			nodeType = kConstantNode;
		}
		else
		{
			nodeType = kVariableNode;
		}
	}
	else
    {
        if(rand() % 3 < 2)  // 2/3 are functions
        {
            nodeType = kFunctionNode;
        }
        else
        {
            // other 1/3 split evenly between constants and variables
            if(rand() % 2)
            {
                nodeType = kConstantNode;
            }
            else
            {
                nodeType = kVariableNode;
            }
        }
    }
    
    return nodeType;
}

- (NSString*)saveTreeToString:(ECTree*)tree
{
    NSMutableString *treeString = [NSMutableString new];

    if(tree.functionPtr)
    {
        // append funcs name followed by the '('character
        [treeString appendString:tree.functionName];
        [treeString appendString:@"("];
        
        [treeString appendString:[self saveTreeToString:tree.leftBranch]];
        
        if(nil != tree.rightBranch)
        {
            [treeString appendString:@","];
            [treeString appendString:[self saveTreeToString:tree.rightBranch]];
        }
        
        [treeString appendString:@")"];
        
    }
    else if(tree.leafVariableIndex != NOT_AN_INDEX)
    {
        // append index in brackets[]
        [treeString appendString:[NSString stringWithFormat:@"%ld", (unsigned long)tree.leafVariableIndex]];
    }
    else
    {
        if(tree.leafConstant == NOT_A_CONSTANT)
        {
            NSLog(@"save tree error");
        }
        
        // append constant value
        NSString *constantAsString = [NSString stringWithFormat:@"%Lf", tree.leafConstant];
        
        [treeString appendString:constantAsString];
    }
    
    return treeString;
}

- (ECTree*)recoverTreeFromString:(NSString*)inString
{
    ECTree *newTree			= nil;
    NSString *newString     = nil;
    NSString *newString2    = nil;
    NSString *token         = nil;
    NSString *arg1String    = nil;
    NSString *arg2String    = nil;
    NSUInteger commaIndex   = 0;
    NSUInteger parenIndex   = 0;
    NSUInteger numArgs      = 0;
    char letter             = '$';
    BOOL gotFunction        = FALSE;
    NSUInteger i            = 0;
	   
	while(i < [inString length])
	{
		letter = [inString characterAtIndex:i++];
		
		if(letter == '(')
		{
			gotFunction = TRUE;
			token       = [inString substringToIndex:i-1];
			break;
		}
	}
	
	if(gotFunction)
	{
        newTree.functionName = token;
        
		if([token isEqualToString:@"add"])
		{
			newTree = [[ECTree alloc] initWithFunctionPointerIndex:kAdditionIndex];
			numArgs = 2;
		}
		else if([token isEqualToString:@"subtract"])
		{
			newTree = [[ECTree alloc] initWithFunctionPointerIndex:kSubtractionIndex];
			numArgs = 2;
		}
		else if([token isEqualToString:@"multiply"])
		{
			newTree = [[ECTree alloc] initWithFunctionPointerIndex:kMultiplicationIndex];
			numArgs = 2;
		}
		else if([token isEqualToString:@"divide"])
		{
			newTree =[[ECTree alloc] initWithFunctionPointerIndex:kDivisionIndex];
			numArgs = 2;
		}
		else if([token isEqualToString:@"squareRoot"])
		{
			newTree = [[ECTree alloc] initWithFunctionPointerIndex:kSquareRootIndex];
			numArgs = 1;
		}
        else if([token isEqualToString:@"square"])
		{
			newTree = [[ECTree alloc] initWithFunctionPointerIndex:kSquareIndex];
			numArgs = 1;
		}
		else if([token isEqualToString:@"naturalLog"])
		{
			newTree = [[ECTree alloc] initWithFunctionPointerIndex:kNaturalLogIndex];;
			numArgs = 1;
		}
		else if([token isEqualToString:@"reciprocal"])
		{
			newTree = [[ECTree alloc] initWithFunctionPointerIndex:kReciprocalIndex];
			numArgs = 1;
		}
		else
		{
			NSLog(@"bad function name in recoverTreeFromString");
			exit(1);
		}
		
		switch(numArgs)
		{
			case 1:
				parenIndex          = [self getIndexOfClosedParen:inString];
				newString           = [inString substringToIndex:parenIndex-1];
				arg1String          = [newString substringFromIndex:i];
				newTree.leftBranch   = [self recoverTreeFromString:arg1String];
				
				break;
                
			case 2:
				parenIndex = [self getIndexOfClosedParen:inString];
				commaIndex = [self getIndexOfComma:inString];
				
				if(commaIndex == 0 || parenIndex <= commaIndex)
				{
					NSLog(@"xxx");
					exit(1);
				}
				
				newString = [inString substringToIndex:parenIndex-1];
				arg2String = [newString substringFromIndex:commaIndex];
				
				newString2 = [newString substringToIndex:commaIndex-1];
				arg1String = [newString2 substringFromIndex:i];
                
				newTree.leftBranch   = [self recoverTreeFromString:arg1String];
				newTree.rightBranch  = [self recoverTreeFromString:arg2String];
                
				break;
                
			default:
				NSLog(@"numArgs error in recoverTreeFromString");
				exit(1);
		}
	}
	else
	{
		// this token must either be an int between 1 - NUM_PAST_LINE_VARIABLES
		// or a doulbe
		if(inString.length <= 2)
		{
			newTree = [[ECTree alloc] initWithRaceVariable:[inString intValue]];
		}
		else
		{
			newTree = [[ECTree alloc] initWithConstantValue:[inString doubleValue]];
		}
	}
	
	if(newTree.functionIndex >= 0 && newTree.functionIndex < 4)
	{
		if(nil == newTree.leftBranch || nil == newTree.rightBranch)
		{
			NSLog(@"recover error 1");
			exit(1);
		}
	}
	else if(newTree.functionIndex >= 4 && newTree.functionIndex < 9)
	{
		if(nil == newTree.leftBranch || newTree.rightBranch)
		{
			NSLog(@"recover error 2");
			exit(1);
		}
	}
	else if(newTree.leafConstant == 0.0 &&
            newTree.functionIndex == -1 &&
            newTree.leafVariableIndex == -1)
	{
		NSLog(@"recover error 3");
		exit(1);
	}
	else if((nil == newTree.functionPtr || newTree.functionIndex == -1) &&
            (newTree.leftBranch || newTree.rightBranch))
	{
		
		NSLog(@"recover error 4");
		exit(1);
	}
    
    return newTree;
}

- (NSUInteger)getIndexOfComma:(NSString*)inString
{
    NSUInteger commaIndex   = 0;
    NSUInteger level        = 0;
    NSUInteger  myLength    = [inString length];
    char letter             = '$';

    while(commaIndex < myLength)
    {
        letter = [inString characterAtIndex:commaIndex++];
        
        if(letter == '(')
        {
            level++;
        }
        else if(letter == ')')
        {
            level--;
        }
        else if(letter == ',' && level == 1)
        {
            break;
        }
    }

    return commaIndex;
}

- (NSUInteger)getIndexOfClosedParen:(NSString*)inString
{
    NSUInteger closedParenIndex = 0;
    NSInteger level             = 0;
    NSInteger myLength          = [inString length];
    char letter                 = '$';

    while(closedParenIndex < myLength)
    {
        letter = [inString characterAtIndex:closedParenIndex++];
        
        if(letter == '(')
        {
            level++;
        }
        else if(letter == ')')
        {
            level--;
            
            if(level == 0)
            {
                break;
            }
            
            if(level < 0)
            {
                NSLog(@"unbalanced parenthesis in tree error 1");
                break;
            }
        }
    }

    return closedParenIndex;
}


- (NSUInteger)getPastLineVariableForDnaStrand:(NSUInteger)dnaStrand
{
    // since each dnaStrand uses a subset of all raceLine variables
    // we carefully assign appropriate indices for later dereferencing the PastLineArray
    // Here is the map of the PastLine
    
    // 0:  weight
    // 1:  race distance
    // 2:  race class
    // 3:  track name
    // 4:  track conditions
    // 5:  past race date
    // 6:  number of entries
    // 7:  post number
    // 8:  position at break
    // 9:  position turn 1
    // 10: position turn 2
    // 11: position at finish
    // 12: entry time
    // 13: lead by lengths 1
    // 14: lead by lengths 2
    // 15: lead by lengths final
    // 16: delat 1
    // 17: delta 2
    // 18: delta 3
    // 19: winning time
    // 20: comments
    
    // dna variables by strand
    //
    
	// 0: class strength
	//      2:  race class
    //      9:  winning time
    //      11: position at finish
    //      12: entry time
	
    // 1: break position strength
    //      2:  race class
    //      6:  number of entrys
    //      8:  position at break
    //      9:  winning time
    
    // 2: break speed strength
    //      2:  race class
    //      6:  number of entrys
    //      8:  position at break
    //      9:  winning time
    
    // 3: first turn position strength
    //      2:  race class
    //      8:  position at break
    //      9:  winning time
    //      13: lead by lengths 1
    //      16: delta 1
    
    // 4: first turn speed strength
    //      9:  winning time
    //      12: entry time
    //      16: delta 1
    //      17: delta 2
    //      18: delta 3
	
	// 5: top of stretch position strength
    //      2:  race class
    //      8:  position at break
    //      9:  winning time
    //      13: lead by lengths 1
    //      16: delta 1
    
    // 6: top of stretch speed strength
    //      9:  winning time
    //      12: entry time
    //      16: delta 1
    //      17: delta 2
    //      18: delta 3
 
	// 7: final Race strength
    //      9:  winning time
    //      12: entry time
    //      16: delta 1
    //      17: delta 2
    //      18: delta 3
    
    // 8: early speed relevance
    //      2:  race class
    //      5:  raceDate (used to calculate "days ago")
    //      7:  post number (used to calculate delta post)

    // 9: other relevance
    //      2:  race class
    //      5:  raceDate (used to calculate "days ago")
    
    NSUInteger pastLineVariableIndex = 999;

    switch (dnaStrand)
    {
        case 0: // break position
        {
            NSUInteger varIndex = rand() % 4;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 3;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 8;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 9;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 1: // break speed
        {
            NSUInteger varIndex = rand() % 5;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 8;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 13;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 16;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 2:  // early speed
        {
            NSUInteger varIndex = rand() % 5;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 12;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 16;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 17;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 18;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 3: // top speed
        {
            NSUInteger varIndex = rand() % 5;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 8;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 13;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 16;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 4:  // late speed
        {
            NSUInteger varIndex = rand() % 5;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 6;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 11;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 12;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
       
        case 5:  // recent class
        {
            NSUInteger varIndex = rand() % 4;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 11;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 12;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
     
        case 6:  // early speed relevance
        {
            NSUInteger varIndex = rand() % 3;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 5;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 7;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
      
        case 7:  // other relevance
        {
            NSUInteger varIndex = rand() % 2;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 5;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        default:
            break;
    }

    if(pastLineVariableIndex == 999)
    {
        NSLog(@"error in getPastLineRaceVariable");
        exit(1);
    }

    return pastLineVariableIndex;
}

// overflow, underflow and division by zero are ignored here
// to be trapped in evalTree method

double getRand(int max, int granularity)
{
    double val  = ((rand() % 10000) / 10000.0) * max;

    if(rand() % 2)
    {
        val *= -1;
    }

    return val;
}


- (ECTree*)getQuadraticNodeAtLevel:(NSUInteger)level
                           forStrand:(NSUInteger)dnaStrand
{
    // creates the form:  a(x^2) + bx + c
    //  where a, b and c are derived from independent tree branches
    //  and X is a random pastLine variable

    double x = getRand(kRandomRange, kRandomGranularity);
    level++;

    ECTree *quadTree                          = [[ECTree alloc] initWithFunctionPointerIndex:kAdditionIndex];       // add

    quadTree.leftBranch.leftBranch                = [self createTreeForStrand:dnaStrand
                                                                    atLevel:level+1];                                   // 'a' branch
    quadTree.leftBranch                          = [[ECTree alloc] initWithFunctionPointerIndex:kMultiplicationIndex]; // mult
    quadTree.leftBranch.rightBranch               = [[ECTree alloc] initWithConstantValue:x];                           // 'x'
    quadTree.leftBranch.rightBranch.leftBranch     = [[ECTree alloc] initWithFunctionPointerIndex:kSquareIndex];         // square


    quadTree.rightBranch                         = [[ECTree alloc] initWithFunctionPointerIndex:kAdditionIndex];       // add
    quadTree.rightBranch.leftBranch.leftBranch     = [self createTreeForStrand:dnaStrand
                                                                    atLevel:level+1];                                   // 'b' branch
    quadTree.rightBranch.leftBranch               = [[ECTree alloc] initWithFunctionPointerIndex:kMultiplicationIndex]; // multiply
    quadTree.rightBranch.leftBranch.rightBranch    = [[ECTree alloc] initWithConstantValue:x];                           // 'x'
    quadTree.rightBranch.rightBranch              = [self createTreeForStrand:dnaStrand
                                                                    atLevel:level];                                     // 'c' branch
    return quadTree;
}



@end
