clear all;         %--删除所有变量
close all;         %--关闭所有窗口
clc;
forMat = '.jpg';    %-- 图片格式
dataPath = [ 'E:\ELM\Data\Img100张图片\']; %-- 图像目录

% Frame_num是帧号,共101张图像,每个人确定自己的帧号处理范围
% 如果被分配处理1~20帧号图像, 则是Frame_num = 1:20  
for Frame_num = 4:4
    res_path1=['blk\' num2str(Frame_num) '\crack\'];   % 存储裂缝块的文件目录
    res_path2=['blk\' num2str(Frame_num) '\nocrack\']; % 存储非裂缝块的文件目录
    % 创建保存结果目录
    if ~exist(res_path1,'dir')  % 检查是否有存储裂缝块的文件夹,没有的话重建1个
        mkdir(res_path1);
    end
    if ~exist(res_path2,'dir')  % 检查是否有存储非裂缝块的文件夹,没有的话重建1个
        mkdir(res_path2);
    end
    % 按照帧号依次读取图像
    frame= imread([dataPath int2str(Frame_num) forMat]); 
    % 将RGB图像转为灰度图像grayframe
    grayframe = rgb2gray(frame);
    % 显示当前灰度图像
    figure, imshow(grayframe);
    % 将当前灰度图像赋给im1
    im1 = grayframe;
    
    %-- 设定分块取图的参数
    imgsize = [size(frame,1),size(frame,2)]; % 获取图像尺寸
    patch_size = 75;    % 每个方块图像的尺寸
    step_size = 25;     % 将图像分块移动时的间隔距离
    %--计算一大幅图可以分多少个方块图像,将每个块看做一个单元
    BlockLie = round((imgsize(2)-patch_size)/step_size-1);   %方块单元的列数
    BlockHang = round((imgsize(1)-patch_size)/step_size-1);  %方块单元的行数
    patch_num = BlockLie*BlockHang;           %一共可以获取多少个方块单元
    %%
    inc0 = 1;   % 裂缝方块图像计数
    inc1 = 1;   % 非裂缝方块图像计数
    % 行列遍历,初步计算每个方块图像的方差,简单判定是否为裂缝方块图像
    for i=1:BlockHang
        for j=1:BlockLie
            % 建立75*75的临时方块图像矩阵 temp_patch
            temp_patch = zeros(patch_size,patch_size);
            % 从灰度图像中按照滑动窗的方式提取方块图像
            temp_patch = grayframe((i-1)*step_size+1:(i-1)*step_size+patch_size, (j-1)*step_size+1:(j-1)*step_size+patch_size);
            % 判定当前提取的方块图像的方差是否大于阈值参数22
            if(std(double(temp_patch(:)))>=22)
                % 如果大于阈值参数22,则写入裂缝块候选文件下,图像格式为png
                imwrite(temp_patch,strcat('.\blk\',num2str(Frame_num),'\crack\',[num2str(inc0),'.png']));
                inc0 = inc0+1; % 累计加1
            else
                % 如果不大于阈值参数,则写入非裂缝块候选文件下,图像格式为png
                imwrite(temp_patch,strcat('.\blk\',num2str(Frame_num),'\nocrack\',[num2str(inc1),'.png']));
                inc1 = inc1+1; % 累计加1
            end
        end
    end
end
