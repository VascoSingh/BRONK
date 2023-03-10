function [TidyFeat] = LabelAnalysis2(LiveData,Img2,LabelInput)
%UNTITLED Analyze BronkSegment output
%   Detailed explanation goes here
% Img2= LiveData{1, 4};
Well=LabelInput{1};
Timepoint=LabelInput{2};
CytosolicPass=LabelInput{3};
 CytoMask=LiveData{CytosolicPass,1}.Label;
 CytoMask=gpuArray(CytoMask);
 CytMatch=0;
 Img2=gpuArray(Img2);
%  TidyFeat=cell(length(LiveData)*length(Img2(1,1,:)),1);
pass=0;
for AnaPass=1:length(LiveData)

    wellnum=str2double(Well)+1;
    timenum=str2double(Timepoint)+1;

    
%     LabelMax=max(LiveData{AnaPass,1}.Label,[],'all');
    DataMask=gpuArray(LiveData{AnaPass,1}.Label); %PROJECT: Make so it is flexible with regards to GPU
%     DataMask=gpuArray(DataMask);  
    AnaFunct=LiveData{AnaPass,1}.Funct;
    for ImgPlane=1:length(Img2(1,1,:))
        pass=pass+1;
        DataImage=Img2(:,:,ImgPlane);
        stats=regionprops(DataMask,DataImage,'Area','Centroid','BoundingBox','MaxIntensity','MeanIntensity','MinIntensity','EquivDiameter','Extent');       
        SumFeats=sum([stats.Area].*[stats.MeanIntensity],'all');
        AreaFeats=sum([stats.Area],'all');
        
        if ImgPlane==1
             
                CytMatch=gpuArray([stats.Centroid]);
                CytMatch=round(CytMatch);
                CytMatch=reshape(CytMatch,2,[])';
                CytMatch=sub2ind(size(DataMask),CytMatch(:,2),CytMatch(:,1));
                CellBody=CytoMask(CytMatch);
                CellBody2=num2cell(gather(CellBody));
            
            
        end  
        
        
        
        [stats.WellNum]=deal(wellnum);
        [stats.TimeNum]=deal(timenum);
        [stats.Cell]=deal(CellBody2{:});
        [stats.AnaPass]=deal(AnaPass);
        [stats.ImgPlane]=deal(ImgPlane);
%         [stats.AnaProgram]=deal(AnaFunct);
        Data=struct2table(stats);
        if ~exist('TidyFeat','var')
            TidyFeat=Data;
        else 
             TidyFeat=vertcat(TidyFeat,Data);
        end
        
      end
    

end

end




