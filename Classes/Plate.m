classdef Plate
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
%   Class definition for a plate.
% Including porperties, constructors, depending properties and
% accessor/mutator methods.
    
    properties (Access = private)
        number %int                 - subsystem number
        lengthX %float              - in m
        lengthY %float              - in m
        thickness %float            - in m
        
        youngsModulus %int          - in N/m^2
        density %float              - in kg/m^3
        poissonRatio %float         - dimensionless unit
        
        dampingLossFactor %float    - dimensionless unit
        
        area %float                 - in m^2 
    end
    
    
    methods (Access = public)
        
        %% Constructors
        %multiple constructors defined by number of input arguments
        function self = Plate(varargin)
            
            if nargin == 8
                self.number = varargin{1};
                self.lengthX = varargin{2};
                self.lengthY = varargin{3};
                self.thickness = varargin{4};
                
                self.youngsModulus = varargin{5};
                self.density = varargin{6};
                self.poissonRatio = varargin{7};
                
                self.dampingLossFactor = varargin{8};
                
                self.area = self.lengthX*self.lengthY;
                
            else %default constructor
                self.number = 0;
                self.lengthX = 0.0;
                self.lengthY = 0.0;
                self.thickness = 0.0;
                
                self.youngsModulus = 0.0;
                self.density = 0.0;
                self.poissonRatio = 0.0;
                
                self.dampingLossFactor = 0.0;
                
                self.area = 0.0;
                
            end
            
        end
        
        %% Standard display function
        function disp(plate)
            fprintf('Plate %d has the following parameters:\n',plate.number);
            fprintf('Length in x-direction: %g m\n',plate.lengthX);
            fprintf('Length in y-direction: %g m\n',plate.lengthY);
            fprintf('Area: %g m^2\n',plate.area);
            fprintf('Thickness: %g m\n',plate.thickness);
            fprintf('Young\''s Modulus: %d N/m^2\n',plate.youngsModulus);
            fprintf('Density: %g kg/m^3\n',plate.density);
            fprintf('Poisson\''s ratio: %g \n',plate.poissonRatio);
            fprintf('Damping Loss Factor: %g\n',plate.dampingLossFactor);
        end
        
        %% Depending properties
        %calculation of modal density (Lyon)
        function retrn = modalDensityLyon(plate)% checked
            kappa = plate.thickness/sqrt(12.0);
            cl = sqrt(plate.youngsModulus/(plate.density*...
                (1.0-power(plate.poissonRatio,2))));
            
            retrn = plate.area/(2.0*kappa*cl*2.0*pi);
        end
        
        %calculation of the group velocity in a plate
        function retrn = groupVelocity(plate,frequencies)
            kappa = plate.thickness/sqrt(12.0);
            cl = sqrt(plate.youngsModulus/(plate.density*...
                (1.0-power(plate.poissonRatio,2))));
            
            retrn = 2.0*sqrt(2.0*pi*frequencies*kappa*cl);
        end
        
        %calculation of bending stiffness in plate
        function retrn = bendingStiffness(plate)
            retrn = power(plate.thickness,3)*plate.youngsModulus/...
                (12.0*(1-power(plate.poissonRatio,2)));
        end
        
        %calculation of the bending wave number in a plate
        function retrn = bendingWaveNumber(plate,frequencies)
            retrn = power(power(2.0*pi*frequencies,2)*plate.density*...
                plate.thickness/...
                plate.bendingStiffness,1.0/4);
        end
        
        %calculation of the longitudinal velocity in a plate
        function retrn = longVel(plate)
            retrn = sqrt(plate.getYoungsModulus/...
                (plate.getDensity*(1.0-power(plate.getPoissonRatio,2))));
        end
        
        %calculation of modal overlap factor
        function retrn = modalOverlapFactor(plate,frequencies)
            retrn = 2.0*pi.*frequencies*plate.dampingLossFactor*...
                plate.modalDensityLyon*pi/2.0;
        end
        
        %calculation of the longitudinal wave number
        function retrn=longitudinalWaveNumber(plate,frequencies)
            retrn=2.0*pi*frequencies/plate.longVel;
        end
        
        %calculation of the shear modulus
        function retrn=shearModulus(plate)
            retrn=plate.getYoungsModulus/(2*(1+plate.getPoissonRatio));
        end
        
        %calculation of transverse wave velocity
        function retrn=transverseWaveVelocity(plate)
            retrn=sqrt(plate.shearModulus/plate.getDensity);
        end
        
         %calculation of the transverse wave number
        function retrn=transverseWaveNumber(plate,frequencies)
            retrn=2.0*pi*frequencies/plate.transverseWaveVelocity;
        end
        
        function retrn = modalDensityLongitudinal (plate,frequencies)
            retrn = frequencies * plate.getArea/(plate.longVel^2);
        end
        function retrn = modalDensityTransverse (plate,frequencies)
            retrn =  frequencies * plate.getArea/(plate.transverseWaveVelocity^2);
        end
        function retrn= allModalDensities(plate,frequencies)
            retrn = [plate.modalDensityLongitudinal(frequencies);plate.modalDensityTransverse(frequencies); plate.modalDensityLyon ];
        end
        function retrn = modalOverlapFactorLongitudinal(plate,frequencies)
            retrn = 2.0*pi.*frequencies*plate.dampingLossFactor.* ...
                plate.modalDensityLongitudinal(frequencies)*pi/2.0;
        end
        function retrn = modalOverlapFactorTransverse(plate,frequencies)
            retrn = 2.0*pi.*frequencies*plate.dampingLossFactor.*...
                plate.modalDensityTransverse(frequencies)*pi/2.0;
        end
        %% Accessor methods
        %return id number
        function retrn = getID(plate)
            retrn = plate.number;
        end
        
        %return lengthX
        function retrn = getLengthX(plate)
            retrn = plate.lengthX;
        end
        
        %return lengthY
        function retrn = getLengthY(plate)
            retrn = plate.lengthY;
        end
        
        %return thickness
        function retrn = getThickness(plate)
            retrn = plate.thickness;
        end
        
        %return youngs modulus
        function retrn = getYoungsModulus(plate)
            retrn = plate.youngsModulus;
        end
        
        %return density
        function retrn = getDensity(plate)
            retrn = plate.density;
        end
        
        %return poisson's ratio
        function retrn = getPoissonRatio(plate)
            retrn = plate.poissonRatio;
        end
        
        %return damping loss factor
        function retrn = getDLF(plate)
            retrn = plate.dampingLossFactor;
        end
        
        %return area
        function retrn = getArea(plate)
            retrn = plate.area;
        end
        
        %return volume
        function retrn = getVolume(plate)
            retrn = plate.area*plate.thickness;
        end
        
        %% Mutator functions
        %currently empty
    end
    
end

