LN = 0.1; % m
D = 0.05; % m
nFins = 4;
CR = 0.06; % m
CT = 0.025; % m
XF = 0.39; % m
XS = 0.045; % m
S = 0.04; % m 
xCG = 0.25; % m

[ CNa_n, xN, Kfb, LF, CNa_f, CNa_fb, xf, CNa_T, xCP, sm ] = ... 
    rocketCP('elliptical', LN, D, nFins, S, XS, CR, CT, XF, xCG)

fprintf('Total slope C_Nα = %.3f  CP = %.3f m  SM = %.2f calibers\n', ...
        CNa_T, xCP, sm);

% Elliptical nose cone: LN = 10 cm, D = 5.0 cm.
% 2. Fin data: No. of fins = 4, CR = 6 cm, CT = 2.5 cm, XF = 39 cm, XS = 4.5 cm, S = 4 cm
% Center of gravity = 25.0 cm from tip of nose cone.
% 
% function [CNa_n, xN, Kfb, LF, CNa_f, CNa_fb, xf, CNa_T, xCP, staticMargin] = ...
%     rocketCP(noseShape, LN, D, nFins, S, XS, CR, CT, XF, xCG)