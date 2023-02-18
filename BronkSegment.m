function [LiveData] = BronkSegment(ImageAnalyses,Img2,MiPerPix,SegDirectory,Well,BaxterName,MakeCompImage,OverlaidDirectory)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
LiveData=cell(length(ImageAnalyses),1);  

for k =1:length(ImageAnalyses)

        Analysis=ImageAnalyses{k,:}{1}{1};
        AnaChan=ImageAnalyses{k,:}{2}{1};
        AnaImage=Img2(:,:,AnaChan);
        AnaSettings= ImageAnalyses{k,:}{3};
        ImMaxBright= ImageAnalyses{k,:}{7}{:};

        switch Analysis
            case 'Nuc'
                [bw4,bw4_perim,Label,Data]= NuclearStain(AnaImage,AnaSettings,MiPerPix);
            case 'NucPlus'
                CytChan=AnaSettings{2};
                Cyt=Img2(:,:,CytChan);
                [bw4,bw4_perim,Label,Data]= Nuc_ConsiderCyt(AnaImage,AnaSettings,MiPerPix,Cyt);    
            case 'Cyt'
                [bw4,bw4_perim,Label,Data] = Cytosol(AnaImage,AnaSettings,MiPerPix);
            case 'CytWS'
                NucChan=AnaSettings{1};
                CytChan=AnaSettings{2};
                Cyt=LiveData{CytChan}.AnaImage;
                Nuc_bw4=LiveData{NucChan}.bw4;
                Cyt_bw4=LiveData{CytChan}.bw4;
                [bw4,bw4_perim,Label,Data] = CytNucWaterShed(Nuc_bw4,Cyt,Cyt_bw4,AnaSettings);
            case 'Gal8'
                CytPass=AnaSettings{2};
                Cyt_bw4=LiveData{CytPass}.bw4;
                [bw4_perim,bw4,Label,Data] = Gal8(AnaImage,AnaSettings,Cyt_bw4,MiPerPix);
             case 'Drug'
                [bw4,bw4_perim,Label,Data] = Drug(AnaImage,AnaSettings,MiPerPix);  

            case 'Trans'
            [bw4,bw4_perim,Label,Data] = Trans(AnaImage,AnaSettings,MiPerPix); 
        end
        LiveData{k}.AnaImage = AnaImage; %Important! Store all of the information about the current well as you go so you can reference if need be!
        LiveData{k}.bw4 = bw4;
        LiveData{k}.bw4_perim = bw4_perim;
        LiveData{k}.Label=Label;
        LiveData{k}.Data=Data;
        LiveData{k}.Funct=Analysis;

        if ImageAnalyses{k,:}{6}{1} %Export Baxter STuff
            SegDir=fullfile(strcat(SegDirectory,Analysis,'_',num2str(k)),Well);
            if ~exist(SegDir,'file')
                mkdir(SegDir);
            end
            ImName=strcat(BaxterName,'c' ,num2str(AnaChan,'%02.f'),'.tif');
            SegFile=fullfile(SegDir,ImName);
            imwrite(Label,SegFile);
        end
        if logical(MakeCompImage) %Make RGB Example IMage
            if ~isempty(ImageAnalyses{k,:}{4})
                ImColor=ImageAnalyses{k,:}{4}{1};
                CompImage(:,:,ImColor)=imadjust(AnaImage,ImMaxBright,[]);
            end
        end
    end
    if exist("CompImage",'var') %Make Example Image and overlay with chosen segmentation
        if size(CompImage,3)<3
        CompImage(:,:,3)=zeros(size(CompImage,1),size(CompImage,2));
%         colorscheme=[0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250];
        end 
        for k =1:length(ImageAnalyses) %Draw Segementation perimeters
            if ~isempty(ImageAnalyses{k,:}{5})
            CompPerim=LiveData{k}.bw4_perim;
            PerimColor=ImageAnalyses{k,:}{5}{1};
            CompImage=imoverlay(CompImage,CompPerim,PerimColor);
        
            end
        end
        CompFile=fullfile(OverlaidDirectory,strcat(BaxterName,'.tif'));
        imwrite(CompImage,CompFile); %Export Overlaid Image to correct folder
    end
end

