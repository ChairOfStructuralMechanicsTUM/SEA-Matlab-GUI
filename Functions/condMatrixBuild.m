function [ conditionMatrix, C1Fy2,C1Mz2,C1az2,C1Fx2,C1ksi2,C1Fz2,C1zeta2,C2Fx2,C2ksi2,C2Fz2,C2zeta2,...
    C1Fy1,C1Mz1,C1az1,C1Fx1,C1ksi1,C1Fz1,C1zeta1,C2Fx1,C2ksi1,C2Fz1,C2zeta1,...
    thetaCutOffBending,thetaCutOffLongitudinal,thetaCutOffTransverse ] =...
    condMatrixBuild( incidentWavenunber , kb2 , kL2, kT2, kb1 , kL1, kT1,...
    theta1, B1, B2, E1, E2, h1, h2, v1, v2, G1, G2,j,phi1,phi2 )
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%cut-off angles for all waves of second plate
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
     
     %transmitted waves wavenumbers
    
            %bending wave transmitted far 
        if theta1(j) <= thetaCutOffBending
            kB1x1 = sqrt(kb1^2 - power(incidentWavenunber*sin(theta1(j)),2));
            kB2x1 = sqrt(kb2^2 - power(incidentWavenunber*sin(theta1(j)),2));
        else
            kB1x1 = -1i * sqrt(-kb1^2 + power(incidentWavenunber*sin(theta1(j)),2));
            kB2x1 = -1i * sqrt(-kb2^2 + power(incidentWavenunber*sin(theta1(j)),2));
        end
            %bending nearfield wave
            kB1x2 = -1i * sqrt(kb1^2 + power(incidentWavenunber*sin(theta1(j)),2));
            kB2x2 = -1i * sqrt(kb2^2 + power(incidentWavenunber*sin(theta1(j)),2));
            
            %longitudinal wave 
        if theta1(j) <= thetaCutOffLongitudinal
            kL1x = sqrt(kL1^2 - power(incidentWavenunber*sin(theta1(j)),2));
            kL2x = sqrt(kL2^2 - power(incidentWavenunber*sin(theta1(j)),2));
        else
            kL1x = -1i * sqrt(-kL1^2 + power(incidentWavenunber*sin(theta1(j)),2));
            kL2x = -1i * sqrt(-kL2^2 + power(incidentWavenunber*sin(theta1(j)),2));
        end
        
            %tranverse wave 
        if theta1(j) <= thetaCutOffTransverse
            kT1x = sqrt(kT1^2 - power(incidentWavenunber*sin(theta1(j)),2));
            kT2x = sqrt(kT2^2 - power(incidentWavenunber*sin(theta1(j)),2));
        else
            kT1x = -1i * sqrt(-kT1^2 + power(incidentWavenunber*sin(theta1(j)),2));
            kT2x = -1i * sqrt(-kT2^2 + power(incidentWavenunber*sin(theta1(j)),2));
        end
        %% second plate entries
        conditionMatrix(1,1) = -E2 * h2 / (1 - v2^2) * (kL2x^2 + v2 * incidentWavenunber^2 *...
            sin(theta1(j))^2) * cos (phi2) ;
        conditionMatrix(1,2) = - 2 * G2 * h2 * kT2x * incidentWavenunber * sin(theta1(j)) * cos(phi2);
        conditionMatrix(1,3) = 1i * B2 * kB2x1 * (kB2x1^2 + (2 - v2) * incidentWavenunber^2 *...
            sin(theta1(j))^2 ) * sin( phi2);
        conditionMatrix(1,4) = 1i* B2 * kB2x2 * (kB2x2^2 + (2 - v2) * incidentWavenunber^2 *...
            sin(theta1(j))^2 ) * sin( phi2);
        
         conditionMatrix(2,1) =  -E2 * h2 / (1 - v2^2) * (kL2x^2 + v2 * incidentWavenunber^2 *...
            sin(theta1(j))^2) * sin (phi2) ;
        conditionMatrix(2,2) = - 2 * G2 * h2 * kT2x * incidentWavenunber * sin(theta1(j)) * sin(phi2);
        conditionMatrix(2,3) = -1i * B2 * kB2x1 * (kB2x1^2 + (2 - v2) * incidentWavenunber^2 *...
            sin(theta1(j))^2 ) * cos( phi2);
        conditionMatrix(2,4) = -1i* B2 * kB2x2 * (kB2x2^2 + (2 - v2) * incidentWavenunber^2 *...
            sin(theta1(j))^2 ) * cos( phi2);
        
         conditionMatrix(3,1) = 0;
         conditionMatrix(3,2) = 0;
        conditionMatrix(3,3) = - B2 * (kB2x1^2 + v2 * incidentWavenunber^2 *...
            sin(theta1(j))^2 );
        conditionMatrix(3,4) = - B2 * (kB2x2^2 + v2 * incidentWavenunber^2 *...
            sin(theta1(j))^2 );
        
         conditionMatrix(4,1) = -2 * G2 * h2 * kL2x * incidentWavenunber *sin( theta1(j));
         conditionMatrix(4,2) = -G2 * h2 *( incidentWavenunber^2 * sin(theta1(j))^2 - kT2x^2);
         conditionMatrix(4,3) = 0;
         conditionMatrix(4,4) = 0;
         
