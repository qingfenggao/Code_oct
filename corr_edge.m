% 使用互相给找到下边界点位置
clear;close all;clc;
% The algorithm parameters:
path_name = 'D:\Documents\optical coherence tomography\Data\OCT-Data\Data_3D\Data_20161208\2016_12_08_6_3\';  %%% 设置数据路径
addpath(path_name);  

k = 1;                       %% 调节强边缘比例，该值越大，边界点越多  
ThresholdRatio = 0.4;        %% 弱边缘阈值相对于强边缘阈值的比重
frame_name = '45.bmp';       %% frame number
extract = 15;                %% correct value
extract_pro = extract + 0;
c_l = 240;
c_r = 350;
num_f = 40;                  %% correct line position
size_r = 180;                %% setting ROI size of row direction
deeper_val = 3;              % 参考点位置再向下移

thresh=[ ];                  % 设置像素灰度低阈值和高阈值
axial_int = 4.7/500;         % mm unit
I = imread(frame_name);
I = img_cor(I,0);
for TF = -5:1:5
    [~,cut_point(TF+6)] = max(I(:,num_f+TF));
end
cut_line2 = mode(cut_point) + deeper_val;             % get the cut_line2 position
cut_line1 = cut_line2 - size_r/2;
cut_line3 = cut_line2 + size_r/2 - 1;

IM_s = I(cut_line1:cut_line2-1,:);                    % get image data
IM_d = I(cut_line2:cut_line3,:);  
IM = [IM_s;IM_d];
figure('name','Original image'),imshow(IM);axis on;

% img_s = canny(IM_s,k_s,thresh,ThresholdRatio1,1);         % superficial image
for pos_x = 1:1000
    [~,img_s(1,pos_x)] = max(IM_s(:,pos_x));  
end

img_d = canny_s_pro(IM_d,k,thresh,ThresholdRatio,extract,extract_pro,c_l,c_r,1); 

row_val_s = img_s;
row_val_d = thin_edge(img_d);                            %% 边界提取得到的每列边界位置
row_val_d = row_val_d + (size_r/2)*ones(size(row_val_d));

%% cross-correlation section/portion
IM_Dim = size(IM);
axial = 1:IM_Dim(1);
coronal = 1:IM_Dim(2);
[coronal,axial] = meshgrid(coronal,axial);
axial_pro = 1:0.2:IM_Dim(1)+0.2*4;
coronal_pro = 1:IM_Dim(2);
[coronal_pro,axial_pro] = meshgrid(coronal_pro,axial_pro);
IM = double(IM);
IM_interp = interp2(coronal,axial,IM,coronal_pro,axial_pro);      % 轴向做了5倍的插值

[~,cut_point] = max(IM_interp(:,num_f));
window_size = 50;

R_threshold = 0.8;
for i = 1:IM_Dim(2)
    peak1 = row_val_s(i)*5;
    [~,peak2_position] = max(IM_interp(peak1+window_size:IM_Dim(1)*5,i));
    peak2 = peak2_position + peak1+window_size;
    array1 = IM_interp(peak1-window_size:peak1+window_size,i);
    array2 = IM_interp(peak2-window_size:peak2+window_size,i);
    S = corrcoef(array1,array2);
    R(i) = S(1,2);
    if R(i)>=R_threshold
        peak_value(i) = peak2;
    else
        peak_value(i) = 0;
    end
end



% 
% 
% num1 = 220;                                               %%%%% set the line num you need observe
% num2 = 260;                                               %%%%% set the line num you need observe
% num3 = 740;                                               %%%%% set the line num you need observe
% num4 = 850;                                               %%%%% set the line num you need observe
% 
% figure('name','original','position',[10,50,1580,770]),
% subplot(3,4,1),plot(IM(:,num1)),title(['第',num2str(num1),'条线，无平滑,sample,bottom'])
% subplot(3,4,5),plot(smoothn(IM(:,num1))),title(['第',num2str(num1),'条线，平滑默认,sample,bottom'])
% subplot(3,4,9),plot(smoothn(IM(:,num1),100)),title(['第',num2str(num1),'条线，平滑度100,sample,bottom'])
% 
% subplot(3,4,2),plot(IM(:,num2)),title(['第',num2str(num2),'条线，无平滑,sample,bottom'])
% subplot(3,4,6),plot(smoothn(IM(:,num2))),title(['第',num2str(num2),'条线，平滑默认,sample,bottom'])
% subplot(3,4,10),plot(smoothn(IM(:,num2),100)),title(['第',num2str(num2),'条线，平滑度100,sample,bottom'])
% 
% subplot(3,4,3),plot(IM(:,num3)),title(['第',num2str(num3),'条线，无平滑,sample,bottom'])
% subplot(3,4,7),plot(smoothn(IM(:,num3))),title(['第',num2str(num3),'条线，平滑默认,sample,bottom'])
% subplot(3,4,11),plot(smoothn(IM(:,num3),100)),title(['第',num2str(num3),'条线，平滑度100,sample,bottom'])
% 
% subplot(3,4,4),plot(IM(:,num4)),title(['第',num2str(num4),'条线，无平滑,sample,bottom'])
% subplot(3,4,8),plot(smoothn(IM(:,num4))),title(['第',num2str(num4),'条线，平滑默认,sample,bottom'])
% subplot(3,4,12),plot(smoothn(IM(:,num4),100)),title(['第',num2str(num4),'条线，平滑度100,sample,bottom'])
% % 


