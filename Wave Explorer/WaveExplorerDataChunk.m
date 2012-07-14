//
//  WaveExplorerDataChunk.m
//  Wave Explorer
//
//  Created by Ben Cox on 7/12/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import "WaveExplorerDataChunk.h"


@implementation WaveExplorerDataChunk

+ (NSUInteger) autoProcessSubchunkOffset
{
    return NSUIntegerMax;
}

- (NSString*) moreInfo
{
    return NSLocalizedString(@"Audio Data Chunk", @"Audio data chunk description");
}

@end
