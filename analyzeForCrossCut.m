% version 1.0   
% First time written by gao  at 2017/1/3
clear; close all; clc;

filename = 'ZH9_2';                           %% input file name
prepath = '健康样品\横切样品\';               %% 
saveValuePath = 'meanValues\';               % 
load([prepath,filename,'.mat'])              % care the pathway
open(['健康样品\横切样品\',filename,'Surface.fig']);      %% input the file name which is needed to proceed
hold on;
ROInumForEveryLine = 10;                     % not include centra of circle
contourPointNum = 20;                        % number of lines
Slice_centre = [5.16,4.5];                  %% mm unit
coronal_int = 7.2/1000;                      % mm unit,interval
sagittal_int = 0.027645;                     % mm unit
axial_int = 1.31/153;                        % mm unit  4.7/500 is replaced
picture_size = 550;                          % coronal direction length
N_max = 2;
N_min = 1;
r_num = 400;
c_num = 1000;
r_len = (1:r_num)*sagittal_int;
c_len = (1:c_num)*coronal_int;

for i = 1:contourPointNum
    [Xpos(i),Ypos(i)] = ginput(1);                       % use mouse to get contour points
    text(Xpos(i),Ypos(i),num2str(i),'color','r','FontSize',10);
    if i>=2
        line([Xpos(i-1),Xpos(i)],[Ypos(i-1),Ypos(i)],'color','r');     % plot the line of contour
    end 
end

for i = 1:contourPointNum                                                                      % the index of counter point
    for j = 1:ROInumForEveryLine
        line([Slice_centre(1),Xpos(i)],[Slice_centre(2),Ypos(i)],'color','y');
        lineLength(i) = sqrt((Slice_centre(1)-Xpos(i))^2 + (Slice_centre(2)-Ypos(i))^2);
        radius(i) = lineLength(i)/(ROInumForEveryLine*2+1);
        linePoint_xx(i,j,:) = Slice_centre(1) - (Slice_centre(1)-Xpos(i))*2*j*radius(i)/lineLength(i);
        linePoint_yy(i,j,:) = Slice_centre(2) - (Slice_centre(2)-Ypos(i))*2*j*radius(i)/lineLength(i);
        lineCentre(i,j,:) = [linePoint_xx(i,j,:),linePoint_yy(i,j,:)];% 第一个数代表第几条线，第二个代表某条线的第几个圆心，第三个为圆心的坐标
    end
end
hold off;

N(find(isnan(N)==1)) = 0;
N(find(N<=N_min)) = 0;                       % removing some unexpect data range (N_min,N_max)
N(find(N>=N_max)) = 0;
N = medfilt2(N,[3,3]);                       % use median fiter

figure('name','Results','position',[550,70,picture_size,2/5*picture_size*sagittal_int/coronal_int-100]),
imagesc(c_len,r_len,N,[1,2]);axis image;
impixelinfo;
xlabel('Distance of X axis [mm]','FontSize',16);
ylabel('Distance of Y axis [mm]','FontSize',16);
[c_dis,r_dis] = meshgrid(c_len,r_len);
for i = 1:contourPointNum 
    for j = 1:ROInumForEveryLine
        circleMask = ((c_dis-lineCentre(i,j,1)).^2 + (r_dis-lineCentre(i,j,2)).^2) <= radius(i).^2;
        hold on;
        line(Xpos,Ypos,'color','r');                                                % plot the line of contour
        line([Slice_centre(1),Xpos(i)],[Slice_centre(2),Ypos(i)],'color','y');      % show the contour line
        contour(c_len, r_len, circleMask, [1 1], 'color',[0.1*j 1 1]);
        ROI_data = N(circleMask);
        ROI_data(find(ROI_data<=N_min)) = 0;                                        % removing some unexpect data range (1,2)
        ROI_data(find(ROI_data>=N_max)) = 0;
        ROI_data(ROI_data==0) = [];
        meanMatrix(i,j) = mean(ROI_data,'omitnan');             % 表示第i条线第j个圆的平均
    end
end
meanData = mean(meanMatrix,'omitnan');
for i = 1:contourPointNum                                                                      % the index of counter point
        lineLength(i) = sqrt((Slice_centre(1)-Xpos(i))^2 + (Slice_centre(2)-Ypos(i))^2);
        radius(i) = lineLength(i)/(ROInumForEveryLine*2+1);
        centrePoint_xx(i) = Slice_centre(1) - (Slice_centre(1)-Xpos(i))*radius(i)/lineLength(i);  % polygon vertexs
        centrePoint_yy(i) = Slice_centre(2) - (Slice_centre(2)-Ypos(i))*radius(i)/lineLength(i);
end
BW = roipoly(c_len,r_len,N,centrePoint_xx,centrePoint_yy);       % get centre mask
fill(centrePoint_xx,centrePoint_yy,[1 0.3 0.3],'EdgeColor','none');  % fill red color in the centre area
if contourPointNum==1
    centreMask = ((c_dis-Slice_centre(1)).^2 + (r_dis-Slice_centre(2)).^2) <= radius.^2;
    hold on;
    contour(c_len, r_len, centreMask, [1 1], 'color','r');
    ROI_data = N(centreMask);
    ROI_data(find(ROI_data<=N_min)) = 0;     % removing some unexpect data range (1,2)
    ROI_data(find(ROI_data>=N_max)) = 0;
    ROI_data(ROI_data==0) = [];
    meanCentre = mean(ROI_data,'omitnan');             % 表示第i条线第j个圆的平均
else
    meanCentre = mean(N(BW),'omitnan');
end

meanValue = [meanCentre,meanData];
hold off;

save([saveValuePath,filename,'.mat'],'meanValue','Slice_centre');    
disp(meanValue)
aCopyValue = [meanValue,Slice_centre];          % data used for coping for MB to Excel




% %% 绘制地势图
% N = flipud(N);                            % 将N值列元素反转
% N_S = smoothn(N,10);
% figure,set(gcf,'position',[100 100 1400 700]);
% surf(c_len,r_len,N_S,'EdgeColor','none');
% zlim([1.4,2]);
% colorbar;
% caxis([1 2]);
% view([-50 74]);
% xlabel('Distance of X axis [mm]','FontSize',16);
% ylabel('Distance of Y axis [mm]','FontSize',16);
% zlabel('Refractive index','FontSize',16);
% % title('关于切片折射率的表面图','FontSize',20);