//
//  Entry.h
//  EvoCapper
//
//  Created by Ron Jurincie on 10/23/13.
//  Copyright (c) 2013 Ron Jurincie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entry : NSManagedObject

@property (nonatomic, retain) NSString  *name;
@property (nonatomic, retain) NSDate    *dateOfBirth;
@property (nonatomic, retain) NSString  *pastLines;

@end
