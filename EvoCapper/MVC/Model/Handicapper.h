//
//  Handicapper.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/1/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Population;

@interface Handicapper : NSManagedObject

@property (nonatomic, retain) NSNumber * birthGeneration;
@property (nonatomic, retain) NSString * breakPositionTree;
@property (nonatomic, retain) NSString * breakSpeedTree;
@property (nonatomic, retain) NSString * earlySpeedRelevanceTree;
@property (nonatomic, retain) NSString * earlySpeedTree;
@property (nonatomic, retain) NSString * lateSpeedTree;
@property (nonatomic, retain) NSString * otherRelevanceTree;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSString * recentClassTree;
@property (nonatomic, retain) NSString * topSpeedTree;
@property (nonatomic, retain) NSNumber * numberWinBets;
@property (nonatomic, retain) NSNumber * numberWinBetWinners;
@property (nonatomic, retain) NSNumber * amountBetOnWinBets;
@property (nonatomic, retain) NSNumber * amountWonOnWinBets1;
@property (nonatomic, retain) Population *handicapperPopulation;

@end
