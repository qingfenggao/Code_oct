% % 读取多张图片,制作短视频
% 
% clear all; close all; clc;
% path_name = 'D:\Gao\OCT\Data of OCT\Data_20161103\2016_11_03_1_5\';  %%% 设置数据路径
% addpath(path_name);                                       % 添加数据文件
% pic = dir([path_name,'*.bmp']);
% % a = size(pic);
% % num = a(1);
% figure('name','Original Image'),imshow('100.bmp'),colormap(gray(256)),axis on,title('Original Image');
% row_num = 201:400;
% frame_init = 201;
% frame_final = 300;
% 
% for i=frame_init:frame_final 
%     im(:,:,:,i)=imread(strcat(num2str(i),'.bmp')); 
%     imshow(im(row_num,:,:,i)) 
%     M(i-frame_init+1) = getframe; 
% end 
% 
% movie2avi(M,'20161103_1_5_1.avi','FPS',20)              %%%%输出视频

%% 简单的3D成像
% 
% clear all;close all;clc;tic;                          %释放参数
% path_name = 'D:\Gao\OCT\Data of OCT\Data_20161103\2016_11_03_1_5_s\';  %%% 设置数据路径
% addpath(path_name);                                       % 添加数据文件
% pic = dir([path_name,'*.bmp']);
% a = size(pic);
% num = a(1);                                      %图片数量
% D = imread('400.bmp');                          %%% set a certain frame
% [D] = img_cor(D,0);                             % correct the frame
% figure,
% for i=num:-1:1                                 %%% 随起始帧的改变而改变
%      fname = sprintf('%d.bmp',i);
%      x=fname;
%      d= imread(x);
%      [d] = img_cor(d,0);
%      D = cat(3,D,d);                             %3维数据堆放在D中
% end                                              %用for循环读入所有的bmp信息，用cat函数进行三维数组排列
% D = D(:,:,:);                            %%%%%选取一定区域的数据,先确定多少行，再确定多少列
% D = squeeze(D);
% [x,y,z,D] = reducevolume(D,[1 1 1]);             %可按4 4 1抽取，减少数据量，当为1 1 1 取值时，那么不改变数据量
% D = smooth3(D);                                  % 对数据进行平滑处理
% p = patch(isosurface(x,y,z,D, 5,'verbose'), ...
% 'FaceColor', 'none', 'EdgeColor', 'none');     %patch创建块对象
% p2 = patch(isocaps(x,y,z,D, 5), 'FaceColor', 'interp', 'EdgeColor','none');
% % view(-24.5,-20);
% view(0,0);                                    % show the image of x-z axis
% axis tight; 
% daspect([1 1 .4])                                %X,Y,Z轴显示比例
% colormap(gray(255))
% camlight; lighting none                       %定义光照等
% time = toc;
% time = time/60;

%% produce a background picture

% 
% clear all;close all;clc;
% I = imread('Galaxy.jpg');
% I = rgb2gray(I);
% Back_pic = zeros(size(I));
% Dim = size(I);
% Dim = Dim/2;
% size_r = 200;
% size_c = size_r*0.8;
% 
% for r = Dim(1)-size_r/2:Dim(1)+size_r/2
%     for c = Dim(2)-size_c/2:Dim(2)+size_c/2
%         Back_pic(r,c) = 1;
%     end
% end
% figure('position',[0,0,Dim(2),Dim(1)]),
% imshow(Back_pic,'border','tight','InitialMagnification','fit')
% % 'border','tight'的组合功能意思是去掉图像周边空白
% % 'InitialMagnification','fit'组合的意思是图像填充整个figure窗口);
% axis normal;
% % imwrite(Back_pic,'background','jpg');


%% 计算图像横向的实际距离

