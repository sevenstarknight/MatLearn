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

function [fltPatternArray_KLT, fltZScore] = PCA_KLT(fltPatternArray, intReduction)
% [fltPatternArray_KLT] = PCA_KLT(fltPatternArray)
% Usage: Designed to transform high-dimensional (M >> 3) data into a 
% low-dimensional projection (M = 2). Uses the full covariance matrix
% computation and therefore and be unweildy if the diemnsionality is large
% 
%
% Inputs: 
%       fltPatternArray: The current n X p pattern matrix
%
% Outputs: 
%       fltPatternArray_KLT: The transformed dataset
    
%   Author: Kyle Johnston     29 Nov 
%% Empirical Mean
[n,m] = size(fltPatternArray);

% if(n > m)
    fltMeanPatternArray = mean(fltPatternArray, 1);
% else
%     fltMeanPatternArray = mean(fltPatternArray, 2);
% end

%% Deviations from Mean
h = ones(m,1);
fltDevPatternArray = fltPatternArray - fltMeanPatternArray*h;

%% Eigenvectors and Eigenvalues
%compute covariance matrix based on deviation matrix
fltCovariance = fltDevPatternArray'*fltDevPatternArray;
[V,D] = eig(fltCovariance);

% Generate Main Diagonal Vector
fltEigenvalueSet = diag(D);

% Sort and Reposition Columns relative to descending eigenvalue
[fltEigenvalueSet_Sorted,IX] = sort(fltEigenvalueSet, 'descend');
fltEigenvectorSet_Sorted = V(IX,:);

fltEnergyContent = sum(fltEigenvalueSet_Sorted);

%% Generate Subsets
% Top Two
fltEigenvectorSet_Subset = fltEigenvectorSet_Sorted(1:intReduction,:);

%% Convert to Z-Score
% Generate Main Diagonal Vector
fltEmpiricalStdev = sqrt(diag(fltCovariance)); % Main diagonal

fltZScore = zeros(m,n);
for i = 1:1:m
    fltZScore(i,:) = fltDevPatternArray(:,i)./fltEmpiricalStdev(i);
end

%% Compute Karhunen-Loeve Transforms of Datavectors

fltPatternArray_KLT = (fltEigenvectorSet_Subset*fltZScore)';


end