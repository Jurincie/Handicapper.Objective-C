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


- (double)getShowTimeThisRaceFromString:(NSString*)singleRaceString
{
	NSArray *lines              = [singleRaceString componentsSeparatedByString:@"\n"];
    NSString *showTimeString    = [lines objectAtIndex:33];
	double showTime             = [showTimeString doubleValue];
    
    if(showTime < 29.00 || showTime > 50.0)
    {
        NSLog(@"bad show time in file?");
        exit(1);
    }
    
    return showTime;
}


- (double)getBestRaceTimeAtTrackNamed:(NSString*)trackName
				  atRaceDistanceIndex:(NSUInteger)raceDxIndex
{
    double bestTime = 0.00;
    
    if([trackName isEqualToString:@"Daytona Beach"])
    {
        switch (raceDxIndex)
        {
            case 0:
                bestTime = 30.00;
                break;
                
            case 1:
                bestTime = 36.80;
                break;
                
            default:
                break;
        }
    }
    else if([trackName isEqualToString:@"Derby Lane"])
    {
        switch (raceDxIndex)
        {
            case 0:
                bestTime = 30.05;
                break;
                
            case 1:
                bestTime = 36.84;
                break;
                
            default:
                break;
        }
    }
    else if([trackName isEqualToString:@"Ebro"])
    {
        switch (raceDxIndex)
        {
            case 0:
                bestTime = 29.96;
                break;
                
            case 1:
                bestTime = 36.47;
                break;
                
            default:
                break;
        }
    }
    else if([trackName isEqualToString:@"Flagler"])
    {
        switch (raceDxIndex)
        {
            case 0:
                bestTime = 30.50;
                break;
                
            case 1:
                bestTime = 36.51;
                break;
                
            default:
                break;
        }
    }
    else if([trackName isEqualToString:@"Gulf"])
    {
        switch (raceDxIndex)
        {
            case 0:
                bestTime = 29.55;
                break;
                
            case 1:
                bestTime = 36.41;
                break;
                
            default:
                break;
        }
    }
    else if([trackName isEqualToString:@"Mardi Gras"])
    {
        switch (raceDxIndex)
        {
            case 0:
                bestTime = 29.91;
                break;
                
            case 1:
                bestTime = 37.08;
                break;
                
            default:
                break;
        }
    }
    else if([trackName isEqualToString:@"Naples - Fort Meyers"])
    {
        switch (raceDxIndex)
        {
            case 0:
                bestTime = 29.50;
                break;
                
            case 1:
                bestTime = 37.64;
                break;
                
            default:
                break;
        }
    }
    else if([trackName isEqualToString:@"Orange Park"])
    {
        switch (raceDxIndex)
        {
            case 0:
                bestTime = 30.10;
                break;
                
            case 1:
                bestTime = 37.10;
                break;
                
            default:
                break;
        }
    }
    
    else if([trackName isEqualToString:@"Palm Beach"])
    {
        switch (raceDxIndex)
        {
            case 0:
                bestTime = 29.02;
                break;
                
            case 1:
                bestTime = 37.40;
                break;
                
            default:
                break;
        }
    }
    else if([trackName isEqualToString:@"Sanford-Orlando"])
    {
        switch (raceDxIndex)
        {
            case 0:
                bestTime = 29.96;
                break;
                
            case 1:
                bestTime = 37.17;
                break;
                
            default:
                break;
        }
    }
    else if([trackName isEqualToString:@"Sarasota"])
    {
        switch (raceDxIndex)
        {
            case 0:
                bestTime = 29.97;
                break;
                
            case 1:
                bestTime = 37.42;
                break;
                
            default:
                break;
        }
    }
    else if([trackName isEqualToString:@"Southland"])
    {
        switch (raceDxIndex)
        {
            case 0:
                bestTime = 31.14;
                break;
                
            case 1:
                bestTime = 36.18;
                break;
                
            default:
                break;
        }
    }
    else if([trackName isEqualToString:@"Tri-State"])
    {
        switch (raceDxIndex)
        {
            case 0:
                bestTime = 29.85;
                break;
                
            case 1:
                bestTime = 37.91;
                break;
                
            default:
                break;
        }
    }
    else if([trackName isEqualToString:@"Wheeling"])
    {
        switch (raceDxIndex)
        {
            case 0:
                bestTime = 29.19;
                break;
                
            case 1:
                bestTime = 37.27;
                break;
                
            default:
                break;
        }
    }
	
	return bestTime;
}

- (double)getWorstRaceTimeAtTrackNamed:(NSString*)trackName
				   atRaceDistanceIndex:(NSUInteger)raceDxIndex
{
    // FIX:
	double bestTime = [self getBestRaceTimeAtTrackNamed:trackName
                                    atRaceDistanceIndex:raceDxIndex];
    
    double worstTime = bestTime * 1.11;
    
	return worstTime;
}

- (double)getWorstTimeThisRaceFromString:(NSString*)singleRaceString
{
    //FIX: set kDnfTime adding a (penalty time percentage) or (flat penalty time) to value from getWorstRaceTimeAtTrackNamed: method
#define kDnfTime 43.0
    
    NSArray *fourWayArray   = [singleRaceString componentsSeparatedByString:@"\n\n\n"];
    NSString *chartString   = [fourWayArray objectAtIndex:1];
	NSArray *lines          = [chartString componentsSeparatedByString:@"\n"];
    double worstTimeSoFar   = 0.0;
    
    // due to dnf scenerio we must iterate through and track worst time
    NSUInteger numberEntries = lines.count / 10;
    
    for(NSUInteger entryNumber = 0; entryNumber < numberEntries; entryNumber++)
    {
        NSUInteger raceTimeStringIndex  = (entryNumber * 10) + 6;
        NSString *raceTimeString        = [lines objectAtIndex:raceTimeStringIndex];
        double thisRaceTime             = [raceTimeString doubleValue];
        
        if(thisRaceTime > 0.00 && thisRaceTime < kDnfTime && thisRaceTime > worstTimeSoFar)
        {
            worstTimeSoFar = thisRaceTime;
        }
    }
    
    return worstTimeSoFar;
}

- (NSUInteger)processEntriesPastLines:(NSString*)pastLines
                       forValidTracks:(NSArray*)validTrackIdsArray
                  withStatisticsArray:(double*)dxStatsAccumulatorArray
                      andCounterArray:(int*)dxRaceCounterArray
{
    
    NSUInteger maxTrapPositions         = kMaximumNumberEntries;
    NSUInteger totalRaces               = 0;
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
    
    NSArray *individualPastLines = [pastLines componentsSeparatedByString:@"\n\n"];
    
    for(NSString *pastLineString in individualPastLines)
    {
        NSArray *lines = [pastLineString componentsSeparatedByString:@"\n"];
        
        raceDateString = [lines firstObject];
        
        NSString *numEntriesString  = [lines objectAtIndex:6];
        NSUInteger numberEntries    = [numEntriesString integerValue];
        
        if(numberEntries == 0) // num entries not given, so put in 8
        {
            numberEntries = 8;
        }
        
        trackID                 = [lines objectAtIndex:1];
        NSUInteger trackIndex   = [validTrackIdsArray indexOfObject:trackID];
        
        // avoids unmodeled tracks
        if(trackIndex == kNoIndex)
        {
            continue;
        }
        
        NSString *calls = [[lines objectAtIndex:9] substringFromIndex:7];
        
        NSArray *callsArray = [calls componentsSeparatedByString:@" "];
        
        NSString *trapPositionString    = [callsArray objectAtIndex:0];
        trapPosition                    = [trapPositionString intValue];
        
        if(trapPosition == 0)
        {
            // simply ignore these
            continue;
        }
        else if(trapPosition == 0 || trapPosition > maxTrapPositions)
        {
            NSLog(@"bad post position");
            continue;
        }
        
        raceDxIndex = [self getRaceDxIndexFromString:[lines objectAtIndex:3]];
        
        if(raceDxIndex == kNoIndex)
        {
            // ignore races at distances we are not interested in
            continue;
        }
        else if(raceDxIndex > kNumberRaceDistances)
        {
            NSLog(@"bad race distance index");
            exit(1);
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
            
            if(firstTurnPositionString.length > 1)
            {
                firstTurnPositionString = [firstTurnPositionString substringToIndex:0];
            }
            
            if([self isThisFallWord:firstTurnPositionString])
            {
                dnfOccurred = YES;
            }
            else
            {
                firstTurnPosition = [firstTurnPositionString integerValue];
                
                if(firstTurnPosition == 0)
                {
                    // simply ignore these
                    continue;
                }
                
                farTurnPositionString = [callsArray objectAtIndex:3];
                
                if(farTurnPositionString.length > 1)
                {
                    farTurnPositionString = [farTurnPositionString substringToIndex:0];
                }
                
                if([self isThisFallWord:farTurnPositionString])
                {
                    dnfOccurred = YES;
                }
                else
                {
                    farTurnPosition = [farTurnPositionString integerValue];
                    
                    if(farTurnPosition == 0)
                    {
                        // simply ignore these
                        continue;
                    }
                    
                    finalPositionString = [callsArray objectAtIndex:4];
                    
                    if([self isThisFallWord:finalPositionString])
                    {
                        dnfOccurred = YES;
                    }
                    else
                    {
                        
                        NSString *lengthsBehindOrAheadString    = [finalPositionString substringFromIndex:2];
                        finalPositionString                    =  [finalPositionString substringToIndex:0];
                        
                        finalPosition = [finalPositionString integerValue];
                        
                        if(finalPosition > numberEntries)
                        {
                            finalPosition = numberEntries;
                        }
                        
                        finalRaceTimeString = [lines objectAtIndex:10];
                        
                        
                        if([lengthsBehindOrAheadString isEqualToString:@"OOP"])
                        {
                            finalRaceTime  = kDnfTime;
                            dnfOccurred     = YES;
                        }
                        else
                        {
                            finalRaceTime = [finalRaceTimeString doubleValue];
                        }
                        
                        if(finalRaceTime < 28.00)
                        {
                            finalRaceTime  = kDnfTime;
                            dnfOccurred     = YES;
                        }
                        
                        raceClassString = [lines objectAtIndex:2];
                    }
                }
            }
        }
        
        if(dnfOccurred)
        {
            finalPosition = numberEntries;
            
            finalRaceTime = [self getBestRaceTimeAtTrackNamed:trackID
                                           atRaceDistanceIndex:raceDxIndex];
        }
        
        // skip races at distances we are not modeling
        if(raceDxIndex == kNoIndex)
        {
            continue;
        }
        
        if(trapPosition == 0 || trapPosition > kMaximumNumberEntries)
        {
            NSLog(@"post position error");
            continue;
        }
        else if(breakPosition == 0 || breakPosition > kMaximumNumberEntries)
        {
            NSLog(@"post position error");
            continue;
        }
        else if(firstTurnPosition == 0 || firstTurnPosition > kMaximumNumberEntries)
        {
            NSLog(@"1st turn position error");
            continue;
        }
        else if(farTurnPosition == 0 || farTurnPosition > kMaximumNumberEntries)
        {
            NSLog(@"top of stretch position error");
            continue;
        }
        else if(finalPosition == 0 || finalPosition > kMaximumNumberEntries)
        {
            NSLog(@"final position error");
            continue;
        }
    }
    
    NSLog(@"%@ %@  %@: %lu %lu %lu %lu %lu %lf, %lu", trackID, raceDateString, raceClassString, trapPosition, breakPosition,                  firstTurnPosition, farTurnPosition, finalPosition, finalRaceTime, raceDxIndex);
    
    totalRaces++;
    
    NSUInteger trackNumber = [validTrackIdsArray indexOfObject:trackID];
    
    [self addStatsForEntryAtPost:trapPosition
             withbreakAtPosition:breakPosition
               firstTurnPosition:firstTurnPosition
                 farTurnPosition:farTurnPosition
                   finalPosition:finalPosition
                    withRaceTime:finalRaceTime
                   atRaceDxIndex:raceDxIndex
        withStatAccumulatorArray:&dxStatsAccumulatorArray[0]
             andRaceCounterArray:&dxRaceCounterArray[0]
                 forTrackINumber:trackNumber];
    
    return totalRaces;
}


