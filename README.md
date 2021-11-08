### Структура программного комплекса "Панорама" ###
##### Программный комплекс "Панорама" состоит из:  #####
###### 1.  Cервер области, включающий в себя: ######
+  [josm gas](https://gitlab.cloud.gas.by/panorama/josm-gas)
+  web-модуль комплекса "[Панорама](http://panorama.topgas.by/)", отображающий данные определённой области
+  render
*Для каждой области существует отдельный сервер*
######  2.  Cервер FTP, выполняющий: ######
+  хранение "свежих" osm файлов с каждой области(/home/ftp/)
+  формирование всех маршрутов для miriada(/home/routs/)
+  работу web-модуля комплекса "Панорама", отображающий данные всех областей
######  3.   Сервер VTiles, роль которого: ######
+  cоздание файлов формата mbtiles на основе osm файлов, взятых с сервера FTP
+  обновление картографического сервера "TileServer"
+  создание файлов формата db для комплекса "Мириада"
+  временное хранение файлов формата db, описанных выше
######  4.   Сервер Storage, выполняющий: ######
+  хранение файлов формата db, созданных на сервере VTiles
___
*Передача файлов формата osm от сервера области к серверу FTP осуществляется в архиве zip каждую пятницу.*
*Передача файлов формата geojson от сервера FTP к серверу VTiles осуществляется в архиве zip каждые выходные.*
*Передача файлов формата db от сервера VTiles к серверу Storage осуществляется каждые выходные.*
___

![Image alt](https://github.com/Zhdanovich98/osmconvertor/raw/master/png/diagram1.png)
