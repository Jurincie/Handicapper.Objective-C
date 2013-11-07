//
//  ECPastLine.m
//  EvoCapper
//
//  Created by Ron Jurincie on 11/7/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import "ECPastLine.h"

@implementation ECPastLine

@synthesize comments            = _comments; //
@synthesize delta1              = _delta1; //
@synthesize delta2              = _delta2; //
@synthesize delta3              = _delta3; //
@synthesize entryTime           = _entryTime; //
@synthesize foundTrouble        = _foundTrouble;
@synthesize leadByLengths1      = _leadByLengths1; //
@synthesize leadByLengths2      = _leadByLengths2; //
@synthesize leadByLengthsFinal  = _leadByLengthsFinal; //
@synthesize numberEntries       = _numberEntries; //
@synthesize pastLineDate        = _pastLineDate; //
@synthesize positionAtBreak     = _positionAtBreak;
@synthesize positionAtFinish    = _positionAtFinish; //
@synthesize positionTurn1       = _positionTurn1; //
@synthesize positionTurn2       = _positionTurn2; //
@synthesize postNumber          = _postNumber; //
@synthesize postTimeOdds        = _postTimeOdds;
@synthesize raceClass           = _raceClass; //
@synthesize raceDistance        = _raceDistance; //
@synthesize trackConditions     = _trackConditions; //
@synthesize trackName           = _trackName; //
@synthesize weight              = _weight; //
@synthesize winningTime         = _winningTime; //
@synthesize entry				= _entry;

// Here is the map of the PastLine

// 0:  weight
// 1:  race distance
// 2:  race class
// 3:  track name
// 4:  track conditions
// 5:  past race date
// 6:  number of entries
// 7:  post number
// 8:  position at break
// 9:  position turn 1
// 10: position turn 2
// 11: position at finish
// 12: entry time
// 13: lead by lengths 1
// 14: lead by lengths 2
// 15: lead by lengths final
// 16: delat 1
// 17: delta 2
// 18: delta 3
// 19: winning time
// 20: comments

@end
