clear
close all
load('result_data2')

figure
%测试准确率
subplot(2,2,1)

plot(No,ACC*100,'--gs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.9,0.5,0.5])
grid minor
hold on;
plot(No,ACC1*100,'--y^',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor',[0.2,0.8,0.5])
hold on;
plot(No,ACC2*100,'--cd',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor',[0.5,0.5,0.9])
title('(a)：模型测试准确率图','FontSize',17)
xlabel('测试样本序号(No)','FontSize',17)
ylabel('准确率(ACC)/%','FontSize',17)
%测试精确率
subplot(2,2,2)

plot(No,P*100,'--gs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.9,0.5,0.5])
grid minor
hold on;
plot(No,P1*100,'--y^',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor',[0.2,0.8,0.5])
hold on;
plot(No,P2*100,'--cd',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor',[0.5,0.5,0.9])
title('(b)：模型测试精确率图','FontSize',17)
xlabel('测试样本序号(No)','FontSize',17)
ylabel('精确率（P）/%','FontSize',17)
%测试召回率
subplot(2,2,3)

plot(No,R*100,'--gs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.9,0.5,0.5])
grid minor
hold on;
plot(No,R1*100,'--y^',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor',[0.2,0.8,0.5])
hold on;
plot(No,R2*100,'--cd',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor',[0.5,0.5,0.9])
title('(c)：模型测试召回率图','FontSize',17)
xlabel('测试样本序号(No)','FontSize',17)
ylabel('召回率(R)/%','FontSize',17)
%测试F1-score
subplot(2,2,4)
plot(No,F1*100,'--gs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.9,0.5,0.5])
grid minor
hold on;
plot(No,F11*100,'--y^',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor',[0.2,0.8,0.5])
hold on;
plot(No,F12*100,'--cd',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor',[0.5,0.5,0.9])
title('(d)：模型测试F1-Score图','FontSize',17)
xlabel('测试样本序号(No)','FontSize',17)
ylabel('F1-Score(F1)/%','FontSize',17)
