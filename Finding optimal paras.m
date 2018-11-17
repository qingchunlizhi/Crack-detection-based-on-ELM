%clear all;
rc=zeros(1,21);
rc(1)=1e-10;
for i=2:21
    rc(i)=rc(i-1)*10;
end
rs=0:0.1:1;
n3=2000:1000:6000;
n12=500:500:2000;
result=ones(4620,8);
i5=1; 
load('traindata_2');
train_x = zscore(train_x')';
test_x = zscore(test_x')';
for i1=1:size(rc,2)
    for i2=1:size(rs,2)
       for i3=1:size(n12,2)
           for i4=1:1%size(n3)
                N1=n12(i3);
                N2=n12(i3);
                N3=n3(i4);
                % rand('state',16917921)   5000
                rand('state',67797325)   % 12000
                b1=2*rand(size(train_x,2)+1,N1)-1;
                b2=2*rand(N1+1,N2)-1;
                 b3=orth(2*rand(N2+1,N3)'-1)';
                 C = rc(i1) ;s = rs(i2);
                tic
                H1 = [train_x .1 * ones(size(train_x,1),1)];
                %clear train_x;
                %% First layer RELM
                A1 = H1 * b1;A1 = mapminmax(A1);
                %clear b1;
                beta1  =  sparse_elm_autoencoder(A1,H1,1e-3,50)';
                %clear A1;

                T1 = H1 * beta1;
                fprintf(1,'Layer 1: Max Val of Output %f Min Val %f\n',max(T1(:)),min(T1(:)));

                [T1,ps1]  =  mapminmax(T1',0,1);T1 = T1';

                %clear H1;
                %% Second layer RELM
                H2 = [T1 .1 * ones(size(T1,1),1)];
                %clear T1;

                A2 = H2 * b2;A2 = mapminmax(A2);
                %clear b2;
                beta2 = sparse_elm_autoencoder(A2,H2,1e-3,50)';
                %clear A2;

                T2 = H2 * beta2;
                fprintf(1,'Layer 2: Max Val of Output %f Min Val %f\n',max(T2(:)),min(T2(:)));

                [T2,ps2] = mapminmax(T2',0,1);T2 = T2';

                %clear H2;
                %% Original ELM
                H3 = [T2 .1 * ones(size(T2,1),1)];
                %clear T2;

                T3 = H3 * b3;
                l3 = max(max(T3));
                l3 = s/l3;
                fprintf(1,'Layer 3: Max Val of Output %f Min Val %f\n',l3,min(T3(:)));

                T3 = tansig(T3 * l3);
                %clear H3;
                %% Finsh Training
                beta = (T3'  *  T3+eye(size(T3',1)) * (C)) \ ( T3'  *  train_y);
                Training_time = toc;
                disp('Training has been finished!');
                %% Calculate the training accuracy
                xx = T3 * beta;
                %clear T3;

                yy = result_tra(xx);
                train_yy = result_tra(train_y);
                TrainingAccuracy = length(find(yy == train_yy))/size(train_yy,1);
                %% First layer feedforward
                tic;
                HH1 = [test_x .1 * ones(size(test_x,1),1)];
                %clear test_x;

                TT1 = HH1 * beta1;TT1  =  mapminmax('apply',TT1',ps1)';
                %clear HH1;%clear beta1;
                %% Second layer feedforward
                HH2 = [TT1 .1 * ones(size(TT1,1),1)];
                %clear TT1;

                TT2  =  HH2 * beta2;TT2  =  mapminmax('apply',TT2',ps2)';
                %clear HH2;%clear beta2;
                %% Last layer feedforward
                HH3 = [TT2 .1 * ones(size(TT2,1),1)];
                %clear TT2;

                TT3 = tansig(HH3 * b3 * l3);
                %clear HH3;%clear b3;

                x = TT3 * beta;
                y = result_tra(x);
                test_yy = result_tra(test_y);
                TestingAccuracy = length(find(y == test_yy))/size(test_yy,1);
                %clear TT3;
                %% Calculate the testing accuracy
                Testing_time = toc;
                disp('Testing has been finished!');
                r1=[C,s,N3,N1,Training_time,TrainingAccuracy,Testing_time,TestingAccuracy];
                result(i5,:)=r1;
                save([num2str(C),'_',num2str(s),'_',num2str(N3),'_',num2str(N1)],'C','s','N3','N1','Training_time','TrainingAccuracy','Testing_time','TestingAccuracy');
                disp(i5);
                disp(r1);
                i5=i5+1;
%                 name=['C=',num2str(C),'_s=',num2str(s),'_N3=',num2str(N3),'_N1N2=',num2str(N1)];
%                 save( name); pause(5);
           end
       end
    end
end
