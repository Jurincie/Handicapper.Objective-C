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
#import "NSString+ECStringValidizer.h"
#import "Constants.h"
#import "ECPopulation.h"
#import "ECEntry.h"
#import "ECTree.h"
#import "ECHandicapper.h"
#import "ECDna.h"
#import "ECRaceRecord.h"
#import "ECTrainigRaceRecord.h"
#import "ECPastLineRecord.h"
#import "ECTracks.h"
#import "ECTrackStats.h"
#import "ECSprintRaceStats.h"
#import "ECTwoTurnRaceStats.h"
#import "ECThreeTurnRaceStats.h"
#import "ECMarathonRaceStats.h"
#import "ECPostStats.h"
#import "ECBreakStats.h"
#import "ECSprintTurnStats.h"
#import "ECFirstTurnStats.h"
#import "ECFarTurnStats.h"

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

- (NSArray*)getClassesForTrackWithId:(NSString*)trackName
{
	NSArray *classNames = nil;
	
    if([trackName isEqualToString:@"BM"])
	{
		classNames = [NSArray arrayWithObjects:@"SCL",
                                                @"M",   @"TM",
                                                @"E",   @"TE",
                                                @"D",   @"TD", @"SD",
                                                @"C",   @"TC", @"SC",
                                                @"B",   @"TB", @"SB",
                                                @"A",   @"TA", @"SA", nil];
	}
	else if([trackName isEqualToString:@"BR"])
	{
		classNames = [NSArray arrayWithObjects:@"SCL",
                                                @"M",
                                                @"D",   @"TD",  @"SD",
                                                @"C",   @"TC",  @"SC",
                                                @"B",           @"SB",
                                                @"A",           @"SA", nil];
	}
    else if([trackName isEqualToString:@"CA"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",   @"TM",
                                                @"E",   @"TE",
                                                @"D",
                                                @"C",
                                                @"B",   @"TB",
                                                @"A",   @"TA", @"SA", nil];
	}
    else if([trackName isEqualToString:@"DB"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL", @"T",
                                                @"M",   @"TM",
                                                @"E",   @"TE",
                                                @"D",   @"TD",
                                                @"C",   @"TC",
                                                @"B",   @"TB",
                                                @"A",   @"TA", nil];
	}
    else if([trackName isEqualToString:@"DP"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                      @"M",
                      @"E",
                      @"D", @"TD",
                      @"C",
                      @"B",
                      @"A",         @"SA", nil];
	}
    else if([trackName isEqualToString:@"DQ"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",
                                                @"E",   @"TE",
                                                @"D",   @"TD",
                                                @"C",   @"TC",    @"SC",
                                                @"B",   @"TB",    @"SB",
                                                @"A",   @"TA",    @"SA", nil];
	}
	else if([trackName isEqualToString:@"EB"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",
                                                @"J",   @"TJ",
                                                @"D",   @"TD",  @"SD",
                                                @"C",   @"TC",  @"SC",
                                                @"B",   @"TB",  @"SB",
                                                @"A",   @"TA",  @"SA", nil];
	}
	else if([trackName isEqualToString:@"FL"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",
                                                @"D",
                                                @"C",
                                                @"B",
                                                @"A", @"TA", nil];
	}
	else if([trackName isEqualToString:@"GG"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",
                                                @"J",
                                                @"D",   @"TD",
                                                @"C",   @"TC",
                                                @"B",   @"TB",
                                                @"A",   @"TA",  @"SA",
                                                @"AA",  @"TAA", @"SAA", nil];
	}
	else if([trackName isEqualToString:@"HI"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL", nil];
	}
	else if([trackName isEqualToString:@"HO"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",
                                                @"D",
                                                @"C",
                                                @"B",
                                                @"A", nil];
	}
	else if([trackName isEqualToString:@"LI"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",
                                                @"J",
                                                @"D",
                                                @"C",
                                                @"B",
                                                @"BB",
                                                @"A",
                                                @"AA", @"SAA", nil];
	}
    else if([trackName isEqualToString:@"MB"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",   @"TM",
                                                @"D",   @"TD",
                                                @"C",   @"TC",
                                                @"B",   @"TB",
                                                @"A",   @"TA",
                                                        @"TAA", nil];
	}
	else if([trackName isEqualToString:@"MG"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL", @"T",
                                                @"M",   @"TM",
                                                @"E",   @"TE",
                                                @"D",   @"TD",  @"SD",
                                                @"C",   @"TC",  @"SC",
                                                @"B",   @"TB",  @"SB",
                                                @"A",   @"TA",  @"SA", nil];
	}
	else if([trackName isEqualToString:@"MO"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL", @"T",
                                                @"M",
                                                @"E",
                                                @"D",   @"TD",
                                                @"C",   @"TC",
                                                @"B",   @"TB",
                                                @"A",   @"TA", nil];
	}
	else if([trackName isEqualToString:@"NF"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",     @"S",
                                                @"M",
                                                @"E",
                                                @"D", @"TD", @"SD",
                                                @"C", @"TC", @"SC",
                                                @"B", @"TB",
                                                @"A", @"TA", @"SA", nil];
	}
	else if([trackName isEqualToString:@"OP"])
	{
		classNames = [NSArray arrayWithObjects:@"SCL",
                                                @"M",   @"TM",
                                                @"D",   @"TD",  @"SD",
                                                @"C",   @"TC",  @"SC",
                                                @"B",   @"TB",  @"SB",
                                                @"A",   @"TA",  @"SA", nil];
	}
	else if([trackName isEqualToString:@"OR"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",
                                                @"D",
                                                @"C",   @"TC",
                                                @"B",   @"TB",
                                                @"A",   @"TA", nil];
	}
	else if([trackName isEqualToString:@"PB"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL", @"T",
                                                @"M",
                                                @"J",   @"TJ",  @"SJ",
                                                @"D",   @"TD",  @"SD",
                                                @"C",   @"TC",  @"SC",
                                                @"B",   @"TB",  @"SB",
                                                @"A",   @"TA",  @"SA", nil];
	}
	else if([trackName isEqualToString:@"PE"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"DT",
                                                @"CT",
                                                @"BT",
                                                @"AT", nil];
	}
	else if([trackName isEqualToString:@"PH"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",
                                                @"J",
                                                @"D",
                                                @"C",   @"TC",
                                                @"B",   @"TB",
                                                @"BB",
                                                @"A",   @"TA",
                                                @"AA",  @"TAA", @"SAA",
                                                nil];
	}
	else if([trackName isEqualToString:@"PN"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                        @"TM",
                                                @"E",   @"TE",
                                                @"D",
                                                @"C",
                                                @"B",   @"TB",
                                                @"A",   @"TA", nil];
	}
	else if([trackName isEqualToString:@"RT"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                        @"TD",
                                                @"C",   @"TC",
                                                        @"TB",
                                                        @"TA", nil];
	}
	else if([trackName isEqualToString:@"SA"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL", @"T",
                                                @"M",   @"TM",
                                                @"E",   @"TE",
                                                @"D",   @"TD",
                                                @"C",   @"TC",
                                                @"B",   @"TB",
                                                @"A",   @"TA", nil];
	}
	else if([trackName isEqualToString:@"SE"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL", @"T",
                                                @"M",
                                                @"J",
                                                @"D",
                                                @"C",   @"TC",  @"SC",
                                                @"B",   @"TB",
                                                @"A",   @"TA",  @"SA", nil];
	}
	else if([trackName isEqualToString:@"SL"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",
                                                @"J",
                                                @"D",   @"TD",  @"SD",
                                                @"C",   @"TC",  @"SC",
                                                @"B",   @"TB",  @"SB",
                                                @"A",   @"TA",  @"SA",
                                                @"AA",  @"TAA", @"SAA", nil];
	}
	else if([trackName isEqualToString:@"SN"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL", @"T",
                                                @"M",   @"TM",
                                                @"J",   @"TJ",
                                                @"E",   @"TE",
                                                @"D",   @"TD",
                                                @"C",   @"TC",
                                                @"B",   @"TB",
                                                @"A",   @"TA",  @"SA", nil];
	}
	else if([trackName isEqualToString:@"SO"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",
                                                @"D",
                                                @"C",   @"TC",
                                                @"B",   @"TB",
                                                @"A",   @"TA", nil];
	}
	else if([trackName isEqualToString:@"SP"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",   @"TM",
                                                @"D",   @"TD",
                                                @"C",   @"TC",
                                                @"B",   @"TB",  @"SB",
                                                @"A",   @"TA",  @"SA", nil];
	}

	else if([trackName isEqualToString:@"TS"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",
                                                @"D",   @"TD",
                                                @"C",   @"TC",  @"SC",
                                                @"B",   @"TB",  @"SB",
                                                @"A",   @"TA",  @"SA",
                                                @"AA",  @"TAA", @"SAA", nil];
	}
	else if([trackName isEqualToString:@"TU"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                        @"TM",
                                                @"D",   @"TD",
                                                @"C",   @"TC",
                                                @"B",   @"TB",
                                                @"A",   @"TA", nil];
	}
	else if([trackName isEqualToString:@"VG"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",
                                                @"J",
                                                @"D",
                                                @"C",
                                                @"B",
                                                @"A",
                                                @"AA", nil];
	}
	else if([trackName isEqualToString:@"VL"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",
                                                @"D",   @"TD",
                                                @"C",   @"TC",
                                                @"B",   @"TB",
                                                @"A",   @"TA",  @"SA", nil];
	}
	else if([trackName isEqualToString:@"WD"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",
                                                @"D",   @"TD",
                                                @"C",   @"TC",  @"SC",
                                                @"B",   @"TB",  @"SB",
                                                @"A",   @"TA",  @"SA",
                                                @"AA",  @"TAA", @"SAA", nil];
	}
	else if([trackName isEqualToString:@"WO"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                      @"M",
                      @"J",   @"TJ",
                      @"D",   @"TD",
                      @"C",
                      @"B",   @"TB",
                      @"A",   @"TA", nil];
	}
	else if([trackName isEqualToString:@"WS"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",
                                                @"D",
                                                @"C",
                                                @"B",
                                                @"A", @"SA", nil];
	}
	else if([trackName isEqualToString:@"WT"])
	{
		classNames = [NSArray arrayWithObjects: @"SCL",
                                                @"M",
                                                @"E",
                                                @"D",
                                                @"C",
                                                @"B",
                                                @"A", nil];
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
	NSArray *lines              = [singleRaceString componentsSeparatedByString:@"\n"];
    NSString *bestTimeString    = [lines objectAtIndex:13];
	double bestTime             = [bestTimeString doubleValue];
    
    if(bestTime < 29.00)
    {
        NSLog(@"bad best time in file?");
        exit(1);
    }
    
    return bestTime;
}


- (NSArray*)processEntriesPastLines:(NSString*)pastLines
                       forValidTracks:(NSArray*)validTrackIdsArray
{
    NSString *pathToBugFile = @"/Users/ronjurincie/Desktop/Project Ixtlan/BuggyLines.txt";
    NSUInteger arraySize    = validTrackIdsArray.count * kNumberRaceDistances * kNumberStatFields * kMaximumNumberEntries;
   
    double combinedStatsAndCountersArray[arraySize * 2];
    
    for(NSUInteger index = 0; index < arraySize * 2; index++)
    {
        combinedStatsAndCountersArray[index] = 0.0;
    }
    
    double fastestSpeed = 0.00;
    double slowestSpeed = 100.00;
    
    NSUInteger maxTrapPositions         = kMaximumNumberEntries;
    NSString *breakPositionString       = nil;
    NSString *firstTurnPositionString   = nil;
    NSString *farTurnPositionString     = nil;
    NSString *finalPositionString       = nil;;
    NSString *finalRaceTimeString       = nil;
    NSString *trackID                   = nil;
    NSString *raceClassString           = nil;
    NSString *raceDateString            = nil;
    
    BOOL dnfOccurred                = NO;
    NSUInteger raceDxIndex          = kNoIndex;
    NSUInteger trapPosition         = 0;
    NSUInteger breakPosition        = maxTrapPositions;
    NSUInteger firstTurnPosition    = maxTrapPositions;
    NSUInteger farTurnPosition      = maxTrapPositions;
    NSUInteger finalPosition        = maxTrapPositions;
    double finalRaceTime            = 0.00;
    double averageRaceSpeed         = 0.00;
    
    NSUInteger numberBadCallsBugs   = 0;
    
    NSArray *individualPastLines    = [pastLines componentsSeparatedByString:@"\n\n"];
    NSString *pastLineString        = nil;
    
    // skip the last (EMPTY) past line
    for(NSUInteger pastLineNumber = 0; pastLineNumber < individualPastLines.count - 1; pastLineNumber++)
    {
        dnfOccurred     = NO;
        pastLineString  = [individualPastLines objectAtIndex:pastLineNumber];
        NSArray *lines  = [pastLineString componentsSeparatedByString:@"\n"];
        
        // Since some sprints have farTurnPosition and others do not
        // determine the number of calls in pastLine now
        NSString *calls         = [[lines objectAtIndex:9] substringFromIndex:7];
        NSArray *callsArray     = [calls componentsSeparatedByString:@" "];
        NSUInteger numberCalls  = callsArray.count;
        
        if(numberCalls > 5)
        {
            continue;
        }
        else if(numberCalls < 4)
        {
            continue;
        }
        
        raceDateString = [lines firstObject];
        
        NSString *numberEntriesString   = [lines objectAtIndex:6];
        NSUInteger numberEntries        = [numberEntriesString intValue];
       
        if(numberEntries == 0) // num entries not given, so put in 8
        {
            numberEntries = 8;
        }
        
        breakPosition       = numberEntries;
        firstTurnPosition   = numberEntries;
        farTurnPosition     = numberEntries;
        finalPosition       = numberEntries;
        
        double winningTime      = [[lines objectAtIndex:7] doubleValue];
        trackID                 = [lines objectAtIndex:1];
        NSUInteger trackIndex   = [validTrackIdsArray indexOfObject:trackID];
        
        // avoids unmodeled tracks
        if(trackIndex == NSNotFound)
        {
            continue;
        }
       
        NSString *raceDistanceString    = [lines objectAtIndex:3];
        NSUInteger raceDistance         = [raceDistanceString intValue];
        raceDxIndex                     = [self getRaceDxIndexFromString:raceDistanceString];
        
//        // TEST // ONLY look at sprint races at HI trackID
//        if(raceDxIndex > 0)
//        {
//            continue;
//        }
//        else if(trackIndex == 0)
//        {
//            continue;
//        }
        
        if(raceDxIndex == kNoIndex)
        {
            // ignore races at distances we are not interested in
            continue;
        }
        else if(raceDxIndex > kNumberRaceDistances)
        {
            NSLog(@"bad race distance index");
            continue;
        }
        
        // skip races at distances we are not modeling
        NSArray *modeledRaceDxIndices = [self getModeledRaceDistancesForTrackWithID:trackID];
        
        if([modeledRaceDxIndices containsObject:raceDistanceString] == NO)
        {
            continue;
        }
    
        // return to callsArray here
        NSString *trapPositionString    = [callsArray objectAtIndex:0];
        trapPosition                    = [trapPositionString intValue];
        
        if(trapPosition == 0)
        {
            NSLog(@"bad post position 1");
            // simply ignore these - arises when race == "declared no race"
            continue;
        }
        else if(trapPosition > maxTrapPositions)
        {
            NSLog(@"bad post position 2");
            continue;
        }
        
        breakPositionString = [callsArray objectAtIndex:1];
        
        if([self isThisFallWord:breakPositionString])
        {
            dnfOccurred = YES;
        }
        else
        {
            breakPosition = [breakPositionString integerValue];
            
            if(breakPosition == 0)
            {
                // simply ignore these
                continue;
            }
            
            firstTurnPositionString = [callsArray objectAtIndex:2];
            
            if([self isThisFallWord:firstTurnPositionString] || firstTurnPosition == 0)
            {
                dnfOccurred = YES;
            }
            else
            {
                firstTurnPosition = [firstTurnPositionString integerValue];
              
                if(firstTurnPositionString.length > 1)
                {
                    firstTurnPositionString = [firstTurnPositionString substringToIndex:1];
                    firstTurnPosition       = [firstTurnPositionString intValue];
                }
                
                BOOL farTurnStatExists = numberCalls == 5 ? YES : NO;
                
                if(farTurnStatExists == NO)
                {
                    farTurnPosition         = 0;
                    farTurnPositionString   = @"-";
                }
                else
                {
                    farTurnPositionString = [callsArray objectAtIndex:3];
                }
                
                if([self isThisFallWord:farTurnPositionString])
                {
                    dnfOccurred = YES;
                }
                else if(farTurnPosition == 0 && raceDxIndex > 0)
                {
                    NSLog(@"problem here");
                }
                else
                {
                    if(farTurnPosition == 0)
                    {
                        // MUST be Sprint Race
                        finalPositionString = [callsArray objectAtIndex:3];
                    }
                    else
                    {
                        farTurnPosition = [farTurnPositionString integerValue];
                        
                        if(farTurnPositionString.length > 1)
                        {
                            farTurnPositionString   = [farTurnPositionString substringToIndex:1];
                            farTurnPosition         = [farTurnPositionString integerValue];
                        }
                   
                        finalPositionString = [callsArray objectAtIndex:4];
                    }
                    
                    if([self isThisFallWord:finalPositionString] || finalPosition == 0)
                    {
                        dnfOccurred = YES;
                    }
                    else
                    {
                        NSString *lengthsBehindOrAheadString    = [finalPositionString substringFromIndex:2];
                        finalPositionString                     = [finalPositionString substringToIndex:1];
                        finalPosition                           = [finalPositionString integerValue];
                        
                        if(finalPosition > numberEntries)
                        {
                            
                            if(finalPosition - numberEntries < 2 && finalPosition <= 8)
                            {
                                finalPosition = numberEntries;
                            }
                            else
                            {
                                numberEntries = [self returnGreatestValueForCalls:callsArray];
                            }
                        }
                        
                        if([lengthsBehindOrAheadString isEqualToString:@"OOP"] || [lengthsBehindOrAheadString doubleValue] == 0.00)
                        {
                            dnfOccurred = YES;
                        }
                    }
                }
            }
        }
        
        raceClassString = [lines objectAtIndex:2];
        
        if(dnfOccurred)
        {
            finalPosition = numberEntries;
            
            // add 11% to winning race time for dnf time
            finalRaceTime = winningTime * 1.11;
        }
        else
        {
            finalRaceTimeString = [lines objectAtIndex:10];
            finalRaceTime       = [finalRaceTimeString doubleValue];
            
            if(finalRaceTime == 0.00 && dnfOccurred)
            {
                finalRaceTime = [finalRaceTimeString doubleValue];
            }
            else if(finalRaceTime < 28.00 && raceDxIndex > 0)
            {
                continue;
            }
            else if(raceDxIndex == 0 && finalRaceTime < 13.00)
            {
                continue;
            }
        }
        
        if(trapPosition == 0 || trapPosition > kMaximumNumberEntries)
        {
            NSLog(@"post position error");
            continue;
        }
        else
        {
            if(breakPosition > kMaximumNumberEntries)
            {
                NSLog(@"post position error");
                continue;
            }
            else if(firstTurnPosition > kMaximumNumberEntries)
            {
                NSLog(@"1st turn position error");
                continue;
            }
            else if(farTurnPosition > kMaximumNumberEntries)
            {
                NSLog(@"top of stretch position error");
                continue;
            }
            else if(finalPosition > kMaximumNumberEntries)
            {
                NSLog(@"final position error");
                continue;
            }
            
            if(breakPosition == 0)
            {
                breakPosition = numberEntries;
            }
            if(firstTurnPosition == 0)
            {
                firstTurnPosition = numberEntries;
            }
            if(farTurnPosition == 0 && raceDxIndex > 0)
            {
                numberBadCallsBugs++;
                
                // first read in text from: pathToBugFile
                // then append calls.\n
                // then overwrite appended content back to file
                NSError *error              = nil;
                NSString *bugFileContents   = [NSString stringWithContentsOfFile:pathToBugFile
                                                                        encoding:NSStringEncodingConversionAllowLossy
                                                                           error:&error];
                
                if(nil == bugFileContents)
                {
                    bugFileContents = @"";
                }
                
                if(calls.length < 32)
                {
                    bugFileContents = [NSString stringWithFormat:@"%@%@\n", bugFileContents, calls];
                    error           = nil;
                    
                    [bugFileContents writeToFile:pathToBugFile
                                      atomically:YES
                                        encoding:NSUTF8StringEncoding
                                           error:&error];
                    
                    if(error)
                    {
                        NSLog(@"%@", error.description);
                        exit(1);
                    }
                }
    
                continue;
            }
            
            if(finalPosition == 0)
            {
                finalPosition = numberEntries;
            }
            
            // calculate average speed in miles/hour knowing raceDistance is in yards
            // first get yards/second
            averageRaceSpeed = raceDistance / finalRaceTime;
            
            // convert to miles/hour
            averageRaceSpeed *= 2.0545454;
            
            if(averageRaceSpeed > fastestSpeed)
            {
                fastestSpeed = averageRaceSpeed;
            }
            
            if(averageRaceSpeed < slowestSpeed)
            {
                slowestSpeed = averageRaceSpeed;
            }
            
            NSString *bufferString = @"";
            NSString *bufferString2 = @"";
            
            if(raceDateString.length == 12)
            {
                bufferString = @" ";
            }
            
            if(raceClassString.length == 2)
            {
                bufferString2 = @" ";
            }
            else if(raceClassString.length == 1)
            {
                bufferString2 = @"  ";
            }
            
            
            NSLog(@"%@ %@ %@ %@ %@ %lu[%lu] %lu %lu %lu %lu %lu %lf", trackID, raceDateString, bufferString, raceClassString, bufferString2, raceDistance,
                                                                        raceDxIndex,  trapPosition, breakPosition, firstTurnPosition,
                                                                        farTurnPosition, finalPosition, averageRaceSpeed);

            for(NSUInteger statFieldNumber = 0; statFieldNumber < kNumberStatFields; statFieldNumber++)
            {
                // rememberSprint races AND BM sprint races DQ have farTurnStat
                if(statFieldNumber == kFarTurnPositionFromFirstTurnStatField && raceDxIndex == kSprintRace)
                {
                    if([trackID isEqualToString:@"BM"] || [trackID isEqualToString:@"DQ"] == NO)
                    {
                        continue;
                    }
                }
                       
                NSUInteger index = [self getIndexForTrackIndex:trackIndex
                                           atRaceDistanceIndex:raceDxIndex
                                            forStatFieldNumber:statFieldNumber
                                                  withPosition:trapPosition];
                
                NSUInteger countIndex = index + arraySize;
                
                if(index == kNoIndex)
                {
                    NSLog(@"bug");
                }
                
                double callPosition = 0;
                
                switch (statFieldNumber)
                {
                    case kBreakPositionFromTrapPositionStatField:
                        callPosition = breakPosition;
                        break;
                        
                    case kFirstTurnPositionFromTrapPositionStatField:
                        callPosition = firstTurnPosition;
                        break;
                        
                    case kFinalPositionFromTrapPositionStatField:
                        callPosition = finalPosition;
                        break;
                        
                    case kFirstTurnPositionFromBreakStatField:
                        callPosition = firstTurnPosition;
                        break;
                        
                    case kFarTurnPositionFromFirstTurnStatField:
                        callPosition = farTurnPosition;
                        break;
                        
                    case kFinalPositionFromFarTurnStatField:
                        callPosition = finalPosition;
                        break;
                        
                    default:
                        break;
                }
                
                double oldValue     = combinedStatsAndCountersArray[index];
                double newValue     = oldValue + callPosition;
                
                double oldCounter   = combinedStatsAndCountersArray[countIndex];
                double newCounter   = oldCounter + 1.0;
                
                combinedStatsAndCountersArray[index]        = newValue;
                combinedStatsAndCountersArray[countIndex]   = newCounter;
            }
        }
     }
    
    NSMutableArray *returnArray = [NSMutableArray new];
    
    // copy the c array to NSArray
    for(NSUInteger i = 0; i < arraySize * 2; i++)
    {
        NSNumber *doubleValue = [NSNumber numberWithDouble:combinedStatsAndCountersArray[i]];
    
        [returnArray addObject:doubleValue];
    }
    
//    NSLog(@"fastest Speed:%lf", fastestSpeed);
//    NSLog(@"slowest Speed:%lf", slowestSpeed);
//    NSLog(@"bad files: %lu", (unsigned long)numberBadCallsBugs);
    
    return returnArray;
}

- (void)printArray:(NSArray*)arrayToPrint
{
    for(NSString *line in arrayToPrint)
    {
        NSLog(@"%@\n", line);
    }
}

- (void)printNonZeroValuesWithIndicesInArray:(NSArray*)arrayToPrint
{
    for(NSUInteger index = 0; index < arrayToPrint.count / 2; index++)
    {
        NSUInteger index2 = index + (arrayToPrint.count / 2);
        double value        = [[arrayToPrint objectAtIndex:index] doubleValue];
        double count        = [[arrayToPrint objectAtIndex:index2] doubleValue];
       
        if(value > 0 || count > 0)
        {
            double average = count > 0.0 ? value / count : 0.0;
            int post = (int)((index % 54) / 6) + 1;
            
            
            switch (index % 6)
            {
                case kBreakPositionFromTrapPositionStatField:
                    NSLog(@"Post[%i]=>AverageBreakPosition[%i]%lf [%i]%lf\t%lf", post, (int)index, value, (int)index2, count, average);
                    break;
                    
                case kFirstTurnPositionFromTrapPositionStatField:
                    NSLog(@"Post[%i]=>AverageFirstTurnPosition[%i]%lf [%i]%lf\t%lf", post, (int)index, value, (int)index2, count, average);
                    break;
                    
                case kFinalPositionFromTrapPositionStatField:
                    NSLog(@"Post[%i]=>AverageFinishPosition[%i]%lf [%i]%lf\t%lf", post, (int)index, value, (int)index2, count, average);
                    break;
                    
                case kFirstTurnPositionFromBreakStatField:
                    NSLog(@"Break[%i]=>AverageFirstTurnPosition[%i]%lf [%i]%lf\t%lf", post, (int)index, value, (int)index2, count, average);
                    break;
                    
                case kFarTurnPositionFromFirstTurnStatField:
                    NSLog(@"1stTurn[%i]=>AverageFarTurnPosition[%i]%lf [%i]%lf\t%lf", post, (int)index, value, (int)index2, count, average);
                    break;
                    
                case kFinalPositionFromFarTurnStatField:
                    NSLog(@"FarTurn[%i]=>AverageFinsihkPosition[%i]%lf [%i]%lf\t%lf", post, (int)index, value, (int)index2, count, average);
                    break;
                    
                default:
                    break;
            }
        }
    }
}


- (NSUInteger)returnGreatestValueForCalls:(NSArray*)raceCallsArray
{
    NSUInteger greatestPosition = 0;
    NSUInteger position         = 0;
    
    for(NSUInteger callsIndex = 0; callsIndex < raceCallsArray.count; callsIndex++)
    {
        NSString *thisCall = [raceCallsArray objectAtIndex:callsIndex];
        
        if(thisCall.length > 1)
        {
            NSArray *splitStringArray   = [thisCall componentsSeparatedByString:@":"];
            NSString *positionString    = [splitStringArray firstObject];
            
            position = [positionString intValue];
        }
        else
        {
            position = [thisCall intValue];
        }
        
        if(position > greatestPosition)
        {
            greatestPosition = position;
        }
    }
    
    return greatestPosition;
}

- (NSArray*)getModeledRaceDistancesForTrackWithID:(NSString*)trackID
{
    NSMutableArray *validRaceDistances = [NSMutableArray new];
    
    if([trackID isEqualToString:@"BM"])    // Birmingham
    {
        [validRaceDistances addObject:@"330"];
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"678"];
    }
    else if([trackID isEqualToString:@"BR"])    // Bluff's Run
    {
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"678"];
    }
    else if([trackID isEqualToString:@"CA"])    // Caliente
    {
        [validRaceDistances addObject:@"550"];
        [validRaceDistances addObject:@"690"];
        
    }
    else if([trackID isEqualToString:@"DB"])    // Daytona Beach
    {
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"678"];
    }
    else if([trackID isEqualToString:@"DP"])    // Dairyland Park*
    {
        [validRaceDistances addObject:@"550"];
        [validRaceDistances addObject:@"660"];
    }
    else if([trackID isEqualToString:@"DQ"])    // Dubuque
    {
        [validRaceDistances addObject:@"330"];
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"678"];
    }
    else if([trackID isEqualToString:@"EB"])    // Ebro
    {
        [validRaceDistances addObject:@"330"];
        [validRaceDistances addObject:@"550"];
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"678"];
    }
    else if([trackID isEqualToString:@"FL"])    // Flagler
    {
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"647"];
    }
    else if([trackID isEqualToString:@"GG"])    // Gulf
    {
        [validRaceDistances addObject:@"330"];
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"678"];
    }
    else if([trackID isEqualToString:@"HI"])    // *
    {
        [validRaceDistances addObject:@"566"];
    }
    else if([trackID isEqualToString:@"HO"])    // Hollywood*
    {
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"678"];
    }
    else if([trackID isEqualToString:@"JA"])    // Jacksonville*
    {
        [validRaceDistances addObject:@"550"];
    }
    else if([trackID isEqualToString:@"JC"])    // Jefferson County*
    {
        [validRaceDistances addObject:@"550"];
    }
    else if([trackID isEqualToString:@"LI"])    // Lincoln*
    {
        [validRaceDistances addObject:@"550"];
        [validRaceDistances addObject:@"678"];
    }
    else if([trackID isEqualToString:@"MB"])    // Melbourne*
    {
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"678"];
    }
    else if([trackID isEqualToString:@"MG"])    // Mardi Gras
    {
        [validRaceDistances addObject:@"550"];
        [validRaceDistances addObject:@"661"];
        [validRaceDistances addObject:@"770"];
    }
    else if([trackID isEqualToString:@"MH"])    // Mile High*
    {
        [validRaceDistances addObject:@"783"];
    }
    else if([trackID isEqualToString:@"MO"])    // Mobile
    {
        [validRaceDistances addObject:@"550"];
        [validRaceDistances addObject:@"661"];
    }
    else if([trackID isEqualToString:@"NF"])    // Naples / Fort Meyers
    {
        [validRaceDistances addObject:@"330"];
        [validRaceDistances addObject:@"550"];
        [validRaceDistances addObject:@"661"];
    }
    else if([trackID isEqualToString:@"OP"])    // Orange Park
    {
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"678"];
        [validRaceDistances addObject:@"770"];
    }
    else if([trackID isEqualToString:@"OR"])    // Oregon?*
    {
        [validRaceDistances addObject:@"566"];
    }
    else if([trackID isEqualToString:@"PB"])    // Palm Beach
    {
        [validRaceDistances addObject:@"301"];
        [validRaceDistances addObject:@"545"];
        [validRaceDistances addObject:@"661"];
    }
    else if([trackID isEqualToString:@"PE"])    // Pensacola?
    {
        [validRaceDistances addObject:@"550"];
    }
    else if([trackID isEqualToString:@"PH"])    // Phoenix*
    {
        [validRaceDistances addObject:@"550"];
        [validRaceDistances addObject:@"685"];
    }
    else if([trackID isEqualToString:@"PN"])    // ??
    {
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"678"];
    }
    else if([trackID isEqualToString:@"RT"])    // Raynaham
    {
        [validRaceDistances addObject:@"330"];
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"678"];
    }
    else if([trackID isEqualToString:@"SA"])    // Sarasota
    {
        [validRaceDistances addObject:@"330"];
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"678"];
    }
    else if([trackID isEqualToString:@"SE"])    // ??
    {
        [validRaceDistances addObject:@"550"];
    }
    else if([trackID isEqualToString:@"SL"])    // Southland
    {
        [validRaceDistances addObject:@"334"];
        [validRaceDistances addObject:@"583"];
        [validRaceDistances addObject:@"703"];
        [validRaceDistances addObject:@"820"];
    }
    else if([trackID isEqualToString:@"SN"])    // Sanford-Orlando?
    {
        [validRaceDistances addObject:@"313"];
        [validRaceDistances addObject:@"350"];
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"678"];
    }
    else if([trackID isEqualToString:@"SO"])    // Sanford-Orlando?
    {
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"678"];
    }
    else if([trackID isEqualToString:@"SP"])    // Derby Lane (St. Petersburt)
    {
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"678"];
    }
    else if([trackID isEqualToString:@"TP"])    // Tampa*
    {
        [validRaceDistances addObject:@"566"];
    }
    else if([trackID isEqualToString:@"TS"])    // Tri-State
    {
        [validRaceDistances addObject:@"550"];
        [validRaceDistances addObject:@"677"];
    }
    else if([trackID isEqualToString:@"TU"])    // Tucson
    {
        [validRaceDistances addObject:@"316"];
        [validRaceDistances addObject:@"566"];
    }
    else if([trackID isEqualToString:@"VG"])    // VictoryLand
    {
        [validRaceDistances addObject:@"566"];
    }
    else if([trackID isEqualToString:@"VL"])    // VictoryLand?
    {
        [validRaceDistances addObject:@"550"];
        [validRaceDistances addObject:@"661"];
    }
    else if([trackID isEqualToString:@"WD"])    // Wheeling
    {
        [validRaceDistances addObject:@"330"];
        [validRaceDistances addObject:@"548"];
        [validRaceDistances addObject:@"678"];
        [validRaceDistances addObject:@"761"];
    }
    else if([trackID isEqualToString:@"WO"])    // Wonderland
    {
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"681"];
    }
    else if([trackID isEqualToString:@"WS"])    // Woodlands
    {
        [validRaceDistances addObject:@"566"];
        [validRaceDistances addObject:@"678"];
    }
    else if([trackID isEqualToString:@"WT"])    // Wichita
    {
        [validRaceDistances addObject:@"550"];
    }
    
    return validRaceDistances;
}