- (NSArray*)processTrackAtPath:(NSString*)formattedResultsFolderPath
			  withDxStatsArray:(double*)statsArray
		andDxStatsCounterArray:(int*)counterArray
	   winTimeAccumulatorArray:(double*)winTimeAccumulatorArray
	 placeTimeAccumulatorArray:(double*)placeTimeAccumulatorArray
	  showTimeAccumulatorArray:(double*)showTimeAccumulatorArray
	  numRacesAccumulatorArray:(int*)raceCounterArray
				 andClassArray:(NSArray*)tracksClassesArray
{
	NSString *fileName				= nil;
	NSError *error					= nil;
	NSFileManager *localFileManager	= [NSFileManager defaultManager];
	NSArray *folderContents			= [localFileManager contentsOfDirectoryAtPath:formattedResultsFolderPath
																			error:&error];
    
    if(error)
    {
        NSLog(@"%@", [error description]);
    }
    
	NSString *trackName		= nil;
	double bestTime2Turns	= 100.00;
	double worstTime2Turns	= 0.00;
	double bestTime3Turns	= 100.00;
	double worstTime3Turns	= 0.00;

    NSLog(@"%@", formattedResultsFolderPath);
    
	for(NSString *yearFolderName in folderContents)
	{
		if([yearFolderName hasSuffix:@".DS_Store"])
		{
			continue;
		}
		
		NSString *folderPath            = [NSString stringWithFormat:@"%@/%@",formattedResultsFolderPath, yearFolderName];
		NSDirectoryEnumerator *yearEnum = [localFileManager enumeratorAtPath:folderPath];
		
		while(fileName = [yearEnum nextObject])
		{
			if([fileName hasSuffix:@".DS_Store"])
			{
				continue;
			}
            
             NSLog(@"%@", fileName);
            
			NSString *filePath = [NSString stringWithFormat:@"%@/%@", folderPath, fileName];
			
            NSString *singleRaceString = [NSString stringWithContentsOfFile:filePath
                                                                   encoding:NSStringEncodingConversionAllowLossy
                                                                      error:&error];
            
			if(fileName.length < 17 || fileName.length > 18)
			{
				NSLog(@"file name error in processTrackAtPath:");
                exit(1);
			}
			
			NSArray *pathComps  = [formattedResultsFolderPath pathComponents];
			trackName           = [pathComps objectAtIndex:pathComps.count - 2];
            
			NSUInteger raceDxIndex = kNoIndex;
            
            [self processRaceFromString:singleRaceString
                    withStatisticsArray:statsArray
                        andCounterArray:counterArray
                        usingClassArray:tracksClassesArray
                           atTrackNamed:trackName
               settingRaceDistanceIndex:&raceDxIndex];
            
            if(raceDxIndex == kNoIndex)
            {
                continue;
            }

			double bestTimeInRace       = [self getBestTimeThisRaceFromString:singleRaceString];
            double thirdBestTimeInRace  = [self getShowTimeThisRaceFromString:singleRaceString];
			double worstTimeInRace      = [self getWorstTimeThisRaceFromString:singleRaceString];
			
            NSString *raceClassString   = [self getRaceClassStringFromSingleRaceString:singleRaceString];
            NSString *trackID           = nil;
            NSArray *raceClassArray     = [self getClassesForTrackWithId:trackID];
            NSUInteger classIndex       = [raceClassArray indexOfObject:raceClassString];

            NSUInteger arrayIndex = (raceDxIndex * raceClassArray.count) + classIndex;
            
            winTimeAccumulatorArray[arrayIndex] += bestTimeInRace;
            showTimeAccumulatorArray[arrayIndex] += thirdBestTimeInRace;
            raceCounterArray[arrayIndex]++;
            
			switch(raceDxIndex)
			{
				case 0:
				{
                  	if(bestTimeInRace < bestTime2Turns)
					{
						bestTime2Turns = bestTimeInRace;
					}
					if(worstTimeInRace > worstTime2Turns)
					{
						worstTime2Turns = worstTimeInRace;
					}
					
					break;
				}
				
				case 1:
				{                    
					if(bestTimeInRace < bestTime3Turns)
					{
						bestTime3Turns = bestTimeInRace;
					}
					if(worstTimeInRace > worstTime3Turns)
					{
						worstTime3Turns = worstTimeInRace;
					}
					
					break;
				}
				
				default:
					break;
			}
        }
	}
		
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
    NSArray *oneTurnRaceDistanceStrings     = [NSArray arrayWithObjects:@"301", @"313", @"330", @"350", nil];
    NSArray *twoTurnRaceDistanceStrings     = [NSArray arrayWithObjects:@"545", @"546", @"550", @"566", @"NC", nil];
    NSArray *threeTurnRaceDistanceStrings   = [NSArray arrayWithObjects:@"627", @"647", @"660", @"661", @"670",
                                                                        @"677", @"678", @"679", @"681", @"685", @"690", @"DC", nil];
    NSArray *marathonRaceDistanceStrings    = [NSArray arrayWithObjects:@"753", @"754", @"758", @"761", @"770", @"783", nil];
    
    if([oneTurnRaceDistanceStrings containsObject:raceDxString])
    {
        raceDxIndex = 0;
    }
    else if([twoTurnRaceDistanceStrings containsObject:raceDxString])
    {
        raceDxIndex = 1;
    }
    else if([threeTurnRaceDistanceStrings containsObject:raceDxString])
    {
        raceDxIndex = 2;
    }
    else if([marathonRaceDistanceStrings containsObject:raceDxString])
    {
        raceDxIndex = 3;
    }
    
    return raceDxIndex;
}

