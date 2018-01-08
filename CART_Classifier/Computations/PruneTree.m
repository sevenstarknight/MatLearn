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

function [structTree] = PruneTree(structTree, arrayOfNodeResults, sortedAlpha, intLengthTraining, priorProb, typesAvailable)

    indexPrune = arrayOfNodeResults(2, sortedAlpha ==  arrayOfNodeResults(1,:));
    
    %% reconstitute the arrays
    arrayToLeft = structTree(indexPrune).arrayToLeft;
    arrayToRight = structTree(indexPrune).arrayToRight;
    
    fltFullSet = cat(2,arrayToLeft, arrayToRight);
    
    grpToLeft = structTree(indexPrune).grpToLeft;
    grpToRight = structTree(indexPrune).grpToRight;
    
    fltFullGrp = cat(2,grpToLeft, grpToRight);
 
    %% Recompute Resubstitution
    [R] = ComputeResubstitutionError(fltFullGrp,intLengthTraining);
    structTree(indexPrune).resubError = R;
    
    %% find parent to change terminal number
    intTerminalNodesPrior = structTree(indexPrune).intTerminalNodes ;
    parentIndex = structTree(indexPrune).parentIndex;
    
    nodeChange = intTerminalNodesPrior - 1;
    
    %% == Determine classification at node
    [type] = DetermineClassType(fltFullGrp, typesAvailable, priorProb);
    
    [structTree] = StoreNode(structTree, indexPrune, ...
                0, 0, 0, 0, fltFullSet, fltFullGrp, 0, 0, ...
                parentIndex, R, 1, type);
      
    %% Iterate down the terminal count, post pruning
    while(2)
       structTree(parentIndex).intTerminalNodes = structTree(parentIndex).intTerminalNodes - nodeChange;
       
       if(structTree(parentIndex).parentIndex == 0)
           break;
       else
           parentIndex = structTree(parentIndex).parentIndex;
       end
       
    end

    %% Prune pointless branches
    while(2)
        leftIndex = structTree(indexPrune).leftIndex;
        rightIndex = structTree(indexPrune).rightIndex;
        
        if(leftIndex == 0 && rightIndex == 0)
            break;
        end
        
        if(structTree(leftIndex).leftIndex == 0)
            structTree(leftIndex) = [];
            indexPrune = structTree(leftIndex).rightIndex;
        else
            indexPrune = leftIndex;
        end
    end
    
end
