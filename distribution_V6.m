% 抛弃之前的用均值来计算波峰的方法，直接用一条线的波峰点作为可用点
% 用于计算玻璃折射率而定制的
% version 6     written by gao at 2016/12/26

clear;close all;
clc;tic;
filename = 'L41_1';                 %%%% set file name
path_name =['D:\OCT_Sync\Data\OCT-Data\Data_3D\Data_20171114\',filename,'\'];   % 设置数据路径
addpath(path_name);  
pic = dir([path_name,'*.bmp']);

% The algorithm parameters:
extract =  2;                       %% correct value       
num_f = 10;                         %% referece line numeber

size_1 = 100;                       %
size_2 = 90;                        % setting ROI size of axial direction
r_val = 150;                        % coordinate point,row
c_val = 500;                        % column
bias = 20;                          % colorbar bias value
deeper_val = 3;
coronal_int = 7.2/1000;             % mm unit,interval
sagittal_int = 0.027645;            % mm unit
axial_int = 1.31/153;               % mm unit 由载玻片玻璃的厚度的计算而来

a = size(pic);
num = a(1);

I1= imread('1.bmp');                                      % 读取第一帧
[I1] = img_cor(I1,0);
img_3D = I1;                                              % 赋值第一帧的数据
for i=2:num                                               %%% 随起始帧的改变而改变
     fname = sprintf('%d.bmp',i);
     x=fname;
     d= imread(x);
     [d] = img_cor(d,0);
     img_3D = cat(3,img_3D,d);                         % 3维数据堆放在D中
end  

Opt_dis = zeros(400,1000);                                 % assign memory
z1 = zeros(1,400);                                         % assign memory
Thickness = Opt_dis;                                       % assign memory
for i = 1:num                                              % frame number
    
    for TF = -5:1:5
         [~,cut_point(TF+6)] = max(img_3D(:,num_f,i));
    end
    cut_line2 = mode(cut_point);                           % get the cut_line2 position
    cut_line2 = cut_line2 + deeper_val;
    cut_line1 = cut_line2 - size_1;
    cut_line3 = cut_line2 + size_2 - 1;
    
    I = img_3D(:,:,i);

    IM_s = I(cut_line1:cut_line2-1,:);                     % get image data
    IM_d = I(cut_line2:cut_line3,:);
    for pos_x = 1:1000
        [~,img_s(1,pos_x)] = max(IM_s(:,pos_x));
        [~,img_d(1,pos_x)] = max(IM_d(:,pos_x));
    end
 
    row_val_s = img_s;
    row_val_d = img_d;
    row_val_d = row_val_d + size_1*ones(size(row_val_d));           
    row_val = [row_val_s;row_val_d];

    Opt_dis(i,:)= row_val_d - row_val_s;                  % calculate the optical distance of slice
    

    z1(i) = mode(row_val_s(num_f-5:num_f+5));             % select mode value of num_f+_5,get the Z1 value 

    Thickness(i,:) = z1(i)*ones(1,1000) - row_val_s;      % calculate the thickness of Slice
    
end
Thickness(find(isnan(Thickness)==1)) = 0;                 % remove NaN values
Opt_dis(find(isnan(Opt_dis)==1)) = 0; 
% get optical distance of slice
figure('position',[100 100 1400 700]),
subplot(1,2,1),
imagesc(Opt_dis);
colorbar;
h = colorbar;
set(get(h,'Title'),'string','mm','FontSize',14); 
caxis([Opt_dis(r_val,c_val)-bias Opt_dis(r_val,c_val)+bias]);  % select midian value +- 10 as the color range
axis square;
xlabel('Coronal Position','FontSize',16);
ylabel('Sagittal Position','FontSize',16);
title('Optical Distance','FontSize',20);
Actual_Thickness = Thickness(r_val,c_val)*axial_int; % get actual thickness value

N = Opt_dis./Thickness;              % calculate referctive index
subplot(1,2,2),
imagesc(N);
colorbar;
axis image;
caxis([1 2]);
axis square;
xlabel('Coronal Position','FontSize',16);
ylabel('Sagittal Position','FontSize',16);
title('Refractive Index','FontSize',20);

annotation('textbox',[0.01 0.01 0.3 0.05],'string',{...
   ['Num f=',num2str(num_f),';  Size 1=',num2str(size_1),';  Size 2=',num2str(size_2),...
    ';  R val=',num2str(r_val),';  C val=',num2str(c_val),';  Bias=',num2str(bias)]},...
    'FitBoxToText','on','EdgeColor','none','FontSize',12);
annotation('textbox',[0.01 0.05 0.3 0.05],...
    'String',{['Actual Thickness(mm)：',num2str(Actual_Thickness)]},...
    'FitBoxToText','on','FontSize',14,'EdgeColor','none');

% saveas(gcf,['MethodOfFindPeaks\',[filename,'.fig']]);            %% 
% save(['MethodOfFindPeaks\',filename,'.mat'],'N');                %%



Elapsed_time=toc;
Elapsed_time = Elapsed_time/60;
fprintf('Elapsed_time = %.5fmin\n',Elapsed_time);

