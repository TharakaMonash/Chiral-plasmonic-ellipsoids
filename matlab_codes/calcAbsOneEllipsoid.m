function abs = calcAbsOneEllipsoid(eMedium,lambda,eEllipsoid,longRadius,transRadius,chirality,C,K,orientation)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculate the absorption of a single ellipsoid based on the
% following parameters.
% Parameters:
%   eMedium     : Permittivity of the background medium
%   lambda      : wavelength as an array (in nm)
%   eEllipsoid  : Permittivity of the ellipsoid medium
%   longRadius  : Longitudinal radius of the ellipsoid
%   transRadius : Transverse radius of the ellipsoid
%   chirality   : Chirality parameter of the ellipsoid
%   C           : Parameter that describe the electric field
%   K           : Parameter that describe the electric field
%   orientation : 1 for longitudinal ellipsoid, 0 for transverse ellipsoid.
% Returns:
%   abs         : Absorption of the ellipsoid as an array
% Author: Tharaka Perera
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Geometric factor calculation
    R = transRadius/longRadius;
    e = sqrt(1-R^2);
    L = ((1-e^2)/e^2) * ((1/(2*e))*log((1+e)/(1-e)) - 1);
    if orientation == 1%"long"
        P = [L, (1-L)/2, (1-L)/2];
    elseif orientation == 0%"trans"
        P = [(1-L)/2, (1-L)/2, L];
    end
    N=1;
    SL= 299792458; % Speed of light
    V= 4/3*pi*longRadius*transRadius*transRadius*(10^(-9))^3;
    % Permittivity
    e1 = real(eEllipsoid);
    e2 = imag(eEllipsoid);
    % Chirailty parameter
    xi1 = real(chirality);
    xi2 = imag(chirality);
    % absorption calculation
    temp = 0;
    for i = 1:2
        temp = temp + (sqrt(eMedium)*e2 - 2*C*((eMedium+P(i).*(e1-eMedium)).*xi2+P(i).*e2.*xi1))./(((P(i)-1)*eMedium-P(i)*e1).^2+(P(i)*e2).^2);
    end
    abs = N*V*K^2*SL*(eMedium^(3/2))*temp./lambda;
end