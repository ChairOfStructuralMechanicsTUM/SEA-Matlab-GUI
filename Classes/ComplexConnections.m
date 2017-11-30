classdef ComplexConnections
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%    
% Class definition for complex connections.
% Including porperties, constructorsand accessor methods.
    
    properties (Access = private)
        idCLF %int          - number of the CLF
        elemI %int          - first element of the coupling
        elemJ %int          - second element of the coupling
        elemK %int          - third element of the coupling
        elemL %int          - fourt element of the coupling
        vecOfCLFs %float    - vector of CLFs for each frequency
        type %string        - type of connection ('tee','cross')
    end
    
    methods (Access = public)
        
        %% Constructors
        function self= ComplexConnections(varargin)
            
            %T-connection of three plates
            if nargin==5
                plate1=varargin{1};
                plate2=varargin{2};
                plate3=varargin{3};
                frequencies=varargin{4};
                lengthOfConnection=varargin{5};
                
                numberOfAngleFractions = 100.0;
                
                self.elemI=plate1.getID;
                self.elemJ=plate2.getID;
                self.elemK=plate3.getID;
                
                %calculate the CLFs
                [CLF12,CLF13,CLF23,CLF21,CLF31,CLF32]=CLFTeeConn(plate1,...
                    plate2,plate3,lengthOfConnection,frequencies,...
                    numberOfAngleFractions);
                
                %store vector of CLFs
                CLF(1)=CouplingLossFactor(strcat(num2str(self.elemI),...
                    num2str(self.elemJ)),self.elemI,self.elemJ,CLF12,CLF21,strcat(num2str(self.elemJ),...
                    num2str(self.elemI)));
                CLF(2)=CouplingLossFactor(strcat(num2str(self.elemI),...
                    num2str(self.elemK)),self.elemI,self.elemK,CLF13,CLF31,strcat(num2str(self.elemK),...
                    num2str(self.elemI)));
                CLF(3)=CouplingLossFactor(strcat(num2str(self.elemJ),...
                    num2str(self.elemK)),self.elemJ,self.elemK,CLF23,CLF32,strcat(num2str(self.elemK),...
                    num2str(self.elemJ)));
                self.vecOfCLFs=CLF;
                
                %set type to T-connection
                self.type='tee';
                
                %X-connection with three plates
            elseif nargin==6
                plate1=varargin{1};
                plate2=varargin{2};
                plate3=varargin{3};
                plate4=varargin{4};
                frequencies=varargin{5};
                lengthOfConnection=varargin{6};
                
                numberOfAngleFractions = 100.0;
                
                self.elemI=plate1.getID;
                self.elemJ=plate2.getID;
                self.elemK=plate3.getID;
                self.elemL=plate4.getID;
                
                %calculate the CLFs
                [CLF12,CLF13,CLF14,CLF23,CLF21,CLF24,CLF31,CLF32,...
                    CLF34,CLF41,CLF42,CLF43]=CLFCrossConn(plate1,plate2,...
                    plate3,plate4,lengthOfConnection,frequencies,...
                    numberOfAngleFractions);
                
                %store vector of CLF
                CLF(1)=CouplingLossFactor(strcat(num2str(self.elemI),...
                    num2str(self.elemJ)),self.elemI,self.elemJ,CLF12,CLF21,strcat(num2str(self.elemJ),...
                    num2str(self.elemI)));
                CLF(2)=CouplingLossFactor(strcat(num2str(self.elemI),...
                    num2str(self.elemK)),self.elemI,self.elemK,CLF13,CLF31,strcat(num2str(self.elemK),...
                    num2str(self.elemI)));
                CLF(3)=CouplingLossFactor(strcat(num2str(self.elemJ),...
                    num2str(self.elemK)),self.elemJ,self.elemK,CLF23,CLF32,strcat(num2str(self.elemK),...
                    num2str(self.elemJ)));
                CLF(4)=CouplingLossFactor(strcat(num2str(self.elemI),...
                    num2str(self.elemL)),self.elemI,self.elemL,CLF14,CLF41,strcat(num2str(self.elemL),...
                    num2str(self.elemI)));
                CLF(5)=CouplingLossFactor(strcat(num2str(self.elemJ),...
                    num2str(self.elemL)),self.elemJ,self.elemL,CLF24,CLF42,strcat(num2str(self.elemL),...
                    num2str(self.elemJ)));
                CLF(6)=CouplingLossFactor(strcat(num2str(self.elemK),...
                    num2str(self.elemL)),self.elemK,self.elemL,CLF34,CLF43,strcat(num2str(self.elemL),...
                    num2str(self.elemK)));
                self.vecOfCLFs=CLF;
                
                %set type to X-connection
                self.type='cross';
            end
            
        end
        
        %% Accessor methods
        %return number of CLF
        function retrn = getID(clf)
            retrn = clf.idCLF;
        end
        
        %return number of element I
        function retrn = getElementI(clf)
            retrn = clf.elemI;
        end
        
        %return number of element J
        function retrn = getElementJ(clf)
            retrn = clf.elemJ;
        end
        
        %return number of element K
        function retrn = getElementK(clf)
            retrn = clf.elemK;
        end
        
        %return number of element L
        function retrn = getElementL(clf)
            retrn = clf.elemL;
        end
        
        %return vector of CLFs
        function retrn = getVecOfCLFs(clf)
            retrn = clf.vecOfCLFs;
        end
        
        %return type of connection
        function retrn = getType(clf)
            retrn = clf.type;
        end
        
    end
    
end

