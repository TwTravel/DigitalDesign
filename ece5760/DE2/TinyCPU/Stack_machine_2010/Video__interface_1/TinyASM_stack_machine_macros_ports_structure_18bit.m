
%===============================================
% Bruce Land -- Cornell University -- Oct 2010
%===============================================
% input format:
% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
% `define
% symbol1 value1 (value in decimal)
% symbol2 value2
% ...
% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
% `data 200 (starting address, decimal)
% name1 length1 (length in decimal)
% name2 length2 
% ....
% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
% `macro macro_name arg_num (macro name, number of arguments)
% ... body of macro ...
% addresses within a macro are LOCAL to macro
% arguments used in a macro are denoted '%n'
% `endmacro
% Examples:
%
% `macro dup 0
% 	pop temp ; temp must be defined in the data section
% 	push temp
%	push temp
% `endmacro
%
% `macro addi 1
% 	pushi %1 ; argument 1
% 	add
% `endmacro
%
% `macro dup? 0 ; dup the top if it is not zero
%	pop temp
%	push temp
%	jz m1
%	push temp
% m1:push temp
% `endmacro
% ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
% ...
%code (always starts at address 0)
% label1: opcode1 argument(if any) ;comment
% opcode2  ;comment
% ; comment
% argument can be 'name' or 'symbol' or 'label'
%
% Structure:
% `if
%   logical expression ;leaves true/false on stack
% `then ;if logical expression is true
%   stuff
% `else ; optional if logical expression is false
%   stuff
% `endif
%
% `while
%   logical expression ;leaves true/false on stack
% `do ; while logical expression is true
%   stuff
%`endwhile
%
%===============================================
clear all

%query for *.asm file
[fname,fpath] = uigetfile('*.asm') ;
%fpath='C:\Users\bruce\Documents\576\TINYCPU\';
%fname='test_stack_machine.asm';
fid = fopen ([fpath,fname]);

% intermediate file
fid_temp = fopen ([fpath,'temp.asm'], 'w');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pass 1:
% find macros and store them
%   macro_name, arg_count, line_count, text cell array
macro_def_count = 0;
macro_instance_count = 0;
in_macro = 0 ;  % tells scanner we are in body of macro
macro = [];

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
    
    % get first token of the line
    % and trim blank lines
    [token,rtxt] = strtok(txtline) ;
    if (isempty(token))
        continue % line was blank
    end
    
    % check for macro first line
    if (strcmp(token, '`macro'))
        macro_def_count = macro_def_count + 1;
        
        % look for a name
        [token,rtxt] = strtok(rtxt) ;
        if (isempty(token))
            error('Macros must be named')
        else
            macro(macro_def_count).name = token ;
        end
        
        % look for the argument count
        [token,rtxt] = strtok(rtxt) ;
        if (isempty(token))
            error('Macros must have a argument count')
        else
            macro(macro_def_count).arg_count = str2num(token) ;
        end  
        
        in_macro = 1; % flag to mark macro storage
        line_count = 0; % number of current lines in macro definition
        continue % don't write out any macro lines
    end % macro first line detect
    
    % store body of macro (if any)
    if in_macro==1
        if ~strcmp(token, '`endmacro')
            line_count = line_count + 1;
            macro(macro_def_count).line{line_count} = txtline ;
        else % macro is done
            in_macro = 0 ;
            macro(macro_def_count).line_count = line_count ;
        end
        continue % don't write out any macro lines
    end
     
    % write out file with NO macro definitions and 
    % with macro instances replaced
    %find macro instances 
    
    % find labels and opcodes for possible replacment
    labelm = '';
    drop_line = 0 ;
    
    if (~isempty(strfind(token, ':')))  %is there a label?
        %if so, store it and check opcode for macro match
        labelm = token ; 
        [token,rtxt] = strtok(rtxt) ; %get opcode
    end
    
    % were any macros defined and if so is the current opcode
    % one of them
    if ~isempty(macro)
        for i=1:length(macro)
            if strcmp(macro(i).name, token) % find a match
                macro_instance_count = macro_instance_count + 1;
                % if match, get arg symbols (if any)
                if macro(i).arg_count > 0
                    for j=1:macro(i).arg_count
                        [token,rtxt] = strtok(rtxt) ; %get arg names
                        arg{j} = token ;
                        if isempty(token)
                            error(['Missing argument for ', macro(i).name])
                        end
                    end
                end % get macro arguments macro(i).arg_count > 0
                
                % modify all labels in STORED MACRO with instance number 
                for j=1:macro(i).line_count
                     % get the label(if any) from the macro body
                    [tokenm,rtxtm] = strtok(macro(i).line{j}) ;
                    if (~isempty(strfind(tokenm, ':')))  %is there a label?
                        %if so
                        % modify label with instance number
                        for k=1:macro(i).line_count
                            label_pos = strfind(macro(i).line{k}, tokenm(1:end-1)) ;
                            if ~isempty(label_pos)
                                macro(i).line{k} = ...
                                    [macro(i).line{k}(1:label_pos), ...
                                    num2str(macro_instance_count,3), ...
                                    macro(i).line{k}(label_pos+1:end)] ;
                            end
                        end
                    end
                end
                
                % output macro body with modified labels
                for j=1:macro(i).line_count
                    [tokenm,rtxtm] = strtok(macro(i).line{j}) ;
                    if (~isempty(strfind(tokenm, ':')))  %is there a label?
                        %if so, store it get opcode 
                        labelm = tokenm ;
                        % and get opcode
                        [tokenm,rtxtm] = strtok(rtxtm) ;
                    end
                    % and build output string
                    out_str = [labelm,' ',tokenm, ' '] ;
                    labelm = ''; % only label the first line with the external label
                    
                    %get the actual args (if any)
                    [tokenm,rtxtm] = strtok(rtxtm) ;
                    if ~isempty(tokenm) % there is an arg
                        %parse token for '%'
                        if strfind(tokenm,'%')
                            %get actual arg
                            out_arg = arg{str2num(tokenm(2:end))} ;
                            % and build output string
                            out_str = [out_str, out_arg] ;
                        else %strfind(token,'%') implies literal argument
                            out_str = [out_str, tokenm] ;
                        end
                    end %~isempty(token)
                    
                    % format line and print it to file
                    fprintf(fid_temp, '%s\n', out_str)
                end % j=1:macro(i).line_count
                % need to drop the line which was replaced by the macro
                drop_line = 1;
            end % strcmp(macro(i).name, token)
        end % search macro table
    end % ~isempty(macro)
    
    % copy out a line from the original file
    % unless the line was part of a macro
    if ~drop_line
        fprintf(fid_temp, '%s\n', txtline)
        drop_line = 0;
    end
    
