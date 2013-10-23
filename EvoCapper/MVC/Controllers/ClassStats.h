//
//  ClassStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/23/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Handicapper;

@interface ClassStats : NSManagedObject

@property (nonatomic, retain) NSNumber      *numberSuperfectaBets;
@property (nonatomic, retain) NSNumber      *numberSuperfectaBetsWinners;
@property (nonatomic, retain) NSNumber      *numberTrifectaBets;
@property (nonatomic, retain) NSNumber      *numberTrifectaBetsWinners;
@property (nonatomic, retain) NSNumber      *numberWinBets;
@property (nonatomic, retain) NSNumber      *numberWinBetWinners;
@property (nonatomic, retain) NSNumber      *returnOnInvestment;
@property (nonatomic, retain) NSNumber      *superfectaBetsCost;
@property (nonatomic, retain) NSNumber      *superfectaBetsWinnings;
@property (nonatomic, retain) NSNumber      *totalCost;
@property (nonatomic, retain) NSNumber      *totalProfit;
@property (nonatomic, retain) NSNumber      *totalWinnings;
@property (nonatomic, retain) NSNumber      *trifectaBetsCost;
@property (nonatomic, retain) NSNumber      *trifectaBetsWinnings;
@property (nonatomic, retain) NSNumber      *winBetsCost;
@property (nonatomic, retain) NSNumber      *winBetsWininings;
@property (nonatomic, retain) Handicapper   *individualHandicapper;

@end
