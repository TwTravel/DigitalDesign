%===============================================
% Hamblen chapter 9: assembler--- text to Altera MIF file
%===============================================
% Bruce Land -- Cornell University -- July 2008
%===============================================
% input format:
% define
% symbol1 value1
% symbol2 value2
% ...
% data 200 (starting address, decimal)
% name1 length1 value1(s)
% name2 length2 value2(s)
% ...
%code (always starts at 0)
% label1: opcode1 addr1 ;comment
% opcode2 addr2 ;comment
% ; comment
% 'addr' can be 'name' or 'symbol'
%===============================================
clear all

%query for *.asm file
[fname,fpath] = uigetfile('*.asm') ;
fid = fopen ([fpath,fname]);

% init state state==1 implies define; ==2 implies data; ==3 implies code
state = 0;
% init definition count
nDef = 0;
% init data count
nData = 0;
% init code count
nCodeLine = 0;

% init assembler opcode string/value pairs
nOpcode = 9 ;
opcode{1,1} = 'add';   opcode{1,2} =0;
opcode{2,1} = 'store'; opcode{2,2} =1;
opcode{3,1} = 'load';  opcode{3,2} =2;
opcode{4,1} = 'jump'; opcode{4,2} =3;
opcode{5,1} = 'jneg';  opcode{5,2} =4;
opcode{6,1} = 'out';    opcode{6,2} =5;
opcode{7,1} = 'in';       opcode{7,2} =6;
opcode{8,1} = 'mult';  opcode{8,2} =7;
opcode{9,1} = 'shl';     opcode{9,2} =8;
%===============================================
% Tokenize the input file:
% skip blank lines, ignore comments
% build tables of definitions, data, code
while feof(fid) == 0            %are we done reading the file yet?
    txtline = fgetl(fid);        %get one line

    % trim off semicolons and comments
    % If  line starts with ';' get next line
    semicolPos = strfind(txtline, ';');
    if (~isempty(semicolPos))
        if (semicolPos(1)>1)
            txtline = txtline(1:semicolPos(1)-1) ;
        else
            continue % whole line is a comment -- get next line
        end
    end

    % get first token of the line,  look for state changes 
    % and trim blank lines
    [token,rtxt] = strtok(txtline) ;
    if (strcmp(token, 'define'))
        state = 1;
        continue % get the next line
    elseif (strcmp(token, 'data'))
        state = 2;
        addrData = str2num(strtok(rtxt)) ; %data section line has an address on it
        continue % get the next line
    elseif (strcmp(token, 'code'))
        state = 3;
        continue % get the next line
    elseif (isempty(token))
        continue % line was blank
    end

    %'define' state machine: build a table of definitions name,value
    if (state==1)
        nDef = nDef + 1;
        def{nDef,1} = token ;
        def{nDef,2} = strtok(rtxt) ;
    end

    %'data' state machine: build a table of data name,location
    if (state==2)
        nData= nData + 1;
        data{nData,1} = token ; % mem location name
        [token,rtxt] = strtok(rtxt) ;  % get count
        data{nData,2} = str2num(token) ;
        for i = 1:data{nData,2}
            [token,rtxt] = strtok(rtxt) ; %get value
            if (~isempty(token))
                data{nData,2+i} = token ; %str2num(token) ;
            else
                data{nData,2+i} = 0 ;
            end
        end
    end

    %'code' state machine:  build a table of lines of code
    % builds a table of labels, opcodes, and addresses
    if (state==3)
        nCodeLine= nCodeLine + 1;
        % handle label
        if (~isempty(strfind(token, ':')))  %label?
            CodeLine{nCodeLine,1} = token(1:end-1) ; %strip off colon and store
            [token,rtxt] = strtok(rtxt) ; %get opcode
        end

        % process opcode or null, and if opcode get address
        if (~isempty(token))
            CodeLine{nCodeLine,2} = lower(token) ; % store opcode in lowercase
            [token,rtxt] = strtok(rtxt) ; %get address
            CodeLine{nCodeLine,3} = token ; % store address
        else
            continue % get next line
        end
    end %end of 'code' state machine
end
fclose(fid); % done reading asm file

%===============================================
%start generating mif file (object code generation)
fid = fopen([fpath,fname(1:end-4),'.mif'], 'w') ;
fprintf(fid, '%s\n', 'DEPTH = 256;') ;
fprintf(fid, '%s\n', 'WIDTH = 18;');
fprintf(fid, '%s\n', '  ');
fprintf(fid, '%s\n', 'ADDRESS_RADIX = HEX;');
fprintf(fid, '%s\n', 'DATA_RADIX = HEX;');
fprintf(fid, '%s\n', '   ');
fprintf(fid, '%s\n', 'CONTENT');
fprintf(fid, '%s\n', 'BEGIN');
fprintf(fid, '%s\t:\t%s\n', '[00..FF]', '00000;');

