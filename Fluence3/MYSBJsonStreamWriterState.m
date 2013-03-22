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

#import "MYSBJsonStreamWriterState.h"
#import "MYSBJsonStreamWriter.h"

// States
MYSBJsonStreamWriterStateStart *kMYSBJsonStreamWriterStateStart;
MYSBJsonStreamWriterStateComplete *kMYSBJsonStreamWriterStateComplete;
MYSBJsonStreamWriterStateError *kMYSBJsonStreamWriterStateError;

MYSBJsonStreamWriterStateObjectStart *kMYSBJsonStreamWriterStateObjectStart;
static MYSBJsonStreamWriterStateObjectKey *kMYSBJsonStreamWriterStateObjectKey;
static MYSBJsonStreamWriterStateObjectValue *kMYSBJsonStreamWriterStateObjectValue;

MYSBJsonStreamWriterStateArrayStart *kMYSBJsonStreamWriterStateArrayStart;
static MYSBJsonStreamWriterStateArrayValue *kMYSBJsonStreamWriterStateArrayValue;

@implementation MYSBJsonStreamWriterState
- (BOOL)isInvalidState:(MYSBJsonStreamWriter*)writer { return NO; }
- (void)appendSeparator:(MYSBJsonStreamWriter*)writer {}
- (BOOL)expectingKey:(MYSBJsonStreamWriter*)writer { return NO; }
- (void)transitionState:(MYSBJsonStreamWriter *)writer {}
- (void)appendWhitespace:(MYSBJsonStreamWriter*)writer {
	[writer.data appendBytes:"\n" length:1];
	for (int i = 0; i < writer.depth; i++)
	    [writer.data appendBytes:"  " length:2];
}
@end

@implementation MYSBJsonStreamWriterStateObjectStart
- (void)transitionState:(MYSBJsonStreamWriter *)writer {
	writer.states[writer.depth] = kMYSBJsonStreamWriterStateObjectValue;
}
- (BOOL)expectingKey:(MYSBJsonStreamWriter *)writer {
	writer.error = @"JSON object key must be string";
	return YES;
}
@end

@implementation MYSBJsonStreamWriterStateObjectKey
- (void)appendSeparator:(MYSBJsonStreamWriter *)writer {
	[writer.data appendBytes:"," length:1];
}
@end

@implementation MYSBJsonStreamWriterStateObjectValue
- (void)appendSeparator:(MYSBJsonStreamWriter *)writer {
	[writer.data appendBytes:":" length:1];
}
- (void)transitionState:(MYSBJsonStreamWriter *)writer {
	writer.states[writer.depth] = kMYSBJsonStreamWriterStateObjectKey;
}
- (void)appendWhitespace:(MYSBJsonStreamWriter *)writer {
	[writer.data appendBytes:" " length:1];
}
@end

@implementation MYSBJsonStreamWriterStateArrayStart
- (void)transitionState:(MYSBJsonStreamWriter *)writer {
	writer.states[writer.depth] = kMYSBJsonStreamWriterStateArrayValue;
}
@end

@implementation MYSBJsonStreamWriterStateArrayValue
- (void)appendSeparator:(MYSBJsonStreamWriter *)writer {
	[writer.data appendBytes:"," length:1];
}
@end

@implementation MYSBJsonStreamWriterStateStart

+ (id)sharedInstance {
	if (!kMYSBJsonStreamWriterStateStart) {
		kMYSBJsonStreamWriterStateStart = [MYSBJsonStreamWriterStateStart new];
		kMYSBJsonStreamWriterStateComplete = [MYSBJsonStreamWriterStateComplete new];
		kMYSBJsonStreamWriterStateError = [MYSBJsonStreamWriterStateError new];
		kMYSBJsonStreamWriterStateObjectStart = [MYSBJsonStreamWriterStateObjectStart new];
		kMYSBJsonStreamWriterStateObjectKey = [MYSBJsonStreamWriterStateObjectKey new];
		kMYSBJsonStreamWriterStateObjectValue = [MYSBJsonStreamWriterStateObjectValue new];
		kMYSBJsonStreamWriterStateArrayStart = [MYSBJsonStreamWriterStateArrayStart new];
		kMYSBJsonStreamWriterStateArrayValue = [MYSBJsonStreamWriterStateArrayValue new];
	}
	return kMYSBJsonStreamWriterStateStart;
}

- (void)transitionState:(MYSBJsonStreamWriter *)writer {
	writer.states[writer.depth] = kMYSBJsonStreamWriterStateComplete;
}
- (void)appendSeparator:(MYSBJsonStreamWriter *)writer {
}
@end

@implementation MYSBJsonStreamWriterStateComplete
- (BOOL)isInvalidState:(MYSBJsonStreamWriter*)writer {
	writer.error = @"Stream is closed";
	return YES;
}
@end

@implementation MYSBJsonStreamWriterStateError
@end

