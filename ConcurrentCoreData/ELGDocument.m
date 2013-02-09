//
//  ELGDocument.m
//  ConcurrentCoreData
//
//  Created by Eric Gorr on 2/2/13.
//  Copyright (c) 2013 Eric Gorr. All rights reserved.
//

#import "ELGDocument.h"
#import "Person.h"
#import "Globals.h"
#import "ELGWorkerOperation.h"



@implementation ELGDocument



- (id)init
{
    self = [super init];
    
	if ( self )
	{
		_queue = [[NSOperationQueue alloc] init];
		
		// Add your subclass-specific initialization here.
    }
    return self;
}



- (NSString *)windowNibName
{
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"ELGDocument";
}



- (void) mocUpdated:(NSNotification*)note
{
	[[self managedObjectContext] mergeChangesFromContextDidSaveNotification:note];
	
	NSPersistentStore*	store = [[[[self managedObjectContext] persistentStoreCoordinator] persistentStores] lastObject];
    NSError*			error;
	
    [self setFileModificationDate:[[[NSFileManager defaultManager]
                                    attributesOfItemAtPath:[[store URL] path] error:&error] fileModificationDate]];
	
	NSLog( @"document updated from operation" );
}


- (void)windowDidBecomeKey:(NSNotification *)notification
{
	//[self saveDocument:self];
	
	/*
	*/
}



- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];
	
	NSWindow*	documentWindow = [aController window];
	
	[documentWindow setDelegate:self];
	
	[self performSelector:@selector( saveDocument: ) withObject:self afterDelay:0];
	
	[self addObserver:self forKeyPath:NSStringFromSelector( @selector( fileURL ) ) options:NSKeyValueObservingOptionOld context:nil];
	
	// Add any code here that needs to be executed once the windowController has loaded the document's window.
	
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ( [self operation] == nil )
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector( mocUpdated: ) name:NSManagedObjectContextDidSaveNotification object:nil];
		
		NSEntityDescription*	entityDescription	= [NSEntityDescription entityForName:@"Globals" inManagedObjectContext:[self managedObjectContext]];
		NSFetchRequest*			request				= [[NSFetchRequest alloc] init];
		NSError*				error;
		Globals*				globals;
		
		[request setEntity:entityDescription];
		
		NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
		
		if ( [array count] == 0 )
		{
			globals = [NSEntityDescription insertNewObjectForEntityForName:@"Globals" inManagedObjectContext:[self managedObjectContext]];
			[globals setCounterA:@1];
		}
		else
		{
			globals = (Globals*)[array objectAtIndex:0];
			
			[globals setCounterA:[NSNumber numberWithInteger:[[globals counterA] integerValue] + 1]];
		}
		
		Person* person;
		
		person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[self managedObjectContext]];
		[person setName:[NSString stringWithFormat:@"Person startup %@", [NSDate date]]];
		
		[self setOperation:[[ELGWorkerOperation alloc] init]];
		
		[[self operation] setPsc:[[self managedObjectContext] persistentStoreCoordinator]];
		
		[[self queue] addOperation:[self operation]];
	}
}



- (IBAction) actionPlus:(id)sender
{
	NSEntityDescription*	entityDescription	= [NSEntityDescription entityForName:@"Globals" inManagedObjectContext:[self managedObjectContext]];
	NSFetchRequest*			request				= [[NSFetchRequest alloc] init];
	NSError*				error;
	Globals*				globals;
	
	[request setEntity:entityDescription];
	
	NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	globals = (Globals*)[array objectAtIndex:0];
	
	[globals setCounterA:[NSNumber numberWithInteger:[[globals counterA] integerValue] + 1]];
	
	
	if ( [[globals autosave] boolValue] )
	{
		NSLog( @"saving plus action" );
		
		[self saveDocument:self];
	}
}



+ (BOOL)autosavesInPlace
{
    return YES;
}



@end
