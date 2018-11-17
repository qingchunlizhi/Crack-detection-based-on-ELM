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
        img = frame(1:3450,1:4500);   % ԭͼ��ȡ��4500*3450��С��ͼƬ
        % figure, imshow(img); 
        img=double(img);
        %figure, imshow(img); 
        imgsize = size(img);              % ��ȡͼ���С

        % �ָ�ģ����Ϣ  
        patch_size = 75;    % ��һ����ģ��ĳߴ�
        step_size = 75;     % ��ͼ��ֿ�ʱ�ļ������
        %
        BlockLie = imgsize(2)/patch_size;   % ȷ��ÿһ�зֳɶ��ٿ�
        BlockHang = imgsize(1)/patch_size;  % ȷ��ÿһ�зֳɶ��ٿ�
        patch_num = BlockLie*BlockHang;     % ȷ����ǰͼ�ܹ�����Ϊ���ٲ��ص���


        load(['E:\����Data\','elm_',num2str(i2)]);
        % ���÷�����ж��ѷ췢������
        for i=1:BlockHang         % ������
            for j=1:BlockLie      % ������
                % ����ָ��
                if(i==46)  % ȷ������һ��
                    i=i;
                end
                if(j==60)  % ȷ������һ��
                    j=j;
                end
                %
                % ��ȡ��i�е�j�еĿ�ͼ��75*75
                temp_patch = img((i-1)*step_size+1:(i-1)*step_size+patch_size, (j-1)*step_size+1:(j-1)*step_size+patch_size);
                % ���÷����С׼����ж���ǰ���Ƿ�Ϊ�ѷ��
                % �������20,��Ϊ�ѷ�� %%%%*******************���ֶ�����
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
        load(['E:\����Data\Img100��ͼƬ\Gnt\',num2str(i1),'_Ground']);
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