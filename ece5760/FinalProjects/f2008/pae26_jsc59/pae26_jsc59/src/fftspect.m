% Plots a surface and heatmap spectrogram for an audio file.
%     audfile    - path to wav file to analyze
%     fftlen     - length of each FFT
%     samprate   - audio sampling rate
%     freqcutoff - maximum frequency to display (less than samprate)
function fftspect(audfile, fftlen, samprate, freqcutoff)

audfft = audprep(audfile, fftlen);
cutoffindex = floor(freqcutoff / samprate * size(audfft, 1));
audfft = audfft(1:cutoffindex, :);

[n m] = size(audfft);
audlength = n*m;

t = linspace(0, audlength/samprate, m) * 1000;
f = linspace(0, freqcutoff, n);

figure;
surf(t, f, audfft, 'EdgeColor', 'interp');
xlabel('Time (ms)');
ylabel('Frequency (Hz)');
axis tight;

figure;
imagesc(t, f, audfft);
xlabel('Time (ms)');
ylabel('Frequency (Hz)');