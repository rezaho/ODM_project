function xi = sample_data(N)
%% Set-Up Assets
K = 20;             % number of assets
psi_dev = 0.02;
zeta_mu = 0.03;
zeta_dev = 0.025;
xi = sample_xi(N,K,psi_dev, zeta_mu, zeta_dev);

%% Helper functions
function xi = sample_xi(N,K,psi_dev, zeta_mu, zeta_dev)
    psi = psi_dev * randn(N,1);
    xi = zeros(N,K);
    for k = 1:K
        xi(:,k) = psi + k*zeta_mu + k*zeta_dev * randn(N,1);
    end
end
end