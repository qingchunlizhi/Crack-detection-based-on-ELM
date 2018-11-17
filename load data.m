clear all;         %--删除所有变量
close all;         %--关闭所有窗口
clc;
dataPath = [ 'E:\数据Data\BLK\']; %-- 图像目录
Cnt_blk = 110;  % 裂缝、非裂缝每张块数110*2,220*90=19800张
Crack_Train = zeros(19800,75*75);
NoCrack_Train = zeros(19800,75*75);
Crack_Test = zeros(2200,75*75);
NoCrack_Test = zeros(2200,75*75);
load('randamList');
for i1=1:1
    disp(i1);
    F_id = list(i1,:);
    inc0 = 1; 
    inc1 = 1; 
    for Frame_cnt = 1:90
        %% 确定图像文件目录
        Frame_num = F_id(Frame_cnt);
        res_path1=[dataPath, num2str(Frame_num) '\crack0\'];   % 存储裂缝块的文件目录
        res_path2=[dataPath, num2str(Frame_num) '\crack90\'];   % 存储裂缝块的文件目录
        res_path3=[dataPath, num2str(Frame_num) '\nocrack\']; % 存储非裂缝块的文件目录
        fileList1 = dir([res_path1  '*.png']);
        fileList2 = dir([res_path2  '*.png']);
        fileList3 = dir([res_path3  '*.png']);
        rand('state',0);
        %%随机确定样本集
        %
        Num_crack = length(fileList1);
        rand_sequence = randperm(Num_crack);   %随机扰动排序 确保每次输入数据均不一样
        fileList1 = fileList1(rand_sequence);
        fileList_c = fileList1(1:Cnt_blk);
        clear fileList1;
        %
        Num_crack = length(fileList2);
        rand_sequence = randperm(Num_crack);   %随机扰动排序 确保每次输入数据均不一样
        fileList2 = fileList2(rand_sequence);
        fileList_c90 = fileList2(1:Cnt_blk);
        clear fileList2;
        %
        Num_crack = length(fileList3);
        rand_sequence = randperm(Num_crack);   %随机扰动排序 确保每次输入数据均不一样
        fileList3 = fileList3(rand_sequence);
        fileList_non = fileList3(1:Cnt_blk*2);
        clear fileList3;

        for i=1:Cnt_blk
            blk_img = imread([res_path1, fileList_c(i).name]);
            Crack_Train(inc0,:)=blk_img(:);
            inc0=inc0+1;
        end
        for i=1:Cnt_blk
            blk_img = imread([res_path2, fileList_c90(i).name]);
            Crack_Train(inc0,:)=blk_img(:);
            inc0=inc0+1;
        end
        for i=1:Cnt_blk*2
            blk_img = imread([res_path3, fileList_non(i).name]);
            NoCrack_Train(inc1,:)=blk_img(:);
            inc1=inc1+1;
        end
    end
    inc0 = 1; 
    inc1 = 1; 
    for Frame_cnt = 91:100
        %% 确定图像文件目录
        Frame_num = F_id(Frame_cnt);
        res_path1=[dataPath, num2str(Frame_num) '\crack0\'];   % 存储裂缝块的文件目录
        res_path2=[dataPath, num2str(Frame_num) '\crack90\'];   % 存储裂缝块的文件目录
        res_path3=[dataPath, num2str(Frame_num) '\nocrack\']; % 存储非裂缝块的文件目录
        fileList1 = dir([res_path1  '*.png']);
        fileList2 = dir([res_path2  '*.png']);
        fileList3 = dir([res_path3  '*.png']);
        %%随机确定样本集
        %
        Num_crack = length(fileList1);
        rand_sequence = randperm(Num_crack);   %随机扰动排序 确保每次输入数据均不一样
        fileList1 = fileList1(rand_sequence);
        fileList_c = fileList1(1:Cnt_blk);
        %
        Num_crack = length(fileList2);
        rand_sequence = randperm(Num_crack);   %随机扰动排序 确保每次输入数据均不一样
        fileList2 = fileList2(rand_sequence);
        fileList_c90 = fileList2(1:Cnt_blk);
        %
        Num_crack = length(fileList3);
        rand_sequence = randperm(Num_crack);   %随机扰动排序 确保每次输入数据均不一样
        fileList3 = fileList3(rand_sequence);
        fileList_non = fileList3(1:Cnt_blk*2);

        for i=1:Cnt_blk
            blk_img = imread([res_path1, fileList_c(i).name]);
            Crack_Test(inc0,:)=blk_img(:);
            inc0=inc0+1;
        end
        for i=1:Cnt_blk
            blk_img = imread([res_path2, fileList_c90(i).name]);
            Crack_Test(inc0,:)=blk_img(:);
            inc0=inc0+1;
        end
        for i=1:Cnt_blk*2
            blk_img = imread([res_path3, fileList_non(i).name]);
            NoCrack_Test(inc1,:)=blk_img(:);
            inc1=inc1+1;
        end
    end
    train_x=[Crack_Train;NoCrack_Train];
    test_y=[ones(1,2200) zeros(1,2200);zeros(1,2200) ones(1,2200)]';
    test_x=[Crack_Test;NoCrack_Test];
    train_y=[ones(1,19800) zeros(1,19800);zeros(1,19800) ones(1,19800)]';
    save(['E:\数据Data\data_' num2str(i1)], 'train_x','train_y','test_y', 'test_x','fileList_c','fileList_c90','fileList_non');
end

