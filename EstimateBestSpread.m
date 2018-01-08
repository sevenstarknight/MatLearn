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
function [structLRC, nodes, spread, error, classEstimate] = EstimateBestSpread(fltTraining, grpTraining, fltCrossVal, grpCrossVal)

errorEst = zeros(2, 100);
h = waitbar(0,'Spread Optimization in Progress') ;
 
for i = 1:1:100 
    
    ratio = double(i)/double(100);
    waitbar(ratio)
    
    spread = 1 + i*0.1;
    [structLRC, nodes, spread, errorEst(1,i), classEstimate] = RadialBasisFunctionClassifier(fltTraining', grpTraining, fltCrossVal', grpCrossVal, spread);
    errorEst(2,i) = spread;

end

close(h);

save(savefile, 'errorEst');


optimalSpread = errorEst(2,min(errorEst(1,:)) == errorEst(1,:));

if(length(optimalSpread) == 1)
    [structLRC, nodes, spread, error, classEstimate] = RadialBasisFunctionClassifier(fltTraining', grpTraining, fltCrossVal', grpCrossVal, optimalSpread);
else
    optimalSpread = mean(optimalSpread);
    [structLRC, nodes, spread, error, classEstimate] = RadialBasisFunctionClassifier(fltTraining', grpTraining, fltCrossVal', grpCrossVal, optimalSpread);
end

end
