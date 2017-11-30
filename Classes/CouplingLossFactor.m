classdef CouplingLossFactor
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%    
% Class definition for coupling loss factors.
% Including porperties, constructors and accessor methods.
    
    properties (Access = public)
        idCLF %int                  - number of the CLF
        invIdCLF%int                -inverse number of the CLF
        elemI %int                  - first element of the coupling
        elemJ %int                  - second element of the coupling
        couplingLossFactor %float   - value of the CLF for each frequency
        reciprocalCLF %float        - value of the reciprocal CLF
        
    end
    
    methods (Access = public)
        
        %% Constructors
        function self = CouplingLossFactor(varargin)
            
            %plate to cavity coupling
            if nargin==3 || nargin==4 || nargin==5
                if isa(varargin{2},'Cavity') %plate to cavity
                    plate1=varargin{1};
                    cavity1=varargin{2};
                    frequencies=varargin{3};
                    
                    self.elemI=plate1.getID;
                    self.elemJ=cavity1.getID;
                    self.idCLF=strcat(num2str(self.elemI),...
                        num2str(self.elemJ));
                    self.invIdCLF=strcat(num2str(self.elemJ),...
                        num2str(self.elemI));
                    %calculate the CLFs
                    [CLF12, CLF21] = couplingLossFactorPlate2CavityFull(...
                        plate1,cavity1,frequencies);
                    
                    %store CLF and reciprocal CLF
                    self.couplingLossFactor=transpose(CLF12);
                    self.reciprocalCLF=transpose(CLF21);
                    
                elseif isa(varargin{1},'Cavity') %cavity to plate
                    plate1=varargin{2};
                    cavity1=varargin{1};
                    frequencies=varargin{3};
                    
                    self.elemI=cavity1.getID;
                    self.elemJ=plate1.getID;
                    self.idCLF=strcat(num2str(self.elemI),...
                        num2str(self.elemJ));
                    self.invIdCLF=strcat(num2str(self.elemJ),...
                        num2str(self.elemI));
                    %calculate the CLFs
                    [CLF21, CLF12] = couplingLossFactorPlate2CavityFull(...
                        plate1,cavity1,frequencies);
                    
                    %store CLF and reciprocal CLF
                    self.couplingLossFactor=transpose(CLF12);
                    self.reciprocalCLF=transpose(CLF21);
                    
                else %two plates
                    global allWavesFlag
                    plate1=varargin{1};
                    plate2=varargin{2};
                    frequencies=varargin{3};
                    lengthOfConnection=varargin{4};
                    if allWavesFlag
                        angleOfConnection=varargin{5};
                    end
                    numberOfAngleFractions = 100;
                    
                    self.elemI=plate1.getID;
                    self.elemJ=plate2.getID;
                    self.idCLF=strcat(num2str(self.elemI),...
                        num2str(self.elemJ));
                    self.invIdCLF=strcat(num2str(self.elemJ),...
                        num2str(self.elemI));
                    
                    %calculate the CLFs
                    if ~allWavesFlag
                    [CLF12,CLF21] = couplingLossFactorPlate2PlateFull(...
                        plate1,plate2,lengthOfConnection,frequencies,...
                        numberOfAngleFractions);
                    else
                     [~,~,~,~,~,~,~,~,~, CLF12,~,~,~,~,~,~,~] = couplingLossFactorPlate2PlateFullAllWaves(plate1,...
                         plate2,lengthOfConnection,frequencies,numberOfAngleFractions,angleOfConnection);
                     
                     [~,~,~,~,~,~,~,~,~, CLF21,~,~,~,~,~,~,~] = couplingLossFactorPlate2PlateFullAllWaves(plate2,...
                         plate1,lengthOfConnection,frequencies,numberOfAngleFractions,angleOfConnection);
                    end
                     
                    %store CLF and reciprocal CLF
                    self.couplingLossFactor=CLF12;
                    self.reciprocalCLF=CLF21;
                end
                
            elseif nargin==6 %constructior without further calculations
                self.idCLF=varargin{1};
                self.elemI=varargin{2};
                self.elemJ=varargin{3};
                self.couplingLossFactor=varargin{4};
                self.reciprocalCLF=varargin{5};
                self.invIdCLF=varargin{6};
            end
        end
        
        %% Accessor methods
        %return number of CLF
        function retrn = getID(clf)
            retrn = clf.idCLF;
        end
        %return inverse number of CLF 
         function retrn = getInvID(clf)
            retrn = clf.invIdCLF;
        end
        
        %return number of element I
        function retrn = getElementI(clf)
            retrn = clf.elemI;
        end
        
        %return number of element J
        function retrn = getElementJ(clf)
            retrn = clf.elemJ;
        end
        
        %return CLF
        function retrn = getCLF(clf)
            retrn = clf.couplingLossFactor;
        end
        
        %return reciprocal CLF
        function retrn = getRCLF(clf)
            retrn = clf.reciprocalCLF;
        end
        
    end
    
end

