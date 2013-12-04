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
#import "ECPopulation.h"
#import "Constants.h"
#import "ECEntry.h"
#import "ECTree.h"
#import "ECHandicapper.h"
#import "ECRaceRecord.h"
#import "ECTrainigRaceRecord.h"
#import "ECPastLineRecord.h"
#import "ECEntryStrengthFields.h"
#import "ECPostStats.h"
#import "ECTrack.h"
#import "ECFirstTurnStats.h"
#import "ECSecondTurnStats.h"
#import "NSString+ECStringValidizer.h"
#import "ECTrack.h"
#import "ECTrackStats.h"

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

- (void)updateAndSaveData
{
    
}

#pragma track statistics methods
- (NSOrderedSet*)createSetOfStatisticsForTrack:(ECTrack*)track
{
//	ECTrackStats *stats550	= [NSEntityDescription insertNewObjectForEntityForName:@"ECTrackStats"
//														   inManagedObjectContext:MOC];
//	
//	ECTrackStats *stats685	= [NSEntityDescription insertNewObjectForEntityForName:@"ECTrackStats"
//														   inManagedObjectContext:MOC];
//				
//	NSOrderedSet *statsSet	= [NSOrderedSet orderedSetWithObjects:stats550, stats685, nil];
//
	// Each of the ECTrackStats objects (550 and 685 for now) needs 3 ordered arrays of kMaximumNumberEntries
	// postStatsitics, firstTurnStatistics and secondTurnStatistics
//	NSOrderedSet *postStats550			= [NSOrderedSet new];
//	NSOrderedSet *firstTurnStats550		= [NSOrderedSet new];
//	NSOrderedSet *secondTurnStats550	= [NSOrderedSet new];
//	NSOrderedSet *postStats685			= [NSOrderedSet new];
//	NSOrderedSet *firstTurnStats685		= [NSOrderedSet new];
//	NSOrderedSet *secondTurnStats685	= [NSOrderedSet new];
//	
//	for(NSUInteger index = 0; index < kMaximumNumberEntries; index++)
//	{
//		ECPostStats *newPostStat550		= [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats"
//																		inManagedObjectContext:MOC];
//		ECFirstTurnStats *newFtStat550	= [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats"
//																		inManagedObjectContext:MOC];
//		ECSecondTurnStats *newStStat550	= [NSEntityDescription insertNewObjectForEntityForName:@"ECSecondTurnStats"
//																		inManagedObjectContext:MOC];
//		
//		ECPostStats *newPostStat685		= [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats"
//																		inManagedObjectContext:MOC];
//		ECFirstTurnStats *newFtStat685	= [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats"
//																		inManagedObjectContext:MOC];
//		ECSecondTurnStats *newStStat685	= [NSEntityDescription insertNewObjectForEntityForName:@"ECSecondTurnStats"
//																		inManagedObjectContext:MOC];
//				
//		[postStats550		insertValue:newPostStat550	atIndex:index inPropertyWithKey:nil];
//		[postStats685		insertValue:newPostStat685	atIndex:index inPropertyWithKey:nil];
//		[firstTurnStats550	insertValue:newFtStat550	atIndex:index inPropertyWithKey:nil];
//		[firstTurnStats685	insertValue:newFtStat685	atIndex:index inPropertyWithKey:nil];
//		[secondTurnStats550	insertValue:newStStat550	atIndex:index inPropertyWithKey:nil];
//		[secondTurnStats685	insertValue:newStStat685	atIndex:index inPropertyWithKey:nil];
//	}
//	
//	stats550.postStatistics			= postStats550;
//	stats550.firstTurnStatistics	= firstTurnStats550;
//	stats550.secondTurnStatistics	= secondTurnStats550;
//	stats685.postStatistics			= postStats685;
//	stats685.firstTurnStatistics	= firstTurnStats685;
//	stats685.secondTurnStatistics	= secondTurnStats685;
	
	// iterate through training data to calculate and save statistics
	NSString *afternoonFolderPath1	= @"/Users/ronjurincie/Desktop/Greyhound Central/Results/DerbyLane/Afternoon/2008";
	NSString *afternoonFolderPath2	= @"/Users/ronjurincie/Desktop/Greyhound Central/Results/DerbyLane/Afternoon/2009";
	NSString *afternoonFolderPath3	= @"/Users/ronjurincie/Desktop/Greyhound Central/Results/DerbyLane/Afternoon/2010";
	NSString *afternoonFolderPath4	= @"/Users/ronjurincie/Desktop/Greyhound Central/Results/DerbyLane/Afternoon/2011";
	NSString *afternoonFolderPath5	= @"/Users/ronjurincie/Desktop/Greyhound Central/Results/DerbyLane/Afternoon/2012";
	NSString *afternoonFolderPath6	= @"/Users/ronjurincie/Desktop/Greyhound Central/Results/DerbyLane/Afternoon/2013";
	NSString *eveningFolderPath1	= @"/Users/ronjurincie/Desktop/Greyhound Central/Results/DerbyLane/Evening/2008";
	NSString *eveningFolderPath2	= @"/Users/ronjurincie/Desktop/Greyhound Central/Results/DerbyLane/Evening/2009";
	NSString *eveningFolderPath3	= @"/Users/ronjurincie/Desktop/Greyhound Central/Results/DerbyLane/Evening/2010";
	NSString *eveningFolderPath4	= @"/Users/ronjurincie/Desktop/Greyhound Central/Results/DerbyLane/Evening/2011";
	NSString *eveningFolderPath5	= @"/Users/ronjurincie/Desktop/Greyhound Central/Results/DerbyLane/Evening/2012";
	NSString *eveningFolderPath6	= @"/Users/ronjurincie/Desktop/Greyhound Central/Results/DerbyLane/Evening/2013";
	
	NSArray *resultFolderPaths = [NSArray arrayWithObjects:afternoonFolderPath1, afternoonFolderPath2, afternoonFolderPath3,
															afternoonFolderPath4, afternoonFolderPath5, afternoonFolderPath6,
															eveningFolderPath1, eveningFolderPath2, eveningFolderPath3,
															eveningFolderPath4, eveningFolderPath5, eveningFolderPath6, nil];
	NSError *error					= nil;
	NSFileManager *localFileManager	= [[NSFileManager alloc] init];
	
	// create a 2D arrry of integers
	//		and init all to 0  (just in case)
	int statsCountrerArray[kNumberRaceDistances][kMaximumNumberEntries][kNumberStatFields];			// do not incriment point or past where entry falls
	double statsAccumulatorArray[kNumberRaceDistances][kMaximumNumberEntries][kNumberStatFields];	// accumulates values to be divided by value above to get avgs.
	
	// initiailize both arrays to 0
	for(int raceDx = 0; raceDx < kNumberRaceDistances; raceDx++)
	{
		for(int position = 0; position < kMaximumNumberEntries; position++)
		{
			for(int dataPoint = 0; dataPoint < kNumberStatFields; dataPoint++)
			{
				statsCountrerArray[raceDx][position][dataPoint] = 0;
				statsAccumulatorArray[raceDx][position][dataPoint] = 0.0;
			}
		}
	}
	
	for(NSString *directoryPath in resultFolderPaths)
	{
		NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:directoryPath];
		NSString *fileName;
		
		while(fileName = [dirEnum nextObject])
		{
			if([fileName isEqualToString:@".DS_Store"])
			{
				continue;
			}
		
			if([[localFileManager attributesOfItemAtPath:directoryPath
												   error: NULL] fileSize] == 0)
			{
				NSLog(@"deleting: %@", directoryPath);
			
				[localFileManager removeItemAtPath:directoryPath
											 error:&error];
			}
			else
			{
				NSString *filePath = [NSString stringWithFormat:@"%@/%@", directoryPath, fileName];
				
				int *counterArrayPtr = &statsCountrerArray[0][0][0];
				double *statArrayPtr = &statsAccumulatorArray[0][0][0];
				
				[self processStatsFromResultFile:filePath
							 withStatisticsArray:statArrayPtr
								 andCounterArray:counterArrayPtr];
			}
		}
	}

	return nil;
}

