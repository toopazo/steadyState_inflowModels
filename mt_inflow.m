function lambda = mt_inflow(CT, mu, alpha, Vtip, lambda_c)
%    @book{leishman2006principles,
%      title={Principles of helicopter aerodynamics with CD extra},
%      author={Leishman, Gordon J},
%      year={2006},
%      publisher={Cambridge university press}
%    }

    % lambda = lambda_c + lambda_i
    % lambda_c    = Vc / (omega*blade_st.R);   % vertical vel  
    % lambda_h    = sqrt( CT/2 )  
    % mu          = Vf / (omega*blade_st.R);   % horizontal vel
    
    if mu == 0
        Vc          = Vtip * lambda_c;
        
        % CT = T / (rho*A*Vtip^2)
        % vh = sqrt(T/(2*rho*A))  
        % vh = sqrt(0.5 * CT * Vtip^2)                  
        vh          = sqrt(0.5 * CT * Vtip^2);
        vi_vh       = - (0.5*Vc/vh) + sqrt( (0.5*Vc/vh)^2 + 1 );
        vi          = vi_vh * vh;
        
        lambda_i    = vi / Vtip;
        
        lambda      = lambda_c + lambda_i;
        return 
    end
    
    options = optimset('Display','off');
    xguess = 10;
    x0 = fsolve(@funzero, xguess, options);
    err = funzero(x0);
    
    lambda = x0;
    
    function err = funzero(x)
        err = x - mu*tan(alpha) - (CT)/(2*sqrt(mu^2+x^2));
    end
end
