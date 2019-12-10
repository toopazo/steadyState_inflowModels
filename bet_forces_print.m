function bet_st = bet_forces_print(...
    ...% r_arr           , ...
    ...% psi_arr         , ...
    dT_arr          , ...
    dQ_arr          , ...
    dP_arr          , ...    
    lambdai_arr     , ...
    blade_st          ...
    )

    [dTr_arr, dQr_arr, dPr_arr, dTpsi_arr, dQpsi_arr, dPpsi_arr] = ...
        bet_forces_along(dT_arr, dQ_arr, dP_arr);    
        
    T = sum(dTr_arr);
    Q = sum(dQr_arr);
    P = sum(dPr_arr);
    fprintf('T %.2f, Q %.2f, P %.2f \n', T, Q, P);
    
    rho = blade_st.rho;
    omega = blade_st.omega;
    R = blade_st.R;
    
    % convert from coeff form to total values
    A = pi*R^2;
    Vtip = omega*R;
    
    CT = T / ( rho*A*Vtip^2 );
    CQ = Q / ( rho*A*Vtip^2*R );
    CP = P / ( rho*A*Vtip^3 );
    fprintf('CT %.4f, CQ %.4f, CP %.4f \n', CT, CQ, CP);
    
    bet_st.A = A;
    bet_st.Vtip = Vtip; 

    bet_st.T = T; 
    bet_st.Q = Q; 
    bet_st.P  = P; 

    bet_st.CT = CT;
    bet_st.CQ = CQ;
    bet_st.CP = CP;    
end
