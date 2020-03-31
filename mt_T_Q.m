function [T, Q] = mt_T_Q(lambda, blade_st)

    mu          = blade_st.mu;
    lambda_c    = blade_st.lambda_c;
    omega       = blade_st.omega;
    R           = blade_st.R;
    rho         = blade_st.rho;
    A           = blade_st.rotArea;

    lambda_i = lambda - lambda_c;    
    
    T = 2*rho*A*( omega*R *sqrt(lambda^2 + mu^2) )*(omega*R*lambda_i);
    Q = T * lambda * R;

    
end
