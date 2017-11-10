% for producing diagram
clear;close all;clc;

% 
% meanValue_Health = [1.485 	1.491 	1.518 	1.557 	1.597 	1.622 	1.632 	1.601 	1.564 	1.539 	1.508];
% std_Health = [0.025 	0.023 	0.025 	0.036 	0.046 	0.059 	0.064 	0.051 	0.040 	0.035 	0.018];
% meanValue_Caries = [1.480 	1.475 	1.484 	1.496 	1.490 	1.475 	1.467 	1.464 	1.451];
% std_Caries = [0.030 	0.036 	0.042 	0.047 	0.045 	0.047 	0.036 	0.042 	0.006];
% x1 = 0:10;
% x2 = 1:9;
% figure('position',[100,200,1200,500]),
% errorbar(x1,meanValue_Health,std_Health,'ro-.');
% hold on;
% errorbar(x2,meanValue_Caries,std_Caries,'kx:');
% h = legend('正常区域','龋坏区域');
% set(h,'FontSize',15);
% hold off;
% xlabel('数据区域','FontSize',18);
% ylabel('折射率数值','FontSize',18);


%%%%%%%%%%%%%%%%%%%% 绘制箱线图 %%%%%%%%%%%%%%%%%%%%

% data = rand(10,24);
% month = repmat({'jan' 'feb' 'mar' 'apr' 'may' 'jun' 'jul' 'aug' 'sep' 'oct' 'nov' 'dec'},1,2);
% simobs = [repmat({'sim'},1,12),repmat({'obs'},1,12)];
% figure,boxplot(data,{month,simobs},'colors',repmat('rk',1,12),'factorgap',[5 2],'labelverbosity','minor');

