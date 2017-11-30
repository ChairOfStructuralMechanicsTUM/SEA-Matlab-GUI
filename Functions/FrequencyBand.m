function [ frequSpec ] = FrequencyBand(type, fstart, ffinish, spacing)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
%   This function returns a vector containing the frequencies of either 
%   a third octave band, an octave band or a linearly spaced frequency
%   band.
%
%   Input:  
%           type (string)       'thirdOctave','octave' or 'linear'
%                               defining the type of frequency band
%           
%           fstart (double)     starting frequency for linear spacing
%           ffinish (double)    end frequency for linear spacing
%           spacing (double)    linear frequency spacing 
%
%   Output:
%           frequSpec           frequencies
%           (double array)


switch nargin
    case 1
        if strcmp(type,'Third Octave')
            frequSpec = [125,160,200,250,315,400,500,630,800,1000,1250,1600,...
                2000,2500,3150,4000,5000,6300,8000,10000,12500,16000]';
        elseif strcmp(type,'Octave')
            frequSpec = [125,250,500,1000,2000,4000,8000,16000]';
        end
    case 4
        if strcmp(type,'linear')
            frequSpec = (fstart:spacing:ffinish)';
        end
end

end

