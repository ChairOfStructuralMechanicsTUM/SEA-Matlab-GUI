function [CLF1b2b,CLF1b2l,CLF1b2t,CLF1l2b,CLF1l2l,CLF1l2t,CLF1t2b,CLF1t2l,CLF1t2t, CLF12, CLF21,CLF1b1l,CLF1b1t,CLF1l1b,CLF1l1t,CLF1t1b,CLF1t1l] = couplingLossFactorPlate2PlateFullAllWaves(plate1,...
    plate2,connectionLength,frequencies,angleFractions,angleOfConnection)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
%implementation for the CLF among all types of waves according to Hopkins
%Sound INsulation pages 545-550


%angles of plates
phi1 = 0;
phi2 = angleOfConnection/180*pi;
%vector from 0 to pi/2
theta1 = 0:(pi/(2*angleFractions)):(pi/2.0);
delta = 0.00001;

%calculate the bending stiffnesses of the plates and other stiffnesses
B1 = plate1.bendingStiffness;
B2 = plate2.bendingStiffness;
E1 = plate1.getYoungsModulus;
E2 = plate2.getYoungsModulus;
h1 = plate1.getThickness;
h2 = plate2.getThickness;
v1 = plate1.getPoissonRatio;
v2 = plate2.getPoissonRatio;
G1 = plate1.shearModulus;
G2 = plate2.shearModulus;

%calculation for each frequency
for frequencyLoopCount=1:length(frequencies)
    
    %current frequency
    frequency=frequencies(frequencyLoopCount);
    w = 2 * pi *frequency;
    %wave number for both plates (defined only by the geometry)
    kb1 = plate1.bendingWaveNumber(frequency);
    kb2 = plate2.bendingWaveNumber(frequency);
    kL1 = plate1.longitudinalWaveNumber(frequency);
    kL2 = plate2.longitudinalWaveNumber(frequency);
    kT1 = plate1.transverseWaveNumber(frequency);
    kT2 = plate2.transverseWaveNumber(frequency);
    
    
    %%  case incident wave is a bending wave
    %initialization of the sums
    taub1b2IntegralArea = 0;
    taub1L2IntegralArea = 0;
    taub1T2IntegralArea = 0;
    taub1b1IntegralArea = 0;
    taub1L1IntegralArea = 0;
    taub1T1IntegralArea = 0;
    incidentWavenunber = kb1;
    %better discretization of angles.SO that we can capture the other waves
    %also
    thetaCutOffBending = asin(kb2/incidentWavenunber);
    thetaCutOffLongitudinal = asin(kL2/incidentWavenunber);
    thetaCutOffTransverse = asin(kT2/incidentWavenunber);
    if imag(thetaCutOffBending)~=0
        thetaCutOffBending = pi/2;
    end
    if imag(thetaCutOffLongitudinal)~=0
        thetaCutOffLongitudinal = pi/2;
    end
    if imag(thetaCutOffTransverse)~=0
        thetaCutOffTransverse = pi/2;
    end
    cutOffAngles = [thetaCutOffLongitudinal;thetaCutOffTransverse;thetaCutOffBending];
    cutOffAngles = sort(cutOffAngles);
    theta1 = [0:(cutOffAngles(1)/angleFractions):(cutOffAngles(1)),...
        cutOffAngles(1)+delta:(cutOffAngles(2)-cutOffAngles(1))/angleFractions:cutOffAngles(2)...
        cutOffAngles(2)+delta:(cutOffAngles(3)-cutOffAngles(2))/angleFractions:cutOffAngles(3)];
    
    
    for j=1:length(theta1)
        [ conditionMatrix, C1Fy2,C1Mz2,C1az2,C1Fx2,C1ksi2,C1Fz2,C1zeta2,C2Fx2,C2ksi2,C2Fz2,C2zeta2,...
            C1Fy1,C1Mz1,C1az1,C1Fx1,C1ksi1,C1Fz1,C1zeta1,C2Fx1,C2ksi1,C2Fz1,C2zeta1,thetaCutOffBending,thetaCutOffLongitudinal,thetaCutOffTransverse ] =...
            condMatrixBuild( incidentWavenunber , kb2 , kL2, kT2, kb1 , kL1, kT1,...
            theta1, B1, B2, E1, E2, h1, h2, v1, v2, G1, G2,j ,phi1,phi2);
        
        %RHS force vector-->changes wrt the incident wave the formulation
        forceVector(1) = 1i * B1 * kb1^3 * cos(theta1(j))*(cos(theta1(j))^2+...
            (2 - v1) * sin (theta1(j))^2) * sin (phi1);
        forceVector(2) = - 1i * B1 * kb1^3 * cos(theta1(j))*(cos(theta1(j))^2+...
            (2 - v1) * sin (theta1(j))^2) * cos(phi1);
        forceVector(3) = B1 * kb1^2 * ( cos(theta1(j))^2 + v1 * sin(theta1(j))^2);
        forceVector(4) = 0;
        forceVector(5) = 0; %due to only bending wave acting
        forceVector(6) = 1;
        forceVector(7) = 0;
        forceVector(8) = 1i * kb1 * cos(theta1(j));
        %          forceVector(9:12) = 0;
        
        solutionVector = conditionMatrix\transpose(forceVector);
        
        %calculation of intensities:
        incidentIntensity = B1 * w * kb1^3* cos(theta1(j));
        %calculation of intensities based on Cremer
        %calculation of Power of 
                bendingTransIntensity = -pi * frequency * imag(C1Fy2 - C1Mz2 * conj(C1az2) ) ...
                    * abs(solutionVector(3))^2;
                longitTransIntensity = -pi * frequency * imag(C1Fx2 * conj(C1ksi2) + C1Fz2 * conj(C1zeta2))...
                    * abs(solutionVector(1))^2;
                transvTransIntensity = -pi * frequency * imag(C2Fx2 * conj(C2ksi2) + C2Fz2 * conj(C2zeta2))...
                    * abs(solutionVector(2))^2;
                bendingRefIntensity = -pi * frequency * imag(C1Fy1 - C1Mz1 * conj(C1az1) ) ...
                    * abs(solutionVector(7))^2;
                longitRefIntensity = -pi * frequency * imag(C1Fx1 * conj(C1ksi1) + C1Fz1 * conj(C1zeta1))...
                    * abs(solutionVector(5))^2;
                transvRefIntensity = -pi * frequency * imag(C2Fx1 * conj(C2ksi1) + C2Fz1 * conj(C2zeta1))...
                    * abs(solutionVector(6))^2;
                
                 %taus according to hopkins
                taub1b2(j) = bendingTransIntensity /incidentIntensity;
        
                taub1L2(j) = longitTransIntensity / incidentIntensity;
                taub1T2(j) = transvTransIntensity / incidentIntensity;
                %for the reflected waves
                taub1b1(j) = bendingRefIntensity /incidentIntensity;
        
                taub1L1(j) = longitRefIntensity / incidentIntensity;
                taub1T1(j) = transvRefIntensity / incidentIntensity;
        %           angles of transmitted waves
