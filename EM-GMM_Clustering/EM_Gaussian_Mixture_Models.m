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
function [structPsi, clusteringMovie, intLabel] = EM_Gaussian_Mixture_Models(fltDataIn, intClusters)

delta = 1;
tol = 1*10^-5;

intDimensions = length(fltDataIn(1,:));
intLength = length(fltDataIn(:,1));

%% Initialization
[structPsi] = Initialization(fltDataIn, intClusters);

fltIncLogArray = [];
counter = 0;

intLabel = [];

while (delta > tol)
    
    %% E-Step
    [fltExpectation, fltIncLog] = E_Step(fltDataIn, structPsi, ...
        intClusters, intLength, intDimensions);
    
    %% M-Step
    [structPsi] = M_Step(fltDataIn, fltExpectation, structPsi, ...
        intClusters, intLength, intDimensions);
   
    %% Generate Surface Map Nodes
    [intLabel] = Graphics(fltDataIn, structPsi, intDimensions, ...
        intLength, intClusters, fltExpectation);
    
    %% Build Movie
    counter = counter + 1;
    
    fltIncLogArray(counter) = fltIncLog;
	clusteringMovie(counter) = getframe;
    
    %% Convergence Estimate
    if(counter > 2)
        delta = fltIncLogArray(counter) - fltIncLogArray(counter - 1);
    end


end
% figure
% movie(clusteringMovie, 1, 5); % Movie plays 1 time 5 fps
% 
% figure
% plot(rateOfConvergence);



end

function [structPsi] = Initialization(fltDataIn, intClusters)

structPsi = struct([]);

fltCovEst = cov(fltDataIn);

r = randi(length(fltDataIn),intClusters,1);

for j = 1:1:intClusters
    structPsi(j).mean = fltDataIn(r(j),:);
    structPsi(j).cov = fltCovEst;
    
    structPsi(j).invCov = inv(fltCovEst);
    structPsi(j).detCov = det(fltCovEst)^(-1/2);
    
    structPsi(j).prior = 1/intClusters;
end

end

function [fltExpectation, fltIncLogArray] = E_Step(fltDataIn, structPsi, intClusters, intLength, intDimensions)

fltExpectation = zeros(intLength, intClusters);
fltIncLogArray = 0;

for i = 1:1:intLength
      fltCurrentData = fltDataIn(i,:);

      fltPDFCluster = zeros(1,intClusters);
      priorArray = zeros(1,intClusters);

      for j = 1:1:intClusters
         fltMean = structPsi(j).mean;
         invCov = structPsi(j).invCov;
         detCov = structPsi(j).detCov;
         priorArray(j) = structPsi(j).prior;

         fltDistance = fltCurrentData - fltMean;

         fltTDistance = (fltDistance*invCov*fltDistance');

         fltPDFCluster(j) = ((2*pi)^(-intDimensions/2))*detCov*exp(-0.5*fltTDistance);
      end

      
      normalize = priorArray*fltPDFCluster';

      fltIncLogArray = fltIncLogArray + normalize;
      
      for j = 1:1:intClusters
         fltExpectation(i,j) = (priorArray(j)*fltPDFCluster(j))/normalize; 
      end

end

end

function [structPsi] = M_Step(fltDataIn, fltExpectation, structPsi, intClusters, intLength, intDimensions)

    switch_expr = 1;

    for j = 1:1:intClusters
        tmpStructPsi = structPsi(j);
        
        fltClusterExp = fltExpectation(:,j);
        fltSum = sum(fltClusterExp);
        %% Mean
        tmpStructPsi.mean = (fltClusterExp'*fltDataIn)/fltSum;
        
        %% Covariance
        [tmpStructPsi] = EstimateCovariance(fltDataIn, fltSum, ...
            fltClusterExp, intLength, tmpStructPsi, switch_expr);
        
        %% Estimate Pi
        tmpStructPsi.prior = fltSum/intLength;
        
        structPsi(j) = tmpStructPsi;
        
    end
    
    %% If Homoscedastic Model is Used
    if(switch_expr > 3)
        
        %% Initialize Cov Matrix
        if(switch_expr == 4)
            tmpCov = zeros(intDimensions);
        elseif(switch_expr == 5)
            tmpCov = zeros(1,intDimensions);
        elseif(switch_expr == 6)
            tmpCov = 0;
        end
        
        for j = 1:1:intClusters
            tmpCov = tmpCov + structPsi(j).cov;
        end
        
        tmpCov = tmpCov/intLength;
    
        if(switch_expr == 5)
                
            tmpEye = eye(length(tmpCov));

            for k = 1:1:intDimensions
                tmpEye(k,k) = tmpCov(k)*tmpEye(k,k);
            end

            tmpCov = tmpEye;

        elseif(switch_expr == 6)
            tmpCov = (tmpCov/intDimensions)*eye(intDimensions);
        else
            
        end
        
        %% Store Cov Matrix
        for j = 1:1:intClusters
            structPsi(j).cov = tmpCov;
            structPsi(j).invCov = inv(tmpCov);
            structPsi(j).detCov = det(tmpCov)^(-1/2);
        end
        
    end
    
end

function [intLabel] = Graphics(fltDataIn, structPsi, ...
        intDimensions, intLength, intClusters, fltExpectation)
%     %% Generate Surface Map Nodes
%     maxSizeA1  = max(fltDataIn);
%     minSizeA1  = min(fltDataIn);
%     X = linspace(minSizeA1(1),maxSizeA1(1),50);
%     Y = linspace(minSizeA1(2),maxSizeA1(2),50);
%     
%     [X1,X2] = meshgrid(X',Y');
%     X = [X1(:) X2(:)];
%     
%     for j = 1:1:intClusters
%         
%         fltMean = structPsi(j).mean;
%         fltCov = structPsi(j).cov;
%         
%         p = mvnpdf(X,fltMean,fltCov);
%         
%         structPsi(j).p = p;
%         
%         structPsi(j).center = mvnpdf(fltMean,fltMean,fltCov);
%     end
% 
%     p = zeros(length(X), 1);
%     
%     for i = 1:1:length(X)
%         tmpArray = zeros(1,length(structPsi));
%         for j = 1:1:length(structPsi)
%             tmpArray(j) = 1 - (structPsi(j).center - structPsi(j).p(i));
%         end
%         
%         p(i) = max(tmpArray);
%         
%     end
    
    %% Initialize Convergence Estimate
    fltMeansK1 = zeros(intClusters, intDimensions);
    
    for j = 1:1:intClusters
        fltMeansK1(j,:) = structPsi(j).mean;
    end
    
    %% Graphics
    intLabel = zeros(1,intLength);
    
    clusterLabel = 1:intClusters;

    for i = 1:1:intLength
       intLabel(i) = find(max(fltExpectation(i,:)) == fltExpectation(i,:));
    end
    
    gscatter(fltDataIn(:,1)', fltDataIn(:,2)', intLabel, 'rbkgm','.',10)
    hold on
    gscatter(fltMeansK1(:,1), fltMeansK1(:,2), clusterLabel, 'rbkgm','o', 15)
%     contour(X1,X2,reshape(p,50,50));

    hold off

end

