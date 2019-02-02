%{
    HRTF Simulation
    Written by David Li
    
    Project Assumptions:
    2D Space with Constant Elevation.

    Script:
    For Script to work, you MUST load in a HRTF file!
    
    Will probably work something along these lines:
    
    Step 1: Find Known Audio, Sample, Reconstruct
    Step 2: Add FIR Filters for HRTF to Simulate Music to Left and Right
    similar to a concert as proof of concept.
    Step 3: .... 

    - Insert Description, Notes, References, Considerations, Usage -

%}

clc
% clear 

% Obtain Signal from File
% [Signal, Fs] = audioread('RunningSound.mp3');
[Signal, Fs] = audioread('footsteps-3.mp3');
fprintf('Sample Rate of File is %i\n', Fs);


% Obtain Down Sampled Version if Necessary
% downSampleRate = 4;
% DownSignal = downsample(Signal, downSampleRate);

% Test Stereo - Shows Column 1 Corresponds to Left Ear, Column 2 
% Presumably with the Right Ear (Headphones) - Verified
%{
Signal2 = Signal(:, 2).* 0;
Combined_Signal = [Signal(:,1) Signal2];
sound(Combined_Signal, Fs);
%}

%{
% Test Quality of Down Sampled Sound - 
% Music File Details:
% RunningSound.mp3 = N/A
fprintf('Testing Down Sampled Sound\n');
sound(DownSignal, Fs/downSampleRate);
pause(5);
fprintf('Sound Sample End - Script Continuing\n');
%}

% Define Sound Source Location (Relative) - For Testing
% Azimuth Values - 
% Directly Left: -90
% Directly Right: 90
% Elevation Values - 
% Directly Ahead (Level to Ears): 0
% Directly Behind (Level to Ears): 180
Azimuth     = -45;
Elevation   = 0;  
Distance    = 5;    % Distance (unitless) used for drop off of sound.

% Obtain Left and Right Ear FIR Filters based on Location Parameters
[FIR_L Azimuth_L_Err Elevation_L_Err] = getNearestUCDpulse(Azimuth, Elevation, hrir_l);
[FIR_R Azimuth_L_Err Elevation_L_Err] = getNearestUCDpulse(Azimuth, Elevation, hrir_r);

% Create Left and Right Ear Sounds
SOUND_L = conv(FIR_L, Signal(:, 1));
SOUND_R = conv(FIR_R, Signal(:, 1));

% Generate Composite Signal
SOUND = [SOUND_L, SOUND_R];

% Alternative Function for 'conv'
% SOUND_L = filter(FIR_L, 1, Signal(:, 1));
% SOUND_R = filter(FIR_R, 1, Signal(:, 1));

% Cut Sound File into Shorter Sound Sample for Use on Board.
% values found experimentally
LEN_SOUND = length(SOUND);  % In Samples
BASE = 185000;                   % Starting Sample
DURATION = 48000 * 2;          % Duration of Sample we Want (1.1 mult seems to work)
PAUSE_DURATION = 2;
SOUND_L_SHORT = SOUND_L(BASE:BASE + DURATION);
SOUND_R_SHORT = SOUND_R(BASE:BASE + DURATION);
SOUND_SHORT = [SOUND_L_SHORT SOUND_R_SHORT];

%%

Distance = 6;
% Account for Distance
% Plays Footsteps Approaching User.
fprintf('Distance Sound Test Start. \n');
while Distance >= 1
    % (Distance)^2 Amplitude Dropoff
    SOUND_L_NEW = SOUND_L_SHORT.* (1 / (Distance^2));
    SOUND_R_NEW = SOUND_R_SHORT.* (1 / (Distance^2));
    SOUND_NEW = [SOUND_L_NEW SOUND_R_NEW];
    % Play Modified HRTF Sound (Shortened)
    fprintf('Distance = %f | Elevation = %f \n', Distance, Elevation);
    sound(SOUND_NEW, Fs);
    pause( (1/Fs) * DURATION);
    
    % Shorten Distance
    Distance = Distance - 0.5;
end
fprintf('Distance Sound Test End. \n');

