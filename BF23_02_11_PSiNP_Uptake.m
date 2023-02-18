
%% Gal8 Recruitment MATLAB Program
clc, clear all, close all
Identifier = ["ST"                                  
    "e5a03cec-4a80-11e4-9553-005056977bd0"
    "DM"                                  
    "IP"                                  
    "3c4d8530-865a-46cb-bd2b-6c4026359270"
    "d1ff6c34-6cbf-4379-8fc7-710f710a1e09"];
Identifier = array2table(Identifier);
addons = matlab.addons.installedAddons;
addons = addons(:,4);
hasAddons = ismember(Identifier, addons);
if hasAddons(2) == 0 
    fprintf("writeFCS(fname, DATA, TEXT, OTHER) MATLAB add on must be installed ");
end
if hasAddons(5) == 0 
    fprintf("ND2 Reader 0.1.1 MATLAB add on must be installed ");
end 
if hasAddons(6) == 0 
    fprintf("Microscopy Image Browser 2 (MIB2) MATLAB add on must be installed ");
end
if hasAddons(2) == 0 || hasAddons(5) == 0 || hasAddons(6) == 0
    return;
end
%
%% USER: Basic Aspects 
    %User Defines location of Image file and location of directory to
    %export to.
ImgFile=char('D:\Dropbox (VU Basic Sciences)\Duvall Confocal\Duvall Lab\Brock Fletcher\2023-02-11-PSiNP-DB-Plasmid\48hr-PSiNP-Plasmid-DB.nd2');
exportdir=char('D:\Dropbox (VU Basic Sciences)\Duvall Confocal\Duvall Lab\Brock Fletcher\2023-02-11-PSiNP-DB-Plasmid\Analysis\All');
    
    %Basic Information
numPlanes=3; %How many image Planes to analyze? For example, If you have a Blue (DAPI), Green (GFP), and Red (Cy5) channel, this would be 3 
BaxExport=false; %Do you wish to export images to folder so they can be analyzed using BaxterAlgorithms? Takes more storage but generally a good idea
MakeCompImage=true; %Make a composite Image of the various channels and segmentation?  MakeCompImage is useful for storing your segements for quick
                %         checks, but will take up more storage space. It's reccomended to
                %         leave on as you check parameters, but then to turn it off if
                %         you're anlayzing a very large file. you can always use the
                %         BaxExport and Segment images to check everything in Baxter
                %         Algorithms.

Parallelize=true; %Take advantage of multiple processing cores? Generally a good idea but can cause some computers to overheat
                        %Note: For troubleshooting, can be useful to change the "parfor"
                        %loop below into a regular for loop, which will stop parralel
                        %processing but allow error codes to report what's actually wrong.

MiPerPix=0.68; %The resolution of your microscopy, in Microns per pixel. A very important parameter.
CellSize=1;  %Scale as needed for different Cells. Not currently used but maybe incorporate later              
BitDepth=12; %The bit depth of your microscopy images, generally 8, 12, or 16 bit. 2^8=255 max. 2^12=4095 max. 2^16= 65535 max.

