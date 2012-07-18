//
//  DWTWaveFmtChunk.h
//  WaveTools
//
//  Created by Ben Cox on 7/17/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import <WaveTools/DWTWaveChunk.h>


@interface DWTWaveFmtChunk : DWTWaveChunk

@property (nonatomic, readwrite, assign) uint16_t compressionCode;
@property (nonatomic, readonly, retain) NSString* compressionDescription;
@property (nonatomic, readwrite, assign) uint16_t numChannels;
@property (nonatomic, readwrite, assign) uint32_t sampleRate;
@property (nonatomic, readwrite, assign) uint32_t averageBytesPerSecond;
@property (nonatomic, readwrite, assign) uint16_t blockAlign;
@property (nonatomic, readwrite, assign) uint16_t bitsPerSample;
@property (nonatomic, readwrite, assign) uint16_t extraFormatBytes;

@end
