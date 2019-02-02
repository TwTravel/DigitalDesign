#ifndef __COMPLEX_H__
#define __COMPLEX_H__

#include <gmpxx.h>
#include <iostream>
#include <vector>

class complex {
private:
    std::vector<uint32_t> get_limbs(mpf_class big_float, int limb_bits) const {
        std::vector<uint32_t> limbs;
        int sign = sgn(big_float);
        uint32_t flip_mask = (1 << limb_bits) - 1;
        big_float = abs(big_float);
        do {
            uint32_t limb = big_float.get_ui();
            big_float -= limb;
            big_float *= 1 << limb_bits;
            if (sign < 0) limb ^= flip_mask;
            limbs.push_back(limb);
        } while(big_float != 0);

        if (sign < 0) {
            limbs[limbs.size() - 1] += 1;
        }

        return limbs;
    }

public:
    mpf_class real;
    mpf_class imag;

    complex(mpf_class real_, mpf_class imag_) : real(real_), imag(imag_) {};

    complex(mpf_class real_, mpf_class imag_, int precision) : real(real_, precision), imag(imag_, precision) {};

    bool operator==(const complex& other) const {
        return real == other.real && imag == other.imag;
    }

    std::vector<uint32_t> get_real_limbs(int limb_bits) const {
        return this->get_limbs(this->real, limb_bits);
    }

    std::vector<uint32_t> get_imag_limbs(int limb_bits) const {
        return this->get_limbs(this->imag, limb_bits);
    }


};


#endif
