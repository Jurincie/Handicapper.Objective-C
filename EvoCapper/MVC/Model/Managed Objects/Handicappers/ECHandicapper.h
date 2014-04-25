//
//  ECHandicapper.h
//  EvoCapper
//
//  Created by Ron Jurincie on 4/25/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECBettingResults, ECDna, ECPopulation, ECRaceBet;

@interface ECHandicapper : NSManagedObject

@property (nonatomic, retain) NSNumber * birthGeneration;
@property (nonatomic, retain) NSNumber * minimumNumberRaces;
@property (nonatomic, retain) NSNumber * winThreshold;
@property (nonatomic, retain) NSSet *bets;
@property (nonatomic, retain) NSSet *bettingResults;
@property (nonatomic, retain) ECDna *dna;
@property (nonatomic, retain) ECPopulation *population;
@end

@interface ECHandicapper (CoreDataGeneratedAccessors)

- (void)addBetsObject:(ECRaceBet *)value;
- (void)removeBetsObject:(ECRaceBet *)value;
- (void)addBets:(NSSet *)values;
- (void)removeBets:(NSSet *)values;

- (void)addBettingResultsObject:(ECBettingResults *)value;
- (void)removeBettingResultsObject:(ECBettingResults *)value;
- (void)addBettingResults:(NSSet *)values;
- (void)removeBettingResults:(NSSet *)values;

@end
