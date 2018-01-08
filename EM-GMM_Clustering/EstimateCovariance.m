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
function [structPsi] = EstimateCovariance(fltDataIn, fltSum, ...
            fltClusterExp, intLength,  structPsi, switch_expr)

%% Traffic Cop for EM Clustering

    if(switch_expr == 1)
        [structPsi] = Heteroscedastic_Unstricted(fltDataIn, fltSum, ...
            fltClusterExp, intLength, structPsi) ; %General QDA
    elseif(switch_expr == 2)
        [structPsi] = Heteroscedastic_Diagonal(fltDataIn, fltSum, ...
            fltClusterExp, intLength, structPsi) ; %Naive QDA
    elseif(switch_expr == 3)
        [structPsi] = Heteroscedastic_Isotropic(fltDataIn, fltSum, ...
            fltClusterExp, intLength, structPsi) ; %Iso QDA
    elseif(switch_expr == 4)
        [structPsi] = Homoscedastic_Unstricted(fltDataIn, ...
            fltClusterExp, intLength,  structPsi); %General QDA
    elseif(switch_expr == 5)
        [structPsi] = Homoscedastic_Diagonal(fltDataIn,  ...
            fltClusterExp, intLength,  structPsi); %Naive QDA
    elseif(switch_expr == 6)
        [structPsi] = Homoscedastic_Isotropic(fltDataIn,  ...
            fltClusterExp, intLength,  structPsi); %Iso QDA
    else
        structParaEst = struct([]);
    end

end

function [structPsi] = Heteroscedastic_Unstricted(fltDataIn, fltSum, ...
            fltClusterExp, intLength, structPsi) 

        fltMean = structPsi.mean;
        
        fltSummation = 0;
        for i = 1:1:intLength
           fltCurrentData = fltDataIn(i,:);
           
           fltDistance = fltCurrentData - fltMean;
           
           fltSummation = fltSummation + fltClusterExp(i)*(fltDistance)'*(fltDistance);
        end

        fltCovEst = fltSummation/fltSum;
        
        structPsi.cov = fltCovEst;
        structPsi.invCov = inv(fltCovEst);
        structPsi.detCov = det(fltCovEst)^(-1/2);
         
end


function [structPsi] = Heteroscedastic_Diagonal(fltDataIn, fltSum, ...
            fltClusterExp, intLength, structPsi)

        fltMean = structPsi.mean;
        fltSummation = 0;
        
        for i = 1:1:intLength
           fltCurrentData = fltDataIn(i,:);
           
           fltDistance = fltCurrentData - fltMean;
           
           fltSummation = fltSummation + fltClusterExp(i)*(fltDistance.^2);
        end

        fltCovEst = fltSummation./fltSum;
        
        fltCovEstDiag = eye(length(fltSummation),length(fltSummation));
        
        for k = 1:1:length(fltSummation)
           fltCovEstDiag(k,k) = fltCovEst(k); 
        end
        
        structPsi.cov = fltCovEstDiag;
        structPsi.invCov = inv(fltCovEstDiag);
        structPsi.detCov = det(fltCovEstDiag)^(-1/2);
         
end



function [structPsi] = Heteroscedastic_Isotropic(fltDataIn, fltSum, ...
            fltClusterExp, intLength, structPsi)

        fltMean = structPsi.mean;
        fltSummation = 0;
        
        for i = 1:1:intLength
           fltCurrentData = fltDataIn(i,:);
           
           fltDistance = fltCurrentData - fltMean;
           fltDistance = sum(fltDistance.^2);
           
           
           fltSummation = fltSummation + fltClusterExp(i)*(fltDistance);
        end

        fltCovEst = fltSummation./(length(fltMean)*fltSum);
        
        fltCovEstDiag = eye(length(fltSummation),length(fltSummation))*fltCovEst;
        
        structPsi.cov = fltCovEstDiag;
        structPsi.invCov = inv(fltCovEstDiag);
        structPsi.detCov = det(fltCovEstDiag)^(-1/2);
         
end

function [structPsi] = Homoscedastic_Unstricted(fltDataIn, ...
    fltClusterExp, intLength,  structPsi) 

        fltMean = structPsi.mean;
        
        fltSummation = 0;
        for i = 1:1:intLength
           fltCurrentData = fltDataIn(i,:);
           
           fltDistance = fltCurrentData - fltMean;
           
           fltSummation = fltSummation + fltClusterExp(i)*(fltDistance)'*(fltDistance);
        end

        structPsi.cov = fltSummation;
         
end

function [structPsi] = Homoscedastic_Diagonal(fltDataIn, ...
    fltClusterExp, intLength,  structPsi) 

        fltMean = structPsi.mean;
        fltSummation = 0;
        
        for i = 1:1:intLength
           fltCurrentData = fltDataIn(i,:);
           
           fltDistance = fltCurrentData - fltMean;
           
           fltSummation = fltSummation + fltClusterExp(i)*(fltDistance.^2);
        end
        
        structPsi.cov = fltSummation;
         
end


function [structPsi] = Homoscedastic_Isotropic(fltDataIn, ...
    fltClusterExp, intLength,  structPsi) 

        fltMean = structPsi.mean;
        fltSummation = 0;
        
        for i = 1:1:intLength
           fltCurrentData = fltDataIn(i,:);
           
           fltDistance = fltCurrentData - fltMean;
           fltDistance = sum(fltDistance.^2);
           
           
           fltSummation = fltSummation + fltClusterExp(i)*(fltDistance);
        end

        structPsi.cov = fltSummation;
         
end