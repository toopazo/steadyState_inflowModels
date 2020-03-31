function plot_bet_st(bet_st, reset_cnt)    

    persistent cnt
    if isempty(cnt)
        cnt = 0;
    end
    if reset_cnt
        cnt = 0;
%        disp('reset_cnt is true')
%        cnt
    end
    
    cnt = cnt + 1;
    switch cnt
        case 1
            linspec = '-b*';
        case 2
            linspec = '-r*';
        case 3
            linspec = '-y*';
        otherwise
            disp('cnt is out of bound')
            cnt
            linspec = NaN;
    end

    % Unpack bet_forces results
    blade_st        = bet_st.blade_st;
    psi_arr         = bet_st.psi_arr;
    r_arr           = bet_st.r_arr;
    T_arr           = bet_st.T_arr;
    Q_arr           = bet_st.Q_arr;
    lambda_i_arr    = bet_st.lambda_i_arr;    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 1) Calculate net produced Thrust and Torque
    Tr_arr      = bet_forces_mean_along_dpsi(T_arr);
    Qr_arr      = bet_forces_mean_along_dpsi(Q_arr);
    lir_arr     = bet_forces_mean_along_dpsi(lambda_i_arr);

        
    fig = figure(1);
    hold on;
    grid on;
    plot(r_arr, Tr_arr, '-*');
    arg = [ 'Mean T(r) distribution about \psi [0, 2 pi]' ]; %, total T = ' num2str(T) ];
    title(arg);
    xlabel('Radius');
    ylabel('Thrust N');

    fig = figure(2);
    hold on;
    grid on;
    plot(r_arr, Qr_arr, '-*');
    arg = [ 'Mean Q(r) distribution about \psi [0, 2 pi]' ]; %, total Q = ' num2str(Q) ];
    title(arg);
    xlabel('Radius');
    ylabel('Torque Nm');
    
    fig = figure(3);
    hold on;
    grid on;
    plot(r_arr, lir_arr, '-*');
    arg = [ 'Mean \lambda_i(r) distribution about \psi [0, 2 pi]' ]; %, total Q = ' num2str(Q) ];
    title(arg);
    xlabel('Radius');
    ylabel('Induced inflow');
    
    fig = figure(4);
    hold on;    
    [X, Y] = meshgrid(r_arr, rad2deg(psi_arr));    
    surf(X, Y, lambda_i_arr);        
    surf(X, Y, lambda_i_arr.*0); %), 'FaceAlpha',0.5,'EdgeColor','none')  % plot zero surface
    arg = [ '\lambda_i(\psi, r) distribution' ];
    title(arg);
    xlabel('Radius');
    ylabel('\psi deg');
    zlabel('induced inflow');
    view(35, 35);
    grid on;     

    nfig = 5;
    fig = figure(nfig);
    hold on;    
    grid on;       
    [X, Y] = plot3D_polar(nfig, linspec, psi_arr, r_arr, lambda_i_arr);       
    arg = [ '\lambda_i(\psi, r) distribution' ];
    title(arg);
    xlabel('x axis');
    ylabel('y axis');
    zlabel('induced inflow');  
    
    nfig = 6;
    fig = figure(nfig);
    hold on;  
    grid on;  
    [X, Y] = plot3D_polar(nfig, linspec, psi_arr, r_arr, T_arr);    
    arg = [ 'Thrust(\psi, r) distribution' ];
    title(arg);
    xlabel('x axis');
    ylabel('y axis');
    zlabel('Thrust');
    
    nfig = 7;
    [dolMxpsi_arr, dolMypsi_arr, dolMzpsi_arr] = bet_forces_dolM(bet_st);    
    plot_dolM(nfig, linspec, psi_arr, dolMxpsi_arr, dolMypsi_arr, dolMzpsi_arr);
    
    nfig1 = 8;
    nfig2 = 9;
    plot_blade_st(nfig1, nfig2, blade_st);
             
end
