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

### select the city of study interest

  <img width="433" alt="LAndsat-1" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/a74b6766-cdaa-4675-a701-b59060bacbad">

  <img width="1679" alt="Landsat-2" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/90d187d2-1b39-4557-87cb-eb7e67a09c51">

### Select the satellite image type: LANDSAT-8

 <img width="430" alt="Landsat-3" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/ad8dd8ec-d57c-4e12-a74f-1e90b8a4b9b9">

### Visualize results

 <img width="1657" alt="Landsat-4" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/2372d05e-2a2c-4a14-b004-92d989e8de6b">

### Download image

<img width="934" alt="dwnld" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/22f10cd8-5942-4b99-ba4d-02961bc1fedd">



### Requirements📋

- R
- RStudio
- renv

### Main Steps📋
  
- **Clone the repository** on your local machine (git clone "https://github.com/ursusdm/URSUS_UHI.git").

- **Open R proyect** file
  
- **Download dependencies and libraries using renv:**  renv::init() and app ready!

## How does it work? 🚀
 
  A) Launch App

  B) Select image folder
  
  <img width="287" alt="Captura de Pantalla 2023-11-05 a las 1 56 11" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/ae012be0-fa36-4cc7-86e0-029a1cbabd1d">

  <img width="1106" alt="Captura de Pantalla 2023-11-05 a las 1 55 33" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/f6c8243e-023a-4eba-ad61-af2c118769ef">
  
  B) Croping area of interest over leaflet map (blue rectangle).  Red rectangle is the area cover by the selected landsat-8 image.
  
  <img width="1680" alt="Captura de Pantalla 2023-11-05 a las 2 15 41" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/ba07dc96-71dd-4cef-91e4-6f45af38f399">

  C) Show result

 ## Results

 **NDVI** Normalized difference Vegetation Index
 
 <img width="553" alt="Captura de Pantalla 2023-11-05 a las 2 04 28" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/08e3960b-2a83-4f25-a303-55130192c0a5">

 **LST** Land Surface Temperature
 
 **DISFAVOURABLE AREAS WITH DAI INDEX** This plot show the more disfavourables areas and their damage level.


 

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

