//
//  ECBettingResults.h
//  EvoCapper
//
//  Created by Ron Jurincie on 4/25/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECHandicapper, ECRaceBet;

@interface ECBettingResults : NSManagedObject

@property (nonatomic, retain) NSNumber * amountBet;
@property (nonatomic, retain) NSNumber * amountWon;
@property (nonatomic, retain) NSString * betType;
@property (nonatomic, retain) NSNumber * numberBets;
@property (nonatomic, retain) NSNumber * numberWinners;
@property (nonatomic, retain) NSSet *bets;
@property (nonatomic, retain) ECHandicapper *handicapper;
@end

@interface ECBettingResults (CoreDataGeneratedAccessors)

- (void)addBetsObject:(ECRaceBet *)value;
- (void)removeBetsObject:(ECRaceBet *)value;
- (void)addBets:(NSSet *)values;
- (void)removeBets:(NSSet *)values;

@end