% clear all;close all;clc;
% I = imread('PIN2.bmp');
% I_gray = rgb2gray(I);
% Dim = size(I_gray);
% figure('position',[300,200,Dim(2),Dim(1)]),
% imshow(I_gray,'border','tight','InitialMagnification','fit');
% % saveas(gcf,'gray.bmp')
% % saveas(gcf,'gray','bmp')
% % axis normal;
% % axis on;
% % save data to a file of txt filetype
% data = I_gray(:,1);
% fid = fopen('test.txt','wt');
% fprintf(fid,'%g\n',data);

%%
% clear;
% 
% coronal_int = 7.2/1000;            % mm unit,interval
% sagittal_int = 10/400;             % mm unit
% axial_int = 1.31/153;               % mm unit  replace 4.7/500
% picture_size = 550;                % coronal direction length
% N_max = 2;
% N_min = 1;
% r_num = 400;
% c_num = 1000;
% r_len = (1:r_num)*sagittal_int;
% c_len = (1:c_num)*coronal_int;
% 
% filename = '1103_1_5';
% open(['1222\',filename,'Surface.fig']); 
% h = get(gca,'children');
% data_D = get(h,'Cdata');
% w=fspecial('gaussian',[9 9]);
% data_D=imfilter(data_D,w,'replicate');
% figure('name','Circles','position',[550,50,picture_size,2/5*picture_size*sagittal_int/coronal_int]),
% imagesc(c_len,r_len,data_D);colormap('gray');
% [c_dis,r_dis] = meshgrid(c_len,r_len);
% 
% BW1 = edge(data_D,'canny',[0.2 0.4]);
% figure,imshow(BW1);
% 
% imshow(PIN2)

%%  尝试对图像加上伪彩
% clear;clc;
% close all;
% % The algorithm parameters:
% path_name = 'D:\Documents\optical coherence tomography\Data\Data_3D\Data_20161020\2016_10_20_C3_f_1\';  %%% 设置数据路径
% addpath(path_name);  
% frame_name = '128.bmp';        %% frame number
% I = imread(frame_name);
% I = img_cor(I,1);              %%%%%
% title(frame_name);
% colormap('hot');
% 
% 
% % w4 = fspecial('laplacian',0);
% % w8 = [1,1,1;1,-8,1;1,1,1];
% % w1 = [0,1,0;0,-4,0;0,1,1];
% % w2 = [0,0,0;1,-4,1;0,0,0];
% % I = im2double(I);
% % g1 = I - imfilter(I,w1,'replicate');
% % g2 = I - imfilter(I,w2,'replicate');
% % % g8 = I - imfilter(I,w8,'replicate');
% % figure,imshow(g1,[]);title('上下为1');
% % figure,imshow(g2,[]);title('左右为1');
% % % subplot(122),imshow(g8);title('g8');
% % 
% % [X,map] = imread('corn.tif');
% % figure,imshow(X,map);
% % figure,imshow(img_C,map);
% % figure,imagesc(img_C);
% % figure,imshow(I,map);title('上下为1');axis on;
% 
% % I1 = gpuArray(reshape(uint8(linspace(1,255,25)),[5 5]));
% % I2 = im2double(I1);

% %%  为丁医生获得不同厚度OCT图像
% clear;clc;
% close all;
% % The algorithm parameters:
% path_name = 'D:\Documents\optical coherence tomography\Data\Data_3D\Data_20170425\';  %%% 设置数据路径
% addpath(path_name);  
% frame_name = 'A_pingxing.png';        %% frame number
% coronal_int = 7.2/1000;             % mm unit,interval
% sagittal_int = 10/400;              % mm unit
% axial_int = 1.31/153;               % mm unit 由载玻片玻璃的厚度的计算而来
% 
% I = imread(frame_name);
% I = rgb2gray(I);
% % figure,imshow(I);
% r_num = 470;
% c_num = 1000;
% r_len = (1:r_num)*axial_int;
% c_len = (1:c_num)*coronal_int;
% figure('position',[10,50,c_num*1.5,r_num*1.5]);
% imagesc(c_len,r_len,I);
% colormap('gray');axis image;
% set(gca,'FontSize',14);
% title('Original image');
% xlabel('unit [mm]');
% ylabel('unit [mm]');
% % use medfilt
% medfilt2_I = medfilt2(I,[3,3]);
% figure('name','medfilt image','position',[10,50,c_num*1.5,r_num*1.5]),
% imagesc(c_len,r_len,medfilt2_I);colormap('gray');title('after medfilt');axis image;
% 
% % 锐化
% ima = double(I);
% h1=fspecial('gaussian',[9 9]); %gaussian低通滤波器锐化
% bw6 = imfilter(ima,h1);
% figure('position',[10,50,c_num*1.5,r_num*1.5]);
% imagesc(c_len,r_len,uint8(bw6));colormap('gray');axis image;title('gaussian低通滤波器锐化');
% 
% h2=fspecial('laplacian');%laplacian算子锐化
% bw7 = imfilter(ima,h2);
% figure('position',[10,50,c_num*1.5,r_num*1.5]);
% imagesc(c_len,r_len,uint8(bw7));colormap('gray');axis image;title('laplacian算子锐化');

% % From Internet
% bw1 = edge(ima,'sobel'); %sobel算子锐化
% figure;subplot(121);imshow(uint8(ima));title('原始图像');%图像显示
% subplot(122);imshow(bw1);title('sobel算子锐化');
% 
% bw2 = edge(ima,'prewitt');%prewitt算子锐化
% figure;subplot(121);imshow(uint8(ima));title('原始图像');
% subplot(122);imshow(bw2);title('prewitt算子锐化');
% 
% bw3 = edge(ima,'roberts');%roberts算子锐化
% figure;subplot(121);imshow(uint8(ima));title('原始图像');
% subplot(122);imshow(bw3);title('roberts算子锐化');
% 
% bw4 = edge(ima,'log');%log算子锐化
% figure;subplot(121);imshow(uint8(ima));title('原始图像');
% subplot(122);imshow(bw4);title('log算子锐化');
% 
% bw5 = edge(ima,'canny');        % canny算子锐化
% figure;subplot(121);imshow(uint8(ima));title('原始图像');
% subplot(122);imshow(bw5);title('canny算子锐化');

% 程序代写&算法设计,联系qq:380238062，转载时请保留
% h1=fspecial('gaussian',[9 9]);%gaussian低通滤波器锐化
% bw6 = imfilter(ima,h1);
% figure;subplot(211);imshow(uint8(ima));title('原始图像');
% subplot(212);imshow(uint8(bw6));title('gaussian低通滤波器锐化');
% 
% h2=fspecial('laplacian');%laplacian算子锐化
% bw7 = imfilter(ima,h1);
% figure;subplot(211);imshow(uint8(ima));title('原始图像');
% subplot(212);imshow(uint8(bw7));title('laplacian算子锐化');

% %% From web:http://blog.sina.com.cn/s/blog_775d556901012dco.html
% a=ima;
% %(1)
% figure;
% subplot(1,3,1);imshow(a);title('input image');
% h1 = fspecial('sobel');
% MotionBlur1 = imfilter(a,h1);
% subplot(1,3,2);imshow(MotionBlur1);title('sobel-Motion Blurred Image         ');
% h2 = fspecial('Laplacia',0);
% MotionBlur2 = imfilter(a,h2);
% subplot(1,3,3);imshow(MotionBlur2);title('Laplacia-Motion Blurred Image');
% %(2)
% figure('name','直接输入算子锐化处理','NumberTitle','Off');
% subplot(1,3,1);imshow(a);title('input image');
% dx=[-1 -2 -1;0 0 0;1 2 1];
% dy=[-1 0 1;-2 0 2;-1 0 1];
% d=(dx.^2+dy.^2).^0.5;
% MotionBlur3= imfilter(a,d);
% subplot(1,3,2);imshow(MotionBlur3);title('sobel-direct input-Motion Blurred Image          ');
% l=[0 -1 0;-1 4 -1;0 -1 0];
% MotionBlur4 = imfilter(a,l);
% subplot(1,3,3);imshow(MotionBlur4);title('Laplacia-direct input-Motion Blurred Image');
%  
% %3
%  a=ima;
% figure;
% %(1);
% subplot(1,3,1);imshow(a);title('input image');
% L=[-1 -1 -1;-1 8 -1;-1 -1 -1];
% MotionBlur1 = imfilter(a,L);
% subplot(1,3,2);imshow(MotionBlur1);title('对角线Laplacian算子');
% %(2)
% MotionBlur2=MotionBlur1+a;
% subplot(1,3,3);imshow(MotionBlur2);title('叠加后图形');
% %(3)
% figure;
% subplot(2,3,1);imshow(a);title('input image');
% h1 = fspecial('sobel');
% h2 = imfilter(a,h1);
% subplot(2,3,2);imshow(h2);title('sobel-Motion Blurred Image         ');
% MotionBlur3=imfilter(h2,[5 5]);
% subplot(2,3,3);imshow(MotionBlur3);title('sobel-领域平均 ');
% %(4,5,6)
% MotionBlur4 = imsubtract(MotionBlur2,h2);
% subplot(2,3,4);imshow(MotionBlur4);title('相乘图象 ');
%  
% MotionBlur5=MotionBlur4+a;
% subplot(2,3,5);imshow(MotionBlur5);title('与原始图叠加后图形');
%  
% MotionBlur6=imadjust(MotionBlur5,[],[],0.2);
% subplot(2,3,6);imshow(MotionBlur6);title('幂指数为0.2的灰度变换');
% %4
% a1=ima;
% f=double(a1);
% [m,n]=size(f);
% for i=1:m
%    for j=1:n
%         if i==m
%            G(i,j)=G(i-1,j) ;
%         elseif j==n
%            G(i,j)=G(i,j-1);
%        else  
%         G(i,j)=abs(f(i,j)-f(i+1,j+1))+abs(f(i+1,j)-f(i,j+1));
%        end  
%    end
% end
% Z=f;
% figure;
% for i=4:8
%     k=find(G>=i);Z(k)=255;
%     q=find(G<i);Z(q)=0;
%         subplot(2,3,1);imshow(a);title('input image');
%         subplot(2,3,i-2);imshow(Z);title(['门限T为',num2str(i)]);
% end;


%% add a function in the script
% a = 1;
% b = 2;
% C = add_Function(a,b);
% 
% function Result = add_Function(M,N)
%     Result = M + N;
% end

% %% 加载N数据，生成折射率图像
% clear; close all; clc;
% 
% filename = '47_1';                       %% input file name
% prepath = '龋坏样品\纵切样品\';            %% 
% % open([prepath,filename,'Surface.fig']);      %% input the file name which is needed to proceed
% load([prepath,filename,'.mat'])           %% care the pathway
% picture_size = 550;                       % coronal direction length
% coronal_int = 7.2/1000;                      % mm unit,interval
% sagittal_int = 0.027645;                     % mm unit
% axial_int = 1.31/153;                        % mm unit  4.7/500 is replaced
% [r_num,c_num]=size(N);
% r_len = (1:r_num)*sagittal_int;
% c_len = (1:c_num)*coronal_int;
% 
% N_max = 2;
% N_min = 1;
% N(find(isnan(N)==1)) = 0;
% N(find(N<=N_min)) = 0;                       % removing some unexpect data range (N_min,N_max)
% N(find(N>=N_max)) = 0;
% N = medfilt2(N,[3,3]);                       % use median fiter
% 
% figure('name','Results','position',[800,50,picture_size,2/5*picture_size*sagittal_int/coronal_int-100]),
% imagesc(c_len,r_len,N,[1,2]);axis image;
% impixelinfo;colorbar;
% xlabel('Distance of X axis [mm]','FontSize',16);
% ylabel('Distance of Y axis [mm]','FontSize',16);











