/*
 Copyright (c) 2010, Stig Brautaset.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:
 
   Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
  
   Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
 
   Neither the name of the the author nor the names of its contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "MYSBJsonStreamParserAdapter.h"

@interface MYSBJsonStreamParserAdapter ()

- (void)pop;
- (void)parser:(MYSBJsonStreamParser*)parser found:(id)obj;

@end



@implementation MYSBJsonStreamParserAdapter

@synthesize delegate;
@synthesize skip;

#pragma mark Housekeeping

- (id)init {
	self = [super init];
	if (self) {
		keyStack = [[NSMutableArray alloc] initWithCapacity:32];
		stack = [[NSMutableArray alloc] initWithCapacity:32];
		
		currentType = MYSBJsonStreamParserAdapterNone;
	}
	return self;
}	

- (void)dealloc {
	[keyStack release];
	[stack release];
	[super dealloc];
}

#pragma mark Private methods

- (void)pop {
	[stack removeLastObject];
	array = nil;
	dict = nil;
	currentType = MYSBJsonStreamParserAdapterNone;
	
	id value = [stack lastObject];
	
	if ([value isKindOfClass:[NSArray class]]) {
		array = value;
		currentType = MYSBJsonStreamParserAdapterArray;
	} else if ([value isKindOfClass:[NSDictionary class]]) {
		dict = value;
		currentType = MYSBJsonStreamParserAdapterObject;
	}
}

- (void)parser:(MYSBJsonStreamParser*)parser found:(id)obj {
	NSParameterAssert(obj);
	
	switch (currentType) {
		case MYSBJsonStreamParserAdapterArray:
			[array addObject:obj];
			break;

		case MYSBJsonStreamParserAdapterObject:
			NSParameterAssert(keyStack.count);
			[dict setObject:obj forKey:[keyStack lastObject]];
			[keyStack removeLastObject];
			break;
			
		case MYSBJsonStreamParserAdapterNone:
			if ([obj isKindOfClass:[NSArray class]]) {
				[delegate parser:parser foundArray:obj];
			} else {
				[delegate parser:parser foundObject:obj];
			}				
			break;

		default:
			break;
	}
}


#pragma mark Delegate methods

- (void)parserFoundObjectStart:(MYSBJsonStreamParser*)parser {
	if (++depth > skip) {
		dict = [[NSMutableDictionary new] autorelease];
		[stack addObject:dict];
		currentType = MYSBJsonStreamParserAdapterObject;
	}
}

- (void)parser:(MYSBJsonStreamParser*)parser foundObjectKey:(NSString*)key_ {
	[keyStack addObject:key_];
}

- (void)parserFoundObjectEnd:(MYSBJsonStreamParser*)parser {
	if (depth-- > skip) {
		id value = [dict retain];
		[self pop];
		[self parser:parser found:value];
		[value release];
	}
}

- (void)parserFoundArrayStart:(MYSBJsonStreamParser*)parser {
	if (++depth > skip) {
		array = [[NSMutableArray new] autorelease];
		[stack addObject:array];
		currentType = MYSBJsonStreamParserAdapterArray;
	}
}

- (void)parserFoundArrayEnd:(MYSBJsonStreamParser*)parser {
	if (depth-- > skip) {
		id value = [array retain];
		[self pop];
		[self parser:parser found:value];
		[value release];
	}
}

- (void)parser:(MYSBJsonStreamParser*)parser foundBoolean:(BOOL)x {
	[self parser:parser found:[NSNumber numberWithBool:x]];
}

- (void)parserFoundNull:(MYSBJsonStreamParser*)parser {
	[self parser:parser found:[NSNull null]];
}

- (void)parser:(MYSBJsonStreamParser*)parser foundNumber:(NSNumber*)num {
	[self parser:parser found:num];
}

- (void)parser:(MYSBJsonStreamParser*)parser foundString:(NSString*)string {
	[self parser:parser found:string];
}

@end
