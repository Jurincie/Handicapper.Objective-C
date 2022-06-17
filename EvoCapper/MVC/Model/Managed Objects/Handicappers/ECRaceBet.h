//
//  ECRaceBet.h
//  EvoCapper
//
//  Created by Ron Jurincie on 4/25/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECBettingResults, ECHandicapper;

@interface ECRaceBet : NSManagedObject

@property (nonatomic, retain) NSNumber * betAmount;
@property (nonatomic, retain) NSString * betDescription;
@property (nonatomic, retain) NSNumber * betPayout;
@property (nonatomic, retain) NSString * bettingSite;
@property (nonatomic, retain) NSString * raceDate;
@property (nonatomic, retain) NSNumber * raceNumber;
@property (nonatomic, retain) NSString * trackName;
@property (nonatomic, retain) ECBettingResults *bettingResults;
@property (nonatomic, retain) ECHandicapper *handicapper;

@end
