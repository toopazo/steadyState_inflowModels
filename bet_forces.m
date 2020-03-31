function bet_st = bet_forces(blade_st)
    
%    [...
%        psi_arr         , ...
%        r_arr           , ...
%        T_arr           , ...
%        Q_arr           , ...        
%        lambda_i_arr      ...
%    ] = bet_forces(...        
%        blade_st          ...
%    )    
    
%    @book{leishman2006principles,
%      title={Principles of helicopter aerodynamics with CD extra},
%      author={Leishman, Gordon J},
%      year={2006},
%      publisher={Cambridge university press}
%    }

    % blade_st parameters
    Nb          = blade_st.Nb;
    R           = blade_st.R;
    rho         = blade_st.rho;
    omega       = blade_st.omega;
    Cla         = blade_st.Cla;      
    Cd0         = blade_st.Cd0;
    d1          = blade_st.d1;
    d2          = blade_st.d2; 
    b0          = blade_st.b0;
    b1c         = blade_st.b1c;
    b1s         = blade_st.b1s; 
    lambda_c    = blade_st.lambda_c;
    mu          = blade_st.mu;
    CT_target   = blade_st.CT_target;
    nsections   = blade_st.nsections;

    dr = 1.0 / nsections;
    num_dr = nsections;
    % blade_st.r_arr    = 0     1     2     3
    % r_arr             =   0.5   1.5   2.5 
    r_arr = linspace(dr, 1, num_dr) - dr/2;
    
    dpsi =  deg2rad(360) / ( nsections );
    num_dpsi = nsections;
    psi_arr = linspace(0, 2*pi-dpsi, num_dpsi);
    % psi_arr = [ 0, 22.5, 45.0, .. 315.0, 337.5 ]
    % psi_arr = deg2rad( linspace(0, 360-22.5, 16) );
    % num_dpsi = size(psi_arr, 2);
    
    T_arr = zeros(num_dpsi, num_dr);
    Q_arr = zeros(num_dpsi, num_dr);
    P_arr = zeros(num_dpsi, num_dr);
    
    lambda_i_arr = zeros(num_dpsi, num_dr);
        
    for i = 1:num_dpsi
        psi = psi_arr(i);        
        for j = 1:num_dr
            r = r_arr(j);
            
            % 1) Interpolate sectional blade values
            % c         = blade chord
            % theta     = blade pitch        
            % sigma     = blade solidity   
            c       = interp1(blade_st.r_arr, blade_st.c_arr, r, 'linear');            
            sigma   = interp1(blade_st.r_arr, blade_st.sigma_arr, r, 'linear');
            theta   = interp1(blade_st.r_arr, blade_st.theta_arr, r, 'linear');                         
        
            % TODO coaxial modofication
            if isfield(blade_st,'position')
                if blade_st.position == 'lower';
                    if r <= 0.5;
                        lambda_c = blade_st.lambda_u_downwash;
                    end
                end
            end
            
            % 2) Inflow model is selected according to adv ratio mu
            % psi       = azimuth angle
            % r         = normalized radial distance
            % mu        = advance ratio 
            % lambda_c  = climb velocity ratio ( Vc / omega R )
            % sigma     = blade solidity
            % Cla       = lift-curve slope
            % theta     = blade pitch   
            % CT_target  = thrust coeff guess for mu > 0 algorithms            
            [...
                lambda          , ...
                lambda_i        , ...
                lambda_c          ...
            ] = bet_forces_inflow(...
                psi, r, mu, lambda_c, sigma, Cla, theta, CT_target);
            
            % 3) Sectional angle of attack = theta - phi
            % phi = U_P / U_T
            % U_T = omega y 
            % U_P = Vc + vi
            % phi = Vc + vi / omega R = lambda r
            alpha = ( theta - lambda/r );
            
            % 4) Blade motion
            % b0        = Blade conning angle
            % b1c       = blade flapping associated with cos(psi)
            % b1s       = blade flapping associated with sin(psi)
            % omega     = RPM
            beta =  b0 + b1c*cos(psi) + b1s*sin(psi);
            betadot = omega * (-b1c*sin(psi) + b1s*cos(psi) );
                          
            % 5) Sectional coeff of drag
            % Cd0       = coeff of drag associated with alpha^0
            % d1        = coeff of drag associated with alpha^1
            % d2        = coeff of drag associated with alpha^2
            Cd = Cd0 + d1*alpha + d2*alpha^2;             
            
            % 6) Calculate UT UP UR
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

            % Dimentional radius location
            y = r * R;            
            dy = dr * R;
            
            % 7) Calculate dT dQ
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
            
            % 8) Integrate along dpsi
            % Section d(i, j) = d(psi, r) are integrated assuming that 
            % dT(psi, r) and dQ(psi, r) remain constant along dy and dpsi
            % This is the same as rectangular integration
            T_arr(i, j) = dT * dpsi;
            Q_arr(i, j) = dQ * dpsi;
            P_arr(i, j) = dP * dpsi;            
            lambda_i_arr(i, j) = lambda_i;
        end
    end       
    
    % Put results into bet_st
    bet_st.blade_st     = blade_st;
    bet_st.psi_arr      = psi_arr;
    bet_st.r_arr        = r_arr;
    bet_st.T_arr        = T_arr;
    bet_st.Q_arr        = Q_arr;
    bet_st.lambda_i_arr = lambda_i_arr;
     
end
