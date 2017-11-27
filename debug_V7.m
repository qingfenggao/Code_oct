% 上下边界都是使用峰值法，获得边界点；
% 下边界使用峰值法获得强边界的位置点，替换弱边界的位置
% 主要用与测量纵切牙片的折射率值
% revised by gao at 2017/11/14

clear;clc;
close all;
% The algorithm parameters:
path_name = 'D:\OCT_Sync\Data\OCT-Data\Data_3D\Data_20171114\ZL50_2\';  %%% 设置数据路径
addpath(path_name);  

% The algorithm parameters:
frame_name = '292.bmp';             %% frame number
num_f = 20;                         %% referece line numeber
extract =   3 ;                     %% correct value

r_val = 200;                        % coordinate point,row
c_val = 500;                        % column
bias = 10;                          % colorbar bias value
size_1 = 100;
size_2 = 90;                        % setting ROI size of axial directio
deeper_val = 2;                 
ref_Threshold = 100;                %% 对于强反射对参考点的判断有影响的情况，设置该值
coronal_int = 7.2/1000;             % mm unit,interval
sagittal_int = 10/400;              % mm unit
axial_int = 1.31/153;               % mm unit 由载玻片玻璃的厚度的计算而来

I = imread(frame_name);
I = img_cor(I,1);             %%%%%
% 对各条求均值线
for i = 3:998
    line_data(:,:,i-2) = I(:,i-2:i+2);    
    img(:,i-2) = sum(line_data(:,:,i-2),2)/5;
end
img = uint8(img);
figure,imshow(img);
I = img;     %%%%%%%%%%% revise for paper
I = padarray(I,[2 2],'replicate');   %为了计算边界上的点，要扩充一下

for TF = -5:1:5
    [~,cut_point(TF+6)] = max(I(:,num_f+TF));
end
% cut_line2 = mode(cut_point) + deeper_val;             % get the cut_line2 position
cut_line2 = mode(cut_point(cut_point>ref_Threshold)) + deeper_val;  % get the cut_line2 position

cut_line1 = cut_line2 - size_1;
cut_line3 = cut_line2 + size_2 - 1;

IM_s = I(cut_line1:cut_line2-1,:);                                  % get image data
IM_d = I(cut_line2:cut_line3,:);  
IM = [IM_s;IM_d];
figure('name','Original image','position',[300,700,1000,400]),imshow(IM,[]);axis on;axis normal;

I_size = size(I);
for pos_x = 1:I_size(2)
    [~,img_s(1,pos_x)] = max(IM_s(:,pos_x));  
end
for pos_x = 1:I_size(2)
    [~,img_d(1,pos_x)] = max(IM_d(:,pos_x));  
end
row_val_s = img_s;
row_val_d = img_d;                     %% 边界提取得到的每列边界位置
row_val_d(row_val_d<extract) = 0;      % 在下图中，去掉位置值小于extract的点
%% next

% get the singal point edge image
edge_point_s = zeros(size(IM_s));
edge_point_d = zeros(size(IM_d));
[r,c] = find(row_val_s(:,:)>=1);
for i = 1:length(r)
    r_val = row_val_s(r(i),c(i));
    r_val = floor(r_val);
    edge_point_s(r_val,c(i)) = 1;      % 边缘点的图片位置
end

[r,c] = find(row_val_d(:,:)>=1);
for i = 1:length(r)
    r_val = row_val_d(r(i),c(i));
    r_val = floor(r_val);
    edge_point_d(r_val,c(i)) = 1;      % 边缘点的图片位置
end
% edge_point = [zeros(size(edge_point_s));edge_point_d];  % 上面的图不需要边缘点的时候用该行
edge_point = [edge_point_s;edge_point_d];
edge_point = logical(edge_point);
figure('name','边缘二值图','position',[100 400 1400 400]),
subplot(2,1,1),imshow(edge_point_s);
subplot(2,1,2),imshow(edge_point_d);

% show the red edge condition
% IM = IM(:,1:500);        %%%%%%%%%%%%%%%%%%%%%%
C=[1 0 0];               % 若设置边缘颜色为红色
r=im2double(IM);g=r;b=r;
r(edge_point)=C(1);g(edge_point)=C(2);b(edge_point)=C(3);
g3=cat(3,r,g,b);
figure('name','singal pixal point edge image','position',[300,1,1000,400]),imshow(g3);
axis on;title(frame_name);

I_cut = zeros(size(IM));
r_edge = im2double(I_cut);g=r_edge;b=r_edge;
r_edge(edge_point)=C(1);g(edge_point)=C(2);b(edge_point)=C(3);
edges = cat(3,r_edge,g,b);
figure,imshow(edges);

row_val_d = row_val_d + size_1*ones(size(row_val_d));            % for glass
row_val = [row_val_s;row_val_d];

figure('name','Optical Distance and Refrative Index'),
set(gcf,'position',[100 100 1400 700]);
Opt_dis = row_val_d - row_val_s;         % optical distance value
subplot(311),plot((1:1000)*coronal_int,Opt_dis*axial_int),ylim([0.2 1]);xlabel('Distance of X axis [mm]','FontSize',16);ylabel('Optical Length [mm]','FontSize',16);

% calculate referctive index
z1 = mode(row_val_s(num_f-5:num_f+5));     % select mode value of num_f+_5
Thickness = z1*ones(size(row_val_s))-row_val_s;
n = Opt_dis./Thickness;
for i = 1:length(n)
    if (n(i)>=2)||(n(i)<=1)
        n(i) = NaN;
    end
end
subplot(312),plot((1:1000)*coronal_int,Thickness*axial_int),xlabel('Distance of X axis [mm]','FontSize',16);ylabel('Thickness [mm]','FontSize',16);
subplot(313),plot((1:1000)*coronal_int,n),ylim([1 2]);xlabel('Distance of X axis [mm]','FontSize',16);ylabel('Refractive Index','FontSize',16);

