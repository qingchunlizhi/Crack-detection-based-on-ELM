clear all;
load('traindata_2');
N1=2000;
N2=2000;
N3=6000;
rand('state',16917921)   % 5000
rand('state',67797325)   % 12000
b1=2*rand(size(train_x,2)+1,N1)-1;
b2=2*rand(N1+1,N2)-1;
 b3=orth(2*rand(N2+1,N3)'-1)';
 C = 2^-30 ;s = 0.8;
tic
train_x = zscore(train_x')';
H1 = [train_x .1 * ones(size(train_x,1),1)];
clear train_x;
%% First layer RELM
A1 = H1 * b1;A1 = mapminmax(A1);
clear b1;
beta1  =  sparse_elm_autoencoder(A1,H1,1e-3,50)';
clear A1;

T1 = H1 * beta1;
fprintf(1,'Layer 1: Max Val of Output %f Min Val %f\n',max(T1(:)),min(T1(:)));

[T1,ps1]  =  mapminmax(T1',0,1);T1 = T1';

clear H1;
%% Second layer RELM
H2 = [T1 .1 * ones(size(T1,1),1)];
clear T1;

A2 = H2 * b2;A2 = mapminmax(A2);
clear b2;
beta2 = sparse_elm_autoencoder(A2,H2,1e-3,50)';
clear A2;

T2 = H2 * beta2;
fprintf(1,'Layer 2: Max Val of Output %f Min Val %f\n',max(T2(:)),min(T2(:)));

[T2,ps2] = mapminmax(T2',0,1);T2 = T2';

clear H2;
%% Original ELM
H3 = [T2 .1 * ones(size(T2,1),1)];
clear T2;

T3 = H3 * b3;
l3 = max(max(T3));l3 = s/l3;
fprintf(1,'Layer 3: Max Val of Output %f Min Val %f\n',l3,min(T3(:)));

T3 = tansig(T3 * l3);
clear H3;
%% Finsh Training
beta = (T3'  *  T3+eye(size(T3',1)) * (C)) \ ( T3'  *  train_y);
Training_time = toc;
disp('Training has been finished!');
disp(['The Total Training Time is : ', num2str(Training_time), ' seconds' ]);
%% Calculate the training accuracy
xx = T3 * beta;
clear T3;

yy = result_tra(xx);
train_yy = result_tra(train_y);
TrainingAccuracy = length(find(yy == train_yy))/size(train_yy,1);
disp(['Training Accuracy is : ', num2str(TrainingAccuracy * 100), ' %' ]);
%% First layer feedforward
tic;

test_x = zscore(test_x')';
HH1 = [test_x .1 * ones(size(test_x,1),1)];
%clear test_x;

TT1 = HH1 * beta1;TT1  =  mapminmax('apply',TT1',ps1)';
%clear HH1;clear beta1;
%% Second layer feedforward
HH2 = [TT1 .1 * ones(size(TT1,1),1)];
%clear TT1;

TT2  =  HH2 * beta2;TT2  =  mapminmax('apply',TT2',ps2)';
%clear HH2;clear beta2;
%% Last layer feedforward
HH3 = [TT2 .1 * ones(size(TT2,1),1)];
%clear TT2;

TT3 = tansig(HH3 * b3 * l3);
%clear HH3;clear b3;

x = TT3 * beta;
y = result_tra(x);
test_yy = result_tra(test_y);
TestingAccuracy = length(find(y == test_yy))/size(test_yy,1);
%clear TT3;
%% Calculate the testing accuracy
Testing_time = toc;
disp('Testing has been finished!');
disp(['The Total Testing Time is : ', num2str(Testing_time), ' seconds' ]);
disp(['Testing Accuracy is : ', num2str(TestingAccuracy * 100), ' %' ]);
