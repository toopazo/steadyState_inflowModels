function bet_forces_plot(...
    r_arr           , ...
    psi_arr         , ...
    dT_arr          , ...
    dQ_arr          , ...
    dP_arr          , ...    
    lambdai_arr       ...
    )
    
    [dTr_arr, dQr_arr, dPr_arr, dTpsi_arr, dQpsi_arr, dPpsi_arr] = ...
        bet_forces_along(dT_arr, dQ_arr, dP_arr);            
        
    fig = figure(1);
    hold on;
    plot(r_arr, dTr_arr, '-*');
    arg = [ 'mean T(r) distribution along \psi' ]; %, total T = ' num2str(T) ];
    title(arg);
    xlabel('radius');
    ylabel('Thrust N');
    legend('type I', 'type II', 'type III', 'Location','northwest');
    grid on;
    saveas(fig, 'img/hover_bet_forces_plot_1.jpg')
    % pause(2)    

    fig = figure(2);
    hold on;
    plot(r_arr, dQr_arr, '-*');
    arg = [ 'mean Q(r) distribution along \psi' ]; %, total Q = ' num2str(Q) ];
    title(arg);
    xlabel('radius');
    ylabel('torque N');
    legend('type I', 'type II', 'type III', 'Location','northwest');
    grid on;
    saveas(fig, 'img/hover_bet_forces_plot_2.jpg')
    % pause(2)
    
    fig = figure(3);
    hold on;
    plot(r_arr, dPr_arr, '-*');
    arg = [ 'mean P(r) distribution along \psi' ]; %, total P = ' num2str(P) ];
    title(arg);
    xlabel('radius');
    ylabel('power W');
    legend('type I', 'type II', 'type III', 'Location','northwest');
    grid on;
    saveas(fig, 'img/hover_bet_forces_plot_3.jpg')
    % pause(2)
    
    fig = figure(4);
    hold on;
    [X, Y] = meshgrid(r_arr, rad2deg(psi_arr));
    surf(X, Y, lambdai_arr)
    surf(X, Y, lambdai_arr.*0)  % plot zero surface
    % plot_my_3d(psi_arr, r_arr, lambdai_arr)
    % arg = [ 'mean \lambda_i(r) distribution along \psi' ];
    arg = [ '\lambda_i(\psi, r) distribution' ];
    title(arg);
    xlabel('radius');
    ylabel('\psi deg');
    zlabel('induced inflow');
    view(40, 35);
    % legend('type I', 'type II', 'type III', 'Location','northwest');
    grid on;
    saveas(fig, 'img/hover_bet_forces_plot_4.jpg');
    % pause(2)           
   
    function plot_my_3d(psi_arr, r_arr, lambdai_arr)
        num_dr = length(r_arr)
        num_dpsi = length(psi_arr)
        
        for i = 1:num_dpsi              
            for j = 1:num_dr
                hold on;
                % scatter3(r_arr(j), rad2deg(psi_arr(i)), lambdai_arr(i, j));
                plot3(r_arr(j), rad2deg(psi_arr(i)), lambdai_arr(i, j), '-*');
            end
        end     
    end
    
end
