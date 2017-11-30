function [ ] = SearchNeighbors(startingSub,targetLevel, levelgen,idSub,neighbors)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global paths lengthofSub
if idSub~=0
    for i=1:length(neighbors(idSub,:))
        %     lengthofSub(startingSub)=lengthofSub(startingSub)+1;
        level=levelgen;
        d=size(paths{startingSub},1);%how many rows already exist
        %     if startingSub>1
        %         d=d+1-max(lengthofSub);%kati dn paei kala edo..dn ksero pou vazei tis times..
        % %         for j=1:startingSub-1
        % %             d=d-lengthofSub(j);
        % %         end
        %     end
        for j=1:1+targetLevel-level%copies all the entries of the previous row till the column that they branch
            
            paths{startingSub}(d+1,j)=paths{startingSub}(d,j);
            
        end
        % paths(startingSub,end+1)=paths(startingSub,end,1:1+targetLevel-level);
        paths{startingSub}(end,2+targetLevel-level)=neighbors(idSub,i);% adds the next subsystem after the branch
        if level==0 && i==length(neighbors(idSub,:))
            return
        elseif level>0
            level=level-1;
            %if idSub~=0
                SearchNeighbors(startingSub,targetLevel, level,neighbors(idSub,i),neighbors)
            %end
        end
    end
% else
%     return
end

end

