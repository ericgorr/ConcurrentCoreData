//
//  Person.h
//  ConcurrentCoreData
//
//  Created by Eric Gorr on 2/2/13.
//  Copyright (c) 2013 Eric Gorr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;

@end
