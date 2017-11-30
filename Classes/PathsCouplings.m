classdef PathsCouplings
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
    
    properties (Access = public)
        idPath %int                  - number of the CLF
        invIdPath%int                -inverse number of the CLF
        couplingLossFactor %float   - value of the CLF for each frequency
        %reciprocalCLF %float        - value of the reciprocal CLF
    end
    
     methods (Access = public)
         
         function self = PathsCouplings(varargin)
             subsystemPath=varargin{1};
             self.idPath=subsystemPath;
             self.couplingLossFactor=varargin{2};
             for i=1:length(subsystemPath)-1
                if subsystemPath(i)~=0 && subsystemPath(i+1)==0
                    self.idPath=subsystemPath(1:i);
                end
             end
         end
     end
end
