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
function [...
    fltPatternArray_Training, grpSource_Training, ...
    fltPatternArray_CrossVal, grpSource_CrossVal, ...
    fltPatternArray_Testing,  grpSource_Testing] = Generate_Training_CrossVal_Testing(fltPatternArray, grpSource, intDatasetSize)

uniqueTypes = unique(grpSource);
intNumTypes = length(uniqueTypes);
[~, intDimensions] = size(fltPatternArray);


%% Training
intTrainingLength = intDatasetSize;

fltPatternArray_Training = zeros(intTrainingLength, intDimensions);
grpSource_Training = cell(intTrainingLength, 1);

cycle = 1;

for i = 1:1:intTrainingLength
    
    TF = strcmp(grpSource, uniqueTypes{cycle}); 
    limitSet = fltPatternArray(TF, :);
    [intLengthReduced, ~] = size(limitSet);
    
    index = randi(intLengthReduced);
    
    fltPatternArray_Training(i,:) = limitSet(index,:);
    grpSource_Training{i} = uniqueTypes{cycle};
    
    if(cycle < intNumTypes)
        cycle = cycle + 1;
    else
        cycle = 1;
    end
    
end

[b, m, n] = unique(fltPatternArray_Training, 'rows');

fltPatternArray_Training = b;
tmp_GrpSource = [];
for i = 1:1:length(m)
    tmp_GrpSource{i} = grpSource_Training{m(i)};
end
grpSource_Training = tmp_GrpSource;

%% Cross Validation
intCrossValLength = intDatasetSize;

fltPatternArray_CrossVal = zeros(intTrainingLength, intDimensions);
grpSource_CrossVal = cell(intTrainingLength, 1);

cycle = 1;

for i = 1:1:intCrossValLength
    
    TF = strcmp(grpSource, uniqueTypes{cycle});
    
    limitSet = fltPatternArray(TF, :);
    [intLengthReduced, ~] = size(limitSet);
    
    index = randi(intLengthReduced);
    
    fltPatternArray_CrossVal(i,:) = limitSet(index,:);
    grpSource_CrossVal{i} = uniqueTypes{cycle};
    
    if(cycle < intNumTypes)
        cycle = cycle + 1;
    else
        cycle = 1;
    end
    
end

[b, m, n] = unique(fltPatternArray_CrossVal, 'rows');

fltPatternArray_CrossVal = b;
tmp_GrpSource = [];
for i = 1:1:length(m)
    tmp_GrpSource{i} = grpSource_CrossVal{m(i)};
end
grpSource_CrossVal = tmp_GrpSource;


%% Testing
intTestingLength = intDatasetSize;

fltPatternArray_Testing = zeros(intTrainingLength, intDimensions);
grpSource_Testing = cell(intTrainingLength, 1);

cycle = 1;

for i = 1:1:intTestingLength
    
    TF = strcmp(grpSource, uniqueTypes{cycle});
    
    limitSet = fltPatternArray(TF, :);
    [intLengthReduced, ~] = size(limitSet);
    
    index = randi(intLengthReduced);
    
    fltPatternArray_Testing(i,:) = limitSet(index,:);
    grpSource_Testing{i} = uniqueTypes{cycle};
    
    if(cycle < intNumTypes)
        cycle = cycle + 1;
    else
        cycle = 1;
    end
    
end

[b, m, n] = unique(fltPatternArray_Testing, 'rows');

fltPatternArray_Testing = b;
tmp_GrpSource = [];
for i = 1:1:length(m)
    tmp_GrpSource{i} = grpSource_Testing{m(i)};
end
grpSource_Testing = tmp_GrpSource;

end