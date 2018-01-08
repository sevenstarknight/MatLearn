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
function [fltOptimalThresholds] = DetermineSplit(fltTrainingSet, grpTrainingSet)

%% ======== Intialization
intDimensions = length(fltTrainingSet(:,1));
intNumberOfSets = length(fltTrainingSet(1,:));

fltParentEntropy = ComputeEntropyOfParent(intNumberOfSets, grpTrainingSet);

fltOptimalThresholds = zeros(2,intDimensions);

for i = 1:1:intDimensions
    fltTmpVectorSet = fltTrainingSet(i,:);
  
    fltDimensionSet = sort(fltTmpVectorSet);
   
    fltDeltaMaxEntropy = 0;
    fltThreshold = 0;
    
    for j = 1:1:intNumberOfSets
        % using the sorted set, step through the possible threshold 'cuts'
        fltTmpThreshold = fltDimensionSet(j);
        
        fltChildEntropy = ComputeEntropyOfChildren(fltTmpVectorSet, grpTrainingSet, fltTmpThreshold);
        
        fltTmpEntropy = fltParentEntropy - fltChildEntropy;
        
        if(fltTmpEntropy > fltDeltaMaxEntropy)
            fltDeltaMaxEntropy = fltTmpEntropy;
            fltThreshold = fltTmpThreshold;
        end
        
    end
    
    fltOptimalThresholds(1,i) = fltThreshold;
    fltOptimalThresholds(2,i) = fltDeltaMaxEntropy;
    
end

end