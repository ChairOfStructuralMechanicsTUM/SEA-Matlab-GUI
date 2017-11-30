function [CLF12,CLF13,CLF14,CLF23,CLF21,CLF24,CLF31,...
    CLF32,CLF34,CLF41,CLF42,CLF43] = CLFCrossConn(plate1,plate2,...
    plate3,plate4,connectionLength,frequencies,angleFractions)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
% Calculation of the coupling loss factors for a X-connection of
% four plates.

%calculate the CLFs
[CLF12,CLF13,CLF14] = CalculationOF4CLFs(plate1,plate2,plate3,plate4,...
    connectionLength,frequencies,angleFractions);
[CLF21,CLF23,CLF24] = CalculationOF4CLFs(plate2,plate1,plate3,plate4,...
    connectionLength,frequencies,angleFractions);
[CLF31,CLF32,CLF34] = CalculationOF4CLFs(plate3,plate1,plate2,plate4,...
    connectionLength,frequencies,angleFractions);
[CLF41,CLF42,CLF43] = CalculationOF4CLFs(plate4,plate1,plate2,plate3,...
    connectionLength,frequencies,angleFractions);
end