%         if theta1(j)<= thetaCutOffBending
%             thetaBendingTrans = asin(incidentWavenunber/kb2*sin(theta1(j)));
%         else
%             thetaBendingTrans = pi/2;
%         end
%         if theta1(j)<= thetaCutOffLongitudinal
%             thetaLongTrans = asin(incidentWavenunber/kL2*sin(theta1(j)));
%         else
%             thetaLongTrans = pi/2;
%         end
%         if theta1(j)<= thetaCutOffTransverse
%             thetaTransvTrans = asin(incidentWavenunber/kT2*sin(theta1(j)));
%         else
%             thetaTransvTrans = pi/2;
%         end
%taus accoridng to Johansson
%         taub1b2(j) = w*B2*kb2^3*cos(thetaBendingTrans)*...
%             abs(solutionVector(3))^2/incidentIntensity;
%         taub1L2(j) = 1/2* plate2.getDensity * h2 * w^3 * kL2 *...
%             cos(thetaLongTrans)*...
%             abs(solutionVector(1))^2/incidentIntensity;
%         taub1T2(j) = 1/2* plate2.getDensity * h2 * w^3 * kT2 *cos(thetaTransvTrans)*...
%             abs(solutionVector(2))^2/incidentIntensity;
       
        
        
        
        %tau average Calculation
        for k=1:3
            if theta1(j)<=cutOffAngles(k) && k==1
                taub1b2IntegralArea = taub1b2IntegralArea + taub1b2(j)*cos(theta1(j)) * cutOffAngles(k) / (angleFractions);
                taub1L2IntegralArea = taub1L2IntegralArea + taub1L2(j)*cos(theta1(j))* cutOffAngles(k) / (angleFractions);
                taub1T2IntegralArea = taub1T2IntegralArea + taub1T2(j)*cos(theta1(j))* cutOffAngles(k) / (angleFractions);
                taub1b1IntegralArea = taub1b1IntegralArea + taub1b1(j)*cos(theta1(j)) * cutOffAngles(k) / (angleFractions);
                taub1L1IntegralArea = taub1L1IntegralArea + taub1L1(j)*cos(theta1(j))* cutOffAngles(k) / (angleFractions);
                taub1T1IntegralArea = taub1T1IntegralArea + taub1T1(j)*cos(theta1(j))* cutOffAngles(k) / (angleFractions);
            elseif theta1(j)<=cutOffAngles(k) && theta1(j)>=cutOffAngles(k-1)
                taub1b2IntegralArea = taub1b2IntegralArea + taub1b2(j)*cos(theta1(j)) * (cutOffAngles(k)-cutOffAngles(k-1))/ (angleFractions);
                taub1L2IntegralArea = taub1L2IntegralArea + taub1L2(j)*cos(theta1(j))* (cutOffAngles(k)-cutOffAngles(k-1)) / (angleFractions);
                taub1T2IntegralArea = taub1T2IntegralArea + taub1T2(j)*cos(theta1(j))* (cutOffAngles(k)-cutOffAngles(k-1)) / (angleFractions);
                taub1b1IntegralArea = taub1b1IntegralArea + taub1b1(j)*cos(theta1(j)) * (cutOffAngles(k)-cutOffAngles(k-1))/ (angleFractions);
                taub1L1IntegralArea = taub1L1IntegralArea + taub1L1(j)*cos(theta1(j))* (cutOffAngles(k)-cutOffAngles(k-1)) / (angleFractions);
                taub1T1IntegralArea = taub1T1IntegralArea + taub1T1(j)*cos(theta1(j))* (cutOffAngles(k)-cutOffAngles(k-1)) / (angleFractions);
                
            end
        end
        %         if theta1(j)<= thetaCutOffBending
        %             taub1b2IntegralArea = taub1b2IntegralArea + taub1b2(j)*cos(theta1(j)) * pi/2 / (length(theta1)-1);
        %         end
        %         if theta1(j)<= thetaCutOffLongitudinal
        %             taub1L2IntegralArea = taub1L2IntegralArea + taub1L2(j)*cos(theta1(j))* pi/2 / (length(theta1)-1);
        %         end
        %         if theta1(j)<= thetaCutOffTransverse
        %             taub1T2IntegralArea = taub1T2IntegralArea + taub1T2(j)*cos(theta1(j))* pi/2 / (length(theta1)-1);
        %         end
        
    end
    %CLFs Calculation
    CLF1b2b(frequencyLoopCount) = plate1.groupVelocity(frequency)*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*taub1b2IntegralArea;
    CLF1b2l(frequencyLoopCount) = plate1.groupVelocity(frequency)*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*taub1L2IntegralArea;
    CLF1b2t(frequencyLoopCount) = plate1.groupVelocity(frequency)*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*taub1T2IntegralArea;
    CLF1b1b(frequencyLoopCount) = plate1.groupVelocity(frequency)*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*taub1b1IntegralArea;
    CLF1b1l(frequencyLoopCount) = plate1.groupVelocity(frequency)*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*taub1L1IntegralArea;
    CLF1b1t(frequencyLoopCount) = plate1.groupVelocity(frequency)*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*taub1T1IntegralArea;
    %assign them in a 3x3 matrix so that it is easier to handle
    CLF12{frequencyLoopCount}(3,6) = CLF1b2b(frequencyLoopCount);
    CLF12{frequencyLoopCount}(3,4) = CLF1b2l(frequencyLoopCount);
    CLF12{frequencyLoopCount}(3,5) = CLF1b2t(frequencyLoopCount);
    CLF12{frequencyLoopCount}(3,3) = CLF1b1b(frequencyLoopCount);
    CLF12{frequencyLoopCount}(3,1) = CLF1b1l(frequencyLoopCount);
    CLF12{frequencyLoopCount}(3,2) = CLF1b1t(frequencyLoopCount);
    %%  case incident wave is a longitudinal wave
    %initialization of the sums
    tauL1b2IntegralArea = 0;
    tauL1L2IntegralArea = 0;
    tauL1T2IntegralArea = 0;
    tauL1b1IntegralArea = 0;
    tauL1L1IntegralArea = 0;
    tauL1T1IntegralArea = 0;
    incidentWavenunber = kL1;
    thetaCutOffBending = asin(kb2/incidentWavenunber);
    thetaCutOffLongitudinal = asin(kL2/incidentWavenunber);
    thetaCutOffTransverse = asin(kT2/incidentWavenunber);
    if imag(thetaCutOffBending)~=0
        thetaCutOffBending = pi/2;
    end
    if imag(thetaCutOffLongitudinal)~=0
        thetaCutOffLongitudinal = pi/2;
    end
    if imag(thetaCutOffTransverse)~=0
        thetaCutOffTransverse = pi/2;
    end
    cutOffAngles = [thetaCutOffLongitudinal;thetaCutOffTransverse;thetaCutOffBending];
    cutOffAngles = sort(cutOffAngles);
    theta1 = [0:(cutOffAngles(1)/angleFractions):(cutOffAngles(1)),...
        cutOffAngles(1)+delta:(cutOffAngles(2)-cutOffAngles(1))/angleFractions:cutOffAngles(2)...
        cutOffAngles(2)+delta:(cutOffAngles(3)-cutOffAngles(2))/angleFractions:cutOffAngles(3)];
    
    for j=1:length(theta1)
        [ conditionMatrix, C1Fy2,C1Mz2,C1az2,C1Fx2,C1ksi2,C1Fz2,C1zeta2,C2Fx2,C2ksi2,C2Fz2,C2zeta2,...
            C1Fy1,C1Mz1,C1az1,C1Fx1,C1ksi1,C1Fz1,C1zeta1,C2Fx1,C2ksi1,C2Fz1,C2zeta1,...
            thetaCutOffBending,thetaCutOffLongitudinal,thetaCutOffTransverse ] =...
            condMatrixBuild( incidentWavenunber , kb2 , kL2, kT2, kb1 , kL1, kT1,...
            theta1, B1, B2, E1, E2, h1, h2, v1, v2, G1, G2,j,phi1,phi2 );
        
        %RHS force vector-->changes wrt the incident wave the formulation
        forceVector(1) =  E1 * h1 / (1 - v1 ^ 2) * incidentWavenunber^2 *...
            (cos(theta1(j)) ^ 2 + v1 * sin(theta1(j)) ^ 2)* cos(phi1);
        forceVector(2) = E1 * h1 / (1 - v1 ^ 2) * incidentWavenunber^2 *...
            (cos(theta1(j)) ^ 2 + v1 * sin(theta1(j)) ^ 2)* sin(phi1);
        forceVector(3) = 0;
        forceVector(4) = -2 * G1 * h1 * incidentWavenunber^2 * cos(theta1(j)) *sin(theta1(j));
        forceVector(5) = 1i * incidentWavenunber * cos (theta1(j));
        forceVector(6) = 0;
        forceVector(7) = -1i * incidentWavenunber * sin (theta1(j));
        forceVector(8) = 0;
        %          forceVector(9:12) = 0;
        solutionVector = conditionMatrix\transpose(forceVector);
        
        incidentIntensity = 1/2* plate1.getDensity * h1 * w^3 * kL1 *cos(theta1(j));
 %johhanson       
