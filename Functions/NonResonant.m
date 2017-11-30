function [ CLF12,CLF21 ] = NonResonant( plate,cavity1,cavity2,frequencies )
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
CLF12 = zeros(1,length(frequencies));
CLF21 = zeros(1,length(frequencies));
angleFractions=100;
theta1 = 0:(pi/(2*angleFractions)):(pi/2.0);

for frequencyLoopCount=1:length(frequencies)
    %%first way (Hopkins) infinite plate
    for j=1:length(theta1)
        tau(j)=1/(1+(2*pi*frequencies(frequencyLoopCount)*cos(theta1(j))*plate.getDensity*plate.getThickness/(2*cavity1.getDensity*cavity1.getSpeedOfSound))^2);
    end
    sumtau=0;
    for j=1:length(theta1)
        sumtau=sumtau+tau(j)*sin(2*theta1(j));
    end
    integratedTau=sumtau/length(theta1)*pi/2;
    %%
    %second way (Craik)finite plate
%     frequency=frequencies(frequencyLoopCount);
%     kp = plate.bendingWaveNumber(frequency);
%       fCrit = kp^2.0*cavity1.getSpeedOfSound^2/(4.0*pi^2*frequency);
%       firstTerm=(cavity1.getDensity*cavity1.getSpeedOfSound/(pi*frequency*plate.getDensity*plate.getThickness*(1-frequency^2/fCrit^2)))^2;
%       mu=sqrt(fCrit/frequency);
%       secondTerm=log(2*pi*frequency*sqrt(plate.getArea)/cavity1.getSpeedOfSound)+0.16;
%       thirdTerm=1/(4*mu)^6*((2*mu^2-1)*(mu^2+1)^2*log(mu^2-1)+(2*mu^2+1)*(mu^2-1)^2*log(mu^2+1)-4*mu^2-8*mu^6*log(mu));
%     tauCraik=firstTerm*(secondTerm+thirdTerm);
      %%
    CLF12(frequencyLoopCount)=integratedTau*cavity1.getSpeedOfSound*plate.getArea/(8*pi*frequencies(frequencyLoopCount)*cavity1.getVolume);
   % CLF12(frequencyLoopCount)=tauCraik*cavity1.getSpeedOfSound*plate.getArea/(8*pi*frequencies(frequencyLoopCount)*cavity1.getVolume);
   CLF21(frequencyLoopCount)=CLF12(frequencyLoopCount)*...
        cavity1.modalDensity(frequencies(frequencyLoopCount))/cavity2.modalDensity(frequencies(frequencyLoopCount));
end

end

