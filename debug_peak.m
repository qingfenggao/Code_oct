% 上下边界都是使用峰值法，获得边界点；
% 下边界使用峰值法获得强边界的位置点，替换弱边界的位置

clear;clc;
close all;
% The algorithm parameters:
path_name = 'D:\Documents\optical coherence tomography\Data\OCT-Data\Data_3D\Data_20161222\1103_1_5\';  %%% 设置数据路径
addpath(path_name);  

% The algorithm parameters:
size_1 = 70;
size_2 = 100;                       %% setting ROI size of axial direction
num_f = 20;                         %%%% referece line numeber
r_val = 200;                        %% coordinate point,row
c_val = 500;                        %% column
bias = 10;                          %% colorbar bias value
frame_name = '178.bmp';             %% frame number
deeper_val = 3;
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
I = img(:,1:500);     %%%%%%%%%%% revise for paper

for TF = -5:1:5
    [~,cut_point(TF+6)] = max(I(:,num_f+TF));
end
cut_line2 = mode(cut_point) + deeper_val;             % get the cut_line2 position

cut_line1 = cut_line2 - size_1;
cut_line3 = cut_line2 + size_2 - 1;

IM_s = I(cut_line1:cut_line2-1,:);                    % get image data
IM_d = I(cut_line2:cut_line3,:);  
IM = [IM_s;IM_d];
figure('name','Original image','position',[300,700,1000,400]),imshow(IM,[]);axis on;axis normal;

I_size = size(I);
for pos_x = 1:(I_size(2)-4)
    [~,img_s(1,pos_x)] = max(IM_s(:,pos_x));  
end
for pos_x = 1:(I_size(2)-4)
    [~,img_d(1,pos_x)] = max(IM_d(:,pos_x));  
end
row_val_s = img_s;
row_val_d = img_d;                        %% 边界提取得到的每列边界位置
%% next

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
edge_point = [zeros(size(edge_point_s));edge_point_d];
edge_point = logical(edge_point);

% show the red edge condition
IM = IM(:,1:500);        %%%%%%%%%%%%%%%%%%%%%%
C=[1 0 0]; % 若设置边缘颜色为红色
r=im2double(IM);g=r;b=r;
r(edge_point)=C(1);g(edge_point)=C(2);b(edge_point)=C(3);
g3=cat(3,r,g,b);
figure('name','singal pixal point edge image','position',[300,1,1000,400]),imshow(g3);
% axis on;title(frame_name);

I_cut = zeros(size(IM));
r_edge = im2double(I_cut);g=r_edge;b=r_edge;
r_edge(edge_point)=C(1);g(edge_point)=C(2);b(edge_point)=C(3);
edges = cat(3,r_edge,g,b);
figure,imshow(edges);

row_val_d = row_val_d + size_1*ones(size(row_val_d));            % for glass
row_val = [row_val_s;row_val_d];

% calculate the optical distance of slice
Opt_dis = row_val_d - row_val_s;
figure('name','Optical Distance and Refrative Index'),
set(gcf,'position',[100 300 1400 500]);
subplot(121),plot(Opt_dis);title('Optical Distance','FontSize',16);
% calculate referctive index
z1 = mode(row_val_s(num_f-5:num_f+5));     % select mode value of num_f+_5
thickness = z1*ones(size(row_val_s))-row_val_s;
% thickness = thickness+5*ones(size(thickness));   % for correcting reference point
n = Opt_dis./thickness;
for i = 1:length(n)
    if (n(i)>=2)||(n(i)<=1)
        n(i) = 0;
    end
end
subplot(122),plot(n),ylim([1 2]);title('Refrative Index: n','FontSize',16);
