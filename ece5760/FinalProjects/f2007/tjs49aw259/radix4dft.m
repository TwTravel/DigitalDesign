function output = radix4dft (input)

output = zeros(4,1);

% Check for correct input
if (size(input) == [4 1])   
    % Split into real and imaginary for VERILOG-like operations
    x0_r = real(input(1));
    x0_c = imag(input(1));

    x1_r = real(input(2));
    x1_c = imag(input(2));
    
    x2_r = real(input(3));
    x2_c = imag(input(3));
    
    x3_r = real(input(4));
    x3_c = imag(input(4));
    
    % First matrix multiply
    y0_r = x0_r + x2_r;
	y1_r = x0_r - x2_r;
    y2_r = x1_r + x3_r;
    y3_r = x1_r - x3_r;

	y0_c = x0_c + x2_c;
    y1_c = x0_c - x2_c;
    y2_c = x1_c + x3_c;
    y3_c = x1_c - x3_c;
    
    % Second matrix multiply
    z0_r = y0_r + y2_r;
    z0_c = y0_c + y2_c;
    
    z1_r = y1_r + y3_c;
    z1_c = y1_c - y3_r;
    
    z2_r = y0_r - y2_r;
    z2_c = y0_c - y2_c;
    
    z3_r = y1_r - y3_c;
    z3_c = y1_c + y3_r;
    
    % Convert back into MATLAB-like code for the rest of the program
    output(1) = z0_r + j*z0_c;
    output(2) = z1_r + j*z1_c;
    output(3) = z2_r + j*z2_c;
    output(4) = z3_r + j*z3_c;
    
    % The two matrix multiplications in MATLAB form
%    intermediate = [1 0 1 0; 1 0 -1 0; 0 1 0 1; 0 1 0 -1]*input;
%    output = [1 0 1 0; 0 1 0 -j; 1  0 -1 0; 0 1 0 j]*intermediate;
end