%% USER: Image Analysis Parameters
   %IMPORTANT: ImageAnalyses is the heart of this program. Each Row is a pass
   %of the computer analyzing the images. Contained within each row is all the information
   %needed for that analysis. See detailed documentation below with help
   %using the available functions. Some Programs (like NucPlus or CytWS)
   %rely on having already run a different program previously. This is how
   %it. For example, 'NucPlus' only looks within regions already determined to be cytosol
   % by 'Cyt'.  To get single-cell level analysis, you need to run
   %'CytWS' which requires both a definition of what is Cytosol (from
   %'Cyt')s and the location of nuclei (from 'Nuc' or 'NucPlus). It perorms
   %a watershedding algorithm to semgent single cells around nuclei.

   % Functions can be used more than once on multiple channels. For
   % example, if you're looking for puncta in multiple different channels,
   % you can run the 'Gal8' Program for each channel

   % If functions are giving poor results and adjusting parameters here is
   % not solving this problem, then going into the associated function
   % within this same folder can help.
   
  
ImageAnalyses=    {

%                          {{'Nuc'},{1},{1 0.02},{3},{'Nuc_bw4_perim' [0.8500 0.3250 0.0980]},{true},{}};
                          {{'Cyt'},   {1},{3 0.10},   {2},    {[0 1 1]},{true},{[0 0.15]}};
                          {{'Cyt'},   {2},{5 0.10},   {1},    {[1 0 1]},{true},{[0 1]}}; 
                           {{'Trans'},   {3},{0.9},   {3},    {[0.8500 0.3250 0.0980]},{true},{[0 1]}}; 
%                           {{'NucPlus'},{1},{7 2 2 0.04 [20 80]},  {3},    {[0 0 1]},{true},{[0 0.05]}};                        
%                           {{'CytWS'}, {2},{2 1 8},      {},     {[0 1 1]},{true},{[0 0.2]}};
%                             {{'Gal8'},  {2},{0.1 3},  {},     {[1 0 1]},{true},{[0 0.2]}};
%                             {{'Gal8'},  {3},{0.1 3},  {1},     {[1 1 0]},{true},{[0.1 0.25]}};
%                            {{'Drug'},  {3},{0.9},      {1},    {[0.8500 0.3250 0.0980]},{true},{}};
%                         {{'Gal8'},{2},{0.01},{},{'Gal_bw4_Perim' [0.4940, 0.1840, 0.5560]},{true},{}};
%                         {{'Cyt'},{1},{5 0.2},{2},{},{true},{}};
%                         {{'Cyt'},{2},{4 0.2},{1},{},{true},{}};
%                         {{'Gal8'},{2},{0.004 2},{},{},{true},{}};
                            };

CytosolicPass=1; 
                % Cytosolic Pass: To work best, this program needs a cytosolic stain to function. Which
                % pass of the image analysis program above (NOT which channel) is best to
                % call the actual cell area. Preferably, CytosolicPass=3; because this would be single-cell level
                % from 'CytWS' after 'Cyt' was pass 1 and 'NucPlus' was pass two.

% IMPORTANT: in ImageAnalyses, there are 7 cells to input your analysis parameters:
%{{1},{2},{3},{4},{5},{6},{7}};  
% Here's a key to what each cell represents:
    % 1 = 'Analysis Program'. For example, 'Cyt' or 'NucPlus'. Call which
    % analysis you actually want to do. For examples below, let's pretend
    % we chose 'Cyt'

    % 2 = Image Plane Number. Let's say you acquired 3 channels, blue
    % (DAPI), green (Gal8-GFP), and Red (Cy5) in that order. Since we're
    % choosing the program 'Cyt' then we will enter "2" as this will be our cytosolic stain. 
    
    % 3 = Analysis Parameters. This gets complicated, as each program
    % requires different numbers corresponding to different inputs. The key
    % for this is written out below. For Cyt, the first number is how strict (Otsu Function) we're being from
    % 0-20, with 1 or 2 generally best. The second number should correspond
    % to about the brightest 10% of the average cell. For example,
    % if you have 8 bit images, each pixel has a brightness value from
    % 0-255 (2^8). If you took a relatively dim image, then the brighter part of
    % the average cell may only read about 38, or about 15% of the total
    % range(38/255 = 0.15). Therefore, we need the program to focus on this
    % range of brightness. 
    % Therefore, the analysis parameters input would look as follows: {2 0.15} 
    % Adjusting these numbers can help with segmentation. 
    
    % 4- Output Segmentation Image Color. 1=r 2=g 3=b. If you would like
    % the image for this program written to an output example image of the
    % segmentation program, you must tell it whether this channel should be
    % colored red, green, or blue. Note that this is the actual image you
    % acquired, not anything from the program itself. Since this example is for Gal8-GFP, we
    % enter 2 here for green, and this section looks like: {2}. If you are
    % running multiple analysis passes for this channel, like you probably will
    % for Gal8-GFP, then it's only necessary to output the segmentation
    % image once. Therefore, on second passes, this input can be left
    % blank, like: {}

    % 5- Color code (3 digit) for overlay of analysis mask perimeter on
    % output image. Each line of the program creates a "mask" of what it
    % has identified as the area of interest. For example, 'Cyt' creates a
    % mask of where it thinks is or is not cytosolic stain. We then take
    % just the perimeter of this mask, and can overlay this perimeter over
    % our output image. The result should look like we have drawn a line
    % around the perimeter of all the cells. Cell 5 of each ImageAnalysese
    % row sets the color of this perimeter using a 3 digit code of the
    % user's choice. See matlab color conventions for more, but [0.85 0.325 0.098]
    % is an example of one good color. This cell can be left empty for no
    % output.

    % 6- Export a segmented image? true or false. We have already set the
    % colors for the image and segmentation, but this cell sets if it is
    % actually made. This seems redundant, but allows the user to quickly
    % turn on or off an image channel in the output image. When setting your segmentation parameters, for example,
    % once 'Cyt' is set satisfactorily, you may want to set it to {false}
    % to more easily see later segmentations you are working on.

    % 7- Image brightness [min max]. Often, its best to take microscopy
    % images far below the upper limit of the detector's max reading,
    % particularly for Gal8. This leaves the raw images looking too dim
    % when sharing/publishing. The imadjust function in Matlab rescales the
    % images to make them more easily viewed. To make sure each image is
    % scaled exactly the same, we must set the min and max range of the
    % inputs. For example [0 0.2] retains the low-end signal (0) but sets
    % pixels >= 20% (0.2) of the total bit range as the new maximum.
    % Effectively, this greatly brightens the image.

%% code:Create Folders and Files for export

%Set Blanks for speed optimization purposes
       DataName = {};                  
       LiveData = {};
       AllData2 = {};
r=bfGetReader();
r = loci.formats.Memoizer(bfGetReader(),0);
r.setId(ImgFile);
if ~exist(exportdir,'file')
mkdir(exportdir);
end
run=char(datetime(clock),"yyyy-MM-dd-HH-mm-ss");    % The Run number is used to track multiple runs of the software, and is used in
          
readeromeMeta=r.getMetadataStore(); %Metadata store from open microscopy
RunDirectory= fullfile(exportdir,run);
mkdir(RunDirectory); 

OverlaidDirectory = fullfile(RunDirectory,'Overlaid');
mkdir(OverlaidDirectory); 

BaxtDirectory = fullfile(RunDirectory,'Baxter');
mkdir(BaxtDirectory);

LogDirectory = fullfile(RunDirectory,'Log');
mkdir(LogDirectory);

 SegDirectory = fullfile(BaxtDirectory,'Analysis','Segmentation_'); %We wait to make the muiltiple segmentation directories until they are needed later on.
Version=run;
LogFile=strcat(LogDirectory,'\');
FileNameAndLocation=[mfilename('fullpath')]; %#ok<NBRAK>
newbackup=sprintf('%sbackup_%s.m',LogFile,Version);
currentfile=strcat(FileNameAndLocation, '.m');
copyfile(pwd,newbackup);


%% code: Analysis Variables
    customRun=true; % False analyzes all the wells, true analyzes only select few wells

    %Generate Parallel Pool for analysis
    if Parallelize
    poolobj = gcp;
            if isempty(poolobj)
                nWorkers = 1;
            else
                nWorkers = poolobj.NumWorkers;
                
                 
            end
    else
         nWorkers = 1;
    end

    if customRun
    wells = [0 8 32]; % Adjust custom run wells using 0 based indexing
    wells = wells + 1;
    timepoints = [0]; % Adjust custom run timepoints using 0 based indexing
    NumSeries = length(wells); % #PROJECT: This will need to be modified to allow selected wells to run

    else
    NumSeries=r.getSeriesCount(); %The count of all the wells you imaged
    wells=[1:nWorkers:NumSeries];
    end
NumColors=r.getEffectiveSizeC(); %The number of colors of each well you imaged
NumTimepoint=(r.getImageCount())/NumColors; %The number of timepoints you imaged
NumImg=NumSeries*NumTimepoint*NumColors; %The total number of images, combining everything
    
    % ParSplit=[1:nWorkers:NumSeries]; %This splits everything so that it can be parrallelized even though OME does not support Parfor. Basically, we make a list of which cores will handle which wells ahead of time.

%% code: Analysis Program 
AllData4={}; %Blank for Parfor CompSci reasons
      for nn = 1 : nWorkers % Initialize logging at INFO level
        bfInitLogging('INFO'); % Initialize a new reader per worker as Bio-Formats is not thread safe
        r2 = javaObject('loci.formats.Memoizer', bfGetReader(), 0); % Initialization should use the memo file cached before entering the parallel loop
        r2.setId(ImgFile);
        
            AllData3={};%Clear because parfor  
            RunNum=0
            for j=wells+nn-2% Number of wells in ND2 File. Dependent on nn so that each worker has its own list of wells to analyze
                
                if customRun || j<=(NumSeries-1)
                RunNum=RunNum+1    
                %Prep Metadata
                CurrSeries=j; %The current well that we're looking at
                r2.setSeries(CurrSeries); %##uses BioFormats function, can be swapped with something else (i forget what) if it's buggy with the GUI
                fname = r2.getSeries; %gets the name of the series using BioFormats
                Well=num2str(fname,'%05.f'); %Formats the well name for up to 5 decimal places of different wells, could increase but 5 already feels like overkill 
                if customRun == false
                T_Value = r2.getSizeT()-1; %Very important, the timepoints of the images. Returns the total number of timepoints, the -1 is important.
                timepoints = double(0):double(T_Value);
                end
                SizeX=r2.getSizeX(); %Number of pixels in image in X dimension
                SizeY=r2.getSizeY(); %Number of pixels in image in Y Dimension
                    
                    BaxWellFolder=fullfile(BaxtDirectory,Well); %Creates a filename that's compatible with both PC and Mac (#PROJECT: Check and see if any of the strcat functions need to be replaced with fullfile functions) 
                    if logical(BaxExport)
                    if ~isfolder(BaxWellFolder)
                        mkdir(BaxWellFolder); %makes a new folder on your hard drive for the baxter stuff   
                    end
                    end
                    AllData2={};%Clear because parfor 
                    for i=timepoints %For all of the time points in the series, should start at zero if T_Value has -1 built in, which it should
                        Img2=zeros(SizeY,SizeX,numPlanes,'uint16');  %Make a blank shell for the images  
                                iplane=r2.getIndex(0,0,i);
                                for n=1:numPlanes         
                                    Img2(:,:,n)=bfGetPlane(r2,iplane+n).*((65535)/(2^BitDepth));
                                    
                                end
%                                 Img2=Img2.*((65535)/(2^BitDepth));
%                                  Img2=uint16(Img2); %Converts Images to uint16 so they're always the same for downstream analysis.
        %##PROJECT: uint8 may be faster and better than uint16 because it would enable GPU integration.
        %However,our Nikon images are captured in uint12,and often the
        %dimmest pixels are very important for demarcating nuclei or cells.
        %Therefore, would need to experiment with.

                        
                            Timepoint = num2str(i,'%03.f'); %Creates a string so that the BioFormats can read it
                            BaxterName=strcat('w',Well,'t',Timepoint) ; %Very important, creates a name in the format that Baxter Algorithms prefers                     
                            ImageName=fullfile(BaxWellFolder,BaxterName); %Creates a name for each particular image
                                
                               
                                
                            %% Analyze Images Custom Functions
                            [LiveData] = BronkSegment(ImageAnalyses,Img2,MiPerPix,SegDirectory,Well,BaxterName,MakeCompImage,OverlaidDirectory);
                                % #PROJECT: The way I formatted LiveData
                                % would probably be faster for matlab to
                                % use in the LabelAnalysis function if it
                                % was structured differently.
                         
                                
                                
                       %% Get Area and Intensity data for every combination of channels
                            LabelInput={Well,Timepoint,CytosolicPass};
%                             LiveData=gpuArray(LiveData);
                            
                            [TidyFeat] = LabelAnalysisNoGPU(LiveData,Img2,LabelInput);
                                % #PROJECT: LabelAnalysis2 was written
                                % quickly and could likely be optimized to
                                % run faster. It's relatively slow.
                                AllData2(i+1)={TidyFeat}
                       
                            if logical(BaxExport)    %Export Images for Baxter
                                    for n=1:numPlanes                        
                                        Img3=Img2(:,:,n);
                                        my_field = strcat('c',num2str(n,'%02.f'));
                                        imwrite((Img3), strcat(ImageName,my_field,'.tif'),'tif');
                                    end
                            end
                    end
                AllData3(:,RunNum)=AllData2 %Parfor look requires certain structures to not delete data
                else
                end    
            end
            RunNum=0
            AllData4{nn}=AllData3; %Store Data in parfor-compatible way
      end %end of all analysis

    
%% code: Write Analysis Data to File
    %Users may want to run/change only this section if they've already run teh
    %entire analysis program but received some export error or would like
    %to change out the output data is structured 
    
    %Clean Up Rows
            z=AllData4;
            lv = max(cellfun(@length,z));
            za = z{1}{1};
            za{1,:}=0;
            for idx = 1:length(z)
                cellVal = z{idx};
              if length(cellVal) < lv
                  for idy =(length(cellVal)+1):lv
                      z{idx}{idy} = za;
                  end
              end
            end

ConcatinatedData=vertcat(z{1:end});
Tablebig = sortrows(vertcat(ConcatinatedData{:}),[9,10,11,12,13]);
 MatSaveName=fullfile(RunDirectory,strcat(run,'.mat'));
 ExcelName=fullfile(RunDirectory,strcat(run,'.txt')); %Prepare excel file name
save(MatSaveName,'Tablebig')
writetable(Tablebig,ExcelName) %Write Excel file of all analysis Data