% method for get and calculate circle data
% version 1.0   
% latest written by gao  at 2016/12/4
% 双层的盖玻片为350um

clear; close all; clc;

coronal_int = 7.2/1000;            % mm unit,interval
sagittal_int = 0.027645;             % mm unit
axial_int = 1.31/153;              % mm unit  replace 4.7/500
picture_size = 550;                % coronal direction length
N_max = 2;
N_min = 1;
r_num = 400;
c_num = 1000;
r_len = (1:r_num)*sagittal_int;
c_len = (1:c_num)*coronal_int;
% 
% %% get suface gray image
% % The algorithm parameters:
% % filename = '1208_13_1';         %%%% set file name
% filename = 'glass1';         %%%% set file name
% path_name =['D:\Administrator\optical coherence tomography\Data\Data_3D\Data_20161222\',filename,'\'];   % 设置数据路径
% addpath(path_name);  
% pic = dir([path_name,'*.bmp']);
% a = size(pic);
% num = a(1);
% I1= imread('1.bmp');                                     % 读取第一帧
% [I1] = img_cor(I1,0);
% img_3D = I1;                                              % 赋值第一帧的数据
% for i=2:num                                              % 随起始帧的改变而改变
%      fname = sprintf('%d.bmp',i);
%      x=fname;
%      d= imread(x);
%      [d] = img_cor(d,0);
%      img_3D = cat(3,img_3D,d);                             % 3维数据堆放在D中
% end  
% for y = 1:400
%    for x = 1:1000
%        img_C(y,x) = max(img_3D(:,x,y));
%    end
% end
% figure('name','C_scan image','position',[10,50,picture_size,2/5*picture_size*sagittal_int/coronal_int]),
% imagesc(c_len,r_len,img_C);
% impixelinfo;colormap(gray);
% xlabel('Coronal Position (mm)','FontSize',16);ylabel('Sagittal Position (mm)','FontSize',16);title('Gray Image of Surface','FontSize',18);

%%
filename = '1103_10_1';
load(['1222\',filename,'.mat'])
% load('1208\2016_12_08_7_2.mat')
% load('1208\1208_10 1.mat')
open(['1222\',filename,'Surface.fig']);                   % input the file name which is needed to proceed
open_circle = 0 ;                    %% select 1==> arbitary ROI,select 0 ==> ROI of circles
open_rectangle = ~open_circle ;     

Circle.n = 6;                        %% set the number of circles
Circle.centre = [4.56,3.86];         %% mm unit
radius_init = 0.8;                   %% mm unit

rectangle.position = [3,0.2];        %%
rectangle.coronal = 6;               %%%
rectangle.sagittal = 9.8;            %%
% rectangle.n = 1;                   %

N(find(isnan(N)==1)) = 0;
N(find(N<=N_min)) = 0;           % removing some unexpect data range (N_min,N_max)
N(find(N>=N_max)) = 0;
N = medfilt2(N,[4,4]);          % use median fiter


%% Circle
if open_circle==0  
figure('name','Circles','position',[550,50,picture_size,2/5*picture_size*sagittal_int/coronal_int]),
imagesc(c_len,r_len,N,[1,2]);
impixelinfo;
% colorbar;
axis image;
xlabel('Coronal Position [mm]','FontSize',16);
ylabel('Sagittal Position [mm]','FontSize',16);
title('Refractive Index','FontSize',20);
[c_dis,r_dis] = meshgrid(c_len,r_len);

    for TF = 1:Circle.n
        radius(TF) = radius_init*sqrt(TF);
        if TF == 1;
            Circle_Mask(:,:,TF) = ((c_dis-Circle.centre(1)).^2 + (r_dis-Circle.centre(2)).^2) <= radius(TF).^2;
        else
            Circle_Mask(:,:,TF) = (((c_dis-Circle.centre(1)).^2 + (r_dis-Circle.centre(2)).^2) <= radius(TF).^2)&(((c_dis-Circle.centre(1)).^2 + (r_dis-Circle.centre(2)).^2) >= radius(TF-1).^2);
        end
        hold on;
%         rectangle('position',[Circle.centre(1),Circle.centre(2),coronal_int,sagittal_int],...
%             'FaceColor','r','EdgeColor','none');
        contour(c_len, r_len, Circle_Mask(:,:,TF), [1 1], 'b-', 'LineWidth', 2);
        %     hold off;
        ROI_data = N(Circle_Mask(:,:,TF));
        ROI_data(find(ROI_data<=N_min)) = 0;      % removing some unexpect data range (1,2)
        ROI_data(find(ROI_data>=N_max)) = 0;
        ROI_data(ROI_data==0) = [];
        Circle.mean(TF) = mean(ROI_data);
        Circle.std(TF) = std(ROI_data);
        
        Circle_total = ((c_dis-Circle.centre(1)).^2 + (r_dis-Circle.centre(2)).^2) <=(radius_init*sqrt(Circle.n)).^2;
        ROI_data_total = N(Circle_total);
        ROI_data_total(ROI_data_total==0) = [];
        Circle.total_mean = mean(ROI_data_total);
        Circle.total_std = std(ROI_data_total);
    end
    hold off;
    
%     figure('position',[100 300 1400 500]),
%     errorbar(1:length(Circle.mean),Circle.mean,Circle.std,':bo');title('Result','FontSize',16);
%     xlabel('Circle number','FontSize',16);
%     ylabel('Refrative Index','FontSize',16);
     disp('');
     disp(fprintf('%20s\t %10.3f\t %10.3f\t %10.3f\t','ROI_mean = ',Circle.mean));  
     disp(fprintf('%20s\t %10.3f\t %10.3f\t %10.3f\t','ROI_std = ',Circle.std));
%      disp(fprintf('%20s\t %10.2f\t %10.2f\t %10.2f\t','ROI_mean = ',Circle.mean,Circle.std));
    
%     disp('Output the aveage value of circles: ');
%     disp(Circle.total_mean)
%     disp('Output the standard deviation of circles: ');
%     disp(Circle.total_std)
end
%% arbitary ROI
if open_rectangle==0
%     figure('name','N','position',[10 50 picture_size 2/5*picture_size*sagittal_int/coronal_int]),
%     imagesc(N,[1,2]);
%     roi = MultiROI(N,rectangle.n);

    figure('name','rectangle','position',[550,50,picture_size,2/5*picture_size*sagittal_int/coronal_int]),
    imagesc(c_len,r_len,N,[N_min,N_max]);
%     imagesc(N);
    impixelinfo;
    xlabel('Coronal Position [mm]','FontSize',16);
    ylabel('Sagittal Position [mm]','FontSize',16);
    title('Refractive Index','FontSize',20);
    [c_dis,r_dis] = meshgrid(c_len,r_len);

    rectangle.Mask = ((c_dis - rectangle.position(1))<=rectangle.coronal) & ((c_dis - rectangle.position(1))>=0) &...
                     ((r_dis - rectangle.position(2))<=rectangle.sagittal) & ((r_dis - rectangle.position(2))>=0);
    hold on;
    contour(c_len, r_len, rectangle.Mask, [1 1], 'r-', 'LineWidth', 2);
    ROI_data = N(rectangle.Mask);
    ROI_data(ROI_data==0) = [];
    rectangle.mean = mean(ROI_data);
    rectangle.std = std(ROI_data);
    
    disp('Output the aveage value of rectangle: ');
    disp(rectangle.mean)
    disp('Output the standard deviation of rectangle: ');
    disp(rectangle.std)
end
    hold off;
% %% 绘制地势图
% N = flipud(N);                            % 将N值列元素反转
% N_S = smoothn(N,10);
% figure,set(gcf,'position',[100 100 1400 700]);
% surf(c_len,r_len,N_S,'EdgeColor','none');
% zlim([1.4,2]);
% colorbar;
% caxis([1 2]);
% view([-50 74]);
% xlabel('Coronal Position [mm]','FontSize',16);
% ylabel('Sagittal Position [mm]','FontSize',16);
% zlabel('Refractive index','FontSize',16);
% title('关于切片折射率的表面图','FontSize',20);



