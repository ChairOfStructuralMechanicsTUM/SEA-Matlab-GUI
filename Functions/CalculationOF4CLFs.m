function [CLF12,CLF13,CLF14] = CalculationOF4CLFs(plate1,plate2,...
    plate3,plate4,connectionLength,frequencies,angleFractions)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
%   This function calculates the coupling loss factors between four
%   plates.
%
%   Input:
%           plate1                  object of class "Plate"
%
%           plate2                  object of class "Plate"
%
%           plate3                  object of class "Plate"
%
%           plate4                  object of class "Plate"
%           
%           connectionLength(int)   length of connection for all 4 plates
%
%           frequencies (float)     array with frequencies
%
%           angleFractions          amount of fractions the angle theta1
%           (int)                   will be split into 
%
%   Output:
%
%           CLF12 (float)           coupling loss factor from plate 1
%                                   to plate 2
%
%           CLF13 (float)           coupling loss factor from plate 1
%                                   to plate 3
%
%           CLF14 (float)           coupling loss factor from plate 1
%                                   to plate 4


%vector from 0 to pi/2
theta1 = 0:(pi/(2*angleFractions)):(pi/2.0);

%calculate the bending stiffnesses of the plates
B1 = plate1.bendingStiffness;
B2 = plate2.bendingStiffness;
B3 = plate3.bendingStiffness;
B4 = plate4.bendingStiffness;

% Initialization of variables
CLF12 = zeros(length(frequencies),1);
CLF13 = zeros(length(frequencies),1);
CLF14=zeros(length(frequencies),1);
conditionMatrix=zeros(4,4);

%calculate for each frequency
for frequencyLoopCount=1:length(frequencies)
    
    %current frequency
    frequency=frequencies(frequencyLoopCount);
    
    %bending wave number for all plates
    kb1 = plate1.bendingWaveNumber(frequency);
    kb2 = plate2.bendingWaveNumber(frequency);
    kb3 = plate3.bendingWaveNumber(frequency);
    kb4 = plate4.bendingWaveNumber(frequency);
    
    %angle theta2 (from Snell's Law)
    for i=1:length(theta1)
        if kb1*sin(theta1(i))/kb2<1.0
            theta2(i) = asin(kb1*sin(theta1(i))/kb2);
        else
            theta2(i)=pi/2.0;
        end
    end
    
    %angle theta3 (from Snell's Law)
    for i=1:length(theta1)
        if kb1*sin(theta1(i))/kb3<1.0
            theta3(i) = asin(kb1*sin(theta1(i))/kb3);
        else
            theta3(i)=pi/2.0;
        end
    end
    
    %angle theta4 (from Snell's Law)
    for i=1:length(theta1)
        if kb1*sin(theta1(i))/kb4<1.0
            theta4(i) = asin(kb1*sin(theta1(i))/kb4);
        else
            theta4(i)=pi/2.0;
        end
    end
    
    for angleInc = 1:length(theta1)
        kb1near=kb1*sqrt(1+power(sin(theta1(angleInc)),2));
        kb2near=kb2*sqrt(1+power(sin(theta2(angleInc)),2));
        kb3near=kb3*sqrt(1+power(sin(theta3(angleInc)),2));
        kb4near=kb4*sqrt(1+power(sin(theta4(angleInc)),2));
        
        conditionMatrix(1,:)=[-kb1near+1i*kb1*cos(theta1(angleInc)),...
            -kb2near+1i*kb2*cos(theta2(angleInc)),0.0,0.0];
        conditionMatrix(2,:)=[-kb1near+1i*kb1*cos(theta1(angleInc)),0.0,...
            -kb3near+1i*kb3*cos(theta3(angleInc)),0.0];
        conditionMatrix(3,:)=[-kb1near+1i*kb1*cos(theta1(angleInc)),0.0,...
            0.0,kb4near-1i*kb4*cos(theta4(angleInc))];
        conditionMatrix(4,:)=[B1*kb1^2,-B2*kb2^2,-B3*kb3^2,B4*kb4^2];
        
        forceVector=[kb1near+1i*kb1*cos(theta1(angleInc));
            kb1near+1i*kb1*cos(theta1(angleInc));
            kb1near+1i*kb1*cos(theta1(angleInc));
            -B1*kb1^2];
        
        vectorAmplitudes = conditionMatrix\forceVector;
        vectorAmplitudeTransmittedWave1(angleInc)=vectorAmplitudes(2);
        vectorAmplitudeTransmittedWave2(angleInc)=vectorAmplitudes(3);
        vectorAmplitudeTransmittedWave3(angleInc)=vectorAmplitudes(4);
    end
    
    for angleInc = 1:length(theta1)
        numerator1=B2*power(kb2,3)*cos(theta2(angleInc))*...
            power(abs(vectorAmplitudeTransmittedWave1(angleInc)),2);
        denominator1=B1*power(kb1,3)*cos(theta1(angleInc));
        vectorThau12(angleInc) = numerator1/denominator1;
        
        numerator2=B3*power(kb3,3)*cos(theta3(angleInc))*...
            power(abs(vectorAmplitudeTransmittedWave2(angleInc)),2);
        vectorThau13(angleInc) = numerator2/denominator1;
        
        numerator3=B4*power(kb4,3)*cos(theta4(angleInc))*...
            power(abs(vectorAmplitudeTransmittedWave3(angleInc)),2);
        vectorThau14(angleInc) = numerator3/denominator1;
    end
    
    %initialize the summation of angle thau1,thau2,thau3
    sumthau1=0.0;
    sumthau2=0.0;
    sumthau3=0.0;
    
    %sum up thau1,thau2,thau3
    for angleInc = 1:length(theta1)
        integrand1(angleInc) = vectorThau12(angleInc)*cos(theta1(angleInc));
        sumthau1=sumthau1+integrand1(angleInc);
        integrand2(angleInc) = vectorThau13(angleInc)*cos(theta1(angleInc));
        sumthau2=sumthau2+integrand2(angleInc);
        integrand3(angleInc) = vectorThau14(angleInc)*cos(theta1(angleInc));
        sumthau3=sumthau3+integrand3(angleInc);
    end
    
    Thau12Integrated=sumthau1/length(theta2);
    Thau13Integrated=sumthau2/length(theta3);
    Thau14Integrated=sumthau3/length(theta4);
    
    %calculate the loss factors
    CLF12(frequencyLoopCount) = plate1.groupVelocity(frequency)*...
        connectionLength/(pi*2.0*pi*frequency*plate1.getArea)*...
        Thau12Integrated*pi/2.0;
    CLF13(frequencyLoopCount) = plate1.groupVelocity(frequency)*...
        connectionLength/(pi*2.0*pi*frequency*plate1.getArea)*...
        Thau13Integrated*pi/2.0;
    CLF14(frequencyLoopCount) = plate1.groupVelocity(frequency)*...
        connectionLength/(pi*2.0*pi*frequency*plate1.getArea)*...
        Thau14Integrated*pi/2.0;
end

