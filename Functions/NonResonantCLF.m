function [ CLF1 ] = NonResonantCLF( handles,subsystems, frequencies)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
flag=0;
CLF12(1)=handles.connections(1);
for i=1:length(handles.connections)
    if handles.connections(i).getElementI > handles.val_plate% || handles.connections(i).getElementJ > handles.val_plate
        cav=  handles.connections(i).getElementI ;
        plat=handles.connections(i).getElementJ ;
        for j=1:length(handles.connections)
            if (handles.connections(j).getElementI==plat || handles.connections(j).getElementJ==plat)&&~(handles.connections(j).getElementI==cav || handles.connections(j).getElementJ==cav)&&(handles.connections(j).getElementI > handles.val_plate||handles.connections(j).getElementJ > handles.val_plate)
                if handles.connections(j).getElementI==plat
                    cav2=handles.connections(j).getElementJ;
                else
                    cav2=handles.connections(j).getElementI;
                end
                for k=1:length(CLF12)
                    if ~(strcat(num2str(cav),num2str(cav2))==CLF12(k).getID ||  strcat(num2str(cav),num2str(cav2))==CLF12(k).getInvID)
                      flag=1 ; 
                    end
                end
                if flag==0
                [clftemp1,clftemp2]=NonResonant(subsystems(plat).data,subsystems(cav).data,subsystems(cav2).data,frequencies);
                 CLF12(end+1)=CouplingLossFactor(strcat(num2str(cav),num2str(cav2)),num2str(cav),num2str(cav2),clftemp1,clftemp2,strcat(num2str(cav2),num2str(cav))) ;
                 flag=0;
                end 
                end
            
        end
    elseif handles.connections(i).getElementJ > handles.val_plate
        cav=  handles.connections(i).getElementJ ;
        plat=handles.connections(i).getElementI ;
        for j=1:length(handles.connections)
            if (handles.connections(j).getElementI==plat || handles.connections(j).getElementJ==plat)&&~(handles.connections(j).getElementI==cav || handles.connections(j).getElementJ==cav)&&(handles.connections(j).getElementI > handles.val_plate||handles.connections(j).getElementJ > handles.val_plate)
                if handles.connections(j).getElementI==plat
                    cav2=handles.connections(j).getElementJ;
                else
                    cav2=handles.connections(j).getElementI;
                end
                for k=1:length(CLF12)
                    temp=CLF12(k).getID;
                    temp2=CLF12(k).getInvID;
                    temp3=strcat(num2str(cav),num2str(cav2));
                    if strcmp(temp3,temp) ||  strcmp(temp3,temp2)
                      flag=1 ; 
                    end
                end
                if flag==0
                [clftemp1,clftemp2]=NonResonant(subsystems(plat).data,subsystems(cav).data,subsystems(cav2).data,frequencies);
                CLF12(end+1)=CouplingLossFactor(strcat(num2str(cav),num2str(cav2)),cav,cav2,clftemp1,clftemp2,strcat(num2str(cav2),num2str(cav))) ;
                flag=0;
                end
            end
            
        end
    end
   
end
if length(CLF12)==1
    CLF1=CouplingLossFactor.empty;
else
    CLF1=CLF12(2:end);
end
end