% generate code section in mif format
for i=1:nCodeLine
    hexaddr = i - 1; %zero based addresses for code
    %opcode table lookup: find the hex opcode which matches the
    % current line's string opcode
    instOpcode = nan ;
    for  j=1:nOpcode
        if  (strcmp(opcode{j,1}, CodeLine{i,2}))
            instOpcode = opcode{j, 2} ;
        end
    end
    if (isnan(instOpcode))
        error(['Bad opcode in code line:', num2str(i)])
    end
    % convert address symbol into a number instAddr
    % if a number, use it
    % if opcode is a 'jump', 'jneg' use labels
    % of opcode is an 'out' or 'in'use defines
    % otherwise  use data names
    instaddr = nan ;
    % check for numeric
    if (~isempty(str2num(CodeLine{i,3})))
        instaddr = str2num(CodeLine{i,3}) ;
     % label search
    elseif (strcmp(CodeLine{i,2}, 'jump') | strcmp(CodeLine{i,2}, 'jneg'))
        for j=1:nCodeLine %search label table
            if (strcmp(CodeLine{i,3}, CodeLine{j,1}))
                instaddr = j-1 
            end
        end
     % 'define' search
    elseif (strcmp(CodeLine{i,2}, 'out') | strcmp(CodeLine{i,2}, 'in'))
        for j=1:nDef %search label table
            if (strcmp(CodeLine{i,3}, def{j,1}))
                instaddr = str2num(def{j,2}) ;
            end
        end        
    else % search data names
        instaddr = addrData ; %init to beginning of data table
        for j=1:nData %search label table
            if (strcmp(CodeLine{i,3}, data{j,1}))
                break
            end
            instaddr = instaddr + data{j,2} ;
        end  
    end %end addr search

    %check for undefined address
    if (isnan(instaddr))
        error(['Bad address in code line:', num2str(i)])
    end
    %build the hex instruction 12-bits of address 2^12=2046
    inst =  4096*instOpcode + instaddr ;
    fprintf(fid, '%02x\t:\t%05x;\t%% %s: %s %s %% \n', ...
        hexaddr, inst, CodeLine{i,1}, CodeLine{i,2}, CodeLine{i,3})
end

% generate data section  in mif format
hexaddr = addrData ; %init address to beginning of data section
for i=1:nData
    for j=1:data{i,2}
        if (~isempty(data{i,2+j}))
            datavalue = data{i,2+j} ;
        else
            datavalue = 0;
        end
        fprintf(fid, '%02x\t:\t%s;\t%% %s  %% \n', hexaddr, datavalue, data{i,1} )
        hexaddr = hexaddr + 1;
    end
end
fprintf(fid,  '%s\n', 'END ;	')

fclose(fid)

% Altera MIF format example
% DEPTH = 256;	% Memory depth and width are required	%
% WIDTH = 16;		% Enter a decimal number	%
%
% ADDRESS_RADIX = HEX;	% Address and value radixes are optional	%
% DATA_RADIX = HEX;		% Enter BIN, DEC, HEX, or OCT; unless 	%
% 						% otherwise specified, radixes = HEX	%
% -- Specify values for addresses, which can be single address or range
% -- program adds one to a counter, MEM(12), every time A overflows to neg value
% CONTENT
% 	BEGIN
% [00..FF]	:	0000;	% Range--Every address from 00 to FF = 0000 (Default)	%
% 	00		:	0210;	% LOAD A with MEM(10) -- clear A%
% 	01		:	0011;	% ADD MEM(11) to A  -- increment A%
% 	02		:	0404;	% JNEG to 04  -- skip next instruction if A is negative%
% 	03		:	0301;	% JMP to 01  -- increment A if it is still positive%
% 	04		:   0212;	% LOAD A from MEM(12)  -- get output counter%
% 	05		:	0011;	% ADD MEM(11) to A  -- incrment output counter%
% 	06		:	0500;	% OUTPUT A %
% 	07		:	0112;	% STORE A to MEM(12)  -- save it%
% 	08		:	0300;	% JUMP to 00 (loop forever)  -- reset A %
% 	10		:	0000;	% initial A Value %
% 	11		:	0001;	% increment for A and output value %
% 	12		:	0000;	% output value %
% 	END ;

