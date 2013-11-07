//
//  ECPastLine.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/7/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECEntry.h"

@interface ECPastLine : NSObject

@property (nonatomic, strong) NSString  *comments;
@property (nonatomic, strong) NSNumber  *delta1;
@property (nonatomic, strong) NSNumber  *delta2;
@property (nonatomic, strong) NSNumber  *delta3;
@property (nonatomic, strong) NSNumber  *entryTime;
@property (nonatomic, strong) NSNumber  *foundTrouble;
@property (nonatomic, strong) NSNumber  *leadByLengths1;
@property (nonatomic, strong) NSNumber  *leadByLengths2;
@property (nonatomic, strong) NSNumber  *leadByLengthsFinal;
@property (nonatomic, strong) NSNumber  *numberEntries;
@property (nonatomic, strong) NSDate    *pastLineDate;
@property (nonatomic, strong) NSNumber  *positionAtBreak;
@property (nonatomic, strong) NSNumber  *positionAtFinish;
@property (nonatomic, strong) NSNumber  *positionTurn1;
@property (nonatomic, strong) NSNumber  *positionTurn2;
@property (nonatomic, strong) NSNumber  *postNumber;
@property (nonatomic, strong) NSNumber  *postTimeOdds;
@property (nonatomic, strong) NSString  *raceClass;
@property (nonatomic, strong) NSNumber  *raceDistance;
@property (nonatomic, strong) NSString  *trackConditions;
@property (nonatomic, strong) NSString  *trackName;
@property (nonatomic, strong) NSNumber  *weight;
@property (nonatomic, strong) NSNumber  *winningTime;
@property (nonatomic, strong) ECEntry		*entry;

@end
