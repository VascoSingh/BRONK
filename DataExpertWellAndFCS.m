clear all
load('untitled.mat')

%% User Inputs
CellCountPlane=1;
OutputPerWell = false;
OutputFCS = true;
exportdir=char('D:\Dropbox (VU Basic Sciences)\Duvall Confocal\Duvall Lab\Jackey\2022-09-15-Gal8-ConjugatesChloroquine\Analysis\Outputs\FCSExport');
DataTable=C;
AnaPassIncluded=[2,3,4,5];
WellKey=[        1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40	41	42	43	44	45	46	47	48	49	50	51	52	53	54	55	56	57	58	59	60	61	62	63	64	65	66	67	68	69	70	71	72;
                12	11	10	9	8	7	6	5	4	3	2	1	1	2	3	4	5	6	7	8	9	10	11	12	12	11	10	9	8	7	6	5	4	3	2	1	1	2	3	4	5	6	7	8	9	10	11	12	12	11	10	9	8	7	6	5	4	3	2	1	1	13	13	13	13	13	14	14	14	14	15	12
            ]';

%% Prep Code 
run=char(datetime(clock),"yyyy-MM-dd-HH-mm-ss"); 
TestTable2=DataTable;
InputTable=TestTable2;


PreppedTable=removevars(InputTable,["Centroid","BoundingBox"]);
PreppedTable=convertvars(PreppedTable,@isnumeric,'single');

SumInt=(PreppedTable{:,"Area"}.*PreppedTable{:,"MeanIntensity"});
PreppedTable.SumInt=SumInt;

GroupNum=vlookup(PreppedTable.WellNum,WellKey,2); 
PreppedTable.GroupNum=GroupNum;
% PreppedTable.AnaProgram=strcat(num2str(PreppedTable.AnaPass),'_',PreppedTable.AnaProgram);

PreppedTable(ismember(PreppedTable.Cell,0),:)=[];
PreppedTable(~ismember(PreppedTable.AnaPass,AnaPassIncluded),:)=[];
PreppedTable.AnaPass=strcat('A',num2str(PreppedTable.AnaPass),'_',PreppedTable.AnaProgram);
PreppedTable.ImgPlane=strcat({'P'},num2str(PreppedTable.ImgPlane));

%% WholeWellDataPrep
if OutputPerWell
StatsWellTimeAnaPlane=groupsummary(PreppedTable,["GroupNum","WellNum","TimeNum","AnaPass","ImgPlane"],{'sum','mean','median','mode','var','std','min','max','range'},["Area","EquivDiameter","Extent","MeanIntensity","SumInt"]);

MeansConstantWellTimeAna=groupsummary(PreppedTable,["GroupNum","WellNum","TimeNum","AnaPass"],{"mean"},["Area","EquivDiameter","Extent"]);
StatsWellTimeAna=unstack(StatsWellTimeAnaPlane,[6:width(StatsWellTimeAnaPlane)],{'ImgPlane'});
WellTimeAna=join(MeansConstantWellTimeAna,StatsWellTimeAna,'Keys',[1 2 3 4]);

WellTimeData=unstack(WellTimeAna,[5:width(WellTimeAna)],{'AnaPass'});
% idx=ismissing(WellTimeData(:,:));
% WellTimeData{:,:}(idx) = 0;

writetable(WellTimeData,strcat(exportdir,'\',run,'_WellTimeData.xlsx'));
% writetable(StatsWellTimeAna,strcat(exportdir,'\','WellTimeAnaData.xlsx'));
% writetable(StatsWellTimeAnaPlane,strcat(exportdir,'\','WellTimeAnaPlaneData.xlsx'));
end

%% FlowCytometryDataPrep

if OutputFCS
PerCellDataAnaPlane = groupsummary(PreppedTable,["GroupNum","WellNum","TimeNum","Cell","AnaPass","ImgPlane"],{'sum','mean','median','mode','var','std','min','max','range'},["MeanIntensity","SumInt"]);
PerCellDataAna = groupsummary(PreppedTable,["GroupNum","WellNum","TimeNum","Cell","AnaPass"],{'sum','mean','median','mode','var','std','min','max','range'},["Area","EquivDiameter","Extent"]);


% FlowbyCellAnaPlane=removevars(PerCellData,["GroupCount"]);

% MeansConstantWellTimeAna=groupsummary(PreppedTable,["GroupNum","WellNum","TimeNum","AnaPass"],{"mean"},["Area","EquivDiameter","Extent"]);

StatsCellAna=unstack(PerCellDataAnaPlane,[7:width(PerCellDataAnaPlane)],{'ImgPlane'});
CellWellTimeAna=join(PerCellDataAna,StatsCellAna,'Keys',[1 2 3 4 5]);

FlowbyCell=unstack(CellWellTimeAna,[6:width(CellWellTimeAna)],{'AnaPass'});
% FlowbyCell(:,7:end)=rescale(FlowbyCell(:,7:end),'InputMin',min(FlowbyCell{:,7:end}),'InputMax',max(FlowbyCell{:,7:end}));

FlowbyCell.FSC_A=FlowbyCell{:,10};
FlowbyCell.SSC_A=10000.*FlowbyCell{:,86};


FCSOutData2=table2array(FlowbyCell);
FCSOutData2(isnan(FCSOutData2))=0;

FCSOutData2(:,7:end)=(2^19).*rescale(FCSOutData2(:,7:end),'InputMin',min(FCSOutData2(:,7:end)),'InputMax',max(FCSOutData2(:,7:end)));
FCSOutData2(isnan(FCSOutData2))=0;
FCSOutData2(:,7:end)=FCSOutData2(:,7:end)+1;
FCSOutData=(double(round(FCSOutData2)));
WellColumn=FCSOutData(:,2);
% TimeColumn=FCSOutData(:,3);



TEXT.PnN = FlowbyCell.Properties.VariableNames;

FCSFolder=strcat(exportdir,'\',run,'\');

mkdir(FCSFolder)

    for i=unique(WellColumn)'
            
            WellPoint = num2str(i,'%03.f');
            CurrWell=FCSOutData(FCSOutData(:,2)==i,:);
            TimeColumn=CurrWell(:,3);
        for j=unique(TimeColumn)'
                Timepoint = num2str(j,'%03.f'); %Creates a string so that the BioFormats can read it
                CurrTime=double(CurrWell(TimeColumn==j,:));
%                 maxdata(:,j)=max(CurrTime);
%                 ExportedTimeData(j)={CurrTime};
                WellID=strcat('w',WellPoint,'t',Timepoint);
                FCSFileName=strcat(FCSFolder,WellID,'.fcs') ; 
                TEXT.WELLID=WellID;
                TEXT.FIL=WellID;
                TEXT.COM=WellID;
                writeFCS(FCSFileName,CurrTime,TEXT); 
            
%         AllMaxes(i)={maxdata};
        end
%         ExportedWellData(i)={ExportedTimeData};
%         clear maxdata ExportedTimeData
        
    end
end
% 
% 
% 