- (BOOL)isThisLineDeclaredNoRace:(NSString*)firstLine
{
	NSString *modifiedFirstLine		= [self removeExtraSpacesFromString:firstLine];
	NSArray *words					= [modifiedFirstLine componentsSeparatedByString:@" "];
	NSString *lastWord				= [words objectAtIndex:words.count-1];
	NSString *nextToLastWord		= [words objectAtIndex:words.count-2];
	NSString *secondFromLastWord	= [words objectAtIndex:words.count-3];
	BOOL answer						= NO;
	
	if([secondFromLastWord isEqualToString:@"Declared"] && [nextToLastWord isEqualToString:@"No"] && [lastWord isEqualToString:@"Race"])
	{
		answer = YES;
	}
	
	return answer;
}

- (NSString*)getRaceClassStringFromSingleRaceString:(NSString*)singleRaceString
{
    NSArray *lineByline         = [singleRaceString componentsSeparatedByString:@"\n"];
    NSString *raceClassString   = [lineByline objectAtIndex:3];
    
    return raceClassString;
}

- (NSUInteger)getRaceDxIndexFromString:(NSString*)raceDxString
{
    NSUInteger raceDxIndex = kNoIndex;
    
    // Race Distances
    NSArray *validOneTurnRaceDistanceStrings     = [NSArray arrayWithObjects:@"301", @"313", @"330", @"350", nil];
    NSArray *validTwoTurnRaceDistanceStrings     = [NSArray arrayWithObjects:@"545", @"546", @"550", @"566", @"NC", nil];
    NSArray *validThreeTurnRaceDistanceStrings   = [NSArray arrayWithObjects:@"627", @"647", @"660", @"661", @"670",
                                                                        @"677", @"678", @"679", @"681", @"685", @"690", @"DC", nil];
    NSArray *validMarathonRaceDistanceStrings    = [NSArray arrayWithObjects:@"753", @"754", @"758", @"761", @"770", @"783", nil];
    
    if([validOneTurnRaceDistanceStrings containsObject:raceDxString])
    {
        raceDxIndex = 0;
    }
    else if([validTwoTurnRaceDistanceStrings containsObject:raceDxString])
    {
        raceDxIndex = 1;
    }
    else if([validThreeTurnRaceDistanceStrings containsObject:raceDxString])
    {
        raceDxIndex = 2;
    }
    else if([validMarathonRaceDistanceStrings containsObject:raceDxString])
    {
        raceDxIndex = 3;
    }
    
    return raceDxIndex;
}

