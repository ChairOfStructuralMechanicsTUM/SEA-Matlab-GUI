function [CLF] = FormCLFMatrix(clf,tclf,crclf)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
%   This function assembles the global coupling loss factor matrix.
%
%   Input:
%           clf             object of class "CouplingLossFactor"
%           
%           tclf            object of class "ComplexConnections"  
%                           
%           crclf           object of class "ComplexConnections"
%
%   Output:
%
%           CLF             assembled global CLF matrix


%number of "normal" CLFs
noOfNormClfs=length(clf);

%add normal CLFs
for i=1:noOfNormClfs
    CLF(i)=clf(i);
end

%add T-Connection CLFs
for i=1:length(tclf)
    vectorOfCLFs=tclf(i).getVecOfCLFs;
    for k=1:length(vectorOfCLFs)
        CLF(noOfNormClfs+3*(i-1)+k)=vectorOfCLFs(k);
    end
end

%check if any "normal" CLFs and/or T-Connection CLFs do exist
if not(isempty(clf) && isempty(tclf))
	noOfNormClfs=length(CLF);
end

%add X-Connection CLFs
for i=1:length(crclf)
    vectorOfCLFs=crclf(i).getVecOfCLFs;
    for k=1:length(vectorOfCLFs)
        CLF(noOfNormClfs+4*(i-1)+k)=vectorOfCLFs(k);
    end
end

end

