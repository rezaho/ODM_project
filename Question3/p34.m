%% Optimal Decision Making Group Project
% Distributionally Robust Optimization
% function y = p34(train, test, rho)
% Input: 
% - train: training samples
% - test: testing samples
% - rho: Wasserstein radius
% Output:
% - y: utility achieved by the optimal decision

% Fill in the sections marked by '...'
function y = p34(train, test, rho)
%% Utility function, Wasserstein radius and norm for the Wasserstein ball
a1 = 4; b1 = 0;
a2 = 1; b2 = 0;

%% Number of assets and training periods
K = length(train(1,:));
N = length(train(:,1));

%% Decision Variables
x = sdpvar(K,1) ;
z = sdpvar(N,1) ;
r = sdpvar(1,1) ;
y = sdpvar(N,1) ;
t = sdpvar(N,1) ;
P = zeros(N,1) ;
P(:,:) = 1/N ;

%% Objective
obj = power(rho,2).*r+P'*t;

%% Constraints
con = [sum(x)==1, x>=0, r<=0];
for i=1:N
    con = [con, a1*x'*test(i,:)'+b1>=z(i), a2*x'*test(i,:)'+b2>=z(i), -y(i)<=z(i)];
end
 
for i=1:N
    for j=1:N
        con =[con, y(j)+t(i)+r*sum(power(train(i,:)-train(j,:), 2))<=0];
    end
end
%% Optimization Settings
ops = sdpsettings('solver','Gurobi','verbose',0);
diag = optimize(con,-obj,ops);

%% Retrieve portfolio weights 
x = value(x);
    
%% Evaluate portfolio
y_test = mean(obj);
print(y_test)
end