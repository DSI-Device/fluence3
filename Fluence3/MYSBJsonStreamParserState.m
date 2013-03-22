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

#import "MYSBJsonStreamParserState.h"
#import "MYSBJsonStreamParser.h"

MYSBJsonStreamParserStateStart *kMYSBJsonStreamParserStateStart;
MYSBJsonStreamParserStateError *kMYSBJsonStreamParserStateError;
static MYSBJsonStreamParserStateComplete *kMYSBJsonStreamParserStateComplete;

MYSBJsonStreamParserStateObjectStart *kMYSBJsonStreamParserStateObjectStart;
static MYSBJsonStreamParserStateObjectGotKey *kMYSBJsonStreamParserStateObjectGotKey;
static MYSBJsonStreamParserStateObjectSeparator *kMYSBJsonStreamParserStateObjectSeparator;
static MYSBJsonStreamParserStateObjectGotValue *kMYSBJsonStreamParserStateObjectGotValue;
static MYSBJsonStreamParserStateObjectNeedKey *kMYSBJsonStreamParserStateObjectNeedKey;

MYSBJsonStreamParserStateArrayStart *kMYSBJsonStreamParserStateArrayStart;
static MYSBJsonStreamParserState *kMYSBJsonStreamParserStateArrayGotValue;
static MYSBJsonStreamParserState *kMYSBJsonStreamParserStateArrayNeedValue;

@implementation MYSBJsonStreamParserState

- (BOOL)parser:(MYSBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	return NO;
}

- (BOOL)parserShouldStop:(MYSBJsonStreamParser*)parser {
	return NO;
}

- (MYSBJsonStreamParserStatus)parserShouldReturn:(MYSBJsonStreamParser*)parser {
	return MYSBJsonStreamParserWaitingForData;
}

