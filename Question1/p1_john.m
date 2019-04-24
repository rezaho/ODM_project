%%%%%%%%%%%%%%%%%%%%%% MGT-483 Optimal Decision Making %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Project / Question 1 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%          Wasserstein Distance           %%

%% Prepare the workspace
clear
clc
close all
%% Distributions

P = [1/2, 1/3, 1/6];
Q = [2/5, 3/5];
loc_s = [1;2;3];
loc_d = [1;2];
%% Compute cost function
dist = pdist2(loc_s, loc_d, 'squaredeuclidean');

%% Optimization problem
% decision variables: [x11, x21, x31, x12, x22, x32]
trans_map = sdpvar(length(P)*length(Q),1, 'full');    

% constraints
A = [1 1 1 0 0 0;
     0 0 0 1 1 1];    % coefficients of demand constraints
 
A2 = [1 0 0 1 0 0;
      0 1 0 0 1 0;
      0 0 1 0 0 1];   % coefficients of supply constraints
  
con = [A*trans_map==Q', A2*trans_map==P', trans_map>=0];

% objective
c = [dist(:,1); dist(:,2)];
obj = c'*trans_map;

% solution
ops = sdpsettings('solver','gurobi','verbose',0);
diag = optimize(con, obj, ops)

% read optimal objective (must be square root of the obj by def'n)
wass_dist = sqrt(value(obj))
