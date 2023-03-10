%% Gal8 Recruitment MATLAB Program
clc, clear all, close all
%% USER: Basic Aspects 
    %User Defines location of Image file and location of directory to
    %export to.
ImgFile=char('D:\Dropbox\Dropbox (VU Basic Sciences)\Duvall Confocal\Duvall Lab\Larry Stokes\23_01_04_Gal8withBF\20221219_Gal8_Carli\T_852pm001.nd2');
exportdir=char('D:\Dropbox\Dropbox (VU Basic Sciences)\Duvall Confocal\Duvall Lab\Larry Stokes\23_01_04_Gal8withBF\Output');
    
    %Basic Information
numPlanes=2; %How many image Planes to analyze? For example, If you have a Blue (DAPI), Green (GFP), and Red (Cy5) channel, this would be 3 
BaxExport=true; %Do you wish to export images to folder so they can be analyzed using BaxterAlgorithms? Takes more storage but generally a good idea
MakeCompImage=true; %Make a composite Image of the various channels and segmentation?  MakeCompImage is useful for storing your segements for quick
                %         checks, but will take up more storage space. It's reccomended to
                %         leave on as you check parameters, but then to turn it off if
                %         you're anlayzing a very large file. you can always use the
                %         BaxExport and Segment images to check everything in Baxter
                %         Algorithms.
UseNvidiaGPU=false;
Parallelize=true; %Take advantage of multiple processing cores? Generally a good idea but can cause some computers to overheat
                        %Note: For troubleshooting, can be useful to change the "parfor"
                        %loop below into a regular for loop, which will stop parralel
                        %processing but allow error codes to report what's actually wrong.

MiPerPix=0.34; %The resolution of your microscopy, in Microns per pixel. A very important parameter.
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
                          {{'Cyt'},   {2},{4 0.13},   {2},    {[0 1 1]},{true},{[0 0.2]}};  
                          {{'NucPlus'},{1},{12 2 0 0.18 [20 80]},  {3},    {[0 0 1]},{true},{[0 0.15]}};                        
                          {{'CytWS'}, {2},{2 1 8},      {},     {},{false},{[0 0.2]}};
                            {{'Gal8'},  {2},{0.09 3},  {},     {[1 0 1]},{true},{[0 0.2]}};
%                            {{'Gal8'},  {3},{0.1 3},  {1},     {[1 1 0]},{true},{[0.1 0.25]}};
%                            {{'Drug'},  {3},{0.9},      {1},    {[0.8500 0.3250 0.0980]},{true},{}};
%                         {{'Gal8'},{2},{0.01},{},{'Gal_bw4_Perim' [0.4940, 0.1840, 0.5560]},{true},{}};
%                         {{'Cyt'},{1},{5 0.2},{2},{},{true},{}};
%                         {{'Cyt'},{2},{4 0.2},{1},{},{true},{}};
%                         {{'Gal8'},{2},{0.004 2},{},{},{true},{}};
                            };

CytosolicPass=3; 
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
%     customrun=false; %False analyzes all the wells, true analyzes only select few wells
%  FastRun=2;
%     if customrun
%     NumSeries=FastRun; % #PROJECT: This will need to be modified to allow selected wells to run
% 
%     wellsSR = [1 2 48 47 3 4 46 45 59 60 86 85 61 62 84 83 63 64 82 81 65 66 80 79 145 146 192 191,...
%              147 148 190 189 203 204 230 229 205 206 228 227 207 208 226 225 209 210 224 223];
%     well_namesSR =   {'A01.1','A01.2','A01.3','A01.4'...
%                     'A02.1','A02.2','A02.3','A02.4'...
%                     'B06.1','B06.2','B06.3','B06.4'...
%                     'B07.1','B07.2','B07.3','B07.4'...
%                     'B08.1','B08.2','B08.3','B08.4'...
%                     'B09.1','B09.2','B09.3','B09.4'...
%                     'D01.1','D01.2','D01.3','D01.4'...
%                     'D02.1','D02.2','D02.3','D02.4'...
%                     'E06.1','E06.2','E06.3','E06.4'...
%                     'E07.1','E07.2','E07.3','E07.4'...
%                     'E08.1','E08.2','E08.3','E08.4'...
%                     'E09.1','E09.2','E09.3','E09.4'};
%     timepointsSR = [1,4,7,10,13,16,19,22,25,28,31,34,37];
% 
% 
%     else
    NumSeries=r.getSeriesCount(); %The count of all the wells you imaged
% 
%     end
NumColors=r.getEffectiveSizeC(); %The number of colors of each well you imaged
NumTimepoint=(r.getImageCount())/NumColors; %The number of timepoints you imaged
NumImg=NumSeries*NumTimepoint*NumColors; %The total number of images, combining everything
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
    
    ParSplit=[1:nWorkers:NumSeries]; %This splits everything so that it can be parrallelized even though OME does not support Parfor. Basically, we make a list of which cores will handle which wells ahead of time.

%% code: Analysis Program 
AllData4={}; %Blank for Parfor CompSci reasons
      parfor nn = 1 : nWorkers % Initialize logging at INFO level
        bfInitLogging('INFO'); % Initialize a new reader per worker as Bio-Formats is not thread safe
        r2 = javaObject('loci.formats.Memoizer', bfGetReader(), 0); % Initialization should use the memo file cached before entering the parallel loop
        r2.setId(ImgFile);
        
            AllData3={};%Clear because parfor  
            RunNum=0
            for j=ParSplit+nn-2% Number of wells in ND2 File. Dependent on nn so that each worker has its own list of wells to analyze
                
                if j<=(NumSeries-1)
                RunNum=RunNum+1    
                %Prep Metadata
                CurrSeries=j; %The current well that we're looking at
                r2.setSeries(CurrSeries); %##uses BioFormats function, can be swapped with something else (i forget what) if it's buggy with the GUI
                fname = r2.getSeries; %gets the name of the series using BioFormats
                Well=num2str(fname,'%05.f'); %Formats the well name for up to 5 decimal places of different wells, could increase but 5 already feels like overkill 
                T_Value = r2.getSizeT()-1; %Very important, the timepoints of the images. Returns the total number of timepoints, the -1 is important.
%                 T_Value = 17
                SizeX=r2.getSizeX(); %Number of pixels in image in X dimension
                SizeY=r2.getSizeY(); %Number of pixels in image in Y Dimension
                    
                    BaxWellFolder=fullfile(BaxtDirectory,Well); %Creates a filename that's compatible with both PC and Mac (#PROJECT: Check and see if any of the strcat functions need to be replaced with fullfile functions) 
                    if logical(BaxExport)
                    if ~isfolder(BaxWellFolder)
                        mkdir(BaxWellFolder); %makes a new folder on your hard drive for the baxter stuff   
                    end
                    end
                    AllData2={};%Clear because parfor 
                    for i=0:T_Value %For all of the time points in the series, should start at zero if T_Value has -1 built in, which it should
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
                            if UseNvidiaGPU
                            [TidyFeat] = LabelAnalysis2(LiveData,Img2,LabelInput);
                            else
                                [TidyFeat] = LabelAnalysisNoGPU(LiveData,Img2,LabelInput);
                            end

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
            AllData4{nn}=AllData3 %Store Data in parfor-compatible way
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