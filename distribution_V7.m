% 在一张图中，对5条均值先求出各点；
% 使用波峰法求上下边界位置，主要考虑用去纵切样品；
% built by gao at 2017/11/14

clear;close all;
clc;tic;

filename = 'ZL50_2';                              %%%% set file name
prepath = '健康样品\纵切样品\';                    %%%% set path name for saving
path_name =['D:\OCT_Sync\Data\OCT-Data\Data_3D\Data_20171114\',filename,'\'];   %%% 设置读取数据路径
addpath(path_name);  
pic = dir([path_name,'*.bmp']);

% The algorithm parameters:
num_f = 10;                         %% referece line numeber
extract =   3 ;                     %% 在下图中，把上面的边缘的去除

deeper_val = 2;
ref_Threshold = 100;                % 对于强反射对参考点的判断有影响的情况，设置该值
r_val = 200;                        % coordinate point,row
c_val = 500;                        % column
bias = 20;                          % colorbar bias value, uint pixel
size_1 = 100;                       %
size_2 = 90;                        % setting ROI size of axial direction
coronal_int = 7.2/1000;             % mm unit,interval
sagittal_int = 0.027645;            % mm unit
axial_int = 1.31/153;               % mm unit 由载玻片玻璃的厚度的计算而来
picture_size = 550;
a = size(pic);
num = a(1);

I1 = imread('1.bmp');                                     % 读取第一帧
[I1] = img_cor(I1,0);
img_3D = I1;                                              % 赋值第一帧的数据
for i = 2:num 
    fname = sprintf('%d.bmp',i);
    d = imread(fname);
    [d] = img_cor(d,0);
    img_3D = cat(3,img_3D,d);                           % 该循环获取了所有的三维数据
end
img_3Dpad = padarray(img_3D,[1,1,1],'replicate');       % img_3Dpad(:,x,y)
img_3Dpad = double(img_3Dpad);
img_3Dpad_test = img_3Dpad(1,:,:);                      % observe a certain frame
Size3D = size(img_3Dpad);
img_ave = zeros(Size3D(1),Size3D(2)-2,Size3D(3)-2);
for posX = 2:Size3D(2)-1
    for posY = 2:Size3D(3)-1
        img_sum = zeros(Size3D(1),1,1);
        for i = -1:1
            for j = -1:1
                img_sum(:,1,1) = img_sum(:,1,1) + img_3Dpad(:,posX+i,posY+j);
            end
        end
        img_ave(:,posX-1,posY-1) = img_sum(:,1,1)/9;
    end
end     

%% get C_scan  
r_num = Size3D(3)-2;                 % 400
c_num = Size3D(2)-2;                 %1000
img_C = zeros(r_num,c_num);
for xx = 1:c_num                     % 1000
   for yy = 1:r_num                  % 400
       img_C(yy,xx) = max(img_ave(:,xx,yy));
   end
end
r_len = (1:r_num)*sagittal_int;
c_len = (1:c_num)*coronal_int;
w=fspecial('gaussian',[9 9]);
img_C=imfilter(img_C,w,'replicate');           % 添加高斯滤波
figure('name','C_scan image','position',[100 100 600 700]),
imagesc(c_len,r_len,img_C);axis image;
colormap(gray);colorbar;
xlabel('Distance of X axis [mm]','FontSize',16);ylabel('Distance of Y axis [mm]','FontSize',16);
saveas(gcf,[prepath,[filename,'Surface','.fig']]);   

%% calculate refrative index
Opt_dis = zeros(r_num,c_num);                              % assign memory
Thickness = Opt_dis;                                       % assign memory
z1 = zeros(1,r_num);                                       % assign memory
img_s = zeros(1,c_num);                                    % assign memory
img_d = img_s;                                             % assign memory
for i = 1:num                                              % frame number
    
    for TF = -5:1:5
         [~,cut_point(TF+6)] = max(img_ave(:,num_f,i));
    end
    cut_line2 = mode(cut_point);                           % get the cut_line2 position
    cut_line2 = cut_line2 + deeper_val;
    cut_line1 = cut_line2 - size_1;
    cut_line3 = cut_line2 + size_2 - 1;
    
    I = img_ave(:,:,i);

    IM_s = I(cut_line1:cut_line2-1,:);                     % get image data
    IM_d = I(cut_line2:cut_line3,:);
    for pos_x = 1:c_num
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
set(get(h,'Title'),'string','pixel number','FontSize',14); 
caxis([Opt_dis(r_val,c_val)-bias Opt_dis(r_val,c_val)+bias]);  % select midian value +- 10 as the color range
xlabel('Coronal Position','FontSize',16);
ylabel('Sagittal Position','FontSize',16);
title('Optical Distance','FontSize',20);
Actual_Thickness = Thickness(r_val,c_val)*axial_int; % get actual thickness value

N = Opt_dis./Thickness;              % calculate referctive index
subplot(1,2,2),imagesc(N);
colorbar;caxis([1 2]);
xlabel('Coronal Position','FontSize',16);
ylabel('Sagittal Position','FontSize',16);
title('Refractive Index','FontSize',20);

annotation('textbox',[0.01 0.0 0.3 0.05],'string',{...
   ['Num f=',num2str(num_f),';  Extract=',num2str(extract),';  ref Threshold=',num2str(ref_Threshold),...
    ';  R val=',num2str(r_val),';  C val=',num2str(c_val),';  Bias=',num2str(bias)]},...
    'FitBoxToText','on','EdgeColor','none','FontSize',12);
annotation('textbox',[0.01 0.03 0.3 0.05],...
    'String',{['Actual Thickness(mm)：',num2str(Actual_Thickness)]},...
    'FitBoxToText','on','FontSize',14,'EdgeColor','none');

saveas(gcf,[prepath,[filename,'.fig']]);            
save([prepath,filename,'.mat'],'N');       % save .mat file and figures
%% time used
Elapsed_time=toc;
Elapsed_time = Elapsed_time/60;
fprintf('Elapsed_time = %.5f min\n',Elapsed_time);