%          conditionMatrix(5:8,1:4) = 0;
         
         conditionMatrix(5,1) = -1i * kL2x * cos(phi2);
         conditionMatrix(5,2) = -1i * incidentWavenunber * sin(theta1(j)) * cos(phi2);
         conditionMatrix(5,3) = -1 * sin(phi2) ;
         conditionMatrix(5,4) = -1 * sin(phi2) ;
         
         conditionMatrix(6,1) = -1i * kL2x * sin(phi2);
         conditionMatrix(6,2) = -1i * incidentWavenunber * sin(theta1(j)) * sin(phi2);
         conditionMatrix(6,3) = 1 * cos(phi2);
         conditionMatrix(6,4) = 1* cos(phi2);
         
         conditionMatrix(7,1) = -1i * incidentWavenunber * sin(theta1(j));
         conditionMatrix(7,2) = 1i * kT2x;
         conditionMatrix(7,3) = 0;
         conditionMatrix(7,4) = 0;
         
         conditionMatrix(8,1) = 0;
         conditionMatrix(8,2) = 0;
         conditionMatrix(8,3) = -1i * kB2x1;
         conditionMatrix(8,4) = -1i * kB2x2;
         
%          conditionMatrix(9,9) = -cos (phi2);
%          conditionMatrix(9,10) = - sin (phi2);
%          conditionMatrix(9,11:12) = 0;
%          
%          conditionMatrix(10,1) = 0;
%          conditionMatrix(10,2) = 0;
%          conditionMatrix(10,3) = 1;
%          conditionMatrix(10,4) = 1;
%          
%          conditionMatrix(10,9) = sin (phi2);
%          conditionMatrix(10,10) = - cos (phi2);
%          conditionMatrix(10,11:12) = 0;
%          
%          conditionMatrix(11,1) = -1i * incidentWavenunber * sin(theta1(j));
%          conditionMatrix(11,2) = 1i * kT2x;
%          conditionMatrix(11,3) = 0;
%          conditionMatrix(11,4) = 0;
%          
%          conditionMatrix(11,9) = 0;
%          conditionMatrix(11,10) = 0;
%          conditionMatrix(11,11) = -1;
%          conditionMatrix(11,12) = 0;
%          
%          conditionMatrix(12,1) = 0;
%          conditionMatrix(12,2) = 0;
%          conditionMatrix(12,3) = -1i * kB2x1;
%          conditionMatrix(12,4) = -1i * kB2x2;
%          
%          conditionMatrix(12,9) = 0;
%          conditionMatrix(12,10) = 0;
%          conditionMatrix(12,11) = 0;
%          conditionMatrix(12,12) = -1;
        
        %% first plate entries
        conditionMatrix(1,5) = -E1 * h1 / (1 - v1^2) * (kL1x^2 + v1 * incidentWavenunber^2 *...
            sin(theta1(j))^2) * cos (phi1) ;
        conditionMatrix(1,6) = - 2 * G1 * h1 * kT1x * incidentWavenunber * sin(theta1(j)) * cos(phi1);
         conditionMatrix(1,7) = 1i * B1 * kB1x1 * (kB1x1^2 + (2 - v1) * incidentWavenunber^2 *...
            sin(theta1(j))^2 ) * sin( phi1);
        conditionMatrix(1,8) = 1i* B1 * kB1x2 * (kB1x2^2 + (2 - v1) * incidentWavenunber^2 *...
            sin(theta1(j))^2 ) * sin( phi1);
        
        conditionMatrix(2,5) =  -E1 * h1 / (1 - v1^2) * (kL1x^2 + v1 * incidentWavenunber^2 *...
            sin(theta1(j))^2) * sin (phi1) ;
        conditionMatrix(2,6) = - 2 * G1 * h1 * kT1x * incidentWavenunber * sin(theta1(j)) * sin(phi1);
        conditionMatrix(2,7) = -1i * B1 * kB1x1 * (kB1x1^2 + (2 - v1) * incidentWavenunber^2 *...
            sin(theta1(j))^2 ) * cos( phi1);
        conditionMatrix(2,8) = -1i* B1 * kB1x2 * (kB1x2^2 + (2 - v1) * incidentWavenunber^2 *...
            sin(theta1(j))^2 ) * cos( phi1);
        
        conditionMatrix(3,5) = 0;
         conditionMatrix(3,6) = 0;
        conditionMatrix(3,7) = - B1 * (kB1x1^2 + v1 * incidentWavenunber^2 *...
            sin(theta1(j))^2 );
        conditionMatrix(3,8) = - B1 * (kB1x2^2 + v1 * incidentWavenunber^2 *...
            sin(theta1(j))^2 );
        
        conditionMatrix(4,5) = -2 * G1 * h1 * kL1x * incidentWavenunber *sin( theta1(j));
         conditionMatrix(4,6) = -G1 * h1 *( incidentWavenunber^2 * sin(theta1(j))^2 - kT1x^2);
         conditionMatrix(4,7) = 0;
         conditionMatrix(4,8) = 0;
         
         %this should be changed if angle of 1st plate is different than 0 
         conditionMatrix(5,5) = 1i * kL1x;
         conditionMatrix(5,6) = 1i * incidentWavenunber * sin(theta1(j));
         conditionMatrix(5,7) = 0;
         conditionMatrix(5,8) = 0;
         
