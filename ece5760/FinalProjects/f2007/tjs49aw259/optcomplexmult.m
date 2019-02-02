function output = optcomplexmult (a, b)
    a_r = real(a);
    a_c = imag(a);

    b_r = real(b);
    b_c = imag(b);

    K = a_r + a_c;
    L = b_r + b_c;
    F = a_r * b_r;
    G = a_c * b_c;
    H = K * L;
    
    d_r = F - G;
    d_c = H - F - G;

    output = d_r + j * d_c;
end