%}
%% 
%{

% Test Sound Around User:
fprintf('Locational Sound Test Start. \n');

% Locational Parameters
Azimuths = (-90:5:90);
Elevation = 0;  % Initial Value. 0 for Directly Ahead and 180 for Directly Behind

for x = 1:length(Azimuths)
    Azimuth = Azimuths(x);
    Elevation;
    [FIR_L Azimuth_L_Err Elevation_L_Err] = getNearestUCDpulse(Azimuth, Elevation, hrir_l);
    [FIR_R Azimuth_R_Err Elevation_R_Err] = getNearestUCDpulse(Azimuth, Elevation, hrir_r);    
    
    % Optional Downsampled FIR Testing (specifically for ~11 kHz)
    % In a sense actually works better oddly?
    % oddly?
    % FIR_L = downsample(FIR_L, 4);
    % FIR_R = downsample(FIR_R, 4);
    
    SOUND_L = conv(FIR_L, Signal(:, 1));
    SOUND_R = conv(FIR_R, Signal(:, 1));
    SOUND_L_SHORT = SOUND_L(BASE:BASE + DURATION);
    SOUND_R_SHORT = SOUND_R(BASE:BASE + DURATION);
    SOUND_SHORT = [SOUND_L_SHORT SOUND_R_SHORT];
    fprintf('Start')
    sound(SOUND_SHORT, Fs);
    pause(PAUSE_DURATION);
    fprintf('Stop')
end

Elevation = 180;
for x = 1:length(Azimuths)
    Azimuth = Azimuths(length(Azimuths) - x + 1);
    Elevation;
    [FIR_L Azimuth_L_Err Elevation_L_Err] = getNearestUCDpulse(Azimuth, Elevation, hrir_l);
    [FIR_R Azimuth_R_Err Elevation_R_Err] = getNearestUCDpulse(Azimuth, Elevation, hrir_r);    
    
    
    SOUND_L = conv(FIR_L, Signal(:, 1));
    SOUND_R = conv(FIR_R, Signal(:, 1));
    SOUND_L_SHORT = SOUND_L(BASE:BASE + DURATION);
    SOUND_R_SHORT = SOUND_R(BASE:BASE + DURATION);
    SOUND_SHORT = [SOUND_L_SHORT SOUND_R_SHORT];
    sound(SOUND_SHORT, Fs);
    pause(PAUSE_DURATION);
end
fprintf('Locational Sound Test End. \n');

%}
%%
%{
% Test Downsampled Sound
% Restore Locational Parameters
Azimuth     = -45;
Elevation   = 0;  
[FIR_L Azimuth_L_Err Elevation_L_Err] = getNearestUCDpulse(Azimuth, Elevation, hrir_l);
[FIR_R Azimuth_R_Err Elevation_R_Err] = getNearestUCDpulse(Azimuth, Elevation, hrir_r);    

% Test 1:
% Description: 
% RunningSound.mp3 is sampled (default) at ~11 kHz.  In essence, this is
% already a downsampled signal. Does this mean we should also downsample
% the FIR filter?  Maybe. Let's see if this is necessary / should be.
% Result: Seems to still work. Let's explore this further.

fprintf('Downsampling Test 1 - Start \n');

% For General Down Sampling
% FIR_L_DOWN = downsample(FIR_L, downSampleRate);
% FIR_R_DOWN = downsample(FIR_R, downSampleRate);

% For RunningSound.mp3 in Particular (Already Downsampled by 4)
FIR_L_DOWN = downsample(FIR_L, 4);
FIR_R_DOWN = downsample(FIR_R, 4);
SOUND_L_DOWN_1 = conv(FIR_L_DOWN, Signal(:, 1));
SOUND_R_DOWN_1 = conv(FIR_R_DOWN, Signal(:, 1));
SOUND_DOWN_1 = [SOUND_L_DOWN_1 SOUND_R_DOWN_1];
sound(SOUND_DOWN_1, Fs);
pause(5);

fprintf('Downsampling Test 1 - End. \n');

%}
%%
%{ 

% Test 2:
% Description: 
% RunningSound.mp3 is sampled (default) at ~11 kHz.  In essence, this is
% already a downsampled signal. Let's see what it sounds like at 44.1 kHz.
% Result: Actually... just 4x the speed audio happens.

% Code TBD (Tested Before)

%}
%% 
%{

% Should I downsample the base signal first?  Yes. Probably.

SOUND_L = conv(FIR_L, Signal(:, 1));
SOUND_R = conv(FIR_R, Signal(:, 1));
SOUND_L_SHORT = SOUND_L(BASE:BASE + DURATION);
SOUND_R_SHORT = SOUND_R(BASE:BASE + DURATION);
SOUND_SHORT = [SOUND_L_SHORT SOUND_R_SHORT];
SIGNAL_SHORT = Signal(BASE: BASE + DURATION);

SIGNAL_DOWN = downsample(SIGNAL_SHORT, downSampleRate);
Fs_DOWN = Fs / downSampleRate;

%}
%% Generate Files

