% 读取图像文件并将其存储为矩阵的MATLAB脚本

% 清除工作区
clear;
clc;

% 读取图像文件
imageFileName = 'your_image_file.jpg'; % 替换为你的图像文件名
imageData = imread(imageFileName);

% 显示图像
figure;
imshow(imageData);
title('读取的图像');

% 将图像数据转换为矩阵
imageMatrix = double(imageData);

% 保存矩阵到文件
matrixFileName = 'image_matrix.mat'; % 替换为你希望保存的文件名
save(matrixFileName, 'imageMatrix');

% 提示保存成功
disp(['图像矩阵已保存到文件: ', matrixFileName]);
