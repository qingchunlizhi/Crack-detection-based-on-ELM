clear all;         %--ɾ�����б���
close all;         %--�ر����д���
clc;
forMat = '.jpg';    %-- ͼƬ��ʽ
dataPath = [ 'E:\ELM\Data\Img100��ͼƬ\']; %-- ͼ��Ŀ¼

% Frame_num��֡��,��101��ͼ��,ÿ����ȷ���Լ���֡�Ŵ���Χ
% ��������䴦��1~20֡��ͼ��, ����Frame_num = 1:20  
for Frame_num = 4:4
    res_path1=['blk\' num2str(Frame_num) '\crack\'];   % �洢�ѷ����ļ�Ŀ¼
    res_path2=['blk\' num2str(Frame_num) '\nocrack\']; % �洢���ѷ����ļ�Ŀ¼
    % ����������Ŀ¼
    if ~exist(res_path1,'dir')  % ����Ƿ��д洢�ѷ����ļ���,û�еĻ��ؽ�1��
        mkdir(res_path1);
    end
    if ~exist(res_path2,'dir')  % ����Ƿ��д洢���ѷ����ļ���,û�еĻ��ؽ�1��
        mkdir(res_path2);
    end
    % ����֡�����ζ�ȡͼ��
    frame= imread([dataPath int2str(Frame_num) forMat]); 
    % ��RGBͼ��תΪ�Ҷ�ͼ��grayframe
    grayframe = rgb2gray(frame);
    % ��ʾ��ǰ�Ҷ�ͼ��
    figure, imshow(grayframe);
    % ����ǰ�Ҷ�ͼ�񸳸�im1
    im1 = grayframe;
    
    %-- �趨�ֿ�ȡͼ�Ĳ���
    imgsize = [size(frame,1),size(frame,2)]; % ��ȡͼ��ߴ�
    patch_size = 75;    % ÿ������ͼ��ĳߴ�
    step_size = 25;     % ��ͼ��ֿ��ƶ�ʱ�ļ������
    %--����һ���ͼ���Էֶ��ٸ�����ͼ��,��ÿ���鿴��һ����Ԫ
    BlockLie = round((imgsize(2)-patch_size)/step_size-1);   %���鵥Ԫ������
    BlockHang = round((imgsize(1)-patch_size)/step_size-1);  %���鵥Ԫ������
    patch_num = BlockLie*BlockHang;           %һ�����Ի�ȡ���ٸ����鵥Ԫ
    %%
    inc0 = 1;   % �ѷ췽��ͼ�����
    inc1 = 1;   % ���ѷ췽��ͼ�����
    % ���б���,��������ÿ������ͼ��ķ���,���ж��Ƿ�Ϊ�ѷ췽��ͼ��
    for i=1:BlockHang
        for j=1:BlockLie
            % ����75*75����ʱ����ͼ����� temp_patch
            temp_patch = zeros(patch_size,patch_size);
            % �ӻҶ�ͼ���а��ջ������ķ�ʽ��ȡ����ͼ��
            temp_patch = grayframe((i-1)*step_size+1:(i-1)*step_size+patch_size, (j-1)*step_size+1:(j-1)*step_size+patch_size);
            % �ж���ǰ��ȡ�ķ���ͼ��ķ����Ƿ������ֵ����22
            if(std(double(temp_patch(:)))>=22)
                % ���������ֵ����22,��д���ѷ���ѡ�ļ���,ͼ���ʽΪpng
                imwrite(temp_patch,strcat('.\blk\',num2str(Frame_num),'\crack\',[num2str(inc0),'.png']));
                inc0 = inc0+1; % �ۼƼ�1
            else
                % �����������ֵ����,��д����ѷ���ѡ�ļ���,ͼ���ʽΪpng
                imwrite(temp_patch,strcat('.\blk\',num2str(Frame_num),'\nocrack\',[num2str(inc1),'.png']));
                inc1 = inc1+1; % �ۼƼ�1
            end
        end
    end
end
