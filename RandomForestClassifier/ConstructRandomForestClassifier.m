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

function [structForest] = ConstructRandomForestClassifier(structPatternArray)

structForest = struct([]);

for indexi = 1:1:length(structPatternArray)
    
    fltPatternArray = structPatternArray(indexi).fltPatternArray;
    grpSource = structPatternArray(indexi).grpSource;
    
    [intNumberOfPatterns,m] = size(fltPatternArray);
    intUniqueSources = length(unique(grpSource));
    
    [...
    fltPatternArray_Training, grpSource_Training, ...
    fltPatternArray_CrossVal, grpSource_CrossVal, ...
    fltPatternArray_Testing,  grpSource_Testing] = ...
    Generate_Training_CrossVal_Testing(fltPatternArray, grpSource, floor(intNumberOfPatterns/intUniqueSources));
    

%     fltPatternArray_Training = fltPatternArray;
%     fltPatternArray_CrossVal = fltPatternArray;
% 
%     grpSource_Training = grpSource;
%     grpSource_CrossVal = grpSource;


    labels = cell(1,m);
    
    for indexj = 1:1:m
        labels{indexj} = ['Feature ', num2str(indexj)];
    end
    
    [C, tmin, ~, ~] = MatlabCART(...
        fltPatternArray_Training, grpSource_Training, ...
        fltPatternArray_CrossVal, grpSource_CrossVal, ...
        labels);
    
    structForest(indexi).tree = tmin;
    structForest(indexi).confusionMatrix = C;
    
end




end