function [...
    lambda          , ...
    lambda_i        , ...
    lambda_c          ...
    ] = bet_forces_inflow(psi, r, mu, lambda_c, sigma, Cla, theta, CT_target)
    
%    @book{leishman2006principles,
%      title={Principles of helicopter aerodynamics with CD extra},
%      author={Leishman, Gordon J},
%      year={2006},
%      publisher={Cambridge university press}
%    }      
        
    % inflow according to BET and Glauert
    % if (mu >= 0.15)
    if (mu > 0.01)
        kx = 1.2;
        % tan(TPP_alpha) = lambda_c / mu
        TPP_alpha = atan(lambda_c / (mu+10^-6)); 
        % lambda_i from MT
        Vtip        = NaN;  % Only used when mu == 0
        lambda_MT   = mt_inflow(CT_target, mu, TPP_alpha, Vtip, lambda_c);
        lambda_0    = lambda_MT - lambda_c;
        % Glauert approximation
        lambda_i    = lambda_0 * ( 1 + kx*r*cos(psi) );
        % total inflow            
        lambda      = lambda_c + lambda_i;
        return
    end
    
    % inflow according to BEMT = (BET + MT + mu=0 )
    if (mu <= 0.01)
        [lambda, lambda_i] = bemt_inflow(...
            sigma, Cla, theta, r, lambda_c); 
        return
    end 
    
    disp('[bet_forces_inflow] No model for lambda_i')                            
end
