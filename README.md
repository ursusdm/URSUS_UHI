# URSUS_UHI

<img width="800" alt="URSUS_UHI: URban SUStainability software for detection of unfavourable areas due to the Urban Heat Island effect" src="https://user-images.githubusercontent.com/68539118/119391636-e1a67700-bcce-11eb-9b01-42cafffdbf31.png">

**URSUS_UHI** is a tool for the **automatic detection of unfavourable areas due to the Urban Heat Island (UHI) effect**. 

The tool is very simple to use and consists of the following steps.

  1. **Download** a **Landsat-8 image** of the city of interest
  2. **Run URSUS_UHI software** to **process** the image to detect unfavourable areas

      2.1 **Install / Run** URSUS_UHI software
  
      2.2. **Load** the image and **crop the area of ​​interest** interactively on the map

      2.3. **Show results**

## Download a Landsat-8 image of the city of interest

To download Landsat-8 images of the cities of interest for the study, we can do so free of charge from the site  https://earthexplorer.usgs.gov . It is necessary to be registered on this site in order to download the images.

The following screenshots show the process in detail: 

### Select the city of interest for the study (Search Criteria tab)

Define "Feature Name" and "Country" (or "State" if US features are used). In this example we select Madrid, the capital of Spain.

=== ESTA IMAGEN HABRÍA QUE VOLVERLA A CAPTURAR (para que esté seleccionado el worl features)

<img width="433" alt="Select the city of study interest (1): Filter" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/a74b6766-cdaa-4675-a701-b59060bacbad">

Press the "Show" button and select the most appropriate element. A map with the selected item is then displayed.

<img width="1679" alt="Select the city of study interest (2): Map" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/90d187d2-1b39-4557-87cb-eb7e67a09c51">

### Select satellite image type: LANDSAT-8 (Data Sets tab)

Search for Landsat-8 image and press the "Results" button


=== ESTAS DOS IMÁGENES LAS FUSIONARÍA
<img width="430" alt="Select satellite image type (1): Landsat-8" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/ad8dd8ec-d57c-4e12-a74f-1e90b8a4b9b9">


<img width="414" alt="Select satellite image type (2): Landsat-8" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/37d6c0cc-5159-4b01-9a3c-d10f1013b885">

### Select the image that most suits your needs and download it

Each image has a list of buttons to interact with it. Click on the "Download" button for that image (green arrow going down to a hard disk).

=== ESTAS DOS IMÁGENES LAS FUSIONARÍA

 <img width="1657" alt="Landsat-4" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/2372d05e-2a2c-4a14-b004-92d989e8de6b">

<img width="409" alt="Captura de pantalla 2023-11-29 a las 17 24 32" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/518bb558-5fff-43d4-a189-75b3d5177e27">

Click in the "Products options" button

 <img width="445" alt="Captura de pantalla 2023-11-29 a las 17 30 28" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/26319dfb-edca-42f5-808f-3741c6a1daed">

And download the first file (1 GB aprox.). It may be necessary to allow pop-up windows
  
<img width="934" alt="dwnld" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/22f10cd8-5942-4b99-ba4d-02961bc1fedd">

After this process, the data of the city of interest is ready to be processed by the URSUS-UHI software.


## Run URSUS_UHI software to process the image to detect unfavourable areas

### Requirements

- R (¿ALGUNA VERSIÓN COMO REQUISITO?)
- RStudio (¿ALGUNA VERSIÓN COMO REQUISITO?)
- renv (¿ALGUNA VERSIÓN COMO REQUISITO?)

### Install / Run URSUS_UHI software
  
- **Clone the repository.** Open your terminal on your local machine and clone the repository

      git clone "https://github.com/ursusdm/URSUS_UHI.git"
    
  ESTO HABRÍA QUE COMPROBARLO CUANDO ESTÉ PÚBLICO. YO NO HE PODIDO DESCARGARLO ASÍ.

- **Create Data folder** on URSUS_UHI App folder. You can create data folder from the UI or from the terminal with the command mkdir data (in both cases inside the APP folder of the project). ¿Y SI CREAMOS LA CARPETA NOSOTROS, DEJÁNDOLA VACÍA?

  <img width="626" alt="Captura de pantalla 2023-11-29 a las 17 59 09" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/ec68efae-1d11-4c05-8d14-0fa4b12a0a0a">

- **Open R project file** placed in the folder
  
  <img width="121" alt="Captura de pantalla 2023-11-29 a las 17 56 59" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/27ed6bd7-fa32-4dee-8b95-09f2b65b5958">