- (void)parser:(MYSBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {}

- (BOOL)needKey {
	return NO;
}

- (NSString*)name {
	return @"<aaiie!>";
}

@end

#pragma mark -

@implementation MYSBJsonStreamParserStateStart

+ (id)sharedInstance {
	if (!kMYSBJsonStreamParserStateStart) {
		kMYSBJsonStreamParserStateStart = [[MYSBJsonStreamParserStateStart alloc] init];
		kMYSBJsonStreamParserStateError = [[MYSBJsonStreamParserStateError alloc] init];
		kMYSBJsonStreamParserStateComplete = [[MYSBJsonStreamParserStateComplete alloc] init];
		kMYSBJsonStreamParserStateObjectStart = [[MYSBJsonStreamParserStateObjectStart alloc] init];
		kMYSBJsonStreamParserStateObjectGotKey = [[MYSBJsonStreamParserStateObjectGotKey alloc] init];
		kMYSBJsonStreamParserStateObjectSeparator = [[MYSBJsonStreamParserStateObjectSeparator alloc] init];
		kMYSBJsonStreamParserStateObjectGotValue = [[MYSBJsonStreamParserStateObjectGotValue alloc] init];
		kMYSBJsonStreamParserStateObjectNeedKey = [[MYSBJsonStreamParserStateObjectNeedKey alloc] init];
		kMYSBJsonStreamParserStateArrayStart = [[MYSBJsonStreamParserStateArrayStart alloc] init];
		kMYSBJsonStreamParserStateArrayGotValue = [[MYSBJsonStreamParserStateArrayGotValue alloc] init];
		kMYSBJsonStreamParserStateArrayNeedValue = [[MYSBJsonStreamParserStateArrayNeedValue alloc] init];
	}
	return kMYSBJsonStreamParserStateStart;
}

- (BOOL)parser:(MYSBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	return token == sbjson_token_array_start || token == sbjson_token_object_start;
}

- (void)parser:(MYSBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {

	MYSBJsonStreamParserState *state = nil;
	switch (tok) {
		case sbjson_token_array_start:
			state = kMYSBJsonStreamParserStateArrayStart;
			break;
			
		case sbjson_token_object_start:
			state = kMYSBJsonStreamParserStateObjectStart;
			break;
			
		case sbjson_token_array_end:
		case sbjson_token_object_end:
			if (parser.multi)
				state = parser.states[parser.depth];
			else
				state = kMYSBJsonStreamParserStateComplete;
			break;
			
		case sbjson_token_eof:
			return;
			
		default:
			state = kMYSBJsonStreamParserStateError;
			break;
	}
	
	
	parser.states[parser.depth] = state;
}

- (NSString*)name { return @"before outer-most array or object"; }

@end

#pragma mark -

@implementation MYSBJsonStreamParserStateComplete

- (NSString*)name { return @"after outer-most array or object"; }

- (BOOL)parserShouldStop:(MYSBJsonStreamParser*)parser {
	return YES;
}

- (MYSBJsonStreamParserStatus)parserShouldReturn:(MYSBJsonStreamParser*)parser {
	return MYSBJsonStreamParserComplete;
}

@end

#pragma mark -

@implementation MYSBJsonStreamParserStateError

- (NSString*)name { return @"in error"; }

- (BOOL)parserShouldStop:(MYSBJsonStreamParser*)parser {
	return YES;
}

- (MYSBJsonStreamParserStatus)parserShouldReturn:(MYSBJsonStreamParser*)parser {
	return MYSBJsonStreamParserError;
}

@end

#pragma mark -

@implementation MYSBJsonStreamParserStateObjectStart

- (NSString*)name { return @"at beginning of object"; }

- (BOOL)parser:(MYSBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	switch (token) {
		case sbjson_token_object_end:
		case sbjson_token_string:
		case sbjson_token_string_encoded:
			return YES;
			break;
		default:
			return NO;
			break;
	}
}

- (void)parser:(MYSBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {
	parser.states[parser.depth] = kMYSBJsonStreamParserStateObjectGotKey;
}

- (BOOL)needKey {
	return YES;
}

@end

#pragma mark -

@implementation MYSBJsonStreamParserStateObjectGotKey

- (NSString*)name { return @"after object key"; }

- (BOOL)parser:(MYSBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	return token == sbjson_token_key_value_separator;
}

- (void)parser:(MYSBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {
	parser.states[parser.depth] = kMYSBJsonStreamParserStateObjectSeparator;
}

@end

#pragma mark -

@implementation MYSBJsonStreamParserStateObjectSeparator

- (NSString*)name { return @"as object value"; }

- (BOOL)parser:(MYSBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	switch (token) {
		case sbjson_token_object_start:
		case sbjson_token_array_start:
		case sbjson_token_true:
		case sbjson_token_false:
		case sbjson_token_null:
		case sbjson_token_integer:
		case sbjson_token_double:
		case sbjson_token_string:
		case sbjson_token_string_encoded:
			return YES;
			break;

		default:
			return NO;
			break;
	}
}

- (void)parser:(MYSBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {
	parser.states[parser.depth] = kMYSBJsonStreamParserStateObjectGotValue;
}

@end

#pragma mark -

@implementation MYSBJsonStreamParserStateObjectGotValue

- (NSString*)name { return @"after object value"; }

- (BOOL)parser:(MYSBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	switch (token) {
		case sbjson_token_object_end:
		case sbjson_token_separator:
			return YES;
			break;
		default:
			return NO;
			break;
	}
}

- (void)parser:(MYSBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {
	parser.states[parser.depth] = kMYSBJsonStreamParserStateObjectNeedKey;
}


@end

#pragma mark -

@implementation MYSBJsonStreamParserStateObjectNeedKey

- (NSString*)name { return @"in place of object key"; }

- (BOOL)parser:(MYSBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	switch (token) {
		case sbjson_token_string:
		case sbjson_token_string_encoded:
			return YES;
			break;
		default:
			return NO;
			break;
	}
}

- (void)parser:(MYSBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {
	parser.states[parser.depth] = kMYSBJsonStreamParserStateObjectGotKey;
}

- (BOOL)needKey {
	return YES;
}

@end

#pragma mark -

@implementation MYSBJsonStreamParserStateArrayStart

- (NSString*)name { return @"at array start"; }

- (BOOL)parser:(MYSBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	switch (token) {
		case sbjson_token_object_end:
		case sbjson_token_key_value_separator:
		case sbjson_token_separator:
			return NO;
			break;
			
		default:
			return YES;
			break;
	}
}

- (void)parser:(MYSBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {
	parser.states[parser.depth] = kMYSBJsonStreamParserStateArrayGotValue;
}

@end

#pragma mark -

@implementation MYSBJsonStreamParserStateArrayGotValue

- (NSString*)name { return @"after array value"; }


- (BOOL)parser:(MYSBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	return token == sbjson_token_array_end || token == sbjson_token_separator;
}

- (void)parser:(MYSBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {
	if (tok == sbjson_token_separator)
		parser.states[parser.depth] = kMYSBJsonStreamParserStateArrayNeedValue;
}

@end

#pragma mark -

@implementation MYSBJsonStreamParserStateArrayNeedValue

- (NSString*)name { return @"as array value"; }


- (BOOL)parser:(MYSBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	switch (token) {
		case sbjson_token_array_end:
		case sbjson_token_key_value_separator:
		case sbjson_token_object_end:
		case sbjson_token_separator:
			return NO;
			break;

		default:
			return YES;
			break;
	}
}

- (void)parser:(MYSBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {
	parser.states[parser.depth] = kMYSBJsonStreamParserStateArrayGotValue;
}

@end