- (void)modelTracks
{
    // add these tracks to
    [self getTracksStatsFromPopulationsPastLines];
	
    [ECMainController updateAndSaveData];
}


- (NSString*)getStringWithAllClassesAtTrackWithID:(NSString*)trackID
{
    NSString *raceClassesString = @"No Classes for this track";
    
    if([trackID isEqualToString:@"AB"])
    {
        raceClassesString = @"SCL M E D C TM TE TD TC S SD";
    }
    else if([trackID isEqualToString:@"BM"])
    {
        raceClassesString = @"SCL M J E D C B A T TM TE TD TC TB TA S SC SB SA";
    }
    else if([trackID isEqualToString:@"BR"])
    {
        raceClassesString = @"SCL M D C B A TM TD TC TB TA S SD SC SB SA";
    }
    else if([trackID isEqualToString:@"CA"])
    {
        raceClassesString = @"SCL M E D C B A AA TM TE TD TC TB TA S SC SB SA";
    }
    else if([trackID isEqualToString:@"CC"])
    {
        raceClassesString = @"SCL M J E D C B A T TM TE TD TC TB TA S SC SB SA";
    }
    else if([trackID isEqualToString:@"DB"])
    {
        raceClassesString = @"SCL M E D C B A T TM TE TD TC TB TA S SC SB SA";
    }
    else if([trackID isEqualToString:@"DP"])
    {
        raceClassesString = @"SCL M J E D C B A T TM TE TD TC TB TA S SC SB SA";
    }
    else if([trackID isEqualToString:@"DQ"])
    {
        raceClassesString = @"SCL M J E D C B A TM TJ TE TD TC TB TA S SD SC SB SA";
    }
    else if([trackID isEqualToString:@"EB"])
    {
        raceClassesString = @"SCL M J E D C B A T TM TE TD TC TB TA S SJ SD SC SB SA";
    }
    else if([trackID isEqualToString:@"FL"])
    {
        raceClassesString = @"SCL M D C B A T TD TC TB TA S SD SC SB SA";
    }
    else if([trackID isEqualToString:@"GG"])
    {
        raceClassesString = @"SCL M J D C B A AA TJ TE TD TC TB TA TAA S SC SB SA SAA";
    }
    else if([trackID isEqualToString:@"HI"])
    {
        raceClassesString = @"SCL E D C B A T TM TE TD TC TB TA";
    }
    else if([trackID isEqualToString:@"HO"])
    {
        raceClassesString = @"SCL M D C B A TM TD TC TB TA SD SC SB SA";
    }
    else if([trackID isEqualToString:@"JA"])
    {
        raceClassesString = @"SCL M D C B A T TM TA S";
    }
    else if([trackID isEqualToString:@"JC"])
    {
        raceClassesString = @"SCL M J E D C B A TM TJ TE TD TC TB TA SC SA";
    }
    else if([trackID isEqualToString:@"LI"])
    {
        raceClassesString = @"SCL M J D C B BB A AA T TM TJ TD TC TB TBB TA TAA S SJ SD SC SB SBB SA SAA";
    }
    else if([trackID isEqualToString:@"MB"])
    {
        raceClassesString = @"SCL M J D C B A AA T TM TE TD TC TB TA TAA S SC SB SA SAA";
    }
    else if([trackID isEqualToString:@"MG"])
    {
        raceClassesString = @"SCL M D C B A T TM TD TC TB TA S SD SC SB SA";
    }
    else if([trackID isEqualToString:@"MH"])
    {
        raceClassesString = @"SCL M D C B A AA TM TE TD TC TB TA TAA SC";
    }
    else if([trackID isEqualToString:@"MO"])
    {
        raceClassesString = @"SCL M E D C B A T TE TD TC TB TA S SD SC SB SA";
    }
    else if([trackID isEqualToString:@"NF"])
    {
        raceClassesString = @"SCL M E D C B A TM TE TD TC TB TA S SD SC SB SA";
    }
    else if([trackID isEqualToString:@"OP"])
    {
        raceClassesString = @"SCL M D C B A T TM TE TD TC TB TA S SD SC SB SA";
    }
    else if([trackID isEqualToString:@"OR"])
    {
        raceClassesString = @"SCL M E D C B A TM TE TD TC TB TA";
    }
    else if([trackID isEqualToString:@"PB"])
    {
        raceClassesString = @"SCL M J E D C B A AT T TM TJ TE TD TC TB TA S SJ SD SC SB SA";
    }
    else if([trackID isEqualToString:@"PE"])
    {
        raceClassesString = @"SCL M J E D C B A T TM TJ TE TD TC TB TA DT CT BT AT";
    }
    else if([trackID isEqualToString:@"PH"])
    {
        raceClassesString = @"SCL M J E D C B BB A AA T TM TJ TD TC TB TBB TA TAA S SC SB SBB SA SAA";
    }
    else if([trackID isEqualToString:@"PN"])
    {
        raceClassesString = @"SCL M E D C B A T TM TE TD TC TB TA";
    }
    else if([trackID isEqualToString:@"RT"])
    {
        raceClassesString = @"SCL M D C B A T TM TD TC TB TA S SD SC SB SA";
    }
    else if([trackID isEqualToString:@"SA"])
    {
        raceClassesString = @"SCL M E D C B A T TM TE TD TC TB TA S SD SC SB SA";
    }
    else if([trackID isEqualToString:@"SE"])
    {
        raceClassesString = @"SCL M J D C B A T TM TJ TE TD TC TB TA S SJ SD SC SB SA";
    }
    else if([trackID isEqualToString:@"SL"])
    {
        raceClassesString = @"SCL M J D C B A T TM TJ TD TC TB TA S SD SC SB SA SAA";
    }
    else if([trackID isEqualToString:@"SN"])
    {
        raceClassesString = @"SCL M J E D C B A T TM TE TD TC TB TA S SD SC SB SA";
    }
    else if([trackID isEqualToString:@"SO"])
    {
        raceClassesString = @"SCL M J E D C B A TM TJ TE TD TC TB TA SD SC SB SA";
    }
    else if([trackID isEqualToString:@"SP"])
    {
        raceClassesString = @"SCL M D C B A TM TD TC TB TA S SD SC SB SA";
    }
    else if([trackID isEqualToString:@"TP"])
    {
        raceClassesString = @"SCL M D C B A TM TD TC TB TA SA";
    }
    else if([trackID isEqualToString:@"TS"])
    {
        raceClassesString = @"SCL M D C B A AA T TM TD TC TB TA TAA S SD SC SB SA SAA";
    }
    else if([trackID isEqualToString:@"TU"])
    {
        raceClassesString = @"SCL M D C B A T TM TD TC TB TA SC SB SA";
    }
    else if([trackID isEqualToString:@"VG"])
    {
        raceClassesString = @"SCL M J D C B A AA TJ TE TD TC TB TA TAA SJ SD SC SB SA SAA";
    }
    else if([trackID isEqualToString:@"VL"])
    {
        raceClassesString = @"SCL M E D C B A T TE TD TC TB TA SD SC SB SA";
    }
    else if([trackID isEqualToString:@"WD"])
    {
        raceClassesString = @"SCL M D C B A AA T TJ TD TC TB TA TAA S SD SC SB SA SAA";
    }
    else if([trackID isEqualToString:@"WO"])
    {
        raceClassesString = @"SCL M J D C B A T TM TJ TD TC TB TA SA";
    }
    else if([trackID isEqualToString:@"WS"])
    {
        raceClassesString = @"SCL M E D C B A T TM TE TD TC TB TA DT CT BT AT SD SC SB SA";
    }
    else if([trackID isEqualToString:@"WT"])
    {
        raceClassesString = @"SCL M E D C B A T TM TE TD TC TB TA S SB SA";
    }
    
    return raceClassesString;
}

