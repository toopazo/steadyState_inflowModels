# steadyState_inflowModels
Software implementation of static (steady state) inflow model for a rotor in hover (BEMT) and forward flight (Glauert approximation)

![alt text](https://github.com/toopazo/steadyState_inflowModels/blob/master/img/bet_forces_plot_4.jpg)


## Simple run
bet_main.m

# Little explanaition

The force integration is performed by bet_forces.m 

In MATLAB this is written as 
[...
    r_arr           , ...
    psi_arr         , ...
    dT_arr          , ...
    dQ_arr          , ...
    dP_arr          , ...    
    lambda_i_arr       ...
    ] = bet_forces(lambda_c, mu, blade_st, CT_guess)

Where the main outputs are 
- dT(psi, r)
- dQ(psi, r)
- dP(psi, r)

Sectional thrust, torque and power at different azimuth angles psi and along the radial section r

These are integrated by bet_forces_along(dT_arr, dQ_arr, dP_arr)
to produce [Tr, Qr, Pr, Tpsi, Qpsi, Ppsi]

- Tr(r) = dT averaged over psi
- Qr(r) = dQ averaged over psi
- Pr(r) = dP averaged over psi

Total values are then 
T = sum(Tr)
Q = sum(Qr)
P = sum(Pr)

- Tpsi(psi) = dT added up along r
- Qpsi(psi) = dQ added up along r
- Ppsi(psi) = dP added up along r

