//
//  Constants.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/25/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#ifndef EvoCapper_Constants_h
#define EvoCapper_Constants_h

#define kMaximumPopulationSize 1024
#define kMaximumTreeDepth 16
#define kTopMinimumTreeDepth 10
#define kMaximumMutationRate .0099

#define kBreakPositionFromPostStatField 0
#define kFirstTurnPositionFromPostStatField 1
#define kFinishPositionFromPostStatField 2
#define kFinishTimeFromPostStatField 3
#define kTopOFStretchPositionFromFirstTurnStatField 4
#define kFinishPositionFromTopOfStretchStatField 5

#define kNumberHtmlMetaLinesToSkip 8

#define kNoIndex 999

#define kNormalResultFileType 1
#define kDerbyLaneResultFileType 2

#define kMinimumTime 27.00
#define kMaxTimeFor2TurnRace 35.00
#define kMaxTimeFor3TurnRace 45.00

// post->break
// post->1stTurn
// post->finish
// post->time
// 1stTurn->2ndTurn
// 2ndTurn->finsh
#define kNumberStatFields 6

// 550, 678 ignoring all others (for now) FIX: later
#define kNumberRaceDistances 2

// define reprocuction type AND fitness selection method
#define kLinearFitnessSelection 0
#define kSuaredFitnessSelection 1

#define kMonogomousPairsMethod 0
#define kAlphasDominateMethod 1
#define kOrgyMethod 1

#define kSelectionMethod kSuaredFitnessSelection
#define kReproductionType kMonogomousPairsMethod

#define kMaximumNumberEntries 9
#define kRandomRange 2.0
#define kRandomGranularity 8
#define kLowestTolerableValue 1.0 / pow(10,kRandomGranularity)

#define kNumberDnaStrands 10
#define kNumberFunctions 8
#define kNumberTwoArgFuncs 4

#define kClassDnaStrand 0
#define kBreakPositionDnaStrand 1
#define kBreakSpeedDnaStrand 2
#define kFirstTurnPositionDnaStrand 3
#define kFirstTurnSpeedDnaStrand 4
#define kTopOfStretchPositionDnaStrand 5
#define kTopOfStretchSpeedDnaStrand 6
#define kFinalStrengthDnaStrand 7
#define kEarlySpeedRelevanceDnaStrand 8
#define kOtherRelevanceDnaStrand 9

#define kTreeRoot 0

#define kAdditionIndex 0
#define kSubtractionIndex 1
#define kMultiplicationIndex 2
#define kDivisionIndex 3
#define kSquareRootIndex 4
#define kSquareIndex 5
#define kNaturalLogIndex 6
#define kReciprocalIndex 7

// tree helpers
#define kFunctionNode 0
#define kVariableNode 1
#define kConstantNode 2
#define kUndefinedNode 999

// Rrlevance Tree vals
#define kMinLevelForRelevanceTrees 3
#define kMaxLevelForRelevanceTrees 4

#define NOT_AN_INDEX 999999
#define NOT_A_CONSTANT 0.0

//const NSString *kPastLinesFoldlerPath = @"/Users/ronjurincie/Desktop/Greyhound Central/Modified Dog Histories";

#endif
