/* syndrome_logical_cpp
 * Computes the syndrome as syndrome_logical
*/

#include "mex.hpp"
#include "mexAdapter.hpp"

#include <vector>

using namespace matlab::data;
using matlab::mex::ArgumentList;

class MexFunction : public matlab::mex::Function {
public:
    void operator()(ArgumentList outputs, ArgumentList inputs) {
        
        //Inputs are points, lambda, Lmax, N_grid
        
        const uint n = uint(inputs[2][0]);
        const uint m = uint(inputs[3][0]); // H is n x m
        TypedArray<bool> H = std::move(inputs[0]);
        TypedArray<bool> v = std::move(inputs[1]);
        ArrayFactory factory;
        TypedArray<bool> w = factory.createArray<bool>({1, n});
        for (uint i = 0; i < n; ++i) {
            w[i] = false;
            for (uint j = 0; j < m; ++j) {
                w[i] ^= (H[i][j] & v[j]);
            }
        }
        outputs[0] = w;
    }
};
