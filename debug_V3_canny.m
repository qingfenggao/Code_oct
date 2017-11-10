% include canny function script
% build based on debug_V3

% 下边界使用峰值法获得强边界的位置点，替换弱边界的位置
clear;clc;close all;
% The algorithm parameters:
path_name = 'D:\Documents\optical coherence tomography\Data\OCT-Data\Data_3D\Data_20161222\1103_1_5\';  %%% 设置数据路径
addpath(path_name);  

k = 2;                         %% 调节强边缘比例，该值越大，边界点越多  
ThresholdRatio = 0.6;          %% 弱边缘阈值相对于强边缘阈值的比重
frame_name = '178.bmp';          %% frame number
extract =  10 ;                %% correct value
extract_pro = extract + 0;
c_l = 185;
c_r = 370;
num_f = 20;                    %% correct line position
ref_Threshold = 100;           %% 对于强反射对参考点的判断有影响的情况，设置该值
size_1 = 150;
size_2 = 100;                  %% setting ROI size of row direction
deeper_val = 3;                % 参考点位置再向下移
thresh=[ ];                    % 设置像素灰度低阈值和高阈值

coronal_int = 7.2/1000;        % mm unit,interval
sagittal_int = 10/400;         % mm unit
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
% img_d = canny_s_pro(IM_d,k,thresh,ThresholdRatio,extract,extract_pro,c_l,c_r,1); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Algorithm for detecting the edge of horizontal diretion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IM_function = IM_d;          %%
cor_1 = extract;
cor_2 = extract_pro;
imaging = 1;

% figure,imshow(IM_function);colorbar;
[m,n]=size(IM_function);
IM_function=double(IM_function);

% The algorithm parameters:
% 1. Parameters of edge detecting filters:
Ng = 10;Sigma = 2;
%高斯卷积核
w=d2dgauss(Ng,Sigma,Ng,Sigma,0);

img=conv2(IM_function,w,'same'); 
img = abs(img);

% X-axis direction edge detection
figure,
filterx=d2dgauss(Ng,Sigma,Ng,Sigma,90);
Ix= conv2(IM_function,filterx,'same');
imshow(Ix,[]);colorbar;
title('Ix');

% Y-axis direction edge detection
figure,
filtery=d2dgauss(Ng,Sigma,Ng,Sigma,0);
Iy=conv2(IM_function,filtery,'same'); 
imshow(abs(Iy),[]);colorbar;
title('Iy');

% Norm of the gradient (Combining the X and Y directional derivatives)
figure,
NVI=sqrt(Ix.*Ix+Iy.*Iy);
imshow(NVI,[]);colorbar;
title('Norm of Gradient');

% img = NVI;
img = Iy;
% figure,imshow(IM_function,[]);colorbar;
figure('name','new'),imshow(abs(img/(max(max(img)))),[]);colorbar;
%%%%%%%%%%%%%%%%%%%%
img_c = zeros(m,n);
for j = 1:n
    img_c(:,j) = img(:,j)./max(img(:,j));    % 对各列进行归一化
end                                   
img = img_c;
figure,imshow(abs(img),[]);colorbar;
%%%%%%%%%%%%%%%%%%%%
PercentOfPixelsNotEdges = 1-k*(m+n)/(m*n); %0.995，非边缘的比例

if isempty(thresh)                         %通过直方图自动计算高低阈值大小
    counts=imhist(img, 256);
    highThresh = find(cumsum(counts) > PercentOfPixelsNotEdges*m*n,1,'first') / 256; %PercentOfPixelsNotEdges=0.8，即不是边界的比例
    lowThresh = ThresholdRatio*highThresh;
    thresh = [lowThresh highThresh];
elseif length(thresh)==1
    highThresh = thresh;
    if thresh>=1
        error(message('images:edge:thresholdMustBeLessThanOne'))
    end
    lowThresh = ThresholdRatio*thresh;
    thresh = [lowThresh highThresh];
elseif length(thresh)==2
    lowThresh = thresh(1);
    highThresh = thresh(2);
    if (lowThresh >= highThresh) || (highThresh >= 1)
        error(message('images:edge:thresholdOutOfRange'))
    end
end
%%下面是非极大值抑制
weak_edge2=zeros(m+2,n+2);
img_h2 = padarray(img,[1 1],'replicate');   %为了计算边界上的点，要扩充一下
for i=2:m+1                                 % 图像边缘的像素不能计算
    for j=2:n+1

        if img_h2(i,j)<=lowThresh
            M1=2;
            M2=2;                          %这时检测点肯定是不大于1的，故isbigger=0
        else
            g1=img_h2(i-1,j);              %g1是检测点正上方一行
            g3=img_h2(i+1,j);              %g3是检测点正下方一行
            M1=g1;                         %M1是上方的插值
            M2=g3;                         %M2是下方的插值
        end
        %此处选择与经典canny不同，考虑到噪声干扰，为了找到“双线边缘”，假定误差不超过0.9的都同为最大值,也可根据加入噪声水平确定该值
        isbigger=(img_h2(i,j)>=(0.8*M1))&&(img_h2(i,j)>=(0.8*M2)); %如果当前点比两边点都大，则置为白色 
        if isbigger
           weak_edge2(i,j)=255;  
        end        
   end
end
weak_edge=weak_edge2(2:m+1,2:n+1);

[rstrong,cstrong] = find(img>highThresh & weak_edge);
strong_edge=zeros(m,n);
for i=1:length(rstrong)
    r=rstrong(i);
    c=cstrong(i);
    strong_edge(r,c)=weak_edge(r,c);
end
se=strel('square',4);                               % 先膨胀，在腐蚀   闭运算
strong_edge=imclose(strong_edge,se);
se=strel('line',3,0);
strong_edge=imopen(strong_edge,se);                 % 先腐蚀，再膨胀   开运算

% 形态学处理
[rstrong,cstrong] = find(strong_edge); 
edge = bwselect(weak_edge, cstrong, rstrong, 8);
% correct the useless values
edge(1:cor_1,:) = 0;                        % extract the superficical error line
edge(1:cor_2,c_l:c_r) = 0;
if imaging
    figure,imshow(edge),title('deeper edge image'),axis on;
    figure,imshow(edge);colorbar;
end
img_d = edge;                                 %%%%% get edge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
figure('name','singal pixal point edge image','position',[300,1,1000,400]),imshow(g3);title(frame_name);
% colorbar;

I_cut = zeros(size(IM));
r_edge = im2double(I_cut);g=r_edge;b=r_edge;
r_edge(edge_point)=C(1);g(edge_point)=C(2);b(edge_point)=C(3);
edges = cat(3,r_edge,g,b);
figure,imshow(edges);             % show edge image




