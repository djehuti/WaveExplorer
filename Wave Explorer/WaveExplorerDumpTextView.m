//
//  WaveExplorerDumpTextView.m
//  Wave Explorer
//
//  Created by Ben Cox on 7/23/12.
//  Copyright (c) 2012 Ben Cox. All rights reserved.
//


#import "WaveExplorerDumpTextView.h"


@implementation WaveExplorerDumpTextView

- (id) initWithCoder:(NSCoder*)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [[self textContainer] setContainerSize:NSMakeSize(FLT_MAX, FLT_MAX)];
        [[self textContainer] setWidthTracksTextView:NO];
    }
    return self;
}

- (id) initWithFrame:(NSRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [[self textContainer] setContainerSize:NSMakeSize(FLT_MAX, FLT_MAX)];
        [[self textContainer] setWidthTracksTextView:NO];
    }
    return self;
}

@end
