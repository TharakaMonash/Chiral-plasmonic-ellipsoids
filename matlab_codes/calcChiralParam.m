function [xi_c,e_c] = calcChiralParam(lambda)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function models the Chirality parameter and the Permitivitty of
% chiral material
% IMPORTANT: lambda_nm should be between 188nm and 1937nm
% following parameters.
% Parameters:
%   lambda      : wavelength in nm as an array
% Returns:
%   xi_c        : Chirality parameter
%   e_c         : Permitivitty of chiral material
% Author: Tharaka Perera
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Constants
    c_const = 299792458; % speed of light
    hbar =1.0545718e-34; % Reduced planck's constant  
    % Parameters that define the chiral material
    tau = 3.5248e-20;
    beeta_c = 1e-22;
    gamma_c = 5e-25; 
    lambda0 = 625e-9;
    
    w0 = hbar*2*pi*c_const/lambda0;
    f = c_const.*1e9./lambda;

    xi_c = beeta_c*((1./(hbar*2*pi*f-w0+1i*tau))+(1./(hbar*2*pi*f+w0+1i*tau)));
    e_c = 1.5 - gamma_c*((1./(hbar*2*pi*f-w0+1i*tau))-(1./(hbar*2*pi*f+w0+1i*tau)));
end