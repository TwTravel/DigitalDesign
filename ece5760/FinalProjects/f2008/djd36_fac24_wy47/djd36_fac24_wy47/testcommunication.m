%=====Control a SRS Model SR830 Lockin Amp==================
%Produces a series of tones and makes a spreadsheet of the 
%resulting amp.
%This program is intended to produce a relative amplitude 
%file to be used with GetDataLockIn.m
%===========================================================
%Written by Bruce Land, BRL4@cornell.edu
%  12 May 2003
%Written for Joe Sisneros

%=====clean up any leftover serial connections==============
clear all
try
    fclose(instrfind) %close any bogus serial connections
end

%=====Data output file name=================================
%[filename,pathname] = uiputfile( 'Z:\ece576\finalproject\proj_full\test.txt');
%if isnumeric(filename) %check to see if Cancel buttion was hit
%    return             %if so, stop program
%end

%=====open a serial connection===============================
%set its rate to 9600 baud
%SR830 terminator character is  (ACSII 13)
%use fprintf(s,['m' mode]) to write
%and fscanf(s) to read the SR830
s = serial('COM1',...
    'baudrate',19200,...
    'terminator',13); 
fopen(s)

%=====Now generate the tones and pauses======================
%and collect amp and phase

x=1:1:100;
y=x*0;
figure(1)
lh = plot(x,y);
command_readmem = 0;
command_resume = 1;
while(1)
    start_matlab_command_in = fscanf(s,'%f');
    while(start_matlab_command_in~=1)
        start_matlab_command_in = fscanf(s,'%f');
    end
    fprintf(s,'%d\r',command_readmem);
    ynew = fscanf(s,'%i');
    y = [y(2:end),ynew];
    set(lh, 'ydata',y);
    drawnow;
    pause(1/60);
    fprintf(s,'%d\r',command_resume);
end

% a = 1:1:21;
% b = a*0;
% figure(1)
% lh = plot(a,b,'b.-');
% command_readmem = 0;
% command_resume = 1;
% for i=1:21
%     start_matlab_command_in = fscanf(s,'%f');
%     while(start_matlab_command_in~=1)
%         start_matlab_command_in = fscanf(s,'%f');
%     end
%     fprintf(s,'%d\r',command_readmem);
%     bnew = fscanf(s,'%i');
%     b = [b(2:end),bnew];
%     set(lh, 'ydata',b);
%     drawnow;
%     pause(1/60);
%     fprintf(s,'%d\r',command_resume);
% end

% z=1;
% tic
% for i=1:60 
%     fprintf(s,'%d\r',z)
%     test = fscanf(s,'%f')
%     
% end
% toc
% fprintf(s,'%d\r',i)

%=====close the serial port=================================
fclose(s)