%          conditionMatrix(5,9) = -cos (phi1);
%          conditionMatrix(5,10) = - sin (phi1);
%          conditionMatrix(5,11:12) = 0;

         %this should be changed if angle of 1st plate is different than 0 
         conditionMatrix(6,5) = 0;
         conditionMatrix(6,6) = 0;
         conditionMatrix(6,7) = -1;
         conditionMatrix(6,8) = -1;
         
%          conditionMatrix(6,9) = sin (phi1);
%          conditionMatrix(6,10) = - cos (phi1);
%          conditionMatrix(6,11:12) = 0;
         
         conditionMatrix(7,5) = 1i * incidentWavenunber * sin(theta1(j));
         conditionMatrix(7,6) = -1i * kT1x;
         conditionMatrix(7,7) = 0;
         conditionMatrix(7,8) = 0;
         
%          conditionMatrix(7,9) = 0;
%          conditionMatrix(7,10) = 0;
%          conditionMatrix(7,11) = -1;
%          conditionMatrix(7,12) = 0;
         
         conditionMatrix(8,5) = 0;
         conditionMatrix(8,6) = 0;
         conditionMatrix(8,7) = 1i * kB1x1;
         conditionMatrix(8,8) = 1i * kB1x2;
         
%          conditionMatrix(8,9) = 0;
%          conditionMatrix(8,10) = 0;
%          conditionMatrix(8,11) = 0;
%          conditionMatrix(8,12) = -1;
         
%          conditionMatrix(9:12,5:8) = 0; 
%          
%          conditionMatrix(1:4,9:12) = 0; 
        C1Fy2 = -1i * B2 * kB2x1 * (kB2x1^2 + (2-v2) * incidentWavenunber^2*sin(theta1(j)));
        C1Mz2 = B2 * (kB2x1^2 + v2 * incidentWavenunber^2 * sin(theta1(j)));
        C1az2 = -1i * kB2x1;
        C1Fx2 = -  E2 * h2 /(1-v2^2) * (kL2x^2 + v2 * incidentWavenunber^2 * sin(theta1(j))^2);
        C1ksi2 = -1i*kL2x;
        C1Fz2 = -2* G2 * h2* kL2x * incidentWavenunber * sin(theta1(j));
        C1zeta2 = -1i*incidentWavenunber *sin(theta1(j));
        C2Fx2 = -2 *G2*h2*kT2x*incidentWavenunber*sin(theta1(j));
        C2ksi2 = -1i*incidentWavenunber *sin(theta1(j));
        C2Fz2 = -G2 * h2 * (incidentWavenunber^2*sin(theta1(j))^2 - kT2x^2);
        C2zeta2 = 1i * kT2x ; 
        %for plate 1
        
          C1Fy1 = -1i * B1 * kB1x1 * (kB1x1^2 + (2-v1) * incidentWavenunber^2*sin(theta1(j)));
        C1Mz1 = B1 * (kB1x1^2 + v1 * incidentWavenunber^2 * sin(theta1(j)));
        C1az1 = -1i * kB1x1;
        C1Fx1 = -  E1 * h1 /(1-v1^2) * (kL1x^2 + v1 * incidentWavenunber^2 * sin(theta1(j))^2);
        C1ksi1 = -1i*kL1x;
        C1Fz1 = -2* G1 * h1* kL1x * incidentWavenunber * sin(theta1(j));
        C1zeta1 = -1i*incidentWavenunber *sin(theta1(j));
        C2Fx1 = -2 *G1*h1*kT1x*incidentWavenunber*sin(theta1(j));
        C2ksi1 = -1i*incidentWavenunber *sin(theta1(j));
        C2Fz1 = -G1 * h1 * (incidentWavenunber^2*sin(theta1(j))^2 - kT1x^2);
        C2zeta1 = 1i * kT1x ;
        
end

