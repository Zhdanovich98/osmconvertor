### Структура программного комплекса "Панорама" ###
##### Программный комплекс "Панорама" состоит из:  #####
###### 1.  Cервер области, включающий в себя: ######
+  [josm-gas](https://gitlab.cloud.gas.by/panorama/josm-gas)(Rails)
+  web-модуль комплекса "[Панорама](http://panorama.topgas.by/)", отображающий данные определённой области
+  render

*Для каждой области существует отдельный сервер области*
######  2.  Cервер FTP(10.108.220.9), выполняющий: ######
+  хранение "свежих" osm файлов с каждой области(/home/ftp/)
+  формирование всех маршрутов для комплекса "[Мириада](https://gitlab.cloud.gas.by/miriada)"(/home/routs/)
+  работу web-модуля комплекса "[Панорама](http://panorama.topgas.by/)", отображающий данные всех областей
######  3.   Сервер VTiles(172.20.220.42), роль которого: ######
+  cоздание файлов формата mbtiles на основе osm-файлов
+  работа/обновление картографического сервера "TileServer"
+  создание/хранение файлов формата db для комплекса "[Мириада](https://gitlab.cloud.gas.by/miriada)"
+  обновление точек повреждений для комплекса "[Мириада](https://gitlab.cloud.gas.by/miriada)" при помощи скриптов(/home/update_gas_dbs)
######  4.   Сервер Storage, выполняющий: ######
+  хранение файлов формата db, созданных на сервере VTiles
######  5.   Сервер Rails respublic, включающий в себя: ######
+  josm-dom(Rails)
___

##### Описание: ##### 
1. На сервер Rails respublic работает Josm-dom(Rails), необходимый для создания/редактирования географических элементов Республики Беларусь в формате osm. Данные, полученные от Josm-dom(Rails), служат "подложкой" для комплекса "[Панорама](http://panorama.topgas.by/)" и комплекса "[Мириада](https://gitlab.cloud.gas.by/miriada)". Данные с "подложкой" передаются на сервер области(для комплекса "[Панорама](http://panorama.topgas.by/)", который отображает одну опредёлнную область), на сервер FTP(для комплекса "[Панорама](http://panorama.topgas.by/)", который отображает всю Республику Беларусь) и на сервер VTiles(для приобразования "подложки" формату, поддерживаемому комплексом "[Мириада](https://gitlab.cloud.gas.by/miriada)").
2. На Cервере области крутится josm-gas(Rails),web-модуль комплекса "[Панорама](http://panorama.topgas.by/)" и render. Josm-gas(Rails) необходим для создания/редактирования газовых элементов и создания маршрутов в формате osm. Созданный osm-файл с данными о газовых элементах определённой области отдаётся web-модулю комплекса "[Панорама](http://panorama.topgas.by/)" для последующего отображения. Также все созданные osm-файлы(osm-файл с данными о газовых элементах области, osm-файлы с данными об маршрутах для комплекса "[Мириада](https://gitlab.cloud.gas.by/miriada)") отдаются серверу FTP.
3. На сервере FTP(10.108.220.9) хранятся osm-файлы, полученные от серврера области, в каталоге /home/ftp/. Формирование маршрутов для комплекса "[Панорама](http://panorama.topgas.by/)" осуществляется в каталоге /home/routs/. На сервере FTP работает web-модуль комплекса "[Панорама](http://panorama.topgas.by/)", роль которого заключается в отображении osm-файлов газовых элементов всех областей.
Сформированные маршруты для комплекса "[Мириада](https://gitlab.cloud.gas.by/miriada)" передаются серверу Storage в качестве файлов geojson.zip.
Данные об газовых элементах каждой из областей передаются серверу VTiles в качестве набора из 7-ми osm-файлов.
4. На сервере VTiles(172.20.220.42) работает docker-контейнер картографического
сервера "[TileServer](https://hub.docker.com/r/maptiler/tileserver-gl)". Вышеописанный сервер принимает в качестве входных данных файлы формата mbtiles. Данный формат файлов создаётся на основе файлов формата osm при помощи проекта [osm_to_mbtiles](https://gitlab.cloud.gas.by/panorama/osm_to_mbtiles). При получении "свежих" osm-файлов с газовыми элементами(от сервера FTP), либо с географическими данными Беларуси(от сервера Rails respublic), начинается работа скриптов по генерации mbtiles-файлов и обновлению данными файлами картографического сервера "[TileServer](https://hub.docker.com/r/maptiler/tileserver-gl)".
После вышеописанной части начинается работа скриптов по созданию файлов формата db для комплекса "[Мириада](https://gitlab.cloud.gas.by/miriada)". Файлы формата db формируются скриптами опираясь на данные от  картографического
сервера "[TileServer](https://hub.docker.com/r/maptiler/tileserver-gl)". Отдельно скриптами выполняется обновление точек повреждений для комплекса "[Мириада](https://gitlab.cloud.gas.by/miriada)", скрипты находятся по пути /home/update_gas_dbs/ .
Созданные файлы формата db временно хранятся на сервере VTiles, а после отдаются серверу Storage.
5. Сервер Storage служит для хранения файлов комплекса "[Мириада](https://gitlab.cloud.gas.by/miriada)".
___
*Передача файлов формата osm от сервера области к серверу FTP осуществляется каждую пятницу.*
*Передача файлов формата osm от сервера FTP к серверу VTiles осуществляется каждые выходные.*
*Передача файлов формата geojson от сервера FTP к серверу Storage осуществляется в архиве zip каждые выходные.*
*Передача файлов формата db от сервера VTiles к серверу Storage осуществляется каждые выходные.*
*Передача файлов формата osm от сервера Rails respublic к серверу области/FTP/VTiles осуществляется каждые выходные.*
___
![Image alt](https://github.com/Zhdanovich98/osmconvertor/raw/master/png/diagram.png)