%         if theta1(j)<= thetaCutOffBending
%             thetaBendingTrans = asin(incidentWavenunber/kb2*sin(theta1(j)));
%         else
%             thetaBendingTrans = pi/2;
%         end
%         if theta1(j)<= thetaCutOffLongitudinal
%             thetaLongTrans = asin(incidentWavenunber/kL2*sin(theta1(j)));
%         else
%             thetaLongTrans = pi/2;
%         end
%         if theta1(j)<= thetaCutOffTransverse
%             thetaTransvTrans = asin(incidentWavenunber/kT2*sin(theta1(j)));
%         else
%             thetaTransvTrans = pi/2;
%         end
%         
%         tauL1b2(j) = w*B2*kb2^3*cos(thetaBendingTrans)*...
%             abs(solutionVector(3))^2/incidentIntensity;
%         tauL1L2(j) = 1/2* plate2.getDensity * h2 * w^3 * kL2 *...
%             cos(thetaLongTrans)*...
%             abs(solutionVector(1))^2/incidentIntensity;
%         tauL1T2(j) = 1/2* plate2.getDensity * h2 * w^3 * kT2 *cos(thetaTransvTrans)*...
%             abs(solutionVector(2))^2/incidentIntensity;
        %calculation of intensities:
        %         w = 2 * pi *frequency;
        %         
        %
                bendingTransIntensity = -pi * frequency * imag(C1Fy2 - C1Mz2 * conj(C1az2) ) ...
                    * abs(solutionVector(3))^2;
                longitTransIntensity = -pi * frequency * imag(C1Fx2 * conj(C1ksi2) + C1Fz2 * conj(C1zeta2))...
                    * abs(solutionVector(1))^2;
                transvTransIntensity = -pi * frequency * imag(C2Fx2 * conj(C2ksi2) + C2Fz2 * conj(C2zeta2))...
                    * abs(solutionVector(2))^2;
                bendingRefIntensity = -pi * frequency * imag(C1Fy1 - C1Mz1 * conj(C1az1) ) ...
                    * abs(solutionVector(7))^2;
                longitRefIntensity = -pi * frequency * imag(C1Fx1 * conj(C1ksi1) + C1Fz1 * conj(C1zeta1))...
                    * abs(solutionVector(5))^2;
                transvRefIntensity = -pi * frequency * imag(C2Fx1 * conj(C2ksi1) + C2Fz1 * conj(C2zeta1))...
                    * abs(solutionVector(6))^2;
                tauL1b2(j) = bendingTransIntensity /incidentIntensity;
                tauL1L2(j) = longitTransIntensity / incidentIntensity;
                tauL1T2(j) = transvTransIntensity / incidentIntensity;
                tauL1b1(j) = bendingRefIntensity /incidentIntensity;
                tauL1L1(j) = longitRefIntensity / incidentIntensity;
                tauL1T1(j) = transvRefIntensity / incidentIntensity;
        
        for k=1:3
            if theta1(j)<=cutOffAngles(k) && k==1
                tauL1b2IntegralArea = tauL1b2IntegralArea + tauL1b2(j)*cos(theta1(j)) * cutOffAngles(k) / (angleFractions);
                tauL1L2IntegralArea = tauL1L2IntegralArea + tauL1L2(j)*cos(theta1(j))* cutOffAngles(k) / (angleFractions);
                tauL1T2IntegralArea = tauL1T2IntegralArea + tauL1T2(j)*cos(theta1(j))* cutOffAngles(k) / (angleFractions);
                tauL1b1IntegralArea = tauL1b1IntegralArea + tauL1b1(j)*cos(theta1(j)) * cutOffAngles(k) / (angleFractions);
                tauL1L1IntegralArea = tauL1L1IntegralArea + tauL1L1(j)*cos(theta1(j))* cutOffAngles(k) / (angleFractions);
                tauL1T1IntegralArea = tauL1T1IntegralArea + tauL1T1(j)*cos(theta1(j))* cutOffAngles(k) / (angleFractions);
            elseif theta1(j)<=cutOffAngles(k) && theta1(j)>=cutOffAngles(k-1)
                tauL1b2IntegralArea = tauL1b2IntegralArea + tauL1b2(j)*cos(theta1(j)) * (cutOffAngles(k)-cutOffAngles(k-1))/ (angleFractions);
                tauL1L2IntegralArea = tauL1L2IntegralArea + tauL1L2(j)*cos(theta1(j))* (cutOffAngles(k)-cutOffAngles(k-1)) / (angleFractions);
                tauL1T2IntegralArea = tauL1T2IntegralArea + tauL1T2(j)*cos(theta1(j))* (cutOffAngles(k)-cutOffAngles(k-1)) / (angleFractions);
                tauL1b1IntegralArea = tauL1b1IntegralArea + tauL1b1(j)*cos(theta1(j)) * (cutOffAngles(k)-cutOffAngles(k-1))/ (angleFractions);
                tauL1L1IntegralArea = tauL1L1IntegralArea + tauL1L1(j)*cos(theta1(j))* (cutOffAngles(k)-cutOffAngles(k-1)) / (angleFractions);
                tauL1T1IntegralArea = tauL1T1IntegralArea + tauL1T1(j)*cos(theta1(j))* (cutOffAngles(k)-cutOffAngles(k-1)) / (angleFractions);
            end
        end
        %tau average Calculation
