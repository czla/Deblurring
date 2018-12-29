% @Description: The solution is to perform out-of-focus deblur. 
%   It uses Wiener filter algorithm to deblur.There are three main 
%   parameters:radius(i.e. the radius of Point-Spread-Function(PSF)),
%   smooth(smooth factor to control K) and dering('On' means do suppress 
%   ringing effect while other means do not.
% @Author: Chen Zhiliang
% @Student ID: 1830765
% @E-mail: zlchen@tongji.edu.cn
% @Date  : 2018/12/16

clc;clear;
close all;
warning off;

% for image1
% G = imread('Blurred_image1.jpg');
% radius = 27.3;  %radius of PSF
% smooth = 45;    %smooth factor, K = (1.09 ^ smooth) / 10000;
% dering = 'On';  %suppressing ring effect

% % for image2
G = imread('Blurred_image2.jpg');
radius = 15.4;  %radius of PSF
smooth = 50;    %smooth factor, K = (1.09 ^ smooth) / 10000;
dering = 'On';  %suppressing ring effect

F = OOF_deblur(G, radius, smooth, dering);

%save deblurred image
figure,imshow(cat(2,G,F)),title('Out-of-focus Deblur');
imwrite(F,['results\\Deblur_Ra' num2str(radius) 'Sm' num2str(smooth) '.png']);

function F = OOF_deblur(G, radius, smooth, dering)

    % perform in every channel
    if size(G, 3) == 3
        F = G;
        for c = 1 : 3
            F(:, :, c) = OOF_deblur(G(:, :, c), radius, smooth, dering);
        end
    else
        % generate PSF
        psf = zeros(size(G, 1), size(G, 2));
        [rows, cols] = size(psf);
        psf = insertShape(psf, 'FilledCircle', [(cols + 1)/ 2, (rows + 1)/ 2, radius], 'Color', 'white', 'Opacity', 1) * 255;      
        psf = psf(:, :, 1);
        psf = psf ./ sum(sum(psf));
        psf = fftshift(psf);
        
        psf_fft = fft2(psf);
        G_fft = fft2(G);
        
        % process the image to prevent ring effect
        if strcmp(dering, 'On')
            for i = 1 : rows
                for j = 1 : cols
                    G_fft(i, j) = G_fft(i, j) * real(psf_fft(i, j));
                end
            end

            tmp = real(ifft2(G_fft));
            for i = 1 : rows
                for j = 1 : cols
                    if (i < radius) || (j < radius) || (i > rows - radius) || (j > cols - radius)
                        G(i, j) = tmp(i, j);% / (rows * cols);
                    end
                end
            end
        end
        
        % wiener inverse filter
        G_fft= fft2(G);
        K = (1.09 ^ smooth) / 10000;
        for i = 1 : rows
            for j = 1 : cols
                energyValue = abs(psf_fft(i, j)) ^ 2;
                wienerValue = real(psf_fft(i, j)) / (energyValue + K);
                G_fft(i, j) = wienerValue * G_fft(i, j);
            end
        end
        F = uint8(real(ifft2(G_fft)));
    end
end