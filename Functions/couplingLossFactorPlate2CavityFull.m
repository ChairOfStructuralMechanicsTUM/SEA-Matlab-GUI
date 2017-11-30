function [CLF12,CLF21] = couplingLossFactorPlate2CavityFull(plate,...
    cavity,frequencies)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
%   This function returns the coupling loss factor (CLF) for a plate
%   and a cavity for each frequency.
%
%   Input:
%           plate               object of class "Plate"
%
%           cavity              object of class "Cavity"
%
%           frequencies         array of frequencies
%           (float array)
%
%   Ouput:
%           CLF12               array with coupling loss factors
%           (float array)       at each frequency
%
%           CLF21               array with reciprocal coupling loss factors
%           (float array)       at each frequency


%preallocation of arrays
CLF12 = zeros(1,length(frequencies));
CLF21 = zeros(1,length(frequencies));

%calculate for each frequency
for frequencyLoopCount=1:length(frequencies)
    
    %current frequency
    frequency=frequencies(frequencyLoopCount);
    
    %bending wave number for cavity and plate
    k0 = cavity.waveNumber(frequency);
    kp = plate.bendingWaveNumber(frequency);
    
    %critical frequency of the cavity
    fCrit = kp^2.0*cavity.getSpeedOfSound^2/(4.0*pi^2*frequency);
    
    
    %calculate the radiation efficiency depending on the
    %relation of current and critical frequency
    if frequency<fCrit
        mRatio = sqrt(fCrit/frequency);
        U = 2.0*(plate.getLengthX+plate.getLengthY);
        S = plate.getArea;
        radEff = U*cavity.getSpeedOfSound/(4.0*pi^2*sqrt(frequency)*...
            sqrt(fCrit)*S*sqrt(mRatio^2-1.0))*...
            (log((mRatio+1.0)/(mRatio-1.0))+2.0*mRatio/(mRatio^2-1.0));
    elseif frequency>fCrit
        radEff = power(1.0-fCrit/frequency,-1/2.0);
    else
        radEff = sqrt(2.0*pi*frequency/cavity.getSpeedOfSound)*...
            plate.getLengthX*(0.15-0.15*plate.getLengthX/plate.getLengthY);
    end
    %%
    %second way rad eff.
    f11=cavity.getSpeedOfSound^2/(4*fCrit)*(1/plate.getLengthX^2+1/plate.getLengthY^2);
    sigma1=1/sqrt(1-fCrit/frequency);
    sigma2=4*plate.getLengthX*plate.getLengthY*(frequency/cavity.getSpeedOfSound)^2;
    sigma3=sqrt(2*pi*frequency*(plate.getLengthX+plate.getLengthY)/16/cavity.getSpeedOfSound);
    if f11<=fCrit/2
        if frequency>=fCrit
            radEff2=sigma1;
        elseif frequency<fCrit
            lamda=sqrt(frequency/fCrit);
            delta1=((1-lamda^2)*log((1+lamda)/(1-lamda))+2*lamda)/(4*pi^2*(1-lamda^2)^1.5);
            if frequency>fCrit/2
                delta2=0;
            else
                delta2=8*cavity.getSpeedOfSound^2*(1-2*lamda^2)/(fCrit^2*pi^4*plate.getLengthX*plate.getLengthY*lamda*sqrt(1-lamda^2));
            end
            radEff2=2*(plate.getLengthX+plate.getLengthY)/plate.getLengthX/plate.getLengthY*cavity.getSpeedOfSound/fCrit*delta1+delta2;
        end
        if frequency< f11 && radEff2>sigma2
            radEff2=sigma2;
        end
    else
        if frequency<fCrit && sigma2<sigma3
            radEff2=sigma2;
        elseif frequency>fCrit && sigma1<sigma3
            radEff2=sigma1;
        else
            radEff2=sigma3;
        end
    end
    %%
    %calculation of the CLF (f(freq,total radiation), Lyon p.199)
    CLF12(frequencyLoopCount) = radEff*cavity.getDensity*...
        cavity.getSpeedOfSound/(2.0*frequency*pi*plate.getThickness*...
        plate.getDensity);
    
    %calculation of the reciprocal CLF
    CLF21(frequencyLoopCount) = CLF12(frequencyLoopCount)*...
        plate.modalDensityLyon/cavity.modalDensity(frequency);
    
end

end

