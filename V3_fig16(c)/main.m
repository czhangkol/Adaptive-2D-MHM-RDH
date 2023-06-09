clear all;
clc;
imgfile = ['..\images\'];
imgdir = dir([imgfile,'\*.bmp']);
fid = fopen('fileName.txt','wt');
data_n = length(imgdir);
start = 2;
% data_n = start;
% data_n = 50;

performance = zeros(length(imgdir)*2,100);
tic
for auxR = 800:50:800
% load 2D_MHM.mat
for i_img = start:data_n
    I = double(imread([imgfile,'\',imgdir(i_img).name]));
%     I = double(rgb2gray(I));
    fprintf(fid, '%s\n',imgdir(i_img).name);
    
    nImg= 2*(i_img-1)+1;
    nIndex = 1;
    
    for Capacity =  5000:5000:100000
        [nPer,bits] = Manner1(I,Capacity,auxR);
        if bits < Capacity
            break
        end
        PSNR = nPer(2)
        if PSNR > performance(nImg+1,nIndex)
            performance(nImg:nImg+1,nIndex) = nPer;
        end
     
        nIndex = nIndex+1;
        
        fprintf('The %d test image,embedding %d bits, %d%%\n',i_img,Capacity,fix((i_img/data_n)*100));
    end
    save 2D_UCID_v3.mat performance;
end
end
toc
disp('��ɣ�')