function jsonStruct = simple_JsonDecode(jsonFilePath)
% simple decoder of json files for older Matlab versions <2017
% please use 'jsondecode' in newer MATLAB versions
%
% Useage: simple_JsonDecode(jsonFilePath)
%   input: jsonFilePath: full path of json file
%
% Assumed format of json-file:
% "FIELDNAME1": DOUBLE,
% "FIELDNAME2": "STRING",
% "FIELDNAME3": [ARRAYVALUE1,ARRAYVALUE2],
%
% Author: Lukas Pirpamer (v.1.0)
% lukas.pirpamer@medunigraz.at
%
% ------------------------------------------------------------------------------
%% BSD 3-Clause License
% Copyright (c) 2021, Lukas Pirpamer
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% 1. Redistributions of source code must retain the above copyright notice, this
%    list of conditions and the following disclaimer.
% 
% 2. Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation
%    and/or other materials provided with the distribution.
% 
% 3. Neither the name of the copyright holder nor the names of its
%    contributors may be used to endorse or promote products derived from
%    this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%%



jsonTxt = fileread(jsonFilePath);

textRep=regexprep(jsonTxt,';','SEMICOLON_REPLACE'); % temporary replace of semicolons
textRep=regexprep(textRep,[char(10),'\t"'],';');
textRep=regexprep(textRep,char(10),'');

jsonTextCell=textscan(textRep,'%s','delimiter',';');
jsonTextCell=jsonTextCell{:};

myJsonCell=cell(size(jsonTextCell,1),2);
for k=1:size(jsonTextCell,1)
    currentline=jsonTextCell{k};
    currentline = regexprep(currentline,'SEMICOLON_REPLACE',';'); % re-substitute semicolons
    sepIdx=strfind(currentline,'": ');
    if ~isempty(sepIdx)
        cellName=currentline(1:sepIdx-1);
        myJsonCell{k,1}=cellName;
        
        valueRaw=currentline(sepIdx+3:end-1);
        valueDouble=str2double(valueRaw);
        if ~isnan(valueDouble)
            myJsonCell{k,2}=valueDouble;
        else
            if strcmp(valueRaw(1),'"')
                myJsonCell{k,2}=valueRaw(2:end-1);
            elseif strcmp(valueRaw(1),'[')
                valueArray=regexprep(valueRaw(2:end-1),'\ ','');
                valueArray=regexprep(valueArray,'\t','');
                valueArray=textscan(valueArray,'%s','delimiter',',');
                valueArray=valueArray{:};
                valueArrayDouble=cellfun(@(x) str2double(x),valueArray);
                myJsonCell{k,2}=valueArrayDouble;
            end
        end
    end
end
emptyCell=cellfun(@(x) isempty(x),myJsonCell(:,1));
myJsonCell(emptyCell,:)=[];

%convert to struct
for k=1:size(myJsonCell,1)
    if k==1
        jsonStruct=struct(myJsonCell{k,1},myJsonCell{k,2});
    else
        jsonStruct.(myJsonCell{k,1})=myJsonCell{k,2};
    end
end

