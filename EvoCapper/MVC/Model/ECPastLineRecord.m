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
@synthesize scratched		= _scratched;
@synthesize outOfPicture	= _outOfPicture;
@synthesize didNotFinish	= _didNotFinish;
@synthesize matinee			= _matinee;

@synthesize postPosition			= _postPosition;
@synthesize breakPosition			= _breakPosition;
@synthesize firstTurnPosition		= _firstTurnPosition;
@synthesize topOfStretchPosition	= _topOfStretchPosition;
@synthesize finishPosition			= _finishPosition;
@synthesize lengthsLeadFirstTurn	= _lengthsLeadFirstTurn;
@synthesize lengthsLeadTopOfStretch	= _lengthsLeadTopOfStretch;
@synthesize lengthsLeadFinish		= _lengthsLeadFinish;

@synthesize entryTime	= _entryTime;
@synthesize winningTime	= _winningTime;

@synthesize comments	= _comments;

@synthesize delta1	= _delta1;  // break position - 1st turn position
@synthesize delta2	= _delta2;	// 1st turn position - top of stretch position
@synthesize delta3	= _delta3;	// top of stretch position - finish position


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
12:	position at finish
13:	lead by lengths final
14:	entry finish time
15:	win odds
16:	comments
17:	race class
18:	win entry
19:	place entry
20:	how entry
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
 0: 2012-09-18e14
 1: SP
 2: 660
 3: ...

*/

@end
