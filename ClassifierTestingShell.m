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
function [errorArray] = ClassifierTestingShell(fltPatternArray_Training, ...
    grpSource_Training, fltPatternArray_CrossVal, grpSource_CrossVal)

% kSet = 10.^(-5:0.2:1); % PWC
kSet = 1:1:20; % K-NN

errorArray = zeros(2,length(kSet));
counter = 1;

for i = kSet

    [fltResponse, classEstimate] = ...
        Naive_K_Nearest(fltPatternArray_Training, grpSource_Training, ...
        fltPatternArray_CrossVal, i, 2, 1, 'Miss');
% 
%     [fltPostProb, classEstimate] = Parzen_Window_Classifier(...
%         fltPatternArray_Training, grpSource_Training, fltPatternArray_CrossVal, ...
%         3, i, 'Missed');
    
    [structMap, uniqueTypes, confusionMatrix, errorEst] = ...
        GenerateConfusionMatrix(grpSource_CrossVal, classEstimate);

    errorArray(1,counter) = i;
    errorArray(2,counter) = errorEst;
    
    counter = counter + 1;
end


end