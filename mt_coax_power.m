clear all
clc
close all
format compact
format short

eta_T_arr = 0:0.1:3;
for i = 1:length(eta_T_arr)
    eta_T = eta_T_arr(i);
    v_l_div_v_u = (1/2) * (...
        sqrt( (eta_T^3 + 4*eta_T^2 + 8*eta_T + 4)/(eta_T) ) - eta_T - 2 ...
        );     
    eta_v = 1/v_l_div_v_u;
    eta_v_arr(i) = eta_v;
    
    % eta_T
    % eta_v
    % eta_T = 1 => eta_v = 1.780776406404415 => 1/eta_v = 0.5616
    
    Pcoax = sqrt( (1+eta_T) / (eta_T)) * ( eta_v / (1+eta_v) );    
    Psbs = ( 1 + eta_T^(3/2) ) / ( (1+eta_T)^(3/2) );
    kint = Pcoax/Psbs;
    
    Pcoax_arr(i) = Pcoax;
    Psbs_arr(i) = Psbs;
    kint_arr(i) = kint;
end

fig = figure(1);
hold on;
grid on;
plot(eta_T_arr, eta_v_arr, '-*');
plot(eta_T_arr, 1./(eta_T_arr-1), '-*');
% plot(eta_T_arr, sqrt(eta_T_arr), '-*');
title('Induced velocity sharing ratio', 'FontSize', 18)
ylabel('\eta_v = v_u / v_l', 'FontSize', 18);
xlabel('\eta_T = T_u / T_l', 'FontSize', 18); 
ylim([0, 4]); 
axis square
set(fig,'units','centimeters','position',[0, 0, 15, 15]);
% pause(10)
% saveas(fig, 'img/mt_coax_power_1.jpg');


fig = figure(2);
hold on;
grid on;
plot(eta_T_arr, Psbs_arr, '-*');
plot(eta_T_arr, Pcoax_arr, '-*');
plot(eta_T_arr, kint_arr, '-*');
title('Coaxial power factor', 'FontSize', 18)
ylabel('P / P_0', 'FontSize', 18);
xlabel('\eta_T = T_u / T_l', 'FontSize', 18); 
legend('side-by-side', 'Alt II coaxial', 'k_{int}')
%ylim([0, 10^5]); 
axis square
set(fig,'units','centimeters','position',[0, 0, 15, 15]); 
% pause(20)
% saveas(fig, 'img/mt_coax_power_2.jpg');

%fig = figure(3);
%hold on;
%grid on;
%plot(eta_T_arr, kint_arr, '-*');
%% plot(eta_T_arr, 1./eta_v_arr, '-*');
%% plot(eta_T_arr, sqrt(eta_T_arr), '-*');
%title('k_{int} factor', 'FontSize', 18)
%ylabel('Pcoax / Psbs', 'FontSize', 18);
%xlabel('\eta_T = T_u / T_l', 'FontSize', 18); 
%%legend('side-by-side', 'Alt II coaxial')
%ylim([0, 1.3]); 
%axis square
%set(fig,'units','centimeters','position',[0, 0, 15, 15]); 
%% pause(20)
%% saveas(fig, 'img/mt_coax_power_2.jpg');

% close all

