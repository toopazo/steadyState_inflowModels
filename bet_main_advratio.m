function bet_main_advratio()

    clear all
    close all
    format compact
    clc

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    lambda_c = 0;
    mu = 0;
    blade_st = blade_model('constant_twist_blade', lambda_c, mu, false);

    lambda_c_arr = linspace(0, 0.1, 4);
    mu_arr = linspace(0, 0.5, 20);

    nfig11 = 11;
    nfig12 = 12;
    figure(nfig11);
    figure(nfig12);

    for j = 1:length(lambda_c_arr)
        for i = 1:length(mu_arr)
        
            blade_st = blade_model('constant_twist_blade', ...
                lambda_c_arr(j), mu_arr(i), false);
            
%            % Modify airflow properties
%            blade_st.lambda_c   = lambda_c_arr(j);
%            blade_st.mu         = mu_arr(i);
%            blade_st.CT_target  = blade_st.Thover / blade_st.normf;
%            blade_st.TPP_alpha  = atan( (blade_st.lambda_c + 10^-6) / (blade_st.mu) );  % atan(1/0) = 90 deg
%            blade_st.TPP_alphad = rad2deg(blade_st.TPP_alpha); 
            
            % Calculate thrust, torque and inflow
            bet_st = bet_forces(blade_st);
            bet_st = bet_forces_add_total(bet_st, false);
            
            % Save variables
            TPP_alpha_arr(i)    = blade_st.TPP_alpha;
            T_arr(i)            = bet_st.total.T;
            Q_arr(i)            = bet_st.total.Q;
            lambda_arr(i)       = bet_st.total.lambda;
            lambda_i_arr(i)     = bet_st.total.lambda_i;        
        end     
        
         % Save label for this case
        switch j
            case 1
                lbl_1 = ['\lambda_c = ' num2str(blade_st.lambda_c)];
            case 2
                lbl_2 = ['\lambda_c = ' num2str(blade_st.lambda_c)];
            case 3
                lbl_3 = ['\lambda_c = ' num2str(blade_st.lambda_c)];
            case 4
                lbl_4 = ['\lambda_c = ' num2str(blade_st.lambda_c)];
            case 5       
                lbl_5 = ['\lambda_c = ' num2str(blade_st.lambda_c)];
        end
       
        figure(nfig11)
        subplot(3, 1, 1)
        hold on;
        grid on;
        plot(mu_arr, lambda_arr, '-*');
        % plot(mu_arr, lambda_arr./lambda_h, '-*');   
        ylabel('Inflow \lambda');
        xlabel('Advance ratio \mu');
        ylim([0, 0.2]);

        subplot(3, 1, 2)
        hold on;
        grid on;
        plot(mu_arr, lambda_i_arr, '-*');
        ylabel('Induced inflow \lambda_i');
        xlabel('Advance ratio \mu');  
        ylim([0, 0.1]);
        
        subplot(3, 1, 3)
        hold on;
        grid on;
        plot(mu_arr, rad2deg(TPP_alpha_arr), '-*');
        ylabel('Angle of attack \alpha');
        xlabel('Advance ratio \mu');
        ylim([0, 90]);
        
        figure(nfig12)
        subplot(2, 1, 1)
        hold on;
        grid on;
        plot(mu_arr, T_arr, '-*');
        ylabel('Thrust N');
        xlabel('Advance ratio \mu');
        ylim([0, 2*10^5]);
        
        subplot(2, 1, 2)
        hold on;
        grid on;
        plot(mu_arr, Q_arr, '-*');
        ylabel('Torque Nm');
        xlabel('Advance ratio \mu'); 
        ylim([0, 1*10^5]); 
       
    end
    
    % Add legend and save
    str1 = 'bet_main_advratio';
    str2  ='';

    fig = figure(nfig11);
    sgtitle('BET at constant climb inflow');
    subplot(3, 1, 2);
    legend(lbl_1, lbl_2, lbl_3, lbl_4, 'Location', 'best'); % , lbl_5);
    set(fig,'units','centimeters','position',[0, 0, 20, 10]);
    filename = ['img/' str1 '_' str2 '_' num2str(nfig11) '.jpg'];
    pause(10);
    saveas(fig, filename);

    fig = figure(nfig12);
    sgtitle('BET at constant climb inflow');
    subplot(2, 1, 1);
    legend(lbl_1, lbl_2, lbl_3, lbl_4, 'Location', 'best'); % , lbl_5);
    set(fig,'units','centimeters','position',[0, 0, 20, 10]);
    filename = ['img/' str1 '_' str2 '_' num2str(nfig12) '.jpg'];    
    pause(10);
    saveas(fig, filename);

    close all;
    return
end
