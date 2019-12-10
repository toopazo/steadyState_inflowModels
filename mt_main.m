clear
clc
close all

CT = 0.01;
lambda_h = sqrt( CT/2 );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha = deg2rad(0)

nsamples = 20;
for i = 0:nsamples
    mu = i/(nsamples*2);
    lambda = mt_inflow(CT, mu, alpha);
    
    mu_arr(i+1) = mu;
    lambda_arr(i+1) = lambda;
end

fig = figure(1);
hold on;
plot(mu_arr, lambda_arr./lambda_h, '-*');
arg = [ 'induced inflow' ]; %, total P = ' num2str(P) ];
title(arg);
xlabel('radius ');
ylabel('induced inflow/ \lambda_h');
% legend('BEMT', 'theory')
grid on;
saveas(fig, 'mt_main_1.jpg')
% pause(2)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha = deg2rad(4)

for i = 0:nsamples
    mu = i/(nsamples*2);
    lambda = mt_inflow(CT, mu, alpha);
    
    mu_arr(i+1) = mu;
    lambda_arr(i+1) = lambda;
end

fig = figure(1);
hold on;
plot(mu_arr, lambda_arr./lambda_h, '-*');
arg = [ 'induced inflow' ]; %, total P = ' num2str(P) ];
title(arg);
xlabel('radius ');
ylabel('induced inflow/ \lambda_h');
% legend('BEMT', 'theory')
grid on;
saveas(fig, 'mt_main_1.jpg')
% pause(2)

