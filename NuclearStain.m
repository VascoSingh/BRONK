function [Nuc_bw4,Nuc_bw4_perim,NucLabel,Data] = NuclearStain(Img,AnaSettings,MiPerPix)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
            NucTophatDisk=strel('disk',round(50*(0.34/MiPerPix)));
            NucOpenDisk= strel('disk',round(6*(0.34/MiPerPix)));
            NucErodeDisk=strel('disk',round(10*(0.34/MiPerPix)));
            NucCloseDisk=strel('disk',round(2*(0.34/MiPerPix)));    
    Low=AnaSettings{1};
    Max=AnaSettings{2};

    NucWeiner=wiener2(Img);
    NucTopHat=imtophat(NucWeiner,NucTophatDisk); % Clean image with tophat filter for thresholding 

    NucOpen=imopen(NucTopHat,NucOpenDisk);
    
    NucMaxValue= Max*intmax(class(Img));

    NucOverbright=NucTopHat>NucMaxValue;
    
    
    NucOpen(NucOverbright)=NucMaxValue;
            
    Cyt(~cyt_bw4)=0;
    NucOpen(~cyt_bw4)=0;
    NucMed=median(NucOpen(NucOpen>1),'all');
        CytMed=median(Cyt(Cyt>1),'all');
        Ratio=double(NucMed)/double(CytMed);
        NucOpen=NucOpen-Cyt.*Ratio.*Scaling;
        NucOpen=imopen(NucOpen,NucOpenDisk);
    
    
    
    
    
    
            NucMT1=multithresh(NucOpen,20); %Calculate 20 brightness thresholds for image 
            NucQuant1=imquantize(NucOpen,NucMT1); %Divide Image into the 20 brightness baskets
%             NucMT1=1;
%             NucQuant1=1;
            NucBrightEnough=NucQuant1>NucLow;
%             NucBrightEnough=NucOpen>Low;
        NucPos=NucBrightEnough;
        NucPos(~NucBrightEnough)=0;
%         NucPos=imadjust(NucPos);
          
            Nuc_bw2=imerode(NucPos,NucErodeDisk);
            Nuc_bw3 = bwareaopen(Nuc_bw2, 250); %%Be sure to check this threshold
            Nuc_bw4 = imclose(Nuc_bw3, NucCloseDisk);
%             Nuc_bw4 = imfill(Nuc_bw4,'holes');
        Nuc_bw4_perim = imdilate(bwperim(Nuc_bw4),strel('disk',3));
       
       NucConn=bwconncomp(Nuc_bw4);
       NucLabel = labelmatrix(NucConn);
%        NucArea = imoverlay(Nuc_eq, Nuc_bw4_perim, [.3 1 .3]);
       
Data = {Max};
end

