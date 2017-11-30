function [ pathsof ] = PathAnalysis(subsystems, CLF,noOfElements)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
%UNTITLED Summary of this function goes here
%  This function gives the paths that transmit more energy 
global paths lengthofSub
paths=[];
noOfNeighbor=[];
pathElements=noOfElements;
for i=1:length(subsystems) %find all the neigbouring elements for all subsystems
    counter=1;
    %clfsOfSubsystems=CouplingLossFactor.empty;
    for j=1:length(CLF)
        if subsystems(i).data.getID==CLF(j).getElementI% || subsystems(i).data.getID==CLF(j).getElementJ
            noOfNeighbor(i,counter)=CLF(j).getElementJ;
            counter=counter+1;
        elseif subsystems(i).data.getID==CLF(j).getElementJ
            noOfNeighbor(i,counter)=CLF(j).getElementI;
            counter=counter+1;
        end
    end
end  
%%  call of search fnc
for i=1:length(subsystems)
    lengthofSub(i)=1;
    paths{i}(1,1)=subsystems(i).data.getID;
    SearchNeighbors(subsystems(i).data.getID,noOfElements, noOfElements,subsystems(i).data.getID,noOfNeighbor)
end
%% delete all unnecesary elements of the paths (paths that cross twice the same subsystem)
for i=1:length(subsystems)% for all subsystems
    j=1;
    while j<=length(paths{i}(:,1))% for all the paths derived from those subsystems
        flag=0;
        k=1;
        while flag==0 && k<=length(paths{i}(j,:))% length of respective row of path
            l=1; 
            controlValue=paths{i}(j,k);
             while flag==0 && l<=length(paths{i}(j,:)) 
                if (controlValue==paths{i}(j,l) && (k~=l) && controlValue>0)
                    flag=1;
                    %break
                end
                 l=l+1;
             end
             k=k+1;
        end

        if flag==1 % delete the row when the repeating element has been found
            paths{i}(j,:)=[];
            j=j-1;
        end
        j=j+1;
    end
end
%% delete all the rows that contain only two subsystems as they are just CLFs not paths.
for i=1:length(subsystems)
    j=1;
    while j<=length(paths{i}(:,1))
        if  paths{i}(j,3)==0
            paths{i}(j,:)=[];
            j=j-1;
        end
        j=j+1;
    end
   
end
%% delete all same rows
for i=1:length(subsystems)
    k=1;
    while k<=length(paths{i}(:,1))
        j=k+1;
        while j<=length(paths{i}(:,1))
            if  paths{i}(k,:)==paths{i}(j,:)
                paths{i}(j,:)=[];
                j=j-1;
            end
            j=j+1;
        end
        k=k+1;
    end
end
%% calculate total losses CLfs for all subsystems
for i=1:length(subsystems)
    TotalCLF{i}=zeros(22,1);
     for j=1:length(CLF)
        if subsystems(i).data.getID==CLF(j).getElementI
            TotalCLF{i}=TotalCLF{i}+CLF(j).getCLF;
        elseif subsystems(i).data.getID==CLF(j).getElementJ
            TotalCLF{i}=TotalCLF{i}+CLF(j).getRCLF;
        end
     end
    TotalCLF{i}=TotalCLF{i}+subsystems(i).data.getDLF; 
end
%% after that i should calculate the total path CLF
pathsCLF=PathsCouplings.empty;
for i=1:length(subsystems)
    for j=1:length(paths{i}(:,1))
        tempPathCLF=ones(22,1);
        for k=1:length(paths{i}(j,:))-1
            if paths{i}(j,k+1)~=0
               for l=1:length(CLF)
                    if paths{i}(j,k)==CLF(l).getElementI && paths{i}(j,k+1)==CLF(l).getElementJ
                        tempPathCLF=tempPathCLF./CLF(l).getCLF;
                        tempPathCLF=tempPathCLF.*TotalCLF{i};
                    elseif paths{i}(j,k)==CLF(l).getElementJ && paths{i}(j,k+1)==CLF(l).getElementI
                        tempPathCLF=tempPathCLF./CLF(l).getRCLF;
                         tempPathCLF=tempPathCLF.*TotalCLF{i};
                    end
               end
            end
        end
        pathsCLF(end+1)=PathsCouplings(paths{i}(j,:),tempPathCLF);
    end
end
pathsof=pathsCLF;
%%
%     for j=1:length(clfsOfSubsystems)
%         if subsystems(i).data.getID==clfsOfSubsystems(j).getElementI 
%             tempSub=clfsOfSubsystems(j).getElementJ; 
%             counter=1;
%                 while counter< pathElements
%                      for k=1:length(CLF)
%                         if tempSub==CLF(k).getElementI
%                             pathsSubs(:,end+1)=clfsOfSubsystems(j).getCLF.*CLF(k).getCLF;
%                             tempSub=CLF(k).getElementJ;
%                         else
%                         end
%                      end
%                     counter=counter+1;
%                 end
%         elseif subsystems(i).data.getID==CLF.getElementJ
% 
%         end
%     end
end




