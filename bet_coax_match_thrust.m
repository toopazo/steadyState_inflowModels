function [blade_u_st, blade_l_st] = bet_coax_match_thrust(...
    blade_u_st, blade_l_st, T_u_target, T_l_target)

    options = optimset('Display','off');
    xguess = [blade_u_st.omega; blade_l_st.omega];
    x0 = fsolve(@funzero, xguess, options);
    
    err = funzero(x0);
    if norm(err) > 10^(-4)
        disp('bet_coax_match_thrust')
        disp('norm(err) > 10^-4')
        blade_u_st = NaN
        blade_l_st = NaN
    end    
    
    blade_u_st.omega      = x0(1);
    blade_u_st.Vtip       = blade_u_st.omega*blade_u_st.R;
    blade_l_st.omega      = x0(2);
    blade_l_st.Vtip       = blade_l_st.omega*blade_l_st.R;         
   
    function err = funzero(x)
        blade_u_st.omega      = x(1);
        blade_u_st.Vtip       = blade_u_st.omega*blade_u_st.R;
        blade_l_st.omega      = x(2);
        blade_l_st.Vtip       = blade_l_st.omega*blade_l_st.R;         
        
        [T_u, Q_u, P_u, lambda_u, T_l, Q_l, P_l, lambda_l] = ...
            bet_coax_forces(blade_u_st, blade_l_st); % blade_type, lambda_c, mu, omega_u, omega_l);
                
        err_u = T_u - T_u_target;
        err_l = T_l - T_l_target;
        err = [err_u; err_l];
    end
end
