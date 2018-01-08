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

function [structTree] = GrowCARTTree(fltPatternArray_Training, grpSource_Training, crit_alpha)
% function [structTree] = GrowCARTTree(fltPatternArray_Training, grpSource_Training,
% crit_alpha)
%
% Author: Kyle Johnston     14 Jan 
%
% Usage: This function generates class estimates based on the CART
%   algorithm. Ties are represented by the "missValue" string in the
%   output labels. 
% 
% Input: 
%       fltPatternArray_Training: the training dataset
%       grpSource_Training: the labels for the training dataset
%       crit_alpha: int representing the kernel selected

% Output:
%       structTree: the decision tree

%% ========= Initialize variables
intLengthTraining = length(grpSource_Training);
entropyTol = 0.000001;

%% === Compute Prior Probability
uniqueSources = unique(grpSource_Training);
fltPriorProb = zeros(1,length(uniqueSources));

for i = 1:1:length(uniqueSources)
    
    TF = strcmp(uniqueSources{i},grpSource_Training);
    intNumberOfClass = sum(TF);
    fltPriorProb(i) = intNumberOfClass/intLengthTraining;
    
end

%% ======== Grown Tree
[structTree] = ComputeGrownRegressionTree(fltPatternArray_Training, ...
    grpSource_Training, uniqueSources, fltPriorProb, entropyTol);

%% ======== Prune Tree
while(2)
    [arrayOfNodeResults] = ComputeAlphaStar(structTree);

    [sortedAlpha] = min(arrayOfNodeResults(1,:));

    if(sortedAlpha < crit_alpha)
        [structTree] = PruneTree(structTree, arrayOfNodeResults, ...
            sortedAlpha, intLengthTraining, fltPriorProb, uniqueSources);
    else
        break;
    end
end

end
