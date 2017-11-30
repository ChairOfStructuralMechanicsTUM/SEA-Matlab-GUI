function [ engValue, engLevel ] = engValues(type, modalEnergy, subsystem)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
%   This function calculates the engineering values for a plate or cavity
%   subsystem.
%
%
%   Input:
%           type (string)   'plate' or 'cavity'
%
%           modalEnergy     modal energy of the subsystem at each frequency
%           (float array)
%
%           subsystem       element of class "Plate" or "Cavity"
%
%
%   Output:
%
%           engValue        r.m.s. of velocity for a plate [m/s] or
%           (float array)   r.m.s of pressure in cavity [N/m^2]
%
%           engLevel        velocity level of plate [dB] or
%           (float array)   sound pressure level in cavity [dB]


p0 = 2e-5; % reference pressure [N/m^2]
v0 = 5e-8; % reference velocity [m/s]
global allWavesFlag
if strcmp(type,'plate')
    if ~allWavesFlag
        engValue = sqrt(modalEnergy./(subsystem.getVolume*subsystem.getDensity));
        
        engLevel = 20.0*log10(engValue./v0);
    else
        for i=1:3
            engValue{i} = sqrt(modalEnergy{i}./(subsystem.getVolume*subsystem.getDensity));
            
            engLevel{i} = 20.0*log10(engValue{i}./v0);
        end
    end
elseif strcmp(type,'cavity')
    
    engValue = sqrt((modalEnergy.*subsystem.getDensity.*...
        power(subsystem.getSpeedOfSound,2))./(subsystem.getVolume));
    
    engLevel = 20.0*log10(engValue./p0);
    
    
end

end

