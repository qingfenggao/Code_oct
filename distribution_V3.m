% calculate the distribution of a slice
% use a method of pictures processing(edge detection)
% using find peak edge in the superfical image，下边界修正的高亮的边界的定位的bug
% version 3.0  written by gao at 2016/12/10

clear;clc;tic;
close all;
filename = 'L42_1';                              %%%% set file name
prepath = '健康样品\纵切样品\';                   %%%% set path name for saving
path_name =['D:\OCT_Sync\Data\OCT-Data\Data_3D\Data_20171102\',filename,'\'];   %%% 设置读取数据路径
addpath(path_name);  
pic = dir([path_name,'*.bmp']);

% The algorithm parameters:
k = 2;                               %% 调节下图强边缘比例，该值越大，边界点越多       
ThresholdRatio = 0.4;                %% 强弱边缘的比例
extract =   10   ;                   %% 除去下图上面几行的1值
extract_pro = extract + 0;
c_l = 320;                          % set the range for correcting
c_r = 500;                          % set the range for correcting
num_f = 10;                         %%% referece line numeber
ref_Threshold = 300;                %% 对于强反射对参考点的判断有影响的情况，设置该值
size_1 = 100;                       %% surficial ROI size of axial direction
size_2 = 90;                        %% setting ROI size of axial direction
r_val = 200;                        %% coordinate point,row
c_val = 500;                        %% column
bias = 0.2;                         %% colorbar bias value

deeper_val = 3;
thresh=[ ];                         % 设置像素灰度低阈值和高阈值
coronal_int = 7.2/1000;             % mm unit,interval
sagittal_int = 0.027645;              % mm unit
axial_int = 1.31/153;               % mm unit 由载玻片玻璃的厚度的计算而来
picture_size = 550;

a = size(pic);
num = a(1);

I1= imread('1.bmp');                                      % 读取第一帧
[I1] = img_cor(I1,0);
img_3D = I1;                                              % 赋值第一帧的数据
for i=2:num                                               % 随起始帧的改变而改变
     fname = sprintf('%d.bmp',i); 
     x=fname;
     d= imread(x);
     [d] = img_cor(d,0);
     img_3D = cat(3,img_3D,d);                             % 3维数据堆放在D中
end  
for y = 1:400
   for x = 1:1000
       img_C(y,x) = max(img_3D(:,x,y));
   end
end
r_num = 400;
c_num = 1000;
r_len = (1:r_num)*sagittal_int;
c_len = (1:c_num)*coronal_int;
w=fspecial('gaussian',[9 9]);
img_C=imfilter(img_C,w,'replicate');           % 添加高斯滤波
figure('name','C_scan image','position',[100 100 600 700]),
imagesc(c_len,r_len,img_C);axis image;
% impixelinfo;
colormap(gray);colorbar;
xlabel('Distance of X axis [mm]','FontSize',16);ylabel('Distance of Y axis [mm]','FontSize',16);
% title('Gray Image of Surface','FontSize',18);
saveas(gcf,[prepath,[filename,'Surface','.fig']]);   

Opt_dis = zeros(400,1000);                                 % assign memory
z1 = zeros(1,400);                                         % assign memory
Thickness = Opt_dis;                                       % assign memory
for i = 1:num                            % frame number
    
    for TF = -5:1:5
         [~,cut_point(TF+6)] = max(img_3D(:,num_f+TF,i));
    end
    cut_line2 = mode(cut_point(cut_point>ref_Threshold)) + deeper_val;             % get the cut_line2 position
    cut_line1 = cut_line2 - size_1;
    cut_line3 = cut_line2 + size_2 - 1;
    
    I = img_3D(:,:,i);

    IM_s = I(cut_line1:cut_line2-1,:);                      % get image data
    IM_d = I(cut_line2:cut_line3,:);
    for pos_x = 1:1000
        [~,img_s(1,pos_x)] = max(IM_s(:,pos_x));
    end
%     img_d = canny_s(IM_d,k,thresh,ThresholdRatio,extract,0);           % deep image and a morphological process
    img_d = canny_s_pro(IM_d,k,thresh,ThresholdRatio,extract,extract_pro,c_l,c_r,0);
    row_val_s = img_s;
%     row_val_s = thin_edge(img_s);
    row_val_d = thin_edge(img_d);
%     row_val_d = thin_edge_cor(img_d,cor_p,diff_line_length);
%     row_val_d = row_val_d + (size_r/2)*ones(size(row_val_d));
    row_val_d = row_val_d + size_1*ones(size(row_val_d));            % for glass
    row_val = [row_val_s;row_val_d];
    % calculate the optical distance of slice
    Opt_dis(i,:)= row_val_d - row_val_s;
    
    % calculate the Z1 value
    z1(i) = mode(row_val_s(num_f-5:num_f+5));     % select mode value of num_f+_5

    Thickness(i,:) = z1(i)*ones(1,1000) - row_val_s;    % calculate the thickness of Slice
    
end
Thickness(find(isnan(Thickness)==1)) = 0;         % remove NaN values
Opt_dis(find(isnan(Opt_dis)==1)) = 0; 
Opt_thi = Opt_dis*axial_int;
% get optical distance of slice
figure,
set(gcf,'position',[100 100 1400 700]);
subplot(1,2,1),
imagesc(Opt_thi);colorbar;
% impixelinfo;
h = colorbar;set(get(h,'Title'),'string','mm','FontSize',14);
caxis([Opt_thi(r_val,c_val)-bias Opt_thi(r_val,c_val)+bias]);  % select midian value +- 10 as the color range
% axis square;
xlabel('Coronal Position','FontSize',16);
ylabel('Sagittal Position','FontSize',16);
title('Optical Distance','FontSize',20);
Actual_Thickness = Thickness(r_val,c_val)*axial_int; % get actual thickness value

% calculate referctive index
N = Opt_dis./Thickness;
subplot(1,2,2),
imagesc(N);colorbar;
% impixelinfo;
caxis([1 2]);
xlabel('Coronal Position','FontSize',16);
ylabel('Sagittal Position','FontSize',16);
title('Refractive Index','FontSize',20);

annotation('textbox',[0.01 0.0 0.3 0.05],'string',{...
   ['K=',num2str(k),';  ThresholdRatio=',num2str(ThresholdRatio),';  Extract=',num2str(extract),...
    ';  Extract pro=',num2str(extract_pro),';  C l=',num2str(c_l),';  C r=',num2str(c_r),...
    ';  Num f=',num2str(num_f),';  Size 1=',num2str(size_1),';  Size 2=',num2str(size_2),...
    ';  R val=',num2str(r_val),';  C val=',num2str(c_val),';  Bias=',num2str(bias)]},...
    'FitBoxToText','on','EdgeColor','none','FontSize',12);
annotation('textbox',[0.01 0.03 0.3 0.05],...
    'String',{['Actual Thickness(mm)：',num2str(Actual_Thickness)]},...
    'FitBoxToText','on','FontSize',14,'EdgeColor','none');

saveas(gcf,[prepath,[filename,'.fig']]);            
save([prepath,filename,'.mat'],'N');               

Elapsed_time=toc;
% Elapsed_time = Elapsed_time/60;
fprintf('Elapsed_time = %.5fs\n',Elapsed_time);

