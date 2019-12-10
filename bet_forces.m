function [...
    r_arr           , ...
    psi_arr         , ...
    dT_arr          , ...
    dQ_arr          , ...
    dP_arr          , ...    
    lambda_i_arr       ...
    ] = bet_forces(lambda_c, mu, blade_st, CT_guess)
    
%    @book{leishman2006principles,
%      title={Principles of helicopter aerodynamics with CD extra},
%      author={Leishman, Gordon J},
%      year={2006},
%      publisher={Cambridge university press}
%    }
    
    dpsi = deg2rad(10);
    num_dpsi = 2*pi / dpsi;
    psi_arr = linspace(0, 2*pi-dpsi, num_dpsi);
    
    dr = 0.1;
    num_dr = 1/dr;
    r_arr = linspace(dr, 1, num_dr) - dr/2;
    
    dT_arr = zeros(num_dpsi, num_dr);
    dQ_arr = zeros(num_dpsi, num_dr);
    dP_arr = zeros(num_dpsi, num_dr);
    
    lambda_i_arr = zeros(num_dpsi, num_dr);
    
    % rotor parameters
    Nb = blade_st.Nb;
    R = blade_st.R;
    rho = blade_st.rho;
    omega = blade_st.omega;
        
    for i = 1:num_dpsi
        psi = psi_arr(i);        
        for j = 1:num_dr
            r = r_arr(j);
            
            % interpolate sectional blade values
            % c         = blade chord
            % theta     = blade pitch        
            % sigma     = blade solidity   
            c       = interp1(blade_st.r_arr, blade_st.c_arr, r, 'linear');            
            sigma   = interp1(blade_st.r_arr, blade_st.sigma_arr, r, 'linear');
            theta   = interp1(blade_st.r_arr, blade_st.theta_arr, r, 'linear');        
        
            % inflow according to BET and Glauert
            if (mu >= 0.15)
                kx = 1.2;                
                % tan(TPP_alpha) = lambda_c / mu
                TPP_alpha = atan(lambda_c / (mu+10^-6)); 
                % lambda_i from MT
                lambda_MT = mt_inflow(CT_guess, mu, TPP_alpha);
                lambda_0 = lambda_MT - lambda_c;
                % Glauert approximation
                lambda_i = lambda_0 * ( 1 + kx*r*cos(psi) );
                % total inflow            
                lambda = lambda_c + lambda_i;
            end
            % inflow according to BEMT = (BET + MT + mu=0 )
            if (mu <= 0.01)
                [lambda, lambda_i] = bemt_inflow(...
                    sigma, blade_st.Cla, theta, r, lambda_c); 
            end        
            
            % sectional angle of attack = theta - phi
            alpha = ( theta - lambda/r );
            
            % flapping
            beta = 0;
            betadot = 0;
            
            % r         = normalized radial distance
            % lambda    = inflow = lambda_c + lambda_i
            % mu        = advance ratio 
            % beta      = flapping angle
            % betadot   = flapping angle derivative
            % psi       = azimuth angle
            % omega     = RPM
            % R         = rotor radius
            [UT UP UR] = bet_UT_UP_UR(...
                r, lambda, mu, beta, betadot, psi, omega, R);
                
            % sectional lift-curve slope
            Cla = blade_st.Cla;
                
            % sectional coeff of drag
            Cd = blade_st.Cd0 + blade_st.d1*alpha + blade_st.d2*alpha^2;            
            
            y = r * R;            
            dy = dr * R;
            
            % UT        = vel normal to blade section
            % UP        = vel perpendicular to blade section
            % UR        = vel radial to blade section    
            % c         = blade chord     
            % Cla       = lift-curve slope
            % Cd        = coeff of drag
            % theta     = blade pitch          
            % Nb        = number of blades
            % rho       = air density        
            % omega     = RPM
            % y         = radial distance = r * R 
            % dy        = radial section distance = dr * R    
            [dT dQ dP] = bet_dT_dQ_dP(...
                UT, UP, UR, c, Cla, Cd, theta, Nb, rho, omega, y, dy);
            
            % (psi, r)
            dT_arr(i, j) = dT;
            dQ_arr(i, j) = dQ;
            dP_arr(i, j) = dP;
            
            lambda_i_arr(i, j) = lambda_i;
        end
    end        
end
