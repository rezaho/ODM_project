%%%%%%%%%%%%%%%%%%%%%% MGT-483 Optimal Decision Making %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Project / Question 2 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%          Color Transfer Using Optimal Transport          %%%%%          

%% Prepare the workspaces
clear
clc
close all

%% Read images
X = imread('spring.jpg'); %Source image
Y = imread('fall.jpg'); %Target image
figure()
subplot(1, 2, 1), imshow(X);
title('Source Image')
subplot(1, 2, 2), imshow(Y);
title('Target Image')
%% Normalize images between 0 and 1
X = im2double(X);
Y = im2double(Y);
%% Reshape images in 2D
[w1, h1, d1] = size(X); % Size of the first image
[w2, h2, d2] = size(Y); % Size of the second image
 
n_1  = w1*h1;   % number of pixels in X for one channel
n_2  = w2*h2;   % number of pixels in Y for one channel

X_ = reshape(X, n_1, 3); % X_ corresponds to X' in the report
Y_ = reshape(Y, n_2, 3); % Y_ corresponds to X' in the report
%% Color Distribution Plot of the Source Image
figure()
sz = 25;             % circle size
scatter3(X_(:,1), X_(:,2), X_(:,3), sz, X_, 'filled')
xlabel('Red')
ylabel('Green')
zlabel('Blue')
title('Color Distribution','FontWeight','normal')
grid on
axis equal
view(3)
%% Subsampling

N = 500; % Number of samples for the images
 
rng(0) % Control random number generation
X_ss = X_(randperm(n_1,N),:); % Subsampled X', corresponds to X^ in the report
Y_ss = Y_(randperm(n_2,N),:); % Subsampled Y', corresponds to Y^ in the report

P = ones(N, 1) / N; %Probability distribution for the first image
Q = ones(N, 1) / N; %Probability distribution for the second image

%% Compute cost function
dist = pdist2(X_ss, Y_ss, 'squaredeuclidean');

%% Optimization problem
% decision variables
S = length(X_ss); S_ = length(Y_ss);
trans_map = sdpvar(S, S_, 'full');   % red sample transport map
% constraints
A = ones(1,S);
A2 = ones(1,S_);
con = [A*trans_map==Q', A2*trans_map'==P', trans_map>=0];

% objective
obj = reshape(dist,S*S_,1)' * reshape(trans_map,S*S_,1);

% solution
ops = sdpsettings('solver','gurobi','verbose',0);
diag = optimize(con, obj, ops)

% read the optimal value
ot_map = value(trans_map); %Corresponds to pi* in the report


% %% Re-color the source image
% X_new_ss = N * ot_map * Y_ss; %X_new_ss corresponds to X^_new in the report
% B = pinv(X_ss) * X_new_ss;    %B corresponds to B* in the report
% X_new_ = X_ * B; %X_new_ corresponds to X' in the report
% X_new = reshape(X_new_, w1, h1, 3);
% 
% figure, imshow(X_new, [])
% title('Re-colored Image')

%% BONUS
Y_new_ss = N * ot_map' * X_ss;
B = pinv(Y_ss) * Y_new_ss;
Y_new_ = Y_ * B;
Y_new = reshape(Y_new_, w2, h2, 3);

figure, imshow(Y_new, [])
title('Re-colored Image')