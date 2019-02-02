% Prepares a wav file for frequency domain analysis.  Given a desired FFT
% length, fftlen, the following steps are performed
%     1) loads the audio file file
%     2) truncates the audio vector to a multiple of fftlen
%     3) scales the audio vector to be in the range [-1,1]
%     4) reshapes the audio vector to have dimension [fflen,y]
%     5) computes and returns the FFT of the reshaped matrix
function afft = audprep(audfile, fftlen)

% Load
avec  = wavread(audfile);

% Truncate and Scale
alen = length(avec);
alen = alen - mod(alen, fftlen);
avec = avec(1:alen);
avec = avec ./ max(abs(avec));

% Reshape and Compute FFT
amat = reshape(avec, fftlen, alen/fftlen);
afft = abs(fft(amat));
afft = afft ./ max(max(afft));