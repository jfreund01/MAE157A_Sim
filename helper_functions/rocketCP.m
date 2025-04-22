function [CNa_n, xN, Kfb, LF, CNa_f, CNa_fb, xf, CNa_T, xCP, staticMargin] = ...
    rocketCP(noseShape, LN, D, nFins, S, XS, CR, CT, XF, xCG)

  CNa_n = 2.0;
  alpha = 0.0
  switch lower(noseShape)
    case 'conical',    alpha = 0.666;
    case 'parabolic',  alpha = 0.500;
    case 'ogive',      alpha = 0.466;
    case 'elliptical', alpha = 0.333;
  end
  xN = alpha * LN;

  Kfb = 1 + D/(2*S + D);
  LF  = sqrt( S^2 + ( XS + CT/2 - CR/2 )^2 );

  if nFins==3
    beta = 13.85;
  elseif nFins==4
    beta = 16.0;
  end
  CNa_f = beta * (S/D)^2 / ( 1 + sqrt( 1 + (2*LF/(CR+CT))^2 ) );
  CNa_fb = Kfb * CNa_f;

  xf = XF ...
     + XS * (CR + 2*CT) / (3*(CR + CT)) ...
     + (1/6)*( CR + CT - (CR*CT)/(CR + CT) );

  CNa_T       = CNa_n  + CNa_fb;
  xCP         = (CNa_n*xN + CNa_fb*xf) / CNa_T;
  staticMargin = (xCP - xCG)/D;
end
