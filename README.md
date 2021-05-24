# URSUS_UHI

URSUS_UHI is a tool for the automatic detection of the most disadvantaged areas due to the urban heat island effect (UHI). 

### Requirements📋

- R
- RStudio
- Landsat-8 satellite images of the city to be analized

## How does it work? 🚀

- Clone the repository on your local machine (git clone "https://github.com/ursusdm/URSUS_UHI.git"). 

- For the correct operation of the tool, it is necessary:  
 
  A) Create a **folder** called **data** that will contain the images of the cities to be analyzed
  
  B) Create a **folder with the name of the city** to be analyzed and add the Landsat-8 images inside data folder.  
  
  For example, to analyze the city of Malaga:  

<img width="546" alt="Captura de pantalla 2021-05-24 a las 13 24 07" src="https://user-images.githubusercontent.com/68539118/119340823-52c83900-bc93-11eb-8b82-67f449a63c9a.png">

<img width="291" alt="Captura de pantalla 2021-05-24 a las 13 22 03" src="https://user-images.githubusercontent.com/68539118/119340617-0977e980-bc93-11eb-82d9-bcae04b177d5.png"><img width="322" alt="Captura de pantalla 2021-05-24 a las 13 36 06" src="https://user-images.githubusercontent.com/68539118/119342208-0251db00-bc95-11eb-8e9c-43ec4af3bce3.png"><img width="822" alt="Captura de pantalla 2021-05-24 a las 13 38 10" src="https://user-images.githubusercontent.com/68539118/119342379-4b099400-bc95-11eb-92f7-c298c188b64d.png">


  C) **Select cropping mode** of the area of interest (manual / interactive) and run script:  
  
  The next step will be to open one of the two attached scripts with RStudio.  
  
- The **interactive_cropping** script allows you to select the area of interest by drawing a rectangle on the map of satellite images that cover the study city.  

- The **cropping_by_coordinates** script allows you to manually enter the coordinates of the area of interest.    

For example, to analyze the city of Malaga using cropping_by_coordinates script setting the coordinates of area of interest manually, open the script with RStudio, set the cityName variable to "MALAGA", and set the area of interest coordinates :  

<img width="1115" alt="Captura de pantalla 2021-05-24 a las 14 18 08" src="https://user-images.githubusercontent.com/68539118/119346736-e4877480-bc9a-11eb-8e75-cb73e5393b49.png">


<img width="1121" alt="Captura de pantalla 2021-05-24 a las 13 53 29" src="https://user-images.githubusercontent.com/68539118/119344010-71303380-bc97-11eb-8d0c-9ff7a93d330f.png">

- **Run script**. You can run the script to get a pdf report. <img width="439" alt="Captura de pantalla 2021-05-24 a las 14 13 38" src="https://user-images.githubusercontent.com/68539118/119346251-44315000-bc9a-11eb-8b1a-b80d9756e44a.png"> or you can run all chunks on RStudio in case you need higher quality images. <img width="370" alt="Captura de pantalla 2021-05-24 a las 14 25 13" src="https://user-images.githubusercontent.com/68539118/119347470-ddad3180-bc9b-11eb-85ca-3499d56515b2.png">

- **pdf generated from the study of Málaga with manual coordinates**. [cropping_coordenadas.pdf](https://github.com/ursusdm/URSUS_UHI/files/6532303/cropping_coordenadas.pdf)


- Results availables from pdf or from run chunks are: 
 
A) A map with a cluster for more disfavourable areas. 

B) A map with pixel DAI values (-1(more favourable) +1 (more disfavourable) ). 

C) A map with pixel DAI values for more disfavourable cluster.  

<img width="637" alt="Captura de pantalla 2021-05-24 a las 14 23 22" src="https://user-images.githubusercontent.com/68539118/119348248-e4887400-bc9c-11eb-85fb-630357c38843.png">


## Construido con 🛠️

* [R](https://www.r-project.org/) - Programming language
* [RStudio](https://www.rstudio.com/) -  IDE


## Autores ✒️


* **Francisco Rodríguez Gómez** 
* **José del Campo Ávila** 
* **Domingo López Rodríguez** 
* **Luis Pérez Urrestarazu** 

 

## Licencia 📄

Este proyecto está bajo la Licencia (Tu Licencia) - mira el archivo [LICENSE.md](LICENSE.md) para detalles

## Acknowledgements 🎁

* This work has been supported by the project RTI2018-095097-B-I00 at the 2018 call for I+D+i Project of the Ministerio de Ciencia, Innovación y Universidades, Spain. Funding for open access charge: Universidad de Málaga / CBUA.

