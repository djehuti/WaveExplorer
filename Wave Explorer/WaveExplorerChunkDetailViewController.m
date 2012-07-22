//
//  WaveExplorerChunkDetailViewController.m
//  Wave Explorer
//
//  Created by Ben Cox on 7/14/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import <WaveTools/WaveTools.h>

#import "WaveExplorerChunkDetailViewController.h"


@interface DWTWaveChunk (ChunkNibAdditions)

+ (NSString*) nibName;

@end


@interface WaveExplorerChunkDetailViewController ()
{
    DWTWaveChunk* mChunk;
}
@end


@implementation WaveExplorerChunkDetailViewController

@synthesize chunk = mChunk;

- (id) initWithChunk:(DWTWaveChunk*)chunk
{
    if ((self = [super initWithNibName:[[chunk class] nibName] bundle:nil])) {
        mChunk = chunk; // Not retained.
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSLog(@"Wrong WaveExplorerChunkDetailViewController initializer called");
    [self release];
    self = nil;
    return self;
}

- (NSAttributedString*) dataDump
{
    NSString* dumpString = [self.chunk dataDump];
    NSFont* font = [NSFont fontWithName:@"Menlo" size:12.0];
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                               font, NSFontAttributeName,
                               nil];
    NSAttributedString* dataDump = [[NSAttributedString alloc] initWithString:dumpString attributes:attributes];
    return [dataDump autorelease];
}

@end

@implementation DWTWaveChunk (ChunkNibAdditions)

+ (NSString*) nibName
{
    return @"WaveExplorerChunk";
}

@end

@implementation DWTWaveFmtChunk (ChunkNibAdditions)

+ (NSString*) nibName
{
    return @"WaveExplorerFmtChunk";
}

@end

@implementation DWTWaveCueChunk (ChunkNibAdditions)

+ (NSString*) nibName
{
    return @"WaveExplorerCueChunk";
}

@end

@implementation DWTWavePlaylistChunk (ChunkNibAdditions)

+ (NSString*) nibName
{
    return @"WaveExplorerPlaylistChunk";
}

@end

@implementation DWTWaveLabeledTextChunk (ChunkNibAdditions)

+ (NSString*) nibName
{
    return @"WaveExplorerLabeledTextChunk";
}

@end
