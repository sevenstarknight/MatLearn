% Copyright (c) 2005, Kyle Johnston
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% 1. Redistributions of source code must retain the above copyright notice, this
%    list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation
%    and/or other materials provided with the distribution.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
% ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% The views and conclusions contained in the software and documentation are those
% of the authors and should not be interpreted as representing official policies,
% either expressed or implied, of the FreeBSD Project.
function [structOutput, fltFullSet, fltFullGrp] = BuildDatasets(sigma, size)

structOutput = struct([]);

%% ========= build datasets
fltGroupClassAX = normrnd(1,sigma,[1 size]);  
fltGroupClassAY = normrnd(1,sigma,[1 size]);  

fltGroupClassA = cat(1,fltGroupClassAX, fltGroupClassAY);
grpA = zeros(1,size) + 1;

structOutput(1).fltGroupClass = fltGroupClassA;
structOutput(1).group = grpA;

fltGroupClassBX = normrnd(1,sigma,[1 size]);  
fltGroupClassBY = normrnd(-1,sigma,[1 size]);  

fltGroupClassB = cat(1,fltGroupClassBX, fltGroupClassBY);
grpB = zeros(1,size) + 2;

structOutput(2).fltGroupClass = fltGroupClassB;
structOutput(2).group = grpB;

fltGroupClassCX = normrnd(-1,sigma,[1 size]);  
fltGroupClassCY = normrnd(-1,sigma,[1 size]);  

fltGroupClassC = cat(1,fltGroupClassCX, fltGroupClassCY);
grpC = zeros(1,size) + 3;

structOutput(3).fltGroupClass = fltGroupClassC;
structOutput(3).group = grpC;

fltGroupClassDX = normrnd(-1,sigma,[1 size]);  
fltGroupClassDY = normrnd(1,sigma,[1 size]);  

fltGroupClassD = cat(1,fltGroupClassDX, fltGroupClassDY);
grpD = zeros(1,size) + 4;

structOutput(4).fltGroupClass = fltGroupClassD;
structOutput(4).group = grpD;

fltFullSet = cat(2,fltGroupClassA, fltGroupClassB);
fltFullSet = cat(2,fltFullSet, fltGroupClassC);
fltFullSet = cat(2,fltFullSet, fltGroupClassD);

fltFullGrp = cat(2, grpA, grpB);
fltFullGrp = cat(2, fltFullGrp, grpC);
fltFullGrp = cat(2, fltFullGrp, grpD);


end
