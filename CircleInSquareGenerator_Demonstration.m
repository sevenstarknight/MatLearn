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
function [fltPatternArray, grpSource, FP_Rate, TP_Rate, Precision, Error] = CircleInSquareGenerator_Demonstration(fltScatter)

%% Model Data
[fltPatternArray, grpSource] = CircleInSquareGenerator(1000, fltScatter);

gscatter(fltPatternArray(:,1), fltPatternArray(:,2), grpSource(1,:), 'rb', 'ox')
xlabel('X_1')
ylabel('X_2')


%% Classifier
[X,Y] = meshgrid(linspace(-1,1, 100),linspace(-1,1, 100));
X = X(:); Y = Y(:);
fltTesting = cat(2, X, Y);
    
grpLabelEstimate = fltTesting(:,1) + fltTesting(:,2) < 0;
grpLabel = zeros(1,length(grpLabelEstimate));
for i = 1:1:length(grpLabelEstimate)
    if(grpLabelEstimate(i))
        grpLabel(i) = 2;
    else
        grpLabel(i) = 1;
    end
end

x_line = -1:0.01:1;
y_line = 0 - x_line;

%% Graphics
gscatter(fltPatternArray(:,1), fltPatternArray(:,2), grpSource(1,:), 'kk', 'ox')
hold on
gscatter(fltTesting(:,1), fltTesting(:,2), grpLabel, 'kw', '.')
line(x_line, y_line)
hold off
xlabel('X_1')
ylabel('X_2')

%% Use Classifier

divison_line(1,:) = 0:0.01:1;
divison_line(2,:) = divison_line(1,:);

FP_Rate = zeros(1,length(x_line));
TP_Rate = zeros(1,length(x_line));
Precision = zeros(1,length(x_line));

Error = struct([]);

for j = 1:1:length(x_line)
    
    classEstimate = (fltPatternArray(:,1) + fltPatternArray(:,2) + x_line(j)*2 < 0);
    fltClassEstimate = zeros(1,length(classEstimate));
    for i = 1:1:length(classEstimate)
        if(classEstimate(i))
            fltClassEstimate(i) = 2;
        else
            fltClassEstimate(i) = 1;
        end
    end

    TP = 0;
    TN = 0;
    FP = 0;
    FN = 0;

    for i = 1:1:length(fltClassEstimate)
        if(fltClassEstimate(i) == grpSource(i) && grpSource(i) == 1)
            TP = TP + 1;
        elseif(fltClassEstimate(i) == grpSource(i) && grpSource(i) == 2)
            TN = TN + 1;
        elseif(fltClassEstimate(i) ~= grpSource(i) && grpSource(i) == 2)
            FP = FP + 1;
        else
            FN = FN + 1;
        end
    end

    FP_Rate(j) = FP/(FP + TN);
    
    if((FP + TN) ~= 0)
        FP_Rate(j) = FP/(FP + TN);
    else
        FP_Rate(j) = 0;
    end
    
    
    if((TP + FN) ~= 0)
        TP_Rate(j) = TP/(TP + FN);
        Error(1).Recall(j) = sqrt(TP)/(TP + FN);
    else
        TP_Rate(j) = 0;
        Error(1).Recall(j) = 0;
    end
    
    if((TP + FP) ~= 0)
        Precision(j) = TP/(TP + FP);
        Error(1).Precision(j) = sqrt(TP*FP*(FP+TP))/((TP+FP)^2);
    else
        Error(1).Precision(j) = 0;
        Precision(j) = 0;
    end
    
end

figure()
plot(FP_Rate, TP_Rate,'--rs', 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',2)
hold on
line(divison_line(1,:), divison_line(2,:), 'Color', 'k')
grid()
hold off

xlim([0,1])
ylim([0,1])
xlabel('False Alarm Rate')
ylabel('True Positive Rate')

figure()
plot(TP_Rate, Precision,'--rs', 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',2)

xlim([0,1])
ylim([0,1])
xlabel('Recall')
ylabel('Precision')

end