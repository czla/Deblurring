% @Description: The solution to perform motion deblur. 
%   It uses Lucy-Richardson algorithm to estimate
%   Point-Spread-Function(PSF).There are three main parameters:len(i.e.
%   blur length),theta(blur angle) and IterNum(number of iteration times).
% @Author: Chen Zhiliang
% @Student ID: 1830765
% @E-mail: zlchen@tongji.edu.cn
% @Date  : 2018/12/16

clc;clear;
close all;
warning off;

% read image
orig_img = imread('Blurred_image3.jpg');

% parameter setting
len = 60;       %motion blur length(pixels)
theta = 315;    %motion blur angle(0 ~ 360)
IterNum = 25;   %total iteration numbers(when sets larger, it performs better basically but takes more time).

% perform motion deblur in every channel
% for c = 1 : 3
%     lucy(:, :, c) = deblur(orig_img(:, :, c), len, theta, IterNum);
% end

% perform motion deblur in grayscale
lucy = deblur(orig_img(:, :, 1), len, theta, IterNum);

%save deblurred image
figure,imshow(cat(2,orig_img(:,:,1),lucy)),title('Motion Deblur');
imwrite(lucy,['results\\Deblur3_' num2str(len) '_' num2str(theta) '_' num2str(IterNum) '.png']);

function lucy = deblur(orig_img, len, theta, IterNum)

    % make sure input is gray image
    if size(orig_img, 3) == 3
        orig_img = orig_img(:,:,1);
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----This code block is to estimate motion length and angle if don't know.---%
%-----If you set parameters correctly above, ignore this code block.----------%
%     % Fast-fourier-transform
%     % fft_img = abs(fft2(orig_img));
% 
%     % log transform
%     % log_fft_img=log(1+fft_img);
%     % log_fft_img=fftshift(log_fft_img);
%     % 
%     % calculate cepstrum
%     % cep_img=ifft2(log_fft_img);
%     % cep_img=ifftshift(cep_img);
%     % figure,imshow(exp(abs((cep_img))),[]),title('cepstrum')
% 
%     % extrate edge of cepstrum
%     % input_img = (100*abs(cep_img));
%     % figure,imshow(input_img),title('cepstrum edge');
% 
%     % blur a clear image manually
%     % PSF = fspecial('motion',len,theta);
%     % blurred_img = imfilter(orig_img,PSF,'circular','conv');
%     % img=double(blurred_img);
%     % imwrite(blurred_img,['Blur3_' num2str(len) '_' num2str(theta) '.png'])
% 
%     % estimate motion angle
%     % est_ang = Estimate_Angle(orig_img);
% 
%     % estimate motion length                                                  % 
%     % est_len = Estimate_Length(orig_img,est_ang);                            % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % calculate PSF and sovle image degration problem
    % est_psf = fspecial('motion',est_len,est_ang);
    est_psf = fspecial('motion',len,theta);
    figure,imshow(est_psf,[]),title('Estimated PSF');

    % suppressing ring effect 
    orig_img = edgetaper(orig_img, est_psf);

    % perform motion deblur
    lucy = deconvlucy(orig_img,est_psf,IterNum);
    
    % calculate PNSR index
    % [before_psnr,mes]=Calculate_PSNR(orig_img,blurred_img);
    % [after_psnr,mes]=Calculate_PSNR(orig_img,lucy);
end