%% 
%{

% Generate ROM Blocks

% Set up Sound.
BASE = 185000;                  % Starting Sample
DURATION = 48000 * 1.1;         % Duration of Sample we Want
Signal_Short = Signal(BASE : BASE + DURATION);

fileID = fopen('footstep.v','w');
fprintf(fileID, 'module Footstep(clock, address, impulse); \n');
fprintf(fileID, '\tinput clock;\n\tinput [31:0] address;\n\toutput signed [26:0] impulse;\n\treg signed [26:0] impulse_reg;\n\tassign impulse = impulse_reg;\n\talways @ (posedge clock) begin\n\t\tcase(address)\n');
count = 0;  % Used for ROM Indexing
fprintf(fileID, '\t\t\t// Values stored in 2.25 Fixed Point \n');
fprintf(fileID, '\t\t\t// Length of Sound is %i\n', length(Signal_Short));

% Write Table
for i = 1:length(Signal_Short)
    TEMP = fix(2^25 * Signal_Short(i));
    if (TEMP < 0)
        fprintf(fileID, '\t\t\t32''h%s: impulse_reg = -27''d%i;\n', dec2hex(count,4), abs(TEMP));
    else
        fprintf(fileID, '\t\t\t32''h%s: impulse_reg = 27''d%i;\n', dec2hex(count,4), TEMP);
    end
    count = count + 1;
end

fprintf('Elements Written = %i\n', count);
fprintf(fileID, '\t\tendcase\n');
fprintf(fileID, '\tend\n');
fprintf(fileID, 'endmodule\n');
fprintf('File Written DONE!\n')
fclose(fileID);

fprintf('Playing Sound');
sound(Signal_Short, 44100); 

%}

%%

% C Array

% Set up Sound.
BASE = 185000;                  % Starting Sample
DURATION = 48000 * 1.1;         % Duration of Sample we Want
Signal_Short = Signal(BASE : BASE + DURATION);

fileID = fopen('footstep_full.c','w');
fprintf(fileID, '/* Footstep Sounds */ \n');
fprintf(fileID, '// Numbers encoded in 2.25 fixed point \n');
fprintf(fileID, '// Length of Array is %i.\n', length(Signal));
fprintf(fileID, '// Time per loop at 44100 kHz is %d seconds.\n', length(Signal_Short)/44100);

fprintf(fileID, '\nint footstep[] = {');

% for i = 1:length(Signal_Short)
for i = 1:length(Signal)
    % TEMP = fix(2^25 * Signal_Short(i));
    TEMP = fix(2^25 * Signal(i));
    if (TEMP < 0)
        fprintf(fileID, '-%i', abs(TEMP));
    else
        fprintf(fileID, '%i', TEMP);
    end
    if i < length(Signal) 
        fprintf(fileID,', ');
    end
end
fprintf(fileID, '};');
fclose(fileID);
fprintf('C Array Printed. \n');

%}
%%
%{
fileID = fopen('FIR.v','w');
for i = 1:200
    Filter_Value = fix(2^25 * FIR_L(i));
    fprintf(fileID, '%i', Filter_Value);
    if i < 200
        fprintf(fileID,', ');
    else
        fprintf(fileID,'\n');
    end
end

for i = 1:200
    Filter_Value = fix(2^25 * FIR_R(i));
    fprintf(fileID, '%i', Filter_Value);
    if i < 200
        fprintf(fileID,', ');
    else
        fprintf(fileID,'\n');
    end
end

fclose(fileID);
%}