//
//  WaveExplorerFmtChunk.h
//  Wave Explorer
//
//  Created by Ben Cox on 7/12/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import "WaveExplorerChunk.h"


@interface WaveExplorerFmtChunk : WaveExplorerChunk

@property (nonatomic, readwrite, assign) uint16_t compressionCode;
@property (nonatomic, readwrite, assign) uint16_t numChannels;
@property (nonatomic, readwrite, assign) uint32_t sampleRate;
@property (nonatomic, readwrite, assign) uint32_t averageBytesPerSecond;
@property (nonatomic, readwrite, assign) uint16_t blockAlign;
@property (nonatomic, readwrite, assign) uint16_t bitsPerSample;
@property (nonatomic, readwrite, assign) uint16_t extraFormatBytes;

@end