%         if theta1(j)<= thetaCutOffBending
%             tauL1b2IntegralArea = tauL1b2IntegralArea + tauL1b2(j)*cos(theta1(j)) * pi/2 / (length(theta1)-1);
%         end
%         if theta1(j)<= thetaCutOffLongitudinal
%             tauL1L2IntegralArea = tauL1L2IntegralArea + tauL1L2(j)*cos(theta1(j))* pi/2 / (length(theta1)-1);
%         end
%         if theta1(j)<= thetaCutOffTransverse
%             tauL1T2IntegralArea = tauL1T2IntegralArea + tauL1T2(j)*cos(theta1(j))* pi/2 / (length(theta1)-1);
%         end
    end
    %CLFs Calculation
    CLF1l2b(frequencyLoopCount) = plate1.longVel*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*tauL1b2IntegralArea;
    CLF1l2l(frequencyLoopCount) = plate1.longVel*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*tauL1L2IntegralArea;
    CLF1l2t(frequencyLoopCount) = plate1.longVel*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*tauL1T2IntegralArea;
    
    CLF1l1b(frequencyLoopCount) = plate1.longVel*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*tauL1b1IntegralArea;
    CLF1l1l(frequencyLoopCount) = plate1.longVel*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*tauL1L1IntegralArea;
    CLF1l1t(frequencyLoopCount) = plate1.longVel*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*tauL1T1IntegralArea;
    
        %assign them in a 3x3 matrix so that it is easier to handle
    CLF12{frequencyLoopCount}(1,4) = CLF1l2l(frequencyLoopCount);
    CLF12{frequencyLoopCount}(1,5) = CLF1l2t(frequencyLoopCount);
    CLF12{frequencyLoopCount}(1,6) = CLF1l2b(frequencyLoopCount);
    CLF12{frequencyLoopCount}(1,1) = CLF1l1l(frequencyLoopCount);
    CLF12{frequencyLoopCount}(1,2) = CLF1l1t(frequencyLoopCount);
    CLF12{frequencyLoopCount}(1,3) = CLF1l1b(frequencyLoopCount);
    %%  case incindent wave is a transverse wave
    %initialization of the sums
    tauT1b2IntegralArea = 0;
    tauT1L2IntegralArea = 0;
    tauT1T2IntegralArea = 0;
    tauT1b1IntegralArea = 0;
    tauT1L1IntegralArea = 0;
    tauT1T1IntegralArea = 0;
    incidentWavenunber = kT1;
    thetaCutOffBending = asin(kb2/incidentWavenunber);
    thetaCutOffLongitudinal = asin(kL2/incidentWavenunber);
    thetaCutOffTransverse = asin(kT2/incidentWavenunber);
    if imag(thetaCutOffBending)~=0
        thetaCutOffBending = pi/2;
    end
    if imag(thetaCutOffLongitudinal)~=0
        thetaCutOffLongitudinal = pi/2;
    end
    if imag(thetaCutOffTransverse)~=0
        thetaCutOffTransverse = pi/2;
    end
    cutOffAngles = [thetaCutOffLongitudinal;thetaCutOffTransverse;thetaCutOffBending];
    cutOffAngles = sort(cutOffAngles);
    theta1 = [0:(cutOffAngles(1)/angleFractions):(cutOffAngles(1)),...
        cutOffAngles(1)+delta:(cutOffAngles(2)-cutOffAngles(1))/angleFractions:cutOffAngles(2)...
        cutOffAngles(2)+delta:(cutOffAngles(3)-cutOffAngles(2))/angleFractions:cutOffAngles(3)];
    
    for j=1:length(theta1)
        [ conditionMatrix, C1Fy2,C1Mz2,C1az2,C1Fx2,C1ksi2,C1Fz2,C1zeta2,C2Fx2,C2ksi2,C2Fz2,C2zeta2,...
            C1Fy1,C1Mz1,C1az1,C1Fx1,C1ksi1,C1Fz1,C1zeta1,C2Fx1,C2ksi1,C2Fz1,C2zeta1,...
            thetaCutOffBending,thetaCutOffLongitudinal,thetaCutOffTransverse ] =...
            condMatrixBuild( incidentWavenunber , kb2 , kL2, kT2, kb1 , kL1, kT1,...
            theta1, B1, B2, E1, E2, h1, h2, v1, v2, G1, G2 ,j,phi1,phi2 );
        
        %RHS force vector-->changes wrt the incident wave the formulation
        forceVector(1) =  -2 * G1 * h1 * incidentWavenunber^2 *cos(theta1(j)) *sin(theta1(j))  * cos(phi1);
        forceVector(2) = -2 * G1 * h1 * incidentWavenunber^2 *cos(theta1(j)) *sin(theta1(j))  * sin(phi1);
        forceVector(3) = 0;
        forceVector(4) = -  G1 * h1 * incidentWavenunber^2 * (cos(theta1(j))^2 - sin(theta1(j))^2);
        forceVector(5) = -1i * incidentWavenunber * sin (theta1(j));
        forceVector(6) = 0;
        forceVector(7) = -1i * incidentWavenunber * cos (theta1(j));
        forceVector(8) = 0;
        %          forceVector(9:12) = 0;
        solutionVector = conditionMatrix\transpose(forceVector);
        
        
        
        incidentIntensity = 1/2* plate1.getDensity *h1* w^3 * kT1 *cos(theta1(j));
        