- **Install / use renv package**. This package helps you to create reproducible environments for your R projects.

  Use the terminal inside RStudio to install the renv package.

      install.packages("renv")
 
  <img width="226" alt="Captura de pantalla   2023-11-29 a las 18 03 32" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/6ad97af5-496c-452e-9c86-47bc1217273d">

  Download dependencies and libraries using renv:  

      renv::init()

  Select yes (if this is the first time renv is used) and select "Selection 1" to use exactly the same libraries that the application uses in its RStudio environment project.

  QUITARÍA ESTA IMAGEN POR HABER PUESTO EL CÓDIGO

  <img width="387" alt="Captura de pantalla 2023-11-29 a las 17 58 12" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/f4782b79-cfe7-4c73-b4cc-ae39febfbbf1">

  <img width="639" alt="Captura de pantalla 2023-11-29 a las 18 06 52" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/fd47d9ee-1338-419e-bdff-cd197c44e1d5">

  HE AÑADIDO NUEVO CÓDIGO PARA QUE ESTO QUE VIENE DESPUÉS NO SEA NECESARIO. HAY QUE MIRARLO

  If a package is not installed, you can try to install it manually. The required library packages are listed in the app.R file. Use:
  
      install.packages("libraryName")



 <img width="178" alt="Captura de pantalla 2023-11-29 a las 17 51 49" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/da2dc255-e2a4-4e4b-967a-5646f04f6a50">

<img width="493" alt="Captura de pantalla 2023-11-29 a las 17 52 40" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/6161ed22-902d-4033-a6ac-6552182f4071">



## Load the image and crop the area of ​​interest interactively on the map 🚀
 
### Run the application

  Click button on "Run App" on file App.R

  <img width="1190" alt="Captura de pantalla 2023-11-29 a las 18 10 08" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/f631958a-50f3-4ed4-9356-cc0c5f99760c">

  The app is executed in a new window

### Select the image

  Search for the desired image in the data folder.

  NO SE DICE QUE HAY QUE DESCOMPRIMIR EL TAR. SE INDICA ALGO EN EL TEXTO DE LA CAJA DONDE ESTÁ EL BOTÓN
  
  <img width="287" alt="Captura de Pantalla 2023-11-05 a las 1 56 11" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/ae012be0-fa36-4cc7-86e0-029a1cbabd1d">

  <img width="897" alt="Captura de Pantalla 2023-11-08 a las 15 25 08" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/8d51b71e-1a92-47b4-a758-db76747a46ab">

  
### Crop the area of interest over the map. Use the icon with a black square to define this area. It is marked in the map by a blue rectangle.

ESTO NO LO ENTIENDO.
Red rectangle is the area cover by the selected landsat-8 image.
  
  <img width="967" alt="MAP" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/5f5176aa-e313-41b2-861e-17e886cc79e3">
  
  <img width="971" alt="croped" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/7b775255-5685-4bbe-92d8-15deeea82d49">


### Process the urban area

  Next screenshots show the results calculated from the data.

 **NDVI** map (Normalized difference Vegetation Index) and **LST** map (Land Surface Temperature)

 <img width="1675" alt="LST_NDVI" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/4c33f6db-4976-49b7-a7b5-3d4a8aa9fb3a">

 **Clusters** map (with different levels of un) and **DAI** map (Disadvantaged Area Index). 
 
 UNFAVOURABLE AREAS WITH DAI INDEX** This plot show the more disfavourables areas and their damage level.

 EN LA APLICACIÓN HEMOS USADO DISFAVORABLE, EN EL DAI DISADVANTAGED Y EN ESTE MANUAL Y CREO QUE EN EL ARTICULO DE 16 CIUDADES UNFAVOURABLE. HAY QUE HOMOGENEIZAR. SEGURAMENTE, ¿DEJAMOS UNFAVOURABLE PARA EL TEXTO? Y ¿DISADVANTAGED PARA EL DAI?

 <img width="1671" alt="CLUSTERS_DAI" src="https://github.com/ursusdm/URSUS_UHI/assets/68539118/ed7ca4d9-a7a5-4956-b1f3-d2c4ee740b49">

  ¿NO SE CALCULABA UN MAPA COMO CON UNA MÁSCARA QUE COMBINABA LOS DOS ÚLTIMOS MAPAS?

  LA IMAGEN CROPPED SE MUY MAL


NO ESTOY SEGURO DE QUE ESTO HAGA FALTA O QUIZÁS MEJOR SE PONE DE OTRA FORMA. MÁS ARRIBA APARECEN LOS REQUIREMENT
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

  This work has been supported by the project RTI2018-095097-B-I00 at the 2018 call for I+D+i Project of the Ministerio de Ciencia, Innovación y Universidades, Spain. 