- (void)getTracksStatsFromPopulationsPastLines
{
//    NSString *pastLinesFolderPath = @"/Users/ronjurincie/Desktop/Project Ixtlan/Dogs/Small Sample Past Lines";
    
    NSString *pastLinesFolderPath = @"/Users/ronjurincie/Desktop/Project Ixtlan/Dogs/Past Lines";

    // Track IDs
    NSArray *modeledTracks = [NSArray arrayWithObjects: @"BM", @"BR", @"CA", @"DB", @"DP", @"DQ", @"EB", @"FL", @"GG",
                                                        @"HI", @"HO", @"JC", @"LI", @"MG", @"MH", @"MO", @"NF", @"OP",
                                                        @"OR", @"PB", @"PE", @"PH", @"PN", @"RT", @"SA", @"SE",
                                                        @"SL",@"SN", @"SO", @"SP", @"TP", @"TS", @"TU", @"VG", @"VL",
                                                        @"WD",@"WO", @"WS", @"WT", nil];
    
    
	NSUInteger arraySize = modeledTracks.count * kNumberRaceDistances * kNumberStatFields * kMaximumNumberEntries;
	
    // create the all encompasing ECTracks class
    ECTrackStats *tracks = [NSEntityDescription insertNewObjectForEntityForName:@"ECTracks"
                                                         inManagedObjectContext:MOC];
	
	double	statsAndCountersAccumulatorArray[arraySize * 2];
	
	// initialize accumulators to zero
	for(int index = 0; index < arraySize * 2; index++)
	{
		statsAndCountersAccumulatorArray[index]	= 0.0;
	}
    
	NSError *error = nil;
 
	NSFileManager *fileManager  = [NSFileManager defaultManager];
	NSArray *pastLineFiles      = [fileManager contentsOfDirectoryAtPath:pastLinesFolderPath
                                                                   error:&error];
	NSArray *combinedStatsAndCounterArray = nil;
    
	for(NSString *fileName in pastLineFiles)
	{
        // skip .DS_Store and ALL other . files
		if([fileName characterAtIndex:0] == '.')
        {
            continue;
        }
		      
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", pastLinesFolderPath, fileName];

        NSLog(@"%@", fileName);
        
        NSString *dogsRacehistory = [NSString stringWithContentsOfFile:filePath
                                                              encoding:NSStringEncodingConversionAllowLossy
                                                                 error:&error];
        
        // stats and counter array is 2X arraySize
        combinedStatsAndCounterArray = [self processEntriesPastLines:dogsRacehistory
                                                      forValidTracks:modeledTracks];
        
        // add to dxStatsAccumulatorArray
        for(NSUInteger i = 0; i < arraySize * 2; i++)
        {
            double accumulatedValueOrCounter    = [[combinedStatsAndCounterArray objectAtIndex:i] doubleValue];
            statsAndCountersAccumulatorArray[i] += accumulatedValueOrCounter;
        }
    }
    
    NSMutableOrderedSet *trackStatsOrderedSet = [NSMutableOrderedSet new];
    
    for(NSString *trackID in modeledTracks)
    {
        ECSprintRaceStats *sprintStats              = nil;
        ECTwoTurnRaceStats *twoTurnRaceStats        = nil;
        ECThreeTurnRaceStats *threeTurnRaceStats    = nil;
        ECMarathonRaceStats *marathonRaceStats      = nil;

        NSUInteger trackIdIndex     = [modeledTracks indexOfObject:trackID];
        ECTrackStats *newTrackStats = [NSEntityDescription insertNewObjectForEntityForName:@"ECTrackStats"
                                                                    inManagedObjectContext:MOC];
        
        NSLog(@"Track:%@ => Sprint Race", trackID);
        
        if([self isThisDistanceIndex:kSprintRace
               modeledForTrackWithID:trackID] == YES)
        {
            sprintStats = (ECSprintRaceStats*)[self getStatsForTrackWithIndex:trackIdIndex
                                                             withTrackIdArray:modeledTracks
                                                              forRaceDistance:kSprintRace
                                                                    fromArray:&statsAndCountersAccumulatorArray[0]
                                                                withArraySize:arraySize];
        }
        
        NSLog(@"Track:%@ => 2 Turn Race", trackID);
        
        if([self isThisDistanceIndex:kTwoTurnRace
               modeledForTrackWithID:trackID] == YES)
        {
            twoTurnRaceStats = (ECTwoTurnRaceStats*)[self getStatsForTrackWithIndex:trackIdIndex
                                                                   withTrackIdArray:modeledTracks
                                                                    forRaceDistance:kTwoTurnRace
                                                                          fromArray:&statsAndCountersAccumulatorArray[0]
                                                                      withArraySize:arraySize];
        }
        
        NSLog(@"Track:%@ => 3 Turn Race", trackID);
        
        if([self isThisDistanceIndex:kThreeTurnRace
               modeledForTrackWithID:trackID] == YES)
        {
            threeTurnRaceStats = (ECThreeTurnRaceStats*)[self getStatsForTrackWithIndex:trackIdIndex
                                                                       withTrackIdArray:modeledTracks
                                                                        forRaceDistance:kThreeTurnRace
                                                                              fromArray:&statsAndCountersAccumulatorArray[0]
                                                                          withArraySize:arraySize];
        }
        
        NSLog(@"Track:%@ => 2 Marathon Race", trackID);
        
        if([self isThisDistanceIndex:kMarathonRace
               modeledForTrackWithID:trackID] == YES)
        {
            marathonRaceStats = (ECMarathonRaceStats*)[self getStatsForTrackWithIndex:trackIdIndex
                                                                     withTrackIdArray:modeledTracks
                                                                      forRaceDistance:kMarathonRace
                                                                            fromArray:&statsAndCountersAccumulatorArray[0]
                                                                        withArraySize:arraySize];
        }
        
        newTrackStats.sprintRaceStats       = sprintStats;
        newTrackStats.twoTurnRaceStats      = twoTurnRaceStats;
        newTrackStats.threeTurnRaceStats    = threeTurnRaceStats;
        newTrackStats.marathonRaceStats     = marathonRaceStats;
        
        double sprintRecordTime         = [self getBestTimeForRaceDistanceIndex:kSprintRace
                                                                  atTrackWithId:trackID];
        double twoTurnRecordTime        = [self getBestTimeForRaceDistanceIndex:kTwoTurnRace
                                                                  atTrackWithId:trackID];
        double threeTurnRecordTime      = [self getBestTimeForRaceDistanceIndex:kThreeTurnRace
                                                                  atTrackWithId:trackID];
        double marathonRaceRecordTime   = [self getBestTimeForRaceDistanceIndex:kMarathonRace
                                                                  atTrackWithId:trackID];

        newTrackStats.sprintRaceRecordTime      = [NSNumber numberWithDouble:sprintRecordTime];
        newTrackStats.twoTurnRaceRecordTime     = [NSNumber numberWithDouble:twoTurnRecordTime];
        newTrackStats.threeTurnRaceRecordTime   = [NSNumber numberWithDouble:threeTurnRecordTime];
        newTrackStats.marathonRaceRecordTime    = [NSNumber numberWithDouble:marathonRaceRecordTime];
        
        newTrackStats.trackName         = [self getTrackNameFromTrackId:trackID];
        newTrackStats.validRaceClasses  = [self getStringWithAllClassesAtTrackWithID:trackID];
        
        [trackStatsOrderedSet addObject:newTrackStats];
    }
}

- (BOOL)isThisDistanceIndex:(NSUInteger)raceDistanceIndex
      modeledForTrackWithID:(NSString*)trackID
{
    BOOL thisDistanceIsModeledAtThisTrack = NO;
    
    NSArray *modeledRaceDistances = [self getModeledRaceDistancesForTrackWithID:trackID];
    
    for(NSUInteger distanceNumber = 0; distanceNumber < modeledRaceDistances.count; distanceNumber++)
    {
        NSUInteger testDistance = [[modeledRaceDistances objectAtIndex:distanceNumber] integerValue];
        NSUInteger testIndex    = [self getRaceDxIndexFromString:[NSString stringWithFormat:@"%lu", testDistance]];
        
        if(testIndex == raceDistanceIndex)
        {
            thisDistanceIsModeledAtThisTrack = YES;
            break;
        }
    }
    
    return thisDistanceIsModeledAtThisTrack;
}

- (void)printTwinNonZeroValuesWithIndicesInCArray:(double*)cArray
                                       ofSize:(NSUInteger)arraySize
{
    for(int i = 0; i < arraySize; i++)
    {
        double value    = cArray[i];
        double count    = cArray[i + arraySize];

        if(value > 0 || count > 0)
        {
            if(count > 0)
            {
                double average = value / count;
                
                NSLog(@"[%i]%lf   [%i]%lf     average:%lf", i, value, i, count, average);
            }
            else
            {
                NSLog(@"[%i]%lf   [%i]%lf     average:---", i, value, i, count);
            }
        }
    }
}

