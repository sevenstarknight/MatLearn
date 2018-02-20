% =======================================================
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
% =======================================================
function [coords, group] = CircleInSquareGenerator(intNumberOfPoints, pFlip)

xLim = [1 -1];
yLim = [1 -1];

xSet = xLim(2) + (xLim(1)-xLim(2)).*rand(intNumberOfPoints,1);
ySet = yLim(2) + (yLim(1)-yLim(2)).*rand(intNumberOfPoints,1);

radius = (0.5/pi);

group = zeros(1,intNumberOfPoints);

for i = 1:1:intNumberOfPoints
     distance = (xSet(i) - 0.5)^2 + (ySet(i) - 0.5)^2;
     if(distance > radius)
         group(i) = 2;
     else
         group(i) = 1;
     end
     
     if(rand(1,1) < pFlip)
         if(group(i) == 2)
             group(i) = 1;
         else
             group(i) = 2;
         end
     end
   
end

coords = cat(2,xSet,ySet);


end

