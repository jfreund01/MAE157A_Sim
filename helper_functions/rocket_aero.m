function [Cd, x_cp, Cd2, x_cp2] = rocket_aero(nose_shape,D,LN,XF,CR,CT,XS,S,N,XF2,CR2,CT2,XS2,S2,N2)
    % nose_shape - 1(conical), 2(parabolic), 3(ogive), or 4(elliptical)
    %   D - body diameter
    %   LN - nose length
    %   XF - fin offset (distance from nose tip to fin leading edge)
    %   CR - fin root chord
    %   CT - fin tip chord
    %   LF - fin span (length from root to tip outward)
    %   XS - distance between fin root leading edge and fin tip leading
    %   edge
    %   S - fin semi-span
    %   N - number of fins
    if (nose_shape == 1)
        alpha = .666;
    elseif(nose_shape == 2)
        alpha = .5;
    elseif(nose_shape == 3)
        alpha = .466;
    elseif(nose_shape == 4)
        alpha = .333;
    else
        disp("Please select a nosecone shape")
    end
    
    if N == 3
        beta = 13.85;
    elseif N == 4
        beta = 16;
    else
        error("Please select either 3 or 4 fins");
    end
    if N2 == 3
        beta2 = 13.85;
    elseif N2 == 4
        beta2 = 16;
    else
        error("Please select either 3 or 4 fins");
    end
    %nose cone
    x_n = alpha * LN;
    CN_a_n = 2;

    %fin set 1
    LF = sqrt(S^2 + (XS + (CT/2 - CR/2))^2);
    Kfb = 1 + (D / (2 * S + D));
    CN_a_f = (beta * (S / D)^2) / (1 + sqrt(1 + (2 * LF / (CR + CT))^2));
    CN_a_fb = Kfb * CN_a_f;
    term1 = XS * (CR + 2 * CT) / (3 * (CR + CT));
    term2 = (1/6) * (CR + CT - (CR * CT) / (CR + CT));
    x_f = XF + term1 + term2;
    Cd_fins = 1.28 * (N * LF * (CR + CT) / 2) / S;

    %fin set 2
    LF2 = sqrt(S2^2 + (XS2 + (CT2/2 - CR2/2))^2);
    Kfb2 = 1 + (D / (2 * S2 + D));
    CN_a_f2 = (beta2 * (S2 / D)^2) / (1 + sqrt(1 + (2 * LF2 / (CR2 + CT2))^2));
    CN_a_fb2 = Kfb2 * CN_a_f2;
    term12 = XS2 * (CR2 + 2 * CT2) / (3 * (CR2 + CT2));
    term22 = (1/6) * (CR2 + CT2 - (CR2 * CT2) / (CR2 + CT2));
    x_f2 = XF2 + term12 + term22;
    Cd_fins2 = 1.28 * (N2 * LF2 * (CR2 + CT2) / 2) / S;

    %total
    Cd_nose = .1;
    CN_a_total = CN_a_n + CN_a_fb + CN_a_fb2;
    CN_a_total2 = CN_a_n + CN_a_fb;
    x_cp = (CN_a_n * x_n + CN_a_fb * x_f + CN_a_fb2 * x_f2) / CN_a_total;
    Cd = Cd_nose + Cd_fins + Cd_fins2;
    Cd2 = Cd_nose + Cd_fins;
    x_cp2 = (CN_a_n * x_n + CN_a_fb * x_f) / CN_a_total2;
end
    




