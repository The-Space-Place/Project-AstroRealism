/*****************************************************************************************
 *                                                                                       *
 * Joshua Carter (c) 2026                                                                *
 *                                                                                       *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this  *
 * software and associated documentation files (the "Software"), to deal in the Software *
 * without restriction, including without limitation the rights to use, copy, modify,    *
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to    *
 * permit persons to whom the Software is furnished to do so, subject to the following   *
 * conditions:                                                                           *
 *                                                                                       *
 * The above copyright notice and this permission notice shall be included in all copies *
 * or substantial portions of the Software.                                              *
 *                                                                                       *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,   *
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A         *
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT    *
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF  *
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE  *
 * OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                                         *
 ****************************************************************************************/

// Limb darkening, with cos(psi) = N . V (N is the surface normal and V the direction
// towards the viewer):
//
//   I(psi) / I(0) = 1 - 0.47 (1 - cos psi) - 0.23 (1 - cos psi)^2
//                     + sum_{k=3}^{N} A_k (1 - cos psi)^k
//
// The series is evaluated up to and including the k = 3 term (the fourth term overall).
// A_3 is a uniform that defaults to 0 on the C++ side, which reduces the expression to
// the two fixed terms. Further terms can be appended to limbDarkeningFactor in the same
// way if more coefficients become available.

#ifndef LIMBDARKENING_GLSL
#define LIMBDARKENING_GLSL

uniform float limbDarkeningA3;

// cosPsi is N . V. Returns I(psi) / I(0), which is 1 at the disc center
float limbDarkeningFactor(float cosPsi) {
    float x = 1.0 - clamp(cosPsi, 0.0, 1.0);

    // Horner form of 1 - 0.47 x - 0.23 x^2 + A_3 x^3
    float f = 1.0 + x * (-0.47 + x * (-0.23 + x * limbDarkeningA3));
    return max(f, 0.0);
}

#endif // LIMBDARKENING_GLSL
