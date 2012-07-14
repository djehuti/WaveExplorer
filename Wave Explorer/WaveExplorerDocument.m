//
//  WaveExplorerDocument.m
//  Wave Explorer
//
//  Created by Ben Cox on 7/12/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import "WaveExplorerDocument.h"
#import "WaveExplorerChunk.h"
#import "WaveExplorerDocumentWindowController.h"


@interface WaveExplorerDocument ()
{
    WaveExplorerChunk* mRiffChunk;
}
@end


@implementation WaveExplorerDocument

@synthesize riffChunk = mRiffChunk;

+ (void) initialize
{
    if (self == [WaveExplorerDocument class]) {
        [WaveExplorerChunk registerChunkClasses];
    }
}

- (void) dealloc
{
    [mRiffChunk release];
    mRiffChunk = nil;
    [super dealloc];
}

- (void) makeWindowControllers
{
    WaveExplorerDocumentWindowController* controller;
    controller = [[[WaveExplorerDocumentWindowController alloc] initWithWindowNibName:@"WaveExplorerDocument"] autorelease];
    [self addWindowController:controller];
}

- (NSData*) dataOfType:(NSString*)typeName error:(NSError**)outError
{
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    }
    return nil;
}

- (BOOL) readFromData:(NSData*)data ofType:(NSString*)typeName error:(NSError**)outError
{
    BOOL result = NO;
    [mRiffChunk release];
    mRiffChunk = nil;
    NSArray* chunks = [[WaveExplorerChunk class] processChunksInData:data];
    if ([chunks count] == 1) {
        WaveExplorerChunk* firstChunk = [chunks objectAtIndex:0];
        if ([firstChunk.chunkID isEqualToString:@"RIFF"]) {
            mRiffChunk = [firstChunk retain];
            result = YES;
        }
    }
    return result;
}

@end
