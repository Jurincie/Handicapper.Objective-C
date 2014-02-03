//
//  ECClassStats.h
//  EvoCapper
//
//  Created by Ron Jurincie on 2/3/14.
//  Copyright (c) 2014 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECTrackStats;

@interface ECClassStats : NSManagedObject

@property (nonatomic, retain) NSNumber * averageShowTime2Turns;
@property (nonatomic, retain) NSNumber * averageShowTime3Turns;
@property (nonatomic, retain) NSNumber * averageWinTime2Turns;
@property (nonatomic, retain) NSNumber * averageWinTime3Turns;
@property (nonatomic, retain) NSString * raceClass;
@property (nonatomic, retain) NSNumber * raceClassIndex;
@property (nonatomic, retain) ECTrackStats *trackStats;

@end