%         if theta1(j)<= thetaCutOffBending
%             thetaBendingTrans = asin(incidentWavenunber/kb2*sin(theta1(j)));
%         else
%             thetaBendingTrans = pi/2;
%         end
%         if theta1(j)<= thetaCutOffLongitudinal
%             thetaLongTrans = asin(incidentWavenunber/kL2*sin(theta1(j)));
%         else
%             thetaLongTrans = pi/2;
%         end
%         if theta1(j)<= thetaCutOffTransverse
%             thetaTransvTrans = asin(incidentWavenunber/kT2*sin(theta1(j)));
%         else
%             thetaTransvTrans = pi/2;
%         end
%         
%         tauT1b2(j) = w*B2*kb2^3*cos(thetaBendingTrans)*...
%             abs(solutionVector(3))^2/incidentIntensity;
%         tauT1L2(j) = 1/2* plate2.getDensity * h2 * w^3 * kL2 *...
%             cos(thetaLongTrans)*...
%             abs(solutionVector(1))^2/incidentIntensity;
%         tauT1T2(j) = 1/2* plate2.getDensity * h2 * w^3 * kT2 *cos(thetaTransvTrans)*...
%             abs(solutionVector(2))^2/incidentIntensity;
        
        %calculation of intensities:
        bendingTransIntensity = -pi * frequency * imag(C1Fy2 - C1Mz2 * conj(C1az2) ) ...
            * abs(solutionVector(3))^2;
        longitTransIntensity = -pi * frequency * imag(C1Fx2 * conj(C1ksi2) + C1Fz2 * conj(C1zeta2))...
            * abs(solutionVector(1))^2;
        transvTransIntensity = -pi * frequency * imag(C2Fx2 * conj(C2ksi2) + C2Fz2 * conj(C2zeta2))...
            * abs(solutionVector(2))^2;
         bendingRefIntensity = -pi * frequency * imag(C1Fy1 - C1Mz1 * conj(C1az1) ) ...
            * abs(solutionVector(7))^2;
        longitRefIntensity = -pi * frequency * imag(C1Fx1 * conj(C1ksi1) + C1Fz1 * conj(C1zeta1))...
            * abs(solutionVector(5))^2;
        transvRefIntensity = -pi * frequency * imag(C2Fx1 * conj(C2ksi1) + C2Fz1 * conj(C2zeta1))...
            * abs(solutionVector(6))^2;
        tauT1b2(j) = bendingTransIntensity /incidentIntensity;
        tauT1L2(j) = longitTransIntensity / incidentIntensity;
        tauT1T2(j) = transvTransIntensity / incidentIntensity;
        tauT1b1(j) = bendingRefIntensity /incidentIntensity;
        tauT1L1(j) = longitRefIntensity / incidentIntensity;
        tauT1T1(j) = transvRefIntensity / incidentIntensity;

        for k=1:3
            if theta1(j)<=cutOffAngles(k) && k==1
                tauT1b2IntegralArea = tauT1b2IntegralArea + tauT1b2(j)*cos(theta1(j)) * cutOffAngles(k) / (angleFractions);
                tauT1L2IntegralArea = tauT1L2IntegralArea + tauT1L2(j)*cos(theta1(j))* cutOffAngles(k) / (angleFractions);
                tauT1T2IntegralArea = tauT1T2IntegralArea + tauT1T2(j)*cos(theta1(j))* cutOffAngles(k) / (angleFractions);
                tauT1b1IntegralArea = tauT1b1IntegralArea + tauT1b1(j)*cos(theta1(j)) * cutOffAngles(k) / (angleFractions);
                tauT1L1IntegralArea = tauT1L1IntegralArea + tauT1L1(j)*cos(theta1(j))* cutOffAngles(k) / (angleFractions);
                tauT1T1IntegralArea = tauT1T1IntegralArea + tauT1T1(j)*cos(theta1(j))* cutOffAngles(k) / (angleFractions);
            elseif theta1(j)<=cutOffAngles(k) && theta1(j)>=cutOffAngles(k-1)
                tauT1b2IntegralArea = tauT1b2IntegralArea + tauT1b2(j)*cos(theta1(j)) * (cutOffAngles(k)-cutOffAngles(k-1))/ (angleFractions);
                tauT1L2IntegralArea = tauT1L2IntegralArea + tauT1L2(j)*cos(theta1(j))* (cutOffAngles(k)-cutOffAngles(k-1)) / (angleFractions);
                tauT1T2IntegralArea = tauT1T2IntegralArea + tauT1T2(j)*cos(theta1(j))* (cutOffAngles(k)-cutOffAngles(k-1)) / (angleFractions);
                 tauT1b1IntegralArea = tauT1b1IntegralArea + tauT1b1(j)*cos(theta1(j)) * (cutOffAngles(k)-cutOffAngles(k-1))/ (angleFractions);
                tauT1L1IntegralArea = tauT1L1IntegralArea + tauT1L1(j)*cos(theta1(j))* (cutOffAngles(k)-cutOffAngles(k-1)) / (angleFractions);
                tauT1T1IntegralArea = tauT1T1IntegralArea + tauT1T1(j)*cos(theta1(j))* (cutOffAngles(k)-cutOffAngles(k-1)) / (angleFractions);
            end
        end
        %tau average Calculation
