//
//  TreeNode.h
//  GreVolution
//
//  Created by Ron Jurincie on 7/1/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface TreeNode : NSObject

@property (nonatomic, strong)   TreeNode    *leftChild;
@property (nonatomic, strong)   TreeNode    *rightChild;
@property (nonatomic, assign)   long double (*functionPtr)();
@property (nonatomic, strong)   NSString    *functionName;
@property (assign)              long double leafConstant;
@property (assign)              NSInteger   leafVariableIndex;
@property (assign)              NSInteger   functionIndex;
@property (nonatomic, strong)   NSString    *conditionTest;


- (id) initWithFunctionPointerIndex:(NSUInteger)funcPtrIndex;
- (id) initWithConstantValue:(long double)c;
- (id) initWithRaceVariable:(NSUInteger)raceVariableIndex;

/***************/
/* c functions */
/***************/
//
// overflow and underflow are ignored here
// capture and deal with those when trees are evaluated

long double add(double a, double b);
long double subtract(double a, double b);
long double multiply(double a, double b);
long double divide(double a, double b);
long double squareRoot(double a);
long double square(double a);
long double naturalLog(double a);
long double reciprocal(double a);

@end
