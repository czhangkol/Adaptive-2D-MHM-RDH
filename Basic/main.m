clear all;
clc;
%% The main program of the adaptive 2D MHM

% read the image
imgfile = ['..\images\'];
imgdir = dir([imgfile,'\*.bmp']);
fid = fopen('fileName.txt','wt');
data_n = length(imgdir); %������ͼ��������

start = 1;%����ͼ����ʼ���
data_n = start;%����ͼ���β���

performance = zeros(length(imgdir)*2,100);
tic
for auxR = 800:50:800 % Ԥ�����Ϣ����
for i_img = start:data_n
    I = double(imread([imgfile,'\',imgdir(i_img).name]));% ��ȡ���ؾ���
%     I = double(rgb2gray(I));  % ��ɫͼ����Ҫ��һ��׼���ɻҶȸ�ʽ
    fprintf(fid, '%s\n',imgdir(i_img).name);
    
    nImg= 2*(i_img-1)+1;%��¼ͼ�����
    nIndex = 1;%��¼Ƕ���������
    
    for Capacity =  10000:1000:10000  %���ò�������
        % ��ʼǶ�룬����[���ܽ����ʵ��Ƕ���������]
        [nPer,bits] = Manner1(I,Capacity,auxR); 
        if bits < Capacity
            break
        end
        PSNR = nPer(2)  %��ȡ����ͼ��PSNR
        
        % ������ѽ������ͬԤ�����Ϣ���ȣ�
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
disp('��ɣ�')