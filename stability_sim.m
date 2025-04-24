LN = 0.4; % m
D = 0.025; % m
nFins = 3;
CR = 0.0373; % m
CT = 0.0254; % m
XF = 0.35; % m
XS = 0.006; % m
S = 0.0378; % m 
xCG = 0.2667; % m


% Length: 15.75 in
% Diameter: .99 in
% Nosecone: 4.05in long
% Root chord: 1.47in
% Tip chord: 1.00in
% Xs: .24 in
% Xf: 13.80in
% S: 1.49 in


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