- (void)processRaceFromString:(NSString*)singleRaceString
                withStatisticsArray:(double*)dxStatsAccumulatorArray
                    andCounterArray:(int*)dxStatsRaceCounterArray
                    usingClassArray:(NSArray*)classArray
                       atTrackNamed:(NSString*)trackName
{
    // split singleRaceString into three pieces
    //  [0] raceInfoString
    //  [1] chartString
    //  [2] payoutStringAndExoticsString which is ignored generating stats
    
    NSArray *singleRaceStringsArray = [singleRaceString componentsSeparatedByString:@"\n\n\n"];
    NSString *raceInfoString        = [singleRaceStringsArray objectAtIndex:0];
    NSString *chartString           = [NSString stringWithFormat:@"%@\n", [singleRaceStringsArray objectAtIndex:1]];
    
    NSArray *raceInfoStringsArray   = [raceInfoString componentsSeparatedByString:@"\n"];
    NSArray *chartStringsArray      = [chartString componentsSeparatedByString:@"\n"];
    
    if([chartStringsArray containsObject:@"DNF"])
    {
        NSLog(@"got DNF");
    }
    
    NSString *raceDistanceString = [raceInfoStringsArray objectAtIndex:3];
    
    // set to avoid passing pointers down the line
    NSUInteger raceDxIndex = 000;;
    
	double dnfTime = [self getWorstRaceTimeAtTrackNamed:trackName
									atRaceDistanceIndex:raceDxIndex];
    
    NSString *dogName                   = nil;
    NSString *trapPositionString        = nil;
    NSString *breakPositionString       = nil;
    NSString *firstTurnPositionString   = nil;
    NSString *farTurnPositionString     = nil;
    NSString *finalPositionString      = nil;
    NSString *finalRaceTimeString      = nil;
    
    // loop through races 9 lines at a time
    NSUInteger numberEntries = chartStringsArray.count / 10;
    
    for(NSUInteger entryNumber = 0; entryNumber < numberEntries; entryNumber++)
    {
        // assign all fields, so that falling at any point is covered
        NSUInteger trapPosition			= 0;
        NSUInteger breakPosition		= numberEntries;
        NSUInteger firstTurnPosition	= numberEntries;
        NSUInteger farTurnPosition	= numberEntries;
        NSUInteger finalPosition		= numberEntries;;
        double finalRaceTime			= [self getWorstRaceTimeAtTrackNamed:trackName
                                                 atRaceDistanceIndex:raceDxIndex];
        
        dogName = [chartStringsArray objectAtIndex:entryNumber * 10];
        
        // check for dnf scenerio => "dnf\n" followed by 7 blank lines
        trapPositionString = [chartStringsArray objectAtIndex:(entryNumber * 10) + 1];
       
        if([[trapPositionString uppercaseString] isEqualToString:@"DNF"] || [[trapPositionString uppercaseString] isEqualToString:@"X"])
        {
            continue;
        }
        
        trapPosition        = [trapPositionString integerValue];
        breakPositionString = [chartStringsArray objectAtIndex:(entryNumber * 10) + 2];
        
        if([[breakPositionString uppercaseString] isEqualToString:@"DNF"] || [[breakPositionString uppercaseString] isEqualToString:@"X"] == NO)
        {
            breakPosition               = [breakPositionString integerValue];
            firstTurnPositionString     = [chartStringsArray objectAtIndex:(entryNumber * 10) + 3];
            
            if([[firstTurnPositionString uppercaseString] isEqualToString:@"DNF"] || [[firstTurnPositionString uppercaseString] isEqualToString:@"X"] == NO)
            {
                if(firstTurnPositionString.length > 1)
                {
                    NSString *substring = [firstTurnPositionString substringToIndex:1];
                    firstTurnPosition	= [substring integerValue];
                }
                else
                {
                    firstTurnPosition = [firstTurnPositionString integerValue];
                }
                
                 farTurnPositionString = [chartStringsArray objectAtIndex:(entryNumber * 10) + 4];
                
                if([[farTurnPositionString uppercaseString] isEqualToString:@"DNF"] || [[farTurnPositionString uppercaseString] isEqualToString:@"X"] == NO)
                {
                    if(farTurnPositionString.length > 1)
                    {
                        NSString *substring		= [farTurnPositionString substringToIndex:1];
                        farTurnPosition	= [substring integerValue];
                    }
                    else
                    {
                        farTurnPosition = [farTurnPositionString integerValue];
                    }
        
                    finalPositionString = [chartStringsArray objectAtIndex:(entryNumber * 10) + 5];
                    
                    if([[finalPositionString uppercaseString] isEqualToString:@"DNF"] || [[finalPositionString uppercaseString] isEqualToString:@"X"] == NO)
                    {
                        if(finalPositionString.length > 1)
                        {
                            NSString *substring = [finalPositionString substringToIndex:1];
                            finalPosition		= [substring integerValue];
                        }
                        else
                        {
                            finalPosition = [finalPositionString integerValue];
                        }

                        finalRaceTimeString = [chartStringsArray objectAtIndex:(entryNumber * 10) + 6];
                        
                        if([[finalRaceTimeString uppercaseString] isEqualToString:@"DNF"] || [[finalRaceTimeString uppercaseString] isEqualToString:@"X"] == NO)
                        {
                            finalRaceTime = [finalRaceTimeString doubleValue];
                        }
                    }
                }
            }
        }
        
        if(finalRaceTime > 45.00 || finalRaceTime == 0)
        {
            finalRaceTime = dnfTime;
        }
        else if(finalRaceTime < 28.80 )
        {
            NSLog(@"bad race time");
        }

//        NSLog(@"%@:%lu %lu %lu %lu %lu %lf", dogName,
//                                            (unsigned long)trapPosition,
//                                            (unsigned long)breakPosition,
//                                            (unsigned long)firstTurnPosition,
//                                            (unsigned long)farTurnPosition,
//                                            (unsigned long)finalPosition, finalRaceTime);
        
//        [self addStatsForEntryAtPost:trapPosition
//                 withbreakAtPosition:breakPosition
//                   firstTurnPosition:firstTurnPosition
//                farTurnPosition:farTurnPosition
//                       finalPosition:finalPosition
//                        withRaceTime:finalRaceTime
//                       atRaceDxIndex:raceDxIndex
//            withStatAccumulatorArray:dxStatsAccumulatorArray
//                 andRaceCounterArray:dxStatsRaceCounterArray];
        
    }
}

- (void)addStatsForEntryAtPost:(NSUInteger)trapPosition
		   withbreakAtPosition:(NSUInteger)breakPosition
			 firstTurnPosition:(NSUInteger)firstTurnPosition
		  farTurnPosition:(NSUInteger)farTurnPosition
				 finalPosition:(NSUInteger)finalPosition
				  withRaceTime:(double)raceTimeForEntry
				 atRaceDxIndex:(NSUInteger)raceDxIndex
	  withStatAccumulatorArray:(double*)statAccumulatorArray
		   andRaceCounterArray:(int*)raceCounterArray
                    forTrackINumber:(NSUInteger)trackNumber
{
    NSUInteger mainOffset = (trackNumber * raceDxIndex * kNumberRaceDistances * kNumberStatFields);

	NSUInteger trapPositionIndex        = trapPosition - 1;
	NSUInteger firstTurnPositionIndex   = firstTurnPosition - 1;
	NSUInteger farTurnPositionIndex     = farTurnPosition - 1;
    
    // break from trap position
	NSUInteger index                        = mainOffset + (trapPositionIndex * kNumberStatFields) + kBreakPositionFromPostStatField;
	double accumulatedBreakValuesFormPost	= statAccumulatorArray[index];
	accumulatedBreakValuesFormPost			+= breakPosition;
	statAccumulatorArray[index]             = accumulatedBreakValuesFormPost;
	
	NSUInteger numberRaces = raceCounterArray[index];
	numberRaces++;
	raceCounterArray[index] = (int)numberRaces;
	
    // first turn from trap position
	index                               = mainOffset + (trapPositionIndex * kNumberStatFields) + kFirstTurnPositionFromPostStatField;
	double accumulatedFTValuesFromPost  = statAccumulatorArray[index];
	accumulatedFTValuesFromPost         += firstTurnPosition;
	statAccumulatorArray[index]         = accumulatedFTValuesFromPost;

	numberRaces = raceCounterArray[index];
	numberRaces++;
	raceCounterArray[index] = (int)numberRaces;
	
    // final from trap position
	index                                       = mainOffset + (trapPositionIndex * kNumberStatFields) + kFinalPositionFromPostStatField;
	double accumulatedFinalPositionFromdPost	= statAccumulatorArray[index];
	accumulatedFinalPositionFromdPost			+= finalPosition;
	statAccumulatorArray[index]                 = accumulatedFinalPositionFromdPost;
	
	numberRaces = raceCounterArray[index];
	numberRaces++;
	raceCounterArray[index] = (int)numberRaces;
   
    // final time from trap position
    index                                       = mainOffset + (trapPositionIndex * kNumberStatFields) + kFinalTimeFromPostStatField;
    double finalTimeAccumulatedValuesFromPost   = statAccumulatorArray[index];
    finalTimeAccumulatedValuesFromPost			+= raceTimeForEntry;
    statAccumulatorArray[index]                 = finalTimeAccumulatedValuesFromPost;
    
    numberRaces = raceCounterArray[index];
    numberRaces++;
    raceCounterArray[index] = (int)numberRaces;
	   
    // far turn from first turn
	index                                       = mainOffset + (firstTurnPositionIndex * kNumberStatFields) + kFarTurnhPositionFromFirstTurnStatField;
	double accumulatedFarTurnValueFromFirstTurn = statAccumulatorArray[index];
	accumulatedFarTurnValueFromFirstTurn        += farTurnPosition;
	statAccumulatorArray[index]                 = accumulatedFarTurnValueFromFirstTurn;
	
	numberRaces = raceCounterArray[index];
	numberRaces++;
	raceCounterArray[index] = (int)numberRaces;
		
    // final from far turn
	index                                       = mainOffset + (farTurnPositionIndex * kNumberStatFields) + kFinalPositionFromFarTurnStatField;
	double accumulatedFinalPositonsFromFarTurn  = statAccumulatorArray[index];
	accumulatedFinalPositonsFromFarTurn         += finalPosition;
	statAccumulatorArray[index]                 = accumulatedFinalPositonsFromFarTurn;
	
	numberRaces = raceCounterArray[index];
	numberRaces++;
	raceCounterArray[index] = (int)numberRaces;
}

- (void)modelTracks
{
    // add these tracks to
    [self getTracksStatsFromPopulationsPastLines:@"/Users/ronjurincie/Desktop/Project Ixtlan/Dogs/Working Past Lines"];
	
    [ECMainController updateAndSaveData];
}



