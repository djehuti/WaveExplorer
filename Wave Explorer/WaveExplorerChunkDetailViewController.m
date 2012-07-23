//
//  WaveExplorerChunkDetailViewController.m
//  Wave Explorer
//
//  Created by Ben Cox on 7/14/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import <WaveTools/WaveTools.h>

#import "WaveExplorerChunkDetailViewController.h"


@interface WaveExplorerChunkDetailViewController ()
{
    DWTWaveChunk* mChunk;
}
@end


@implementation WaveExplorerChunkDetailViewController

@synthesize chunk = mChunk;

- (id) initWithChunk:(DWTWaveChunk*)chunk
{
    static NSDictionary* s_chunkToNibMap = nil;
    static dispatch_once_t s_chunkToNibMapOnce;
    dispatch_once(&s_chunkToNibMapOnce, ^{
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"WaveExplorerChunkToNibMap" ofType:@"plist"];
        s_chunkToNibMap = [[NSDictionary dictionaryWithContentsOfFile:plistPath] retain];
    });
    NSString* chunkClassName = NSStringFromClass([chunk class]);
    NSString* nibName = [s_chunkToNibMap objectForKey:chunkClassName];
    if (nibName == nil) {
        nibName = @"WaveExplorerChunk";
    }
    if ((self = [super initWithNibName:nibName bundle:nil])) {
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
