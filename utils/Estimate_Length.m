function LEN = Estimate_Length(input_img, angle)
% 倒谱法估计模糊长度

% 中值滤波去噪
input_img = medfilt2(abs(input_img));

% 先进行FFT变换
fft_img = fft2(input_img);

% 对数变换
log_fft_img = abs(log(1 + abs(fft_img)));

% 倒谱计算
cep_img = ifft2(log_fft_img);

% 旋转图像以便检测模糊长度
rot_cep_img = imrotate(cep_img, -angle);


% 计算列平均值
for i=1:size(rot_cep_img, 2)
    avg(i) = 0;
    for j=1:size(rot_cep_img, 1)
        avg(i) = avg(i) + rot_cep_img(j, i);
    end
    avg(i) = avg(i)/size(rot_cep_img, 1);
end
avgr = real(avg);%获得实部

% 通过查找第一个负值确定模糊长度
index = 0;
for i = 1:round(size(avg,2)),
    if real(avg(i))<0,
        index = i;
        break;
    end
end

%plot(avgr)

% 如果索引不为零则返回索引为模糊长度
if index~=0,
    LEN = index;
else
    % 否则查找最小值作为模糊长度
    index = 1;
    startval = avgr(index);
    for i = 1 : round(size(avg, 2)/2),
        if startval>avgr(i),
            startval = avgr(i);
            index = i;
        end
    end

    LEN = index;
end