% % 另一种方法是利用不同坐标使用hold on在同一幅图上画箱线图
% % Boxplot for the observed temperature from January to December
% Temp_O = [Jan_O, Feb_O, Mar_O, Apr_O, May_O, Jun_O, Jul_O, Aug_O, Sep_O, Oct_O, Nov_O, Dec_O];
% position_O = 1:1:12; 
% % Define position for 12 Month_O boxplots 
% box_O = boxplot(Temp_O,'colors','b','positions',position_O,'width',0.18);
% set(gca,'XTickLabel',{' '})  % Erase xlabels  
% hold on  % Keep the Month_O boxplots on figure overlap the Month_S boxplots  
% % Boxplot for the simulated temperature from January to December
% Temp_S = [Jan_S, Feb_S, Mar_S, Apr_S, May_S, Jun_S, Jul_S, Aug_S, Sep_S, Oct_S, Nov_S, Dec_S];
% position_S = 1.3:1:12.3;  % Define position for 12 Month_S boxplots 
% box_S = boxplot(Temp_S,'colors','r','positions',position_S,'width',0.18);  
% hold off   % Insert texts and labels 
% % 
% 
% health_Value = [1.450 	1.462 	1.500 	1.569 	1.635 	1.686 	1.698 	1.646 	1.589 	1.586 	1.542 
% 1.470 	1.480 	1.498 	1.529 	1.569 	1.621 	1.655 	1.619 	1.573 	1.538 	1.501 
% 1.515 	1.514 	1.547 	1.622 	1.688 	1.737 	1.757 	1.662 	1.594 	1.574 	1.538 
% 1.491 	1.496 	1.518 	1.545 	1.574 	1.611 	1.651 	1.664 	1.624 	1.567 	1.503 
% 1.502 	1.510 	1.535 	1.567 	1.601 	1.620 	1.609 	1.578 	1.556 	1.540 	1.510 
% 1.469 	1.493 	1.534 	1.574 	1.624 	1.645 	1.631 	1.602 	1.572 	1.538 	1.507 
% 1.445 	1.451 	1.469 	1.492 	1.537 	1.535 	1.539 	1.513 	1.492 	1.469 	1.488 
% 1.491 	1.477 	1.500 	1.527 	1.539 	1.551 	1.560 	1.531 	1.505 	1.498 	1.489 
% 1.497 	1.498 	1.532 	1.578 	1.615 	1.625 	1.625 	1.603 	1.552 	1.542 	1.506 
% 1.515 	1.526 	1.546 	1.564 	1.583 	1.593 	1.598 	1.595 	1.584 	1.535 	1.495 
% ];
% position_H = 0.5:1:10.5;
% figure('position',[100 100 1400 700]),
% boxplot(health_Value,{0,1,2,3,4,5,6,7,8,9,10},'color','b','positions',position_H,'width',0.15);
% hold on;
% 
% Cdata0 = [1.519 
% 1.458 
% 1.459 ];
% Cdata1 = [1.450 
% 1.509 
% 1.509 
% 1.459 
% 1.505 
% 1.450];
% Cdata2 = [1.407 
% 1.514 
% 1.479 
% 1.491 
% 1.466 
% 1.507 
% 1.459 ] ;
% Cdata3 = [1.392 
% 1.524 
% 1.507 
% 1.463 
% 1.517 
% 1.460 
% 1.431 
% 1.506 
% 1.496 
% 1.514 
% 1.516 ];
% Cdata4 = [1.530 
% 1.405 
% 1.514 
% 1.515 
% 1.467 
% 1.527 
% 1.516 
% 1.430 
% 1.519 
% 1.544 
% 1.455 
% 1.470 
% 1.561 ];
% Cdata5 = [1.512 
% 1.409 
% 1.529 
% 1.545 
% 1.544 
% 1.427 
% 1.510 
% 1.498 
% 1.485 
% 1.452 
% 1.507 
% 1.455 ];
% Cdata6 = [1.400 
% 1.530 
% 1.437 
% 1.521 
% 1.448 
% 1.515 
% 1.461 
% 1.442 
% 1.459 
% 1.538 ];
% Cdata7 = [1.437 
% 1.474 
% 1.444 
% 1.497 
% 1.441 
% 1.446 
% 1.457 
% 1.543 ];
% Cdata8 = [1.457 
% 1.418 
% 1.532 
% 1.459 
% 1.457 ];
% Cdata9 = [1.451 
% 1.444 
% 1.456 ];
% Cdata10 = 1.447;
% position_C = 0.3:1:10.3;
% Cdata = [Cdata0;Cdata1;Cdata2;Cdata3;Cdata4;Cdata5;Cdata6;Cdata7;Cdata8;Cdata9;Cdata10];
% Origin = [zeros(length(Cdata0),1);ones(length(Cdata1),1);2*ones(length(Cdata2),1);3*ones(length(Cdata3),1);
%     4*ones(length(Cdata4),1);5*ones(length(Cdata5),1);6*ones(length(Cdata6),1);7*ones(length(Cdata7),1);
%     8*ones(length(Cdata8),1);9*ones(length(Cdata9),1);10*ones(length(Cdata10),1)];
% boxplot(Cdata,Origin,'color','r','positions',position_C,'width',0.15);
% ylim([1.3,1.8]);
% set(gca,'FontSize',14);
% xlabel('Mark of Sampling-Region','FontSize',20);
% ylabel('Refractive Index','FontSize',20);
% plot(0:0,'color','k');
% plot(0:0,'color','r');
% h = legend('Control Group','Research Group');
% set(h,'FontSize',15);
% %%%%%%%%%%%%%%%%%% Robust Regression + 散点图 %%%%%%%%%%%%%%%%%%%%
% clear;  close all;   clc;
% 
% RefrativeIndex_cor = [1.458478
%     1.579734
%     1.394417
%     1.505102
%     1.546928
%     1.522897
%     1.510269
%     1.497748
%     1.512631
%     1.523168
%     1.556192
%     1.376378
%     1.509688
%     1.492921
%     1.508445
%     1.472838];
% 
% Result_MD = [0.70783
%     1.37604
%     0.64006
%     1.27773
%     1.49782
%     1.41727
%     1.18627
%     1.6388
%     1.53741
%     1.55042
%     1.50147
%     0.66121
%     1.38479
%     1.28094
%     1.03842
%     1.10997];
% a = polyfit(Result_MD,RefrativeIndex_cor,1);       % Ordinary Least Squares
% b = robustfit(Result_MD,RefrativeIndex_cor);       % Robust Regression , Bisquare
% scatter(Result_MD,RefrativeIndex_cor,'k','filled'); hold on;
% plot(Result_MD,a(2)+a(1)*Result_MD,'k','LineWidth',2);
% plot(Result_MD,b(1)+b(2)*Result_MD,'r','LineWidth',2);
% xlabel('Mineral Density [g/cm^3]','FontSize',14);
% ylabel('Refrative Index','FontSize',14);
% legend('Data','Ordinary Least Squares','Robust Regression');
% hold off;

%% 画龋坏切片中牙本质小管影响值的Stem图
% 
% x1 = 0:1:9;
% x2 = -1:10;
% Caries_MeanValue = [1.495	1.491	1.494	1.508	1.494	1.514	1.510	1.531	1.476	1.470];
% fig = figure;
% left_color = [0 0 0];
% right_color = [0 .5 .5];
% set(fig,'defaultAxesColorOrder',[left_color; right_color]);
% yyaxis left
% stem(x1,Caries_MeanValue,'k','filled','BaseValue',1.2);
% axis([-1 10 1.2 1.7]);
% set(gca,'YGrid','on');
% % set(gca,'FontSize',12,'XTick',-1:1:10);     % Current axes handle
% hold on;
% plot(x2,Caries_MeanValue(1)*ones(1,12),'k--');
% xlabel('Mark of Sampling-Region','FontSize',14);
% ylabel('Refrative Index','FontSize',14);
% yyaxis right
% D_value = Caries_MeanValue - Caries_MeanValue(1);
% scatter(x1,D_value,'d','MarkerEdgeColor',[0 .5 .5],...
%               'MarkerFaceColor',[0 .5 .5],...
%               'LineWidth',1.5);
% 
% ylim([-0.1 0.6]);
% ylabel('D-Value','FontSize',14);
% % hold off;

%% BlandAltman Test
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



