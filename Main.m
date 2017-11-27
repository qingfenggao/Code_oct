%%%% calculating parameter of BlandAltman %%%%
clear;
close all;clc;
Day1Scan1 = [16.40,13.73,10.28,14.36,10.95,16.96,16.20,13.94,10.00,18.12];  % data from paper(Gabrielle Rankin,1998)
Day1Scan2 = [15.94,13.48,10.74,14.44,11.64,15.84,14.06,14.82,10.65,17.84];
Day2Scan1 = [17.13,16.08,10.91,14.96,13,18.27,14.99,15.64,10.93,16.48];
Day2Scan2 = [16.78,16.31,10.6,14.7,12.63,18.57,15.81,15.22,13.46,17.51];
% the results of experiments
CrossCut_Operator1Scan1 = [1.634,1.611,1.667,1.59,1.633,1.543,1.538,1.577,1.607];
CrossCut_Operator1Scan2 = [1.626,1.591,1.614,1.571,1.576,1.507,1.534,1.582,1.591];
CrossCut_Operator2Scan1 = [1.641,1.615,1.679,1.602,1.637,1.585,1.573,1.611,1.619];
CrossCut_Operator2Scan2 = [1.637,1.595,1.623,1.581,1.625,1.555,1.568,1.613,1.614];
CrossCut_Operator1Mean = [1.630,1.601,1.641,1.581,1.605,1.525,1.536,1.580,1.599];
CrossCut_Operator2Mean = [1.639,1.605,1.651,1.592,1.631,1.570,1.571,1.612,1.617];

LongCut_Operator1Scan1 = [1.617,1.610,1.558,1.575,1.533,1.548,1.528,1.557,1.564,1.583];
LongCut_Operator1Scan2 = [1.499,1.491,1.517,1.537,1.549,1.549,1.479,1.551,1.543,1.582];
LongCut_Operator2Scan1 = [1.487,1.492,1.515,1.547,1.581,1.604,1.531,1.517,1.572,1.619];
LongCut_Operator2Scan2 = [1.528,1.508,1.548,1.567,1.592,1.563,1.565,1.568,1.577,1.638];
LongCut_Operator1Mean = [1.558,1.551,1.538,1.556,1.541,1.549,1.504,1.554,1.554,1.583];
LongCut_Operator2Mean = [1.508,1.500,1.532,1.557,1.587,1.584,1.548,1.543,1.575,1.629];

flag = 2;      %%
[ReliabilityCoefficient,SEd,SDdiff,means,diffs,meanDiff,CI_agreement,CI_d,linFit,xlim] = BlandAltman(CrossCut_Operator1Mean, CrossCut_Operator2Mean, flag);
set(gca,'FontSize',12,'XTick',xlim(1):0.01:xlim(2));     % Current axes handle
xlabel('IRMEAN','FontSize',16);
ylabel('IRDIFF','FontSize',16);

% OUTPUT = [meanDiff,SEd,CI_d(2),CI_d(1),SDdiff,ReliabilityCoefficient,CI_agreement(2),CI_agreement(1)];

fprintf('***************  Output  *******************:\n');
fprintf('mean diff:               %2.3f ;\n',meanDiff);
fprintf('SE d:                    %2.3f ;\n',SEd);
fprintf('CI diff:                 %2.3f->%2.3f ;\n',CI_d(2),CI_d(1));
fprintf('SD diff:                 %2.3f ;\n',SDdiff);
fprintf('Reliability Coefficient: %2.3f ;\n',ReliabilityCoefficient);
fprintf('CI agreement:            %2.3f->%2.3f ;\n',CI_agreement(2),CI_agreement(1));