%         if theta1(j)<= thetaCutOffBending
%             tauT1b2IntegralArea = tauT1b2IntegralArea + tauT1b2(j)*cos(theta1(j)) * pi/2 / (length(theta1)-1);
%         end
%         if theta1(j)<= thetaCutOffLongitudinal
%             tauT1L2IntegralArea = tauT1L2IntegralArea + tauT1L2(j)*cos(theta1(j))* pi/2 / (length(theta1)-1);
%         end
%         if theta1(j)<= thetaCutOffTransverse
%             tauT1T2IntegralArea = tauT1T2IntegralArea + tauT1T2(j)*cos(theta1(j))* pi/2 / (length(theta1)-1);
%         end
    end
    %CLFs Calculation
    CLF1t2b(frequencyLoopCount) = plate1.transverseWaveVelocity*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*tauT1b2IntegralArea;
    CLF1t2l(frequencyLoopCount) = plate1.transverseWaveVelocity*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*tauT1L2IntegralArea;
    CLF1t2t(frequencyLoopCount) = plate1.transverseWaveVelocity*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*tauT1T2IntegralArea;
    
    CLF1t1b(frequencyLoopCount) = plate1.transverseWaveVelocity*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*tauT1b1IntegralArea;
    CLF1t1l(frequencyLoopCount) = plate1.transverseWaveVelocity*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*tauT1L1IntegralArea;
    CLF1t1t(frequencyLoopCount) = plate1.transverseWaveVelocity*connectionLength/...
        (pi*2.0*pi*frequency*plate1.getArea)*tauT1T1IntegralArea;
    
           %assign them in a 3x3 matrix so that it is easier to handle
    CLF12{frequencyLoopCount}(2,4) = CLF1t2l(frequencyLoopCount);
    CLF12{frequencyLoopCount}(2,5) = CLF1t2t(frequencyLoopCount);
    CLF12{frequencyLoopCount}(2,6) = CLF1t2b(frequencyLoopCount);
    CLF12{frequencyLoopCount}(2,1) = CLF1t1l(frequencyLoopCount);
    CLF12{frequencyLoopCount}(2,2) = CLF1t1t(frequencyLoopCount);
    CLF12{frequencyLoopCount}(2,3) = CLF1t1b(frequencyLoopCount);
    %calculate the reciprocal CLFs
    modalDensPlate1 = plate1.allModalDensities(frequency);
    modalDensPlate2 = plate2.allModalDensities(frequency);
    for l=1:3
        for m=1:3
            CLF21{frequencyLoopCount}(l,m) = CLF12{frequencyLoopCount}(m,l+3)*modalDensPlate1(m)/...
                modalDensPlate2(l);
        end
    end
end