//
//  ECDna.h
//  EvoCapper
//
//  Created by Ron Jurincie on 4/25/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECHandicapper;

@interface ECDna : NSManagedObject

@property (nonatomic, retain) NSString * bettingStrengthTree;
@property (nonatomic, retain) NSString * breakPositionStrengthTree;
@property (nonatomic, retain) NSString * classStrengthTree;
@property (nonatomic, retain) NSString * earlySpeedRelevanceTree;
@property (nonatomic, retain) NSString * farTurnPositionStrengthTree;
@property (nonatomic, retain) NSString * finalRaceStrengthTree;
@property (nonatomic, retain) NSString * firstTurnPositionStrengthTree;
@property (nonatomic, retain) NSString * otherRelevanceTree;
@property (nonatomic, retain) ECHandicapper *handicapper;

@end
