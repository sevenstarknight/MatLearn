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
function [AUC, Avar, Aci] = AUC_Computation(tp, fp, grpSource, flag)

alpha = 0.05;

if ~exist('flag','var')
   flag = 'hanley';
elseif isempty(flag)
   flag = 'hanley';
else
   flag = lower(flag);
end

strUnique = unique(grpSource);

m = sum(grpSource == strUnique(1));
n = sum(grpSource == strUnique(2));

% m = sum(data(:,1)>0);
% n = sum(data(:,1)<=0);

% Integrate ROC, A = trapz(fp,tp);
A = sum((fp(2:end) - fp(1:end-1)).*(tp(2:end) + tp(1:end-1)))/2;

% Confidence intervals
if strcmp(flag,'hanley') % See Hanley & McNeil, 1982; Cortex & Mohri, 2004
  Q1 = A / (2-A);
  Q2 = (2*A^2) / (1+A);

  Avar = A*(1-A) + (m-1)*(Q1-A^2) + (n-1)*(Q2-A^2);
  Avar = Avar / (m*n);

  Ase = sqrt(Avar);
  z = norminv(1-alpha/2);
  Aci = [A-z*Ase A+z*Ase];

elseif strcmp(flag,'maxvar') % Maximum variance
  Avar = (A*(1-A)) / min(m,n);

  Ase = sqrt(Avar);
  z = norminv(1-alpha/2);
  Aci = [A-z*Ase A+z*Ase];

else
  error('Bad FLAG for AUC!')
end

AUC = A;


end