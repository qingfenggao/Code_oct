% for get surface of slice of tooth
% version 1.0  written by gao at 2016/12/24

clear;close all;clc;tic;

% The algorithm parameters:
filename = '2016_10_20_C2_f_1';         %%%% set file name
coronal_int = 7.2/1000;            % mm unit,interval
sagittal_int = 10/400;             % mm unit
picture_size = 550;                % coronal direction length
path_name =['D:\Documents\optical coherence tomography\Data\Data_3D\Data_20161020\',filename,'\'];   % 设置数据路径
addpath(path_name);  
pic = dir([path_name,'*.bmp']);
a = size(pic);
num = a(1);

I1= imread('1.bmp');                                     % 读取第一帧
[I1] = img_cor(I1,0);
img_3D = I1;                                              % 赋值第一帧的数据
for i=2:num                                              %%% 随起始帧的改变而改变
     fname = sprintf('%d.bmp',i);
     x=fname;
     d= imread(x);
     [d] = img_cor(d,0);
     img_3D = cat(3,img_3D,d);                             % 3维数据堆放在D中
end  

for y = 1:400
    for x = 1:1000
        img_cc(y,x) = img_3D(60,x,y);
    end
end
figure,
imagesc(img_cc);
colormap(gray);title('C image')

for y = 1:400
   for x = 1:1000
       img_C(y,x) = max(img_3D(:,x,y));
   end
end

% figure('name','C_scan imshow image','position',[10,50,picture_size,2/5*picture_size*sagittal_int/coronal_int]),
% imshow(img_C,'border','tight','InitialMagnification','fit');
figure('name','C_scan image','position',[10,50,picture_size,2/5*picture_size*sagittal_int/coronal_int]),
imagesc(img_C);title('C_scan image');
colormap(gray);

% figure('name','medfilt2 image','position',[10,50,picture_size,2/5*picture_size*sagittal_int/coronal_int]),
% img_med = medfilt2(img_C,[3,3]);
% imagesc(img_med);title('medfilt image');
% colormap(gray);
% 
% figure('name','smooth image','position',[10,50,picture_size,2/5*picture_size*sagittal_int/coronal_int])
% img_smooth = smoothn(img_C);
% imagesc(img_smooth);title('smooth image');
% colormap(gray);



toc;
