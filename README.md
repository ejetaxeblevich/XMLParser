<a id="top"></a>

<div align="center">

# XMLParser.lua

***ФАЙЛОВЫЙ LUA-МОДУЛЬ,*** *написанный специально для игры [Ex Machina](https://store.steampowered.com/app/285500/Hard_Truck_Apocalypse__Ex_Machina/)*


***LUA-MODULE FOR FILES,*** *written specifically for the game [Hard Truck Apocalypse](https://store.steampowered.com/app/285500/Hard_Truck_Apocalypse__Ex_Machina/)*

**Lua 5.0**

<img src="exm_xmlparser_demo.jpg" alt="exm_xmlparser_demo_jpg" width="800" />

***

<table>
  <thead>
    <tr>
      <th style="text-align: center;">Содержание</th>
      <th style="text-align: center;">Table of contents (machine translation)</th>
    </tr>
  </thead>
  <tbody align="center">
    <tr>
      <td><a href="#wtf_ru">Краткое описание</a></td>
      <td><a href="#wtf_en">Brief description</a></td>
    </tr>
    <tr>
      <td><a href="#allAboutIt_ru">Все инструкции для моддеров</a></td>
      <td><a href="#allAboutIt_en">All instructions for modders</a></td>
    </tr>
    <tr>
      <td><a href="#allFunctions_ru">Все методы и функции</a></td>
      <td><a href="#allFunctions_en">All methods and functions</a></td>
    </tr>
    <tr>
      <td><a href="#exampleScriptForReading_ru">Пример использования методов</a></td>
      <td><a href="#exampleScriptForReading_en">Example of using methods</a></td>
    </tr>
    <tr>
      <td><a href="#exampleParams_ru">Параметры xml объектов lua-модуля</a></td>
      <td><a href="#exampleParams_en">Parameters of xml objects of the lua-module</a></td>
    </tr>
    <tr>
      <td><a href="#whatIsModuleItems_ru">Xml объекты lua-модуля</a></td>
      <td><a href="#whatIsModuleItems_en">Xml objects of the lua-module</a></td>
    </tr>
    <tr>
      <td><a href="#tipsAndCodeExamples_ru">Советы и примеры скриптов</a></td>
      <td><a href="#tipsAndCodeExamples_en">Tips and examples of scripts</a></td>
    </tr>
    <tr>
      <td><a href="#detailsAndThanks_ru">Подробности и выражение благодарности</a></td>
      <td><a href="#detailsAndThanks_en">Details and gratitude</a></td>
    </tr>
  </tbody>
</table>

</div>

> [!WARNING]
> Этот ReadMe акутален только для `v1.2.2` версии XMLParser и выше!
>
> This ReadMe is relevant only for `v1.2.2` versions of XMLParser and above!

***

<a id="wtf_ru"></a>

## ЧТО ЭТО

Универсальный lua-модуль, который может использоваться для **ЧТЕНИЯ** и **ЗАПИСИ** .xml файлов **через скрипты** любой модификации внутри игры.

Вы сможете прочитать xml дерево, получить значения его объектов и использовать их в игре. Кроме того, здесь имеется, не весть какой, но конструктор, который позволит вам создавать файлы, а затем записывать/читать деревья и объекты внутри них.

### ВОЗМОЖНОСТИ
- **Чтение** - легко узнать ранее недоступную информацию из игровых ресурсов!
- **Запись** - можно редактировать существующие значения в файлах, создавать новые или удалять старые! Вполне реально записать в свой `xml` файл любую информацию, так её хранить и получать в любое время!
- **Крупный список разных функций** - для гибкого и точечного использования модуля!

<a id="allAboutIt_ru"></a><a href="#top">Наверх ↑</a>

### Дисклеймер

АВТОР ЭТОГО ТВОРЕНИЯ ДУМАЕТ, ЧТО ЗНАЕТ, КАК ПРАВИЛЬНО НАЗЫВАТЬ И ИСПОЛЬЗОВАТЬ ВЕЩИ В ПРОГРАММИРОВАНИИ, ПОЭТОМУ ПРОСЬБА ДЛЯ ПРОГРАММИСТОВ ЗДОРОВОГО ЧЕЛОВЕКА - ПОНЯТЬ И ПРОСТИТЬ, ЕСЛИ ЗДЕСЬ ЧТО-ТО(ВСЕ) НЕ ТАК.


АВТОР ПОНИМАЕТ И ПРИНИМАЕТ, ЧТО ВЕСЬ КОД НИЖЕ И ЭТОТ ТЕКСТ НАПИСАН ПЛОХО, НЕПОНЯТНО И ГРОМОЗДКО, ЧТО ДАЖЕ В ЭТОМ ЗАНЯТИИ НЕТ НИ МАЛЕЙШЕГО СМЫСЛА - КАК И СМЫСЛА В ЭТОМ КАПСОМ НАПИСАННОМ ДИСКЛЕЙМЕРЕ.


LUA-МОДУЛЬ РАСПРОСТРАНЯЕТСЯ СВОБОДНО "КАК ЕСТЬ" И ИСПОЛЬЗУЕТСЯ ИГРОЙ EX MACHINA / HARD TRUCK APOCALYPSE ДЛЯ ЧТЕНИЯ, ИЗМЕНЕНИЯ, СОЗДАНИЯ, А ТАКЖЕ УДАЛЕНИЯ(!) ФАЙЛОВ НА ВАШЕМ КОМПЬЮТЕРЕ И МОЖЕТ БЫТЬ ИЗМЕНЕН ЛЮБЫМ ДРУГИМ ПОЛЬЗОВАТЕЛЕМ (МОДДЕРОМ) ВНУТРИ СВОИХ МОДИФИКАЦИЙ И ПРОЧИХ РЕСУРСАХ.

АВТОР НЕ НЕСЕТ ОТВЕТСТВЕННОСТИ ЗА КАКИЕ-ЛИБО ПОСЛЕДСТВИЯ, ПОВЛЕКШИХ ЗА СОБОЙ УЩЕРБ ВО ВРЕМЯ ИСПОЛЬЗОВАНИЯ ЭТОГО, А ТАКЖЕ ЛЮБОЙ ДРУГОЙ, В Т.Ч. ИЗМЕНЕННОЙ ВЕРСИИ LUA-МОДУЛЯ ИЛИ ЧАСТЕЙ КОДА, ПОЗАИМСТВОВАННЫХ (ПЕРЕПИСАННЫХ) ИЗ ЭТОГО ФАЙЛА.


## КАК ЭТО ИСПОЛЬЗОВАТЬ

Почему это "модуль" а не любой другой файл с lua скриптами? Хотя он таким и является...
- Потому что этот файл - таблица функций XMLParser (далее класс), который имеет свои собственные методы и функции, что очень похоже на серьезную тему. Наверное. Типа. Я хз...

### УСТАНОВКА

Для полноценного lua-модуля этой поделке еще далеко, поэтому ее не нужно устанавливать как библиотеку Lua в системе.

В игру этот lua-модуль загружается двумя способами: через `require()` или `dofile()`. Это внутренние Lua команды игры. 
Наш знакомый `EXECUTE_SCRIPT` не подойдет, так как он не возвращает объект модуля.


Чем отличается `require()` от `dofile()`? 


- `require()` загружает файл в игру при первом выполнении и держит в памяти игры до перезапуска. Эта команда используется для подгрузки модулей здорового человека, которые устанавливаются в систему (но необязательно);
- `dofile()` загружает в память игры файл столько раз, сколько был вызван. Очищается весь внутренний кеш lua-модуля и принимаются настройки по умолчанию. Рекомендуется для отладки и прочего дебага.

Рекомендую прописывать команду в конец файла `server.lua` игры, поскольку могут использоваться в модуле команды, которые грузятся в игру чуть раньше сервера ("могут"? автор альцгеймер!).


В качестве аргумента функции указывается локальный путь до файла модуля.


Возвращаемая таблица помещается в глобальную переменную, которая будет использована как объект, на который будут применяться методы (функции) этого модуля через двоеточие. 

Чтобы было понятнее, вспомним как мы обращаемся к машине игрока: 
```lua
local Plv = GetPlayerVehicle()
if Plv then
    Plv:SetSkin(1)  --> метод на объект
end
```
Или к обжект контейнеру:
```lua
local Gde = CVector(1,2,3)
local Gde.y = g_ObjCont:GetHeight(Gde.x, Gde.z)  --> метод на объект
```

### Пример кода загрузки

```lua
XMLParser = require("data\\gamedata\\lua_lib\\xmlparser.lua")
if not XMLParser then
    LOG("[E] Could not find global xmlparser.lua...")
end
```

После загрузки модуля в игру можно инициализировать его работу через метод `init()` (либо другой) для выбора файла. Функция может быть вызвана вновь в любой момент.


## ТЕХНИКА БЕЗОПАСНОСТИ

- ***НАСТОЯТЕЛЬНО РЕКОМЕНДУЕТСЯ*** перед работой ознакомиться с памятками ниже ***[Что такое "дерево"]***, ***[Что такое "объект"]*** и ***[Что такое "поле текста"]*** в понимании этого lua-модуля. *В противном случае гарантия правильной работы говно-парсера аннулируется.*

- **КАТЕГОРИЧЕСКИ ЗАПРЕЩАЕТСЯ** использовать в именах, значениях и прочих ключах следующие символы: `</>"`. А также рекомендуется отказаться от прочих управляющих и неэкранированных уникальных символов: `\\`,`\"`,`'`,`?`,`[`,`]`,`(`,`)`,`.`,`^`,`$`,`*`,`+`,`-`,`%`. *В противном случае гарантия правильной работы говно-парсера аннулируется.*

- **КАТЕГОРИЧЕСКИ ЗАПРЕЩАЕТСЯ** использовать этот lua-модуль на файлах, размещаемых вне игры и модификации! Нет, нельзя! *Только Ex Machina и только модификации к ней!*

- **Запрещается** создавать полностью одинаковые деревья с идентичными тегами и именами, даже внутри разных деревьев. *В противном случае гарантия правильной работы говно-парсера аннулируется.*

- **Следует помнить**, что xml-разметка в файле должна быть "чистой" - соблюдается табуляция у объектов (отступы), отсутствуют ненужные пробелы и управляющие символы. Про правильный xml-синтаксис я напомню вам чисто так, невзначай. *В противном случае гарантия правильной работы говно-парсера аннулируется.*

- Не рекомендуется использовать этот lua-модуль на важных игровых xml файлах, так как в ходе внезапной неправильной работы парсера сломаете игру. *Делайте такие действия с осторожностью, либо проведите тестирование своего скрипта на подопытном файле.*

- Не рекомендуется использовать этот lua-модуль на сложных xml структурах.    

- ***ЗАПРЕЩАЕТСЯ*** использовать этот lua-модуль в своих модах без указания авторства. А то натравлю порчу и наколдую недельный понос 😡 
*Шутка 💋*

<a id="allFunctions_ru"></a><a href="#top">Наверх ↑</a>

## ФУНКЦИИ И МЕТОДЫ

Здесь собраны все публичнные функции этого модуля. У каждой функции имеется детальное описание, что она делает и что в ней указывать.

За время разработки и обновлений тут уже скопилось достаточно много функций разной полезности и уровня яндередева, но тем не менее, некоторые из них всё так же остаются полезными.

> [!IMPORTANT]
> Обратите внимание, что дочерний класс должен вызывать главный метод своего родительского класса вплоть до XMLParser.
>
> Функции для редактирования объектов и деревьев **РАБОТАТЬ НЕ БУДУТ**, если применяются на подобъекты захватываемого дерева. Сначала вам следует сделать дерево-подобъект активным.

> [!TIP]
> Вы можете скроллить код ниже вправо и влево! Наведите курсор на полотно и колесиком мыши с помощью `shift` двигайте его!

```c
Class XMLParser
{
    /* Вывод информации */

    [M] void PrintTable( table Table, any findLOGvalue )
    /* Принтит в лог игры любую таблицу Table в развернутом виде.

       Очень полезно, если вы не знаете, что за table (XMLParser-объект) возвращает XMLParser.

       Укажите значение findLOGvalue для его быстрого поиска по файлу в exmachina.log */

    [M] void LOG( bool )
    /* Принтит всю дебаг информацию, если нужно отследить, что не нравится парсеру или где он ломается.

       Внимание! Принтит ОЧЕНЬ много мусора в лог игры и вызывает НАИСИЛЬНЕЙШУЮ утечку памяти */


    /* Основные функции */

    [M] bool IsFileExists( const char* path_to_file )
    /* Проверяет, существует ли файл по этому пути */

    [M] bool IsFileOpen( file descriptor )
    /* Проверяет, открыт ли файл в памяти по этому дескриптору */

    [M] string ReadFile( const char* path_to_file )
    /* Читает файл и возвращает все его содержимое как одну строку */

    [M] bool&descriptor init( const char* path_to_file, const CStr& root_tag_in_file, const CStr& default_file_content, bool LOG )
    /* Инициализирует "точку входа" парсера в файле, перезатирает ранее установленные параметры парсера.

       bool LOG принтит всю дебаг информацию, если нужно отследить, что не нравится парсеру или где он ломается.
       Внимание! Принтит ОЧЕНЬ много мусора в лог игры и вызывает НАИСИЛЬНЕЙШУЮ утечку памяти */

    [M] bool save()
    /* Сохраняет в файл все изменения, произведенные парсером */

    [M] bool createFile( const char* path, const CStr& default_file_content )
    /* Создает файл и записывает в него базовый контент, указанный в default_file_content или в init().

       По умолчанию это "data\\gamedata\\file_name.xml" */

    [M] bool removeFile()
    /* Удаляет файл, указанный в init().

       По умолчанию это "data\\gamedata\\file_name.xml" */

    [M] void AutoUpdateTree( bool Value )
    /* Включает/отключает автоматическое обновление дерева TREE при каждом вызове дочерних методов TREE */


    /* Универсальные функции */

    [M] string QuickGet( const char* path_to_file, const char* AttrName )
    /* Возвращает значение атрибута из файла.

       Работает быстро, возвращает первое совпадение!
       Не использует кэш и переменные парсера.
       Игнорирует деревья и объекты, пробелы и табуляцию.

       Имеются интерпретации значения:
              [.AsInt]     - возвращает целое число,
              [.AsString]  - возвращает строку,
              [.AsFloat]   - возвращает число с запятой,
              [.AsBoolean] - возвращает логическое значение,
              [.AsRUchars] - возвращает строку с переведенной латиницей на кириллицу,
              [.AsENchars] - возвращает строку с переведенной кириллицей на латиницу */

    [M] bool QuickSet( const char* path_to_file, const char* AttrName, const CStr& AttrValue )
    /* Редактирует значение атрибута в файле.

       Работает быстро, редактирует первое совпадение!
       Не использует кэш и переменные парсера.
       Игнорирует деревья и объекты, пробелы и табуляцию */

    [M] string QuickParseLine( const char* path_to_file, const char* LinePattern )
    /* Возвращает захваченный паттерн строки из файла.

       Ищет построчно до первого совпадения, работает с регулярными выражениями */

    [M] table ReadFromBigfile( const char* path_to_file, const char* ItemTagName, const char* AttributeName, const char* AttributeValue, int SkokaItems, int SkokaDepth )
    /* Возвращает таблицу всех объектов из файла,

       имеющих тег ItemTagName и содержащих атрибут AttributeName со значением AttributeValue,
       их максимальное количество SkokaItems
       и максимальую глубину парсинга SkokaDepth внутрь деревьев.

       Собирает все без конкретики, если аргумент nil.

       Не использует кэш и переменные парсера.

       Работает на стриминговом принципе за один проход, и это максимальная возможная оптимизация и скорость на lua 5.0 у Ex Machina (тест на dynamicscene из currentmap занял 0.25 секунды) */

    [M] bool openQueue( const char* path_to_file )
    /* Открывает очередь для команд ниже (и не только),

       открывает файл и держит его в памяти.

       Пока открыта очередь, команды парсера будут применяться к файлу по этому пути */

    [M] table GetItemFromFile( string FindExample, const char* ItemTagName, const char* ItemRepositoryName )
    /* Возвращает XMLParser-объект из выбранного xml файла, используется без init().

       Не нагружает игру как простое чтение XMLParser через init() у большого файла.
       Очень полезно для чтения огромных файлов (таких как dialogsglobal.xml или currentmap.xml) а также более "шелкового касания" объекта, нежели как это делает автоматически XMLParser,
       однако необходимо уже вручную разбирать возвращаемую таблицу.

       Аргументы:
              FindExample        - образец строки для первичного поиска. Указывается один из атрибутов объекта, например имя: 'name="object_name"';
              ItemTagName        - имя открывающего тега этого объекта;
              ItemRepositoryName - имя открывающего/закрывающего тега дерева, где этот объект находится. */

    [M] bool SetItemValueInFile( string FindExample, const char* ItemTagName, const char* ItemRepositoryName, const char* AttributeName, const char* Pattern, const CStr& AttributeValue )
    /* Изменяет параметр объекта в выбранном xml файле, используется без init().

       Не нагружает игру как простое чтение XMLParser через init() у большого файла.
       Очень полезно для чтения огромных файлов (таких как dialogsglobal.xml или currentmap.xml) а также более "шелкового касания" объекта, нежели как это делает автоматически XMLParser.

       Аргументы:
              FindExample        - образец строки для первичного поиска. Указывается один из атрибутов объекта, например имя: 'name="object_name"';
              ItemTagName        - имя открывающего тега этого объекта;
              ItemRepositoryName - имя открывающего/закрывающего тега дерева, где этот объект находится;
              AttributeName      - имя атрибута;
              Pattern            - что нужно найти и заменить. Если nil, будет весь текст атрибута;
              AttributeValue     - на что нужно заменить. Если nil, будет весь текст атрибута. */

    [M] bool RemoveItemFromFile( string FindExample, const char* ItemTagName, const char* ItemRepositoryName )
    /* Удаляет найденный XMLParser-объект из выбранного xml файла, используется без init().

       Не нагружает игру как простое чтение XMLParser через init() у большого файла.
       Очень полезно для чтения огромных файлов (таких как dialogsglobal.xml или currentmap.xml) а также более "шелкового касания" объекта, нежели как это делает автоматически XMLParser,
       однако необходимо уже вручную разбирать возвращаемую таблицу.

       Аргументы:
              FindExample        - образец строки для первичного поиска. Указывается один из атрибутов объекта, например имя: 'name="object_name"';
              ItemTagName        - имя открывающего тега этого объекта;
              ItemRepositoryName - имя открывающего/закрывающего тега дерева, где этот объект находится. */

    [M] bool closeQueue( table content, file descriptor )
    /* Закрывает очередь для команд выше (и не только),

       закрывает файл и сохраняет изменения в нем.

       Не указывайте аргументы для работы с текущим открытым файлом */


    /* Чтение и редактирование XML */

    Class TREE
    {
        [M] TREE Tree( table treeParams ) : public XMLParser
        /* Это прямое обращение к дереву TREE.

           Используйте [XMLParser:Tree( table treeParams ):init()] перед выполнением команд.
           Во время использования команд аргумент в Tree() не нужен */
        {
            [M] bool init( table new_treeParams )
            /* Обновляет содержимое TREE, захватывает новое дерево если указан new_treeParams */

            [M] bool IsObjectExists( table ObjectTagXorCustomKey, string CustomKeyValue )
            /* Проверяет, существует ли такой объект в дереве: [{"TagName", "Name"}, "bibka"].

               Пользовательские ключи задаются в PARSER.KEYS */

            [M] bool IsTreeExists( table TreeTagXorCustomKey, string CustomKeyValue )
            /* Проверяет, существует ли такое дерево в дереве: [{"TagName", "Name"}, "bibka"].

               Пользовательские ключи задаются в PARSER.KEYS */

            [M] bool CaptureInnerTree( table TreeTagXorCustomKey, string CustomKeyValue )
            /* Помещает найденное дерево внутри дерева в TREE (новое дерево становится активным).

               Пользовательские ключи задаются в PARSER.KEYS */

            [M] bool Add( table itemParams, bool Enters, bool Spaces, table includeKeysForSort )
            /* Добавляет новый item в дерево.

               bool Enters добавляет пробелы (отступы) сверху добавляемых объектов.
               bool Spaces добавляет пробелы (отступы) между значениями добавляемых объектов.

               Сортирует новые ключи параметров сверху вниз, если указаны.
               Сортируемые ключи по умолчанию определяются классом нового элемента */

            [M] bool Remove( table itemParams or "self")
            /* Удаляет item в дереве.

               Укажите аргументом строку "self" для удаления дерева TREE (активного дерева) */

            [M] string GetName()
            /* Возвращает имя тега дерева */

            [M] string GetObjName()
            /* Возвращает Name дерева */

            [M] ??? GetCustomValue()
            /* Возвращает _customValue дерева */

            [M] bool SetParam( const char* ParameterName, const CStr& ParameterValue )
            /* Устанавливает новое значение параметра дерева */

            [M] AIParam GetParam( const char* ParameterName )
            /* Возвращает значение параметра дерева.

               Имеются интерпретации значения:
                        [.AsInt]     - возвращает целое число,
                        [.AsString]  - возвращает строку,
                        [.AsFloat]   - возвращает число с запятой,
                        [.AsBoolean] - возвращает логическое значение,
                        [.AsRUchars] - возвращает строку с переведенной латиницей на кириллицу,
                        [.AsENchars] - возвращает строку с переведенной кириллицей на латиницу */

            [M] int GetParamsAmount()
            /* Возвращает количество параметров дерева */

            [M] bool AddParam( const char* ParameterName, const CStr& ParameterValue, bool Spaces )
            /* Добавляет новый параметр дерева.

               bool Spaces добавляет пробелы (отступы) между значениями добавляемого параметра */

            [M] bool RemoveParam( const char* ParameterName )
            /* Удаляет параметр дерева */

            [M] table GetObjectByCustomKey( string CustomKey )
            /* Возвращает первый найденный объект дерева по пользовательскому параметру.

               Пользовательские ключи задаются в PARSER.KEYS */

            [M] table GetObjectByName( const char* ItemObjName )
            /* Возвращает первый найденный объект дерева по Name */

            [M] table GetObjectById( const int* Id )
            /* Возвращает первое найденный объект дерева по айди */

            [M] table GetObject( const char* ItemName )
            /* Возвращает первый найденный объект дерева по тегу */

            [M] table GetTreeByCustomKey( string CustomKey )
            /* Возвращает первое найденное дерево по пользовательскому параметру.

               Пользовательские ключи задаются в PARSER.KEYS */

            [M] table GetTreeByName( const char* TreeObjName )
            /* Возвращает первое найденное дерево по Name внутри дерева */

            [M] table GetTreeById( const int* Id )
            /* Возвращает первое найденное дерево по айди внутри дерева */

            [M] table GetTree( const char* TreeName )
            /* Возвращает первое найденное дерево по тегу внутри дерева */

            [M] int GetItemsAmount()
            /* Возвращает количество items дерева */

            [M] int GetChildsAmount()
            /* Возвращает количество подобъектов дерева */

            [M] table GetParams()
            /* Возвращает все параметры дерева */

            [M] table GetItems()
            /* Возвращает все items дерева */

            [M] table GetChilds()
            /* Возвращает все items дерева, имеющие подобъекты внутри себя */

            [M] bool Wrap()
            /* Сворачивает выбранное дерево */

            [M] bool Unwrap()
            /* Разворачивает выбранное дерево */

            [M] bool WrapAllItems()
            /* Сворачивает все items дерева */

            [M] bool UnwrapAllItems()
            /* Разворачивает все items дерева */

            [M] bool AddEnters()
            /* Добавляет отступы между элементами, если нет */

            [M] bool CleanEnters()
            /* Убирает отступы между элементами, если есть */

            [M] string AddAsTextField( const table* fieldParams, string TextFieldValue, bool Enters )
            /* Добавляет fieldParams дерево как поле текста со значением TextFieldValue.

               Делает отступы если Enters = true */

            [M] string ReadAsTextField( const table* fieldParams, bool CutTabs )
            /* Возвращает содержимое между тегами дерева, ищет по fieldParams.

               удаляет табуляцию в возвращаемом значении, если CutTabs = true */

            [M] string EditAsTextField( const table* fieldParams, string TextFieldNewValue )
            /* Редактирует fieldParams дерево как поле текста с новым значением TextFieldNewValue */


            Class OBJ
            {
                [M] OBJ GetObj( table ObjectTagXorCustomKey, string CustomKeyValue ) : public TREE
                /* Это прямое обращение к объекту OBJ: [{"TagName", "Name"}, "bibka"].

                   Пользовательские ключи задаются в PARSER.KEYS */
                {
                    [M] string GetName()
                    /* Возвращает имя тега объекта */

                    [M] string GetObjName()
                    /* Возвращает Name объекта */

                    [M] AIParam GetProperty( const char* PropertyName )
                    /* Возвращает значение параметра объекта.

                       Имеются интерпретации значения:
                               [.AsInt]     - возвращает целое число,
                               [.AsString]  - возвращает строку,
                               [.AsFloat]   - возвращает число с запятой,
                               [.AsBoolean] - возвращает логическое значение,
                               [.AsRUchars] - возвращает строку с переведенной латиницей на кириллицу,
                               [.AsENchars] - возвращает строку с переведенной кириллицей на латиницу */

                    [M] table GetProperties()
                    /* Возвращает все параметры объекта */

                    [M] bool SetProperty( const char* PropertyName, const CStr& PropertyValue )
                    /* Устанавливает новое значение параметра объекта */

                    [M] bool AddProperty( const char* PropertyName, const CStr& PropertyValue, bool Spaces )
                    /* Добавляет новый параметр объекта.

                       bool Spaces добавляет пробелы (отступы) между значениями добавляемого параметра */

                    [M] bool RemoveProperty( const char* PropertyName )
                    /* Удаляет параметр объекта */

                    [M] string GetParentName()
                    /* Возвращает имя тега родительского дерева */

                    [M] bool Wrap()
                    /* Сворачивает выбранный объект */

                    [M] bool Unwrap()
                    /* Разворачивает выбранный объект */
                }
            }
        }
    }


    /* Сервисные функции. По возможности не используйте */

    [M] void clearCache()
    /* Сбрасывает глобальные переменные парсера в настройки по умолчанию.

       После этого необходимо снова инициализировать парсер через init() */

    [M] table getCache()
    /* Возвращает все глобальные переменные парсера.

       Индексы переменных можно посмотреть в логе игры, если включен bool LOG в init() */

    [M] void ConvertPropertiesIn( const char* InputPATH, const char* OutputPATH )
    /* Конвертирует значения объектов из файла (dynamicscene, world)
       в удобные варианты копирования для скриптов в файл OutputPATH,
       иначе в корень как func_ConvertPropertiesIn.xml.

       Примеры:
              rot="0.0004 0.9786 -0.2058 0.0021" --> rot="Quaternion(0.0004, 0.9786, -0.2058, 0.0021)";
              Pos="326.145 436.152 2804.116"     --> Pos="CVector(326.145, 436.152, 2804.116)" */

    [M] AIParam ReadBinary( const char* path_to_file )
    /* Читает бинарные файлы.

       Возвращает размер файла в байтах, килобайтах и мегабайтах.
              [.AsHex] - возвращает Hex-содержимое файла,
              [.AsASCII] - возвращает ASCII-содержимое файла */

    [M] bool AddCommentNearItem( string comment, table itemParams )
    /* Добавляет комментарий над элементом.

       Используйте [XMLParser:Tree( table treeParams ):init()] перед выполнением команды */

    [M] string GetLineWithContent( int line, string Content )
    /* Возвращает строку и ее номер из файла,
       ищет первое совпадение по Content, если указан (поддержка регулярных выражений).

       Используйте [XMLParser:Tree( table treeParams ):init()] перед выполнением команды */

    [M] tuple RemoveLineWithContent( int line, string Content )
    /* Удаляет строку в файле (Осторожно! Можно сломать разметку файла!).

       Возвращает истину, номер строки и само значение строки, в противном случае nil.
       Ищет первое совпадение по Content, если указан (поддержка регулярных выражений).

       Используйте [XMLParser:Tree( table treeParams ):init()] перед выполнением команды */

    [M] bool addTree( table treeParams, table put_inParams, table includeKeysForSort )
    /* Добавляет xml дерево в дерево table put_inParams, иначе в корень.

       Сортирует новые ключи параметров сверху вниз, если указаны.
       Сортируемые ключи сверху вниз по умолчанию: "id", "Id", "ObjectId", "Name", "name", "Amount", "Maximum", "Description" */

    [M] bool addObject( table objectParams, table put_inParams, table includeKeysForSort)
    /* Добавляет xml объект в дерево put_inParams, иначе в корень.

       Сортирует новые ключи параметров сверху вниз, если указаны.
       Сортируемые ключи сверху вниз по умолчанию: "id", "Id", "ObjectId", "Name", "name", "Value", "ListOfItems", "Chassis", "Cabin", "Cargo", "Skin", "ListOfGuns", "Name", "Status", "Item", "Description", "Difficulty", "Done" */

    [M] bool removeTree( table treeParams )
    /* Удаляет xml дерево */

    [M] bool removeObject( table treeParams, table objectParams )
    /* Удаляет xml объект в дереве */

    [M] string Wrap( table objectParams )
    /* Возвращает свернутый item */

    [M] table Unwrap( table objectParams )
    /* Возвращает развернутый item */

    [M] tuple getTree( const table* treeParams, const char* put_in )
    /* Возвращает все найденные параметры, items и все childs дерева,
       сложенного в put_in,
       иначе найдет первое вхождение или nil */

    [M] table getItemFromLine( const table* content, const int* Line, const CStr& parentName, const char* parentTabs )
    /* Возвращает найденный item из content,
       все его параметры и все вложенные дочерние item и их параметры,
       начиная с номера строки Line.

       Ищет закрывающий тег parentName вместе с parentTabs.
       Громоздкая и рекурсивная функция, дающая памяти игры утечь куда глаза глядят, если xml конструкция достаточно сложная */

    [M] string getItemClass( const table* content, const int* curLine )
    /* Проверяет item из content, под номером строки curLine
       и возвращает его класс: "tree", "object" */

    [M] table GetTagAndCustomKeyFromItem( const table* itemParams )
    /* Возвращает имя тега и пользовательский параметр item.

       Пользовательские ключи задаются в PARSER.KEYS */

    [M] string GetItemCustomKey( const table* itemParams, const table* keys )
    /* Возвращает ключ объекта и его значение.

       Берет table keys из PARSER.KEYS_SearchingGradient если nil. */


    /* Экспериментальная ветка скриптов. Позволяет управлять триггерами других карт */

    Class TRIGGER
    {
        [M] TRIGGER trigger( string TriggerName ) : public XMLParser
        /* Это прямое обращение к триггеру TRIGGER.

           Используйте [XMLParser:init()] перед выполнением команд */
        {
            [M] bool Add( int Active, table Events, table Script)
            /* Добавляет триггер с именем TriggerName, ивентами Events и скриптом Script.

               Events и Script это таблицы, содержащие отдельные строки, где каждая строка это строка скрипта/объекта ивента */

            [M] bool Remove()
            /* Удаляет триггер с именем TriggerName */

            [M] bool DoScript()
            /* Безопасно выполняет скрипт триггера.

               Возвращает вторым значением ошибку в противном случае.
               Глобальные игровые методы trigger недоступны - пожалуйста, откажитесь от методов или переопределяйте trigger внутри скрипта триггера, чтобы DoScript() выполнился корректно.
               В противном случае в скрипте триггера есть ошибка.
               Помните, что манипулирование объектами на других картах извне невозможно */

            [M] bool IsActive()
            /* Возвращает состояние триггера */

            [M] bool SetActive( bool Active )
            /* Назначает состояние триггера */

            [M] string GetBody()
            /* Возвращает скрипт триггера как строку */

            [M] table GetScript()
            /* Возвращает скрипт триггера как строковую таблицу */

            [M] string GetScriptByLine( int Line )
            /* Возвращает строку скрипта триггера по номеру строки (относительно) */

            [M] int GetLineByScriptContent( string Content )
            /* Возвращает номер строки скрипта триггера по содержимому строки (относительно) */

            [M] bool ReplaceScript( string NewScript )
            /* Заменяет скрипт триггера новым скриптом [[]] */

            [M] bool AddScript( string Script, int Line )
            /* Добавляет новую часть скрипта в триггер с позицией Line, иначе в конец триггера */

            [M] void RemoveScript()
            /* Удаляет скрипт триггера */

            [M] bool RemoveScriptLine( int Line or string Content )
            /* Удаляет строку скрипта триггера по номеру строки или по содержимому (относительно) */

            [M] table GetAllEvents()
            /* Возвращает все ивенты триггера.

               Ключами ивентов могут быть:
                   [eventid]
                   [timeout]
                   [ObjName]
                   [msgid]
                   [flypath] */

            [M] event[table] GetEventById( const char* EventId )
            /* Возвращает ивент триггера по имени eventid.

               Ключами ивентов могут быть:
                   [eventid]
                   [timeout]
                   [ObjName]
                   [msgid]
                   [flypath] */

            [M] event[table] GetEventByKey( const char* EventKey, string EventValue )
            /* Возвращает ивент триггера по ключу ивента и его значению.

               Ключами ивентов могут быть:
                   [eventid]
                   [timeout]
                   [ObjName]
                   [msgid]
                   [flypath] */

            [M] bool AddEvent( table event )
            /* Добавляет новый ивент в триггер.

               Ключами ивентов могут быть:
                   [eventid]
                   [timeout]
                   [ObjName]
                   [msgid]
                   [flypath] */

            [M] bool RemoveEvent( table event )
            /* Удаляет ивент из триггера.

               Ключами ивентов могут быть:
                   [eventid]
                   [timeout]
                   [ObjName]
                   [msgid]
                   [flypath] */
        }
    }
}
```

<a id="exampleScriptForReading_ru"></a><a href="#top">Наверх ↑</a>

### Пример использования методов

```lua
if XMLParser then       --> Получаем объект парсера lua-модуля, загруженного с помощью кода выше
    local success, file = XMLParser:init('data\\gamedata\\my_xml_file.xml', "RootTagName", nil, false)   --> Инициализируем точку входа парсера в файл с заданным корневым тегом "RootTagName" или любым другим желаемым - "указатель" парсера захватит желаемое дерево
    if success then
        println("file exists")
        local tree = XMLParser:Tree({"Repository", "My Items"}):init()   --> Инициализируем дерево с тегом "Repository" и параметром имени "My Items" внутри "RootTagName"
        if tree then     --> Проверяем, существует ли такое дерево в файле
            println("tree exists")
            local getTree = XMLParser:Tree()                     --> Добавляем дерево в локальную переменную
            local getItem = getTree:GetObj({"Item", "Item01"})   --> Пытаемся получить объект с тегом "Item" и именем "Item01" в этом дереве
            if getItem then      --> Проверяем, существует ли такой объект
                println("item exists")
                local getItemParameter = getItem:GetProperty("MyParameterName").AsString        --> Пытаемся получить параметр "MyParameterName" этого объекта в виде строки
                println("parameter value: "..tostring(getItemParameter))        --> Принт значения этого параметра в консоль
            end
        end
        file:close()     --> Вручную закрываем файл, так как мы только узнали оттуда информацию и ничего не изменили. Не закрыть файл нельзя - он будет оставаться в памяти игры и другие программы не смогут получить к нему доступ. Если бы меняли, использовали бы [XMLParser:save()] - он и сохранит и закроет файл
    end
end
```

<a id="exampleParams_ru"></a><a href="#top">Наверх ↑</a>

## ОБРАЗЕЦ Params ДЕРЕВА/ОБЪЕКТА

```lua
local itemParams = {                /* Это таблица с ключами */
    _itemClass = "tree",           --> Обязательный параметр. _itemClass задает сущность item. "tree" - для дерева, "object" - для объекта.
    _itemTag = "TreeExample",      --> Обязательный параметр. _itemTag задает имя открывающего тега item (и закрывающего для дерева).
    Name = "Example"               --> Необязательный, но очень рекомендуемый параметр. Ключевое значение, такое как (Name, name, ObjectId, Id, id) задает имя item внутри тегов. Незаменим для правильного поиска среди одинаковых тегов у объектов.
}                                   --> Ниже могут быть любые другие параметры без нижнего подчеркивания. Название параметра может быть любым буквенным ключом, значение параметра - строка.
```
```lua
local treeParams = {
    _itemClass = "tree",
    _itemTag = "TreeExample",
    Name = "Example",
    Param1 = "6",
    Param2 = "true",
    Description = "jopa",
}

local objectParams = {
    _itemClass = "object",
    _itemTag = "Object",
    ObjectId = "627",
    Description = "huy",
    Param3 = "true",
    Param4 = "value",
}
```

<a id="whatIsModuleItems_ru"></a><a href="#top">Наверх ↑</a>

## Что такое "дерево"

Class TREE команды.

```xml
<RootTree>      --> Открывающий тег
</RootTree>     --> Закрывающий тег
```
```xml
<TreeExample Name="Tree">
</TreeExample>

<Repository
    Name="Пример"
    Description="I am a tree">
</Repository>

<Aboba>       --> Плохой пример дерева без уникального параметра имени или айди
</Aboba>
```

## Что такое "поле текста"

Class TREE команды.

```xml
<Key>           --> Открывающий тег
</Key>          --> Закрывающий тег
```
```xml
<Key Name="Field">64</Key>

<Text Name="Текст">Первая строка текста
    Вторая строка текста
</Text>

<Key>       --> Плохой пример поля без уникального параметра имени или айди
</Key>
```

## Что такое "объект"

Class OBJ команды.

```xml
<Ware                 --> Открывающий тег   
    Name="Картошка"                         
/>                    --> Закрывающий флажок (тег)
```
```xml
<Item Id="666" Value="true" />              --> Объект 1
<Object Value="3" />                        --> Объект 2
<Entity Name="Параметр2" Value="false" />   --> Объект 3

<Ending                           
    Name="Спасибо за игру!"       
    Description="Complete game" />

<Object />       --> Плохой пример
```

## Пример `example_content` для `init`

```lua
local example_content = '<?xml version="1.0" encoding="windows-1251" standalone="yes" ?>\n<Root>\n<!-- здесь ваши данные -->\n</Root>'
```

<a id="tipsAndCodeExamples_ru"></a><a href="#top">Наверх ↑</a>

## СОВЕТЫ

- Если вы читаете **небольшие файлы**, можете использовать образец выше с `XMLParser:init()`. Его легко контролировать и проводить всякие проверки.

- Если вы хотите **узнать информацию из огромных файлов**, например, получить множество объектов из файла сохранения, стоит использовать `ReadFromBigfile()`.

- Если вы читаете **большие файлы, но хотите их редактировать**, настоятельно рекомендую рассмотреть вариант с "очередью": `openQueue()` и `closeQueue()`. Он будет наиболее "оптимизированным" вариантом, который лучше справляется с большими файлами - игра заметно меньше страдает. Этот вариант сложнее поддается на проверки.


Приведу несколько готовых скриптов-примеров:

### Получим XMLParser-объект игрока из сохранения и отдельно запишем ему новое значение денег
```lua
local path_to_savefile = 'data\\profiles\\Player\\saves\\00000000\\maps\\currentmap.xml'
XMLParser:openQueue( path_to_savefile )
local PLAYER = XMLParser:GetItemFromFile('Name%s*=%s*"Player1"', "Object", "DynamicScene")
XMLParser:SetItemValueInFile('Name%s*=%s*"Player1"', "Object", "DynamicScene", 'Money', '%d*', '99999999')
XMLParser:closeQueue()
```
### Изменим текст некоторых реплик из dialogsglobal.xml
```lua
local path_to_dialogsglobal = 'data\\if\\diz\\dialogsglobal.xml'
XMLParser:openQueue( path_to_dialogsglobal )
XMLParser:SetItemValueInFile('name%s*=%s*"Man_dlg0_1"', "Reply", "DialogsResource", "text", "текст для замены", "этот текст был заменен")
XMLParser:SetItemValueInFile('name%s*=%s*"Man_dlg0_2"', "Reply", "DialogsResource", "text", "текст для замены", "этот текст был заменен")
XMLParser:SetItemValueInFile('name%s*=%s*"Man_dlg1_1"', "Reply", "DialogsResource", "text", "текст для замены", "этот текст был заменен")
XMLParser:SetItemValueInFile('name%s*=%s*"Man_dlg2_3"', "Reply", "DialogsResource", "text", "текст для замены", "этот текст был заменен")
XMLParser:SetItemValueInFile('name%s*=%s*"Man_dlg2_4"', "Reply", "DialogsResource", "text", "текст для замены", "этот текст был заменен")
XMLParser:SetItemValueInFile('name%s*=%s*"Man_dlg3_0"', "Reply", "DialogsResource", "text", "текст для замены", "этот текст был заменен")
XMLParser:SetItemValueInFile('name%s*=%s*"Man_dlg4_3"', "Reply", "DialogsResource", "text", "текст для замены", "этот текст был заменен")
XMLParser:closeQueue()
if RepliesManager then
    RepliesManager:Init()
end
```
### Найдем и удалим все ненужные объекты из world.xml
```lua
local path_to_world = 'data\\maps\\r1m1\\world.xml'
local tag = "Node"
local folder = "World"
local example = 'id%s*=%s*"big_stone4"'
XMLParser:openQueue( path_to_world )
local item = XMLParser:GetItemFromFile(example, tag, folder)
if item then
    repeat
        item = XMLParser:RemoveItemFromFile(example, tag, folder)
    until not item
end
XMLParser:closeQueue()
```
### Получим XMLParser-объект *ВСЕЙ* dynamicscene из сохранения
```lua
local dynamicscene = XMLParser:ReadFromBigfile('data\\profiles\\Player\\saves\\00000066\\maps\\currentmap.xml', "DynamicScene", nil, nil, nil, nil)
```

<a id="detailsAndThanks_ru"></a><a href="#top">Наверх ↑</a>

## ПОДРОБНЕЕ

Эту и другую информацию вы сможете найти в файле проекта или найти примеры работы парсера в моде ExplorerMod от того же автора.

Как расшифровать таблицу `table` и небольшие пояснения можно узнать [здесь](https://github.com/ejetaxeblevich/XMLParser/blob/main/helpinfo.md).


## КОММЕНТАРИИ АВТОРА

    E Jet: Это заколдованный парсер в котором хочется срать.

Благодарность [stakanyash](https://github.com/stakanyash) за идею скрипта захвата атрибутов!

<a href="#top">Наверх ↑</a>

----

----

<a id="wtf_en"></a>

## WHAT IS IT

A universal lua module that can be used to **READ** and **WRITE** .xml files **through scripts** of any modification inside the game.

You can read the xml tree, get the values of its objects and use them in the game. In addition, there is, I don't know what, but a constructor that will allow you to create files, and then write/read trees and objects inside them.

### FEATURES
- **Reading** - It's easy to learn previously unavailable information from game resources!
- **Record** - you can edit existing values in files, create new ones or delete old ones! It is quite realistic to write any information into your xml file, so it can be stored and received at any time!
- **Large list of different functions** - for flexible and point-to-point use of the module!

<a id="allAboutIt_en"></a><a href="#top">Go up ↑</a>

### Disclaimer

THE AUTHOR OF THIS CREATION THINKS HE KNOWS HOW TO PROPERLY NAME AND USE THINGS IN PROGRAMMING, SO A REQUEST FOR HEALTHY PROGRAMMERS IS TO UNDERSTAND AND FORGIVE IF THERE IS SOMETHING (EVERYTHING) HERE NOT LIKE THAT.


THE AUTHOR UNDERSTANDS AND ACCEPTS THAT ALL THE CODE BELOW AND THIS TEXT IS POORLY WRITTEN, INCOMPREHENSIBLE AND CUMBERSOME, THAT EVEN THIS LESSON DOES NOT MAKE THE SLIGHTEST SENSE - AS WELL AS THE MEANING IN THIS CAPSULE DISCLAIMER.


THE LUA MODULE IS FREELY DISTRIBUTED "AS IS" AND IS USED BY THE GAME EX MACHINA / HARD TRUCK APOCALYPSE TO READ, MODIFY, CREATE, AND DELETE (!) FILES ON YOUR COMPUTER AND CAN BE MODIFIED BY ANY OTHER USER (MODDER) INSIDE THEIR OWN MODIFICATIONS AND OTHER RESOURCES.

THE AUTHOR IS NOT RESPONSIBLE FOR ANY CONSEQUENCES RESULTING IN DAMAGE DURING THE USE OF THIS, AS WELL AS ANY OTHER, INCLUDING MODIFIED VERSIONS OF THE LUA MODULE OR PARTS OF THE CODE BORROWED (REWRITTEN) FROM THIS FILE.


## HOW TO USE IT

Why is this a "module" and not any other lua script file? Although it is...
- Because this file is an XMLParser function table (hereinafter referred to as the class), which has its own methods and functions, which is very similar to a serious topic. Probably. Like. I don't know...

### INSTALLATION

This craft is still far from being a full-fledged lua module, so it does not need to be installed as a Lua library in the system.

This lua module is loaded into the game in two ways: via `require()` or `dofile()`. These are the internal Lua commands of the game. 
Our familiar `EXECUTE_SCRIPT` won't do, as it doesn't return a module object.


What is the difference between `require()` and `dofile()`? 


- `require()` loads the file into the game at the first execution and holds it in the game's memory until restarting. This command is used to load modules of a healthy person, which are installed into the system (but not necessarily);
- `dofile()` loads a file into the game's memory as many times as it was called. The entire internal cache of the lua module is cleared and the default settings are accepted. It is recommended for debugging and other debugging.

I recommend writing the command at the end of the `server.lua` file of the game, since commands that are loaded into the game a little earlier than the server can be used in the module ("can"? the author is Alzheimer's!).


The local path to the module file is specified as the function argument.


The returned table is placed in a global variable, which will be used as an object to which the methods (functions) of this module will be applied separated by a colon. 

To make it clearer, let's recall how we refer to the player's vehicle:
```lua
local Plv = GetPlayerVehicle()
if Plv then
    Plv:SetSkin(1)  --> method per object
end
```
Or object container:
```lua
local Gde = CVector(1,2,3)
local Gde.y = g_ObjCont:GetHeight(Gde.x, Gde.z)  --> method per object
```

### Sample load code

```lua
XMLParser = require("data\\gamedata\\lua_lib\\xmlparser.lua")
if not XMLParser then
    LOG("[E] Could not find global xmlparser.lua...")
end
```

After loading the module into the game, you can initialize its operation using the `init()` method (or another one) to select a file. The function can be called again at any time.


## SAFETY PRECAUTIONS

- ***STRONGLY RECOMMENDED*** to read the notes below before working ***[What is a "tree"]***, ***[ What is an "object"]*** and ***[What is a "text field"]*** in understanding this the lua module. *Otherwise, the guarantee of the correct operation of the shit parser is canceled.*

- **STRICTLY FORBIDDEN** to use the following characters in names, values and other keys: `</>"`. It is also recommended to discard other control and unshielded unique characters: `\\`,`\"`,`'`,`?`,`[`,`]`,`(`,`)`,`.`,`^`,`$`,`*`,`+`,`-`,`%`. *Otherwise, the guarantee of the correct operation of the shit parser is canceled.*

- **STRICTLY FORBIDDEN** to use this lua module on files hosted outside the game and modification! No, you can't! *Only Ex Machina and only modifications to it!*

- **Forbidden** to create completely identical trees with identical tags and names, even inside different trees. *Otherwise, the guarantee of the correct operation of the shit parser is canceled.*

- **It should be remembered** that the xml markup in the file must be "clean" - the tabs of objects (indents) are observed, unnecessary spaces and control characters are missing. I'll remind you about the correct xml syntax just by chance. *Otherwise, the guarantee of the correct operation of the shit parser is canceled.*

- It is not recommended to use this lua module on important game xml files, as you will break the game if the parser suddenly malfunctions. *Do this with caution, or test your script on a test file.*

- It is not recommended to use this lua module on complex xml structures. 

- ***FORBIDDEN*** to use this lua module in your mods without attribution. Otherwise, I'll set off a spell and conjure up a week's diarrhea. 
*A joke 💋*

<a id="allFunctions_en"></a><a href="#top">Go up ↑</a>

## FUNCTIONS AND METHODS

All the public functions of this module are collected here. Each function has a detailed description of what it does and what to specify in it.

During the development and updates, there have already accumulated quite a lot of functions of different usefulness and level of yanderedev, but nevertheless, some of them still remain useful.

> [!IMPORTANT]
> That the child class must call the main method of its parent class up to XMLParser.
>
> Functions for editing objects and trees **WILL NOT WORK** if they are applied to subobjects of the captured tree. First, you should make the tree-subobject active.

> [!TIP]
> You can scroll the code below to the right and left! Hover the cursor over the canvas and use the mouse wheel to move it using `shift`!

```c
Class XMLParser
{
    /* Information output */

    [M] void PrintTable( table Table, any findLOGvalue )
    /* Prints any Table in the expanded form into the game log.

       It is very useful if you do not know what kind of table (XMLParser object) the XMLParser returns.

       Specify the findLOGvalue value for quick file search in exmachina.log */

    [M] void LOG( bool )
    /* Prints all the debug information if you need to track down what the parser doesn't like or where it breaks.

       Attention! Prints a lot of garbage into the game log and causes a MASSIVE memory leak */


    /* Main functions */

    [M] bool IsFileExists( const char* path_to_file )
    /* Checks if a file exists in this path */

    [M] bool IsFileOpen( file descriptor )
    /* Checks whether a file is open in memory using this descriptor */

    [M] string ReadFile( const char* path_to_file )
    /* Reads the file and returns all its contents as a single line */

    [M] bool&descriptor init( const char* path_to_file, const CStr& root_tag_in_file, const CStr& default_file_content, bool LOG )
    /* Initializes the "entry point" of the parser in the file, repeats the previously set parameters of the parser.

       bool LOG prints all debug information if you need to track down what the parser doesn't like or where it breaks.
       Attention! Prints a lot of garbage into the game log and causes a MASSIVE memory leak. */

    [M] bool save()
    /* Saves all changes made by the parser to a file */

    [M] bool createFile( const char* path, const CStr& default_file_content )
    /* Creates a file and writes the base content specified in default_file_content or init() to it.

       By default, this is "data\\gamedata\\file_name.xml" */

    [M] bool removeFile()
    /* Deletes the file specified in init().

       By default, this is "data\\gamedata\\file_name.xml" */

    [M] void AutoUpdateTree( bool Value )
    /* Enables/disables automatic updating of the TREE tree every time child TREE methods are called */


    /* Universal functions */

    [M] string QuickGet( const char* path_to_file, const char* AttrName )
    /* Returns the attribute value from a file.

       It works fast, returns the first match!
       It does not use the cache and parser variables.
       Ignores trees and objects, spaces and tabs.

       There are interpretations of the meaning:
              [.AsInt]     - returns a integer,
              [.AsString]  - returns a string,
              [.AsFloat]   - returns a number with a comma,
              [.AsBoolean] - returns a boolean value,
              [.AsRUchars] - returns a string with the Latin alphabet translated into Cyrillic,
              [.AsENchars] - returns a string from translated Cyrillic to Latin */

    [M] bool QuickSet( const char* path_to_file, const char* AttrName, const CStr& AttrValue )
    /* Edits the attribute value in the file.

       Works fast, edits the first match!
       It does not use the cache and parser variables.
       Ignores trees and objects, spaces and tabs */

    [M] string QuickParseLine( const char* path_to_file, const char* LinePattern )
    /* Returns the captured string pattern from the file.

       Searches line by line up to the first match, works with regular expressions */

    [M] table ReadFromBigfile( const char* path_to_file, const char* ItemTagName, const char* AttributeName, const char* AttributeValue, int SkokaItems, int SkokaDepth )
    /* Returns a table of all objects from a file,

       having the ItemTagName tag and containing the attributeName attribute with the AttributeValue value,
       their maximum number is SkokaItems
       and the maximum depth of SkokaDepth parsing inside the trees.

       Collects everything without specifics if the argument is nil.

       It does not use the cache and parser variables.

       It works on the streaming principle in one pass, and this is the maximum possible optimization and speed on lua 5.0 from Ex Machina (the dynamicscene test from currentmap took 0.25 seconds) */

    [M] bool openQueue( const char* path_to_file )
    /* Opens a queue for the commands below (and beyond),

       opens the file and holds it in memory.

       While the queue is open, the parser commands will be applied to the file along this path */

    [M] table GetItemFromFile( string FindExample, const char* ItemTagName, const char* ItemRepositoryName )
    /* Returns an XMLParser object from the selected xml file, used without init().

       It doesn't load the game like just reading XMLParser via init() from a large file.
       Very useful for reading huge files (such as dialogsglobal.xml or currentmap.xml ) and also a more "silk touch" of the object, rather than how the XMLParser does it automatically.,
       however, it is necessary to manually disassemble the returned table.

       Arguments:
              FindExample        - string for the primary search. One of the object's attributes is specified, for example, the name: 'name="object_name"';
              ItemTagName        - name of the opening tag of this object.;
              ItemRepositoryName - name of the opening/closing tag of the tree where this object is located. */

    [M] bool SetItemValueInFile( string FindExample, const char* ItemTagName, const char* ItemRepositoryName, const char* AttributeName, const char* Pattern, const CStr& AttributeValue )
    /* Modifies the object parameter in the selected xml file, used without init().

       It doesn't load the game like simply reading XMLParser via init() from a large file.
       Very useful for reading huge files (such as dialogsglobal.xml or currentmap.xml) and also a more "silk touch" of the object, rather than how the XMLParser does it automatically.

       Arguments:
              FindExample        - sample string for the primary search. One of the object's attributes is specified, for example, the name: 'name="object_name"';
              ItemTagName        - name of the opening tag of this object;
              ItemRepositoryName - name of the opening/closing tag of the tree where this object is located;
              attributeName      - attribute name;
              Pattern            - what needs to be found and replaced. If nil, the entire attribute text will be displayed;
              AttributeValue     - what needs to be replaced with. If nil, the entire attribute text will be displayed. */

    [M] bool RemoveItemFromFile( string FindExample, const char* ItemTagName, const char* ItemRepositoryName )
    /* Deletes the found XMLParser object from the selected xml file, used without init().

       It doesn't load the game like just reading XMLParser via init() from a large file.
       Very useful for reading huge files (such as dialogsglobal.xml or currentmap.xml) and also a more "silk touch" of the object, rather than how the XMLParser does it automatically.,
       however, it is necessary to manually disassemble the returned table.

       Arguments:
              FindExample        - sample string for the primary search. One of the object's attributes is specified, for example, the name: 'name="object_name"';
              ItemTagName        - name of the opening tag of this object;
              ItemRepositoryName - name of the opening/closing tag of the tree where this object is located. */

    [M] bool closeQueue( table content, file descriptor )
    /* Closes the queue for higher commands (and beyond),

       closes the file and saves the changes in it.

       Do not specify arguments for working with the currently open file */


    /* Reading and editing XML */

    Class TREE
    {
        [M] TREE Tree( table treeParams ) : public XMLParser
        /* This is a direct reference to the tree TREE.

           Use [XMLParser:Tree( table treeParams):init()] before executing commands.
           When using commands, the argument in Tree() is not needed */
        {
            [M] bool init( table new_treeParams )
            /* Updates the contents of the TREE, captures a new tree if new_treeParams is specified */

            [M] bool IsObjectExists( table ObjectTagXorCustomKey, string CustomKeyValue )
            /* Checks if such an object exists in the tree: [{"TagName", "Name"}, "bibka"].

               User keys are set in PARSER.KEYS */

            [M] bool IsTreeExists( table TreeTagXorCustomKey, string CustomKeyValue )
            /* Checks if such a tree exists in the tree: [{"TagName", "Name"}, "bibka"].

               User keys are set in PARSER.KEYS */

            [M] bool CaptureInnerTree( table TreeTagXorCustomKey, string CustomKeyValue )
            /* Places the found tree inside the tree in the TREE (the new tree becomes active).

               User keys are set in PARSER.KEYS */

            [M] bool Add( table itemParams, bool Enters, bool Spaces, table includeKeysForSort )
            /* Adds a new item to the tree.

               bool Enterers adds spaces (indents) on top of the objects being added.
               bool Spaces adds spaces (indents) between the values of the objects being added.

               Sorts new parameter keys from top to bottom, if specified.
               Sortable keys are determined by default by the class of the new element */

            [M] bool Remove( table itemParams or "self")
            /* Deletes an item in the tree.

               Specify the string "self" as an argument to delete the TREE TREE (active tree) */

            [M] string GetName()
            /* Returns the name of the tree tag */

            [M] string GetObjName()
            /* Returns the name of the tree */

            [M] ??? GetCustomValue()
            /* Returns the _customValue of the tree */

            [M] bool SetParam( const char* ParameterName, const CStr& ParameterValue )
            /* Sets a new value for the tree parameter */

            [M] AIParam GetParam( const char* ParameterName )
            /* Returns the value of the tree parameter.

               There are interpretations of the meaning:
                      [.AsInt]     - returns a integer,
                      [.AsString]  - returns a string,
                      [.AsFloat]   - returns a number with a comma,
                      [.AsBoolean] - returns a boolean value,
                      [.AsRUchars] - returns a string with the Latin alphabet translated into Cyrillic,
                      [.AsENchars] - returns a string from translated Cyrillic to Latin */

            [M] int GetParamsAmount()
            /* Returns the number of tree parameters */

            [M] bool AddParam( const char* ParameterName, const CStr& ParameterValue, bool Spaces )
            /* Adds a new tree parameter.

               bool Spaces adds spaces (indents) between the values of the parameter being added */

            [M] bool RemoveParam( const char* ParameterName )
            /* Deletes a tree parameter */

            [M] table GetObjectByCustomKey( string CustomKey )
            /* Returns the first found object of the tree by the user parameter.

               User keys are set in PARSER.KEYS */

            [M] table GetObjectByName( const char* ItemObjName )
            /* Returns the first found object of the tree by Name */

            [M] table GetObjectById( const int* Id )
            /* Returns the first found tree object by ID */

            [M] table GetObject( const char* ItemName )
            /* Returns the first found tree object by tag */

            [M] table GetTreeByCustomKey( string CustomKey )
            /* Returns the first tree found by the user parameter.

               User keys are set in PARSER.KEYS */

            [M] table GetTreeByName( const char* TreeObjName )
            /* Returns the first found tree by Name inside the tree */

            [M] table GetTreeById( const int* Id )
            /* Returns the first tree found by ID inside the tree */

            [M] table GetTree( const char* TreeName )
            /* Returns the first tree found by the tag inside the tree */

            [M] int GetItemsAmount()
            /* Returns the number of items in the tree */

            [M] int GetChildsAmount()
            /* Returns the number of subobjects of the tree */

            [M] table GetParams()
            /* Returns all the parameters of the tree */

            [M] table GetItems()
            /* Returns all the items in the tree */

            [M] table GetChilds()
            /* Returns all the items in the tree that have subobjects inside themselves */

            [M] bool Wrap()
            /* Collapses the selected tree */

            [M] bool Unwrap()
            /* Expands the selected tree */

            [M] bool WrapAllItems()
            /* Collapses all the items in the tree */

            [M] bool UnwrapAllItems()
            /* Expands all the items in the tree */

            [M] bool AddEnters()
            /* Adds padding between elements, if not */

            [M] bool CleanEnters()
            /* Removes the margins between the elements, if any */

            [M] string AddAsTextField( const table* fieldParams, string TextFieldValue, bool Enters )
            /* Adds the fieldParams tree as a text field with the TextFieldValue value.

               Makes padding if Enters = true */

            [M] string ReadAsTextField( const table* fieldParams, bool CutTabs )
            /* Returns the content between the tree tags and searches by fieldParams.

               Deletes the tab in the return value if CutTabs = true */

            [M] string EditAsTextField( const table* fieldParams, string TextFieldNewValue )
            /* Edits the fieldParams tree as a text field with a new TextFieldNewValue value */


            Class OBJ
            {
                [M] OBJ GetObj( table ObjectTagXorCustomKey, string CustomKeyValue ) : public TREE
                /* This is a direct reference to the OBJ object: [{"TagName", "Name"}, "bibka"].

                   User keys are set in PARSER.KEYS */
                {
                    [M] string GetName()
                    /* Returns the name of the object tag */

                    [M] string GetObjName()
                    /* Returns the name of the object */

                    [M] AIParam GetProperty( const char* PropertyName )
                    /* Returns the value of the object parameter.

                       There are interpretations of the meaning:
                              [.AsInt]     - returns a integer,
                              [.AsString]  - returns a string,
                              [.AsFloat]   - returns a number with a comma,
                              [.AsBoolean] - returns a boolean value,
                              [.AsRUchars] - returns a string with the Latin alphabet translated into Cyrillic,
                              [.AsENchars] - returns a string from translated Cyrillic to Latin */

                    [M] table GetProperties()
                    /* Returns all object parameters */

                    [M] bool SetProperty( const char* PropertyName, const CStr& PropertyValue )
                    /* Sets the new value of the object parameter */

                    [M] bool AddProperty( const char* PropertyName, const CStr& PropertyValue, bool Spaces )
                    /* Adds a new object parameter.

                       bool Spaces adds spaces (indents) between the values of the parameter being added */

                    [M] bool RemoveProperty( const char* PropertyName )
                    /* Deletes an object parameter */

                    [M] string GetParentName()
                    /* Returns the tag name of the parent tree */

                    [M] bool Wrap()
                    /* Collapses the selected object */

                    [M] bool Unwrap()
                    /* Expands the selected object */
                }
            }
        }
    }


    /* Service functions. If possible, do not use */

    [M] void clearCache()
    /* Resets global parser variables to the default settings.

       After that, the parser must be initialized again via init() */

    [M] table getCache()
    /* Returns all global variables of the parser.

       The indexes of variables can be viewed in the game log if bool LOG is enabled in init() */

    [M] void ConvertPropertiesIn( const char* InputPATH, const char* OutputPATH )
    /* Converts object values from a file (dynamicscene, world)
       into convenient copy options for scripts to an OutputPath file.,
       otherwise, at the root of how func_ConvertPropertiesIn.xml .

       Examples:
              rot="0.0004 0.9786 -0.2058 0.0021" --> rot="Quaternion(0.0004, 0.9786, -0.2058, 0.0021)";
              Pos="326.145 436.152 2804.116"     --> Pos="CVector(326.145, 436.152, 2804.116)" */

    [M] AIParam ReadBinary( const char* path_to_file )
    /* Reads binary files.

       Returns the file size in bytes, kilobytes, and megabytes.
              [.AsHex] - returns the Hex content of the file,
              [.AsASCII] - returns the ASCII contents of the file */

    [M] bool AddCommentNearItem( string comment, table itemParams )
    /* Adds a comment above the element.

       Use [XMLParser:Tree( table treeParams):init()] before executing the command */

    [M] string GetLineWithContent( int line, string Content )
    /* Returns a string and its number from a file,
       searches for the first match by Content, if specified (regular expression support).

       Use [XMLParser:Tree( table treeParams):init()] before executing the command */

    [M] tuple RemoveLineWithContent( int line, string Content )
    /* Deletes a line in the file (Careful! You can break the markup of the file!).

       Returns true, the row number, and the row value itself, otherwise nil.
       Searches for the first match by Content, if specified (regular expression support).

       Use [XMLParser:Tree( table treeParams):init()] before executing the command */

    [M] bool addTree( table treeParams, table put_inParams, table includeKeysForSort )
    /* Adds an xml tree to the put_inParams table tree, otherwise to the root.

       Sorts new parameter keys from top to bottom, if specified.
       Sorted keys from top to bottom by default: "id", "Id", "ObjectId", "Name", "name", "Amount", "Maximum", "Description" */

    [M] bool addObject( table objectParams, table put_inParams, table includeKeysForSort)
    /* Adds an xml object to the put_inParams tree, otherwise to the root.

       Sorts new parameter keys from top to bottom, if specified.
       Sorted keys from top to bottom by default: "id", "Id", "ObjectId", "Name", "name", "Value", "ListOfItems", "Chassis", "Cabin", "Cargo", "Skin", "ListOfGuns", "Name", "Status", "Item", "Description", "Difficulty", "Done" */

    [M] bool removeTree( table treeParams )
    /* Deletes the xml tree */

    [M] bool removeObject( table treeParams, table objectParams )
    /* Deletes an xml object in the tree */

    [M] string Wrap( table objectParams )
    /* Returns the collapsed item */

    [M] table Unwrap( table objectParams )
    /* Returns the expanded item */

    [M] tuple getTree( const table* treeParams, const char* put_in )
    /* Returns all found parameters, items, and all childs of the tree,
       folded in put_in,
       otherwise it will find the first occurrence or nil */

    [M] table getItemFromLine( const table* content, const int* Line, const CStr& parentName, const char* parentTabs )
    /* Returns the found item from the content,
       all its parameters and all nested child items and their parameters,
       starting from the line number Line.

       Searches for the closing ParentName tag along with parentTabs.
       A cumbersome and recursive function that allows the game's memory to drain away if the xml structure is complex enough. */

    [M] string getItemClass( const table* content, const int* curLine )
    /* Checks the item from the content, under the row number curLine
       and returns its class: "tree", "object" */

    [M] table GetTagAndCustomKeyFromItem( const table* itemParams )
    /* Returns the tag name and the custom item parameter.

       User keys are set in PARSER.KEYS */

    [M] string GetItemCustomKey( const table* itemParams, const table* keys )
    /* Returns the object's key and its value.

       Takes table keys from PARSER.KEYS_SearchingGradient if nil. */


    /* Experimental script branch. Allows you to control the triggers of other maps */

    Class TRIGGER
    {
        [M] TRIGGER trigger( string TriggerName ) : public XMLParser
        /* This is a direct reference to the trigger TRIGGER.

           Use [XMLParser:init()] before executing commands */
        {
            [M] bool Add( int Active, table Events, table Script)
            /* Adds a trigger named TriggerName, Events, and the Script Script.

               Events and Script are tables containing separate rows, where each row is a row of the script/event object. */

            [M] bool Remove()
            /* Deletes a trigger named TriggerName */

            [M] bool DoScript()
            /* Executes the trigger script safely.

               Returns an error with the second value otherwise.
               Global trigger game methods are not available. Please discard the methods or redefine trigger inside the trigger script so that DoScript() executes correctly.
               Otherwise, there is an error in the trigger script.
               Remember that it is not possible to manipulate objects on other maps from the outside. */

            [M] bool IsActive()
            /* Returns the trigger state */

            [M] bool SetActive( bool Active )
            /* Assigns the trigger state */

            [M] string GetBody()
            /* Returns the trigger script as a string */

            [M] table GetScript()
            /* Returns the trigger script as a string table */

            [M] string GetScriptByLine( int Line )
            /* Returns the trigger script string by line number (relative) */

            [M] int GetLineByScriptContent( string Content )
            /* Returns the line number of the trigger script based on the content of the line (relative) */

            [M] bool ReplaceScript( string NewScript )
            /* Replaces the trigger script with a new script [[]] */

            [M] bool AddScript( string Script, int Line )
            /* Adds a new part of the script to the trigger with the Line position, otherwise to the end of the trigger */

            [M] void RemoveScript()
            /* Deletes the trigger script */

            [M] bool RemoveScriptLine( int Line or string Content )
            /* Deletes the trigger script line by line number or by content (relative) */

            [M] table GetAllEvents()
            /* Returns all trigger events.

               Event keys can be:
                   [eventid]
                   [timeout]
                   [ObjName]
                   [msgid]
                   [flypath] */

            [M] event[table] GetEventById( const char* EventId )
            /* Returns the trigger event by the name eventid.

               Event keys can be:
                   [eventid]
                   [timeout]
                   [ObjName]
                   [msgid]
                   [flypath] */

            [M] event[table] GetEventByKey( const char* EventKey, string EventValue )
            /* Returns the trigger event based on the event key and its value.

               Event keys can be:
                   [eventid]
                   [timeout]
                   [ObjName]
                   [msgid]
                   [flypath] */

            [M] bool AddEvent( table event )
            /* Adds a new event to the trigger.

               Event keys can be:
                   [eventid]
                   [timeout]
                   [ObjName]
                   [msgid]
                   [flypath] */

            [M] bool RemoveEvent( table event )
            /* Removes the event from the trigger.

               Event keys can be:
                   [eventid]
                   [timeout]
                   [ObjName]
                   [msgid]
                   [flypath] */
        }
    }
}
```

<a id="exampleScriptForReading_en"></a><a href="#top">Go up ↑</a>

### Example of using methods

```lua
if XMLParser then   --> We get the lua module parser object loaded using the code above
    local success, file = XMLParser:init('data\\gamedata\\my_xml_file.xml', "RootTagName", nil, false)   --> Initialize the entry point of the parser into the file with the specified root tag "RootTagName" or any other desired one - the "pointer" of the parser will capture the desired tree
    if success then
        println("file exists")
        local tree = XMLParser:Tree({"Repository", "My Items"}):init()   --> Initialize the tree with the "Repository" tag and the "My Items" name parameter inside the "RootTagName"
        if tree then     --> Checking if such a tree exists in the file
            println("tree exists")
            local getTree = XMLParser:Tree()                     --> Adding the tree to the local variable
            local getItem = getTree:GetObj({"Item", "Item01"})   --> We are trying to get an object with the tag "Item" and the name "Item01" in this tree
            if getItem then      --> Checking if such an object exists
                println("item exists")
                local getItemParameter = getItem:GetProperty("MyParameterName").AsString        --> We are trying to get the "MyParameterName" parameter of this object as a string
                println("parameter value: "..tostring(getItemParameter))        --> Printing the value of this parameter to the console
            end
        end
        file:close()     --> We close the file manually, as we only learned the information from there and did not change anything. It is impossible not to close the file - it will remain in the game's memory and other programs will not be able to access it. If you were changing it, you would use [XMLParser:save()] - it will save and close the file.
    end
end
```

<a id="exampleParams_en"></a><a href="#top">Go up ↑</a>

## SAMPLE Params OF A TREE/OBJECT

```lua
local itemParams = {                /* This is a table with keys */
    _itemClass = "tree",           --> Required parameter. _itemClass specifies the item entity. "tree" - for the tree, "object" - for the object.
    _itemTag = "TreeExample",      --> Required parameter. _itemTag specifies the name of the opening item tag (and the closing one for the tree).
    Name = "Example"               --> An optional, but highly recommended parameter. A key value such as (Name, name, ObjectId, Id, id) sets the name of the item inside the tags. It is indispensable for the correct search among the identical tags of objects.
}                                   --> There can be any other parameters below without underscores. The parameter name can be any letter key, and the parameter value is a string.
```
```lua
local treeParams = {
    _itemClass = "tree",
    _itemTag = "TreeExample",
    Name = "Example",
    Param1 = "6",
    Param2 = "true",
    Description = "jopa",
}

local objectParams = {
    _itemClass = "object",
    _itemTag = "Object",
    ObjectId = "627",
    Description = "huy",
    Param3 = "true",
    Param4 = "value",
}
```

<a id="whatIsModuleItems_en"></a><a href="#top">Go up ↑</a>

## What is a "tree"

Class TREE functions.

```xml
<RootTree>      --> Open tag
</RootTree>     --> Close tag
```
```xml
<TreeExample Name="Tree">
</TreeExample>

<Repository
    Name="Example"
    Description="I am a tree">
</Repository>

<Aboba>       --> A bad example of a tree without a unique name or ID parameter
</Aboba>
```

## What is a "text field"

Class TREE functions.

```xml
<Key>           --> Open tag
</Key>          --> Close tag
```
```xml
<Key Name="Field">64</Key>

<Text Name="Text">First text line
    Second text line
</Text>

<Key>       --> A bad example of a tree without a unique name or ID parameter
</Key>
```

## What is a "object"

Class OBJ functions.

```xml
<Ware                 --> Open tag
    Name="Potatoe"                         
/>                    --> Close tag
```
```xml
<Item Id="666" Value="true" />               --> Object 1
<Object Value="3" />                         --> Object 2
<Entity Name="Parameter2" Value="false" />   --> Object 3

<Ending                           
    Name="Thanks for playing!"       
    Description="Complete game" />

<Object />       --> A bad example of a tree without a unique name or ID parameter
```

## Example `example_content` for `init`

```lua
local example_content = '<?xml version="1.0" encoding="windows-1251" standalone="yes" ?>\n<Root>\n<!-- here your data -->\n</Root>'
```

<a id="tipsAndCodeExamples_en"></a><a href="#top">Go up ↑</a>

## TIPS

- If you are reading **small files**, you can use the sample above with `XMLParser:init()`. It is easy to monitor and carry out all kinds of checks.

- If you want to **get information from huge files**, for example, to get a lot of objects from a save file, it is worth using `XMLParser:ReadFromBigfile()`.

- If you are reading **large files but want to edit them**, I strongly recommend considering the "queue" option: `XMLParser:openQueue()` and `XMLParser:closeQueue()`. It will be the most "optimized" option, which copes better with large files - the game suffers noticeably less. This option is more difficult to verify.


I'll give you some ready-made example scripts:

### We will get the XMLParser object of the player from the save and write the new value of money to it separately.
```lua
local path_to_savefile = 'data\\profiles\\Player\\saves\\00000000\\maps\\currentmap.xml'
XMLParser:openQueue( path_to_savefile )
local PLAYER = XMLParser:GetItemFromFile('Name%s*=%s*"Player1"', "Object", "DynamicScene")
XMLParser:SetItemValueInFile('Name%s*=%s*"Player1"', "Object", "DynamicScene", 'Money', '%d*', '99999999')
XMLParser:closeQueue()
```
### Let's change the text of some lines from dialogsglobal.xml
```lua
local path_to_dialogsglobal = 'data\\if\\diz\\dialogsglobal.xml'
XMLParser:openQueue( path_to_dialogsglobal )
XMLParser:SetItemValueInFile('name%s*=%s*"Man_dlg0_1"', "Reply", "DialogsResource", "text", "text for replace", "this text has been replaced")
XMLParser:SetItemValueInFile('name%s*=%s*"Man_dlg0_2"', "Reply", "DialogsResource", "text", "text for replace", "this text has been replaced")
XMLParser:SetItemValueInFile('name%s*=%s*"Man_dlg1_1"', "Reply", "DialogsResource", "text", "text for replace", "this text has been replaced")
XMLParser:SetItemValueInFile('name%s*=%s*"Man_dlg2_3"', "Reply", "DialogsResource", "text", "text for replace", "this text has been replaced")
XMLParser:SetItemValueInFile('name%s*=%s*"Man_dlg2_4"', "Reply", "DialogsResource", "text", "text for replace", "this text has been replaced")
XMLParser:SetItemValueInFile('name%s*=%s*"Man_dlg3_0"', "Reply", "DialogsResource", "text", "text for replace", "this text has been replaced")
XMLParser:SetItemValueInFile('name%s*=%s*"Man_dlg4_3"', "Reply", "DialogsResource", "text", "text for replace", "this text has been replaced")
XMLParser:closeQueue()
if RepliesManager then
    RepliesManager:Init()
end
```
### We will find and delete all unnecessary objects from world.xml
```lua
local path_to_world = 'data\\maps\\r1m1\\world.xml'
local tag = "Node"
local folder = "World"
local example = 'id%s*=%s*"big_stone4"'
XMLParser:openQueue( path_to_world )
local item = XMLParser:GetItemFromFile(example, tag, folder)
if item then
    repeat
        item = XMLParser:RemoveItemFromFile(example, tag, folder)
    until not item
end
XMLParser:closeQueue()
```
### Getting the XMLParser object of the *ENTIRE* dynamicscene from the save
```lua
local dynamicscene = XMLParser:ReadFromBigfile('data\\profiles\\Player\\saves\\00000066\\maps\\currentmap.xml', "DynamicScene", nil, nil, nil, nil)
```

<a id="detailsAndThanks_en"></a><a href="#top">Go up ↑</a>

## LEARN MORE

You can find this and other information in the project file or find examples of how the module works in the ExplorerMod mod from the same author.

You can find out how to decipher the `table` and some small explanations [here](https://github.com/ejetaxeblevich/XMLParser/blob/main/helpinfo.md).


## AUTHOR'S COMMENTS

    E Jet: It's an enchanted parser that makes you want to shit.

Thanks to [stakanyash](https://github.com/stakanyash) for the idea of an attribute capture script!

<a href="#top">Go up ↑</a>
