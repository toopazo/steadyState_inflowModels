function ...
    [T_u, Q_u, P_u, lambda_u_arr, T_l, Q_l, P_l, lambda_l_arr] = ...
        bet_coax_forces(blade_u_st, blade_l_st)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    blade_u_st.position     = 'upper';
    blade_u_st.lambda_u_arr = NaN;          % not yet known
    
    bet_u_st = bet_forces(blade_u_st);
    bet_u_st = bet_forces_add_total(bet_u_st, false);

    T_u = bet_u_st.total.T;
    Q_u = bet_u_st.total.Q;
    P_u = bet_u_st.total.P;  

    lir_arr         = bet_forces_mean_along_dpsi(bet_u_st.lambda_i_arr);
    lambda_u_arr    = blade_u_st.lambda_c + lir_arr;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    blade_l_st.position     = 'lower';
    blade_l_st.lambda_u_arr = lambda_u_arr; % now is known
    
    bet_l_st = bet_forces(blade_l_st);
    bet_l_st = bet_forces_add_total(bet_l_st, false);
    
    T_l = bet_l_st.total.T;
    Q_l = bet_l_st.total.Q;
    P_l = bet_l_st.total.P;  
    
    lir_arr         = bet_forces_mean_along_dpsi(bet_l_st.lambda_i_arr);
    lambda_l_arr    = blade_l_st.lambda_c + lir_arr; 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % res = [T_u, Q_u, P_u, lambda_u_arr, T_l, Q_l, P_l, lambda_l_arr];
end

