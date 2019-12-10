function x0 = mt_inflow(CT, mu, alpha)
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
    
    options = optimset('Display','off');
    x0 = 10;
    x0 = fsolve(@funzero, x0, options);
    err = funzero(x0);
    
    function err = funzero(x)
        err = x - mu*tan(alpha) - (CT)/(2*sqrt(mu^2+x^2));
    end
end