- (NSString*)getTrackNameFromTrackId:(NSString*)trackID
{
    NSString *trackName = nil;
    
    if([trackID isEqualToString:@"BM"])
    {
        trackName = @"Birmingham Race Course";
    }
    else if([trackID isEqualToString:@"BR"])
    {
        trackName = @"Bluff's Run Greyhound Park";
    }
    else if([trackID isEqualToString:@"CA"])
    {
        trackName = @"Caliente Greyhound Racetrack";
    }
    else if([trackID isEqualToString:@"DB"])
    {
        trackName = @"Daytona Beach Kennel Club";
    }
    else if([trackID isEqualToString:@"DP"])
    {
        trackName = @"Dairyland Greyhound Park";
    }
    else if([trackID isEqualToString:@"DQ"])
    {
        trackName = @"Dubuque Greyhound Park";
    }
    else if([trackID isEqualToString:@"EB"])
    {
        trackName = @"Ebro Greyhound Park";
    }
    else if([trackID isEqualToString:@"FL"])
    {
        trackName = @"Flagler Kennel Club";
    }
    else if([trackID isEqualToString:@"GG"])
    {
        trackName = @"Gulf Greyhound Park";
    }
    else if([trackID isEqualToString:@"HI"])
    {
        trackName = @"Hinsdale Greyhound Park";
    }
    else if([trackID isEqualToString:@"HO"])
    {
        trackName = @"Hollywood Greyhound Track";
    }
    else if([trackID isEqualToString:@"JC"])
    {
        trackName = @"Jefferson County Kennel Club";
    }
    else if([trackID isEqualToString:@"LI"])
    {
        trackName = @"Lincoln Greyhound Park";
    }
    else if([trackID isEqualToString:@"MG"])
    {
        trackName = @"Mardi Gras";
    }
    else if([trackID isEqualToString:@"MH"])
    {
        trackName = @"Mile High Greyhound Park";
    }
    else if([trackID isEqualToString:@"MO"])
    {
        trackName = @"Mobile Greyhound Park";
    }
    else if([trackID isEqualToString:@"NF"])
    {
        trackName = @"Naples / Ft. Meyers Greyhound Park";
    }
    else if([trackID isEqualToString:@"OR"])
    {
        trackName = @"Unknown";
    }
    else if([trackID isEqualToString:@"PB"])
    {
        trackName = @"Palm Beach Kennel Club";
    }
    else if([trackID isEqualToString:@"PE"])
    {
        trackName = @"Pensacola Greyhound Park";
    }
    else if([trackID isEqualToString:@"PH"])
    {
        trackName = @"Phoenix Greyhound Park";
    }
    else if([trackID isEqualToString:@"PN"])
    {
        trackName = @"Unknown";
    }
    else if([trackID isEqualToString:@"RT"])
    {
        trackName = @"Raynham-Taunton Greyhound Park";
    }
    else if([trackID isEqualToString:@"SA"])
    {
        trackName = @"Sarasota Kennel Club";
    }
    else if([trackID isEqualToString:@"SE"])
    {
        trackName = @"Unknown";
    }
    else if([trackID isEqualToString:@"SL"])
    {
        trackName = @"Southland Greyhound Park";
    }
    else if([trackID isEqualToString:@"SN"])
    {
        trackName = @"Unknown";
    }
    else if([trackID isEqualToString:@"SO"])
    {
        trackName = @"Sanford-Orlando Kennel Club";
    }
    else if([trackID isEqualToString:@"SP"])
    {
        trackName = @"Derby Lane Kennel Club";
    }
    else if([trackID isEqualToString:@"TP"])
    {
        trackName = @"Tampa Greyhound Park";
    }
    else if([trackID isEqualToString:@"TS"])
    {
        trackName = @"Tri-State Greyhound Park";
    }
    else if([trackID isEqualToString:@"TU"])
    {
        trackName = @"Tucson Greyhound Park";
    }
    else if([trackID isEqualToString:@"VG"])
    {
        trackName = @"Victoryland Greyhound Park";
    }
    else if([trackID isEqualToString:@"VL"])
    {
        trackName = @"Unknown";
    }
    else if([trackID isEqualToString:@"WD"])
    {
        trackName = @"Wheeling Downs";
    }
    else if([trackID isEqualToString:@"WO"])
    {
        trackName = @"Wonderland";
    }
    else if([trackID isEqualToString:@"WS"])
    {
        trackName = @"Woodlands Kennel Club";
    }
    else if([trackID isEqualToString:@"WT"])
    {
        trackName = @"Wichata?";
    }
    else if([trackID isEqualToString:@"VG"])
    {
        trackName = @"Victoryland Greyhound Park";
    }
    else
    {
        trackName = nil;
    }
 
    return trackName;
}

- (double)getBestTimeForRaceDistanceIndex:(NSUInteger)raceDxIndex
                            atTrackWithId:(NSString*)trackID
{
    double recordTime = 0.00;
    
    switch (raceDxIndex)
    {
        case 0:
        {
            if([trackID isEqualToString:@"AB"])
            {
                recordTime = 17.37;
            }
            else if([trackID isEqualToString:@"BR"])
            {
                recordTime = 17.54;
            }
            else if([trackID isEqualToString:@"DP"])
            {
                recordTime = 17.23;
            }
            else if([trackID isEqualToString:@"DQ"])
            {
                recordTime = 17.41;
            }
            else if([trackID isEqualToString:@"FL"])
            {
                recordTime = 18.42;
            }
            else if([trackID isEqualToString:@"GG"])
            {
                recordTime = 17.02;
            }
            else if([trackID isEqualToString:@"NF"])
            {
                recordTime = 16.66;
            }
            else if([trackID isEqualToString:@"OP"])
            {
                recordTime = 17.61;
            }
            else if([trackID isEqualToString:@"PB"])
            {
                recordTime = 16.38;
            }
            else if([trackID isEqualToString:@"PH"])
            {
                recordTime = 17.37;
            }
            else if([trackID isEqualToString:@"SO"])
            {
                recordTime = 16.59;
            }
            else if([trackID isEqualToString:@"SA"])
            {
                recordTime = 17.85;
            }
            else if([trackID isEqualToString:@"SL"])
            {
                recordTime = 17.60;
            }
            else if([trackID isEqualToString:@"TU"])
            {
                recordTime = 17.70;
            }
                
            break;
        }
            
        case 1:
        {
            if([trackID isEqualToString:@"AB"])
            {
                recordTime = 29.61;
            }
            else if([trackID isEqualToString:@"AP"])
            {
                recordTime = 30.01;
            }
            else if([trackID isEqualToString:@"BM"])
            {
                recordTime = 29.92;
            }
            else if([trackID isEqualToString:@"BR"])
            {
                recordTime = 29.33;
            }
            else if([trackID isEqualToString:@"DP"])
            {
                recordTime = 29.70;
            }
            else if([trackID isEqualToString:@"DB"])
            {
                recordTime = 30.00;
            }
            else if([trackID isEqualToString:@"SP"])
            {
                recordTime = 29.59;
            }
            else if([trackID isEqualToString:@"DQ"])
            {
                recordTime = 29.83;
            }
            else if([trackID isEqualToString:@"EB"])
            {
                recordTime = 29.89;
            }
            else if([trackID isEqualToString:@"FL"])
            {
                recordTime = 31.17;
            }
            else if([trackID isEqualToString:@"GG"])
            {
                recordTime = 29.42;
            }
            else if([trackID isEqualToString:@"JC"])
            {
                recordTime = 30.01;
            }
            else if([trackID isEqualToString:@"MG"])
            {
                recordTime = 29.64;
            }
            else if([trackID isEqualToString:@"MO"])
            {
                recordTime = 29.92;
            }
            else if([trackID isEqualToString:@"NF"])
            {
                recordTime = 29.54;
            }
            else if([trackID isEqualToString:@"OP"])
            {
                recordTime = 30.01;
            }
            else if([trackID isEqualToString:@"PB"])
            {
                recordTime = 29.01;
            }
            else if([trackID isEqualToString:@"PE"])
            {
                recordTime = 29.78;
            }
            else if([trackID isEqualToString:@"PH"])
            {
                recordTime = 29.54;
            }
            else if([trackID isEqualToString:@"SO"])
            {
                recordTime = 29.99;
            }
            else if([trackID isEqualToString:@"SA"])
            {
                recordTime = 29.97;
            }
            else if([trackID isEqualToString:@"SL"])
            {
                recordTime = 31.14;
            }
            else if([trackID isEqualToString:@"TS"])
            {
                recordTime = 29.61;
            }
            else if([trackID isEqualToString:@"TU"])
            {
                recordTime = 29.92;
            }
            else if([trackID isEqualToString:@"VG"])
            {
                recordTime = 30.02;
            }
            else if([trackID isEqualToString:@"WD"])
            {
                recordTime = 29.06;
            }
            
            break;
        }
            
        case kThreeTurnRace:
        {
            if([trackID isEqualToString:@"AP"])
            {
                recordTime = 38.39;
            }
            else if([trackID isEqualToString:@"BM"])
            {
                recordTime = 38.14;
            }
            else if([trackID isEqualToString:@"BR"])
            {
                recordTime = 37.96;
            }
            else if([trackID isEqualToString:@"DP"])
            {
                recordTime = 37.25;
            }
            else if([trackID isEqualToString:@"DB"])
            {
                recordTime = 37.07;
            }
            else if([trackID isEqualToString:@"SP"])
            {
                recordTime = 36.53;
            }
            else if([trackID isEqualToString:@"DQ"])
            {
                recordTime = 37.77;
            }
            else if([trackID isEqualToString:@"EB"])
            {
                recordTime = 35.90;
            }
            else if([trackID isEqualToString:@"FL"])
            {
                recordTime = 36.45;
            }
            else if([trackID isEqualToString:@"GG"])
            {
                recordTime = 36.26;
            }
            else if([trackID isEqualToString:@"JC"])
            {
                recordTime = 38.00;
            }
            else if([trackID isEqualToString:@"MG"])
            {
                recordTime = 36.43;
            }
            else if([trackID isEqualToString:@"MO"])
            {
                recordTime = 37.26;
            }
            else if([trackID isEqualToString:@"NF"])
            {
                recordTime = 37.44;
            }
            else if([trackID isEqualToString:@"OP"])
            {
                recordTime = 36.73;
            }
            else if([trackID isEqualToString:@"PB"])
            {
                recordTime = 37.29;
            }
            else if([trackID isEqualToString:@"PE"])
            {
                recordTime = 38.23;
            }
            else if([trackID isEqualToString:@"PH"])
            {
                recordTime = 38.13;
            }
            else if([trackID isEqualToString:@"SO"])
            {
                recordTime = 37.48;
            }
            else if([trackID isEqualToString:@"SA"])
            {
                recordTime = 37.20;
            }
            else if([trackID isEqualToString:@"SL"])
            {
                recordTime = 36.14;
            }
            else if([trackID isEqualToString:@"TS"])
            {
                recordTime = 37.62;
            }
            else if([trackID isEqualToString:@"TU"])
            {
                recordTime = 38.07;
            }
            else if([trackID isEqualToString:@"VG"])
            {
                recordTime = 38.62;
            }
            else if([trackID isEqualToString:@"WD"])
            {
                recordTime = 37.05;
            }
            
            break;
        }
            
        case kMarathonRace:
        {
            if([trackID isEqualToString:@"DP"])
            {
                recordTime = 43.47;
            }
            else if([trackID isEqualToString:@"DQ"])
            {
                recordTime = 42.98;
            }
            else if([trackID isEqualToString:@"EB"])
            {
                recordTime = 43.03;
            }
            else if([trackID isEqualToString:@"FL"])
            {
                recordTime = 44.52;
            }
            else if([trackID isEqualToString:@"GG"])
            {
                recordTime = 43.16;
            }
            else if([trackID isEqualToString:@"MG"])
            {
                recordTime = 42.57;
            }
            else if([trackID isEqualToString:@"NF"])
            {
                recordTime = 42.41;
            }
            else if([trackID isEqualToString:@"OP"])
            {
                recordTime = 43.27;
            }
            else if([trackID isEqualToString:@"PB"])
            {
                recordTime = 41.47;
            }
            else if([trackID isEqualToString:@"PE"])
            {
                recordTime = 42.96;
            }
            else if([trackID isEqualToString:@"PH"])
            {
                recordTime = 42.23;
            }
            else if([trackID isEqualToString:@"SO"])
            {
                recordTime = 42.35;
            }
            else if([trackID isEqualToString:@"SA"])
            {
                recordTime = 43.41;
            }
            else if([trackID isEqualToString:@"SL"])  // 820 yards
            {
                recordTime = 46.09;
            }
            else if([trackID isEqualToString:@"TS"])
            {
                recordTime = 43.15;
            }
            else if([trackID isEqualToString:@"WD"])
            {
                recordTime = 41.85;
            }
            
            break;
        }
    
        default:
            break;
    }
    
    return recordTime;
}


