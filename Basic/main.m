clear all;
clc;
%% The main program of the adaptive 2D MHM

% read the image
imgfile = ['..\images\'];
imgdir = dir([imgfile,'\*.bmp']);
fid = fopen('fileName.txt','wt');
data_n = length(imgdir); %测试数图像总数量

start = 1;%测试图像起始标记
data_n = start;%测试图像结尾标记

performance = zeros(length(imgdir)*2,100);
tic
for auxR = 800:50:800 % 预设边信息长度
for i_img = start:data_n
    I = double(imread([imgfile,'\',imgdir(i_img).name]));% 读取像素矩阵
%     I = double(rgb2gray(I));  % 彩色图像需要进一步准换成灰度格式
    fprintf(fid, '%s\n',imgdir(i_img).name);
    
    nImg= 2*(i_img-1)+1;%记录图像序号
    nIndex = 1;%记录嵌入容量标记
    
    for Capacity =  10000:1000:10000  %设置测试容量
        % 开始嵌入，返回[性能结果，实际嵌入比特数量]
        [nPer,bits] = Manner1(I,Capacity,auxR); 
        if bits < Capacity
            break
        end
        PSNR = nPer(2)  %读取含密图像PSNR
        
        % 保存最佳结果（不同预设边信息长度）
        if PSNR > performance(nImg+1,nIndex)
            performance(nImg:nImg+1,nIndex) = nPer;
        end
     
        nIndex = nIndex+1;
        
        fprintf('The %d test image,embedding %d bits, %d%%\n',i_img,Capacity,fix((i_img/data_n)*100));
    end
%     save 2D_MHM_Kodak.mat performance;
end
end
toc
disp('完成！')