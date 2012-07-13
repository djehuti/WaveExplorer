//
//  WaveExplorerListInfoChunk.m
//  Wave Explorer
//
//  Created by Ben Cox on 7/12/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import "WaveExplorerListInfoChunk.h"


@implementation WaveExplorerListInfoChunk

+ (NSUInteger) autoProcessSubchunkOffset
{
    // The first bit is INFO and then subchunks.
    return 4;
}

- (NSString*) moreInfo
{
    return @"";
}

@end
