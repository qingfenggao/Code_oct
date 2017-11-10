% for thinning edge and edge msut be a pixel
% the median value will be the actual value of lines
% the superficial pixel will be available
% only the first six value will be available in a column
% every column will just be a singal pixel

function row_val = thin_edge(input_img)

[r_d,c_d] = size(input_img);
row_ele = zeros(15,c_d);           % pre-distribution memory
for j = 1:c_d                       % column

    flag = 1;
    for i = 1:r_d                   % row      
        if flag==1
            if input_img(i,j)
                row_ele(flag,j)= i;
                flag = flag+1;
            end
        else
            D = row_ele(flag-1,j);
            if (input_img(i,j)==1)&&((i - D)<=6)&&(flag<=15)
                row_ele(flag,j)= i;
                flag = flag+1;
            end
        end
    end
end
% get median value
for j = 1:c_d
    a = row_ele(:,j);
    a(a==0) = [];
    row_val(j) = median(a);
end
