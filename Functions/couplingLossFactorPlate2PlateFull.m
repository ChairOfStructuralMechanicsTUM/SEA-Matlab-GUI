function [CLF12,CLF21] = couplingLossFactorPlate2PlateFull(plate1,...
    plate2,connectionLength,frequencies,angleFractions)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
%   This function returns the coupling loss factor (CLF) for two plates
%   connected at a line for each frequency.
%
%   Input:
%           plate1              object of class "Plate"
%
%           plate2              object of class "Plate"
%
%           connectionLength    length of the line connection
%
%           frequencies         array of frequencies
%           (float array)
%
%           angleFractions      amount of fractions the angle theta1
%           (int)               will be split into 
%
%   Ouput:
%           CLF12               array with coupling loss factors
%           (float array)       at each frequency
%
%           CLF21               array with reciprocal coupling loss factors
%           (float array)       at each frequency


%vector from 0 to pi/2
theta1 = 0:(pi/(2*angleFractions)):(pi/2.0);

%calculate the bending stiffnesses of the plates
B1 = plate1.bendingStiffness;
B2 = plate2.bendingStiffness;

%Initialization of variables
CLF12 = zeros(length(frequencies),1);
CLF21 = zeros(length(frequencies),1);
conditionMatrix = zeros(4,4);

%calculation for each frequency
for frequencyLoopCount=1:length(frequencies)
    
    %current frequency
    frequency=frequencies(frequencyLoopCount);
    
    %bending wave number for both plates
    kb1 = plate1.bendingWaveNumber(frequency);
    kb2 = plate2.bendingWaveNumber(frequency);
    
    %angle theta2 (from Snell's Law)
    for i=1:length(theta1)
        if kb1*sin(theta1(i))/kb2<1.0
            theta2(i) = asin(kb1*sin(theta1(i))/kb2);
        else
            theta2(i)=pi/2.0;
        end
    end
    
    %Amplitude of incoming wave == 1
    AInc = 1.0;
    
    %Condition matrix with BC's
    for angleInc = 1:length(theta2)
        
        %Derivation from Skript of Chair of Structural Mechanics (matches with Craiks)
        conditionMatrix(1,:) = [1.0,0.0,1.0,0.0];
        conditionMatrix(2,:) = [0.0,1.0,0.0,1.0];
        
        conditionMatrix(3,1) = 1i*kb1*cos(theta1(angleInc));
        conditionMatrix(3,2) = 1i*kb2*cos(theta2(angleInc));
        conditionMatrix(3,3) = kb1*sqrt(1.0+power(sin(theta1(angleInc)),2));
        conditionMatrix(3,4) = kb2*sqrt(1.0+power(sin(theta2(angleInc)),2));
        
        conditionMatrix(4,1) = -B1*power(kb1,2)*(power(cos(theta1(...
            angleInc)),2)+plate1.getPoissonRatio*power(sin(theta1(...
            angleInc)),2));
        conditionMatrix(4,2) = B2*power(kb2,2)*(power(cos(theta2(...
            angleInc)),2)+plate2.getPoissonRatio*power(sin(theta2(...
            angleInc)),2));
        conditionMatrix(4,3) = B1*power(kb1,2)*(power(sin(theta1(...
            angleInc)),2)+1-plate1.getPoissonRatio*power(sin(theta1(...
            angleInc)),2));
        conditionMatrix(4,4) = B2*power(kb2,2)*(-1*power(sin(theta2(...
            angleInc)),2)-1.0+plate2.getPoissonRatio*power(sin(theta2(...
            angleInc)),2));
        
        %"Force vector" with amplitude of incoming wave
        forceVector = [-AInc;
            0.0;
            1i*kb1*cos(theta1(angleInc))*AInc;
            AInc*B1*power(kb1,2)*(power(cos(theta1(angleInc)),2)+...
            plate1.getPoissonRatio*power(sin(theta1(angleInc)),2))];
        
        %solve for vector of amplitudes
        vectorAmplitudes = conditionMatrix\forceVector;
        
        %only second entry of value for us
        vectorAmplitudeTransmittedWave(angleInc) = vectorAmplitudes(2);
        
    end
    
    %Calculation of thau12
    for angleInc = 1:length(theta2)
        numerator=B2*power(kb2,3)*cos(theta2(angleInc))*...
            power(abs(vectorAmplitudeTransmittedWave(angleInc)),2);
        denominator=B1*power(kb1,3)*cos(theta1(angleInc));
%         numerator=B2*power(kb2,3)*(power(cos(theta2(angleInc)),3)+...
%             plate2.getPoissonRatio*...
%             power(sin(theta2(angleInc)),2)*cos(theta2(angleInc)))*...
%             power(abs(vectorAmplitudeTransmittedWave(angleInc)),2);
%         denominator=B1*power(kb1,3)*...
%             (power(cos(theta1(angleInc)),3)+...
%             plate1.getPoissonRatio*...
%             power(sin(theta1(angleInc)),2)*cos(theta1(angleInc)));
        vectorThau12(angleInc) = numerator/denominator;
    end
    
    %Integration of thau12
    %Initialize before starting the summation
    sumthau=0.0;
    
    for angleInc = 1:length(theta2)
        integrand(angleInc) = vectorThau12(angleInc)*cos(theta1(angleInc));
        sumthau=sumthau+integrand(angleInc);
    end
    
    Thau12Integrated=sumthau/length(theta2);
    
    %calculate the CLF
    CLF12(frequencyLoopCount) = plate1.groupVelocity(frequency)*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*Thau12Integrated*pi/2.0;
    
    %calculate the reciprocal CLF
    CLF21(frequencyLoopCount) = CLF12(frequencyLoopCount)*plate1.modalDensityLyon/...
        plate2.modalDensityLyon;
end
end

