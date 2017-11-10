% Algrorith for detecting the edge of horizontal diretion
%    The algorithm parameters:
%    k = 3                    % ����ǿ��Ե��������ֵԽ�󣬱߽��Խ��
%    thresh=[ ];              % �������ػҶȵ���ֵ�͸���ֵ
%    ThresholdRatio = 0.4     % ǿ����Ե�ı���
%    cor_d = 1;               % the first cor_d rows will be setted to zero

function edge = canny_s_pro(IM,k,thresh,ThresholdRatio,cor_1,cor_2,c_l,c_r,imaging)
[m,n]=size(IM);
IM=double(IM);
% The algorithm parameters:
% 1. Parameters of edge detecting filters:
Ng = 10;Sigma = 2;
%��˹�����
w=d2dgauss(Ng,Sigma,Ng,Sigma,0);

img=conv2(IM,w,'same'); 
img = abs(img);
img_c = zeros(m,n);
for j = 1:n
    img_c(:,j) = img(:,j)./max(img(:,j));    % �Ը��н��й�һ��
end                                   
img = img_c;
% figure,imshow(img);title('��һ��');

PercentOfPixelsNotEdges = 1-k*(m+n)/(m*n); %0.995���Ǳ�Ե�ı���

if isempty(thresh)                         %ͨ��ֱ��ͼ�Զ�����ߵ���ֵ��С
    counts=imhist(img, 256);
    highThresh = find(cumsum(counts) > PercentOfPixelsNotEdges*m*n,1,'first') / 256; %PercentOfPixelsNotEdges=0.8�������Ǳ߽�ı���
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
%%�����ǷǼ���ֵ����
weak_edge2=zeros(m+2,n+2);
img_h2 = padarray(img,[1 1],'replicate');   %Ϊ�˼���߽��ϵĵ㣬Ҫ����һ��
for i=2:m+1                                 % ͼ���Ե�����ز��ܼ���
    for j=2:n+1

        if img_h2(i,j)<=lowThresh
            M1=2;
            M2=2;                          %��ʱ����϶��ǲ�����1�ģ���isbigger=0
        else
            g1=img_h2(i-1,j);              %g1�Ǽ������Ϸ�һ��
            g3=img_h2(i+1,j);              %g3�Ǽ������·�һ��
            M1=g1;                         %M1���Ϸ��Ĳ�ֵ
            M2=g3;                         %M2���·��Ĳ�ֵ
        end
        %�˴�ѡ���뾭��canny��ͬ�����ǵ��������ţ�Ϊ���ҵ���˫�߱�Ե�����ٶ�������0.9�Ķ�ͬΪ���ֵ,Ҳ�ɸ��ݼ�������ˮƽȷ����ֵ
        isbigger=(img_h2(i,j)>=(0.8*M1))&&(img_h2(i,j)>=(0.8*M2)); %�����ǰ������ߵ㶼������Ϊ��ɫ 
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
se=strel('square',4);                               % ����
strong_edge=imclose(strong_edge,se);
se=strel('line',3,0);
strong_edge=imopen(strong_edge,se);                 % ��ʴ

% ��̬ѧ����
[rstrong,cstrong] = find(strong_edge); 
edge = bwselect(weak_edge, cstrong, rstrong, 8);
%% correct the useless values
edge(1:cor_1,:) = 0;                        % extract the superficical error line
edge(1:cor_2,c_l:c_r) = 0;
if imaging
    figure('name','deeper edge image'),imshow(edge),title('deeper edge image'),axis on;
end