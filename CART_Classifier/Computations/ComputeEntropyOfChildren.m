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
function [fltPostEntropy] = ComputeEntropyOfChildren(fltVectorSet, grpTrainingSet, fltThresholdEst)

fltLeftChildSet = grpTrainingSet(fltVectorSet > fltThresholdEst);
fltRightChildSet = grpTrainingSet(fltVectorSet <= fltThresholdEst);

intNumberParent = length(fltVectorSet);

intNumberLeft = length(fltLeftChildSet);
intNumberRight = length(fltRightChildSet);


%% Left Side
fltUniqueLeft = unique(fltLeftChildSet);
intNumberTypesLeft = length(fltUniqueLeft);
fltEntropyLeft = 0;

for i = 1:1:intNumberTypesLeft
    TF = strcmp(fltUniqueLeft{i}, fltLeftChildSet);
    
    boolLeftSet = sum(TF);
    postProb = (boolLeftSet/intNumberLeft);
    
    fltEntropyLeft = fltEntropyLeft + postProb*log(postProb);
end

fltEntropyLeft = -fltEntropyLeft;

%% Right Side
fltUniqueRight = unique(fltRightChildSet);
intNumberTypesRight = length(fltUniqueRight);
fltEntropyRight = 0;

for i = 1:1:intNumberTypesRight
    TF = strcmp(fltUniqueRight{i}, fltRightChildSet);
    boolRightSet = sum(TF);
    postProb = (boolRightSet/intNumberRight);
    fltEntropyRight = fltEntropyRight + postProb*log(postProb);
end

fltEntropyRight = -fltEntropyRight;

%% Mean Post Entropy
fltPostEntropy = (intNumberLeft/intNumberParent)*fltEntropyLeft + (intNumberRight/intNumberParent)*fltEntropyRight;

end