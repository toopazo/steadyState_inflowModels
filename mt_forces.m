function [T, Q, lambda_i] = mt_forces(blade_st)

    % Blade properties are assummed to be constant
    alpha       = blade_st.TPP_alpha;
    CT_target   = blade_st.CT_target;
    mu          = blade_st.mu;
    lambda_c    = blade_st.lambda_c;
    omega       = blade_st.omega;
    R           = blade_st.R;
    rho         = blade_st.rho;
    A           = blade_st.rotArea;
    Vtip        = blade_st.Vtip;
        
%    % In case the calculated CT_mt is different from the initially 
%    % assumed CT_target, we need to change that assumption until 
%    % the error is zero        
%    options = optimset('Display','off');
%    x0 = CT_target;
%    x0 = fsolve(@funzero, x0, options);
%    err = funzero(x0);
%    
%    CT = x0;
    CT = CT_target;
    
    % 1) Calculate inflow and induced inflow
    lambda = mt_inflow(CT, mu, alpha, Vtip, lambda_c);    
    lambda_i = lambda - lambda_c;
    
    % 2) Calculate thrust and torque
    [T, Q] = mt_T_Q(lambda, blade_st); 
    
    function err = funzero(x)
        CT = x;
    
        % 1) Calculate inflow and induced inflow
        lambda = mt_inflow(CT, mu, alpha, Vtip, lambda_c);    
        lambda_i = lambda - lambda_c;
        
        % 2) Calculate thrust and torque 
        [T_mt, Q_mt] = mt_T_Q(lambda, blade_st);
        
        % 3) Calculate thrust and torque coeff
        CT_mt = T_mt / ( rho * A * Vtip^2 );
        CQ_mt = Q_mt / ( rho * A * Vtip^2 * R );
        
        % 4) Calculate CT_err = CT - CT_expos
        CT_err = CT - CT_mt;
        
        err = CT_err;
    end
    
end
