function [CLF12,CLF13,CLF23,CLF21,CLF31,CLF32] = CLFTeeConn(plate1,...
    plate2,plate3,connectionLength,frequencies,angleFractions)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
% Calculation of the coupling loss factors for a T-connection of
% three plates.

%calculation of CLFs
[CLF12,CLF13] = CalculationOF3CLFs(plate1,plate2,plate3,connectionLength,...
    frequencies,angleFractions);
[CLF21,CLF23] = CalculationOF3CLFs(plate2,plate1,plate3,connectionLength,...
    frequencies,angleFractions);
[CLF31,CLF32] = CalculationOF3CLFs(plate3,plate1,plate2,connectionLength,...
    frequencies,angleFractions);
end

