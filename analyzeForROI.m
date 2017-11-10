%  refractive index is associated with mineral density 
% revised by gao at 2017/08/25
clear; close all; clc;

filename = 'D1_c';                      %% input file name
prepath = '龋坏样品\横切样品\';          %% 
load([prepath,filename,'.mat'])       
open([prepath,filename,'Surface.fig']);      %% input the file name which is needed to proceed

ROI_centre = [3.025,6.33];                  %% mm unit
InputRadius = 0.6;                        %% mm unit

coronal_int = 7.2/1000;                      % mm unit,interval
sagittal_int = 0.027645;                     % mm unit
axial_int = 1.31/153;                        % mm unit  4.7/500 is replaced
picture_size = 550;                          % coronal direction length
N_max = 2;
N_min = 1;
r_num = 400;
c_num = 1000;
yLen = (1:r_num)*sagittal_int;
xLen = (1:c_num)*coronal_int;


N(find(isnan(N)==1)) = 0;
N(find(N<=N_min)) = 0;                       % removing some unexpect data range (N_min,N_max)
N(find(N>=N_max)) = 0;
N = medfilt2(N,[3,3]);                       % use median fiter

figure('name','Results','position',[600,50,700,770]),
imagesc(xLen,yLen,N,[1,2]);axis image;
impixelinfo;
xlabel('Coronal Position [mm]','FontSize',16);
ylabel('Sagittal Position [mm]','FontSize',16);
title('Refractive Index','FontSize',20);

% Perform the ROI analysis
[xDis,yDis] = meshgrid(xLen,yLen);
circleMaskROI = (((xDis - ROI_centre(1)).^2 + (yDis - ROI_centre(2)).^2) <= InputRadius^2);
hold on;
contour(xLen, yLen, circleMaskROI, [1 1],'LineColor',[1 1 0], 'LineWidth', 0.5);
hold off;
%%%%%%%%%% Gray Image of Surface %%%%%%%%%%%%%%%
open([prepath,filename,'Surface.fig']);      %% input the file name which is needed to proceed
hold on;
contour(xLen, yLen, circleMaskROI, [1 1],'LineColor',[1 1 0], 'LineWidth', 0.5);
hold off;
%%%%%%%%%%%

% Analysis the ROI 
N_max = 2;
N_min = 1;
inclusion = N(circleMaskROI);
inclusion(find(inclusion<=N_min)) = 0;     % removing some unexpect data range (N_min,N_max)
inclusion(find(inclusion>=N_max)) = 0;
inclusion(inclusion==0) = [];
inclusionMeanV = mean(inclusion(:));
inclusionStdV = std(inclusion(:));

fprintf('Refractive Index of ROI is %2.5f±%2.5f ;\n',inclusionMeanV,inclusionStdV);
