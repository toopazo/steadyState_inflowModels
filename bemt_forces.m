function [...
    r_arr           , ...
    dT_arr          , ...
    dQ_arr          , ...
    dP_arr          , ...
    lambda_i_arr      ...
    ] = bemt_forces(lambda_c, mu, blade_st, rho, omega)

%    @book{leishman2006principles,
%      title={Principles of helicopter aerodynamics with CD extra},
%      author={Leishman, Gordon J},
%      year={2006},
%      publisher={Cambridge university press}
%    }   
    
    dr = 0.1;
    num_dr = 1/dr;
    r_arr = linspace(dr, 1, num_dr) - dr/2;
    
    dT_arr = zeros(1, num_dr);
    dQ_arr = zeros(1, num_dr);
    dP_arr = zeros(1, num_dr);

    lambda_i_arr = zeros(1, num_dr);
      
    for j = 1:num_dr
        r = r_arr(j);
        
        % interpolate sectional blade values
        % c         = blade chord
        % theta     = blade pitch        
        % sigma     = blade solidity        
        % vq = interp1(x,v,xq,method)
        % where x = r_arr and y = v_arr
        c       = interp1(blade_st.r_arr, blade_st.c_arr, r, 'linear');            
        sigma   = interp1(blade_st.r_arr, blade_st.sigma_arr, r, 'linear');
        theta   = interp1(blade_st.r_arr, blade_st.theta_arr, r, 'linear');
        
        % inflow
        [lambda, lambda_i] = bemt_inflow(sigma, blade_st.Cla, theta, r, lambda_c);
        
        % sectional angle of attack = theta - phi
        alpha = ( theta - lambda/r );
        
        % sectional coeff of lift 
        Cl = blade_st.Cla * alpha;

        % sectional coeff of drag
        Cd = blade_st.Cd0 + blade_st.d1*alpha + blade_st.d2*alpha^2;            
        
        phi = lambda / r;
        [dCT dCQ dCP] = bemt_dCT_dCQ_dCP(sigma, phi, Cl, Cd, r, dr);
        
        % convert from coeff form to total values
        A = pi*blade_st.R^2;
        Vtip = omega*blade_st.R;
              
        % (psi, r)
        dT_arr(1, j) = ( rho*A*Vtip^2 ) * dCT;
        dQ_arr(1, j) = ( rho*A*Vtip^2*blade_st.R ) * dCQ;
        dP_arr(1, j) = ( rho*A*Vtip^3 ) * dCP;
        
        lambda_i_arr(1, j) = lambda_i;
    end           
end
