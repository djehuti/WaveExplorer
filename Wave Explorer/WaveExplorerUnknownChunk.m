//
//  WaveExplorerUnknownChunk.m
//  Wave Explorer
//
//  Created by Ben Cox on 7/12/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import "WaveExplorerUnknownChunk.h"


@implementation WaveExplorerUnknownChunk

+ (NSUInteger) autoProcessSubchunkOffset
{
    return NSUIntegerMax;
}

- (NSString*) moreInfo
{
    return NSLocalizedString(@"(no details available)", @"unknown chunk description");
}

@end