- (void)processStatsFromResultFile:(NSString*)resultFilePath
			   withStatisticsArray:(double*)statsAccumulatorArray
				   andCounterArray:(int*)statsCounterArray;
{
	//		1  <html>
	//		2  <head>
	//		3  <title> Rosnet,Inc - Greyhound Racing</title>
	//		4  </head>
	//		5  </head>
	//		6  <body bgcolor="#FFFFFF" text="#000000" vlink="#00FF00" link="#FFFF00">
	//		7  <font face=Arial Narrow size=3>
	//		8  <pre>
	//		9  ____________________________________________________________________________________________________________________________________
	//		10  DERBY LANE                   Wednesday Nov 05 2008 Afternoon   Race 1    Grade  C   (550)  Time: 31.19
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
	
	BOOL isThisNewRaceRecord	= NO;
	NSError *error				= nil;
	NSString *fileContents		= [NSString stringWithContentsOfFile:resultFilePath
														encoding:NSStringEncodingConversionAllowLossy
														   error:&error];
	
	NSArray *fileContentsLineByLine = [fileContents componentsSeparatedByString:@"\n"];
		
	// skip html meta lines
	NSUInteger startIndex = kNumberHtmlMetaLinesToSkip;
	
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
			isThisNewRaceRecord		= NO;
			NSString *raceInfoLine	= [fileContentsLineByLine objectAtIndex:i+1];
			NSString *modifiedLine	= [self removeExtraSpacesFromString:raceInfoLine];
			NSArray *tokens			= [modifiedLine componentsSeparatedByString:@" "];
			NSUInteger index		= 0;
		
			for(NSString *word in tokens)
			{
				if([word isEqualToString:@"Grade"])
				{
					break;
				}
			
				index++;
			}
		
			NSString *suffix = [[tokens objectAtIndex:index+2] substringFromIndex:1];
			NSString *raceDxString = [suffix substringToIndex:suffix.length-1];
			
			// identify race distance to trim arrays passed
			int raceDxIndex = 0;
			
			if([raceDxString isEqualToString:@"685"])
			{
				raceDxIndex = 1;
			}
			
			double maxTimeForDistance = kMaxTimeFor550Race;
			
			if(raceDxIndex == 1)
			{
				maxTimeForDistance = kMaxTimeFor685Race;
			}
				
			// create thisRaceLineByLine and add the line starting with trackName (lines 10)
			NSMutableArray *thisRaceLineByLine = [NSMutableArray new];
			
			// skips 2nd longLine...
			NSUInteger thisRaceLineNumber = 3;
			
			// loop until next race start found
			while(i + thisRaceLineNumber < endIndex)
			{
				thisLine			= [fileContentsLineByLine objectAtIndex:i + thisRaceLineNumber++];
				isThisNewRaceRecord	= [NSString isThisALongLineOfUnderscores:thisLine];
				
				if(isThisNewRaceRecord)
				{
					break;  // new record found
				}
				
				else
				{
					[thisRaceLineByLine addObject:thisLine];
				}
			}
			
			// since entries who fall have no race time to track
			// keep track of the worst time race and assign that plus a penalty (10%) to all dogs who fall
			double worstTime	= 0.0;
			double raceTime		= 0.0;
			
			//	iterate through all entries via thisRaceLineByLine
			for(NSString *line in thisRaceLineByLine)
			{
				// modify line by removing extra white space
				NSString *modifiedLine = [self removeExtraSpacesFromString:line];
			
				raceTime = [self setStatsForLine:modifiedLine
							 withStatisticsArray:statsAccumulatorArray
								 andCounterArray:statsCounterArray
								withMaxTimeForDx:maxTimeForDistance
							 andCurrentWorstTime:worstTime
								  forRaceDxIndex:raceDxIndex];
				
				// if the entry does not finish race of is out of picture 'dnf' 'oop'
				//	assign worstTime + kNotFinishingPenalty
				
				if(raceTime > worstTime)
				{
					worstTime = raceTime;
				}
			}
			
			// increment i so we don't reread this race
			i += thisRaceLineNumber - 2;
		}
	}
}

