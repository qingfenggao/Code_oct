% 本脚本的目的寻找正确的矫正值

% % 金属板线的矫正,第一帧的情况
% % 2D  100
% % 4D  200
% % 6D  300
% % 7D  ?
% % 8D  400


clear; close all; clc;
path_name = 'D:\Documents\optical coherence tomography\Data\OCT-Data\Data_3D\Data_20170824\D8_e';  %%% 设置数据路径
addpath(path_name);                                      % 添加数据文件%%%%%% correct value
I = imread('2.bmp');                                    %% I为为参考帧
imshow(I);axis on;
% figure,imshow(I(250:450,:),[100 255]); colorbar;        % 获取弯曲的反射基板面
cor = 10;
% [I] = img_cor(I,1);                               %%% 图像校正
for i = 1:1000
    line = I(cor:500,i);                        % 对反射板线加平滑
    [~,surface(1,i)] = max(line);
end

surface_pro = surface + (cor-1)*ones(1,1000);   % get the position of surface
min_val = min(surface_pro);
z_new = surface_pro - min_val*ones(1,1000);     % be attention to modificating the name in saving
z_correct = z_new;
save correct_7D_20170824_z5 z_correct          %%%


load('correct_7D');        
z_7D = z_correct;
figure,
x = 1:1000;
plot(x,z_7D,x,z_new);       
legend('z 7D','z new','Location','Northeast');             %%%
%%%%%%%%%%%%%%%%% use for paper,creat a calibration profile line  %%%%%%%%%%%%%%%
% coronal_int = 7.2/1000;        % mm unit,interval
% figure,
% plot(x*coronal_int,z_7D);
% xlabel('Distance of X axis  [mm]','FontSize',18);
% ylabel('Pixel Numbel of Calibration','FontSize',18);
% set(gca,'FontSize',14,'XTick',0:2:8,'YTick',0:5:25);   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('correct_7D_20170824_z1');             %%
z1 = z_correct;
load('correct_7D_20170824_z2');             %%
z2 = z_correct;
load('correct_7D_20170824_z3');             %%
z3 = z_correct;
load('correct_7D_20170824_z4');             %%
z4 = z_correct;
load('correct_7D_20170824_z5');             %%
z5 = z_correct;
z_correct = (z1+z2+z3+z4+z5)/5;
z_correct = round(z_correct);
figure,
x = 1:1000;
plot(x,z_7D,x,z_correct);         %%%
legend('z 7D','z new average','Location','Northeast'); 
save correct_7D_20170824 z_correct              %% rename!!!



%% 三维扫的校正
% 
% clear all; close all; clc; 
% path_name = 'D:\Administrator\optical coherence tomography\Data\Data_3D\Data_20161208\2016_12_08_10_1\';  %%% 设置数据路径
% addpath(path_name);                                       % 添加数据文件
% pic = dir([path_name,'*.bmp']);
% a = size(pic);
% num = a(1);
% num_f = 10;
% I1= imread('1.bmp');                                     % 读取第一帧
% [I1] = img_cor(I1,1);
% img_3D = I1;                                              % 赋值第一帧的数据
% for i=2:num                                              %%% 随起始帧的改变而改变
%      fname = sprintf('%d.bmp',i);
%      x=fname;
%      d= imread(x);
%      [d] = img_cor(d,0);
%      img_3D = cat(3,img_3D,d);                             %3维数据堆放在D中
% end  
% 
% for i = 1:num
%     line_f = img_3D(:,num_f,i);            % 对反射板线加平滑
%     [~,z1(i)] = max(line_f);
% end
% 
% save sagittal_10_1 z1                        %%%
% 
% load('sagittal_1_1');
% z_1_1 = z1;
% load('sagittal_24_1');
% z_24_1 = z1;
% load('sagittal_1_2');
% z_1_2 = z1;
% load('sagittal_10_1');
% z_10_1 = z1;
% figure,
% n = 1:400;
% plot(n,z_1_1,n,z_1_2,n,z_10_1,n,z_24_1)
% legend('z 1 1','z 1 2','z 10 1','z 24 1');



