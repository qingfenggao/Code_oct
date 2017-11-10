%%%% calculating parameter of BlandAltman %%%%
clear;
close all;clc;
Day1Scan1 = [16.40,13.73,10.28,14.36,10.95,16.96,16.20,13.94,10.00,18.12];  % data from paper(Gabrielle Rankin,1998)
Day1Scan2 = [15.94,13.48,10.74,14.44,11.64,15.84,14.06,14.82,10.65,17.84];
Day2Scan1 = [17.13,16.08,10.91,14.96,13,18.27,14.99,15.64,10.93,16.48];
Day2Scan2 = [16.78,16.31,10.6,14.7,12.63,18.57,15.81,15.22,13.46,17.51];
flag = 2;
[ReliabilityCoefficient,SEd,SDdiff,means,diffs,meanDiff,CI_agreement,CI_d,linFit] = BlandAltman(Day2Scan1, Day2Scan2, flag);
xlabel('means','FontSize',14);
ylabel('Diff','FontSize',14);
set(gca,'FontSize',12); 

fprintf('***************  Output  *******************:\n');
fprintf('mean diff:               %2.3f ;\n',meanDiff);
fprintf('SE d:                    %2.3f ;\n',SEd);
fprintf('CI diff:                 %2.3f-->%2.3f ;\n',CI_d(2),CI_d(1));
fprintf('SD diff:                 %2.3f ;\n',SDdiff);
fprintf('Reliability Coefficient: %2.3f ;\n',ReliabilityCoefficient);
fprintf('CI agreement:            %2.3f-->%2.3f ;\n',CI_agreement(2),CI_agreement(1));