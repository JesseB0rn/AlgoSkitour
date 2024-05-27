#ifndef NO_CONFIG_FILE
#include "config.metal"
#endif
#include <metal_stdlib>
using namespace metal;

#define pi 3.14159
#define ga 9.80500

typedef struct {
    float   a, b, c,
            d, e, f,
            g, h, i;
} korn_t;

int idx(int x, int y, int width) {
    return y * width + x;
}

int2 imgcoord(int id, int size) { return int2(id % size, id / size); }

kernel void prepareMap(const device float* inputBuffer [[buffer(0)]], device float4* out [[buffer(1)]], uint id [[ thread_position_in_grid ]]) {
                          
    float4 gaccel = float4(0.0, 0.0, 0.0, 0.0);
    int2 imgCoord = imgcoord(id, SIZE);

    if (1 >= imgCoord.x || SIZE-2 <= imgCoord.x || 1 >= imgCoord.y || SIZE-2 <= imgCoord.y) {
        out[id] = gaccel;
        return;
    }

    int ksi = idx(imgCoord.x - 1, imgCoord.y - 1, SIZE);
    
    korn_t korn = {
        inputBuffer[ksi],          inputBuffer[ksi+1],         inputBuffer[ksi+2],
        inputBuffer[ksi+SIZE],     inputBuffer[ksi+SIZE+1],    inputBuffer[ksi+SIZE+2],
        inputBuffer[ksi+2*SIZE],   inputBuffer[ksi+2*SIZE+1],  inputBuffer[ksi+2*SIZE+2],
    };



    float dzdx = ((korn.c + 2 * korn.f + korn.i) - 
                (korn.a + 2 * korn.d + korn.g)) / (8 * resolution);
    float dzdy = ((korn.g + 2 * korn.h + korn.i) - 
                    (korn.a + 2 * korn.b + korn.c)) / (8 * resolution);
    
    const float slope = atan(sqrt(dzdx * dzdx + dzdy * dzdy));
    const float aspect = atan2(dzdy, -dzdx);
    // const float aspect = 0.0;
    // const float slope = 45.0;
    
    gaccel.x = ga * sin(slope) * cos(aspect);
    gaccel.y = ga * sin(slope) * sin(aspect);
    gaccel.z = -ga * cos(slope);

    out[id] = gaccel;
}


kernel void resampleToSize(const device float* inputBuffer [[buffer(0)]], 
                           device float* outputBuffer [[buffer(1)]], 
                           uint id [[thread_position_in_grid]]) {
    
    uint x = id % SIZE;
    uint y = id / SIZE;

    if (x >= SIZE || y >= SIZE) return;

    float scaleX = float(INSIZE) / float(SIZE);
    float scaleY = float(INSIZE) / float(SIZE);

    float inputX = x * scaleX;
    float inputY = y * scaleY;

    uint x0 = uint(floor(inputX));
    uint y0 = uint(floor(inputY));

    float dx = inputX - float(x0);
    float dy = inputY - float(y0);

    float topLeft     = inputBuffer[y0 * INSIZE + x0];
    float topRight    = inputBuffer[y0 * INSIZE + (x0 + 1)];
    float bottomLeft  = inputBuffer[(y0 + 1) * INSIZE + x0];
    float bottomRight = inputBuffer[(y0 + 1) * INSIZE + (x0 + 1)];

    float top = topLeft + dx * (topRight - topLeft);
    float bottom = bottomLeft + dx * (bottomRight - bottomLeft);
    float value = top + dy * (bottom - top);

    outputBuffer[y * SIZE + x] = value;
}
