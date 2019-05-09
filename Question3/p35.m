%% Optimal Decision Making Group Project
% Loop over 1,000 independent training datasets
% % Fill in the sections marked by '...'

%% Clear Matlab
clc
clear
close all

%% Set random number generator seed for reproducibility
rng(0);

%% Specify training and testing samples
% testing set
load test
% training set
N = 1000;           % number of independent training datasets
N_train = 30;       % number of training samples in each set

%% Declare results and set Wasserstein radius
saa = zeros(N,1);
dro = zeros(N,1);
rho = 0.9;          % Wasserstein radius
%% Compute optimal utility when knowing all testing samples
pi = 0.5712;
%% Loop over all training datasets
for n = 1:N
    train = sample_data(N_train);       % draw a new training dataset
    [saa(n), ~] = p33(train, test) ;
    dro(n) = p34(train, test, rho);
    fprintf('Progress %0.2f\n',n/N)
end
%% Save results
save results

%% Plot normalized cumulative distribution function
set(0,'DefaultAxesFontSize',24)

plot(sort(saa)/pi,1/N:1/N:1,'LineWidth',3,'DisplayName','SAA','Color',[1 0.5 0]);
hold on
plot(sort(dro)/pi,1/N:1/N:1,'LineWidth',3,'DisplayName','DRO','Color',[0.25 0.5 1]);
line([mean(saa)/pi,mean(saa)/pi] ,[0 1],'LineWidth',3,'Color',[1 0.5 0],'LineStyle','--','DisplayName','Mean SAA')
line([mean(dro)/pi, mean(dro)/pi],[0 1],'LineWidth',3,'Color',[0.25 0.5 1],'LineStyle','--','DisplayName','Mean DRO')
legend('boxoff')

axis([0.65 1 0 1])

ax = gca();
ax.LineWidth = 2.5;

grid on

xlabel('Normalized out-of-sample utility')
ylabel('Probability')
legend('Location','northwest')

% Save the figure under the name 'fname'
fname = 'p35_plot';
saveas(gcf, fname);

hold off