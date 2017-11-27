% version 1.0   
% First time written by gao  at 2017/11/1
% 由外向内取点
% ROI数字由内向外是 1->10

clear; close all; clc;

filename = 'L50_1';                       %% input file name
prepath = '健康样品\纵切样品\';            %% 
saveValuePath = 'meanValues\';            %% 
load([prepath,filename,'.mat'])              %% care the pathway
open([prepath,filename,'Surface.fig']);      %% input the file name which is needed to proceed
hold on;
ROInumForEveryLine = 10;                     %% not include centra of circle
contourPointNum = 10;                        %% number of lines
% inXpos = [5.3,4.23];                       %% mm unit
coronal_int = 7.2/1000;                      % mm unit,interval
sagittal_int = 0.027645;                     % mm unit
axial_int = 1.31/153;                        % mm unit  4.7/500 is replaced
picture_size = 550;                          % coronal direction length
N_max = 2;
N_min = 1.33;                                %%
[r_num,c_num]=size(N);
r_len = (1:r_num)*sagittal_int;
c_len = (1:c_num)*coronal_int;

for i = 1:contourPointNum
    [outXpos(i),outYpos(i)] = ginput(1);                                 % use mouse to get contour points
    [inXpos(i),inYpos(i)] = ginput(1);                                   % out- represent outer point
    text(outXpos(i),outYpos(i),num2str(i),'color','r','FontSize',10);    % in-  represent inter point
    text(inXpos(i),inYpos(i),num2str(i),'color','r','FontSize',10);
    if i>=2
        line([outXpos(i-1),outXpos(i)],[outYpos(i-1),outYpos(i)],'color','r');     % plot the line of contour
        line([inXpos(i-1),inXpos(i)],[inYpos(i-1),inYpos(i)],'color','r');
    end
end

for i = 1:contourPointNum                                                   % the index of counter point
    for j = 1:ROInumForEveryLine
        line([inXpos(i),outXpos(i)],[inYpos(i),outYpos(i)],'color','y');
        lineLength(i) = sqrt((inXpos(i)-outXpos(i))^2 + (inYpos(i)-outYpos(i))^2);
        radius(i) = lineLength(i)/(ROInumForEveryLine*2);
        linePoint_xx(i,j,:) = inXpos(i) - (inXpos(i)-outXpos(i))*(2*j-1)*radius(i)/lineLength(i);
        linePoint_yy(i,j,:) = inYpos(i) - (inYpos(i)-outYpos(i))*(2*j-1)*radius(i)/lineLength(i);
        lineCentre(i,j,:) = [linePoint_xx(i,j,:),linePoint_yy(i,j,:)];      % 第一个数代表第几条线，第二个代表某条线的第几个圆心，第三个为圆心的坐标
    end
end
hold off;

N(find(isnan(N)==1)) = 0;
N(find(N<=N_min)) = 0;                       % removing some unexpect data range (N_min,N_max)
N(find(N>=N_max)) = 0;
N = medfilt2(N,[3,3]);                       % use median fiter

figure('name','Results','position',[550,50,picture_size,2/5*picture_size*sagittal_int/coronal_int-100]),
imagesc(c_len,r_len,N,[1,2]);axis image;
impixelinfo;
xlabel('Distance of X axis [mm]','FontSize',16);
ylabel('Distance of Y axis [mm]','FontSize',16);
[c_dis,r_dis] = meshgrid(c_len,r_len);
for i = 1:contourPointNum 
    for j = 1:ROInumForEveryLine
        circleMask = ((c_dis-lineCentre(i,j,1)).^2 + (r_dis-lineCentre(i,j,2)).^2) <= radius(i).^2;
        hold on;
        line(outXpos,outYpos,'color','r');                                    % plot the line of contour
        line(inXpos,inYpos,'color','r'); 
        line([inXpos(i),outXpos(i)],[inYpos(i),outYpos(i)],'color','y');      % show the contour line
        contour(c_len, r_len, circleMask, [1 1], 'color',[0.1*j 1 1]);
        ROI_data = N(circleMask);
        ROI_data(find(ROI_data<=N_min)) = 0;                                        % removing some unexpect data range (1,2)
        ROI_data(find(ROI_data>=N_max)) = 0;
        ROI_data(find(isnan(ROI_data)==1)) = 0;
        ROI_data(ROI_data==0) = [];
        meanMatrix(i,j) = mean(ROI_data,'omitnan');             % 表示第i条线第j个圆的平均
    end
end

meanData = nanmean(meanMatrix,1);       % expect nan
hold off;

save([saveValuePath,filename,'.mat'],'meanData');    
disp(meanData)
aCopyValue = meanData;


%%%%%%%%%%%%%%  20171102_L44_1折射率数值stem图  %%%%%%%%%%%%%%%%
% figure,
% xx = 1:10;
% stem(xx,meanValue,'MarkerFaceColor','black',...
%          'Color','black',...
%          'MarkeredgeColor','none');
% set(gca,'FontSize',12,'YGrid','on');
% axis([1 10 1.2 1.7]);
% xlabel('Marker of sampling-region','FontSize',14);
% ylabel('Refractive index','FontSize',14);

