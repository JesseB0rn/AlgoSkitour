#ifndef NO_CONFIG_FILE
#include "config.metal"
#endif
#include <metal_stdlib>
using namespace metal;

int idx(int x, int y, int width) {
    return y * width + x;
}

int2 imgcoord(int id, int size) { return int2(id % size, id / size); }

float mass_entrainement_Q(float4 state, device float &snowHeight, float speedU) {
    float local_density_density = 1.0;
    float Q_dot = local_density_density * ENTRAINMENT_COEFF * speedU;

    if (Q_dot > snowHeight) {
        Q_dot = snowHeight;
    }
    snowHeight -= Q_dot;
    return Q_dot;
}

float2 effectiveAccel(float H, float4 grav_accels) {
    return float2(grav_accels.x * H, grav_accels.y * H);
}

float muh(float R) {
    return MUH_ZERO * exp(- (R / R_ZERO));
}
float xi(float R) {
    return XI_ZERO * exp((R / R_ZERO));
}

float2 frictionTermsRKE(float R, float H, float U, float4 grav_accels, float2 n) {
    return float2(n.x * (muh(R) * grav_accels.z  * H + (grav_accels.x * U * U) / xi(R)), n.y * (muh(R) * grav_accels.z * H + (grav_accels.y * U * U) / xi(R)));
}

float2 frictionTermsVS(float H, float U, float4 grav_accels) {
    return float2((MUH_ZERO * grav_accels.z * H + grav_accels.x * U * U) / XI_ZERO, (MUH_ZERO * grav_accels.z * H + grav_accels.y * U * U) / XI_ZERO);
}

float energyBalance(float U, float HR, float2 friction) {
    float decay = HR >= 0.0 ? beta * HR : 0.0;
    float gen = length(friction) * U >= 0.0 ? alpha * length(friction) * U : 0.0;
    return gen - decay;
}

float zero_safe_div(float a, float b) {
    float res = a / b;
    if (isnan(res)) {
        res = 0.0;
    }
    return res;
}
float2 zero_safe_div(float2 a, float b) {
    float2 res = a / b;
    if (isnan(res.x)) {
        res.x = 0.0;
    }
    if (isnan(res.y)) {
        res.y = 0.0;
    }
    return res;
}


float4 sourceterm(float4 state, float speedU, device float &snowHeight, float4 grav_accels) {
    float R = zero_safe_div(state.w, state.x);

    float2 u = zero_safe_div(state.yz, state.x);
    float2 n = zero_safe_div(u, speedU);

    float4 source = float4(0.0, 0.0, 0.0, 0.0);

    source.x = mass_entrainement_Q(state, snowHeight, speedU);
    
    float2 S_f = frictionTermsRKE(R, state.x, speedU, grav_accels, n);
    // float2 S_f = frictionTermsVS(state.x, speedU, grav_accels);
    source.yz = effectiveAccel(state.x, grav_accels) - S_f;
    source.w = energyBalance(speedU, state.w, S_f);

    return source;
}

float2x4 F_of_V(float4 state, float4 grav_accels) {
    float2x4 out;
    float k_pa = 1.0;

    out[0] = float4(
        state.y, 
        state.x * pow(zero_safe_div(state.y, state.x), 2) + grav_accels.z * k_pa * (pow(state.x, 2)/2.0), 
        state.y * zero_safe_div(state.z, state.x), 
        state.w * zero_safe_div(state.y, state.x)
    );
    out[1] = float4(
        state.z,
        state.y * zero_safe_div(state.z, state.x),
        state.x * pow(zero_safe_div(state.z, state.x), 2) +  grav_accels.z * k_pa * (pow(state.x, 2)/2.0),
        state.w * zero_safe_div(state.z, state.x)
    );

    return out;
}

float4 InterfaceFlux_F_ij(float4 state, float4 stateOuter, float4 grav_accels, float4 grav_accels_outer, float2 normal) {

    float U = length(zero_safe_div(state.yz, state.x));
    float Uo = length(zero_safe_div(stateOuter.yz, stateOuter.x));

    float s_l = min(U - c_sound, Uo - c_sound);
    float s_r = max(U + c_sound, Uo + c_sound);

    float4 leftFlux = F_of_V(state, grav_accels) * normal;
    float4 rightFlux = F_of_V(stateOuter, grav_accels_outer) * normal;

    if (0 <= s_l) {
        return leftFlux;
    }
    if (s_l <= 0 && 0 <= s_r) {
        return (s_r * leftFlux - s_l * rightFlux + s_r*s_l*(stateOuter - state)) 
        /
        (s_r - s_l);
    }
    if (s_r <= 0) {
        return rightFlux;
    }

    return float4(0.0);
}

