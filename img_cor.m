% ����У��ͼ�����ĺ���
% img     ΪУ��ǰ��ͼ�����ݣ�
% img_cor ΪУ�����ͼ�����ݣ�
% �ֱ�Ը������ݼ�ȥ����Ӧ�ľ���ֵ,����������30����,ʵ���ϸ��д���z(i)+2�㴦��ʼȡֵ�����ж�ȡ470��ֵ
% 2D  100
% 4D  200
% 6D  300
% 8D  400
% ÿ�βɼ����ݺ󣬱������У��ֵ

function[img_cor] = img_cor(img,flag)
  [~,m] = size(img);
  load correct_7D_20171114
for i = 1:m
    img_cor(:,i) = img(z_correct(i)+2:471+z_correct(i),i);
end
if flag == 1
    figure('name','ͼ��У��'),
    imshow(img_cor);

    title('У�����ͼ��')
    axis on;
%     figure('name','ͼ��У��������paper'),
%     imshow(img_cor(300:450,:),[100 255]);colorbar;  % ����paper
else 
    return
end

end