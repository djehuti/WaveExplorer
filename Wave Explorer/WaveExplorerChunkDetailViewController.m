//
//  WaveExplorerChunkDetailViewController.m
//  Wave Explorer
//
//  Created by Ben Cox on 7/14/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import "WaveExplorerChunkDetailViewController.h"
#import "WaveExplorerChunk.h"


@interface WaveExplorerChunkDetailViewController ()
{
    WaveExplorerChunk* mChunk;
}
@end


@implementation WaveExplorerChunkDetailViewController

@synthesize chunk = mChunk;

- (id) initWithChunk:(WaveExplorerChunk*)chunk
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

@end