end %while feof(fid) == 0

fclose(fid_temp);
fclose(fid);  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% intermediate file
fid = fopen ([fpath,'temp.asm']);

% Pass 2:
%get intermediate file and convert to mif
% init state state==1 implies define; ==2 implies data; ==3 implies code
state = 0;
% init data count
nData = 0;
% init code count
nCodeLine = 0;
% init symbol table index
nTableIndex = 0;
% init structured if/then/else/endif nesting
if_level = 0 ;
% init structured while/do/endwhile
while_level = 0 ;
% sequential unique label for all structures
label_number = 0 ; 

% init assembler opcode string/value pairs
% third field:
% 0=no arg; 1=12-bit-pos-int; 2=12-bit-int; 3=3-bit-int
opcode{1,1} = 'pushi';  opcode{1,2} ='1000'; opcode{1,3} =2;
opcode{2,1} = 'push';   opcode{2,2} ='2000'; opcode{2,3} =1;
opcode{3,1} = 'pop';    opcode{3,2} ='3000'; opcode{3,3} =1;
opcode{4,1} = 'jmp';    opcode{4,2} ='4000'; opcode{4,3} =1;
opcode{5,1} = 'jz';     opcode{5,2} ='5000'; opcode{5,3} =1;
opcode{6,1} = 'jnz';    opcode{6,2} ='6000'; opcode{6,3} =1;
opcode{7,1} = 'ld';     opcode{7,2} ='7000'; opcode{7,3} =0;
opcode{8,1} = 'st';     opcode{8,2} ='8000'; opcode{8,3} =0;
opcode{9,1} = 'pushpc'; opcode{9,2} ='9000'; opcode{9,3} =0;
opcode{10,1} = 'poppc'; opcode{10,2}='9001'; opcode{10,3} =0;
opcode{11,1} = 'in';    opcode{11,2}='d000'; opcode{11,3} =3;
opcode{12,1} = 'out';   opcode{12,2}='e000'; opcode{12,3} =3;
opcode{13,1} = 'add';   opcode{13,2}='f000'; opcode{13,3} =0;
opcode{14,1} = 'sub';   opcode{14,2}='f001'; opcode{14,3} =0;
opcode{15,1} = 'mul';   opcode{15,2}='f002'; opcode{15,3} =0;
opcode{16,1} = 'shl';   opcode{16,2}='f003'; opcode{16,3} =0;
opcode{17,1} = 'shr';   opcode{17,2}='f004'; opcode{17,3} =0;
opcode{18,1} = 'band';  opcode{18,2}='f005'; opcode{18,3} =0;
opcode{19,1} = 'bor';   opcode{19,2}='f006'; opcode{19,3} =0;
opcode{20,1} = 'bxor';  opcode{20,2}='f007'; opcode{20,3} =0;
opcode{21,1} = 'and';   opcode{21,2}='f008'; opcode{21,3} =0;
opcode{22,1} = 'or';    opcode{22,2}='f009'; opcode{22,3} =0;
opcode{23,1} = 'eq';    opcode{23,2}='f00a'; opcode{23,3} =0;
opcode{24,1} = 'ne';    opcode{24,2}='f00b'; opcode{24,3} =0;
opcode{25,1} = 'ge';    opcode{25,2}='f00c'; opcode{25,3} =0;
opcode{26,1} = 'le';    opcode{26,2}='f00d'; opcode{26,3} =0;
opcode{27,1} = 'gt';    opcode{27,2}='f00e'; opcode{27,3} =0;
opcode{28,1} = 'lt';    opcode{28,2}='f00f'; opcode{28,3} =0;
opcode{29,1} = 'neg';   opcode{29,2}='f010'; opcode{29,3} =0;
opcode{30,1} = 'bnot';  opcode{30,2}='f011'; opcode{30,3} =0;
opcode{31,1} = 'not';   opcode{31,2}='f012'; opcode{31,3} =0;
opcode{32,1} = 'nop';   opcode{32,2}='0000'; opcode{32,3} =0;
opcode{33,1} = 'dup';   opcode{33,2}='f013'; opcode{33,3} =0;
opcode{34,1} = 'drop';  opcode{34,2}='f017'; opcode{34,3} =0;
opcode{35,1} = 'over';   opcode{35,2}='f01f'; opcode{35,3} =0;
opcode{36,1} = 'dnext';  opcode{36,2}='f01b'; opcode{36,3} =0;

