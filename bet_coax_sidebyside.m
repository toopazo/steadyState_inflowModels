function ...
    [T_u, Q_u, P_u, lambda_u, T_l, Q_l, P_l, lambda_l] = ...
        bet_coax_sidebyside(blade_type, lambda_c, mu, omega_u, omega_l)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    blade_u_st = blade_model(blade_type, lambda_c, mu, false);
    
    
    blade_u_st.omega                = omega_u;
    blade_u_st.Vtip                 = blade_u_st.omega*blade_u_st.R;          
    
    bet_u_st = bet_forces(blade_u_st);
    bet_u_st = bet_forces_add_total(bet_u_st, false);

    T_u = bet_u_st.total.T;
    Q_u = bet_u_st.total.Q;
    P_u = bet_u_st.total.P;
    % lambda_c_u = bet_u_st.total.lambda_c    % at hover this is == zero
    % lambda_i_u = bet_u_st.total.lambda_i    % at hover this is == lambda
    lambda_u = bet_u_st.total.lambda;    
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    blade_l_st = blade_model(blade_type, lambda_c, mu, false);
    
    
    blade_l_st.omega                = omega_l;
    blade_l_st.Vtip                 = blade_l_st.omega*blade_l_st.R;  
    
    bet_l_st = bet_forces(blade_l_st);
    bet_l_st = bet_forces_add_total(bet_l_st, false);
    
    T_l = bet_l_st.total.T;
    Q_l = bet_l_st.total.Q;
    P_l = bet_l_st.total.P;
    % lambda_c_l = bet_l_st.total.lambda_c    % at hover this is == zero
    % lambda_i_l = bet_l_st.total.lambda_i    % at hover this is == lambda
    lambda_l = bet_l_st.total.lambda;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    res = [T_u, Q_u, P_u, lambda_u, T_l, Q_l, P_l, lambda_l];
end

