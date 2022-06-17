//
//  ECDna.h
//  EvoCapper
//
//  Created by Ron Jurincie on 5/10/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECHandicapper;

@interface ECDna : NSManagedObject

@property (nonatomic, retain) NSString * bettingStrengthDnaStrand;
@property (nonatomic, retain) NSString * breakStrengthDnaStrand;
@property (nonatomic, retain) NSString * getClassStrengthDnaStrand;
@property (nonatomic, retain) NSString * earlySpeedRelevanceDnaStrand;
@property (nonatomic, retain) NSString * midtrackSpeedDnaStrand;
@property (nonatomic, retain) NSString * lateSpeedDnaStrand;
@property (nonatomic, retain) NSString * speedToFirstTurnDnaStrand;
@property (nonatomic, retain) NSString * otherRelevanceDnaStrand;
@property (nonatomic, retain) NSString * recentClassDnaTree;
@property (nonatomic, retain) NSString * raceToFirstTurnDnaStrand;
@property (nonatomic, retain) NSString * raceToFarTurnDnaStrand;
@property (nonatomic, retain) NSString * raceToFinishDnaStrand;
@property (nonatomic, retain) ECHandicapper *handicapper;

@end