- (BOOL)isThisFallWord:(NSString*)testWord
{
    BOOL answer = NO;
    
    if([[testWord uppercaseString] isEqualToString:@"X"]     ||
       [[testWord uppercaseString] isEqualToString:@"DNF"]   ||
       [[testWord uppercaseString] isEqualToString:@"OOP"]   ||
       [[testWord uppercaseString] isEqualToString:@"FL"]    ||
       [[testWord uppercaseString] isEqualToString:@"FL "]   ||
       [[testWord uppercaseString] isEqualToString:@"F"]     ||
       [[testWord uppercaseString] isEqualToString:@"FELL"]  ||
       [[testWord uppercaseString] isEqualToString:@"FEL"]   ||
       [testWord isEqualToString:@"0"]   ||
       [testWord isEqualToString:@"bmp"] ||
       [testWord isEqualToString:@"0"] ||
       [testWord isEqualToString:@"."])
    {
        answer = YES;
    }
    
    return answer;
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



- (id)getStatsForTrackWithIndex:(NSUInteger)trackIdIndex
               withTrackIdArray:(NSArray*)trackIdArray
                forRaceDistance:(NSUInteger)raceDistanceIndex
                      fromArray:(double*)statsAndCounterAccumulatorArrray
                  withArraySize:(NSUInteger)arraySize

{
    id returnStatsResults = nil;
    
    double counterValue = 0;
	double statValue    = 0.0;
	double breakPositionAverageFromTrapPosition     = 0.0;
	double firstTurnPositionAverageFromTrapPosition = 0.0;
	double finalPositionAverageFromTrapPosition     = 0.0;
    double firstTurnPositionAverageFromBreak        = 0.0;
    double farTurnPositionAverageFromFirstTurn      = 0.0;
    double finalPositionAverageFromFarTurn          = 0.0;
	double finalPositionAverageFromTurn             = 0.0;
    
    NSOrderedSet *workingPostStats          = nil;
    NSOrderedSet *workingBreakStats         = nil;
    NSOrderedSet *workingFirstTurnStats     = nil;
    NSOrderedSet *workingFarTurnStats       = nil;
    NSOrderedSet *workingSprintTurnStats    = nil;
  
    ECPostStats *postStats_1 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
    ECPostStats *postStats_2 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
    ECPostStats *postStats_3 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
    ECPostStats *postStats_4 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
    ECPostStats *postStats_5 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
    ECPostStats *postStats_6 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
    ECPostStats *postStats_7 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
    ECPostStats *postStats_8 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
    ECPostStats *postStats_9 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];

    ECBreakStats *breakStats_1 = [NSEntityDescription insertNewObjectForEntityForName:@"ECBreakStats" inManagedObjectContext:MOC];
    ECBreakStats *breakStats_2 = [NSEntityDescription insertNewObjectForEntityForName:@"ECBreakStats" inManagedObjectContext:MOC];
    ECBreakStats *breakStats_3 = [NSEntityDescription insertNewObjectForEntityForName:@"ECBreakStats" inManagedObjectContext:MOC];
    ECBreakStats *breakStats_4 = [NSEntityDescription insertNewObjectForEntityForName:@"ECBreakStats" inManagedObjectContext:MOC];
    ECBreakStats *breakStats_5 = [NSEntityDescription insertNewObjectForEntityForName:@"ECBreakStats" inManagedObjectContext:MOC];
    ECBreakStats *breakStats_6 = [NSEntityDescription insertNewObjectForEntityForName:@"ECBreakStats" inManagedObjectContext:MOC];
    ECBreakStats *breakStats_7 = [NSEntityDescription insertNewObjectForEntityForName:@"ECBreakStats" inManagedObjectContext:MOC];
    ECBreakStats *breakStats_8 = [NSEntityDescription insertNewObjectForEntityForName:@"ECBreakStats" inManagedObjectContext:MOC];
    ECBreakStats *breakStats_9 = [NSEntityDescription insertNewObjectForEntityForName:@"ECBreakStats" inManagedObjectContext:MOC];

    ECFirstTurnStats *firstTurnPos_1 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
    ECFirstTurnStats *firstTurnPos_2 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
    ECFirstTurnStats *firstTurnPos_3 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
    ECFirstTurnStats *firstTurnPos_4 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
    ECFirstTurnStats *firstTurnPos_5 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
    ECFirstTurnStats *firstTurnPos_6 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
    ECFirstTurnStats *firstTurnPos_7 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
    ECFirstTurnStats *firstTurnPos_8 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
    ECFirstTurnStats *firstTurnPos_9 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFirstTurnStats" inManagedObjectContext:MOC];
    
    ECFarTurnStats *farTurnPos_1 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFarTurnStats" inManagedObjectContext:MOC];
    ECFarTurnStats *farTurnPos_2 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFarTurnStats" inManagedObjectContext:MOC];
    ECFarTurnStats *farTurnPos_3 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFarTurnStats" inManagedObjectContext:MOC];
    ECFarTurnStats *farTurnPos_4 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFarTurnStats" inManagedObjectContext:MOC];
    ECFarTurnStats *farTurnPos_5 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFarTurnStats" inManagedObjectContext:MOC];
    ECFarTurnStats *farTurnPos_6 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFarTurnStats" inManagedObjectContext:MOC];
    ECFarTurnStats *farTurnPos_7 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFarTurnStats" inManagedObjectContext:MOC];
    ECFarTurnStats *farTurnPos_8 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFarTurnStats" inManagedObjectContext:MOC];
    ECFarTurnStats *farTurnPos_9 = [NSEntityDescription insertNewObjectForEntityForName:@"ECFarTurnStats" inManagedObjectContext:MOC];
    
    NSArray *postStats = [NSArray arrayWithObjects:postStats_1, postStats_2, postStats_3, postStats_4, postStats_5,
                                                    postStats_6, postStats_7, postStats_8, postStats_9, nil];

    NSArray *breakStats = [NSArray arrayWithObjects:breakStats_1, breakStats_2, breakStats_3, breakStats_4, breakStats_5,
                                                    breakStats_6, breakStats_7, breakStats_8, breakStats_9, nil];
    
    NSArray *firstTurnStats = [NSArray arrayWithObjects:firstTurnPos_1, firstTurnPos_2, firstTurnPos_3, firstTurnPos_4, firstTurnPos_5,
                                                        firstTurnPos_6, firstTurnPos_7, firstTurnPos_8, firstTurnPos_9, nil];
    
    NSArray *farTurnStats = [NSArray arrayWithObjects:farTurnPos_1, farTurnPos_2, farTurnPos_3, farTurnPos_4, farTurnPos_5,
                                                        farTurnPos_6, farTurnPos_7, farTurnPos_8, farTurnPos_9, nil];
    
    switch (raceDistanceIndex)
    {
        // Note: Even though Birmingham DOES have a stat for farTurns, we IGNORE this here
        case kSprintRace:
        {
            ECSprintRaceStats *sprintRaceStats = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintRaceStats" inManagedObjectContext:MOC];
            
            ECSprintTurnStats *sprintTurnStats_1 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
            ECSprintTurnStats *sprintTurnStats_2 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
            ECSprintTurnStats *sprintTurnStats_3 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
            ECSprintTurnStats *sprintTurnStats_4 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
            ECSprintTurnStats *sprintTurnStats_5 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
            ECSprintTurnStats *sprintTurnStats_6 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
            ECSprintTurnStats *sprintTurnStats_7 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
            ECSprintTurnStats *sprintTurnStats_8 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
            ECSprintTurnStats *sprintTurnStats_9 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
            
            NSArray *turnStatsSprint = [NSArray arrayWithObjects:sprintTurnStats_1, sprintTurnStats_2, sprintTurnStats_3, sprintTurnStats_4, sprintTurnStats_5,
                                        sprintTurnStats_6, sprintTurnStats_7, sprintTurnStats_8, sprintTurnStats_9, nil];
    
            sprintRaceStats.postStats       = [[NSOrderedSet alloc] initWithArray:postStats];
            sprintRaceStats.breakStats      = [[NSOrderedSet alloc] initWithArray:breakStats];
            sprintRaceStats.sprintTurnStats = [[NSOrderedSet alloc] initWithArray:turnStatsSprint];
            
            workingPostStats        = sprintRaceStats.postStats;
            workingBreakStats       = sprintRaceStats.breakStats;
            workingSprintTurnStats  = sprintRaceStats.sprintTurnStats;
            returnStatsResults      = sprintRaceStats;
           
            break;
        }
      
        case kTwoTurnRace:
        {
            ECTwoTurnRaceStats *twoTurnRaceStats = [NSEntityDescription insertNewObjectForEntityForName:@"ECTwoTurnRaceStats" inManagedObjectContext:MOC];
        
            twoTurnRaceStats.postStats      = [[NSOrderedSet alloc] initWithArray:postStats];
            twoTurnRaceStats.breakStats     = [[NSOrderedSet alloc] initWithArray:breakStats];
            twoTurnRaceStats.firstTurnStats = [[NSOrderedSet alloc] initWithArray:firstTurnStats];
            twoTurnRaceStats.farTurnStats   = [[NSOrderedSet alloc] initWithArray:farTurnStats];
            
            workingPostStats        = twoTurnRaceStats.postStats;
            workingBreakStats       = twoTurnRaceStats.breakStats;
            workingFirstTurnStats   = twoTurnRaceStats.firstTurnStats;
            workingFarTurnStats     = twoTurnRaceStats.farTurnStats;
            returnStatsResults      = twoTurnRaceStats;
           
            break;
        }
       
        case kThreeTurnRace:
        {
            ECThreeTurnRaceStats *threeTurnRaceStats = [NSEntityDescription insertNewObjectForEntityForName:@"ECThreeTurnRaceStats" inManagedObjectContext:MOC];
            
            threeTurnRaceStats.postStats        = [[NSOrderedSet alloc] initWithArray:postStats];
            threeTurnRaceStats.breakStats       = [[NSOrderedSet alloc] initWithArray:breakStats];
            threeTurnRaceStats.firstTurnStats   = [[NSOrderedSet alloc] initWithArray:firstTurnStats];
            threeTurnRaceStats.farTurnStats     = [[NSOrderedSet alloc] initWithArray:farTurnStats];
           
            workingPostStats        = threeTurnRaceStats.postStats;
            workingBreakStats       = threeTurnRaceStats.breakStats;
            workingFirstTurnStats   = threeTurnRaceStats.firstTurnStats;
            workingFarTurnStats     = threeTurnRaceStats.farTurnStats;
            returnStatsResults      = threeTurnRaceStats;
           
            break;
        }
       
        case kMarathonRace:
        {
            ECMarathonRaceStats *marathonRaceStats = [NSEntityDescription insertNewObjectForEntityForName:@"ECMarathonRaceStats" inManagedObjectContext:MOC];
     
            marathonRaceStats.postStats         = [[NSOrderedSet alloc] initWithArray:postStats];
            marathonRaceStats.breakStats        = [[NSOrderedSet alloc] initWithArray:breakStats];
            marathonRaceStats.firstTurnStats    = [[NSOrderedSet alloc] initWithArray:firstTurnStats];
            marathonRaceStats.farTurnStats      = [[NSOrderedSet alloc] initWithArray:farTurnStats];
            
            workingBreakStats       = marathonRaceStats.postStats;
            workingBreakStats       = marathonRaceStats.breakStats;
            workingFirstTurnStats   = marathonRaceStats.firstTurnStats;
            workingFarTurnStats     = marathonRaceStats.farTurnStats;
            returnStatsResults      = marathonRaceStats;
            
            break;
        }
            
        default:
            break;
    }
    
    // calculate and assign average values for each post
    for(NSUInteger position = 1; position <= kMaximumNumberEntries; position++)
    {
        for(NSUInteger statFieldNumber = 0; statFieldNumber < kNumberStatFields; statFieldNumber++)
        {
            NSUInteger index = [self getIndexForTrackIndex:trackIdIndex
                                       atRaceDistanceIndex:raceDistanceIndex
                                        forStatFieldNumber:statFieldNumber
                                              withPosition:position];
            statValue       = statsAndCounterAccumulatorArrray[index];
            counterValue    = statsAndCounterAccumulatorArrray[index + arraySize];
            
            if((counterValue == 0.00 && statValue > 0.0) || (counterValue > 0.0 && statValue == 0.0))
            {
                NSLog(@"data error 1a");
                continue;
            }
            else if(counterValue == 0.0)
            {
                NSLog(@"data error 2a");
                continue;
            }
            
            if(raceDistanceIndex == kSprintRace)
            {
                switch (statFieldNumber)
                {
                    case kBreakPositionFromTrapPositionStatField:
                       
                        breakPositionAverageFromTrapPosition = statValue / counterValue;
                        
                        NSLog(@"Trap Position:%lu Count:%lf => breakPositionAverageFromTrapPosition:%lf", position, counterValue, breakPositionAverageFromTrapPosition);
                        break;
                        
                        
                    case kFirstTurnPositionFromTrapPositionStatField:
                        firstTurnPositionAverageFromTrapPosition = statValue / counterValue;
                        
                        NSLog(@"Trap Position:%lu Count:%lf => firstTurnPositionAverageFromTrapPosition:%lf", position, counterValue, firstTurnPositionAverageFromTrapPosition);
                        break;
                        
                        
                    case kFinalPositionFromTrapPositionStatField:
                        finalPositionAverageFromTrapPosition = statValue / counterValue;
                        
                        NSLog(@"Trap Position:%lu Count:%lf => finalPositionAverageFromTrapPosition:%lf", position, counterValue, finalPositionAverageFromTrapPosition);
                        break;
                        
                        
                    case kFirstTurnPositionFromBreakStatField:
                        firstTurnPositionAverageFromBreak = statValue / counterValue;
                        
                        NSLog(@"Break Position:%lu Count:%lf => firstTurnPositionAverageFromBreak:%lf", position, counterValue, firstTurnPositionAverageFromBreak);
                        break;
                        
                    case kFarTurnPositionFromFirstTurnStatField:
                        farTurnPositionAverageFromFirstTurn = 0.0;
                        break;
                        
                    case 5:
                        finalPositionAverageFromTurn = statValue / counterValue;
                        NSLog(@"Turn Position:%lu Count:%lf => finalPositionAverageFromTurn:%lf", position, counterValue, finalPositionAverageFromTurn);
                        break;
                    
                    default:
                        break;
                }
            }
            else
            {
                switch (statFieldNumber)
                {
                    case kBreakPositionFromTrapPositionStatField:
                        
                        breakPositionAverageFromTrapPosition = statValue / counterValue;
                        
                        NSLog(@"Trap Position:%lu Count:%lf => breakPositionAverageFromTrapPosition:%lf", position, counterValue, breakPositionAverageFromTrapPosition);
                        
                        break;
                        
                    case kFirstTurnPositionFromTrapPositionStatField:
                        
                        firstTurnPositionAverageFromTrapPosition = statValue / counterValue;
                        
                        NSLog(@"Trap Position:%lu Count:%lf => firstTurnPositionAverageFromTrapPosition:%lf", position, counterValue, firstTurnPositionAverageFromTrapPosition);
                        break;
                        
                    case kFinalPositionFromTrapPositionStatField:
                        
                        finalPositionAverageFromTrapPosition = statValue / counterValue;
                        
                        NSLog(@"Trap Position:%lu Count:%lf => finalPositionAverageFromTrapPosition:%lf", position, counterValue, finalPositionAverageFromTrapPosition);
                        
                        break;
                        
                    case kFirstTurnPositionFromBreakStatField:
                        
                        firstTurnPositionAverageFromBreak = statValue / counterValue;
                        
                        NSLog(@"Break Position:%lu Count:%lf => firstTurnPositionAverageFromBreak:%lf", position, counterValue, firstTurnPositionAverageFromBreak);
                        
                        break;
                        
                    case kFarTurnPositionFromFirstTurnStatField:
                        
                        if((counterValue == 0.00 && statValue > 0.0) || (counterValue > 0.0 && statValue == 0.0))
                        {
                            NSLog(@"data error 1f");
                            break;
                        }
                        else if(counterValue == 0.0)
                        {
                            NSLog(@"data error 2f");
                            break;
                        }
                        
                        farTurnPositionAverageFromFirstTurn = statValue / counterValue;
                        
                        NSLog(@"First Turn Position:%lu Count:%lf => farTurnPositionAverageFromFirstTurn:%lf", position, counterValue, farTurnPositionAverageFromFirstTurn);
                    
                        break;
                        
                    case kFinalPositionFromFarTurnStatField:
                        // Final From Far
                        finalPositionAverageFromFarTurn = statValue / counterValue;
                        
                        NSLog(@"Far Turn Position:%lu Count:%lf => finalPositionAverageFromFarTurn:%lf", position, counterValue, finalPositionAverageFromFarTurn);
                        
                        break;
                        
                    default:
                        break;
                }
            }
        }
        
        //////////////////////////////////////////////////////////////
        // set values for this post at this distance for this track //
        //////////////////////////////////////////////////////////////
        
        // all race distances have postStats
        ECPostStats *thesePostStats             = [workingPostStats objectAtIndex:position - 1];
        thesePostStats.boxNumber                = [NSNumber numberWithInteger:position];
        thesePostStats.breakPositionAverage		= [NSNumber numberWithDouble:breakPositionAverageFromTrapPosition];
        thesePostStats.firstTurnPositionAverage	= [NSNumber numberWithDouble:firstTurnPositionAverageFromTrapPosition];
        thesePostStats.finalPositionAverage		= [NSNumber numberWithFloat:finalPositionAverageFromTrapPosition];
        
        // all race distances have breakStats
        ECBreakStats *theseBreakStats               = [workingBreakStats objectAtIndex:position - 1];
        theseBreakStats.breakPosition               = [NSNumber numberWithInteger:position];
        theseBreakStats.firstTurnPositionAverage    = [NSNumber numberWithDouble:firstTurnPositionAverageFromBreak];
        
        // may or may not use next 3
        ECSprintTurnStats *theseSprintTurnStats = nil;
        ECFirstTurnStats *theseFirstTurnStats   = nil;
        ECFarTurnStats *theseFarTurnStats       = nil;
        
        if(raceDistanceIndex == kSprintRace)
        {
            theseSprintTurnStats                        = [workingSprintTurnStats objectAtIndex:position - 1];
            theseSprintTurnStats.turnPosition           = [NSNumber numberWithFloat:position];
            theseSprintTurnStats.averageFinalPosition   = [NSNumber numberWithFloat:finalPositionAverageFromTurn];
        }
        else
        {
            theseFirstTurnStats                         = [workingFirstTurnStats objectAtIndex:position - 1];
            theseFirstTurnStats.firstTurnPosition       = [NSNumber numberWithInteger:position];
            theseFirstTurnStats.averagePositionFarTurn  = [NSNumber numberWithFloat:farTurnPositionAverageFromFirstTurn];
            
            theseFarTurnStats                       = [workingFarTurnStats objectAtIndex:position - 1];
            theseFarTurnStats.farTurnPosition       = [NSNumber numberWithInteger:position];
            theseFarTurnStats.averageFinalPosition  = [NSNumber numberWithFloat:finalPositionAverageFromFarTurn];
        }
    }
    
    return returnStatsResults;
}

