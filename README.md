# URSUS_UHI

<img width="1259" alt="Captura de pantalla 2021-05-24 a las 20 30 07" src="https://user-images.githubusercontent.com/68539118/119391636-e1a67700-bcce-11eb-9b01-42cafffdbf31.png">

**URSUS_UHI** is a tool for the **automatic determination of the urban areas most disadvantaged by the urban heat island effect**. 

The use of the tool is very simple, and consists of the following steps.

a) **Download** a **Landsat-8 image** of the city of interest

b) **Select** a **landsat-8 image** 

c) **Cropping** the **area of ​​interest** interactively on the map

d) **Show results**

## Download a Landsat-8 image of the city of interest

To download Landsat-8 images of the cities of study interest, we can do so for free from the site https://earthexplorer.usgs.gov/ following the instructions shown in the screenshots:


### User register in UGSS (Skip this step if you already have a registered user in UGSS)

The first step is to register a user in [with USGS](https://earthexplorer.usgs.gov/). If you do not register, you will not be able to download images

### select the city of study interest

  <img width="433" alt="LAndsat-1" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/a74b6766-cdaa-4675-a701-b59060bacbad">

  <img width="1679" alt="Landsat-2" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/90d187d2-1b39-4557-87cb-eb7e67a09c51">

### Select the satellite image type: LANDSAT-8

 <img width="430" alt="Landsat-3" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/ad8dd8ec-d57c-4e12-a74f-1e90b8a4b9b9">


 - Push result button
   
 
<img width="414" alt="Captura de pantalla 2023-11-29 a las 17 18 47" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/37d6c0cc-5159-4b01-9a3c-d10f1013b885">

### Visualize results. 

 <img width="1657" alt="Landsat-4" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/2372d05e-2a2c-4a14-b004-92d989e8de6b">

### Download image

- Click the download button on any of the images

<img width="409" alt="Captura de pantalla 2023-11-29 a las 17 24 32" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/518bb558-5fff-43d4-a189-75b3d5177e27">

- Click products options

 <img width="445" alt="Captura de pantalla 2023-11-29 a las 17 30 28" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/26319dfb-edca-42f5-808f-3741c6a1daed">

- Download the first file (1 GB aprox.)
  
<img width="934" alt="dwnld" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/22f10cd8-5942-4b99-ba4d-02961bc1fedd">

## Insert into Data folder 


### Requirements📋

- R
- RStudio
- renv

### Main Steps📋
  
- **Clone the repository** Open your terminal on your local machine and clone repository (git clone "https://github.com/ursusdm/URSUS_UHI.git").

- **Create Data folder** on URSUS_UHI App folder. You can create data folder from the UI or from the terminal with the command mkdir data (in both cases inside the APP folder of the project)

- **Open R proyect** file
- 
  <img width="121" alt="Captura de pantalla 2023-11-29 a las 17 56 59" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/27ed6bd7-fa32-4dee-8b95-09f2b65b5958">

- **Download dependencies and libraries using renv:**  renv::init().

 <img width="387" alt="Captura de pantalla 2023-11-29 a las 17 58 12" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/f4782b79-cfe7-4c73-b4cc-ae39febfbbf1">

 If app not works, you can try to install manually the required library apps from (app.R start file) using install.packages("libraryNAme")

 <img width="178" alt="Captura de pantalla 2023-11-29 a las 17 51 49" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/da2dc255-e2a4-4e4b-967a-5646f04f6a50">

<img width="493" alt="Captura de pantalla 2023-11-29 a las 17 52 40" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/6161ed22-902d-4033-a6ac-6552182f4071">



## How does it work? 🚀
 
  A) Launch App

  B) Select image folder
  
  <img width="287" alt="Captura de Pantalla 2023-11-05 a las 1 56 11" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/ae012be0-fa36-4cc7-86e0-029a1cbabd1d">

  <img width="897" alt="Captura de Pantalla 2023-11-08 a las 15 25 08" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/8d51b71e-1a92-47b4-a758-db76747a46ab">

  
  B) Croping area of interest over leaflet map (blue rectangle).  Red rectangle is the area cover by the selected landsat-8 image.
  
  <img width="967" alt="MAP" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/5f5176aa-e313-41b2-861e-17e886cc79e3">
  
  <img width="971" alt="croped" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/7b775255-5685-4bbe-92d8-15deeea82d49">


  C) Show result

 ## Results

 **NDVI** Normalized difference Vegetation Index and **LST** Land Surface Temperature

 <img width="1675" alt="LST_NDVI" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/4c33f6db-4976-49b7-a7b5-3d4a8aa9fb3a">

 **CLUSTERS AND DISFAVOURABLE AREAS WITH DAI INDEX** This plot show the more disfavourables areas and their damage level.

 <img width="1671" alt="CLUSTERS_DAI" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/ed7ca4d9-a7a5-4956-b1f3-d2c4ee740b49">

## Developed tool 🛠️

* [R](https://www.r-project.org/) - Programming language
* [RStudio](https://www.rstudio.com/) -  IDE
* R Libraries (shiny, dplyr, leaflet, raster, rf)


## Authors ✒️


* **Francisco Rodríguez Gómez** 
* **José del Campo Ávila** 
* **Domingo López Rodríguez** 
* **Luis Pérez Urrestarazu** 

 
## License 📄

This project is under GNU General Public License v3.0 [LICENSE.md](LICENSE.md) for more detail.

## Acknowledgements 🎁

* This work has been supported by the project RTI2018-095097-B-I00 at the 2018 call for I+D+i Project of the Ministerio de Ciencia, Innovación y Universidades, Spain. Funding for open access charge: Universidad de Málaga / CBUA.

