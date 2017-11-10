% 下边界使用峰值法获得强边界的位置点，替换弱边界的位置
clear;clc;close all;
% The algorithm parameters:
path_name = 'D:\OCT_Sync\Data\OCT-Data\Data_3D\Data_20171102\47_1';  %%% 设置数据路径
addpath(path_name);  

k = 2;                         %% 调节强边缘比例，该值越大，边界点越多  
ThresholdRatio = 0.4;          %% 弱边缘阈值相对于强边缘阈值的比重
frame_name = '189.bmp';         %% frame number
extract =   10 ;                %% correct value
extract_pro = extract + 0;
c_l = 185;
c_r = 370;
num_f = 10;                    %% correct line position
ref_Threshold = 100;           %% 对于强反射对参考点的判断有影响的情况，设置该值
size_1 = 150;
size_2 = 100;                  %% setting ROI size of row direction
deeper_val = 3;                % 参考点位置再向下移
thresh=[ ];                    % 设置像素灰度低阈值和高阈值

coronal_int = 7.2/1000;        % mm unit,interval
sagittal_int = 0.027645;       % mm unit
axial_int = 1.31/153;          % mm unit  replace 4.7/500

I = imread(frame_name);
I = img_cor(I,1);             %%%%%
for TF = -5:1:5
    [~,cut_point(TF+6)] = max(I(:,num_f+TF));
end
cut_line2 = mode(cut_point(cut_point>ref_Threshold)) + deeper_val;             % get the cut_line2 position

cut_line1 = cut_line2 - size_1;
cut_line3 = cut_line2 + size_2 - 1;

IM_s = I(cut_line1:cut_line2-1,:);                    % get image data
IM_d = I(cut_line2:cut_line3,:);  
IM = [IM_s;IM_d];
dim = size(IM);
figure('name','Original image','position',[300,500,1000,300]),
imagesc((1:dim(2))*coronal_int,(1:dim(1))*axial_int,IM);
colormap('gray');colorbar;
% axis normal;
xlabel('unit [cm]','FontSize',14);ylabel('unit [cm]','FontSize',14);

% img_s = canny_s_pro(IM_s,k,thresh,ThresholdRatio,extract,extract_pro,c_l,c_r,1);          % superficial image
for pos_x = 1:1000
    [~,img_s(1,pos_x)] = max(IM_s(:,pos_x));  
end
img_d = canny_s_pro(IM_d,k,thresh,ThresholdRatio,extract,extract_pro,c_l,c_r,1); 

%% next
row_val_s = img_s;
row_val_d = thin_edge(img_d);                        %% 边界提取得到的每列边界位置

% get the singal point edge image
edge_point_s = zeros(size(IM_s));
edge_point_d = zeros(size(IM_d));
[r,c] = find(row_val_s(:,:)>=1);
for i = 1:length(r)
    r_val = row_val_s(r(i),c(i));
    r_val = floor(r_val);
    edge_point_s(r_val,c(i)) = 1;
end

[r,c] = find(row_val_d(:,:)>=1);
for i = 1:length(r)
    r_val = row_val_d(r(i),c(i));
    r_val = floor(r_val);
    edge_point_d(r_val,c(i)) = 1;
end
edge_point = [edge_point_s;edge_point_d];
edge_point = logical(edge_point);

% show the red edge condition
C=[1 0 0]; % 若设置边缘颜色为红色
r=im2double(IM);g=r;b=r;
r(edge_point)=C(1);g(edge_point)=C(2);b(edge_point)=C(3);
g3=cat(3,r,g,b);
figure('name','singal pixal point edge image','position',[300,1,1000,400]),imshow(g3);
title(frame_name);axis on;
% colorbar;

I_cut = zeros(size(IM));
r_edge = im2double(I_cut);g=r_edge;b=r_edge;
r_edge(edge_point)=C(1);g(edge_point)=C(2);b(edge_point)=C(3);
edges = cat(3,r_edge,g,b);
% figure('name','Edge Image'),imshow(edges);             % show edge image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
row_val_d = row_val_d + size_1*ones(size(row_val_d));            % for glass
% row_val_d = row_val_d + (size_r/2)*ones(size(row_val_d));
row_val = [row_val_s;row_val_d];

% calculate the optical distance of slice
Opt_length = row_val_d - row_val_s;
% Opt_dis = Opt_dis - 2*ones(size(Opt_dis));
% 
figure('name','Optical Distance and Refrative Index'),
set(gcf,'position',[100 100 1400 700]);
subplot(311),plot((1:1000)*coronal_int,Opt_length*axial_int),ylim([0.2 1]);xlabel('Distance of X axis [mm]','FontSize',16);ylabel('Optical Length [mm]','FontSize',16);

% calculate referctive index
z1 = mode(row_val_s(num_f-5:num_f+5));     % select mode value of num_f+_5
Thickness = z1*ones(size(row_val_s))-row_val_s;
% thickness = thickness+5*ones(size(thickness));   % for correcting reference point
n = Opt_length./Thickness;
for i = 1:length(n)
    if (n(i)>=2)||(n(i)<=1)
        n(i) = NaN;
    end
end
subplot(312),plot((1:1000)*coronal_int,Thickness*axial_int),xlabel('Distance of X axis [mm]','FontSize',16);ylabel('Thickness [mm]','FontSize',16);
subplot(313),plot((1:1000)*coronal_int,n),ylim([1 2]);xlabel('Distance of X axis [mm]','FontSize',16);ylabel('Refractive Index','FontSize',16);



%%%%%%%%% produce OCT signal profile line %%%%%%%%%%%%%%%%%%%
% IM_new = IM(26:250,:);
% line_ref = IM_new(:,38);
% line_sample = IM_new(:,456);
% [m,n] = size(IM_new);
% figure('position',[200,200,1300,500]),
% plot((1:m)*axial_int,line_ref,(1:m)*axial_int,line_sample,'--');
% xlabel('Depth of Z axis [mm]','FontSize',16);
% ylabel('Signal Amplitude','FontSize',16);
% h = legend('Referential Line','Sample Line');
% set(h,'FontSize',15,'EdgeColor',[1 1 1]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% n(find(isnan(n))) = [];
% n(find(n == 0)) = [];
% n_mean = mean(n);
% fprintf('%20s\t %10.3f\t %10.3f\t %10.3f\n','n_mean = ',n_mean);
% disp(fprintf('%20s\t %10.3f\t %10.3f\t %10.3f\t','n_mean = ',n_mean));

