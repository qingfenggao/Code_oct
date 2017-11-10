% % ��ȡ����ͼƬ,��������Ƶ
% 
% clear all; close all; clc;
% path_name = 'D:\Gao\OCT\Data of OCT\Data_20161103\2016_11_03_1_5\';  %%% ��������·��
% addpath(path_name);                                       % ��������ļ�
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
% movie2avi(M,'20161103_1_5_1.avi','FPS',20)              %%%%�����Ƶ

%% �򵥵�3D����
% 
% clear all;close all;clc;tic;                          %�ͷŲ���
% path_name = 'D:\Gao\OCT\Data of OCT\Data_20161103\2016_11_03_1_5_s\';  %%% ��������·��
% addpath(path_name);                                       % ��������ļ�
% pic = dir([path_name,'*.bmp']);
% a = size(pic);
% num = a(1);                                      %ͼƬ����
% D = imread('400.bmp');                          %%% set a certain frame
% [D] = img_cor(D,0);                             % correct the frame
% figure,
% for i=num:-1:1                                 %%% ����ʼ֡�ĸı���ı�
%      fname = sprintf('%d.bmp',i);
%      x=fname;
%      d= imread(x);
%      [d] = img_cor(d,0);
%      D = cat(3,D,d);                             %3ά���ݶѷ���D��
% end                                              %��forѭ���������е�bmp��Ϣ����cat����������ά��������
% D = D(:,:,:);                            %%%%%ѡȡһ�����������,��ȷ�������У���ȷ��������
% D = squeeze(D);
% [x,y,z,D] = reducevolume(D,[1 1 1]);             %�ɰ�4 4 1��ȡ����������������Ϊ1 1 1 ȡֵʱ����ô���ı�������
% D = smooth3(D);                                  % �����ݽ���ƽ������
% p = patch(isosurface(x,y,z,D, 5,'verbose'), ...
% 'FaceColor', 'none', 'EdgeColor', 'none');     %patch���������
% p2 = patch(isocaps(x,y,z,D, 5), 'FaceColor', 'interp', 'EdgeColor','none');
% % view(-24.5,-20);
% view(0,0);                                    % show the image of x-z axis
% axis tight; 
% daspect([1 1 .4])                                %X,Y,Z����ʾ����
% colormap(gray(255))
% camlight; lighting none                       %������յ�
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
% % 'border','tight'����Ϲ�����˼��ȥ��ͼ���ܱ߿հ�
% % 'InitialMagnification','fit'��ϵ���˼��ͼ���������figure����);
% axis normal;
% % imwrite(Back_pic,'background','jpg');


%% ����ͼ������ʵ�ʾ���

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

%%  ���Զ�ͼ�����α��
% clear;clc;
% close all;
% % The algorithm parameters:
% path_name = 'D:\Documents\optical coherence tomography\Data\Data_3D\Data_20161020\2016_10_20_C3_f_1\';  %%% ��������·��
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
% % figure,imshow(g1,[]);title('����Ϊ1');
% % figure,imshow(g2,[]);title('����Ϊ1');
% % % subplot(122),imshow(g8);title('g8');
% % 
% % [X,map] = imread('corn.tif');
% % figure,imshow(X,map);
% % figure,imshow(img_C,map);
% % figure,imagesc(img_C);
% % figure,imshow(I,map);title('����Ϊ1');axis on;
% 
% % I1 = gpuArray(reshape(uint8(linspace(1,255,25)),[5 5]));
% % I2 = im2double(I1);

% %%  Ϊ��ҽ����ò�ͬ���OCTͼ��
% clear;clc;
% close all;
% % The algorithm parameters:
% path_name = 'D:\Documents\optical coherence tomography\Data\Data_3D\Data_20170425\';  %%% ��������·��
% addpath(path_name);  
% frame_name = 'A_pingxing.png';        %% frame number
% coronal_int = 7.2/1000;             % mm unit,interval
% sagittal_int = 10/400;              % mm unit
% axial_int = 1.31/153;               % mm unit ���ز�Ƭ�����ĺ�ȵļ������
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
% % ��
% ima = double(I);
% h1=fspecial('gaussian',[9 9]); %gaussian��ͨ�˲�����
% bw6 = imfilter(ima,h1);
% figure('position',[10,50,c_num*1.5,r_num*1.5]);
% imagesc(c_len,r_len,uint8(bw6));colormap('gray');axis image;title('gaussian��ͨ�˲�����');
% 
% h2=fspecial('laplacian');%laplacian������
% bw7 = imfilter(ima,h2);
% figure('position',[10,50,c_num*1.5,r_num*1.5]);
% imagesc(c_len,r_len,uint8(bw7));colormap('gray');axis image;title('laplacian������');

