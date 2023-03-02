function ExportWellAndFCS(DataTable, wells, AnaPassIncluded, OutputPerWell, OutputFCS, exportdir)
    %% Prep Code 
    run=char(datetime(clock),"yyyy-MM-dd-HH-mm-ss"); 
    %TestTable2=DataTable;
    InputTable = DataTable;
    %InputTable=TestTable2(1:30000,:); %Only include beginning for testing
    
    %WellKey = [wells, 1:length(wells)];
    PreppedTable=removevars(InputTable,["Centroid","BoundingBox"]) %some variables not compatible with analysis
    PreppedTable=convertvars(PreppedTable,@isnumeric,'single'); %single precision all numbers to prevent problems
    
    SumInt=(PreppedTable{:,"Area"}.*PreppedTable{:,"MeanIntensity"}); %Get sum intensity value from existing numbers
    PreppedTable.SumInt=SumInt; %add SumINt variable to the data set
    
    GroupNum=repmat([1:length(wells)]',ceil(size(Tablebig, 1)/(length(wells))),1);
    GroupNum=GroupNum(1:size(TableBig,1));%I think i had to add an add-on for this to work, this is so that in the next step we can label each well with a group number
    PreppedTable.GroupNum=GroupNum; %add a group number, for instance different treatment groups, each well is a replicate
    % PreppedTable.AnaProgram=strcat(num2str(PreppedTable.AnaPass),'_',PreppedTable.AnaProgram);
    
    PreppedTable(ismember(PreppedTable.Cell,0),:)=[]; %Filter out blank cells and whole-well data
    PreppedTable(~ismember(PreppedTable.AnaPass,AnaPassIncluded),:)=[]; %filter out unwanted analysis passes
    PreppedTable.AnaPass=strcat('A',num2str(PreppedTable.AnaPass),'_',PreppedTable.AnaProgram); %add labels to make data easier to analyze after run
    PreppedTable.ImgPlane=strcat({'P'},num2str(PreppedTable.ImgPlane)); %add labels to make data easier to analyze after run
    
    %% WholeWellDataPrep
    if OutputPerWell
    StatsWellTimeAnaPlane=groupsummary(PreppedTable,["GroupNum","WellNum","TimeNum","AnaPass","ImgPlane"],{'sum','mean','median','mode','var','std','min','max','range'},["Area","EquivDiameter","Extent","MeanIntensity","SumInt"]); %Get per-image-plane level data
    
    MeansConstantWellTimeAna=groupsummary(PreppedTable,["GroupNum","WellNum","TimeNum","AnaPass"],{"mean"},["Area","EquivDiameter","Extent"]); %get per analysis pass level data
    StatsWellTimeAna=unstack(StatsWellTimeAnaPlane,[6:width(StatsWellTimeAnaPlane)],{'ImgPlane'}); %put all of the per-image plane data on a single row for each analysis pass
    WellTimeAna=join(MeansConstantWellTimeAna,StatsWellTimeAna,'Keys',[1 2 3 4]); %Put all the data together
    
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
    FlowbyCell.FSC_A=FlowbyCell{:,10};
    FlowbyCell.SSC_A=10000.*FlowbyCell{:,86};
    FlowbyCell.FSC_A(FlowbyCell.FSC_A<=1)=1;
    FlowbyCell.SSC_A(FlowbyCell.SSC_A<=1)=1;
    FCSOutData=table2array(FlowbyCell);
    FCSOutData(isnan(FCSOutData))=0;
    FCSOutData=double(FCSOutData);
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
                    maxdata(:,j)=(max(CurrTime))';
                    WellID=strcat('w',WellPoint,'t',Timepoint);
                    FCSFileName=strcat(FCSFolder,WellID,'.fcs'); 
                    TEXT.WELLID=WellID;
                    TEXT.FIL=WellID;
                    TEXT.COM=WellID;
                    writeFCS(FCSFileName,CurrTime,TEXT); 
              
        
            AllMaxes(i)={maxdata};
            end
            clear maxdata
        end
    end
end