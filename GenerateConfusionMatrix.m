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

function [structMap, uniqueTypes, confusionMatrix, errorEst] = GenerateConfusionMatrix(grpSource_CrossVal, classEstimate)

%% Initialize Parameters and Structures
uniqueTypes = unique(grpSource_CrossVal);
intUniqueTypes = length(uniqueTypes);

confusionMatrix = zeros(intUniqueTypes);

structMap = struct([]);

for i = 1:1:intUniqueTypes
    structMap(i).structName = uniqueTypes{i};
    
    fltFrequencyDistribution = zeros(1,intUniqueTypes);
    
    structMap(i).frequencyDistribution = fltFrequencyDistribution;
    
end

%% Populate Confusion Matrix with #
for i = 1:1:length(grpSource_CrossVal)
    
    for j = 1:1:intUniqueTypes
        if(strcmp(structMap(j).structName, grpSource_CrossVal{i}))
            
            fltFrequencyDistribution = structMap(j).frequencyDistribution;
            
            for k = 1:1:intUniqueTypes
                if(strcmp(classEstimate{i}, uniqueTypes{k}))
                    fltFrequencyDistribution(k) = fltFrequencyDistribution(k)  + 1;
                end
            end   
            
            structMap(j).frequencyDistribution = fltFrequencyDistribution;
            
        end
    end
    
end

%% Transform # to Frequency
for i = 1:1:intUniqueTypes
    fltFrequencyDistribution = structMap(i).frequencyDistribution;
    intSum = sum(fltFrequencyDistribution);
    
    confusionMatrix(i,:) = fltFrequencyDistribution/intSum;
    
end


%% Estimate Error
correct = 0;
for i = 1:1:length(grpSource_CrossVal)
    if(strcmp(grpSource_CrossVal{i}, classEstimate{i}))
        correct = correct  + 1;
    end
end

errorEst = 1 - correct/length(grpSource_CrossVal);

end