nOpcode = length(opcode) ;
%===============================================
% store all symbol/value pairs in one table 
% called symbolTable
%
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
    if (strcmp(token, '`define'))
        state = 1;
        continue % get the next line
    elseif (strcmp(token, '`data'))
        state = 2;
        addrData = str2num(strtok(rtxt)) ; %data section line has an address on it
        continue % get the next line
    elseif (strcmp(token, '`code'))
        state = 3;
        continue % get the next line
    elseif (isempty(token))
        continue % line was blank
    end

    %'define' state machine: build a table of definitions name,value
    if (state==1)
        nTableIndex = nTableIndex + 1;
        symbolTable{nTableIndex,1} = token ;
        token = strtok(rtxt);
        if ~isempty(token)
            symbolTable{nTableIndex,2} = str2num(token) ; % value 
        else
            error('Definitions require a value')
        end
    end

    %'data' state machine: build a table of data name,location
    if (state==2)
        nTableIndex = nTableIndex + 1;
        symbolTable{nTableIndex,1} = token ; % mem location name
        symbolTable{nTableIndex,2} = addrData ; % mem location 
        [token,rtxt] = strtok(rtxt) ;  % get count
        if ~isempty(token)
            addrData = addrData + str2num(token) ; % and update location
        else
            error('Data declaration requires a count')
        end
    end

    %'code' state machine:  build a table of lines of code
    % builds a table of labels, opcodes, and addresses
    if (state==3)
        
        % handle IF structure
        % if `if: inc if_level
        % if `then: insert jz--- instruction (modify CodeLine)
        % if `else: insert jmp--- instruction 
        %           insert label:nop and fix jz--- instruction
        % if `endif: insert label:nop
        %           if no 'else' fix jz--- instruction
        %           if 'else' fix jmp--- instruction
        %           dec if_level
        if strcmp(token, '`if')
            if_level = if_level + 1;
            continue %next line
        end
        
        if strcmp(token, '`then')
            nCodeLine = nCodeLine + 1;
           % if_table_Index = if_table_Index + 1;
            if_table{if_level} = nCodeLine ;
            CodeLine{nCodeLine,1} = 'jz'; % to be filled in at 'else' or 'endif'
            continue %next line
        end
        
        if strcmp(token, '`else')
            nCodeLine = nCodeLine + 1;
            CodeLine{nCodeLine,1} = 'jmp'; % to be filled in at 'endif'
            nCodeLine = nCodeLine + 1;
            CodeLine{nCodeLine,1} = 'nop'; % label target for jz in 'then'
            % so hack symbol table
            nTableIndex = nTableIndex + 1;
            label_number = label_number + 1 ;
            symbolTable{nTableIndex,1} = ['L',num2str(label_number,3)] ; % code location name
            symbolTable{nTableIndex,2} = nCodeLine ; % code location 
            CodeLine{nCodeLine,3} =  ['L',num2str(label_number,3),':'] ; %store for comment generation
             % and modify 'then' instruction 'jz'
             CodeLine{if_table{if_level},2} = ['L',num2str(label_number,3)];
             % change if_table to point to 'jmp' in 'else'
             if_table{if_level} = nCodeLine - 1 ;
            continue %next line
        end 
        
        if strcmp(token, '`endif')
            nCodeLine = nCodeLine + 1;
            CodeLine{nCodeLine,1} = 'nop'; % label target for jz in 'then'
            % so hack symbol table
            nTableIndex = nTableIndex + 1;
            label_number = label_number + 1 ;
            symbolTable{nTableIndex,1} = ['L',num2str(label_number,3)] ; % code location name
            symbolTable{nTableIndex,2} = nCodeLine ; % code location 
            CodeLine{nCodeLine,3} =  ['L',num2str(label_number,3),':'] ; %store for comment generation
            % and modify 'then' instruction 'jz'
            CodeLine{if_table{if_level},2} = ['L',num2str(label_number,3)];
            if_level = if_level - 1 ;
            continue %next line
        end 
        
        % handle WHILE structure
        % if `while: increment level
        %               insert label:nop, record label1 
        % if `do: insert jz---, record address to insert label2
        % if `endwhile: fill in jz with label2
        %               insert jmp label1; 
        %               insert label2: nop
        %               decrement level
        
        if strcmp(token, '`while')
            while_level = while_level + 1 ;
            nCodeLine = nCodeLine + 1;
            CodeLine{nCodeLine,1} = 'nop'; % label target for jmp in 'endwhile'
            % so hack symbol table
            nTableIndex = nTableIndex + 1;
            label_number = label_number + 1 ;
            symbolTable{nTableIndex,1} = ['L',num2str(label_number,3)] ; % code location name
            while_table_label{while_level} = ['L',num2str(label_number,3)] ; % code location name
            symbolTable{nTableIndex,2} = nCodeLine ; % code location 
            CodeLine{nCodeLine,3} =  ['L',num2str(label_number,3),':'] ; %store for comment gen
            continue %next line
        end
        
        if strcmp(token, '`do')
            nCodeLine = nCodeLine + 1;
            while_table_jz{while_level} = nCodeLine ;
            CodeLine{nCodeLine,1} = 'jz'; % to be filled in at 'endwhile'
            continue
        end
        
         if strcmp(token, '`endwhile')
            nCodeLine = nCodeLine + 1;
            CodeLine{nCodeLine,1} = 'jmp'; % back to 'while'
            CodeLine{nCodeLine,2} = while_table_label{while_level} ; %label generated in 'while'
            nCodeLine = nCodeLine + 1;
            CodeLine{nCodeLine,1} = 'nop'; % target for 'jz' in 'do'
             % so hack symbol table
            nTableIndex = nTableIndex + 1;
            label_number = label_number + 1 ;
            symbolTable{nTableIndex,1} = ['L',num2str(label_number,3)] ; % code location name
            symbolTable{nTableIndex,2} = nCodeLine ; % code location 
            CodeLine{nCodeLine,3} =  ['L',num2str(label_number,3),':'] ; %store for comment gen
            % fix jz from 'do'
            CodeLine{while_table_jz{while_level},2} = ['L',num2str(label_number,3)] ; %current label
            while_level = while_level - 1 ;
            continue
         end
        
        % handle CASE structure
        % if `caseentry
        %               increment case level
        % code must put value to compare on stack
        % if `case x 
        %           if NOT first case, fill in jz in previous CASE with label
        %           if NOT first case, jmp to endcase
        %           insert label:dup
        %           insert pushi x
        %           insert jz---, record address to insert label
        % if `endcase  
        %               fill in last jz with label
        %               insert label: nop
        %               decrement case level
        
        
        
        
        % handle label
        if (~isempty(strfind(token, ':')))  %is there a label?
            nTableIndex = nTableIndex + 1;
            symbolTable{nTableIndex,1} = token(1:end-1) ; % code location name
            symbolTable{nTableIndex,2} = nCodeLine ; % code location 
             CodeLine{nCodeLine+1,3} = token ; %store for comment generation
            [token,rtxt] = strtok(rtxt) ; %get opcode
        end

        % process opcode or null, and if opcode get argument (if any)
        if (~isempty(token))
            nCodeLine = nCodeLine + 1;
            CodeLine{nCodeLine,1} = lower(token) ; % store opcode in lowercase
            [token,rtxt] = strtok(rtxt) ; %get argument(if any)
            if (~isempty(token))
                CodeLine{nCodeLine,2} = token ; %store, if it exists
            end
        else
            continue % get next line
        end
    end %end of 'code' state machine
end
if while_level>0
    error('Improper while_statment nesting ... missing endwhile?')
end
if if_level>0
    error('Improper if_statment nesting ... missing endif?')
end

fclose(fid); % done reading asm file
 
%===============================================
%start generating mif file (object code generation)
fid = fopen([fpath,fname(1:end-4),'.mif'], 'w') ;
fprintf(fid, '%s\n', 'DEPTH = 4096;') ;
fprintf(fid, '%s\n', 'WIDTH = 18;');
fprintf(fid, '%s\n', '  ');
fprintf(fid, '%s\n', 'ADDRESS_RADIX = HEX;');
fprintf(fid, '%s\n', 'DATA_RADIX = HEX;');
fprintf(fid, '%s\n', '   ');
fprintf(fid, '%s\n', 'CONTENT');
fprintf(fid, '%s\n', 'BEGIN');
fprintf(fid, '%s\t:\t%s\n', '[000..FFF]', '0000;');

% generate code section in mif format
for i=1:nCodeLine
    hexaddr = i - 1; %zero based addresses for code
    %opcode table lookup: find the hex opcode which matches the
    % current line's string opcode
    instOpcode = nan ;
    for  j=1:nOpcode
        if  (strcmp(opcode{j,1}, CodeLine{i,1}))
            instOpcode = opcode{j, 2} ; %hexidecimal string
            opcode_index = j;
        end
    end
    if (isnan(instOpcode))
        error(['Bad opcode ', CodeLine{i,1},' in code line:', num2str(i)])
    end
    % convert argument symbol into a number instAddr
    % if a number, use it
    % otherwise  use symbol table values
    inst_arg = nan ;
    % check to see if argument exists
    if (~isempty(CodeLine{i,2}))
        % check for numeric
        if ~isempty(str2num(CodeLine{i,2}(1))) | strcmp(CodeLine{i,2}(1),'-')
            inst_arg = str2num(CodeLine{i,2}) ;  
        else
            % symbol search
            for j=1:nTableIndex %search symbol table
                if (strcmp(CodeLine{i,2}, symbolTable{j,1}))
                    inst_arg = symbolTable{j,2} ;
                end
            end   
            if (isnan(inst_arg))
                error(['Undefined symbol in code line:', num2str(i)...
            ,' ',CodeLine{i,3},' ',CodeLine{i,1}])
            end
        end %end addr search
    end
 
    %detect undefined address and build the hex instruction
    if (isnan(inst_arg))
        inst = instOpcode;
    else
        if inst_arg>=0
            inst = [instOpcode(1),dec2hex(inst_arg,3)];
        else
            inst = [instOpcode(1),dec2hex(bitcmp(-inst_arg,12)+1,3)];
        end
    end
    
    %do some argument checks
    if isnan(inst_arg) & opcode{opcode_index, 3}>0
        error(['Need argument in code line:', num2str(i)...
            ,' ',CodeLine{i,3},' ',CodeLine{i,1}])
    end
    
    % only pushi can have a negative argument
    if inst_arg<0 & opcode{opcode_index, 3}~=2
        error(['Argument must be positive in code line:', num2str(i),...
            ' ',CodeLine{i,3},CodeLine{i,1},' ', CodeLine{i,2}])
    end
    
    if ~isnan(inst_arg) & opcode{opcode_index, 3}==0
        error(['No Argument allowed in code line:', num2str(i) ...
            ,' ',CodeLine{i,3},CodeLine{i,1},' ',CodeLine{i,2}])
    end
    
    if ~isnan(inst_arg) & opcode{opcode_index, 3}==3 & inst_arg>7
        error(['I/O address too big in code line:', num2str(i) ...
             ,' ',CodeLine{i,3},CodeLine{i,1},' ',CodeLine{i,2}])
    end
    
    % emit the code
    fprintf(fid, '%03x\t:\t%s;\t%% %s %s %s %% \n', ...
            hexaddr, inst, CodeLine{i,3}, CodeLine{i,1}, CodeLine{i,2});
    fprintf(1,'%03x\t:\t%s;\t%% %s %s %s %% \n', ...
            hexaddr, inst,  CodeLine{i,3}, CodeLine{i,1}, CodeLine{i,2});
end %code lines

fprintf(fid,  '%s\n', 'END ;	')

fclose(fid);

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

