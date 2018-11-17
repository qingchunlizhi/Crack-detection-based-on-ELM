clear all;         %--删除所有变量
close all;         %--关闭所有窗口
clc;
dataPath = [ 'F:\数据集Data\BLK\']; %-- 图像目录
load ('randamList');       %帧号数据
Cnt_blk = 110;  % 裂缝、非裂缝每张块数110*2,220*90=19800张裂缝/非裂缝
Crack_Train = zeros(19800,28*28);
NoCrack_Train = zeros(19800,28*28);
F_id = list;
inc0 = 1; 
inc1 = 1; 
for num=1:100
  for Frame_cnt = 1:90
     [num,Frame_cnt]
    %% 确定图像文件目录
    Frame_num = F_id(num,Frame_cnt);
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
    fileList1_cut = fileList1(1:Cnt_blk);
    clear fileList1;
    %
    Num_crack = length(fileList2);
    rand_sequence = randperm(Num_crack);   %随机扰动排序 确保每次输入数据均不一样
    fileList2 = fileList2(rand_sequence);
    fileList2_cut = fileList2(1:Cnt_blk);
    clear fileList2;
    %
    Num_crack = length(fileList3);
    rand_sequence = randperm(Num_crack);   %随机扰动排序 确保每次输入数据均不一样
    fileList3 = fileList3(rand_sequence);
    fileList3_cut = fileList3(1:Cnt_blk*2);
    clear fileList3;
    
    for i=1:Cnt_blk
        blk_img = imread([res_path1, fileList1_cut(i).name]);
        blk_img28 = imresize(double(blk_img),[28 28],'bilinear');
        Crack_Train(inc0,:)=blk_img28(:);
        inc0=inc0+1;
    end
    for i=1:Cnt_blk
        blk_img = imread([res_path2, fileList2_cut(i).name]);
        blk_img28 = imresize(double(blk_img),[28 28],'bilinear');
        Crack_Train(inc0,:)=blk_img28(:);
        inc0=inc0+1;
    end
    for i=1:Cnt_blk*2
        blk_img = imread([res_path3, fileList3_cut(i).name]);
        blk_img28 = imresize(double(blk_img),[28 28],'bilinear');
        NoCrack_Train(inc1,:)=blk_img28(:);
        inc1=inc1+1;
    end
    Frame_cnt
  end
  save(['CNN',num2str(num),'_data.mat'],'Crack_Train','NoCrack_Train','F_id');
end

