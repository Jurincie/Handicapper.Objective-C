//
//  ECHandicapper.h
//  EvoCapper
//
//  Created by Ron Jurincie on 1/23/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECPopulation;

@interface ECHandicapper : NSManagedObject

@property (nonatomic, retain) NSNumber * amountBetOnWinBets;
@property (nonatomic, retain) NSNumber * birthGeneration;
@property (nonatomic, retain) NSString * breakPositionTree;
@property (nonatomic, retain) NSString * breakSpeedTree;
@property (nonatomic, retain) NSString * earlySpeedRelevanceTree;
@property (nonatomic, retain) NSString * earlySpeedTree;
@property (nonatomic, retain) NSString * lateSpeedTree;
@property (nonatomic, retain) NSNumber * numberWinBets;
@property (nonatomic, retain) NSNumber * numberWinBetWinners;
@property (nonatomic, retain) NSString * otherRelevanceTree;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSString * recentClassTree;
@property (nonatomic, retain) NSString * topSpeedTree;
@property (nonatomic, retain) NSNumber * winThreshold;
@property (nonatomic, retain) ECPopulation *handicapperPopulation;

@end
