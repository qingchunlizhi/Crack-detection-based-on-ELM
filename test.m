clear all;
close all;
clc;
load('allImg');
test_x=zeros(1,75*75);
temp_patch=zeros(75,75);
imgout= zeros(46,60); 
accuracy=zeros(1,100);
for i2=1:1
    for i1=1:1
        [i2,i1]
        frame=allImg(i1,:,:);
        frame=reshape(frame,3456,4608);
        img = frame(1:3450,1:4500);   % 原图截取成4500*3450大小的图片
        % figure, imshow(img); 
        img=double(img);
        %figure, imshow(img); 
        imgsize = size(img);              % 读取图像大小

        % 分割模板信息  
        patch_size = 75;    % 归一化后模板的尺寸
        step_size = 75;     % 将图像分块时的间隔距离
        %
        BlockLie = imgsize(2)/patch_size;   % 确定每一行分成多少块
        BlockHang = imgsize(1)/patch_size;  % 确定每一列分成多少块
        patch_num = BlockLie*BlockHang;     % 确定当前图总共被分为多少不重叠块


        load(['E:\数据Data\','elm_',num2str(i2)]);
        % 利用方差简单判定裂缝发生区域
        for i=1:BlockHang         % 遍历行
            for j=1:BlockLie      % 遍历列
                % 调试指令
                if(i==46)  % 确定在哪一行
                    i=i;
                end
                if(j==60)  % 确定在哪一列
                    j=j;
                end
                %
                % 提取第i行第j列的块图像75*75
                temp_patch = img((i-1)*step_size+1:(i-1)*step_size+patch_size, (j-1)*step_size+1:(j-1)*step_size+patch_size);
                % 利用方差大小准则简单判定当前块是否为裂缝块
                % 方差大于20,认为裂缝块 %%%%*******************可手动调节
               %%
                test_x=temp_patch(:)';
                test_x = zscore(test_x')';
                HH1 = [test_x .1 * ones(size(test_x,1),1)];
                %clear test_x;

                TT1 = HH1 * beta1;
                TT1  =  mapminmax('apply',TT1',ps1)';
                %clear HH1;clear beta1;
                %% Second layer feedforward
                HH2 = [TT1 .1 * ones(size(TT1,1),1)];
                %clear TT1;

                TT2  =  HH2 * beta2;
                TT2  =  mapminmax('apply',TT2',ps2)';
                %clear HH2;clear beta2;
                %% Last layer feedforward
                HH3 = [TT2 .1 * ones(size(TT2,1),1)];
                %clear TT2;

                TT3 = tansig(HH3 * b3 * l3);
                %clear HH3;clear b3;

                x = TT3 * beta;
                y = result_tra(x);
                if(x(1)>x(2))
                    imgout(i,j)=1;
                end
            end
        end
        load(['E:\数据Data\Img100张图片\Gnt\',num2str(i1),'_Ground']);
        [lm ,ln]=size(imgout);

        for i=1:lm
            for j=1:ln
                if imgout(i,j)==Ground_bw(lm,ln);
                    accuracy(i1)=accuracy(i1)+1;
                end
            end
        end

        if ~exist(['.\result',num2str(i2),'\'],'dir')
            mkdir(['.\result',num2str(i2),'\']);
        end
        imwrite(imgout,strcat('.\result',num2str(i2),'\',[num2str(i1),'.png']));
        accuracy(i1)=accuracy(i1)/(lm*ln);

    end
    save(['accuracy_',num2str(i2)],'accuracy');
end