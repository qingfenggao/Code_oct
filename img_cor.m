% 用于校正图像误差的函数
% img     为校正前的图像数据；
% img_cor 为校正后的图像数据；
% 分别对各列数据减去所对应的纠正值,再抛弃最后的30个点,实际上各列从在z(i)+2点处开始取值，各列都取470个值
% 2D  100
% 4D  200
% 6D  300
% 8D  400
% 每次采集数据后，必须测试校正值

function[img_cor] = img_cor(img,flag)
  [~,m] = size(img);
  load correct_7D_20171114
for i = 1:m
    img_cor(:,i) = img(z_correct(i)+2:471+z_correct(i),i);
end
if flag == 1
    figure('name','图像校正'),
    imshow(img_cor);

    title('校正后的图像')
    axis on;
%     figure('name','图像校正，用于paper'),
%     imshow(img_cor(300:450,:),[100 255]);colorbar;  % 用于paper
else 
    return
end

end