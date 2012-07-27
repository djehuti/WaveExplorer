//
//  WaveExplorerDocument.m
//  Wave Explorer
//
//  Created by Ben Cox on 7/12/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import <WaveTools/WaveTools.h>

#import "WaveExplorerDocument.h"
#import "WaveExplorerDocumentWindowController.h"


@interface WaveExplorerDocument ()
{
    DWTWaveFile* mWaveFile;
}
@end


@implementation WaveExplorerDocument

- (DWTWaveChunk*) riffChunk
{
    return mWaveFile.riffChunk;
}

+ (void) initialize
{
    if (self == [WaveExplorerDocument class]) {
        [DWTWaveChunk registerChunkClasses];
    }
}

- (void) dealloc
{
    [mWaveFile release];
    mWaveFile = nil;
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
    [mWaveFile release];
    mWaveFile = [[DWTWaveFile alloc] initWithData:data];
    result = (mWaveFile != nil);
    return result;
}

@end
