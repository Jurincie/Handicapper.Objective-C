//
//  ECFarTurnStatistics.h
//  EvoCapper
//
//  Created by Ron Jurincie on 12/22/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ECRaceDistanceStats;

@interface ECFarTurnStatistics : NSManagedObject

@property (nonatomic, retain) NSNumber * farTurnPosition;
@property (nonatomic, retain) NSNumber * averageFinishPosition;
@property (nonatomic, retain) ECRaceDistanceStats *trackRaceDistanceStats;

@end
