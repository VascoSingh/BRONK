# BRONK README
## BRONK: An Open-Source Multi-Channel Cell Segmentation Software for Single-Cell Tracking and Analysis

# 1. Introduction

The BRONK Segmentation Pipeline is a powerful software package for automated cell segmentation and analysis in microscopy images. This software is designed to handle images generated using various microscopy techniques, such as bright field, phase contrast, fluorescence microscopy (including wide field, confocal, and light sheet), and more. The BRONK Segmentation Pipeline supports both 2D and 3D image analysis, making it a versatile tool for a wide range of applications in cell biology and histology.

The primary aim of the BRONK Segmentation Pipeline is to provide an efficient and user-friendly solution for cell segmentation, feature extraction, and quantification in large microscopy datasets. The software is implemented in MATLAB and incorporates advanced image processing algorithms for accurate and reliable cell segmentation, with additional support for customizable parameters to suit specific experimental conditions and image properties.

### 1.1 Key features of the BRONK Segmentation Pipeline:

1. Automated cell segmentation: The software is capable of segmenting cells in microscopy images using various user-defined parameters, allowing for accurate and consistent cell identification across different experimental setups and imaging modalities.
2. Feature extraction and quantification: Once cells are segmented, the BRONK Segmentation Pipeline extracts and quantifies a comprehensive set of cellular features, such as area, intensity, shape, and more. These features can be easily exported for further analysis in external software packages.
3. Customizable analysis workflows: The BRONK Segmentation Pipeline is designed with flexibility in mind, allowing users to create and modify their analysis workflows to fit their specific needs. This includes options for analyzing select wells or timepoints, as well as support for parallel processing to expedite analysis of large datasets.
4. Integration with Baxter Algorithms: The pipeline is compatible with the Baxter Algorithms software package, enabling users to leverage the powerful cell tracking and analysis capabilities of Baxter Algorithms in conjunction with the segmentation provided by the BRONK Segmentation Pipeline.
5. Open-Source and Customizable: The BRONK Segmentation Pipeline is developed with a strong focus on openness and adaptability, enabling users to not only utilize the software but also actively contribute to its improvement. The code is extensively documented, ensuring that researchers can easily understand its structure, functionality, and underlying algorithms.

### 1.2 Background and Motivations:

Intracellular drug delivery remains a significant challenge due to the difficulty of overcoming endolysosome entrapment, which hinders the therapeutic use of biologic drugs that act intracellularly. Current methods for screening prospective nanoscale endosome-disrupting delivery technologies are indirect and cumbersome, which has led to a demand for more direct, quantitative, and predictive approaches. Galectin-8 (Gal8) intracellular tracking has emerged as a promising solution that addresses these limitations and enables high-throughput screening and in vivo validation. Our work at the Duvall Lab builds off the “Galectin 8 Recruitment Analysis MATLAB Software” software and prospectives of Kameron Kilchrist [1].

The motivations behind this project, which focuses on the development and optimization of a Gal8-based cell segmentation and tracking platform, are threefold:

1. Enhancing endosomal disruption measurement: The direct measurement of endosomal disruption is challenging due to its rarity and difficulty in high-throughput capacities. Traditional approaches rely on tracking pH-sensitive fluorophores or imaging colocalization, which can be limited in sensitivity and may require supra-therapeutic dosing. By developing a live-cell, high-throughput-amenable endosomal escape screening assay based on Gal8 recruitment, we aim to overcome these limitations and provide a more direct, sensitive, and accurate method for assessing endosomal disruption.
2. Improving intracellular bioavailability prediction: Establishing quantitative correlations between carrier-mediated Gal8 recruitment levels and intracellular biologic cargo bioavailability and activity is crucial for validating the use of Gal8 recruitment imaging as a predictive tool. Our project aims to rigorously investigate these correlations, paving the way for the adoption of Gal8-based assays in the high-throughput screening pipeline for evaluating the endosome disruptive potency of candidate formulations.
3. Facilitating large-scale studies and drug delivery optimization: The ability to efficiently process and analyze large datasets of microscopy images is essential for advancing our understanding of complex cellular processes and optimizing drug delivery systems. Our project aims to develop a user-friendly software solution that enables researchers to effectively handle large-scale studies and leverage the power of Gal8-based assays for the rapid optimization of endosome-disrupting intracellular delivery technologies.

