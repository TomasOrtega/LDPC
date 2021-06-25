/* belief_propagation_cpp*/

#include "mex.hpp"
#include "mexAdapter.hpp"

#include <vector>

using namespace matlab::data;
using matlab::mex::ArgumentList;

class MexFunction : public matlab::mex::Function {
public:
    void operator()(ArgumentList outputs, ArgumentList inputs) {
        
        //Inputs are points, lambda, Lmax, N_grid
        
        const int n = int(inputs[2][0]);
        const int m = int(inputs[3][0]); // H is n x m
        const int max_it = int(inputs[4][0]);
        TypedArray<bool> H = std::move(inputs[0]);
        TypedArray<bool> v = std::move(inputs[1]);
        
        bool sv[m];
        for (int it = 0; it < max_it; ++it) { // always N max iter
            int w_v = 0;
            for (int i = 0; i < n; ++i) {
                sv[i] = false;
                for (int j = 0; j < m; ++j) {
                    sv[i] ^= (H[i][j] & v[j]);
                }
                w_v += sv[i];
            }
            if (w_v == 0) break;
            
            // Compute weight of v + errors
            
            int min_i = -1;
            int min_w = m;
            int ws[m];
            for (int i = 0; i < m; ++i) {
                ws[i] = 0;
                for (int j = 0; j < n; ++j) {
                    ws[i] += sv[j]^H[j][i];
                }
                if (ws[i] < min_w) {
                    min_w = ws[i];
                    min_i = i;
                }
            }
            if (min_i > 0) v[min_i] = !v[min_i];
            else break;
        }
        outputs[0] = v;
    }
};