- (void)printNewTrackCouters:(NSArray*)trackCounterArray
{
	for(NSUInteger index = 0; index < trackCounterArray.count; index++)
	{
		NSString *line = [trackCounterArray objectAtIndex:index];
		NSLog(@"%@", line);
	}
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

- (NSArray*)getValidRaceDistancesForTrack:(NSString*)trackID
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

- (void)getTracksStatsFromPopulationsPastLines:(NSString*)pastLinesFolderPath
{
    
    // Track IDs
    NSArray *modeledTracks = [NSArray arrayWithObjects: @"BM", @"BR", @"CA", @"DB", @"DP", @"DQ", @"EB", @"FL", @"GG",
                                                        @"HI", @"HO", @"JC", @"LI", @"MG", @"MH", @"MO", @"NF", @"OP",
                                                        @"OR", @"PB", @"PE", @"PH", @"PN", @"RT", @"SA", @"SE",
                                                        @"SL",@"SN", @"SO", @"SP", @"TP", @"TS", @"TU", @"VG", @"VL",
                                                        @"WD",@"WO", @"WS", @"WT", nil];
    
//        // ignore results from tracks below due to insufficient data
//    NSArray *ignoredTracks = [NSArray arrayWithObjects:@"**", @"CC", @"CL", @"HI", @"HO", @"IR", @"IS",
//                                                        @"JA", @"JC", @"MB", @"MH", @"PU", nil];
//    
//    NSArray *validTrackClasses = [NSArray arrayWithObjects: @"SCL", @"M", @"TM", @"J", @"TJ", @"SJ", @"E", @"TE",
//                                                            @"D", @"DT", @"TD", @"TD", @"SD", @"C", @"CT", @"TC", @"SC",
//                                                            @"B", @"TB", @"BT", @"TB", @"SB", @"BB", @"TBB", @"SBB",
//                                                            @"A", @"AT", @"TA", @"SA", @"AA", @"TAA", @"SAA", nil];
    
    // Each raceClass 2-Turn and 3-Turn stats are kept for:
	//	averageWinTime and averageShowTime
	ECTrackStats *trackStats = [NSEntityDescription insertNewObjectForEntityForName:@"ECTrackStats"
															 inManagedObjectContext:MOC];
	// Distance Stats
	NSUInteger dxArraySize = [modeledTracks count] * kNumberRaceDistances * kMaximumNumberEntries * kNumberStatFields;
	
	int		dxRaceCounterArray[dxArraySize];
	double	dxStatsAccumulatorArray[dxArraySize];
	
	// initialize accumulators to zero
	for(int index = 0; index < dxArraySize; index++)
	{
		dxStatsAccumulatorArray[index]	= 0.0;
		dxRaceCounterArray[index]		= 0.0;
	}
    
	NSError *error = nil;
 
	NSFileManager *fileManager  = [NSFileManager defaultManager];
	NSArray *pastLineFiles      = [fileManager contentsOfDirectoryAtPath:pastLinesFolderPath
                                                                   error:&error];
				
	for(NSString *fileName in pastLineFiles)
	{
        // skip .DS_Store and ALL other . files
		if([fileName characterAtIndex:0] == '.')
        {
            continue;
        }
		
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", pastLinesFolderPath, fileName];

        NSLog(@"=====> %@", fileName);
        
        NSString *dogsRacehistory = [NSString stringWithContentsOfFile:filePath
                                                              encoding:NSStringEncodingConversionAllowLossy
                                                                 error:&error];
        
        NSUInteger numberRacesEvaluatedForThisEntry = [self processEntriesPastLines:dogsRacehistory
                                                                     forValidTracks:modeledTracks
                                                                withStatisticsArray:dxStatsAccumulatorArray
                                                                    andCounterArray:dxRaceCounterArray];
        
        NSLog(@"races evaluated for this entry: %lu", numberRacesEvaluatedForThisEntry);
    }
    
    NSMutableOrderedSet *trackStatsOrderedSet = [NSMutableOrderedSet new];
    
    for(NSString *trackID in modeledTracks)
    {
        ECTrackStats *newTrackStats = [NSEntityDescription insertNewObjectForEntityForName:@"ECTrackStats" inManagedObjectContext:MOC];
        NSUInteger trackIdIndex     = [modeledTracks indexOfObject:trackID];
        
        ECSprintRaceStats *sprintStats = [self getSprintStatsForTrackWithIndex:trackIdIndex
                                                                   withTrackIdArray:modeledTracks
                                                            fromArray:dxStatsAccumulatorArray
                                                       andCounterArray:dxRaceCounterArray];
        
        ECTwoTurnRaceStats *twoTurnRaceStats = [self getTwoTurnStatsForTrackWithIndex:trackIdIndex
                                                                   withTrackIdArray:modeledTracks
                                                                          fromArray:dxStatsAccumulatorArray
                                                            andCounterArray:dxRaceCounterArray];
        
        ECThreeTurnRaceStats *threeTurnRaceStats = [self getThreeTurnStatsForTrackWithIndex:trackIdIndex
                                                                           withTrackIdArray:modeledTracks
                                                                                  fromArray:dxStatsAccumulatorArray
                                                                            andCounterArray:dxRaceCounterArray];
        
        ECMarathonRaceStats *marathonRaceStats = [self getMarathonStatsForTrackWithIndex:trackIdIndex
                                                                        withTrackIdArray:modeledTracks
                                                                               fromArray:dxStatsAccumulatorArray
                                                                         andCounterArray:dxRaceCounterArray];
        
        newTrackStats.sprintRaceStats       = sprintStats;
        newTrackStats.twoTurnRaceStats      = twoTurnRaceStats;
        newTrackStats.threeTurnRaceStats    = threeTurnRaceStats;
        newTrackStats.marathonRaceStats     = marathonRaceStats;
        
        newTrackStats.twoTurnRaceRecordTime     = nil;
        newTrackStats.threeTurnRaceRecordTime   = nil;
        newTrackStats.sprintRaceRecordTime      = nil;
        newTrackStats.marathonRaceRecordTime    = nil;
        
        newTrackStats.validRaceClasses          = nil;
        
        [trackStatsOrderedSet addObject:newTrackStats];
    }
    
    // save stats to coreData
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
            
        case 2:
        {
            if([trackID isEqualToString:@"AP"])
            {
                recordTime = 38.39;
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
            
        case 3:
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

- (NSArray*)getStatDistancesForTrackWithID:(NSString*)trackID
{
    NSArray *validDistances = nil;
    
    return validDistances;
}


- (NSString*)fixNoSpaceBeforeDateBugInFileAtPath:(NSString*)buggyFilePath
{
    NSError *error          = nil;
    NSString *fileContents  = [NSString stringWithContentsOfFile:buggyFilePath
                                                        encoding:NSStringEncodingConversionAllowLossy
                                                           error:&error];
   
    // first split on \n\n to get singleRacePastLineStrings
    NSArray *singleRacePastLine             = [fileContents componentsSeparatedByString:@"\n\n"];
    NSMutableString *repairedFileContents   = [NSMutableString new];
    NSUInteger numberRaces                  = singleRacePastLine.count;
    NSUInteger linesInLastRace              = [[singleRacePastLine objectAtIndex:singleRacePastLine.count-1] length];
 
    if(linesInLastRace < 14)
    {
        numberRaces--;
    }
    
    for(NSUInteger raceNumber = 0; raceNumber < numberRaces; raceNumber++)
    {
//        NSLog(@"Race Number: %lu", raceNumber);
        
//        if(raceNumber == 84)
//        {
//            NSLog(@"got debug race");
//        }
        
        NSString *singlePastLineString = [singleRacePastLine objectAtIndex:raceNumber];
       
        NSArray *lineByLineArray = [singlePastLineString componentsSeparatedByString:@"\n"];
        
        if(lineByLineArray.count < 5)
        {
            if(raceNumber == singleRacePastLine.count - 1)
            {
                // don't need to read these added spaces
                continue;
            }
            else
            {
                // problem
                NSLog(@"buggy file");
            }
           
        }
        else if(lineByLineArray.count > 30)
        {
            NSMutableString *multiRaceString = [NSMutableString new];
            
            // start with first date line
            [multiRaceString appendFormat:@"%@\n", [lineByLineArray objectAtIndex:0]];
            
            // need to add line by line
            for(NSUInteger lineNumber = 1; lineNumber < lineByLineArray.count; lineNumber++)
            {
                NSString *line = [lineByLineArray objectAtIndex:lineNumber];
                
                BOOL isDateLine = [self isLineDateLine:line];
                    
                if(isDateLine)
                {
                    // add "\n" before and after date lines, since they MUST be buggy here
                    [multiRaceString appendFormat:@"\n%@\n", line];
                }
                else
                {
                    // add this non-date string back to newString with "\n"
                    [multiRaceString appendFormat:@"%@\n", line];
                }
            }
            
            [repairedFileContents appendFormat:@"%@\n", multiRaceString];
        }
        else
        {
            [repairedFileContents appendString:singlePastLineString];
            
            // this is proper, so write it to newString with \n\n unless its last race
            if(raceNumber < numberRaces - 1)
            {
                [repairedFileContents appendString:@"\n\n"];
            }
        }
    }
    
    // append a last "\n" so that string ends with "\n\n"
//[repairedFileContents appendString:@"\n"];
    
    return  repairedFileContents;
}


- (NSUInteger)processStatsFromPastLineString:(NSString*)originalFileContents
                      forTracksWithAbbreviations:(NSArray*)unmodeledTrackAbbreviationArray
                            andtrackClassesArray:(NSArray*)newTrackClassesArray
                 withWinTimeAccumulatorArray:(NSMutableArray*)winTimeAccumulatorArray
                    showTimeAccumulatorArray:(NSMutableArray*)winTimesAccumulatorArray
                    numRacesAccumulatorArray:(NSMutableArray*)numRacesAccumulatorArray
{
#define kMaxTrapPosition 9
    
    NSUInteger totalRacesEvaluatedForThisEntry  = 0;
    NSUInteger totalDuplicatedForThisEntry      = 0;

	// Distance Stats
	NSUInteger dxArraySize = kNumberRaceDistances * kMaximumNumberEntries * kNumberStatFields;
 	
    int		dxRaceCounterArray[dxArraySize];
	double	dxStatsAccumulatorArray[dxArraySize];
	
	// initialize accumulators to zero
	for(int index = 0; index < dxArraySize; index++)
	{
		dxStatsAccumulatorArray[index]	= 0.0;
		dxRaceCounterArray[index]		= 0;
	}
    
    NSArray *pastLineStrings        = [originalFileContents componentsSeparatedByString:@"\n\n"];
    NSString *lastRaceDateString    = nil;
    NSString *raceDateString        = nil;
    NSString *raceClassString       = @"";

    NSUInteger numberRaces      = pastLineStrings.count;
    NSUInteger lastStringSize   = [[pastLineStrings objectAtIndex:pastLineStrings.count-1] length];
    
    if(lastStringSize < 23)
    {
        numberRaces--;
    }
    
    for(NSUInteger raceNumber = 0; raceNumber < numberRaces; raceNumber++)
    {
        NSString *singlePastLineString  = [pastLineStrings objectAtIndex:raceNumber];
        NSArray *lines                  = [singlePastLineString componentsSeparatedByString:@"\n"];
    
        if(lines.count < 12)
        {
            // "No Race" scnerio encountered
            continue;
        }
        
        if(raceDateString)
        {
            lastRaceDateString = [raceDateString copy];
        }
       
        raceDateString = [lines objectAtIndex:0];
      
        // check for target tracks
        NSString *trackAbbreviation = [lines objectAtIndex:1];
        
        if([unmodeledTrackAbbreviationArray containsObject:trackAbbreviation] == NO)
        {
            // ignore this race
            continue;
        }
        
        if(lastRaceDateString)
        {
            NSString *raceDatePrefix        = [raceDateString substringToIndex:10];
            NSString *lastRaceDatePrefix    = [lastRaceDateString substringToIndex:10];
            
            if([raceDatePrefix isEqualToString:lastRaceDatePrefix])
            {
                totalDuplicatedForThisEntry++;
                NSLog(@"Duplicate entries for race on date: %@", raceDateString);
               continue;
            }
        }
       
        NSString *breakPositionString           = nil;
        NSString *firstTurnPositionString       = nil;
        NSString *farTurnPositionString    = nil;
        NSString *finalPositionString          = nil;;
        NSString *finalRaceTimeString          = nil;
        
        BOOL dnfOccurred            = NO;
        NSString *numEntriesString  = [lines objectAtIndex:lines.count - 1];
        
        if([numEntriesString isEqualToString:@"Replay"])
        {
            numEntriesString = [lines objectAtIndex:lines.count - 2];
        }
        
        NSUInteger numberEntries = [numEntriesString integerValue];
        
        if(numberEntries == 0) // bug occurred so put in 8
        {
            numberEntries = 8;
        }
        
        NSUInteger trapPosition         = 0;
        NSUInteger breakPosition        = numberEntries;
        NSUInteger firstTurnPosition    = numberEntries;
        NSUInteger farTurnPosition = numberEntries;
        NSUInteger finalPosition       = numberEntries;
        double finalRaceTime           = 0.00;
        NSUInteger raceDxIndex          = [self getRaceDxIndexFromString:[lines objectAtIndex:2]];
        
        if(raceDxIndex == kNoIndex)
        {
            // ignore races at distances we are not interested in
            continue;
        }
        else if(raceDxIndex > 2)
        {
            NSLog(@"bad race distance index");
            exit(1);
        }
        
        NSUInteger lineNumber           = 6;
        NSString *trapPositionString    = [lines objectAtIndex:lineNumber++];

        trapPosition = [trapPositionString integerValue];
        
        if(trapPosition == 0)
        {
            // simply ignore these
            continue;
        }
        else if(trapPosition == 0 || trapPosition > kMaxTrapPosition)
        {
            NSLog(@"bad post position");
            continue;
        }
        
        breakPositionString = [lines objectAtIndex:lineNumber++];
        
        if([[breakPositionString uppercaseString] isEqualToString:@"X"]     ||
           [[breakPositionString uppercaseString] isEqualToString:@"DNF"]   ||
           [[breakPositionString uppercaseString] isEqualToString:@"OOP"]   ||
           [[breakPositionString uppercaseString] isEqualToString:@"FL"]    ||
           [[breakPositionString uppercaseString] isEqualToString:@"FL "]   ||
           [[breakPositionString uppercaseString] isEqualToString:@"F"]     ||
           [[breakPositionString uppercaseString] isEqualToString:@"FELL"]  ||
           [[breakPositionString uppercaseString] isEqualToString:@"FEL"]   ||
           [breakPositionString isEqualToString:@"0"]   ||
           [breakPositionString isEqualToString:@"bmp"] ||
           [breakPositionString isEqualToString:@"0"] ||
           [breakPositionString isEqualToString:@"."])
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
        
            firstTurnPositionString = [lines objectAtIndex:lineNumber++];
            
            if([[firstTurnPositionString uppercaseString] isEqualToString:@"X"]     ||
               [[firstTurnPositionString uppercaseString] isEqualToString:@"DNF"]   ||
               [[firstTurnPositionString uppercaseString] isEqualToString:@"OOP"]   ||
               [[firstTurnPositionString uppercaseString] isEqualToString:@"FL"]    ||
               [[firstTurnPositionString uppercaseString] isEqualToString:@"FL "]   ||
               [[firstTurnPositionString uppercaseString] isEqualToString:@"F"]     ||
               [[firstTurnPositionString uppercaseString] isEqualToString:@"FELL"]  ||
               [[firstTurnPositionString uppercaseString] isEqualToString:@"OOP"]   ||
               [firstTurnPositionString isEqualToString:@"0"]   ||
               [firstTurnPositionString isEqualToString:@"bmp"] ||
               [firstTurnPositionString isEqualToString:@"."])
            {
                dnfOccurred = YES;
            }
            else
            {
                firstTurnPosition = [firstTurnPositionString integerValue];
                
                if(firstTurnPosition == 0)
                {
                    // simply ignore these
                    continue;
                }
              
                // entries at NF and FL have lengthsBehind/Ahead for 1st turn position
                // every track adds for leader
                if(firstTurnPosition == 1 || [trackAbbreviation isEqualToString:@"NF"] ||
                   [trackAbbreviation isEqualToString:@"FL"] || [trackAbbreviation isEqualToString:@"MG"])
                {
                    lineNumber++;  // for lengths in lead
                }
                
                farTurnPositionString = [lines objectAtIndex:lineNumber++];
                
                if([[farTurnPositionString uppercaseString] isEqualToString:@"X"]      ||
                   [[farTurnPositionString uppercaseString] isEqualToString:@"DNF"]    ||
                   [[farTurnPositionString uppercaseString] isEqualToString:@"OOP"]    ||
                   [[farTurnPositionString uppercaseString] isEqualToString:@"FL"]     ||
                   [[farTurnPositionString uppercaseString] isEqualToString:@"FL "]    ||
                   [[farTurnPositionString uppercaseString] isEqualToString:@"F"]      ||
                   [[farTurnPositionString uppercaseString] isEqualToString:@"FELL"]   ||
                   [[farTurnPositionString uppercaseString] isEqualToString:@"OOP"]    ||
                   [farTurnPositionString isEqualToString:@"0"]    ||
                   [farTurnPositionString isEqualToString:@"."]    ||
                   [farTurnPositionString isEqualToString:@"bmp"]  ||
                   [farTurnPositionString isEqualToString:@"fel"])
                {
                    dnfOccurred = YES;
                }
                else
                {
                    farTurnPosition = [farTurnPositionString integerValue];
                    
                    if(farTurnPosition == 0)
                    {
                        // simply ignore these
                        continue;
                    }
                    else if(farTurnPosition == 1)
                    {
                        lineNumber++;  // for lengths in lead
                    }
                
                    finalPositionString = [lines objectAtIndex:lineNumber++];
                    
                    if([[finalPositionString uppercaseString] isEqualToString:@"X"]    ||
                       [[finalPositionString uppercaseString] isEqualToString:@"DNF"]  ||
                       [[finalPositionString uppercaseString] isEqualToString:@"OOP"]  ||
                       [[finalPositionString uppercaseString] isEqualToString:@"FL"]   ||
                       [[finalPositionString uppercaseString] isEqualToString:@"FL "]  ||
                       [[finalPositionString uppercaseString] isEqualToString:@"F"]    ||
                       [[finalPositionString uppercaseString] isEqualToString:@"FELL"] ||
                       [[finalPositionString uppercaseString] isEqualToString:@"OOP"]  ||
                       [finalPositionString isEqualToString:@"0"]      ||
                       [finalPositionString isEqualToString:@"."]      ||
                       [finalPositionString isEqualToString:@"bmp"]    ||
                       [finalPositionString isEqualToString:@"fel"])
                    {
                        dnfOccurred = YES;
                    }
                    else
                    {
                        finalPosition  = [finalPositionString integerValue];
                        
                        if(finalPosition > numberEntries)
                        {
                            finalPosition = numberEntries;
                        }
                        else if(finalPosition == 0 && ([trackAbbreviation isEqualToString:@"NF"] || [trackAbbreviation isEqualToString:@"MG"]))
                        {
                            finalPosition  = farTurnPosition;
                            farTurnPosition = firstTurnPosition;   // not EXACTLY right but close enough
                            lineNumber--;
                        }
                        
                        lineNumber++;  // for lengths in lead
                        
                        finalRaceTimeString = [lines objectAtIndex:lineNumber++];
                        
                        NSString *lengthsBehindOrAheadString = [lines objectAtIndex:lineNumber];
                        
                        if([lengthsBehindOrAheadString isEqualToString:@"OOP"])
                        {
                            finalRaceTime  = kDnfTime;
                            dnfOccurred     = YES;
                        }
                        else
                        {
                            finalRaceTime = [finalRaceTimeString doubleValue];
                        }
                        
                        if(finalRaceTime < 28.00)
                        {
                            finalRaceTime  = kDnfTime;
                            dnfOccurred     = YES;
                        }
                    
                        raceClassString         = @"";
                        NSUInteger trackIndex   = [unmodeledTrackAbbreviationArray indexOfObject:trackAbbreviation];
                        
                        while(raceClassString.length == 0 || raceClassString.length > 2)
                        {
                            if(lineNumber > lines.count - 3)
                            {
                                NSLog(@"could not find raceClass for race");
                                raceClassString = nil;
                                break;
                            }
                            
                            raceClassString = [lines objectAtIndex:lineNumber++];
                            
                            if (raceClassString.length == 3 && [raceClassString characterAtIndex:2] == ' ')
                            {
                                raceClassString = [raceClassString substringToIndex:2];
                            }
                            else if(raceClassString.length == 2 && [raceClassString characterAtIndex:1] == ' ')
                            {
                                raceClassString = [raceClassString substringToIndex:1];
                            }
                            else if([[raceClassString uppercaseString] isEqualToString:@"SCL"])
                            {
                                break;
                            }
                        }
                        
                        // avoids schooling races
                        if(nil == raceClassString)
                        {
                            continue;
                        }
                    
                        if(trackIndex != kNoIndex && raceClassString.length > 0 && raceClassString.length < 3 &&
                                [[raceClassString lowercaseString] characterAtIndex:0] >= 'a' &&
                                [[raceClassString lowercaseString] characterAtIndex:0] <= 'z')
                        {
                            NSMutableArray *thisTracksClasses = [newTrackClassesArray objectAtIndex:trackIndex];
                            
                            if([thisTracksClasses containsObject:raceClassString] == NO)
                            {
                                [thisTracksClasses addObject:raceClassString];
                            }
                        }
                    }
                }
            }
        }
        
        if(dnfOccurred)
        {
            finalPosition = numberEntries;
            
            switch (raceDxIndex)
            {
                case 0:
                    finalRaceTime = 34.50;
                    break;
                
                case 1:
                    finalRaceTime = 42.50;
                    break;
                    
                default:
                    break;
            }
        }
       
        // skip races at distances we are not modeling
        if(raceDxIndex == kNoIndex)
        {
            continue;
        }
        
        if(finalRaceTime == 0.0)	// based on post position
        {
            NSLog(@"zero race time");
            continue;
        }
        else if(trapPosition == 0 || trapPosition > kMaximumNumberEntries)
        {
            NSLog(@"post position error");
            continue;
        }
        else if(breakPosition == 0 || breakPosition > kMaximumNumberEntries)
        {
            NSLog(@"post position error");
            continue;
        }
        else if(firstTurnPosition == 0 || firstTurnPosition > kMaximumNumberEntries)
        {
            NSLog(@"1st turn position error");
            continue;
        }
        else if(farTurnPosition == 0 || farTurnPosition > kMaximumNumberEntries)
        {
            NSLog(@"top of stretch position error");
            continue;
        }
        else if(finalPosition == 0 || finalPosition > kMaximumNumberEntries)
        {
            NSLog(@"final position error");
            continue;
        }
        
        NSLog(@"%@ %@  %@: %lu %lu %lu %lu %lu %lf, %lu", trackAbbreviation, raceDateString, raceClassString, trapPosition, breakPosition, firstTurnPosition, farTurnPosition, finalPosition, finalRaceTime, raceDxIndex);
        
        totalRacesEvaluatedForThisEntry++;
        
        [self addStatsForEntryAtPost:trapPosition
                 withbreakAtPosition:breakPosition
                   firstTurnPosition:firstTurnPosition
                     farTurnPosition:farTurnPosition
                       finalPosition:finalPosition
                        withRaceTime:finalRaceTime
                       atRaceDxIndex:raceDxIndex
            withStatAccumulatorArray:&dxStatsAccumulatorArray[0]
                 andRaceCounterArray:&dxRaceCounterArray[0]
                     forTrackINumber:0];
        
           }
    
    NSLog(@"total Duplicates: %lu", totalDuplicatedForThisEntry);
    return totalRacesEvaluatedForThisEntry;

    return 0;
}

- (BOOL)isLineDateLine:(NSString*)testLine
{
    BOOL answer     = YES;
    BOOL gotAnswer  = NO;
    
    if(testLine.length < 10 || testLine.length > 14)
    {
        answer = NO;
    }
    else
    {
        for(NSUInteger index = 0; index < testLine.length; index++)
        {
            char c = [testLine characterAtIndex:index];
            
            switch (index)
            {
                case 0:
                case 1:
                case 2:
                case 3:
                case 5:
                case 6:
                case 8:
                case 9:
                {
                    if(c < '0' || c > '9')
                    {
                        answer = NO;
                        gotAnswer = YES;
                    }
                    
                    break;
                }
                    
                case 4:
                case 7:
                {
                    if(c != '-')
                    {
                        answer = NO;
                        gotAnswer = YES;
                    }
                    
                    break;
                }
                    
                default:
                    break;
            }
            
            if(gotAnswer)
            {
                break;
            }
        }
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



- (NSUInteger)getIndexOfTrapPosition:(NSArray*)tokens
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

- (ECSprintRaceStats*)getSprintStatsForTrackWithIndex:(NSUInteger)trackIdIndex
                                     withTrackIdArray:(NSArray*)trackIdArray
                                            fromArray:(double*)accumulatedStatsArray
                                      andCounterArray:(int*)accumulatedCounterArray
{
    int raceCounterAtDx						= 0;
	double statValue						= 0.0;
	double breakAverageFromPost				= 0.0;
	double firstTurnAverageFromPost			= 0.0;
	double finalPositionAverageFromPost	= 0.0;
	double finalTimeAverageFromPost		= 0.0;
	double finalPositionAverageFromTurn	= 0.0;

    ECSprintRaceStats *sprintRaceStats = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintRaceStats" inManagedObjectContext:MOC];
    
    // sprint races
    ECPostStats *sprintPostStats_1 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *sprintPostStats_2 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *sprintPostStats_3 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *sprintPostStats_4 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *sprintPostStats_5 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *sprintPostStats_6 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *sprintPostStats_7 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *sprintPostStats_8 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *sprintPostStats_9 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
    
    ECSprintTurnStats *sprintTurnStats_1 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
    ECSprintTurnStats *sprintTurnStats_2 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
    ECSprintTurnStats *sprintTurnStats_3 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
    ECSprintTurnStats *sprintTurnStats_4 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
    ECSprintTurnStats *sprintTurnStats_5 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
    ECSprintTurnStats *sprintTurnStats_6 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
    ECSprintTurnStats *sprintTurnStats_7 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
    ECSprintTurnStats *sprintTurnStats_8 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
    ECSprintTurnStats *sprintTurnStats_9 = [NSEntityDescription insertNewObjectForEntityForName:@"ECSprintTurnStats" inManagedObjectContext:MOC];
    
    NSArray *postStatsSprint = [NSArray arrayWithObjects:sprintPostStats_1, sprintPostStats_2, sprintPostStats_3, sprintPostStats_4, sprintPostStats_5,
                                sprintPostStats_6, sprintPostStats_7, sprintPostStats_8, sprintPostStats_9, nil];
    NSArray *turnStatsSprint = [NSArray arrayWithObjects:sprintTurnStats_1, sprintTurnStats_2, sprintTurnStats_3, sprintTurnStats_4, sprintTurnStats_5,
                                sprintTurnStats_6, sprintTurnStats_7, sprintTurnStats_8, sprintTurnStats_9, nil];
    
    sprintRaceStats.postStats           = [[NSOrderedSet alloc] initWithArray:postStatsSprint];
    sprintRaceStats.sprintTurnStats     = [[NSOrderedSet alloc] initWithArray:turnStatsSprint];
    
    int overallIndex = (int)trackIdIndex * kNumberRaceDistances * kMaximumNumberEntries  * kNumberStatFields;
    
    for(int positionIndex = 0; positionIndex < kMaximumNumberEntries; positionIndex++)
    {
        ECPostStats *postStats          = [sprintRaceStats.postStats objectAtIndex:positionIndex];
        ECSprintTurnStats *turnStats    = [sprintRaceStats.sprintTurnStats objectAtIndex:positionIndex];
        
        // calculate and assign average values for each post
        for(int fieldNumber = 0; fieldNumber < kNumberStatFields; fieldNumber++)
        {
            // get the counter for this fieldNumber at this postIndex for this raceDxIndex
            raceCounterAtDx	= accumulatedCounterArray[overallIndex];
            statValue		= accumulatedStatsArray[overallIndex];
            
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
                    finalPositionAverageFromPost = statValue / raceCounterAtDx;
                    break;
                    
                case 3:
                    finalTimeAverageFromPost = statValue / raceCounterAtDx;
                    break;
                    
                case 4:
                    finalPositionAverageFromTurn = statValue / raceCounterAtDx;
                    break;
                    
                case 5:
                    break;
                    
                default:
                    NSLog(@"bad field number");
                    break;
            }
            
            postStats.boxNumber                 = [NSNumber numberWithInt:positionIndex + 1];
            postStats.breakPositionAverage		= [NSNumber numberWithDouble:breakAverageFromPost];
            postStats.firstTurnPositionAverage	= [NSNumber numberWithDouble:firstTurnAverageFromPost];
            postStats.finalPositionAverage		= [NSNumber numberWithDouble:finalPositionAverageFromPost];
            
            turnStats.turnPosition              = [NSNumber numberWithDouble:positionIndex + 1];
            turnStats.averageFinalPosition		= [NSNumber numberWithDouble:finalPositionAverageFromTurn];
            
            overallIndex++;
        }
    }
    
    return sprintRaceStats;
}

- (ECThreeTurnRaceStats*)getThreeTurnStatsForTrackWithIndex:(NSUInteger)trackIdIndex
                                           withTrackIdArray:(NSArray*)trackIdArray
                                                  fromArray:(double*)accumulatedStatsArray
                                            andCounterArray:(int*)accumulatedCounterArray
{
	int raceCounterAtDx                     = 0;
	double statValue                        = 0.0;
	double breakAverageFromPost             = 0.0;
	double firstTurnAverageFromPost         = 0.0;
	double finalPositionAverageFromPost     = 0.0;
	double finalTimeAverageFromPost         = 0.0;
	double farTurnAverageFromFirstTurn      = 0.0;
	double finalPositionAverageFromFarTurn	= 0.0;
    
    ECThreeTurnRaceStats *threeTurnStats = [NSEntityDescription insertNewObjectForEntityForName:@"ECTwoTurnStats" inManagedObjectContext:MOC];
    
    // 3 turn races
	ECPostStats *post_1 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_2 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_3 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_4 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_5 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_6 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_7 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_8 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_9 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
    
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
    
	NSArray *postStatsArray         = [[NSArray alloc] initWithObjects:post_1, post_2, post_3, post_4, post_5, post_6, post_7, post_8, post_9, nil];
	NSArray *firstTurnStatsArray    = [[NSArray alloc] initWithObjects:firstTurnPos_1, firstTurnPos_2, firstTurnPos_3, firstTurnPos_4, firstTurnPos_5, firstTurnPos_6, firstTurnPos_7, firstTurnPos_8, firstTurnPos_9, nil];
	NSArray *farTurnStatsArray      = [[NSArray alloc] initWithObjects:farTurnPos_1, farTurnPos_2, farTurnPos_3, farTurnPos_4, farTurnPos_5, farTurnPos_6, farTurnPos_7, farTurnPos_8, farTurnPos_9, nil];
	
    threeTurnStats.postStats        = [[NSOrderedSet alloc] initWithArray:postStatsArray];
	threeTurnStats.firstTurnStats   = [[NSOrderedSet alloc] initWithArray:firstTurnStatsArray];
	threeTurnStats.farTurnStats     = [[NSOrderedSet alloc] initWithArray:farTurnStatsArray];
	
    int index = ((int)trackIdIndex * kNumberRaceDistances * kMaximumNumberEntries * kNumberStatFields) + (2 * kMaximumNumberEntries * kNumberStatFields);
    
    for(int positionIndex = 0; positionIndex < kMaximumNumberEntries; positionIndex++)
    {
        ECPostStats *postStats              = [threeTurnStats.postStats objectAtIndex:positionIndex];
        ECFirstTurnStats *firstTurnStats    = [threeTurnStats.firstTurnStats objectAtIndex:positionIndex];
        ECFarTurnStats *farTurnStats        = [threeTurnStats.farTurnStats objectAtIndex:positionIndex];
        
        // calculate and assign average values for each post
        for(int fieldNumber = 0; fieldNumber < kNumberStatFields; fieldNumber++)
        {
            // get the counter for this fieldNumber at this postIndex for this raceDxIndex
            raceCounterAtDx     = accumulatedCounterArray[index];
            statValue           = accumulatedStatsArray[index];
            
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
                    finalPositionAverageFromPost = statValue / raceCounterAtDx;
                    break;
                    
                case 3:
                    finalTimeAverageFromPost = statValue / raceCounterAtDx;
                    break;
                    
                case 4:
                    farTurnAverageFromFirstTurn = statValue / raceCounterAtDx;
                    break;
                    
                case 5:
                    finalPositionAverageFromFarTurn = statValue / raceCounterAtDx;
                    break;
                    
                default:
                    NSLog(@"bad field number");
                    break;
            }
            
            postStats.breakPositionAverage          = [NSNumber numberWithDouble:breakAverageFromPost];
            postStats.firstTurnPositionAverage      = [NSNumber numberWithDouble:firstTurnAverageFromPost];
            postStats.finalPositionAverage          = [NSNumber numberWithDouble:finalPositionAverageFromPost];
            firstTurnStats.averagePositionFarTurn   = [NSNumber numberWithDouble:farTurnAverageFromFirstTurn];
            farTurnStats.averageFinalPosition		= [NSNumber numberWithDouble:finalPositionAverageFromFarTurn];
            
            index++;
        }
    }
    
	return threeTurnStats;
}

- (ECMarathonRaceStats*)getMarathonStatsForTrackWithIndex:(NSUInteger)trackIdIndex
                                         withTrackIdArray:(NSArray*)trackIdArray
                                                fromArray:(double*)accumulatedStatsArray
                                          andCounterArray:(int*)accumulatedCounterArray
{
	int raceCounterAtDx                     = 0;
	double statValue                        = 0.0;
	double breakAverageFromPost             = 0.0;
	double firstTurnAverageFromPost         = 0.0;
	double finalPositionAverageFromPost     = 0.0;
	double finalTimeAverageFromPost         = 0.0;
	double farTurnAverageFromFirstTurn      = 0.0;
	double finalPositionAverageFromFarTurn	= 0.0;
    
    ECMarathonRaceStats *marathonStats = [NSEntityDescription insertNewObjectForEntityForName:@"ECTwoTurnStats" inManagedObjectContext:MOC];
    
    // 2 turn races
	ECPostStats *post_1 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_2 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_3 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_4 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_5 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_6 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_7 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_8 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_9 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
    
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
    
	NSArray *postStatsArray         = [[NSArray alloc] initWithObjects:post_1, post_2, post_3, post_4, post_5, post_6, post_7, post_8, post_9, nil];
	NSArray *firstTurnStatsArray    = [[NSArray alloc] initWithObjects:firstTurnPos_1, firstTurnPos_2, firstTurnPos_3, firstTurnPos_4, firstTurnPos_5, firstTurnPos_6, firstTurnPos_7, firstTurnPos_8, firstTurnPos_9, nil];
	NSArray *farTurnStatsArray      = [[NSArray alloc] initWithObjects:farTurnPos_1, farTurnPos_2, farTurnPos_3, farTurnPos_4, farTurnPos_5, farTurnPos_6, farTurnPos_7, farTurnPos_8, farTurnPos_9, nil];
	
    marathonStats.postStats         = [[NSOrderedSet alloc] initWithArray:postStatsArray];
	marathonStats.firstTurnStats    = [[NSOrderedSet alloc] initWithArray:firstTurnStatsArray];
	marathonStats.farTurnStats      = [[NSOrderedSet alloc] initWithArray:farTurnStatsArray];
	
    int index = ((int)trackIdIndex * kNumberRaceDistances * kMaximumNumberEntries * kNumberStatFields) + (3 * kMaximumNumberEntries * kNumberStatFields);
    
    for(int positionIndex = 0; positionIndex < kMaximumNumberEntries; positionIndex++)
    {
        ECPostStats *postStats              = [marathonStats.postStats objectAtIndex:positionIndex];
        ECFirstTurnStats *firstTurnStats    = [marathonStats.firstTurnStats objectAtIndex:positionIndex];
        ECFarTurnStats *farTurnStats        = [marathonStats.farTurnStats objectAtIndex:positionIndex];
        
        // calculate and assign average values for each post
        for(int fieldNumber = 0; fieldNumber < kNumberStatFields; fieldNumber++)
        {
            // get the counter for this fieldNumber at this postIndex for this raceDxIndex
            raceCounterAtDx     = accumulatedCounterArray[index];
            statValue           = accumulatedStatsArray[index];
            
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
                    finalPositionAverageFromPost = statValue / raceCounterAtDx;
                    break;
                    
                case 3:
                    finalTimeAverageFromPost = statValue / raceCounterAtDx;
                    break;
                    
                case 4:
                    farTurnAverageFromFirstTurn = statValue / raceCounterAtDx;
                    break;
                    
                case 5:
                    finalPositionAverageFromFarTurn = statValue / raceCounterAtDx;
                    break;
                    
                default:
                    NSLog(@"bad field number");
                    break;
            }
            
            postStats.breakPositionAverage          = [NSNumber numberWithDouble:breakAverageFromPost];
            postStats.firstTurnPositionAverage      = [NSNumber numberWithDouble:firstTurnAverageFromPost];
            postStats.finalPositionAverage          = [NSNumber numberWithDouble:finalPositionAverageFromPost];
            firstTurnStats.averagePositionFarTurn   = [NSNumber numberWithDouble:farTurnAverageFromFirstTurn];
            farTurnStats.averageFinalPosition		= [NSNumber numberWithDouble:finalPositionAverageFromFarTurn];
            
            index++;
        }
    }
    
	return marathonStats;
}

- (ECTwoTurnRaceStats*)getTwoTurnStatsForTrackWithIndex:(NSUInteger)trackIdIndex
                                       withTrackIdArray:(NSArray*)trackIdArray
                                              fromArray:(double*)accumulatedStatsArray
                                        andCounterArray:(int*)accumulatedCounterArray
{
	int raceCounterAtDx                     = 0;
	double statValue                        = 0.0;
	double breakAverageFromPost             = 0.0;
	double firstTurnAverageFromPost         = 0.0;
	double finalPositionAverageFromPost     = 0.0;
	double finalTimeAverageFromPost         = 0.0;
	double farTurnAverageFromFirstTurn      = 0.0;
	double finalPositionAverageFromFarTurn	= 0.0;

    ECTwoTurnRaceStats *twoTurnStats = [NSEntityDescription insertNewObjectForEntityForName:@"ECTwoTurnStats" inManagedObjectContext:MOC];
    
    // 2 turn races
	ECPostStats *post_1 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_2 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_3 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_4 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_5 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_6 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_7 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_8 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
	ECPostStats *post_9 = [NSEntityDescription insertNewObjectForEntityForName:@"ECPostStats" inManagedObjectContext:MOC];
    
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
    
	NSArray *postStatsArray         = [[NSArray alloc] initWithObjects:post_1, post_2, post_3, post_4, post_5, post_6, post_7, post_8, post_9, nil];
	NSArray *firstTurnStatsArray    = [[NSArray alloc] initWithObjects:firstTurnPos_1, firstTurnPos_2, firstTurnPos_3, firstTurnPos_4, firstTurnPos_5, firstTurnPos_6, firstTurnPos_7, firstTurnPos_8, firstTurnPos_9, nil];
	NSArray *farTurnStatsArray      = [[NSArray alloc] initWithObjects:farTurnPos_1, farTurnPos_2, farTurnPos_3, farTurnPos_4, farTurnPos_5, farTurnPos_6, farTurnPos_7, farTurnPos_8, farTurnPos_9, nil];
	
    twoTurnStats.postStats      = [[NSOrderedSet alloc] initWithArray:postStatsArray];
	twoTurnStats.firstTurnStats = [[NSOrderedSet alloc] initWithArray:firstTurnStatsArray];
	twoTurnStats.farTurnStats	= [[NSOrderedSet alloc] initWithArray:farTurnStatsArray];
	
    int index = ((int)trackIdIndex * kNumberRaceDistances * kMaximumNumberEntries * kNumberStatFields) + (1 * kMaximumNumberEntries * kNumberStatFields);
    
    for(int positionIndex = 0; positionIndex < kMaximumNumberEntries; positionIndex++)
    {
        ECPostStats *postStats              = [twoTurnStats.postStats objectAtIndex:positionIndex];
        ECFirstTurnStats *firstTurnStats    = [twoTurnStats.firstTurnStats objectAtIndex:positionIndex];
        ECFarTurnStats *farTurnStats        = [twoTurnStats.farTurnStats objectAtIndex:positionIndex];
        
        // calculate and assign average values for each post
        for(int fieldNumber = 0; fieldNumber < kNumberStatFields; fieldNumber++)
        {
            // get the counter for this fieldNumber at this postIndex for this raceDxIndex
            raceCounterAtDx     = accumulatedCounterArray[index];
            statValue           = accumulatedStatsArray[index];
            
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
                    finalPositionAverageFromPost = statValue / raceCounterAtDx;
                    break;
                    
                case 3:
                    finalTimeAverageFromPost = statValue / raceCounterAtDx;
                    break;
                    
                case 4:
                    farTurnAverageFromFirstTurn = statValue / raceCounterAtDx;
                    break;
                    
                case 5:
                    finalPositionAverageFromFarTurn = statValue / raceCounterAtDx;
                    break;
                    
                default:
                    NSLog(@"bad field number");
                    break;
            }
            
            postStats.breakPositionAverage          = [NSNumber numberWithDouble:breakAverageFromPost];
            postStats.firstTurnPositionAverage      = [NSNumber numberWithDouble:firstTurnAverageFromPost];
            postStats.finalPositionAverage          = [NSNumber numberWithDouble:finalPositionAverageFromPost];
            firstTurnStats.averagePositionFarTurn   = [NSNumber numberWithDouble:farTurnAverageFromFirstTurn];
            farTurnStats.averageFinalPosition		= [NSNumber numberWithDouble:finalPositionAverageFromFarTurn];
            
            index++;
        }
    }

	return twoTurnStats;
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
    /*
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
	
	[self fillWorkingPopulationArrayWithOriginalMembers];*/
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
        
		NSArray *thisMembersDnaTrees = [NSArray arrayWithObjects:[self recoverTreeFromString:tempHandicapper.dna.classStrengthTree],
                                                                    [self recoverTreeFromString:tempHandicapper.dna.breakPositionStrengthTree],
                                                                    [self recoverTreeFromString:tempHandicapper.dna.firstTurnPositionStrengthTree],
                                                                    [self recoverTreeFromString:tempHandicapper.dna.farTurnPositionStrengthTree],
                                                                    [self recoverTreeFromString:tempHandicapper.dna.finalRaceStrengthTree],
                                                                    [self recoverTreeFromString:tempHandicapper.dna.earlySpeedRelevanceTree],
                                                                    [self recoverTreeFromString:tempHandicapper.dna.otherRelevanceTree],
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

- (NSString*)getRaceDistanceStringFromString:(NSString*)fileNameString
{
    // As of 3/19/2014 file name are as below:
    //      DB_05-04-2010.e.09
    // making this method obsolete
    
//  NSUInteger index		= 0;
	NSString *raceDxString	= @"Obsolete Method";
	
//	for(index = 0; index < fileNameString.length; index++)
//	{
//		if([fileNameString characterAtIndex:index] == '-')
//		{
//			break;
//		}
//	}
//	
//	if(index < fileNameString.length - 2)
//	{
//		raceDxString = [fileNameString substringFromIndex:index + 1];
//	}
	
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
            NSLog(@"Past Line: %@", [pastLine description]);
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
	pastLineRecord.didNotFinal		= NO;
	pastLineRecord.ranInside		= NO;
		pastLineRecord.ranOutside	= NO;
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
		pastLineRecord.didNotFinal = YES;
	}
	else
	{
		pastLineRecord.firstTurnPosition = [[pastLineArray objectAtIndex:8] integerValue];
		
		if(pastLineRecord.firstTurnPosition == 0)
		{
			pastLineRecord.didNotFinal = YES;
		}
		else
		{
			pastLineRecord.lengthsLeadFirstTurn	= [[pastLineArray objectAtIndex:9] integerValue];
			
			if(pastLineRecord.firstTurnPosition != 1)
			{
				pastLineRecord.lengthsLeadFirstTurn *= -1;  // not in lead then this must be a negative value
			}
			
			pastLineRecord.deltaPosition1		= pastLineRecord.breakPosition - pastLineRecord.firstTurnPosition;
			pastLineRecord.farTurnPosition	= [[pastLineArray objectAtIndex:10] integerValue];
			
			if(pastLineRecord.farTurnPosition == 0)
			{
				pastLineRecord.didNotFinal = YES;
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
					pastLineRecord.didNotFinal = YES;
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
			pastLineRecord.didNotFinal = YES;
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
    /*
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
//    newHandicapper.b              = [self saveTreeToString:[newChildsDnaTreesArray objectAtIndex:kBettingDnaStrand]];
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
    /*
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
       tempNode.leafVariableIndex == kNoIndex &&
       tempNode.leafConstant == kNoConstant)
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
{/*
    // Since dnaTrees are stored as strings in coreData data model
    // need to copy just edited trees to appropriate strings
    ECHandicapper *changedHandicapper = nil;
  
	changedHandicapper.classStrengthTree				= self.workingPopulationDna[popIndex][0];
    changedHandicapper.breakPositionStrengthTree		= self.workingPopulationDna[popIndex][1];
    changedHandicapper.breakSpeedStrengthTree           = self.workingPopulationDna[popIndex][2];
    changedHandicapper.firstTurnPositionStrengthTree	= self.workingPopulationDna[popIndex][3];
    changedHandicapper.firstTurnSpeedStrengthTree		= self.workingPopulationDna[popIndex][4];
    changedHandicapper.farTurnPositionStrengthTree	= self.workingPopulationDna[popIndex][5];
    changedHandicapper.farTurnSpeedStrengthTree	= self.workingPopulationDna[popIndex][6];
	changedHandicapper.finalRaceStrengthTree			= self.workingPopulationDna[popIndex][7];
    changedHandicapper.earlySpeedRelevanceTree			= self.workingPopulationDna[popIndex][8];
    changedHandicapper.otherRelevanceTree				= self.workingPopulationDna[popIndex][9];
   */
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
//            switch (strandNumber)
//            {
//                case kClassDnaStrand:
//                    newbie.classStrengthTree = dnaString;
//                    break;
//                    
//                case kBreakPositionDnaStrand:
//                    newbie.breakPositionStrengthTree = dnaString;
//                    break;
//                    
//                case kBreakSpeedDnaStrand:
//                    newbie.breakSpeedStrengthTree = dnaString;
//                    break;
//                    
//                case kFirstTurnPositionDnaStrand:
//                    newbie.firstTurnPositionStrengthTree = dnaString;
//                    break;
//                    
//                case kFirstTurnSpeedDnaStrand:
//                    newbie.firstTurnSpeedStrengthTree = dnaString;
//                    break;
//                    
//                case kFarTurnPositionDnaStrand:
//                    newbie.farTurnPositionStrengthTree = dnaString;
//                    break;
//                    
//                case kFarTurnSpeedDnaStrand:
//                    newbie.farTurnSpeedStrengthTree = dnaString;
//                    break;
//				
//                case kFinalStrengthDnaStrand:
//					newbie.finalRaceStrengthTree = dnaString;
//					break;
//				
//                case kEarlySpeedRelevanceDnaStrand:
//                    newbie.earlySpeedRelevanceTree = dnaString;
//                    break;
//				
//                case kOtherRelevanceDnaStrand:
//					newbie.otherRelevanceTree = dnaString;
//					break;
//				
//                default:
//                    break;
//            }
//            
//            NSLog(@"%i: %@", popIndex, dnaString);
        }
        
//        newbie.birthGeneration  = self.population.generationNumber;
//        newbie.rank				= [NSNumber numberWithInteger:popIndex];
//        
//        [handicappersSet addObject:newbie];
    }
//    
//    [self.population addIndividualHandicappers:[handicappersSet copy]];
//	
//	return [immutableArray mutableCopy];
        
        return nil;
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
