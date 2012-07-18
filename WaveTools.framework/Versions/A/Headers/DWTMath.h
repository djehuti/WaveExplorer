//
//  DWTMath.h
//  WaveTools
//
//  Created by Ben Cox on 7/17/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <math.h>


#ifdef __cplusplus
extern "C" {
#endif

// Computes the GCD of x and y, using Euclid's algorithm.
// Throws an exception if x or y is 0.
uint64_t DWTGCD(uint64_t x, uint64_t y);

// Computes the LCM of x and y. Returns 0 if x or y is 0.
uint64_t DWTLCM(uint64_t x, uint64_t y);

// Returns a random 64-bit value.
uint64_t DWTRandom(void);

#define DWTMathAlmostEqual(x, y, tolerance) (abs((x) - (y)) < (tolerance))

#ifndef EXCLUDE_DWTMATH_INLINE_DEFINITIONS

// Returns sinc(x); that is, sin(pi*x)/(pi*x), where sinc(0)===1.
inline double DWTSinc(double x)
{
    double sinc = 1.0;
    if (x != 0.0) {
        double pix = M_PI * x;
        return sin(pix) / pix;
    }
    return sinc;
}

#else // EXCLUDE_DWTMATH_INLINE_DEFINITIONS

double DWTSinc(double x);

#endif // EXCLUDE_DWTMATH_INLINE_DEFINITIONS

#ifdef __cplusplus
}
#endif
