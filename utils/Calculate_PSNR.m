% func----calculate PSNR index of two image
% return:z is MSE,result is PSNR
function [result,z]=Calculate_PSNR(in1,in2)
z=mse(in1,in2);
result=10*log10(255.^2/z);

function z=mse(x,y)
x=double(x);
y=double(y);
[m,n]=size(y);
z=0;
for i=1:m
    for j=1:n
        z=z+(x(i,j)-y(i,j)).^2;
    end
end
z=z/(m*n);