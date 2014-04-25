//
//  ECPastLineRecord.m
//  EvoCapper
//
//  Created by Ron Jurincie on 11/14/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import "ECPastLineRecord.h"

@implementation ECPastLineRecord

@synthesize raceDate		= _raceDate;
@synthesize trackName		= _trackName;
@synthesize trackConditions	= _trackConditions;

@synthesize raceClass		= _raceClass;
@synthesize numberEntries	= _numberEntries;
@synthesize raceDistance	= _raceDistance;
@synthesize weight			= _weight;
@synthesize winOdds			= _winOdds;

@synthesize foundTrouble	= _foundTrouble;
@synthesize isMatinee		= _isMatinee;
@synthesize didNotFinal	= _didNotFinal;
@synthesize wasScratched	= _wasScratched;
@synthesize ranInside		= _ranInside;
@synthesize ranMidtrack		= _ranMidtrack;
@synthesize ranOutside		= _ranOutside;

@synthesize trapPosition			= _trapPosition;
@synthesize breakPosition			= _breakPosition;
@synthesize firstTurnPosition		= _firstTurnPosition;
@synthesize farTurnPosition	= _farTurnPosition;
@synthesize finalPosition			= _finalPosition;
@synthesize lengthsLeadFirstTurn	= _lengthsLeadFirstTurn;
@synthesize lengthsLeadFarTurn	= _lengthsLeadFarTurn;
@synthesize lengthsLeadFinal		= _lengthsLeadFinal;

@synthesize entryTime	= _entryTime;
@synthesize winningTime	= _winningTime;
@synthesize comments	= _comments;

@synthesize deltaPosition1	= _deltaPosition1;  // break position - 1st turn position
@synthesize deltaPosition2	= _deltaPosition2;	// 1st turn position - top of stretch position
@synthesize deltaPosition3	= _deltaPosition3;	// top of stretch position - final position
@synthesize deltaLengths1	= _deltaLengths1;	// lengthsInLeadFirstTurn - lengthsInLeadFarTurn
@synthesize deltaLengths2	= _deltaLengths2;	// lengthsInLeadFarTurn - lengthsInLeadFinal

/* ECPastLineRecord line by line definition:

 0:	date / race number / matinee?
 1:	track name
 2:	race distance
 3:	track conditions
 4:	winning time
 5:	weight
 6:	post number
 7:	position at break
 8:	position first turn
 9:	lead by lengths 1
10:	position top of stretch
11:	lead by lengths 2
12:	position at final
13:	lead by lengths final
14:	entry final time
15:	win odds
16:	comments
17:	race class
18:	win entry
19:	place entry
20:	show entry
21:	number entries

*/

/* ECPastLineRecord line by line EXAMPLE:

 0: 2012-09-22e7
 1: SP
 2: 550
 3: F
 4: 31.17
 5: 65
 6: 1
 7: 8
 8: 8
 9:
10: 8
11:
12: 8
13: 16
14: 32.35
15: 5.50
16: Never A Threat-insid
17: D
18: Rs Libbys Secret
19: Gerard Butler
20: Ctw Hot Potato
21: 8
22: Replay
23:
24:

Note: records without replays are missing line 22, so they are 1 line shorter

*/

@end
