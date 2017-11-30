classdef Cavity
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%    
% Class definition for a cavity.
% Including porperties, constructors, depending properties and
% accessor/mutator methods.
    
    properties (Access = private)
        number %int                 - subsystem number
        lengthX %float              - in m
        lengthY %float              - in m
        lengthZ %float              - in m
        
        density %float              - in kg/m^3
        speedOfSound %float         - in m/s
        
        dampingLossFactor %float    - dimensionless unit
        
        volume %float               - in m^3
        surface %float              - in m^2
        perimeter %float            - in m
    end
    
    methods (Access = public)
        
        %% Constructors
        %multiple constructors defined by number of input arguments
        function self = Cavity(varargin)
            
            if nargin == 7
                self.number = varargin{1};
                self.lengthX = varargin{2};
                self.lengthY = varargin{3};
                self.lengthZ = varargin{4};
                
                self.density = varargin{5};
                self.speedOfSound = varargin{6};
                
                self.dampingLossFactor = varargin{7};
                
                self.volume = self.lengthX*self.lengthY*self.lengthZ;
                self.surface = 2*(self.lengthX*self.lengthY+self.lengthX*...
                    self.lengthZ+self.lengthY*self.lengthZ);
                self.perimeter = 4*(self.lengthX+self.lengthY+self.lengthZ);
                
            else %default constructor
                self.number = 0;
                self.lengthX = 0.0;
                self.lengthY = 0.0;
                self.lengthY = 0.0;
                self.lengthZ = 0.0;
                
                self.density = 0.0;
                self.speedOfSound = 0.0;
                
                self.dampingLossFactor = 0.0;
                
                self.volume = 0.0;
                self.surface=0.0;
                self.perimeter = 0.0;
            end
        end
        
        %% Standard display function
        function disp(cavity)
            fprintf('Cavity %d has the following parameters:\n',cavity.number);
            fprintf('Length in x-direction: %g m\n',cavity.lengthX);
            fprintf('Length in y-direction: %g m\n',cavity.lengthY);
            fprintf('Length in z-direction: %g m\n',cavity.lengthZ);
            fprintf('Volume: %g m^3\n',cavity.volume);
            fprintf('Surface: %g m^2\n',cavity.surface);
            fprintf('Perimeter: %g m\n',cavity.perimeter);
            fprintf('Density: %g kg/m^3\n',cavity.density);
            fprintf('Speed of Sound: %g m/s\n',cavity.speedOfSound);
            fprintf('Damping Loss Factor: %g\n',cavity.dampingLossFactor);
        end
        
        %% Depending properties
        %calculation of modal density
        function retrn = modalDensity(cavity,frequencies)
            retrn = (4.0*pi*power(frequencies,2)*cavity.volume/...
                power(cavity.speedOfSound,3)+frequencies*pi*...
                cavity.surface/(2.0*power(cavity.speedOfSound,2))+...
                cavity.perimeter/8.0/cavity.speedOfSound)/(2.0*pi);
        end
        
        %calculation of modal overlap factor
        function retrn = modalOverlapFactor(cavity,frequencies)
            retrn = 2.0*pi*frequencies*cavity.dampingLossFactor.*...
                cavity.modalDensity(frequencies)*pi/2.0;
        end
            
        %calculation of the wave number
        function retrn = waveNumber(cavity,frequencies)
            retrn = 2.0*pi*frequencies/cavity.speedOfSound;
        end
        
        %% Accessor methods
        %return id number
        function retrn = getID(cavity)
            retrn = cavity.number;
        end
        
        %return length in x-direction
        function retrn = getLengthX(cavity)
            retrn = cavity.lengthX;
        end
        
        %return length in y-direction
        function retrn = getLengthY(cavity)
            retrn = cavity.lengthY;
        end
        
        %return length in z-direction
        function retrn = getLengthZ(cavity)
            retrn = cavity.lengthZ;
        end
        
        %return density
        function retrn = getDensity(cavity)
            retrn = cavity.density;
        end
        
        %return speed of sound
        function retrn = getSpeedOfSound(cavity)
            retrn = cavity.speedOfSound;
        end
        
        %return damping loss factor
        function retrn = getDLF(cavity)
            retrn = cavity.dampingLossFactor;
        end
        
        %return volume
        function retrn = getVolume(cavity)
            retrn = cavity.volume;
        end
        
        %return surface
        function retrn = getSurface(cavity)
            retrn = cavity.surface;
        end
        
        %return perimeter
        function retrn = getPerimeter(cavity)
            retrn = cavity.perimeter;
        end
        
        %% Mutator functions
        %currently empty
    end
    
end