% % From Internet
% bw1 = edge(ima,'sobel'); %sobel������
% figure;subplot(121);imshow(uint8(ima));title('ԭʼͼ��');%ͼ����ʾ
% subplot(122);imshow(bw1);title('sobel������');
% 
% bw2 = edge(ima,'prewitt');%prewitt������
% figure;subplot(121);imshow(uint8(ima));title('ԭʼͼ��');
% subplot(122);imshow(bw2);title('prewitt������');
% 
% bw3 = edge(ima,'roberts');%roberts������
% figure;subplot(121);imshow(uint8(ima));title('ԭʼͼ��');
% subplot(122);imshow(bw3);title('roberts������');
% 
% bw4 = edge(ima,'log');%log������
% figure;subplot(121);imshow(uint8(ima));title('ԭʼͼ��');
% subplot(122);imshow(bw4);title('log������');
% 
% bw5 = edge(ima,'canny');        % canny������
% figure;subplot(121);imshow(uint8(ima));title('ԭʼͼ��');
% subplot(122);imshow(bw5);title('canny������');

% �����д&�㷨���,��ϵqq:380238062��ת��ʱ�뱣��
% h1=fspecial('gaussian',[9 9]);%gaussian��ͨ�˲�����
% bw6 = imfilter(ima,h1);
% figure;subplot(211);imshow(uint8(ima));title('ԭʼͼ��');
% subplot(212);imshow(uint8(bw6));title('gaussian��ͨ�˲�����');
% 
% h2=fspecial('laplacian');%laplacian������
% bw7 = imfilter(ima,h1);
% figure;subplot(211);imshow(uint8(ima));title('ԭʼͼ��');
% subplot(212);imshow(uint8(bw7));title('laplacian������');

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
% figure('name','ֱ�����������񻯴���','NumberTitle','Off');
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
% subplot(1,3,2);imshow(MotionBlur1);title('�Խ���Laplacian����');
% %(2)
% MotionBlur2=MotionBlur1+a;
% subplot(1,3,3);imshow(MotionBlur2);title('���Ӻ�ͼ��');
% %(3)
% figure;
% subplot(2,3,1);imshow(a);title('input image');
% h1 = fspecial('sobel');
% h2 = imfilter(a,h1);
% subplot(2,3,2);imshow(h2);title('sobel-Motion Blurred Image         ');
% MotionBlur3=imfilter(h2,[5 5]);
% subplot(2,3,3);imshow(MotionBlur3);title('sobel-����ƽ�� ');
% %(4,5,6)
% MotionBlur4 = imsubtract(MotionBlur2,h2);
% subplot(2,3,4);imshow(MotionBlur4);title('���ͼ�� ');
%  
% MotionBlur5=MotionBlur4+a;
% subplot(2,3,5);imshow(MotionBlur5);title('��ԭʼͼ���Ӻ�ͼ��');
%  
% MotionBlur6=imadjust(MotionBlur5,[],[],0.2);
% subplot(2,3,6);imshow(MotionBlur6);title('��ָ��Ϊ0.2�ĻҶȱ任');
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
%         subplot(2,3,i-2);imshow(Z);title(['����TΪ',num2str(i)]);
% end;


%% add a function in the script
% a = 1;
% b = 2;
% C = add_Function(a,b);
% 
% function Result = add_Function(M,N)
%     Result = M + N;
% end

% %% ����N���ݣ�����������ͼ��
% clear; close all; clc;
% 
% filename = '47_1';                       %% input file name
% prepath = 'ȣ����Ʒ\������Ʒ\';            %% 
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











