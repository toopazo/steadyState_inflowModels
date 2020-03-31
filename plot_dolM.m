function plot_dolM(...
    nfig            , ...
    linspec         , ...
    psi_arr         , ...
    dolMxpsi_arr    , ...
    dolMypsi_arr    , ...
    dolMzpsi_arr      ...
    )   

    fig = figure(nfig);
    
    subplot(3, 1, 1)
    hold on;
    grid on;
    plot(rad2deg(psi_arr), dolMxpsi_arr, linspec);
    arg = [ 'Total dolMx(\psi) distribution along r [0, 1]' ]; %, total Q = ' num2str(Q) ];
    title(arg);
    xlabel('Azimuth \psi deg');
    ylabel('Momentum Nm');
    
    subplot(3, 1, 2)
    hold on;
    grid on;
    plot(rad2deg(psi_arr), dolMypsi_arr, linspec);
    arg = [ 'Total dolMy(\psi) distribution along r [0, 1]' ]; %, total Q = ' num2str(Q) ];
    title(arg);
    xlabel('Azimuth \psi deg');
    ylabel('Momentum Nm');
    
    subplot(3, 1, 3)
    hold on;
    grid on;
    plot(rad2deg(psi_arr), dolMzpsi_arr, linspec);
    arg = [ 'Total dolMz(\psi) distribution along r [0, 1]' ]; %, total Q = ' num2str(Q) ];
    title(arg);
    xlabel('Azimuth \psi deg');
    ylabel('Momentum Nm');        

end
