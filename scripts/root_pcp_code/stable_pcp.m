function [L, S] = stable_pcp (D, lambda, mu)
% [L, S] = stable_pcp( D, lambda, mu )
%
% Solve the following problem:
% min_{L,S}
%         ||L||_* + lambda * ||S||_1 + mu/2 * ||L+S-D||_F^2
% This is first transformed to the problem
% min_{L1,L2,S1,S2,Z}
%      ||L1||_* + lambda * ||S1||_1 + mu/2 * ||Z||_F^2
% s.t. L1 = L2
%      S1 = S2
%      L2 + S2 + Z = D.
% The algorithm conducts ADMM splitting as (L1,S1,Z),(L2,S2).

[n,p] = size(D);
rho = 0.1; % Augmented Lagrangian parameter

[L1,L2,S1,S2,Z,Y1,Y2,Y3] = deal(zeros(n,p));

MAX_ITER = 5000;
EPS_ABS = 1e-6;
EPS_REL = 1e-6;

flag_converge = 0;

% ADMM-splitting iterations
for i = 1:MAX_ITER
    if mod(i,100)==0
        fprintf("\n current iteration %d",i);
    end
    
    % Store previous values of L2,S2
    L2_old = L2;
    S2_old = S2;
    
    % Update 1st primal variable (L1,S1,Z)
    [L1, ~] = prox_nuclear( L2-Y1/rho, 1/rho );
    S1 = prox_l1( S2-Y2/rho, lambda/rho );
    Z = (rho*(D-L2-S2)-Y3)/(mu+rho);
    
    % Update 2nd primal variable (L2,S2)
    L2 = 1/3*( D-Z+2*L1-S1 + (2*Y1-Y2-Y3)/rho );
    S2 = 1/3*( D-Z+2*S1-L1 + (2*Y2-Y1-Y3)/rho );
    
    % Update dual variable (Y1,Y2,Y3)
    Y1 = Y1 + rho*(L1-L2);
    Y2 = Y2 + rho*(S1-S2);
    Y3 = Y3 + rho*(L2+S2+Z-D);
    
    %  Calculate primal & dual residuals; Update rho
    res_primal = sqrt( norm(L1-L2,'fro')^2 + norm(S1-S2,'fro')^2 + ...
                       norm(Z+L2+S2-D,'fro')^2 );
    res_dual = rho * sqrt( norm(L2-L2_old,'fro')^2 + norm(S2-S2_old,'fro')^2 + ...
                           norm(L2-L2_old+S2-S2_old,'fro')^2 );
    if res_primal > 10 * res_dual
        rho = rho * 2;
    elseif res_dual > 10 * res_primal
        rho = rho / 2;
    end 
    
    % Check stopping criteria
    thresh_primal = EPS_ABS * sqrt(3*n*p) + EPS_REL * ...
                    max([sqrt( norm(L1,'fro')^2 + norm(S1,'fro')^2 + norm(Z,'fro')^2 ), ...
                         sqrt( norm(L2,'fro')^2 + norm(S2,'fro')^2 + norm(L2+S2,'fro')^2 ), ...
                         norm(D,'fro')
                        ]);
    thresh_dual = EPS_ABS * sqrt(3*n*p) + EPS_REL * ...
                    sqrt( norm(Y1,'fro')^2 + norm(Y2,'fro')^2 + norm(Y3,'fro')^2 );
    if res_primal < thresh_primal && res_dual < thresh_dual
        flag_converge = 1;
        disp(['Converged in ',num2str(i),' iterations.']);
        fprintf('\nfinal residual primal %d, dual %d\n',res_primal,res_dual);
        break
    end
end

L = (L1+L2) / 2;
S = (S1+S2) / 2;
if flag_converge == 0
    disp('Did not converge.');
end

return
