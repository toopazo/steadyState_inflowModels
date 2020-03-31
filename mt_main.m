clear
clc
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
blade_st = blade_model('constant_twist_blade');

% Modify airflow properties
blade_st.lambda_c   = 0.0;
blade_st.mu         = 0.0;
blade_st.CT_target  = blade_st.Thover / blade_st.normf;
blade_st.TPP_alpha  = atan( blade_st.lambda_c / (blade_st.mu + 10^-6) );

[T, Q, lambda_i] = mt_forces(blade_st);

lambda = blade_st.lambda_c + lambda_i;
lambda_h = lambda;
% check = lambda_h - sqrt( blade_st.CT_target/2 );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%alpha_arr = deg2rad( linspace(0, 15, 4) );
%mu_arr = linspace(0, 0.5, 20);
%fig1 = figure(1);
%fig2 = figure(2);

%for j = 1:length(alpha_arr)
%    for i = 1:length(mu_arr)
%        
%        % Modify airflow properties
%        blade_st.lambda_c   = 0.02;
%        blade_st.mu         = mu_arr(i);
%        blade_st.CT_target  = blade_st.Thover / blade_st.normf;
%        blade_st.TPP_alpha  = alpha_arr(j); % atan( (blade_st.lambda_c + 10^-6) / (blade_st.mu) );  % atan(1/0) = 90 deg
%        blade_st.TPP_alphad = rad2deg(blade_st.TPP_alpha);        
%        
%        % But tan(alpa) = lambda_c / mu
%        blade_st.lambda_c = tan(blade_st.TPP_alpha) * blade_st.mu;
%        
%        [T, Q, lambda_i] = mt_forces(blade_st);    
%        lambda = blade_st.lambda_c + lambda_i;
%        
%        T_arr(i) = T;
%        Q_arr(i) = Q;
%        lambda_i_arr(i) = lambda_i;

%        lambda_arr(i) = lambda;
%        lambda_c_arr(i) = blade_st.lambda_c;        
%        
%        % Save label for this case
%        switch j
%            case 1
%                lbl_1 = ['\alpha = ' num2str(blade_st.TPP_alphad) ' deg'];
%            case 2
%                lbl_2 = ['\alpha = ' num2str(blade_st.TPP_alphad) ' deg'];
%            case 3
%                lbl_3 = ['\alpha = ' num2str(blade_st.TPP_alphad) ' deg'];
%            case 4
%                lbl_4 = ['\alpha = ' num2str(blade_st.TPP_alphad) ' deg'];
%            case 5       
%                lbl_5 = ['\alpha = ' num2str(blade_st.TPP_alphad) ' deg'];
%        end
%    end

%    figure(1)
%    subplot(3, 1, 1)
%    hold on;
%    grid on;
%    plot(mu_arr, lambda_arr, '-*');
%    % plot(mu_arr, lambda_arr./lambda_h, '-*');   
%    ylabel('Inflow \lambda');
%    xlabel('Advance ratio \mu');

%    subplot(3, 1, 2)
%    hold on;
%    grid on;
%    plot(mu_arr, lambda_i_arr, '-*');
%    ylabel('Induced inflow \lambda_i');
%    xlabel('Advance ratio \mu');  
%    
%    subplot(3, 1, 3)
%    hold on;
%    grid on;
%    plot(mu_arr, lambda_c_arr, '-*');
%    ylabel('Climb inflow \lambda_c');
%    xlabel('Advance ratio \mu');      
%    
%    figure(2)
%    subplot(2, 1, 1)
%    hold on;
%    grid on;
%    plot(mu_arr, T_arr, '-*');
%    ylabel('Thrust N');
%    xlabel('Advance ratio \mu');
%    ylim([0, 10^5]);
%    
%    subplot(2, 1, 2)
%    hold on;
%    grid on;
%    plot(mu_arr, Q_arr, '-*');
%    ylabel('Torque Nm');
%    xlabel('Advance ratio \mu');    
%    ylim([0, 10^5]);
%end

%figure(1)
%sgtitle('MT at constant angle of attack')
%subplot(3, 1, 2)
%legend(lbl_1, lbl_2, lbl_3, lbl_4, 'Location', 'best') % , lbl_5);
%set(fig1,'units','centimeters','position',[0, 0, 20, 10])
%saveas(fig1, 'img/mt_forces_1.jpg')

%figure(2)
%sgtitle('MT at constant angle of attack')
%subplot(2, 1, 1)
%legend(lbl_1, lbl_2, lbl_3, lbl_4, 'Location', 'best') % , lbl_5);
%set(fig2,'units','centimeters','position',[0, 0, 20, 10])
%saveas(fig2, 'img/mt_forces_2.jpg')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lambda_c_arr = linspace(0, 0.1, 4);
mu_arr = linspace(0, 0.5, 20);
fig3 = figure(3);
fig4 = figure(4);

for j = 1:length(lambda_c_arr)
    for i = 1:length(mu_arr)
        
        % Modify airflow properties
        blade_st.lambda_c   = lambda_c_arr(j);
        blade_st.mu         = mu_arr(i);
        blade_st.CT_target  = blade_st.Thover / blade_st.normf;
        blade_st.TPP_alpha  = atan( (blade_st.lambda_c + 10^-6) / (blade_st.mu) );  % atan(1/0) = 90 deg
        blade_st.TPP_alphad = rad2deg(blade_st.TPP_alpha);        
        
        [T, Q, lambda_i] = mt_forces(blade_st);    
        lambda = blade_st.lambda_c + lambda_i;
        
        T_arr(i) = T;
        Q_arr(i) = Q;
        lambda_i_arr(i) = lambda_i;

        lambda_arr(i) = lambda;
        TPP_alpha_arr(i) = blade_st.TPP_alpha;        
        
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
    end

    figure(3)
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
    
    figure(4)
    subplot(2, 1, 1)
    hold on;
    grid on;
    plot(mu_arr, T_arr, '-*');
    ylabel('Thrust N');
    xlabel('Advance ratio \mu');
    % ylim([0, 10^5]);
    ylim([0, 2*10^5]);
    
    subplot(2, 1, 2)
    hold on;
    grid on;
    plot(mu_arr, Q_arr, '-*');
    ylabel('Torque Nm');
    xlabel('Advance ratio \mu'); 
    % ylim([0, 10^5]);   
    ylim([0, 1*10^5]);
          
end

figure(3)
sgtitle('MT at constant climb inflow')
subplot(3, 1, 2)
legend(lbl_1, lbl_2, lbl_3, lbl_4, 'Location', 'best') % , lbl_5);
set(fig3,'units','centimeters','position',[0, 0, 20, 10])
pause(10)
saveas(fig3, 'img/mt_forces_3.jpg')

figure(4)
sgtitle('MT at constant climb inflow')
subplot(2, 1, 1)
legend(lbl_1, lbl_2, lbl_3, lbl_4, 'Location', 'best') % , lbl_5);
set(fig4,'units','centimeters','position',[0, 0, 20, 10])
pause(20)
saveas(fig4, 'img/mt_forces_4.jpg')




