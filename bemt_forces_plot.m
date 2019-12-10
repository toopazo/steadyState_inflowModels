function bemt_forces_plot(r_arr, dT_arr, dQ_arr, dP_arr, lambda_i_arr)
    
    T = sum(dT_arr)    
    Q = sum(dQ_arr)    
    P = sum(dP_arr)
    
    fig = figure(1);
    hold on;
    plot(r_arr, dT_arr, '-*');
    arg = [ 'T(r) distribution' ]; %, total T = ' num2str(T) ];
    title(arg);
    xlabel('radius ');
    ylabel('thrust N');
    % legend('BEMT', 'theory')
    grid on;
    saveas(fig, 'bemt_forces_plot_1.jpg')
    % pause(2)
    
    fig = figure(2);
    hold on;
    plot(r_arr, dQ_arr, '-*');
    arg = [ 'Q(r) distribution' ]; %, total Q = ' num2str(Q) ];
    title(arg);
    xlabel('radius ');
    ylabel('torque N');
    % legend('BEMT', 'theory')
    grid on;
    saveas(fig, 'bemt_forces_plot_2.jpg')
    % pause(2)
    
    fig = figure(3);
    hold on;
    plot(r_arr, dP_arr, '-*');
    arg = [ 'P(r) distribution' ]; %, total P = ' num2str(P) ];
    title(arg);
    xlabel('radius ');
    ylabel('power W');
    % legend('BEMT', 'theory')
    grid on;
    saveas(fig, 'bemt_forces_plot_3.jpg')
    % pause(2)
    
    fig = figure(4);
    hold on;
    plot(r_arr, lambda_i_arr, '-*');
    arg = [ '\lambda_i(r) distribution' ];
    title(arg);
    xlabel('radius ');
    ylabel('induced inflow ');
    % legend('BEMT', 'theory')
    grid on;
    saveas(fig, 'bemt_forces_plot_4.jpg')
    % pause(2)    
    
end
