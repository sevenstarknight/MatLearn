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
function [C, tmin, errorEst, uniqueTypes] = MatlabCART(fltPatternArray_Training, grpSource_Training, fltPatternArray_CrossVal, grpSource_CrossVal, labels)

t = classregtree(fltPatternArray_Training,grpSource_Training,'method', 'classification', 'splitcriterion', 'gdi', 'names',labels,'splitmin',5, 'priorprob', 'equal');

try
    [c,s,n,best] = test(t,'crossvalidate',fltPatternArray_CrossVal, grpSource_CrossVal);

    if(best <= 1)
        tmin = t;
    else
        tmin = prune(t,'level',best);
    end

    [mincost,minloc] = min(c);

    plot(n,c,'b-o',...
         n(best+1),c(best+1),'bs',...
         n,(mincost+s(minloc))*ones(size(n)),'k--')

    xlabel('Tree size (number of terminal nodes)')

    ylabel('Cost')
    
catch ME
    
    tmin = t;
    
end


classEstimate = tmin(fltPatternArray_CrossVal);

[C,order] = confusionmat(grpSource_CrossVal,classEstimate);

[structMap, uniqueTypes, confusionMatrix, errorEst] = GenerateConfusionMatrix(grpSource_CrossVal, classEstimate);

sumSet = sum(C,2);

for i = 1:1:length(sumSet)
    C(i,:) = C(i,:)./sumSet(i);
end


end

%% Subfunction