float4 numerical_flux(float4 state, float4x4 neighborStates, float4 grav_accels, float4x4 grav_accels_outer) {
    float4x2 cell_normals = float4x2(
        float2(1.0, 0.0),
        float2(0.0, 1.0),
        float2(-1.0, 0.0),
        float2(0.0, -1.0)
    );
    float4 num = float4(0.0);

    for (int j = 0; j < 4; j++) {
        num += InterfaceFlux_F_ij(state, neighborStates[j], grav_accels[j], grav_accels_outer[j], cell_normals[j]);
    }
    float FLUXMAX = 100.0;


    num.x = max(-FLUXMAX, min(num.x, FLUXMAX));
    num.y = max(-FLUXMAX, min(num.y, FLUXMAX));
    num.z = max(-FLUXMAX, min(num.z, FLUXMAX));
    num.w = max(-FLUXMAX, min(num.w, FLUXMAX));
    return -num * resolution;
}



kernel void secondPass(const device float4* grav_accelerations [[buffer(0)]], const device float4* origState [[buffer(1)]], device float4* inputState [[buffer(2)]], device float* snowHeightsIn [[buffer(3)]], device float4* outState [[buffer(4)]], device float* snowHeights [[buffer(5)]], uint id [[ thread_position_in_grid ]]) {

    float4 state = inputState[id];
    float4 orgstate = origState[id];

    snowHeights[id] = snowHeightsIn[id];

    float speedU = length(zero_safe_div(state.yz, state.x));

    float4x4 neighborStates;
    float4x4 grav_accels_neighbor;

    // build neigbors and neigbor gravity
    int2 xy = imgcoord(id, SIZE);
    if (2 >= xy.x || SIZE-2 <= xy.x || 2 >= xy.y || SIZE-2 <= xy.y) {
        outState[id] = float4(0.0);
        return;
    }

    neighborStates = {inputState[idx(xy.x-1, xy.y, SIZE)], inputState[idx(xy.x, xy.y-1, SIZE)], inputState[idx(xy.x+1, xy.y, SIZE)], inputState[idx(xy.x, xy.y+1, SIZE)]};
    grav_accels_neighbor = {grav_accelerations[idx(xy.x-1, xy.y, SIZE)], grav_accelerations[idx(xy.x, xy.y-1, SIZE)], grav_accelerations[idx(xy.x+1, xy.y, SIZE)], grav_accelerations[idx(xy.x, xy.y+1, SIZE)]};
    
    float4 V_n_twostar = state + (dt/cell_area) * (numerical_flux(state, neighborStates, grav_accelerations[id], grav_accels_neighbor));
    outState[id] = 0.5 * (orgstate + V_n_twostar);
    outState[id] -= sourceterm(outState[id], speedU, snowHeights[id], grav_accelerations[id]);
    // outState[id] = state + sourceterm(state, speedU, snowHeights[id], grav_accelerations[id]) * dt;
    // outState[id] = state;
}

kernel void firstPass(const device float4* grav_accelerations [[buffer(0)]], const device float4* inputState [[buffer(1)]], device float4* outState [[buffer(2)]], uint id [[ thread_position_in_grid ]]) {

    float4 state = inputState[id];

    float4x4 neighborStates;
    float4x4 grav_accels_neighbor;

    int2 xy = imgcoord(id, SIZE);
    if (2 >= xy.x || SIZE-2 <= xy.x || 2 >= xy.y || SIZE-2 <= xy.y) {
        outState[id] = float4(0.0);
        return;
    }


    //! This is wrong (most likely): Left right more literal eg. x -> y -> z instead of y -> y <- z
    neighborStates = {inputState[idx(xy.x-1, xy.y, SIZE)], inputState[idx(xy.x, xy.y-1, SIZE)], inputState[idx(xy.x+1, xy.y, SIZE)], inputState[idx(xy.x, xy.y+1, SIZE)]};
    grav_accels_neighbor = {grav_accelerations[idx(xy.x-1, xy.y, SIZE)], grav_accelerations[idx(xy.x, xy.y-1, SIZE)], grav_accelerations[idx(xy.x+1, xy.y, SIZE)], grav_accelerations[idx(xy.x, xy.y+1, SIZE)]};
    

    float4 V_n_star = state + (dt/cell_area) * numerical_flux(state, neighborStates, grav_accelerations[id], grav_accels_neighbor);

    outState[id] = V_n_star;
}