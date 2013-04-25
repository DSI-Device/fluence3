//
//  MyAnnotation.m
//  SimpleMapView
//
//  Created by Mayur Birari .

//

#import "MyAnnotation.h"


@implementation MyAnnotation

@synthesize title;
@synthesize uniqueId;
@synthesize subtitle;
@synthesize coordinate;
@synthesize imageUrl;

- (void)dealloc 
{
	
	self.title = nil;
	self.subtitle = nil;
    self.uniqueId = nil;
    self.imageUrl = nil;
    [self.uniqueId release];
    [self.imageUrl release];
    [super dealloc];
}

- (id)init 
{
    self = [super init]; 
    if (self) 
    { 
        /* custom initialization here ... */ 
    } 
    return self;
} 
@end