- (NSUInteger)getIndexForTrackIndex:(NSUInteger)trackIdIndex
          atRaceDistanceIndex:(NSUInteger)raceDistanceIndex
           forStatFieldNumber:(NSUInteger)statFieldIndex
                 withPosition:(NSUInteger)position
{
    if(position == 0 || position > kMaximumNumberEntries)
    {
        NSLog(@"bad position value");
        return kNoIndex;
    }
    
    NSUInteger index =  (trackIdIndex * kNumberRaceDistances * kMaximumNumberEntries * kNumberStatFields) +
                        (raceDistanceIndex * kMaximumNumberEntries * kNumberStatFields) +
                        ((position - 1) * kNumberStatFields) + statFieldIndex;
    
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
/*
	self.rankedPopulation = [self createNewHandicappers];
	
	[self fillWorkingPopulationArrayWithOriginalMembers];
*/
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
        ECDna *thisMembersDna           = nil;
        
        tempHandicapper.dna = thisMembersDna;
        
		NSArray *thisMembersDnaTrees = [NSArray arrayWithObjects:   [self recoverTreeFromString:tempHandicapper.dna.getClassStrengthDnaStrand],
                                                                    [self recoverTreeFromString:tempHandicapper.dna.earlySpeedRelevanceDnaStrand],
                                                                    [self recoverTreeFromString:tempHandicapper.dna.otherRelevanceDnaStrand],
                                                                    [self recoverTreeFromString:tempHandicapper.dna.breakStrengthDnaStrand],
                                                                    [self recoverTreeFromString:tempHandicapper.dna.speedToFirstTurnDnaStrand],
                                                                    [self recoverTreeFromString:tempHandicapper.dna.midtrackSpeedDnaStrand],
                                                                    [self recoverTreeFromString:tempHandicapper.dna.lateSpeedDnaStrand],
                                                                    [self recoverTreeFromString:tempHandicapper.dna.recentClassDnaTree],
                                                                    [self recoverTreeFromString:tempHandicapper.dna.raceToFirstTurnDnaStrand],
                                                                    [self recoverTreeFromString:tempHandicapper.dna.raceToFarTurnDnaStrand],
                                                                    [self recoverTreeFromString:tempHandicapper.dna.raceToFinishDnaStrand],
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
	
	NSLog(@"trainPopulation finaled");
}


   
- (void)testPopulation:(ECPopulation*)population
	  includingParents:(BOOL)parentsToo
	belowResultsFolder:(NSString *)resultFolderPath
{
	// self.workingPopulation array MUST be sorted at this point with:
	//	chldren occupying BOTTOM HALF of array with their indices
	
/*	NSUInteger startIndex					= self.populationSize - self.trainingPopSize;
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
					handicapper.numberWinBets	= [NSNumber numberWithUnsignedInteger:incrementedTotal];
				
					// only increment numberWinBetWinners if handicapper predicted winner correctly
					if(trainingRaceRecord.winningPost == [[winBetsArray objectAtIndex:index] unsignedIntegerValue])
					{
						incrementedTotal				= [handicapper.numberWinBetWinners unsignedIntegerValue] + 1;
						handicapper.numberWinBetWinners	= [NSNumber numberWithUnsignedInteger:incrementedTotal];
					}
				}
			}
		}
    } */
}

//- (BOOL)analyzeRace
//{
//	NSUInteger start, end, count;
//	
//	ECHandicapper *handicapper;
//	NSNumber *boxNumber;
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
//	[opQueue waitUntilAllOperationsAreFinaled];
//	
//	return result;
//}

- (NSUInteger)getParentIndexFromPopulation:(ECPopulation*)population
				   withOverallFitnessValue:(double)popsSummedFitness;
{
    NSUInteger parentIndex = 0;
    
    return parentIndex;
}

- (NSArray*)getTrainingRaceRecordsForResultsFileAtPath:(NSString*)resultsFileAtPath
{
    NSLog(@"FIX: this method to match Modified Results format.");
    
    return nil;
    
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

//	BOOL isThisANewRecord	= NO;
//	NSMutableArray *records	= [NSMutableArray new];
//	NSError *error			= nil;
//	NSString *fileContents	= [NSString stringWithContentsOfFile:resultsFileAtPath
//													    encoding:NSStringEncodingConversionAllowLossy
//														   error:&error];
//
//	NSArray *fileContentsLineByLine = [fileContents componentsSeparatedByString:@"\n"];
//	
//	// skip html meta lines
//	NSUInteger startIndex = 8;
//	
//	// takes us to the attendance line
//	NSUInteger endIndex	= fileContentsLineByLine.count - 4;
//	
//	// iterate through file line by line
//	// looking for start of each new race
//	for(NSUInteger i = startIndex; i < endIndex; i++)
//	{
//		NSString *thisLine		= [fileContentsLineByLine objectAtIndex:i];
//		NSString *twoLinesAhead	= [fileContentsLineByLine objectAtIndex:i+2];
//		
//		if([NSString isThisALongLineOfUnderscores:thisLine] && [NSString isThisALongLineOfUnderscores:twoLinesAhead])
//		{
//			// reset
//			isThisANewRecord = NO;
//			
//			// create thisRaceLineByLine and add the line starting with trackName (lines 10)
//			NSMutableArray *thisRaceLineByLine = [NSMutableArray new];
//		
//			[thisRaceLineByLine	addObject:[fileContentsLineByLine objectAtIndex:i+1]];
//			
//			// skips 2nd longLine...
//			NSUInteger thisRaceLineNumber = 3;
//			
//			// loop until next race start found
//			while(i + thisRaceLineNumber < endIndex)
//			{
//				thisLine			= [fileContentsLineByLine objectAtIndex:i + thisRaceLineNumber++];
//				isThisANewRecord	= [NSString isThisALongLineOfUnderscores:thisLine];
//				
//				if(isThisANewRecord)
//				{
//					break;  // new record found
//				}
//				
//				else
//				{
//					[thisRaceLineByLine addObject:thisLine];
//				}
//			}
//			
//			// load raceRecord fields form these lines
//			ECTrainigRaceRecord	*trainingRaceRecord = [self getTrainingRaceRecordFromLines:thisRaceLineByLine];
//			
//			// add new raceRecord to records array
//			[records addObject:trainingRaceRecord];
//			
//			// increment i so we don't reread this race
//			i += thisRaceLineNumber - 2;
//		}
//	}
//	
//	// ok to return the mutableArray since an immutable copy is made for the return
//	return records;
}

- (ECTrainigRaceRecord*)getTrainingRaceRecordFromLines:(NSArray*)resultFileLineByLine
{
    NSLog(@"Depricated Method");
    return nil;
    
	// Derby Lane ONLY
	
	//Line #	^
	//	0:		DERBY LANE                   Wednesday Nov 05 2008 Afternoon   Race 2    Grade  D   (548)  Time: 30.97
	//	1:		Curler Ron G     70½ 7 2 1 3  1 4  1 3½    30.97 3.50  Won With Ease-inside
	//	2:		Ww's Arcadia     60  4 3 2    2    2 3½    31.21 4.90  Held Place Safe-rail
	//	3:		Jamie M Grodeki  61½ 6 4 5    4    3 5     31.32 5.90  Swung Wide 1st-gaining
	//  4:		Silver Fang      67  1 8 4    3    4 6½    31.43 3.90  Outfinaled-inside
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
	//	- entryNames with trapPositions
		
//	NSString *modifiedLine		= [self removeExtraSpacesFromString:[resultFileLineByLine objectAtIndex:0]];
//	NSArray *lineZeroTokens		= [modifiedLine componentsSeparatedByString:@" "];
//	NSUInteger firstDateToken	= [self getIndexOfFirstDateToken:lineZeroTokens];
//	
//	if(firstDateToken == 0)
//	{
//		NSLog(@"error getting index start of date token");
//		exit(1);
//	}
//	
//	// get track Name
//	NSMutableString *trackName = [NSMutableString new];
//	
//	for(NSUInteger index = 0; index < firstDateToken; index++)
//	{
//		// add a space " " character unless initial word
//		if(index > 0)
//		{
//			[trackName appendString:@" "];
//		}
//	
//		NSString *word = [lineZeroTokens objectAtIndex:index];
//	
//		[trackName appendString:word];
//	}
//	
//	// jump through some hoops to create NSDate object
//	NSString *yyyySubstring	= [lineZeroTokens objectAtIndex:firstDateToken + 3];
//	NSString *monthName		= [lineZeroTokens objectAtIndex:firstDateToken + 1];
//	NSString *mmSubstring	= [self getMmSubstringFromSpelledMonth:monthName];
//	NSString *ddSubstring	= [lineZeroTokens objectAtIndex:firstDateToken + 2];
//	NSString *suffix		= @" 10:00:00 +0600";
//	NSString *dateString	= [NSString stringWithFormat:@"%@-%@-%@%@", yyyySubstring, mmSubstring, ddSubstring, suffix];
//	NSDate *raceDate		= [NSDate dateWithString:dateString];
//	NSString *raceClass		= [lineZeroTokens objectAtIndex:firstDateToken + 8];
//	NSUInteger raceNumber	= [[lineZeroTokens objectAtIndex:firstDateToken + 6] integerValue];
//	NSUInteger raceDx		= [self getRaceDxFromString:[lineZeroTokens objectAtIndex:firstDateToken + 9]];
//	double winningTime		= [[lineZeroTokens objectAtIndex:firstDateToken + 11] doubleValue];
//
//// iterate through resultFileLineByLine filling in entryNamesArray and postOddsArray
//	NSMutableArray *namesByPostArray	= [NSMutableArray new];
//	NSMutableArray *finalByPostArray	= [NSMutableArray new];
//
//	NSUInteger lineNumber	= 0;
//	BOOL isThisKennelLine	= NO;
//		
//	// fill arrays with strings @"empty post"
//	for(NSUInteger index = 0; index < kMaximumNumberEntries; index++)
//	{
//		[namesByPostArray addObject:@"Empty Post"];
//		[finalByPostArray addObject:@"Empty Post"];
//	}
//	
//	// replace @"Empty Post" strings with name and odds for each post
//	while(1)
//	{
//		NSString *resultFileLine	= [resultFileLineByLine objectAtIndex:++lineNumber];
//		modifiedLine				= [self removeExtraSpacesFromString:resultFileLine];
//		isThisKennelLine			= [NSString isThisWinningKennelLine:modifiedLine];
//
//		if(isThisKennelLine)
//		{
//			break;
//		}
//		
//		NSArray *tokens = [modifiedLine componentsSeparatedByString:@" "];
//		
//		NSString *entryName			= nil;
//		NSUInteger boxNumber		= 0;
//		NSUInteger finalPosition	= 0;
//		
//		[self useResultLineArray:tokens
//		  toGetValueForEntryName:&entryName
//					trapPosition:&boxNumber
//					andFinalPosition:&finalPosition];
//				
//		NSNumber *finalPositionNumber = [NSNumber numberWithInteger:finalPosition];
//				
//		[finalByPostArray replaceObjectAtIndex:boxNumber-1
//									 withObject:finalPositionNumber];
//				
//		[namesByPostArray replaceObjectAtIndex:boxNumber-1
//									withObject:entryName];
//	}
//	
//	ECRaceResults *results	= [[ECRaceResults alloc] initWithFinalPositionsArray:finalByPostArray];
//	results.winningTime		= winningTime;
//	ECRacePayouts *payouts	= [self getPayoutsUsingArray:resultFileLineByLine
//										   atLineNumber:++lineNumber];
//				
//	ECTrainigRaceRecord *record = [[ECTrainigRaceRecord alloc] initRecordAtTrack:trackName
//																	  onRaceDate:raceDate
//																   forRaceNumber:raceNumber
//																	 inRaceClass:raceClass
//																  atRaceDiatance:raceDx
//																 withWinningPost:results.winningPost
//														andEntryNamesByPostArray:namesByPostArray
//															   resultingInPayout:payouts];
//				
//	return record;
}

- (void)useResultLineArray:(NSArray*)tokens
	toGetValueForEntryName:(NSString**)entryNameString
			  trapPosition:(NSUInteger*)entryTrapPosition
			  andFinalPosition:(NSUInteger*)entryFinalPosition
{
	/* result line EXAMPLE:
	
	Backwood Ethel   62½ 1 1 1 3  1 3  1 5     31.05 *0.80 Increasing Lead-inside
	Hallo See Me     63½ 2 2 2    2    2 5     31.42 8.30  Evenly To Place-midtrk
	...
	
	*/
	
	NSMutableString *entryName	= [NSMutableString new];
	NSUInteger finalPosition	= 0;
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
	*entryTrapPosition	= post;
	
	// final position is usually 4 words later
	NSUInteger finalPositionIndex = index + 4;

	// if this entry is in first (at first turn) add word for placesInLead
	NSUInteger placeAtFirstTurn = [[tokens objectAtIndex:++index] integerValue];
	
	if(placeAtFirstTurn == 1)
	{
		finalPositionIndex++;
		index++;
	}
	
	// if this entry is in first (at top of stretch)  add word for placesInLead
	
	NSUInteger placeAtFarTurn = [[tokens objectAtIndex:index + 1] integerValue];
	
	if(placeAtFarTurn == 1)
	{
		finalPositionIndex++;
	}
	
	finalPosition			= [[tokens objectAtIndex:finalPositionIndex] integerValue];
	*entryFinalPosition	= finalPosition;
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
            NSLog(@"Past Line: %@", [pastLine description]);
			
            //***********************************
			
			//	Multiprocess Here
			//	devoting 1 core per Handicapper
				
			//************************************/
			
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
    pastLineRecord.ranOutside       = NO;
 	pastLineRecord.raceDate			= pastLineDate;
	pastLineRecord.trackName		= [pastLineArray objectAtIndex:1];
	pastLineRecord.raceDistance		= [[pastLineArray objectAtIndex:2] integerValue];
	pastLineRecord.raceClass		= [pastLineArray objectAtIndex:17];
	pastLineRecord.trackConditions	= [pastLineArray objectAtIndex:3];
	pastLineRecord.winningTime		= [[pastLineArray objectAtIndex:4] doubleValue];
	pastLineRecord.weight			= [[pastLineArray objectAtIndex:5] integerValue];
	pastLineRecord.trapPosition		= [[pastLineArray objectAtIndex:6] integerValue];
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
			
			pastLineRecord.deltaPosition1   = pastLineRecord.breakPosition - pastLineRecord.firstTurnPosition;
			pastLineRecord.farTurnPosition	= [[pastLineArray objectAtIndex:10] integerValue];
			
			if(pastLineRecord.farTurnPosition == 0)
			{
				pastLineRecord.didNotFinish = YES;
			}
			else
			{
				pastLineRecord.lengthsLeadFarTurn	= [[pastLineArray objectAtIndex:11] integerValue];
				
				if(pastLineRecord.farTurnPosition != 1)
				{
					pastLineRecord.lengthsLeadFarTurn *= -1;  // not in lead then this must be a negative value
				}
				
				pastLineRecord.deltaLengths1	= pastLineRecord.lengthsLeadFirstTurn - pastLineRecord.lengthsLeadFarTurn;
				pastLineRecord.deltaPosition2	= pastLineRecord.firstTurnPosition - pastLineRecord.farTurnPosition;
				pastLineRecord.finalPosition	= [[pastLineArray objectAtIndex:12] integerValue];

				if(pastLineRecord.finalPosition == 0)
				{
					pastLineRecord.didNotFinish = YES;
				}
				else
				{
					pastLineRecord.lengthsLeadFinal	= [[pastLineArray objectAtIndex:13] integerValue];
					
					if(pastLineRecord.finalPosition != 1)
					{
						pastLineRecord.lengthsLeadFinal *= -1;  // not in lead then this must be a negative value
					}
					
					pastLineRecord.entryTime		= [[pastLineArray objectAtIndex:14] doubleValue];
					pastLineRecord.winOdds			= [[pastLineArray objectAtIndex:15] doubleValue];
					pastLineRecord.deltaPosition3	= pastLineRecord.farTurnPosition - pastLineRecord.finalPosition;
					pastLineRecord.deltaLengths2	= pastLineRecord.lengthsLeadFarTurn - pastLineRecord.lengthsLeadFinal;
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
	NSArray *collisionWords = [NSArray arrayWithObjects:    @"blocke", @"bounced", @"bumped", @"blocked",  @"collided", @"crowded",
                                                            @"fell", @"hit", @"impeded", @"interference", @"interfered", @"jammed", @"knocked",
															@"shut", @"shuffled", @"shffld", @"pnchd", @"pinched", @"trouble", @"trble", nil];
    
   
	NSArray *indsideWords	= [NSArray arrayWithObjects:@"rail", @"inside", @"insid", @"in", @"ins", nil];
	NSArray *outsideWords	= [NSArray arrayWithObjects:@"outside", @"out", @"wide", @"wd", nil];
	NSArray *midtrackWords	= [NSArray arrayWithObjects:@"midtrack", @"mid", @"midt", nil];
	NSArray *scratchedWords	= [NSArray arrayWithObjects:@"scratched", @"scr", nil];
	NSArray *dnfWords		= [NSArray arrayWithObjects:@"fl", @"OP", @"OOP", @"fell", @"dnf", nil];

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
    /* FIX:
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
	
//	newHandicapper.classStrengthTree				= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kClassDnaStrand]];
//	newHandicapper.breakPositionStrengthTree		= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kBreakPositionDnaStrand]];
//	newHandicapper.firstTurnPositionStrengthTree	= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kFirstTurnPositionDnaStrand]];
//	newHandicapper.farTurnPositionStrengthTree      = [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kFarTurnPositionDnaStrand]];
//    newHandicapper.b              = [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kBettingStrengthDnaStrand]];
//	newHandicapper.earlySpeedRelevanceTree			= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kEarlySpeedRelevanceDnaStrand]];
//	newHandicapper.otherRelevanceTree				= [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kOtherRelevanceDnaStrand]];
		
	return newHandicapper;
}

- (NSUInteger)getParentIndexFromPopulation:(ECPopulation*)population
				   withOverallFitnessValue:(double)popsFitness
{
	// orgy type does not specify unique parent
	if(kReproductionType == kOrgyMethod)
	{
		return kNoIndex; // orgy method does NOT require unique parents
	}

	// parents are chosen based on kReproductionType and kSelection

	NSUInteger parentIndex				= kNoIndex;
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
     */
    return nil;
    
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
    /* FIX:
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
     */
    return nil;
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
       tempNode.leafVariableIndex == kNoIndex && tempNode.leafConstant == kNoConstant)
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
    else if(tempNode.leafConstant != kNoConstant)
	{
        newTree = [[ECTree alloc] initWithConstantValue:tempNode.leafConstant];
	}
    else if(tempNode.leafVariableIndex != kNoIndex)
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
    // FIX:
	ECTree *crossoverFromParent2 = nil;

	return crossoverFromParent2;
}

- (double)evalTree:(ECTree*)treeNode
	usingVariables:(NSMutableArray*)dataArray
			atPost:(NSUInteger)trapPosition
{
	double returnVal = 0.0;
	
        if(trapPosition > kMaximumNumberEntries)
		{
            NSLog(@"eval tree post error 1");
            exit(1);
		}
	
        if(treeNode.functionPtr)
		{
            double leftBranchVal = [self evalTree:treeNode.leftBranch
                                   usingVariables:dataArray
                                           atPost:trapPosition];
		
            if(leftBranchVal == 00000)
			{
                return 00000;
			}
		
            if(treeNode.rightBranch)
            {
                double rightBranchVal = [self evalTree:treeNode.rightBranch
                                        usingVariables:dataArray
                                                atPost:trapPosition];
			
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
        else if(treeNode.leafConstant != kNoConstant)
		{
            returnVal = treeNode.leafConstant;
		}
        else
		{
		
            // get value for this race variable
            if(treeNode.leafVariableIndex == kNoIndex)
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
 
    
    changedHandicapper.dna.getClassStrengthDnaStrand        = nil;
    changedHandicapper.dna.earlySpeedRelevanceDnaStrand     = nil;
    changedHandicapper.dna.otherRelevanceDnaStrand          = nil;
    changedHandicapper.dna.breakStrengthDnaStrand           = nil;
    changedHandicapper.dna.speedToFirstTurnDnaStrand        = nil;
    changedHandicapper.dna.midtrackSpeedDnaStrand           = nil;
    changedHandicapper.dna.lateSpeedDnaStrand               = nil;
    changedHandicapper.dna.recentClassDnaTree               = nil;
    changedHandicapper.dna.raceToFirstTurnDnaStrand         = nil;
    changedHandicapper.dna.raceToFarTurnDnaStrand           = nil;
    changedHandicapper.dna.raceToFinishDnaStrand            = nil;
    changedHandicapper.dna.bettingStrengthDnaStrand         = nil;
}


- (void)freeTree:(ECTree*)node
{
	
	if(nil == node)
	{
        NSLog(@"node is nil");
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
       tempNode.leafVariableIndex == kNoIndex &&
       tempNode.leafConstant == kNoConstant)
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
    else if(tempNode.leafConstant != kNoConstant)
    {
        newTree = [[ECTree alloc] initWithConstantValue:tempNode.leafConstant];
    }
    else if(tempNode.leafVariableIndex != kNoIndex)
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
                case kEarlySpeedRelevanceDnaStrand:
                    newbie.dna.earlySpeedRelevanceDnaStrand = dnaString;
                    break;
                    
                case kOtherRelevanceDnaStrand:
                    newbie.dna.otherRelevanceDnaStrand = dnaString;
                    break;
                    
                case kBreakStrengthDnaStrand:
                    newbie.dna.breakStrengthDnaStrand = dnaString;
                    break;
                    
                case kSpeedToFirstTurnDnaStrand:
                    newbie.dna.speedToFirstTurnDnaStrand = dnaString;
                    break;
                
                case kMidtrackSpeedDnaStrand:
                    newbie.dna.midtrackSpeedDnaStrand = dnaString;
                    break;
                    
                case kLateSpeedDnaStrand:
                    newbie.dna.lateSpeedDnaStrand = dnaString;
                    break;
				
                case kRaceToFirstTurnStrengthDnaStrand:
					newbie.dna.raceToFirstTurnDnaStrand = dnaString;
					break;
				
                case kRaceToFarTurnStrengthDnaStrand:
                    newbie.dna.raceToFarTurnDnaStrand = dnaString;
                    break;
				
                case kRaceToFinishStrengthDnaStrand:
					newbie.dna.raceToFinishDnaStrand = dnaString;
					break;
				
                case kBettingStrengthDnaStrand:
                    newbie.dna.bettingStrengthDnaStrand = dnaString;
                    break;
                    
                default:
                    break;
            }
            
            NSLog(@"%i: %@", popIndex, dnaString);
        }
        
        newbie.birthGeneration  = self.population.generationNumber;
        
        [handicappersSet addObject:newbie];
    }
    
    [self.population addHandicappers:[handicappersSet copy]];
	
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
    else if(tree.leafVariableIndex != kNoIndex)
    {
        // append index in brackets[]
        [treeString appendString:[NSString stringWithFormat:@"%ld", (unsigned long)tree.leafVariableIndex]];
    }
    else
    {
        if(tree.leafConstant == kNoConstant)
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
    // 11: position at final
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
    //      11: position at final
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
