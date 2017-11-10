% Algrorith for detecting the edge of horizontal diretion
%    The algorithm parameters:
%    k = 3                    % 调节强边缘比例，该值越大，边界点越多
%    thresh=[ ];              % 设置像素灰度低阈值和高阈值
%    ThresholdRatio = 0.4     % 强弱边缘的比例
%    cor_d = 1;               % the first cor_d rows will be setted to zero

function edge = canny_s_pro(IM,k,thresh,ThresholdRatio,cor_1,cor_2,c_l,c_r,imaging)
[m,n]=size(IM);
IM=double(IM);
% The algorithm parameters:
% 1. Parameters of edge detecting filters:
Ng = 10;Sigma = 2;
%高斯卷积核
w=d2dgauss(Ng,Sigma,Ng,Sigma,0);

img=conv2(IM,w,'same'); 
img = abs(img);
img_c = zeros(m,n);
for j = 1:n
    img_c(:,j) = img(:,j)./max(img(:,j));    % 对各列进行归一化
end                                   
img = img_c;
% figure,imshow(img);title('归一化');

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
se=strel('square',4);                               % 膨胀
strong_edge=imclose(strong_edge,se);
se=strel('line',3,0);
strong_edge=imopen(strong_edge,se);                 % 腐蚀

% 形态学处理
[rstrong,cstrong] = find(strong_edge); 
edge = bwselect(weak_edge, cstrong, rstrong, 8);
%% correct the useless values
edge(1:cor_1,:) = 0;                        % extract the superficical error line
edge(1:cor_2,c_l:c_r) = 0;
if imaging
    figure('name','deeper edge image'),imshow(edge),title('deeper edge image'),axis on;
end