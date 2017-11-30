function [energyVectorStore,CLFMatrixStore] = SolveSystem(noOfSubsystems,...
    noOfCLFs,CLFs,DLFs,frequencies,powerInput,subsystems)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
%   This function calculates solves the systems for the energies at each
%   frequency.
%
%   Input:
%           noOfSubsystems (int)    number of subsystems
%
%           noOfCLFs (int)          number of CLFs
%
%           CLFs (float array)      array with the CLFs at each frequency
%
%           DLFs (float array)      array with the DLFs of the subsystems
%
%           frequencies             array with the frequencies
%           (float array)
%
%           powerInputStore         array with the global power input
%           (float array)
%
%   Output:
%
%           energyVectorStore       array with the energies of each
%           (float array)           subsystem at each frequency
%
%           CLFMatrixStore          matrix with the CLFs and DLFs at
%           (float matrix)          each frequency

global allWavesFlag
if ~allWavesFlag
    %initialization of variables
    CLFMatrixStore = zeros(length(frequencies),noOfSubsystems,noOfSubsystems);
    energyVectorStore = zeros(noOfSubsystems,length(frequencies));
    
    %calculation for each frequency
    for frequencyLoopCount=1:length(frequencies)
        
        %current frequency
        frequency=frequencies(frequencyLoopCount);
        
        %initialize local (means: at each frequency) CLF matrix
        CLFMatrixLocal = zeros(noOfSubsystems,noOfSubsystems);
        
        %set up the local CLF matrix
        for i=1:noOfCLFs
            elementI = CLFs(i).getElementI;
            elementJ = CLFs(i).getElementJ;
            etaijNorm = CLFs(i).getCLF;
            etaijrecipr = CLFs(i).getRCLF;
            CLFMatrixLocal(elementI,elementJ) = -etaijrecipr(frequencyLoopCount);
            CLFMatrixLocal(elementJ,elementI) = -etaijNorm(frequencyLoopCount);
            for noEli=1:noOfSubsystems
                if noEli==elementI
                    CLFMatrixLocal(noEli,noEli) = CLFMatrixLocal(noEli,...
                        noEli)+etaijNorm(frequencyLoopCount);
                elseif noEli==elementJ
                    CLFMatrixLocal(noEli,noEli) = CLFMatrixLocal(noEli,...
                        noEli)+etaijrecipr(frequencyLoopCount);
                end
            end
        end
        
        %add the damping loss factors to the local CLF matrix
        for i=1:noOfSubsystems
            CLFMatrixLocal(i,i) = CLFMatrixLocal(i,i)+DLFs(i);
        end
        
        CLFMatrixLocal = CLFMatrixLocal*2.0*pi*frequency;
        
        %store CLF Matrix
        CLFMatrixStore(frequencyLoopCount,:,:) = CLFMatrixLocal;
        
        %solve the system for energies
        energyVectorLocal = CLFMatrixLocal\powerInput(:,...
            frequencyLoopCount);
        
        %store energy vector
        energyVectorStore(:,frequencyLoopCount) = energyVectorLocal;
    end
else
    for frequencyLoopCount=1:length(frequencies)
        CLFMatrixLocal = zeros(subsystems(1)*3+(subsystems(2)-1),subsystems(1)*3+(subsystems(2)-1));
        %current frequency
        frequency=frequencies(frequencyLoopCount);
        %set up the local CLF matrix
        for i=1:noOfCLFs
            elementI = CLFs(i).getElementI;
            elementJ = CLFs(i).getElementJ;
            etaijNorm = CLFs(i).getCLF;
            etaijrecipr = CLFs(i).getRCLF;
            if elementI<=subsystems(1) && elementJ<=subsystems(1)
            for j=1:3
                %place the CLF of the reflection
                for k=1:3
                    if k~=j
                        CLFMatrixLocal((elementI-1)*3+k,(elementI-1)*3+j) = CLFMatrixLocal((elementI-1)*3+k,(elementI-1)*3+j) -etaijNorm{frequencyLoopCount}(j,k);
                        CLFMatrixLocal((elementJ-1)*3+k,(elementJ-1)*3+j) = CLFMatrixLocal((elementJ-1)*3+k,(elementJ-1)*3+j) -etaijrecipr{frequencyLoopCount}(j,k);
                    end
                end
                %place the CLF of the transmission
                for k=4:6
                    
                    CLFMatrixLocal((elementI-1)*3+k-3,(elementJ-1)*3+j) = CLFMatrixLocal((elementI-1)*3+k-3,(elementJ-1)*3+j) -etaijrecipr{frequencyLoopCount}(j,k);
                    CLFMatrixLocal((elementJ-1)*3+k-3,(elementI-1)*3+j) = CLFMatrixLocal((elementJ-1)*3+k-3,(elementI-1)*3+j) -etaijNorm{frequencyLoopCount}(j,k);
                end
            end
            else % here the cavity plate should be added
                if elementI<=subsystems(1)
                    CLFMatrixLocal(subsystems(1)*3+elementJ-subsystems(1),elementI*3) = CLFMatrixLocal(subsystems(1)*3+elementJ-subsystems(1),elementI*3)-etaijNorm(frequencyLoopCount);
                    CLFMatrixLocal(elementI*3,subsystems(1)*3+elementJ-subsystems(1)) = CLFMatrixLocal(elementI*3,subsystems(1)*3+elementJ-subsystems(1)) -etaijrecipr(frequencyLoopCount);
                else
                    CLFMatrixLocal(subsystems(1)*3+elementI-subsystems(1),elementJ*3) = CLFMatrixLocal(subsystems(1)*3+elementJ-subsystems(1),elementI*3)-etaijrecipr(frequencyLoopCount);
                    CLFMatrixLocal(elementJ*3,subsystems(1)*3+elementI-subsystems(1)) = CLFMatrixLocal(elementI*3,subsystems(1)*3+elementJ-subsystems(1)) -etaijNorm(frequencyLoopCount);
                end
            end
%             diagonal = -sum(CLFMatrixLocal,1);
%             for diag =1:length(CLFMatrixLocal(1,:))
%                 CLFMatrixLocal(diag,diag) = diagonal(diag) + DLFs(diag);
%             end
        end
        diagonal = -sum(CLFMatrixLocal,1);
        for diag =1:length(CLFMatrixLocal(1,:))
            CLFMatrixLocal(diag,diag) = diagonal(diag) + DLFs(diag);
        end
        CLFMatrixLocal = CLFMatrixLocal*2.0*pi*frequency;
        
        %store CLF Matrix
        CLFMatrixStore(frequencyLoopCount,:,:) = CLFMatrixLocal;
        
        %solve the system for energies
        energyVectorLocal = CLFMatrixLocal\powerInput(:,...
            frequencyLoopCount);
        
        %store energy vector
        energyVectorStore(:,frequencyLoopCount) = energyVectorLocal;
    end
end
end

