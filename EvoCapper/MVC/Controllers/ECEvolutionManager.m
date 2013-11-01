//
//  ECEvolutionManager.m
//  EvoCapper
//
//  Created by Ron Jurincie on 10/23/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

// Since we only want (1) EvolutionManager Ever to be created
// We have made this class a singleton

#import "ECEvolutionManager.h"
#import "Population.h"

#define MOC [[NSApp delegate]managedObjectContext]

@implementation ECEvolutionManager

@synthesize population                      = _population;
@synthesize generationsAlreadyEvolved       = _generationsAlreadyEvolved;
@synthesize trainingGenerationsThisCycle    = _trainingGenerationsThisCycle;
@synthesize workingPopulationMembersDna     = _workingPopulationMembersDna;
@synthesize sortedArrayOfHandicapperSet     = _sortedArrayOfHandicapperSet;

#pragma mark Singleton Methods

+ (id)sharedManager
{
    static ECEvolutionManager *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

- (id)init
{
    
    NSLog(@"ECEVolutionManager.init called");
    
    if (self = [super init])
    {
        // seed random number generator here ONLY
        time_t seed = time(NULL);
        srand((unsigned) time(&seed));
        
        self.population                     = nil;
        self.generationsAlreadyEvolved      = 0;
        self.trainingGenerationsThisCycle   = 0;
    }
    
    return self;
}

#pragma custom class methods

- (void)createNewPopoulationWithName:(NSString*)name
						 initialSize:(NSUInteger)initialSize
						maxTreeDepth:(NSUInteger)maxTreeDepth
						minTreeDepth:(NSUInteger)mintreeDepth
                        mutationRate:(float)mutationRate
                            comments:(NSString*)comments

{
    NSLog(@"createNewPopulation called in ECEvolutionManager");
    
    self.population = [NSEntityDescription insertNewObjectForEntityForName:@"HandicapperPopulation"
                                                    inManagedObjectContext:MOC];
    if(self.population)
    {
        NSArray *unsortedArray = [NSArray arrayWithObjects:[self.population.individualHandicappers allObjects], nil];
        
        // sort unsortedArray on populationIndex into sortedArray...
        NSSortDescriptor *popIndexDescriptor    = [[NSSortDescriptor alloc] initWithKey:@"populationIndex" ascending:YES];
        NSArray *sortDescriptors                = @[popIndexDescriptor];
        self.sortedArrayOfHandicapperSet        = [unsortedArray sortedArrayUsingDescriptors:sortDescriptors];


        self.population.populationName  = @"NewPopulationTest 1.0.0.0";
        self.population.initialSize     = [NSNumber numberWithInteger:initialSize];
        self.population.minTreeDepth    = [NSNumber numberWithInteger:mintreeDepth];
        self.population.maxTreeDepth    = [NSNumber numberWithInteger:maxTreeDepth];
        self.population.genesisDate     = [NSDate date];
        self.population.mutationRate    = [NSNumber numberWithFloat:mutationRate];
        
        [self createNewHandicappers:initialSize];
        
        [self fillWorkingPopulationArray];
    }
}

- (void)sortWorkingPopulationUsingIndividualsFitnessValues
{
    // iterate through fitness array
}


- (void)fillWorkingPopulationArray
{
   // fill the workingPopulationMembersDna with
   // arrays of each members trees created from their string form
   self.workingPopulationMembersDna    = [NSMutableArray new];
   Handicapper *tempHandicapper        = nil;
   
   for(int popIndex = 0; popIndex < [self.population.initialSize integerValue]; popIndex++)
   {
       tempHandicapper             = self.sortedArrayOfHandicapperSet[popIndex];
       NSMutableArray *dnaTrees    = [NSMutableArray new];
       
       [dnaTrees addObject:[self recoverTreeFromString:tempHandicapper.breakPositionTree]];
       [dnaTrees addObject:[self recoverTreeFromString:tempHandicapper.breakSpeedTree]];
       [dnaTrees addObject:[self recoverTreeFromString:tempHandicapper.earlySpeedTree]];
       [dnaTrees addObject:[self recoverTreeFromString:tempHandicapper.topSpeedTree]];
       [dnaTrees addObject:[self recoverTreeFromString:tempHandicapper.lateSpeedTree]];
       [dnaTrees addObject:[self recoverTreeFromString:tempHandicapper.recentClassTree]];
       [dnaTrees addObject:[self recoverTreeFromString:tempHandicapper.earlySpeedRelevanceTree]];
       [dnaTrees addObject:[self recoverTreeFromString:tempHandicapper.otherRelevanceTree]];
       
       [self.workingPopulationMembersDna addObject:dnaTrees];
   }
}
                       
- (void)trainPopulationForGenerations:(NSUInteger)numberGenerations
{
    NSLog(@"trainPopulation called in ECEvolutionManager");
    
    for(NSUInteger localGenNumber = 0; localGenNumber < numberGenerations; localGenNumber++)
    {
        [self testPopulation:self.population
		   usingChildrenOnly:localGenNumber > 0 ? YES : NO
	   withResultFilesAtPath:nil];
    
        [self createNextGenerationForPopulation:self.population];
		
	    [self mutatePopulation];
    }
    
    [self updateAndSaveData];
}


   
- (void)testPopulation:(Population*)testPopulation
     usingChildrenOnly:(BOOL)testChildrenOnly
 withResultFilesAtPath:(NSString *)path
{
	// self.workingPopulation array MUST be sorted at this point with:
	//	chldren occupying BOTTOM HALF of array with their indices

    // FIX: actually test
    // for now assuming 100 races are run
    // assign to each handicappers fitnessValues
    
    // iterate through Result files
    //      for each race obtain:
    //          names of entries
    //          post positions of entries
    //          date of race
    //          class of race
    //          distance of race
    
//    NSUInteger startIndex   = testChildrenOnly == TRUE ? [testPopulation.initialSize integerValue] : 0;
//    NSString *pathToFile    = nil;  /// FIX:
//    
//    while(pathToFile)
//    {
//        for(NSUInteger index = startIndex; index < [testPopulation.initialSize integerValue]; index++)
//        {
//            // use information above to simulate race to:
//            //  get predicted winner from EVERY UNTESTED handicapper
//            //  track these picks to accumulate:
//            //      bets made and bets won
//        
//        }
//    }

	NSUInteger startIndex = testChildrenOnly == TRUE ? [testPopulation.initialSize integerValue] / 2: 0;
    
    for(NSUInteger index = startIndex; index < [testPopulation.initialSize integerValue]; index++)
    {
		// FIX: for now just assign 100 for numberWinBets and rand() % 50 for numberWinBetWinners
		Handicapper *tempHandicapper = [self.workingPopulationMembersDna objectAtIndex:index];
		
		tempHandicapper.fitnessStats.numberWinBets			= [NSNumber numberWithInteger:100];
		tempHandicapper.fitnessStats.numberWinBetWinners	= [NSNumber numberWithInteger:rand() % 50];
    }
}

                       
- (void)createNextGenerationForPopulation:(Population*)testPopulation
{
    [self sortWorkingPopulationUsingIndividualsFitnessValues];

    [self replaceBottomHalfOfPopulationWithNewChildren];
}

- (void)replaceBottomHalfOfPopulationWithNewChildren
{
    
}


- (void)mutatePopulation
{
    
}
- (void)crossoverMember:(Handicapper*)parent1
			withMember:(Handicapper*)parent2
			 forChild1:(Handicapper*)child1
			 andChild2:(Handicapper*)child2
{
    // this popMember and sibling are the two children of mother and father
    NSUInteger parent1Index     = [parent1.populationIndex integerValue];
    NSUInteger parent2Index     = [parent2.populationIndex integerValue];
    NSUInteger child1Index      = [child1.populationIndex integerValue];
    NSUInteger child2Index      = [child2.populationIndex integerValue];
    TreeNode *parent1Root       = nil;
    TreeNode *parent2Root       = nil;
    TreeNode *child1Root        = nil;
    TreeNode *child2Root        = nil;
    TreeNode *parent1Crossover  = nil;
    TreeNode *parent2Crossover  = nil;
    TreeNode *grandparent1      = nil;
    TreeNode *grandparent2      = nil;
    NSUInteger parent1Level;
    NSUInteger parent2Level;
    NSUInteger traverseMoves;
    BOOL grandparent1UsingRightChild;
    BOOL grandparent2UsingRightChild;
    
    [self removeOldDnaTreesForChildWithIndex:child1Index];
    [self removeOldDnaTreesForChildWithIndex:child2Index];
    
	for(NSUInteger strandNumber = 0; strandNumber < kNumberDnaStrands; strandNumber++)
	{
        // identify motherCrossoverNode
        traverseMoves = rand() % ([self.population.maxTreeDepth integerValue] * 2);
       
         if(traverseMoves < 2)
        {
            traverseMoves = 2;
        }
        
        parent1Level    = 0;
        parent1Root     = self.workingPopulationMembersDna[parent1Index][strandNumber];
        parent2Root     = self.workingPopulationMembersDna[parent2Index][strandNumber];
        child1Root      = self.workingPopulationMembersDna[child1Index][strandNumber];
        child2Root      = self.workingPopulationMembersDna[child2Index][strandNumber];
		
        // randomly traverse tree
        // identifing mother crossover node
        grandparent1 = nil;
        
        for(NSUInteger moveNumber = 0; moveNumber < traverseMoves; moveNumber++)
        {
            if(parent1Crossover.rightChild && rand() % 2)
            {
                parent1Level++;
                grandparent1                = parent1Crossover;
                parent1Crossover            = parent1Crossover.rightChild;
                grandparent1UsingRightChild = YES;
            }
            else if(parent1Crossover.leftChild)
            {
                parent1Level++;
                grandparent1                = parent1Crossover;
                parent1Crossover            = parent1Crossover.leftChild;
                grandparent1UsingRightChild = NO;
            }
            else	// reached a leaf --> goto root
            {
                parent1Level        = 0;
                parent1Crossover    = parent1Root;
                grandparent1        = nil;
            }
        }
        
        if(parent1Level == 0)
        {
            grandparent1                = parent1Root;
            parent1Crossover            = parent1Crossover.leftChild;
            grandparent1UsingRightChild = NO;
            parent1Level                = 1;
        }
		
        if(nil == parent1Crossover)
        {
            NSLog(@"crossover error alpha1");
            exit(1);
        }
        
        // identify father crossover node
        parent2Crossover = parent2Root;
		
        // randomly traverse tree
        grandparent2 = nil;
        parent2Level = 0;
        
        while(parent2Level != parent1Level)
        {
            if(parent2Crossover.rightChild && rand() % 2)    // identify father crossover node
            {
                parent2Level++;
                grandparent2                = parent2Crossover;
                parent2Crossover            = parent2Crossover.rightChild;
                grandparent2UsingRightChild = YES;
            }
            else if(parent2Crossover.leftChild)
            {
                parent2Level++;
                grandparent2                = parent2Crossover;
                parent2Crossover            = parent2Crossover.leftChild;
                grandparent2UsingRightChild = NO;
            }
            else	// reached a leaf --> goto root
            {
                parent2Crossover    = parent2Root;
                parent2Level        = 0;
            }
        }
        
        if(nil == parent2Crossover)
        {
            NSLog(@"crossover error alpha2");
            exit(1);
        }
		      
        // create danStrand for child 1 //
        
        // copy motherRoot tree into child1Root tree without copying motherCrossover node and below
        self.workingPopulationMembersDna[child1Index][strandNumber] = [self copyTree:parent1Root
                                                                             without:parent1Crossover];
        
        // now copy parent2 crossover node to mothersParentNode's appropriate child
        if(grandparent1UsingRightChild == YES)
        {
            grandparent1.rightChild = [self copyTree:parent2Crossover
                                             without:nil];
        }
        else
        {
            grandparent1.leftChild  = [self copyTree:parent2Crossover
                                             without:nil];
        }
		
        // create danStrand for child 2 //
        
        // copy motherRoot tree into child1Root tree without copying motherCrossover node and below
        self.workingPopulationMembersDna[child2Index][strandNumber] = [self copyTree:parent2Root
                                                                             without:parent2Crossover];
        
        // now copy parent2 crossover node to mothersParentNode's appropriate child
        if(grandparent2UsingRightChild == YES)
        {
            grandparent2.rightChild = [self copyTree:parent1Crossover
                                             without:nil];
        }
        else
        {
            grandparent2.leftChild  = [self copyTree:parent1Crossover
                                             without:nil];
        }
        
        // now replace the appropriate dnaString in Handicapper class
        [self replaceOldDnaStringsForChildWithIndex:child1Index];
        [self replaceOldDnaStringsForChildWithIndex:child2Index];
	}
}

- (void)replaceOldDnaStringsForChildWithIndex:(NSUInteger)popIndex
{
    // Since dnaTrees are stored as strings in coreData data model
    // need to copy just edited trees to appropriate strings
    Handicapper *changedHandicapper = nil;
    
    changedHandicapper.breakPositionTree        = self.workingPopulationMembersDna[popIndex][0];
    changedHandicapper.breakSpeedTree           = self.workingPopulationMembersDna[popIndex][1];
    changedHandicapper.earlySpeedTree           = self.workingPopulationMembersDna[popIndex][2];
    changedHandicapper.topSpeedTree             = self.workingPopulationMembersDna[popIndex][3];
    changedHandicapper.lateSpeedTree            = self.workingPopulationMembersDna[popIndex][4];
    changedHandicapper.recentClassTree          = self.workingPopulationMembersDna[popIndex][5];
    changedHandicapper.earlySpeedRelevanceTree  = self.workingPopulationMembersDna[popIndex][6];
    changedHandicapper.otherRelevanceTree       = self.workingPopulationMembersDna[popIndex][7];
}


- (void)removeOldDnaTreesForChildWithIndex:(NSUInteger)popIndex
{
    
}

- (TreeNode*)copyTree:(TreeNode*)parentRoot
              without:(TreeNode*)doNotCopyNode
{
	TreeNode *newTree   = nil;
    TreeNode *tempNode  = parentRoot;
	
	if(tempNode.functionPtr &&
       tempNode.leafVariableIndex == NOT_AN_INDEX &&
       tempNode.leafConstant == NOT_A_CONSTANT)
	{
        newTree = [[TreeNode alloc] initWithFunctionPointerIndex:tempNode.functionIndex];

        if(tempNode.leftChild == doNotCopyNode)
        {
            newTree.leftChild = nil;
        }
        else
        {
            newTree.leftChild = [self copyTree:tempNode.leftChild
                                       without:doNotCopyNode];
        }
        
        if(tempNode.rightChild)
        {
            if(tempNode.rightChild == doNotCopyNode)
            {
                newTree.rightChild = nil;
            }
            else
            {
                newTree.rightChild = [self copyTree:tempNode.rightChild
                                            without:doNotCopyNode];
            }
        }
    }
    else if(tempNode.leafConstant != NOT_A_CONSTANT)
    {
        newTree = [[TreeNode alloc] initWithConstantValue:tempNode.leafConstant];
    }
    else if(tempNode.leafVariableIndex != NOT_AN_INDEX)
    {
        newTree = [[TreeNode alloc] initWithRaceVariable:tempNode.leafVariableIndex];
    }
    else
    {
        NSLog(@"copy tree error");
        exit(1);
    }
	
	return newTree;
}


- (void)createNewHandicappers:(NSUInteger)initialPopSize
{
    NSMutableSet *handicappersSet = [NSMutableSet new];
    
    // create initial population
    for(int i = 0; i < initialPopSize; i++)
    {
        Handicapper *newbie = [NSEntityDescription insertNewObjectForEntityForName:@"IndividualHandicapper"
                                                            inManagedObjectContext: MOC];
		
		// add a FitnessStats instance to each handicapper
		newbie.fitnessStats = [NSEntityDescription insertNewObjectForEntityForName:@"FitnessStats"
                                                            inManagedObjectContext: MOC];
        NSLog(@"Population Index:%i:", i);
    
        // iterate through dnaStrands
        for(int j = 0; j < kNumberDnaStrands; j++)
        {
            // iterate through dnaStrands
            int rootLevel = 0;
            
            if(j == 6)
            {
                rootLevel = 1;
            }
            else if(j == 7)
            {
                rootLevel = 3;
            }
            
            // don't worry about trees, will rebuild trees later from the strings below
            NSString *dnaString = [self saveTreeToString:[self createTreeForStrand:j
                                                                           atLevel:rootLevel]];
            switch (j)
            {
                case kBreakPosition:
                    newbie.breakPositionTree = dnaString;
                    break;
                    
                case kBreakSpeed:
                    newbie.breakSpeedTree = dnaString;
                    break;
                    
                case kEarlySpeed:
                    newbie.earlySpeedTree = dnaString;
                    break;
                    
                case kTopSpeedStrand:
                    newbie.topSpeedTree = dnaString;
                    break;
                    
                case kLateSpeedStrand:
                    newbie.lateSpeedTree = dnaString;
                    break;
                    
                case kRecentClassStrand:
                    newbie.recentClassTree = dnaString;
                    break;
                    
                case kEarlySpeedRelevanceStrand:
                    newbie.earlySpeedRelevanceTree = dnaString;
                    break;
                    
                case kOtherRelevanceStrand:
                    newbie.otherRelevanceTree = dnaString;
                    break;
                    
                default:
                    break;
            }
            
            NSLog(@"%i: %@", j, dnaString);
        }
        
        newbie.birthGeneration  = self.population.generationNumber;
        newbie.populationIndex  = [NSNumber numberWithInteger:i];
        
        [handicappersSet addObject:newbie];
        NSLog(@"-------");  // forces cr
    }
    
    [self.population addIndividualHandicappers:[handicappersSet copy]];
}

- (TreeNode*)createTreeForStrand:(NSUInteger)dnaStrand
                         atLevel:(NSUInteger)level
{
	// tree is made of TreeNodes
	// as we get deeper into the tree increase probability of leaf node
    level++;
    
    TreeNode *newNode   = nil;
	NSUInteger nodeType = [self getTreeNodeTypeAtLevel:level];
    
    switch (nodeType)
    {
        case kFunctionNode:
        {
            NSUInteger functionNumber = rand() % kNumberFunctions;
            
            // FIX: for now do NOT use quadratic nodes
            // make 9% of function nodes quadratic Iff they are low enough in tree
            // if(rand() % 11 == 10 && level < [[self.population maxTreeDepth] integerValue] - 2)
            if(0)
            {
                newNode = [self getQuadraticNodeAtLevel:level
                                              forStrand:dnaStrand];
            }
            else
            {
                newNode = [[TreeNode alloc] initWithFunctionPointerIndex:functionNumber];
            }
            
            newNode.rightChild  = nil;
            newNode.leftChild   = nil;
            
            if(functionNumber < kNumberTwoArgFuncs)
            {
                newNode.rightChild = [self createTreeForStrand:dnaStrand
                                                       atLevel:level];
            }
            
            // Always make left child
            newNode.leftChild = [self createTreeForStrand:dnaStrand
                                                  atLevel:level];
            
            break;
        }
            
        case kVariableNode:
        {
            NSUInteger arrayIndex   = [self getPastLineVariableForDnaStrand:dnaStrand];
            newNode                 = [[TreeNode alloc] initWithRaceVariable:arrayIndex];
            
            break;
        }
        case kConstantNode:
        {
            double c    = getRand(kRandomRange, kRandomGranularity);
            newNode     = [[TreeNode alloc] initWithConstantValue:c];
            
            break;
        }
            
        case kUndefinedNode:
        {
            NSLog(@"Node definition error");
            
            break;
        }
    }
    
	return newNode;
}


- (NSUInteger)getTreeNodeTypeAtLevel:(NSUInteger)level
{
    NSUInteger nodeType = kUndefinedNode;
    
    if(level < [self.population.minTreeDepth intValue])
	{
		nodeType = kFunctionNode;
	}
	else
    {
        if(rand() % 3 == 0)  // 1/3 of remaining nodes are functions
        {
            nodeType = kFunctionNode;
        }
        else
        {
            // other 2/3 split evenly between constants and variables
            if(rand() % 2)
            {
                nodeType = kConstantNode;
            }
            else
            {
                nodeType = kVariableNode;
            }
        }
    }
    
    return nodeType;
}

- (NSString*)saveTreeToString:(TreeNode*)tree
{
    NSMutableString *treeString = [NSMutableString new];

    if(tree.functionPtr)
    {
        // append funcs name followed by the '('character
        [treeString appendString:tree.functionName];
        [treeString appendString:@"("];
        
        [treeString appendString:[self saveTreeToString:tree.leftChild]];
        
        if(nil != tree.rightChild)
        {
            [treeString appendString:@","];
            [treeString appendString:[self saveTreeToString:tree.rightChild]];
        }
        
        [treeString appendString:@")"];
        
    }
    else if(tree.leafVariableIndex != NOT_AN_INDEX)
    {
        // append index in brackets[]
        [treeString appendString:[NSString stringWithFormat:@"%ld", (unsigned long)tree.leafVariableIndex]];
    }
    else
    {
        if(tree.leafConstant == NOT_A_CONSTANT)
        {
            NSLog(@"save tree error");
        }
        
        // append constant value
        NSString *constantAsString = [NSString stringWithFormat:@"%Lf", tree.leafConstant];
        
        [treeString appendString:constantAsString];
    }
    
    return treeString;
}

- (TreeNode*)recoverTreeFromString:(NSString*)inString
{
    TreeNode *newTree       = nil;
    NSString *newString     = nil;
    NSString *newString2    = nil;
    NSString *token         = nil;
    NSString *arg1String    = nil;
    NSString *arg2String    = nil;
    NSUInteger commaIndex   = 0;
    NSUInteger parenIndex   = 0;
    NSUInteger numArgs      = 0;
    NSUInteger i            = 0;
    char letter             = '$';
    BOOL gotFunction        = FALSE;
	
	i = 0;
    
	while(i < [inString length])
	{
		letter = [inString characterAtIndex:i++];
		
		if(letter == '(')
		{
			gotFunction = TRUE;
			token       = [inString substringToIndex:i-1];
			break;
		}
	}
	
	if(gotFunction)
	{
        newTree.functionName = token;
        
		if([token isEqualToString:@"add"])
		{
			newTree = [[TreeNode alloc] initWithFunctionPointerIndex:kAdditionIndex];
			numArgs = 2;
		}
		else if([token isEqualToString:@"subtract"])
		{
			newTree = [[TreeNode alloc] initWithFunctionPointerIndex:kSubtractionIndex];
			numArgs = 2;
		}
		else if([token isEqualToString:@"multiply"])
		{
			newTree = [[TreeNode alloc] initWithFunctionPointerIndex:kMultiplicationIndex];
			numArgs = 2;
		}
		else if([token isEqualToString:@"divide"])
		{
			newTree =[[TreeNode alloc] initWithFunctionPointerIndex:kDivisionIndex];
			numArgs = 2;
		}
		else if([token isEqualToString:@"squareRoot"])
		{
			newTree = [[TreeNode alloc] initWithFunctionPointerIndex:kSquareRootIndex];
			numArgs = 1;
		}
        else if([token isEqualToString:@"square"])
		{
			newTree = [[TreeNode alloc] initWithFunctionPointerIndex:kSquareIndex];
			numArgs = 1;
		}
		else if([token isEqualToString:@"naturalLog"])
		{
			newTree = [[TreeNode alloc] initWithFunctionPointerIndex:kNaturalLogIndex];;
			numArgs = 1;
		}
		else if([token isEqualToString:@"reciprocal"])
		{
			newTree = [[TreeNode alloc] initWithFunctionPointerIndex:kReciprocalIndex];
			numArgs = 1;
		}
		else
		{
			NSLog(@"bad function name in recoverTreeFromString");
			exit(1);
		}
		
		switch(numArgs)
		{
			case 1:
				parenIndex          = [self getIndexOfClosedParen:inString];
				newString           = [inString substringToIndex:parenIndex-1];
				arg1String          = [newString substringFromIndex:i];
				newTree.leftChild   = [self recoverTreeFromString:arg1String];
				
				break;
                
			case 2:
				parenIndex = [self getIndexOfClosedParen:inString];
				commaIndex = [self getIndexOfComma:inString];
				
				if(commaIndex == 0 || parenIndex <= commaIndex)
				{
					NSLog(@"xxx");
					exit(1);
				}
				
				newString = [inString substringToIndex:parenIndex-1];
				arg2String = [newString substringFromIndex:commaIndex];
				
				newString2 = [newString substringToIndex:commaIndex-1];
				arg1String = [newString2 substringFromIndex:i];
                
				newTree.leftChild   = [self recoverTreeFromString:arg1String];
				newTree.rightChild  = [self recoverTreeFromString:arg2String];
                
				break;
                
			default:
				NSLog(@"numArgs error in recoverTreeFromString");
				exit(1);
		}
	}
	else
	{
		// this token must either be an int between 1 - NUM_PAST_LINE_VARIABLES
		// or a doulbe
		if(inString.length <= 2)
		{
			newTree = [[TreeNode alloc] initWithRaceVariable:[inString intValue]];
		}
		else
		{
			newTree = [[TreeNode alloc] initWithConstantValue:[inString doubleValue]];
		}
	}
	
	if(newTree.functionIndex >= 0 && newTree.functionIndex < 4)
	{
		if(newTree.leftChild == nil || newTree.rightChild == nil)
		{
			NSLog(@"recover error 1");
			exit(1);
		}
	}
	else if(newTree.functionIndex >= 4 && newTree.functionIndex < 9)
	{
		if(nil == newTree.leftChild || newTree.rightChild)
		{
			NSLog(@"recover error 2");
			exit(1);
		}
	}
	else if(newTree.leafConstant == 0.0 &&
            newTree.functionIndex == -1 &&
            newTree.leafVariableIndex == -1)
	{
		NSLog(@"recover error 3");
		exit(1);
	}
	else if((nil == newTree.functionPtr || newTree.functionIndex == -1) &&
            (newTree.leftChild || newTree.rightChild))
	{
		
		NSLog(@"recover error 4");
		exit(1);
	}
    
    return newTree;
}

- (NSUInteger)getIndexOfComma:(NSString*)inString
{
    NSUInteger commaIndex   = 0;
    NSUInteger level        = 0;
    NSUInteger  myLength    = [inString length];
    char letter             = '$';

    while(commaIndex < myLength)
    {
        letter = [inString characterAtIndex:commaIndex++];
        
        if(letter == '(')
        {
            level++;
        }
        else if(letter == ')')
        {
            level--;
        }
        else if(letter == ',' && level == 1)
        {
            break;
        }
    }

    return commaIndex;
}

- (NSUInteger)getIndexOfClosedParen:(NSString*)inString
{
    NSUInteger closedParenIndex = 0;
    NSInteger level             = 0;
    NSInteger myLength          = [inString length];
    char letter                 = '$';

    while(closedParenIndex < myLength)
    {
        letter = [inString characterAtIndex:closedParenIndex++];
        
        if(letter == '(')
        {
            level++;
        }
        else if(letter == ')')
        {
            level--;
            
            if(level == 0)
            {
                break;
            }
            
            if(level < 0)
            {
                NSLog(@"unbalanced parenthesis in tree error 1");
                break;
            }
        }
    }

    return closedParenIndex;
}


- (NSUInteger)getPastLineVariableForDnaStrand:(NSUInteger)dnaStrand
{
    // since each dnaStrand uses a subset of all raceLine variables
    // we carefully assign appropriate indices for later dereferencing the PastLineArray
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
    
    // dna variables by strand
    //
    
    // 0: break position
    //      2:  race class
    //      6:  number of entrys
    //      8:  position at break
    //      9:  winning time
    
    // 1: break speed
    //      2:  race class
    //      6:  number of entrys
    //      8:  position at break
    //      9:  winning time
    
    // 2: early speed
    //      2:  race class
    //      8:  position at break
    //      9:  winning time
    //      13: lead by lengths 1
    //      16: delta 1
    
    // 3: top speed
    //      9:  winning time
    //      12: entry time
    //      16: delta 1
    //      17: delta 2
    //      18: delta 3
    
    // 4: late speed
    //      2:  race class
    //      8:  position at break
    //      9:  winning time
    //      13: lead by lengths 1
    //      16: delta 3

    // 5: recent class
    //      2:  race class
    //      9:  winning time
    //      11: position at finish
    //      12: entry time
    
    // 6: early speed relevance
    //      2:  race class
    //      5:  raceDate (used to calculate "days ago")
    //      7:  post number (used to calculate delta post)

    // 7: other relevance
    //      2:  race class
    //      5:  raceDate (used to calculate "days ago")
    
    NSUInteger pastLineVariableIndex = 999;

    switch (dnaStrand)
    {
        case 0: // break position
        {
            NSUInteger varIndex = rand() % 4;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 3;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 8;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 9;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 1: // break speed
        {
            NSUInteger varIndex = rand() % 5;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 8;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 13;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 16;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 2:  // early speed
        {
            NSUInteger varIndex = rand() % 5;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 12;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 16;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 17;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 18;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 3: // top speed
        {
            NSUInteger varIndex = rand() % 5;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 8;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 13;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 16;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 4:  // late speed
        {
            NSUInteger varIndex = rand() % 5;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 6;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 11;
                    break;
                    
                case 4:
                    pastLineVariableIndex = 12;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
       
        case 5:  // recent class
        {
            NSUInteger varIndex = rand() % 4;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 9;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 11;
                    break;
                    
                case 3:
                    pastLineVariableIndex = 12;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
     
        case 6:  // early speed relevance
        {
            NSUInteger varIndex = rand() % 3;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 5;
                    break;
                    
                case 2:
                    pastLineVariableIndex = 7;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
      
        case 7:  // other relevance
        {
            NSUInteger varIndex = rand() % 2;
            
            switch (varIndex)
            {
                case 0:
                    pastLineVariableIndex = 2;
                    break;
                    
                case 1:
                    pastLineVariableIndex = 5;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        default:
            break;
    }

    if(pastLineVariableIndex == 999)
    {
        NSLog(@"error in getPastLineRaceVariable");
        exit(1);
    }

    return pastLineVariableIndex;
}

// overflow, underflow and division by zero are ignored here
// to be trapped in evalTree method

double getRand(int max, int granularity)
{
    double val  = ((rand() % 10000) / 10000.0) * max;

    if(rand() % 2)
    {
        val *= -1;
    }

    return val;
}


- (TreeNode*)getQuadraticNodeAtLevel:(NSUInteger)level
                           forStrand:(NSUInteger)dnaStrand
{
    // creates the form:  a(x^2) + bx + c
    //  where a, b and c are derived from independent tree branches
    //  and X is a random pastLine variable

    double x = getRand(kRandomRange, kRandomGranularity);
    level++;

    TreeNode *quadTree                          = [[TreeNode alloc] initWithFunctionPointerIndex:kAdditionIndex];       // add

    quadTree.leftChild.leftChild                = [self createTreeForStrand:dnaStrand
                                                                    atLevel:level+1];                                   // 'a' branch
    quadTree.leftChild                          = [[TreeNode alloc] initWithFunctionPointerIndex:kMultiplicationIndex]; // mult
    quadTree.leftChild.rightChild               = [[TreeNode alloc] initWithConstantValue:x];                           // 'x'
    quadTree.leftChild.rightChild.leftChild     = [[TreeNode alloc] initWithFunctionPointerIndex:kSquareIndex];         // square


    quadTree.rightChild                         = [[TreeNode alloc] initWithFunctionPointerIndex:kAdditionIndex];       // add
    quadTree.rightChild.leftChild.leftChild     = [self createTreeForStrand:dnaStrand
                                                                    atLevel:level+1];                                   // 'b' branch
    quadTree.rightChild.leftChild               = [[TreeNode alloc] initWithFunctionPointerIndex:kMultiplicationIndex]; // multiply
    quadTree.rightChild.leftChild.rightChild    = [[TreeNode alloc] initWithConstantValue:x];                           // 'x'
    quadTree.rightChild.rightChild              = [self createTreeForStrand:dnaStrand
                                                                    atLevel:level];                                     // 'c' branch
    return quadTree;
}

- (void)updateAndSaveData
{
    
}


@end
