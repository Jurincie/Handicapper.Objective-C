//
//  ECHandicapper.h
//  EvoCapper
//
//  Created by Ron Jurincie on 2/16/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECPopulation;

@interface ECHandicapper : NSManagedObject

@property (nonatomic, retain) NSNumber * birthGeneration;
@property (nonatomic, retain) NSNumber * amountBetOnWinBets;
@property (nonatomic, retain) NSNumber * numberWinBets;
@property (nonatomic, retain) NSNumber * numberWinBetWinners;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSNumber * winThreshold;

@property (nonatomic, retain) NSString * classStrengthTree;
@property (nonatomic, retain) NSString * breakPositionStrengthTree;
@property (nonatomic, retain) NSString * breakSpeedStrengthTree;
@property (nonatomic, retain) NSString * firstTurnPositionStrengthTree;
@property (nonatomic, retain) NSString * firstTurnSpeedStrengthTree;
@property (nonatomic, retain) NSString * topOfStretchPositionStrengthTree;
@property (nonatomic, retain) NSString * topOfStretchSpeedStrengthTree;
@property (nonatomic, retain) NSString * finalRaceStrengthTree;
@property (nonatomic, retain) NSString * earlySpeedRelevanceTree;
@property (nonatomic, retain) NSString * otherRelevanceTree;

@property (nonatomic, retain) ECPopulation *handicapperPopulation;

@end
