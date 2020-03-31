function bet_st = bet_forces_add_total(bet_st, verbose)
    
    % Unpack bet_forces results
    blade_st        = bet_st.blade_st;
    psi_arr         = bet_st.psi_arr;
    r_arr           = bet_st.r_arr;
    T_arr           = bet_st.T_arr;
    Q_arr           = bet_st.Q_arr;
    lambda_i_arr    = bet_st.lambda_i_arr;
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Net produced thrust, torque and power
    Tr_arr      = bet_forces_mean_along_dpsi(T_arr);
    Qr_arr      = bet_forces_mean_along_dpsi(Q_arr);
    
    % A blade produces lift at all r, but only during one psi at a time      
    % Therefore, this is wrong
    % T = sum(T_arr, 'all'); 
    % Q = sum(Q_arr, 'all');
    % And this ir right
    T = sum(Tr_arr);    % Sum of avgerage of T(psi, r) along psi
    Q = sum(Qr_arr);    % Sum of avgerage of Q(psi, r) along psi    
    P = Q * blade_st.omega;

    percT = T / blade_st.Thover * 100;
    percQ = Q / ( blade_st.Pavail / blade_st.omega ) * 100;
    percP = P / blade_st.Pavail * 100;
    
    CT = T / ( blade_st.rho * blade_st.rotArea * blade_st.Vtip^2 );
    CQ = Q / ( blade_st.rho * blade_st.rotArea * blade_st.Vtip^2 * blade_st.R );
    CP = CQ;    % CQ == CP    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Inflow    
    lir_arr     = bet_forces_mean_along_dpsi(lambda_i_arr);
    
    lambda_c    = bet_st.blade_st.lambda_c;
    lambda_i    = mean(lir_arr);    % Avgerage of { avgerage of li(psi, r) along psi } along r
    lambda      = lambda_c + lambda_i;    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Net dissymmetry of lift moment
    [dolMxpsi_arr, dolMypsi_arr, dolMzpsi_arr] = bet_forces_dolM(bet_st);
    
    mean_dolMx = mean(dolMxpsi_arr);
    mean_dolMy = mean(dolMypsi_arr);
    mean_dolMz = mean(dolMzpsi_arr);
             
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                   
    % Add to total bet_st
    bet_st.total.T = T; 
    bet_st.total.Q = Q;
    bet_st.total.P = P;
    
    bet_st.total.percT = percT; 
    bet_st.total.percQ = percQ;
    bet_st.total.percP = percP;  
      
    bet_st.total.CT = CT;
    bet_st.total.CQ = CQ;      
    bet_st.total.CP = CP;   
    
    bet_st.total.lambda_c   = lambda_c;
    bet_st.total.lambda_i   = lambda_i;
    bet_st.total.lambda     = lambda;
     
    bet_st.total.mean_dolMx = mean_dolMx;
    bet_st.total.mean_dolMy = mean_dolMy;
    bet_st.total.mean_dolMz = mean_dolMz;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 4) Print
    if verbose    
        % Print blade type
        fprintf('%s \n', blade_st.blade_type);
        
        % Angular speed
        fprintf('  Omega = %.2f rad/s, Vtip = %.2f m/s \n', ...
            blade_st.omega, blade_st.Vtip );
      
        % Print net produced Thrust and Torque 
        fprintf('  T %.2f N, Q %.2f Nm, P = %.2f \n', T, Q, P);
        fprintf('  percThover = %.2f, percPhover = %.2f \n', percT, percP);    
        fprintf('  CT %.4f, CQ %.4f \n', CT, CQ);   
        
        % Print net dissymmetry of lift moment
        fprintf('  Mean dolM about psi [0, 2 pi] is [%.2f; %.2f; %.2f] \n', ...
            mean_dolMx, mean_dolMy, mean_dolMz);  
    end
end
