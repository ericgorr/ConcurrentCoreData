//
//  ELGWorkerOperation.m
//  ConcurrentCoreData
//
//  Created by Eric Gorr on 2/2/13.
//  Copyright (c) 2013 Eric Gorr. All rights reserved.
//

#import "ELGWorkerOperation.h"
#import "Person.h"
#import "Globals.h"



@implementation ELGWorkerOperation



- (void) main
{
	
	[self setMoc:[[NSManagedObjectContext alloc] init]];
	[[self moc] setPersistentStoreCoordinator:[self psc]];
	[[self moc] setUndoManager:nil];
	[[self moc] setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
	
	Person* person;
	
	for ( NSUInteger x = 0; x < 5000; x++ )
	{	
		person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[self moc]];
		[person setName:[NSString stringWithFormat:@"Person worker %lu", x]];
	}
	
	sleep( 10 );
	
	NSError*	error;
	
	[[self moc] save:&error];
	
	NSLog( @"save person error: %@", error );
	
	NSEntityDescription*	entityDescription	= [NSEntityDescription entityForName:@"Globals" inManagedObjectContext:[self moc]];
	NSFetchRequest*			request				= [[NSFetchRequest alloc] init];

	[request setEntity:entityDescription];
	
	NSArray*	array		= [[self moc] executeFetchRequest:request error:&error];
	Globals*	globals		= [array objectAtIndex:0];
	
	while ( [self isCancelled] == NO )
	{		
		[globals setCounterA:[NSNumber numberWithInteger:[[globals counterA] integerValue] + 1]];
	
		NSLog( @"saveing globals" );

		[[self moc] save:&error];
		
		NSLog( @"save global (%@) error: %@", [globals counterA], error );

		sleep( 10 );
	
		NSLog( @"woke up" );
		NSLog( @"-------" );
		NSLog( @"-------" );
	}
}




@end
