//
//  RaceRecord.h
//  EvoCapper
//
//  Created by Ron Jurincie on 11/2/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RaceRecord : NSObject

@property (readonly, nonatomic, strong) NSString *trackName;
@property (readonly, nonatomic, strong)	NSDate *raceDate;
@property (readonly, nonatomic, strong)	NSString *raceClass;
@property (readonly, nonatomic, strong)	NSArray *postNames;
@property (readonly, nonatomic, strong)	NSArray *postWinOdds;
@property (readonly, assign)			NSUInteger raceDistance;

- (id)initFromResultsFileSubstring:(NSString*)resultSubstring;


@end
