 # URSUS_UHI

<img width="1259" alt="G_A" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/2d23532d-7795-41a7-ab77-0d5f3089e60a">

**URSUS_UHI** is a tool for the **automatic detection of unfavourable areas due to the Urban Heat Island (UHI) effect**. 

The tool is very simple to use and consists of the following steps.

  1. **Download** a **Landsat-8 image** of the city of interest
  2. **Run URSUS_UHI software** to **process** the image to detect unfavourable areas

      2.1 **Install / Run** URSUS_UHI software
  
      2.2. **Load** the image and **crop the area of ​​interest** interactively on the map

      2.3. **Show results**

     <img width="1063" alt="Captura de pantalla 2024-02-02 a las 13 49 15" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/06f43bb0-59e2-4937-8379-1b172d4474f8">


## Download a Landsat-8 image of the city of interest

To download Landsat-8 images of the cities of interest for the study, we can do so free of charge from the site  https://earthexplorer.usgs.gov . It is necessary to be registered on this site in order to download the images.

The following screenshots show the process in detail: 

### Select the city of interest for the study (Search Criteria tab)

Define "Feature Name" and "Country" (or "State" if US features are used). In this example we select Madrid, the capital of Spain.

<img width="430" alt="W_F" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/0826446b-95a1-41ea-8eae-76f1e9ad1f08">

Select the most appropriate element and press the "Show" button.

<img width="427" alt="Captura de pantalla 2024-01-25 a las 12 57 20" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/88bfab5f-0eaa-48df-9270-beee435b553d">

A map with the selected item is then displayed.

<img width="1679" alt="Select the city of study interest (2): Map" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/90d187d2-1b39-4557-87cb-eb7e67a09c51">

### Select satellite image type: LANDSAT-8 (Data Sets tab)

Search for Landsat-8 image and press the "Results" button

<img width="439" alt="result_button" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/ec40f2e3-c1c7-433f-b61a-7178a4627cbe">


### Select the image that most suits your needs and download it

Each image has a list of buttons to interact with it. Click on the "Download" button for that image (green arrow going down to a hard disk).

<img width="1079" alt="ds" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/da82dc61-f2e3-429c-a588-2a70031d8d83">

Click in the "Products options" button

 <img width="445" alt="Captura de pantalla 2023-11-29 a las 17 30 28" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/26319dfb-edca-42f5-808f-3741c6a1daed">

And download the first file (1 GB aprox.). It may be necessary to allow pop-up windows
  
<img width="934" alt="dwnld" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/22f10cd8-5942-4b99-ba4d-02961bc1fedd">

After this process, the data of the city of interest is ready to be processed by the URSUS-UHI software.

```diff
- All downloaded images must be placed unzipped in the data folder of the project.
```


## Run URSUS_UHI software to process the image to detect unfavourable areas

### Requirements

- R 4.3.1 or latest version
- RStudio
- Some R libraries (renv, shiny, dplyr, ...)

### Install / Run URSUS_UHI software
  
- **Clone the repository.** Open your terminal on your local machine and clone the repository

      git clone "https://github.com/ursusdm/URSUS_UHI.git"

- **Open R project file** placed in the folder
  
  <img width="121" alt="Captura de pantalla 2023-11-29 a las 17 56 59" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/27ed6bd7-fa32-4dee-8b95-09f2b65b5958">

- **Install / use renv package**. This package helps you to create reproducible environments for your R projects.

  Use the terminal inside RStudio to install the renv package.

      install.packages("renv")
 
  Download dependencies and libraries using renv:  

      renv::init()

  Select yes (if this is the first time renv is used) and select "Selection 1" to use exactly the same libraries that the application uses in its RStudio environment project.

  <img width="639" alt="Captura de pantalla 2023-11-29 a las 18 06 52" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/fd47d9ee-1338-419e-bdff-cd197c44e1d5">

  If a package is not installed, you can try to install it manually. The required library packages are listed in the app.R file. Use:
  
      install.packages("libraryName")

<img width="178" alt="Captura de pantalla 2023-11-29 a las 17 51 49" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/da2dc255-e2a4-4e4b-967a-5646f04f6a50">

<img width="493" alt="Captura de pantalla 2023-11-29 a las 17 52 40" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/6161ed22-902d-4033-a6ac-6552182f4071">



## Load the image and crop the area of ​​interest interactively on the map 🚀
 
### Run the application

  Click button on "Run App" on file App.R
  
  <img width="1028" alt="Captura de pantalla 2024-01-25 a las 21 43 30" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/f2826ee4-3d62-4a81-adbe-642c0c0668e9">

  The app is executed in a new window

### Select the image

  Search for the desired image in the data folder. Select image folder (not files inside). In this example, select Malaga folder and push select 'button'.

  <img width="401" alt="select_b" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/a4d86611-bfe5-4a05-8e18-a5e371593091">

  <img width="877" alt="Captura de pantalla 2024-01-25 a las 22 14 18" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/d4c2d545-5b3a-4e7b-a765-11d46275d599">

### Crop the area of interest over the map. Use the icon with a black square to define this area. It is marked in the map by a blue rectangle.

Red rectangle is the area cover by the selected landsat-8 image.
  
<img width="778" alt="Captura de pantalla 2024-01-25 a las 21 57 46" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/e36fbfd8-2fd6-49be-a985-edc49a985a2f">

### Process the urban area

  Next screenshots show the results calculated from the data.

 **NDVI** map (Normalized difference Vegetation Index) and **LST** map (Land Surface Temperature)
 
  <img width="877" alt="Captura de pantalla 2024-01-25 a las 22 12 56" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/262cd2a3-51d5-4274-a59f-041276e6506d">

 **Clusters** map (the urban areas are classified based on different levels (favourable (fav.), more favourable (more fav.), unfavourable (unf.) ) of emergency in terms of adding green infrastructure.) and **DAI** map (Disadvantaged Area Index).
 
 <img width="876" alt="Captura de pantalla 2024-01-25 a las 22 11 19" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/40fdd4c7-85e3-40f7-acf0-d7c1f6a8cb90">


## Authors ✒️

* **Francisco Rodríguez Gómez** 
* **José del Campo Ávila** 
* **Domingo López Rodríguez** 
* **Luis Pérez Urrestarazu** 

 
## License 📄

  This project is under GNU General Public License v3.0 [LICENSE.md](LICENSE.md) for more detail.

## Acknowledgements 🎁

  This work has been supported by the project RTI2018-095097-B-I00 at the 2018 call for I+D+i Project of the Ministerio de Ciencia, Innovación y Universidades, Spain. 
