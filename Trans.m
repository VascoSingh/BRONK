function [tran_bw4,tran_bw4_perim,tranLabel,Data] = Trans(AnaImage,AnaSettings,MiPerPix)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% threshold=AnaSettings{1};           
[~,threshold] = edge(AnaImage,'sobel');
fudgeFactor = AnaSettings{1};
BWs = edge(AnaImage,'sobel',threshold * fudgeFactor);

seBig =strel('line',round(3*(0.34/MiPerPix)),90);

seLil =strel('line',round(3*(0.34/MiPerPix)),90);
BWsdil = imdilate(BWs,[seBig seLil]);
BWdfill = imfill(BWsdil,'holes');

BWnobord = imclearborder(BWdfill,4);

seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
BWfinal = bwareaopen(BWfinal,40);
 tran_bw4 = BWfinal;
 tran_bw4_perim = imdilate(bwperim(tran_bw4),strel('disk',2));
 tranLabel = tran_bw4;
 Data = AnaSettings{1};        
     
end