- (double)setStatsForLine:(NSString*)resultFileLine
	  withStatisticsArray:(double*)statsAccumulatorArray
		  andCounterArray:(int*)statsCounterArray
		 withMaxTimeForDx:(double)maxTimeForDistance
	  andCurrentWorstTime:(double)worstTime
		   forRaceDxIndex:(NSUInteger)raceDxIndex
{
	/*
	 NORMAL EXAMPLE:
	 King Tarik 74½ 3 6 8 7 5 3½ 31.44 8.00 Blocked 1st-went Wide
	 
	 EXAMLES of dnf entry line:
	 
	 Deco Alamo Rojo      2 0 0    0    8       94.00 -----
	 Hessian Soldier  73½ 7 6 7    7    7       91.00 9.90  Collided 1st Turn-fell
	 Bow Sassy Circle 59½ 2 2 8    8    8       92.00 4.10  Clipped 1st Turn-fell
	*/
	
	// assign zero to all fields, so that falling at any point is covered
	BOOL didNotFinishRace			= NO;
	NSUInteger postPosition			= 0;
	NSUInteger breakPosition		= 0;
	NSUInteger firstTurnPosition	= 0;
	NSUInteger secondTurnPosition	= 0;
	NSUInteger finishPosition		= 0;
	double actualFinishTime			= 0.0;
	double adjustedFinishTime		= 0.0;
	double returnFinishTime			= 0.0;
	double maxTimeForThisDistance	= 0.0;
	
	// get the post and break positions
	NSArray *tokens		= [resultFileLine componentsSeparatedByString:@" "];
	NSUInteger index	= [self getIndexOfPostPosition:tokens];
	
	if(index == 0)
	{
		didNotFinishRace = YES;
	}
	else
	{
		NSString *postWord	= [tokens objectAtIndex:index];
		NSString *breakWord	= [tokens objectAtIndex:++index];
		
		if([breakWord isEqualToString:@"0"] || [postWord isEqualToString:@"0"])
		{
			didNotFinishRace = YES;
		}
		else
		{
			NSString *firstTurnWord	= [tokens objectAtIndex:++index];
			
			if([firstTurnWord isEqualToString:@"0"])
			{
				didNotFinishRace = YES;
			}
			else
			{
				if([firstTurnWord isEqualToString:@"1"])
				{
					index++;
				}
				
				NSString *secondTurnWord = [tokens objectAtIndex:++index];
				
				if([secondTurnWord isEqualToString:@"0"])
				{
					didNotFinishRace = YES;
				}
				else
				{
					if([secondTurnWord isEqualToString:@"1"])
					{
						index++;
					}
					
					NSString *finishWord		= [tokens objectAtIndex:++index];
					NSString *finishTimeWord	= [tokens objectAtIndex:index];
					
					actualFinishTime = [finishTimeWord doubleValue];
					
					// some times arbitrary very long times are assigned
					// lower this to our own maxTime
					if(actualFinishTime > maxTimeForThisDistance)
					{
						didNotFinishRace	= YES;
					}
					else
					{
						postPosition		= (NSUInteger)[postWord integerValue];
						breakPosition		= (NSUInteger)[breakWord integerValue];
						firstTurnPosition	= (NSUInteger)[firstTurnWord integerValue];
						secondTurnPosition	= (NSUInteger)[secondTurnWord integerValue];
						finishPosition		= (NSUInteger)[finishWord integerValue];
						actualFinishTime	= (double)[finishTimeWord doubleValue];
						returnFinishTime	= actualFinishTime;
						adjustedFinishTime	= actualFinishTime;
					}
				}
			}
		}
	}
	
	// need to fix finishTime for all falls etc. by assigning penalty to worst time
	if(didNotFinishRace == YES)
	{
		adjustedFinishTime	= worstTime + kNotFinishingPenalty;
		returnFinishTime	= worstTime;
	}
	
	// work backwards from finish stats
	// statFields
	//	0: average breakPosition for post
	//	1: average firstTurnPosition for post
	//	2: average secondTurnPosition for firstTurnPosition
	//	3: average finishPosition for secondTurnPosition
	//	4: average time for post
	
	#define kBreakPositionFromPostStatField 0
	#define kFirstTurnPositionFromPostStatField 1
	#define kSecondTurnPositionFromFirstTurnStatField 2
	#define kFinishPositionFromSecondTurnStatField 3
	#define kFinishTimeFromPostStatField 4
	
	if(adjustedFinishTime > 0)
	{
		NSUInteger timeOffset	= raceDxIndex * kNumberRaceDistances + postPosition * kMaximumNumberEntries + kFinishTimeFromPostStatField;
		double *timeStatPtr		= statsAccumulatorArray + timeOffset;
		int *timeCounterPtr		= statsCounterArray + timeOffset;
		
		*timeCounterPtr		+= 1;
		*timeStatPtr		+= adjustedFinishTime;
	}
	
	if(finishPosition > 0)
	{
		NSUInteger finishOffset	= raceDxIndex * kNumberRaceDistances + postPosition * kMaximumNumberEntries + kFinishPositionFromSecondTurnStatField;
		double *finishStatPtr	= statsAccumulatorArray + finishOffset;
		int *finishCounterPtr	= statsCounterArray + finishOffset;

		*finishCounterPtr	+= 1;
		*finishStatPtr		+= (double)finishPosition;
	}
	
	if(secondTurnPosition > 0)
	{
		NSUInteger secondTurnPositionOffset	= raceDxIndex * kNumberRaceDistances + firstTurnPosition * kMaximumNumberEntries + kSecondTurnPositionFromFirstTurnStatField;
		double *secondTurnPositionStatPtr	= statsAccumulatorArray + secondTurnPositionOffset;
		int *secondTurnCounterPtr			= statsCounterArray + secondTurnPositionOffset;
		
		*secondTurnCounterPtr		+= 1;
		*secondTurnPositionStatPtr	+= (double)secondTurnPosition;
	}
	
	
	if(firstTurnPosition > 0)
	{
		NSUInteger firstTurnPositionOffset	= raceDxIndex * kNumberRaceDistances + postPosition * kMaximumNumberEntries + kFirstTurnPositionFromPostStatField;
		double *firstTurnPositionStatPtr	= statsAccumulatorArray + firstTurnPositionOffset;
		int *firstTurnCounterPtr			= statsCounterArray + firstTurnPositionOffset;
		
		*firstTurnCounterPtr		+= 1;
		*firstTurnPositionStatPtr	+= (double)firstTurnPosition;
	}
	
	if(breakPosition > 0)
	{
		NSUInteger breakPositionOffset	= raceDxIndex * kNumberRaceDistances + postPosition * kMaximumNumberEntries + kFirstTurnPositionFromPostStatField;
		double *breakPositionStatPtr	= statsAccumulatorArray + breakPositionOffset;
		int *breakCounterPtr			= statsCounterArray + breakPositionOffset;
		
		*breakCounterPtr		+= 1;
		*breakPositionStatPtr	+= (double)breakPosition;
	}
	
	return returnFinishTime;
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

- (void)createNewPopoulationWithName:(NSString*)name
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
		self.populationSize = initialSize;

		self.population.track			= [NSEntityDescription insertNewObjectForEntityForName:@"ECTrack"
																		inManagedObjectContext:MOC] ;
		self.population.populationName  = @"NewPopulationTest 1.0.0.0";
        self.population.initialSize     = [NSNumber numberWithInteger:initialSize];
        self.population.minTreeDepth    = [NSNumber numberWithInteger:mintreeDepth];
        self.population.maxTreeDepth    = [NSNumber numberWithInteger:maxTreeDepth];
        self.population.genesisDate     = [NSDate date];
        self.population.mutationRate    = [NSNumber numberWithFloat:mutationRate];
		
		self.population.track.trackRaceDistanceStats = [self createSetOfStatisticsForTrack:self.population.track];
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

	for(int popIndex = 0; popIndex < [self.population.initialSize unsignedIntegerValue]; popIndex++)
	{
		ECHandicapper *tempHandicapper	= self.rankedPopulation[popIndex];
		NSArray *thisMembersDnaTrees	= [NSArray arrayWithObjects:[self recoverTreeFromString:tempHandicapper.breakPositionTree],
																	[self recoverTreeFromString:tempHandicapper.breakSpeedTree],
																	[self recoverTreeFromString:tempHandicapper.earlySpeedTree],
																	[self recoverTreeFromString:tempHandicapper.topSpeedTree],
																	[self recoverTreeFromString:tempHandicapper.lateSpeedTree],
																	[self recoverTreeFromString:tempHandicapper.recentClassTree],
																	[self recoverTreeFromString:tempHandicapper.earlySpeedRelevanceTree],
																	[self recoverTreeFromString:tempHandicapper.otherRelevanceTree], nil];
				
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
		NSString *question      = NSLocalizedString(@"Create New Population",
													@"Cancel");
		NSString *info			= NSLocalizedString(@"No population has been selected.",
												@"Tap the Create New Population button or Select Population button?");
		NSString *quitButton    = NSLocalizedString(@"OK", @"");
		
		[alert setMessageText:question];
		[alert setInformativeText:info];
		[alert addButtonWithTitle:quitButton];
		
		[alert runModal];
	
		return;
	}

		
	self.generationsThisCycle	= numberGenerations;
	NSString *resultFolderPath	= @"/Users/ronjurincie/Desktop/Greyhound Central/Results/DerbyLane";
	
			
	for(NSUInteger localGenNumber = 0; localGenNumber < self.generationsThisCycle; localGenNumber++)
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
    
    [self updateAndSaveData];
	
	NSLog(@"trainPopulation finished");
}


   
- (void)testPopulation:(ECPopulation*)population
	  includingParents:(BOOL)parentsToo
	belowResultsFolder:(NSString *)resultFolderPath
{
	// self.workingPopulation array MUST be sorted at this point with:
	//	chldren occupying BOTTOM HALF of array with their indices
	
	NSUInteger startIndex					= self.populationSize - self.trainingPopSize;
	NSFileManager *localFileManager			= [[NSFileManager alloc] init];
	NSDirectoryEnumerator *dirEnumerator	= [localFileManager enumeratorAtPath:resultFolderPath];
	NSString *fileName						= nil;
	BOOL isDirectory						= NO;
	
    while((fileName = [dirEnumerator nextObject]))
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
	//		10  DERBY LANE                   Wednesday Nov 05 2008 Afternoon   Race 1    Grade  C   (550)  Time: 31.19
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
	//Line #	^
	//	0:		DERBY LANE                   Wednesday Nov 05 2008 Afternoon   Race 2    Grade  D   (550)  Time: 30.97
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
	NSUInteger raceDx		= [self getRaceDistanceFromString:[lineZeroTokens objectAtIndex:firstDateToken + 9]];
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


- (NSUInteger)getRaceDistanceFromString:(NSString*)raceNumberString
{
	NSString *prefix				= [raceNumberString substringToIndex:4];
	NSString *stringWithoutParens	= [prefix substringFromIndex:1];
	NSUInteger distanceOfRaceinFeet = [stringWithoutParens integerValue];
	
	return distanceOfRaceinFeet;
}

- (NSString*)removeExtraSpacesFromString:(NSString*)originalString
{
    NSString *strippedString = nil;
    
    while ([originalString rangeOfString:@"  "].location != NSNotFound)
	{
        originalString = [originalString stringByReplacingOccurrencesOfString:@"  "
                                                                   withString:@" "];
	}
    
    strippedString = [NSString stringWithString:originalString];
    
    return strippedString;
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
		ECEntry *entry	= [NSEntityDescription insertNewObjectForEntityForName:@"ECEntry"
														inManagedObjectContext:MOC];
		entry.name		= entryName;
		
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
	NSArray *collisionWords = [NSArray arrayWithObjects:@"fell", @"trouble", @"collided", @"bumped", @"hit", @"blocked", @"crowded", nil];
	NSArray *indsideWords	= [NSArray arrayWithObjects:@"rail", @"inside", @"insid", @"in", nil];
	NSArray *outsideWords	= [NSArray arrayWithObjects:@"outside", @"out", @"wide", nil];
	NSArray *midtrackWords	= [NSArray arrayWithObjects:@"midtrack", @"mid", nil];
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
	 for(NSUInteger index = 0; index < [population.populationSize unsignedIntegerValue]; index++)
	 {
		NSArray *thisHandicappersStrengthFields = nil; // FIX:
		
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
	
	newHandicapper.breakPositionTree		= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kBreakPositionStrand]];
	newHandicapper.breakSpeedTree			= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kBreakSpeedStrand]];
	newHandicapper.earlySpeedTree			= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kEarlySpeedStrand]];
	newHandicapper.topSpeedTree				= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kTopSpeedStrand]];
	newHandicapper.lateSpeedTree			= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kLateSpeedStrand]];
	newHandicapper.recentClassTree			= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kRecentClassStrand]];
	newHandicapper.earlySpeedRelevanceTree	= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kEarlySpeedRelevanceStrand]];
	newHandicapper.otherRelevanceTree		= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kOtherRelevanceStrand]];
	
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
    
    changedHandicapper.breakPositionTree        = self.workingPopulationDna[popIndex][0];
    changedHandicapper.breakSpeedTree           = self.workingPopulationDna[popIndex][1];
    changedHandicapper.earlySpeedTree           = self.workingPopulationDna[popIndex][2];
    changedHandicapper.topSpeedTree             = self.workingPopulationDna[popIndex][3];
    changedHandicapper.lateSpeedTree            = self.workingPopulationDna[popIndex][4];
    changedHandicapper.recentClassTree          = self.workingPopulationDna[popIndex][5];
    changedHandicapper.earlySpeedRelevanceTree  = self.workingPopulationDna[popIndex][6];
    changedHandicapper.otherRelevanceTree       = self.workingPopulationDna[popIndex][7];
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
                case kBreakPositionStrand:
                    newbie.breakPositionTree = dnaString;
                    break;
                    
                case kBreakSpeedStrand:
                    newbie.breakSpeedTree = dnaString;
                    break;
                    
                case kEarlySpeedStrand:
                    newbie.earlySpeedTree = dnaString;
                    break;
                    
                case kTopSpeedStrand:
                    newbie.topSpeedTree = dnaString;
                    break;
                    
                case kLateSpeedStrand:
                    newbie.lateSpeedTree = dnaString;
                    break;
                    
                case kRecentClassStrand:
                    newbie.recentClassTree = dnaString;
                    break;
                    
                case kEarlySpeedRelevanceStrand:
                    newbie.earlySpeedRelevanceTree = dnaString;
                    break;
                    
                case kOtherRelevanceStrand:
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
    
    if(level < [self.population.minTreeDepth intValue])
	{
		nodeType = kFunctionNode;
	}
	else
    {
        if(rand() % 3 == 0)  // 1/3 of remaining nodes are functions
        {
            nodeType = kFunctionNode;
        }
        else
        {
            // other 2/3 split evenly between constants and variables
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
    ECTree *newTree       = nil;
    NSString *newString     = nil;
    NSString *newString2    = nil;
    NSString *token         = nil;
    NSString *arg1String    = nil;
    NSString *arg2String    = nil;
    NSUInteger commaIndex   = 0;
    NSUInteger parenIndex   = 0;
    NSUInteger numArgs      = 0;
    NSUInteger i            = 0;
    char letter             = '$';
    BOOL gotFunction        = FALSE;
	
	i = 0;
    
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
		if(newTree.leftBranch == nil || newTree.rightBranch == nil)
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
    
    // 0: break position
    //      2:  race class
    //      6:  number of entrys
    //      8:  position at break
    //      9:  winning time
    
    // 1: break speed
    //      2:  race class
    //      6:  number of entrys
    //      8:  position at break
    //      9:  winning time
    
    // 2: early speed
    //      2:  race class
    //      8:  position at break
    //      9:  winning time
    //      13: lead by lengths 1
    //      16: delta 1
    
    // 3: top speed
    //      9:  winning time
    //      12: entry time
    //      16: delta 1
    //      17: delta 2
    //      18: delta 3
    
    // 4: late speed
    //      2:  race class
    //      8:  position at break
    //      9:  winning time
    //      13: lead by lengths 1
    //      16: delta 3

    // 5: recent class
    //      2:  race class
    //      9:  winning time
    //      11: position at finish
    //      12: entry time
    
    // 6: early speed relevance
    //      2:  race class
    //      5:  raceDate (used to calculate "days ago")
    //      7:  post number (used to calculate delta post)

    // 7: other relevance
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