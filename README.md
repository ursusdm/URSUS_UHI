# URSUS_UHI

URSUS_UHI is a tool based on data mining and machine learning for the automatic detection of the most disadvantaged areas due to the urban heat island effect (UHI). 

<img width="1259" alt="Captura de pantalla 2021-05-24 a las 20 30 07" src="https://user-images.githubusercontent.com/68539118/119391636-e1a67700-bcce-11eb-9b01-42cafffdbf31.png">


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

For **example**, to analyze the city of Malaga using **cropping_by_coordinates** script setting the coordinates of area of interest manually, open the script with RStudio, set the cityName variable to "MALAGA", and set the area of interest coordinates : 


<img width="1130" alt="Captura de pantalla 2021-05-24 a las 13 58 21" src="https://user-images.githubusercontent.com/68539118/119378888-0c88cf00-bcbf-11eb-9f46-7ddc796594b3.png">



<img width="1121" alt="Captura de pantalla 2021-05-24 a las 13 53 29" src="https://user-images.githubusercontent.com/68539118/119344010-71303380-bc97-11eb-8d0c-9ff7a93d330f.png">

- **Run script**. You can run the script to get a pdf report. <img width="439" alt="Captura de pantalla 2021-05-24 a las 14 13 38" src="https://user-images.githubusercontent.com/68539118/119346251-44315000-bc9a-11eb-8b1a-b80d9756e44a.png"> or you can run all chunks on RStudio in case you need higher quality images. <img width="370" alt="Captura de pantalla 2021-05-24 a las 14 25 13" src="https://user-images.githubusercontent.com/68539118/119347470-ddad3180-bc9b-11eb-85ca-3499d56515b2.png">

- **pdf generated from the study of Málaga with manual coordinates**. [cropping_coordenates.pdf](https://github.com/ursusdm/URSUS_UHI/files/6532303/cropping_coordenadas.pdf)


- **Results availables** from pdf or from run chunks are: 
 
A) A map with a cluster for more disfavourable areas. 

B) A map with pixel DAI values (-1(more favourable) +1 (more disfavourable) ). 

C) A map with pixel DAI values for more disfavourable cluster.  

D) A table with disfavourable and urban element areas on % and km2.  


<img width="637" alt="Captura de pantalla 2021-05-24 a las 14 23 22" src="https://user-images.githubusercontent.com/68539118/119348248-e4887400-bc9c-11eb-85fb-630357c38843.png">


For **example**, to analyze the city of Malaga using **interactive_cropping** script setting the coordinates of area of interest drawing a rectangle over satellite images map, open the script with RStudio:

A) Set Chunk Output in Console for add interactivity to map plotted.  


<img width="1214" alt="Captura de pantalla 2021-05-24 a las 18 46 40" src="https://user-images.githubusercontent.com/68539118/119379958-63db6f00-bcc0-11eb-9ec9-991b47b6028d.png">. 



B) Set the cityName variable to "MALAGA":  


<img width="1130" alt="Captura de pantalla 2021-05-24 a las 13 58 21" src="https://user-images.githubusercontent.com/68539118/119378888-0c88cf00-bcbf-11eb-9f46-7ddc796594b3.png"> 

C.1) Run all chunk

<img width="1058" alt="Captura de pantalla 2021-05-24 a las 20 07 55" src="https://user-images.githubusercontent.com/68539118/119389366-cede7300-bccb-11eb-8993-b49a74663657.png">

D) Draw a rectangle which cover area of interest.

<img width="418" alt="Captura de pantalla 2021-05-24 a las 16 48 53" src="https://user-images.githubusercontent.com/68539118/119379081-4e197a00-bcbf-11eb-9e9f-03078f2dfc72.png">

E) Navigate over plots with left and right arrow to show plotted result (Clusters, disfavourable areas, NDVI, LST, ...)

<img width="452" alt="Captura de pantalla 2021-05-24 a las 20 22 01" src="https://user-images.githubusercontent.com/68539118/119390714-bbcca280-bccd-11eb-9c31-8135ec62d75f.png">

<img width="1656" alt="Captura de pantalla 2021-05-24 a las 20 21 36" src="https://user-images.githubusercontent.com/68539118/119390717-bc653900-bccd-11eb-8ca6-4adfb82559d0.png">

<img width="595" alt="Captura de pantalla 2021-05-24 a las 20 21 48" src="https://user-images.githubusercontent.com/68539118/119390719-bcfdcf80-bccd-11eb-9213-5f2fe72c07e8.png">


## Download satellite image from Málaga

- https://oc.iaia.lcc.uma.es/index.php/s/rDqNDaOaxoe1YSf (password:ursus)


## Construido con 🛠️

* [R](https://www.r-project.org/) - Programming language
* [RStudio](https://www.rstudio.com/) -  IDE


## Autores ✒️


* **Francisco Rodríguez Gómez** 
* **José del Campo Ávila** 
* **Domingo López Rodríguez** 
* **Luis Pérez Urrestarazu** 

 

## Licencia 📄

This project is under GNU General Public License v3.0 [LICENSE.md](LICENSE.md) for more detail.

## Acknowledgements 🎁

* This work has been supported by the project RTI2018-095097-B-I00 at the 2018 call for I+D+i Project of the Ministerio de Ciencia, Innovación y Universidades, Spain. Funding for open access charge: Universidad de Málaga / CBUA.