By addressing these challenges and developing an optimized Gal8-based image analysis suite, we hope to significantly enhance the utility of microscopy images in biological research and drug delivery optimization. The efficacy and user-friendliness of the software will be validated through the analysis of both in vitro and in vivo nanoparticle drug delivery experiments, ultimately providing researchers with a powerful and accessible tool for unlocking the full potential of Gal8-based assays in understanding endosomal disruption and advancing scientific discovery.

### 1.3 Who we are:

BRONK is a cell segmentation pipeline written in MATLAB for analysis of large multi-channel experiments. Our pipeline is developed to handle different imaging and microscopy techniques. 

- Multi Page tiff
- Different types of imaging
- Reasons for starting it
    - Who we are, vanderbilt etc. → building off Kameron’s code
- best experiments
- 

# 2. Quick Guide

Many users are familiar with MATLAB and want to dive directly into the codebase. In this case, we have prepared an abridged tutorial outlining only the basics. Please refer to the Video Tutorial and the extensive information in the manual if additional help is needed along the way.

1. Clone the repository from
    
    [https://github.com/VascoSingh/BRONK](https://github.com/VascoSingh/BRONK)
    
2. Navigate to BRONK.m
3. 

### 2.1 Video Tutorial

- [ ]  Insert link here

# 3. Installation

### 3.1 **BRONK Installation on a Computer with MATLAB and the Image Processing Toolbox**

- Clone the repository from https://github.com/VascoSingh/BRONK
- Open the folder containing you respository in the MATLAB app
- In MATLAB navigate to ‘Apps’ → ‘Get More Apps’
- Install the following packages:
    - ND2 Reader 0.1.1
        
        [https://www.mathworks.com/matlabcentral/fileexchange/73271-nd2-reader](https://www.mathworks.com/matlabcentral/fileexchange/73271-nd2-reader)
        
    - writeFCS(fname, DATA, TEXT, OTHER)
        
        [https://www.mathworks.com/matlabcentral/fileexchange/42603-writefcs-fname-data-text-other](https://www.mathworks.com/matlabcentral/fileexchange/42603-writefcs-fname-data-text-other)
        
    - Microscopy Image Browser 2 (MIB2)
        
        [https://www.mathworks.com/matlabcentral/fileexchange/63402-microscopy-image-browser-2-mib2](https://www.mathworks.com/matlabcentral/fileexchange/63402-microscopy-image-browser-2-mib2)
        
- Install and add the Bio-Formats library to path
    - [https://www.openmicroscopy.org/bio-formats/](https://www.openmicroscopy.org/bio-formats/)
    - Download the MATLAB toolbox from the Bio-Formats [downloads page](https://downloads.openmicroscopy.org/bio-formats/6.12.0/)
    . Unzip `bfmatlab.zip` and add the unzipped `bfmatlab` folder to your MATLAB path.
    - Please see [Using Bio-Formats in MATLAB](https://bio-formats.readthedocs.io/en/v6.12.0/developers/matlab-dev.html)
     for usage instructions. If you intend to extend the existing .m files, please also see the [developer page](https://bio-formats.readthedocs.io/en/v6.12.0/developers/index.html)
     for more information on how to use Bio-Formats in general.

# 4. Image Data Format

Directly imports ‘.nd2’ files using nd2 reader

### 4.1 Multiple channels

# 5. Running the Program

### 5.1 User Inputs and Set Up

Before running the BRONK Segmentation Pipeline, users need to configure specific variables in the code to ensure proper analysis of their microscopy images. This section outlines the essential variables that must be set by the user, providing a brief description and an example for each variable. By carefully setting these variables, users can tailor the analysis to their specific experimental setup and requirements.

**Basic Aspects:**
The user will need to define the location of the image file to be analyzed and the directory to which the segmented images should be exported. The following variables are used to set these locations:

**ImgFile** - This variable should be set to the location of the image file to be analyzed. **ImgFile** should be a string representing the file path to the given nd2/tiff file. Do not add trailing slashes.

```matlab
ImgFile=char('C:\Users\John\Downloads\ND2File.nd2');
```

**exportdir** - This variable should be set to the directory where segmented images will be exported. A new folder containing the data of your experiment will be created here.

```matlab
exportdir=char('C:\Users\John\Experiments\ND2Data');
```

**Basic Information:**
The following variables will provide the basic information needed to analyze the image:

**numPlanes** - This variable should be set to the number of image planes to analyze. For example, if the image has three channels (Blue, Green, and Red), then numPlanes should be set to 3.

**BaxExport** - This variable should be set to 'true' if the user wishes to export images to a folder for analysis with BaxterAlgorithms. This option is recommended, but will take up more storage space.

**MakeCompImage** - This variable should be set to 'true' if the user wants to make a composite image of the various channels and segmentation. This option is useful for storing segments for quick checks, but will take up more storage space. It is recommended to leave this option on while checking parameters, but then turn it off for large files. The images can always be checked in BaxterAlgorithms.

**Parallelize** - This variable should be set to 'true' if the user wants to take advantage of multiple processing cores. This option is recommended, but may cause some computers to overheat. If troubleshooting is required, change the 'parfor' loop to a regular 'for' loop to stop parallel processing.

**MiPerPix** - This variable should be set to the resolution of the microscopy in microns per pixel. This is a very important parameter.

**CellSize** - This variable is used to scale as needed for different cells. It is not currently used, but may be incorporated later.

**BitDepth** - This variable should be set to the bit depth of the microscopy images. This is generally 8, 12, or 16 bits. For example, if the image is 12 bits, then BitDepth should be set to 12.

**customrun** - This variable should be set to ‘true’ if the user wants to run a custom set of user-defined wells and/or timepoints

**wells** - This variable should be set to a list of integer value corresponding to the wells the user wants to analyze. Only these wells will be analyzed if **customrun** is set to ‘true’.

To analyze only wells 2-5 → wells = [2 3 4 5];

**timepoints** - This variable should be set to a list of integer value corresponding to the time points the user wants to analyze. Only these time points will be analyzed if **customrun** is set to ‘true’.

To analyze only time points 2 and 4 → timepoints = [2 4];

**OutputFCS** - This variable should be set to ‘true’ if the user wants FCS files to be output on a per image level at the end of the program. 

**OutputPerWell** - This variable should be set to ‘true’ if the user wants Well level data as an .xlsx file.

### 5.2 ImageAnalyses **Instructions**

The **`ImageAnalyses`** variable is a cell array that contains the instructions for the different analysis passes that the program will perform. Each row in the **`ImageAnalyses`** array represents a pass of the computer analyzing the images. Each pass has seven cells, which contain different parameters and settings for the analysis. The following instructions will guide you through the process of creating and modifying the **`ImageAnalyses`** variable for your specific analysis needs.

1. Determine the number of analysis passes you want to perform and create a row for each pass in the **`ImageAnalyses`** cell array. The array should have the following structure:

```
matlabCopy code
ImageAnalyses = {
    {Pass 1},
    {Pass 2},
    {Pass 3},
    ...
};
```

1. For each pass, fill in the seven cells with the appropriate parameters and settings, as described below:
    
    a. Cell 1: Analysis Program - Enter the name of the analysis program you want to run for this pass, e.g., 'Cyt', 'NucPlus', etc.
    
    b. Cell 2: Image Plane Number - Enter the channel number for the image you want to analyze during this pass.
    
    c. Cell 3: Analysis Parameters - Provide the parameters required by the analysis program you selected in Cell 1. The required parameters vary depending on the program; consult the documentation for each program to determine the correct parameters.
    
    d. Cell 4: Output Segmentation Image Color - Specify the color (1 = red, 2 = green, 3 = blue) for the segmentation output image generated by the analysis pass.
    
    e. Cell 5: Color code for the overlay of the analysis mask perimeter on the output image - Specify the color code (3-digit) for the perimeter of the mask generated by the analysis pass.
    
    f. Cell 6: Export a segmented image - Set this to true if you want to export the segmented image, or false if you do not.
    
    g. Cell 7: Image brightness [min max] - Specify the minimum and maximum brightness values for the output image.
    
2. Set the **`CytosolicPass`** variable to the pass number (not the channel number) that best represents the actual cell area. This is typically the pass that runs the 'CytWS' program after 'Cyt' and 'NucPlus' have been executed.

After you have created and configured the **`ImageAnalyses`** variable, the program will use the specified analysis passes to process your images. You can further customize the pipeline by modifying the main function and individual processing functions, as necessary, to accommodate your specific experimental requirements.

# 6. Analysis

### 6.1 Downstream Analysis and Baxter Integration Instructions

### Baxter System Requirements

The software has been designed to work on Windows, Mac and Linux. Most of the testing has however been done on Windows. The software is written in MATLAB, but it also contains some algorithms written in C++, which are compiled into mex-files. The software has been tested with MATLAB 2019b. Later versions should work too, but it cannot be guaranteed. To run the software in MATLAB, you need the toolboxes for Image Processing, Optimization, Parallel Computing, and Statistics and Machine Learning.

### Documentation

The software is started by running the file BaxterAlgorithms.m in MATLAB. Further instructions on how to use the software can be found in UserGuide.pdf, which is located in the folder UserGuide. There are also video tutorials in the YouTube playlist [https://tinyurl.com/ba-tutorials](https://tinyurl.com/ba-tutorials).

### 6.2 Downstream Flow Cytometry Analysis (FCS)

FCS stands for “Flow Cytometry Standard.” These files provide a standard for a uniform file format that allows files created by one type of acquisition hardware and software to be read by any other. If 

### 6.3 Well-Level Data Interpretation and Analysis

# 7. Development

# 8. How to Cite

# 9. Support

To report any issues, suggest new features, or request enhancements for the BaxterAlgorithms software, please visit the following link: https://github.com/VascoSingh/BRONK/issues. When reporting a bug, please provide details such as the version of MATLAB, the operating system being used, the error message received, and a clear set of instructions on how to replicate the issue. Additionally, please specify if you are using a deployed version of the software. If you have any questions that are not addressed in the user guide, feel free to email them to brock.fletcher@vanderbilt.edu.

# 10. Acknowledgments

# 11. Licenses

### 11.1 License for nd2reader

MIT License

Copyright (c) [2019] [Jacob Zuo]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

### 11.2 License for writeFCS(fname, DATA, TEXT, OTHER)

Copyright (c) 2015, Jakub Nedbal
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

### 11.3 License for Microscopy Image Browser 2 (MIB2)

License for Microscopy Image Browser source code
Source code of Microscopy Image Browser (MIB) is licensed under the GNU General Public License v2.

By using MIB in MATLAB source code form, you agree to the terms of

- the GNU General Public License, version 2 (see the license text below)
- the licenses of external packages
- the following disclaimer:

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE. MATHWORKS AND ITS LICENSORS ARE EXCLUDED
FROM ALL LIABILITY FOR DAMAGES OR ANY OBLIGATION TO PROVIDE REMEDIAL ACTIONS.

GNU GENERAL PUBLIC LICENSE
                   Version 2, June 1991

Copyright (C) 1989, 1991 Free Software Foundation, Inc., [http://fsf.org/](http://fsf.org/)
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
Everyone is permitted to copy and distribute verbatim copies
of this license document, but changing it is not allowed.

### 11.4 License for Bio-Formats

Copyright (c) 2005 - 2014, Open Microscopy Environment:

- Board of Regents of the University of Wisconsin-Madison
- Glencoe Software, Inc.
- University of Dundee
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

# 12. References

[1] Kilchrist, Kameron V et al. “Gal8 Visualization of Endosome Disruption Predicts Carrier

Mediated Biologic Drug Intracellular Bioavailability.” *ACS nano*
 vol. 13,2 (2019): 1136-1152. doi:10.1021/acsnano.8b05482
