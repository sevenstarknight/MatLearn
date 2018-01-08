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
function [structTree] = ComputeGrownRegressionTree(fltPatternArray_Training, grpSource_Training, uniqueSources, fltPriorProb, entropyTol)

%% Initialize Variables
intLengthTraining = length(grpSource_Training);
structTree = struct([]);

intWhichNode = 1;
numberOfNodes = 1;
parentIndex = 0;

%% Grow Tree
while (entropyTol)
    
    intLengthFullSet = length(fltPatternArray_Training(1,:));
    
    [fltOptimalThresholds] = DetermineSplit(fltPatternArray_Training, grpSource_Training);
    
    [junkArray, indexArray] = sort(fltOptimalThresholds(2,:), 'descend');
       
    fltThresholdSet = fltOptimalThresholds(:,(indexArray(1)));
    
    intDimensionSplit = indexArray(1);
    
    fltDeltaMaxEntropy = fltThresholdSet(2);
    fltThreshold = fltThresholdSet(1);
    
    if(fltDeltaMaxEntropy > entropyTol)
        fltLeftChildren = [];
        fltRightChildren = [];
        
        intLeftCount = 0;
        intRightCount = 0;
        
        %% split into children
        for i = 1:1:intLengthFullSet
            if(fltThreshold > fltPatternArray_Training(intDimensionSplit,i))
                intLeftCount = intLeftCount + 1;
                fltLeftChildren(:, intLeftCount) = fltPatternArray_Training(:,i);
                fltLeftChildrenGrp{intLeftCount} = grpSource_Training{i};
            else
                intRightCount = intRightCount + 1;
                fltRightChildren(:, intRightCount) = fltPatternArray_Training(:,i);
                fltRightChildrenGrp{intRightCount} = grpSource_Training{i};
            end
        end

        [R] = ComputeResubstitutionError(grpSource_Training,intLengthTraining);
        
        %% terminal node 
        if(intRightCount < 2 || intLeftCount < 2)
            
            [type] = DetermineClassType(grpSource_Training, uniqueSources, fltPriorProb);
            
            [structTree] = StoreNode(structTree, intWhichNode, ...
                0, 0, 0, 0, fltPatternArray_Training, grpSource_Training, ...
                0, 0, parentIndex, R, 1, type);
    
            [structTree, parentIndex, intWhichNode, fltPatternArray_Training, grpSource_Training] =  ...
                MoveUpTree(structTree, parentIndex, intWhichNode);
            
            if(parentIndex ~=0)
                continue;
            else
                return;
            end
            
        end
            
        %% build node in tree
        [structTree] = StoreNode(structTree, intWhichNode, ...
            numberOfNodes + 1, numberOfNodes + 2, fltThreshold, ...
            intDimensionSplit, fltLeftChildren, fltLeftChildrenGrp, ...
            fltRightChildren, fltRightChildrenGrp, parentIndex, R, 0, 0);
        
        %% move down the tree to the left child first
        [fltPatternArray_Training, grpSource_Training, parentIndex, intWhichNode, numberOfNodes] = ...
            MoveDownTree(fltLeftChildren, fltLeftChildrenGrp, intWhichNode, numberOfNodes);
        
    else
        %% Left Side Terminal
        
        [R] = ComputeResubstitutionError(grpSource_Training,intLengthTraining);
        
        [type] = DetermineClassType(grpSource_Training, uniqueSources, fltPriorProb);
        
        [structTree] = StoreNode(structTree, intWhichNode, ...
                0, 0, 0, 0, fltPatternArray_Training, grpSource_Training, 0, 0, ...
                parentIndex, R, 1, type);
    
        [structTree, parentIndex, intWhichNode, fltPatternArray_Training, grpSource_Training] =  ...
                MoveUpTree(structTree, parentIndex, intWhichNode);
            
        if(parentIndex ~=0)
            continue;
        else
            return;
        end
        
    end
end

end
