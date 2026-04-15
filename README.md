# ФАЙЛОВЫЙ LUA-МОДУЛЬ

Написанный специально для игры Ex Machina / Hard Truck Apocalypse

### Note: Please translate this text, if it nessesary.

[comment]: <> ( Этот readme не имеет красивого оформления, поэтому используйте поиск по тексту вверху справа.)
[comment]: <> ( <div align="center">)
[comment]: <> ( <img width="114" height="92" alt="image" src="https://github.com/user-attachments/assets/9ed52681-407d-44c1-8a02-6df8c0cbd563" />)
[comment]: <> ( </div>)


## ЧТО ЭТО


Универсальный lua-модуль, который может использоваться для **ЧТЕНИЯ** и **ЗАПИСИ** .xml файлов **через скрипты** любой модификации внутри игры.

Вы сможете прочитать xml дерево, получить значения его объектов и использовать их в игре. Кроме того, здесь имеется, не весть какой, но конструктор, который позволит вам создавать файлы, а затем записывать/читать деревья и объекты внутри них.

> ![ModuleDemoJpg](exm_xmlparser_demo.jpg)
> exm_xmlparser_demo.jpg

### ВОЗМОЖНОСТИ
- **Чтение** - легко узнать ранее недоступную информацию из игровых ресурсов!
- **Запись** - можно записать в свой `xml` файл любую информацию, так её хранить и получать в любое время!
- **Крупный список разных функций** - для гибкого и точечного использования модуля!


### Дисклеймер

АВТОР ЭТОГО ТВОРЕНИЯ ДУМАЕТ, ЧТО ЗНАЕТ, КАК ПРАВИЛЬНО НАЗЫВАТЬ И ИСПОЛЬЗОВАТЬ ВЕЩИ В ПРОГРАММИРОВАНИИ, ПОЭТОМУ ПРОСЬБА ДЛЯ ПРОГРАММИСТОВ ЗДОРОВОГО ЧЕЛОВЕКА - ПОНЯТЬ И ПРОСТИТЬ, ЕСЛИ ЗДЕСЬ ЧТО-ТО(ВСЕ) НЕ ТАК.


АВТОР ПОНИМАЕТ И ПРИНИМАЕТ, ЧТО ВЕСЬ КОД НИЖЕ И ЭТОТ ТЕКСТ НАПИСАН ПЛОХО, НЕПОНЯТНО И ГРОМОЗДКО, ЧТО ДАЖЕ В ЭТОМ ЗАНЯТИИ НЕТ НИ МАЛЕЙШЕГО СМЫСЛА - КАК И СМЫСЛА В ЭТОМ КАПСОМ НАПИСАННОМ ДИСКЛЕЙМЕРЕ.


LUA-МОДУЛЬ РАСПРОСТРАНЯЕТСЯ СВОБОДНО "КАК ЕСТЬ" И ИСПОЛЬЗУЕТСЯ ИГРОЙ EX MACHINA / HARD TRUCK APOCALYPSE ДЛЯ ЧТЕНИЯ, ИЗМЕНЕНИЯ, СОЗДАНИЯ, А ТАКЖЕ УДАЛЕНИЯ(!) ФАЙЛОВ НА ВАШЕМ КОМПЬЮТЕРЕ И МОЖЕТ БЫТЬ ИЗМЕНЕН ЛЮБЫМ ДРУГИМ ПОЛЬЗОВАТЕЛЕМ (МОДДЕРОМ) ВНУТРИ СВОИХ МОДИФИКАЦИЙ И ПРОЧИХ РЕСУРСАХ.

АВТОР НЕ НЕСЕТ ОТВЕТСТВЕННОСТИ ЗА КАКИЕ-ЛИБО ПОСЛЕДСТВИЯ, ПОВЛЕКШИХ ЗА СОБОЙ УЩЕРБ ВО ВРЕМЯ ИСПОЛЬЗОВАНИЯ ЭТОГО, А ТАКЖЕ ЛЮБОЙ ДРУГОЙ, В Т.Ч. ИЗМЕНЕННОЙ ВЕРСИИ LUA-МОДУЛЯ ИЛИ ЧАСТЕЙ КОДА, ПОЗАИМСТВОВАННЫХ (ПЕРЕПИСАННЫХ) ИЗ ЭТОГО ФАЙЛА.


## КАК ЭТО ИСПОЛЬЗОВАТЬ

Почему это "модуль" а не любой другой файл с lua скриптами? Хотя он таким и является...
- Потому что этот файл - таблица функций XMLParser (далее класс), который имеет свои собственные методы и функции, что очень похоже на серьезную тему. Наверное. Типа. Я хз...


Для полноценного lua-модуля этой поделке еще далеко, поэтому ее не нужно устанавливать как библиотеку Lua в системе.

В игру этот lua-модуль загружается двумя способами: через `require()` или `dofile()`. Это внутренние Lua команды игры. 
Наш знакомый `EXECUTE_SCRIPT` не подойдет, так как он не возвращает объект модуля.


Чем отличается `require()` от `dofile()`? 


- `require()` загружает файл в игру при первом выполнении и держит в памяти игры до перезапуска. Эта команда используется для подгрузки модулей здорового человека, которые устанавливаются в систему (но необязательно);
- `dofile()` загружает в память игры файл столько раз, сколько был вызван. Очищается весь внутренний кеш lua-модуля и принимаются настройки по умолчанию. Рекомендуется для отладки и прочего дебага.

Рекомендую прописывать команду в начало файла `server.lua` игры, поскольку могут использоваться в модуле команды, которые грузятся в игру чуть раньше сервера ("могут"? автор альцгеймер!).


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

После загрузки модуля в игру следует инициализировать его работу через метод `init()`. Это необходимо, чтобы указать парсеру файл для "анализа" и имя главного корня xml (дерева). Функция может быть вызвана вновь в любой момент.

### ФУНКЦИЯ `init()`
```lua
XMLParser:init(path_to_file, root_tag_in_file, default_file_content, bLOG)
```

`path_to_file`            - путь к xml файлу *[string]*;

`root_tag_in_file`        - имя главного xml корня (дерева) в файле *[string]*;

`default_file_content`    - (необязательно) содержимое xml файла по умолчанию (при создании файла), указывается как пример `example_content` ниже *[string]*;

`bLOG`                    - (необязательно) разрешает/запрещает принтить (выводить) всю дебаг информацию в лог и консоль игры *[bool]*.


```lua
local example_content = '<?xml version="1.0" encoding="windows-1251" standalone="yes" ?>\n<Root>\n<!-- здесь ваши данные -->\n</Root>'
```

### Пример кода загрузки

```lua
g_XMLParser = require("data\\gamedata\\lua_lib\\xmlparser.lua")
if not g_XMLParser then
    LOG("[E] Could not find global xmlparser.lua...")
else
    g_XMLParser:init("data\\gamedata\\ModStats.xml", "ModStats", nil, false)
end
```

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


## ФУНКЦИИ И МЕТОДЫ

Здесь собраны все публичнные функции этого модуля. У каждой функции имеется детальное описание что она делает. Прочтите описание парсера полностью, чтобы лучше понимать, что это за парацетамол. Пользуйтесь на здоровье!

За время разработки и обновлений тут уже скопилось достаточно много функций разной полезности и уровня яндередева, но тем не менее, некоторые из них всё так же остаются полезными.

**Обратите внимание**, что дочерний класс должен вызывать главный метод своего родительского класса вплоть до XMLParser.

**Также обратите внимание на то, что функции для редактирования объектов и деревьев РАБОТАТЬ НЕ БУДУТ**, если применяются на подобъекты захватываемого дерева. Сначала вам следует сделать дерево-подобъект активным.

По умолчанию в некоторых командах **вместо аргумента `self`** указывайте `nil` при вызове.

```c
Class XMLParser
{
    /* Основные функции */
    [M] bool IsFileExists( const char* path_to_file )    /* Проверяет, существует ли файл по этому пути */
    [M] bool IsFileOpen( file descriptor )               /* Проверяет, открыт ли файл в памяти по этому дескриптору */
    [M] bool&descriptor init( const char* path_to_file, const CStr& root_tag_in_file, const CStr& default_file_content, bool LOG )  /* Инициализирует "точку входа" парсера в файле, перезатирает ранее установленные параметры парсера. bool LOG принтит дебаг информацию, если нужно отследить, что не нравится парсеру или где он ломается (Внимание! Принтит ОЧЕНЬ много мусора в лог игры и вызывает НАИСИЛЬНЕЙШУЮ утечку памяти) */
    [M] bool save()      /* Сохраняет в файл все изменения, произведенные парсером */
    [M] bool createFile( const char* path, const CStr& default_file_content )     /* Создает (ПЕРЕЗАТИРАЕТ) файл и записывает в него базовый контент, указанный в default_file_content или в init(). По умолчанию это "data\\gamedata\\file_name.xml" */
    [M] bool removeFile()       /* Удаляет файл, указанный в init(). По умолчанию это "data\\gamedata\\file_name.xml" */
    [M] void AutoUpdateTree( bool Value )       /* Включает/отключает автоматическое обновление дерева TREE при каждом вызове дочерних методов TREE */
    
    /* Универсальные функции */
    [M] string QuickGet( const char* path_to_file, const char* AttrName )                       /* Возвращает значение атрибута из файла. Работает быстро, возвращает первое совпадение! Не использует кэш и переменные парсера. Игнорирует деревья и объекты, пробелы и табуляцию */
    [M] bool QuickSet( const char* path_to_file, const char* AttrName, const CStr& AttrValue )  /* Редактирует значение атрибута в файле. Работает быстро, редактирует первое совпадение! Не использует кэш и переменные парсера. Игнорирует деревья и объекты, пробелы и табуляцию */
    [M] string QuickParseLine( const char* path_to_file, const char* LinePattern )              /* Возвращает захваченный паттерн строки из файла. Ищет построчно до первого совпадения, работает с регулярными выражениями */
    [M] bool openQueue( const char* path_to_file )           /* Открывает очередь для команд ниже (и не только), открывает файл и держит его в памяти. Пока открыта очередь, команды парсера будут применяться к файлу по этому пути */
    [M] table GetItemFromFile( string FindExample, const char* ItemTagName, const char* ItemRepositoryName )       /* Возвращает XMLParser-объект из выбранного xml файла, используется без init(). Не нагружает игру как простое чтение XMLParser через init() у большого файла. Очень полезно для чтения огромных файлов (таких как dialogsglobal.xml или currentmap.xml) а также более "шелкового касания" объекта, нежели как это делает автоматически XMLParser, однако необходимо уже вручную разбирать возвращаемую таблицу. Аргументы: FindExample - образец строки для первичного поиска. Указывается один из атрибутов объекта, например имя: 'name="object_name"'; ItemTagName - имя открывающего тега этого объекта; ItemRepositoryName - имя открывающего/закрывающего тега дерева, где этот объект находится. */
    [M] bool SetItemValueInFile( string FindExample, const char* ItemTagName, const char* ItemRepositoryName, const char* AttributeName, const char* Pattern, const CStr& AttributeValue )    /* Изменяет параметр объекта в выбранном xml файле, используется без init(). Не нагружает игру как простое чтение XMLParser через init() у большого файла. Очень полезно для чтения огромных файлов (таких как dialogsglobal.xml или currentmap.xml) а также более "шелкового касания" объекта, нежели как это делает автоматически XMLParser. Аргументы: FindExample - образец строки для первичного поиска. Указывается один из атрибутов объекта, например имя: 'name="object_name"'; ItemTagName - имя открывающего тега этого объекта; ItemRepositoryName - имя открывающего/закрывающего тега дерева, где этот объект находится; AttributeName - имя атрибута; Pattern - что нужно найти и заменить. Если nil, будет весь текст атрибута; AttributeValue - на что нужно заменить. Если nil, будет весь текст атрибута. */
    [M] bool RemoveItemFromFile( string FindExample, const char* ItemTagName, const char* ItemRepositoryName )     /* Удаляет найденный XMLParser-объект из выбранного xml файла, используется без init(). Не нагружает игру как простое чтение XMLParser через init() у большого файла. Очень полезно для чтения огромных файлов (таких как dialogsglobal.xml или currentmap.xml) а также более "шелкового касания" объекта, нежели как это делает автоматически XMLParser, однако необходимо уже вручную разбирать возвращаемую таблицу. Аргументы: FindExample - образец строки для первичного поиска. Указывается один из атрибутов объекта, например имя: 'name="object_name"'; ItemTagName - имя открывающего тега этого объекта; ItemRepositoryName - имя открывающего/закрывающего тега дерева, где этот объект находится. */
    [M] bool closeQueue( table content, file descriptor )    /* Закрывает очередь для команд выше (и не только), закрывает файл и сохраняет изменения в нем. Не указывайте аргументы для работы с текущим открытым файлом */

    /* Сервисные функции. По возможности не используйте */
    [M] void clearCache()       /* Сбрасывает глобальные переменные парсера в настройки по умолчанию. После этого необходимо снова инициализировать парсер через init() */
    [M] table getCache()        /* Возвращает все глобальные переменные парсера. Индексы переменных можно посмотреть в логе игры, если включен bool LOG в init() */
    [M] void ConvertPropertiesIn( const char* InputPATH, const char* OutputPATH )    /* Конвертирует значения объектов из файла (dynamicscene, world) в удобные варианты копирования для скриптов в файл OutputPATH, иначе в корень как func_ConvertPropertiesIn.xml. Примеры: rot="0.0004 0.9786 -0.2058 0.0021" --> rot="Quaternion(0.0004, 0.9786, -0.2058, 0.0021)"; Pos="326.145 436.152 2804.116" --> Pos="CVector(326.145, 436.152, 2804.116)" */ 
    [M] AIParam ReadBinary( const char* path_to_file )       /* Читает бинарные файлы. Возвращает размер файла в байтах, килобайтах и мегабайтах. [.AsHex] - возвращает Hex-содержимое файла, [.AsASCII] - возвращает ASCII-содержимое файла */
    [M] bool AddCommentNearItem( string comment, table itemParams )  /* Добавляет комментарий над элементом. Используйте [XMLParser:Tree( table treeParams ):init()] перед выполнением команды */
    [M] string GetLineWithContent( int line, string Content )        /* Возвращает строку и ее номер из файла, ищет первое совпадение по Content, если указан (поддержка регулярных выражений). Используйте [XMLParser:Tree( table treeParams ):init()] перед выполнением команды */
    [M] tuple RemoveLineWithContent( int line, string Content )      /* Удаляет строку в файле (Осторожно! Можно сломать разметку файла!). Возвращает истину, номер строки и само значение строки, в противном случае nil. Ищет первое совпадение по Content, если указан (поддержка регулярных выражений). Используйте [XMLParser:Tree( table treeParams ):init()] перед выполнением команды */
    [M] bool addTree( table treeParams, table put_inParams, table includeKeysForSort )       /* Добавляет xml дерево в дерево table put_inParams, иначе в корень. Сортирует новые ключи параметров сверху вниз, если указаны. Сортируемые ключи сверху вниз по умолчанию: "id", "Id", "ObjectId", "Name", "name", "Amount", "Maximum", "Description" */
    [M] bool addObject( table objectParams, table put_inParams, table includeKeysForSort)    /* Добавляет xml объект в дерево put_inParams, иначе в корень. Сортирует новые ключи параметров сверху вниз, если указаны. Сортируемые ключи сверху вниз по умолчанию: "id", "Id", "ObjectId", "Name", "name", "Value", "ListOfItems", "Chassis", "Cabin", "Cargo", "Skin", "ListOfGuns", "Name", "Status", "Item", "Description", "Difficulty", "Done" */
    [M] bool removeTree( table treeParams )     /* Удаляет xml дерево */
    [M] bool removeObject( table treeParams, table objectParams )     /* Удаляет xml объект в дереве */
    [M] string Wrap( table objectParams )       /* Возвращает свернутый item */
    [M] table Unwrap( table objectParams )      /* Возвращает развернутый item */
    [M] tuple getTree( const table* treeParams, const char* put_in )    /* Возвращает все найденные параметры, items и все childs дерева, сложенного в put_in, иначе найдет первое вхождение или nil */
    [M] table getItemFromLine( const table* content, const int* Line, const CStr& parentName, const char* parentTabs )       /* Возвращает найденный item из content, все его параметры и все вложенные дочерние item и их параметры, начиная с номера строки Line. Ищет закрывающий тег parentName вместе с parentTabs. Громоздкая и рекурсивная функция, дающая памяти игры утечь куда глаза глядят, если xml конструкция достаточно сложная */
    [M] string getItemClass( const table* content, const int* curLine )     /* Проверяет item из content, под номером строки curLine и возвращает его класс: "tree", "object" */
    [M] table GetTagAndCustomKeyFromItem( const table* itemParams )         /* Возвращает имя тега и пользовательский параметр item. Пользовательские ключи задаются в PARSER.KEYS */
    [M] string GetItemCustomKey( const table* itemParams, const table* keys )    /* Возвращает ключ объекта и его значение. Берет table keys из PARSER.KEYS_ForSearching если nil. */


    /* Чтение и редактирование XML */
    Class TREE
    {
        [M] TREE Tree( table treeParams ) : public XMLParser     /* Это прямое обращение к дереву TREE. Используйте [XMLParser:Tree( table treeParams ):init()] перед выполнением команд. Во время использования команд аргумент в Tree() не нужен */
        {
            [M] bool init( table new_treeParams )      /* Обновляет содержимое TREE, захватывает новое дерево если указан new_treeParams */
            [M] bool IsObjectExists( table ObjectTagXorCustomKey, string CustomKeyValue )      /* Проверяет, существует ли такой объект в дереве: [{"TagName", "Name"}, "bibka"]. Пользовательские ключи задаются в PARSER.KEYS */
            [M] bool IsTreeExists( table TreeTagXorCustomKey, string CustomKeyValue )          /* Проверяет, существует ли такое дерево в дереве: [{"TagName", "Name"}, "bibka"]. Пользовательские ключи задаются в PARSER.KEYS */
            [M] bool CaptureInnerTree( table TreeTagXorCustomKey, string CustomKeyValue )      /* Помещает найденное дерево внутри дерева в TREE (новое дерево становится активным). Пользовательские ключи задаются в PARSER.KEYS */
            [M] bool Add( table itemParams, bool Enters, bool Spaces, table includeKeysForSort )         /* Добавляет новый item в дерево. bool Enters добавляет пробелы (отступы) сверху добавляемых объектов. bool Spaces добавляет пробелы (отступы) между значениями добавляемых объектов. Сортирует новые ключи параметров сверху вниз, если указаны. Сортируемые ключи по умолчанию определяются классом нового элемента */
            [M] bool Remove( table itemParams or "self")       /* Удаляет item в дереве. Укажите аргументом строку "self" для удаления дерева TREE (активного дерева) */ 
            [M] string GetName()        /* Возвращает имя тега дерева */
            [M] string GetObjName()     /* Возвращает Name дерева */
            [M] ??? GetCustomValue()    /* Возвращает _customValue дерева */
            [M] bool SetParam( const char* ParameterName, const CStr& ParameterValue )      /* Устанавливает новое значение параметра дерева */
            [M] AIParam GetParam( const char* ParameterName )    /* Возвращает значение параметра дерева. Имеются интерпретации значения: [.AsInt] - возвращает целое число, [.AsString] - возвращает строку, [.AsFloat] - возвращает число с запятой, [.AsBoolean] - возвращает логическое значение, [.AsRUchars] - возвращает строку с переведенными английскими буквами на русские буквы, [.AsENchars] - возвращает строку с переведенными русскими буквами на английские буквы */
            [M] int GetParamsAmount()    /* Возвращает количество параметров дерева */
            [M] bool AddParam( const char* ParameterName, const CStr& ParameterValue, bool Spaces )       /* Добавляет новый параметр дерева. bool Spaces добавляет пробелы (отступы) между значениями добавляемого параметра */
            [M] bool RemoveParam( const char* ParameterName )        /* Удаляет параметр дерева */
            [M] table GetObjectByCustomKey( string CustomKey )       /* Возвращает первый найденный объект дерева по пользовательскому параметру. Пользовательские ключи задаются в PARSER.KEYS */
            [M] table GetObjectByName( const char* ItemObjName )     /* Возвращает первый найденный объект дерева по Name */
            [M] table GetObjectById( const int* Id )         /* Возвращает первое найденный объект дерева по айди */
            [M] table GetObject( const char* ItemName )      /* Возвращает первый найденный объект дерева по тегу */
            [M] table GetTreeByCustomKey( string CustomKey )        /* Возвращает первое найденное дерево по пользовательскому параметру. Пользовательские ключи задаются в PARSER.KEYS */
            [M] table GetTreeByName( const char* TreeObjName )      /* Возвращает первое найденное дерево по Name внутри дерева */
            [M] table GetTreeById( const int* Id )          /* Возвращает первое найденное дерево по айди внутри дерева */
            [M] table GetTree( const char* TreeName )       /* Возвращает первое найденное дерево по тегу внутри дерева */
            [M] int GetItemsAmount()     /* Возвращает количество items дерева */
            [M] int GetChildsAmount()    /* Возвращает количество подобъектов дерева */
            [M] table GetParams()    /* Возвращает все параметры дерева */
            [M] table GetItems()     /* Возвращает все items дерева */
            [M] table GetChilds()    /* Возвращает все items дерева, имеющие подобъекты внутри себя */
            [M] bool Wrap()       /* Сворачивает выбранное дерево */
            [M] bool Unwrap()     /* Разворачивает выбранное дерево */
            [M] bool WrapAllItems()       /* Сворачивает все items дерева */
            [M] bool UnwrapAllItems()     /* Разворачивает все items дерева */
            [M] bool AddEnters()          /* Добавляет отступы между элементами, если нет */
            [M] bool CleanEnters()        /* Убирает отступы между элементами, если есть */
            [M] string AddAsTextField( const table* fieldParams, string TextFieldValue, bool Enters )    /* Добавляет fieldParams дерево как поле текста со значением TextFieldValue. Делает отсупы если Enters = true */
            [M] string ReadAsTextField( const table* fieldParams, bool CutTabs )       /* Возвращает содержимое между тегами дерева, ищет по fieldParams. Удаляет табуляцию в возвращаемом значении, если CutTabs = true */
            [M] string EditAsTextField( const table* fieldParams, string TextFieldNewValue )         /* Редактирует fieldParams дерево как поле текста с новым значением TextFieldNewValue */


            Class OBJ
            {
                [M] OBJ GetObj( table ObjectTagXorCustomKey, string CustomKeyValue ) : public TREE       /* Это прямое обращение к объекту OBJ: [{"TagName", "Name"}, "bibka"]. Пользовательские ключи задаются в PARSER.KEYS */
                {
                    [M] string GetName()         /* Возвращает имя тега объекта */
                    [M] string GetObjName()      /* Возвращает Name объекта */
                    [M] AIParam GetProperty( const char* PropertyName )     /* Возвращает значение параметра объекта. Имеются интерпретации значения: [.AsInt] - возвращает целое число, [.AsString] - возвращает строку, [.AsFloat] - возвращает число с запятой, [.AsBoolean] - возвращает логическое значение, [.AsRUchars] - возвращает строку с переведенными английскими буквами на русские буквы, [.AsENchars] - возвращает строку с переведенными русскими буквами на английские буквы */
                    [M] table GetProperties()                               /* Возвращает все параметры объекта */
                    [M] bool SetProperty( const char* PropertyName, const CStr& PropertyValue )                 /* Устанавливает новое значение параметра объекта */
                    [M] bool AddProperty( const char* PropertyName, const CStr& PropertyValue, bool Spaces )    /* Добавляет новый параметр объекта. bool Spaces добавляет пробелы (отступы) между значениями добавляемого параметра */
                    [M] bool RemoveProperty( const char* PropertyName )       /* Удаляет параметр объекта */
                    [M] string GetParentName()        /* Возвращает имя тега родительского дерева */
                    [M] bool Wrap()       /* Сворачивает выбранный объект */
                    [M] bool Unwrap()     /* Разворачивает выбранный объект */
                }
            }
        }
    }

    /* Экспериментальная ветка скриптов. Позволяет управлять триггерами других карт */
    Class TRIGGER
    {
        [M] TRIGGER trigger( string TriggerName ) : public XMLParser     /* Это прямое обращение к триггеру TRIGGER. Используйте [XMLParser:init()] перед выполнением команд */
        {
            [M] bool Add( self, int Active, table Events, table Script)      /* Добавляет триггер с именем TriggerName, ивентами Events и скриптом Script. Events и Script это таблицы, содержащие отдельные строки, где каждая строка это строка скрипта/объекта ивента */
            [M] bool Remove()        /* Удаляет триггер с именем TriggerName */
            [M] bool DoScript()      /* Безопасно выполняет скрипт триггера. Возвращает вторым значением ошибку в противном случае. Глобальные игровые методы trigger недоступны - пожалуйста, откажитесь от методов или переопределяйте trigger внутри скрипта триггера, чтобы DoScript() выполнился корректно. В противном случае в скрипте триггера есть ошибка. Помните, что манипулирование объектами на других картах извне невозможно */
            [M] bool IsActive()      /* Возвращает состояние триггера */
            [M] bool SetActive( bool Active )     /* Назначает состояние триггера */
            [M] string GetBody()     /* Возвращает скрипт триггера как строку */
            [M] table GetScript()    /* Возвращает скрипт триггера как строковую таблицу */
            [M] string GetScriptByLine( self, int Line )            /* Возвращает строку скрипта триггера по номеру строки (относительно) */
            [M] int GetLineByScriptContent( self, string Content )  /* Возвращает номер строки скрипта триггера по содержимому строки (относительно) */
            [M] bool ReplaceScript( self, string NewScript )        /* Заменяет скрипт триггера новым скриптом [[]] */
            [M] bool AddScript( self, string Script, int Line )     /* Добавляет новую часть скрипта в триггер с позицией Line, иначе в конец триггера */
            [M] void RemoveScript()     /* Удаляет скрипт триггера */
            [M] bool RemoveScriptLine( self, int Line or string Content )     /* Удаляет строку скрипта триггера по номеру строки или по содержимому (относительно) */
            [M] table GetAllEvents()    /* Возвращает все ивенты триггера. Ключами ивентов могут быть: [eventid], [timeout], [ObjName], [msgid], [flypath] */
            [M] event[table] GetEventById( self, const char* EventId )                        /* Возвращает ивент триггера по имени eventid. Ключами ивентов могут быть: [eventid], [timeout], [ObjName], [msgid], [flypath] */
            [M] event[table] GetEventByKey( self, const char* EventKey, string EventValue )   /* Возвращает ивент триггера по ключу ивента и его значению. Ключами ивентов могут быть: [eventid], [timeout], [ObjName], [msgid], [flypath] */
            [M] bool AddEvent( table event )        /* Добавляет новый ивент в триггер. Ключами ивентов могут быть: [eventid], [timeout], [ObjName], [msgid], [flypath] */
            [M] bool RemoveEvent( table event )     /* Удаляет ивент из триггера. Ключами ивентов могут быть: [eventid], [timeout], [ObjName], [msgid], [flypath] */
        }
    }
}
```

### Пример использования методов

```lua
local XMLParser = g_XMLParser    --> Получаем объект парсера lua-модуля, загруженного с помощью кода выше
if XMLParser then
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

<Key Name="Текст">Первая строка текста
    Вторая строка текста
</Key>

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

## СОВЕТЫ

- Если вы читаете небольшие файлы, можете использовать образец выше с `XMLParser:init()`. Его легко контролировать и проводить всякие проверки.

- Если вы читаете огромные файлы со сложной структурой, настоятельно рекомендую рассмотреть вариант с "очередью": `openQueue()` и `closeQueue()`. Он будет наиболее "оптимизированным" вариантом, который лучше справляется с большими файлами - игра заметно меньше страдает. Этот вариант сложнее поддается на проверки.
Приведу несколько готовых скриптов-примеров:
```lua
--Получим XMLParser-объект игрока из сохранения и отдельно запишем ему новое значение денег
local path_to_savefile = 'data\\profiles\\Player\\saves\\00000000\\maps\\currentmap.xml'
XMLParser:openQueue( path_to_savefile )
local PLAYER = XMLParser:GetItemFromFile('Name%s*=%s*"Player1"', "Object", "DynamicScene")
XMLParser:SetItemValueInFile('Name%s*=%s*"Player1"', "Object", "DynamicScene", 'Money', '%d*', '99999999')
XMLParser:closeQueue()
```
```lua
--Изменим текст некоторых реплик из dialogsglobal.xml
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
```lua
--Найдем и удалим все ненужные объекты из world.xml
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

## ПОДРОБНЕЕ

Эту и другую информацию вы сможете найти в файле проекта или найти примеры работы парсера в моде ExplorerMod от того же автора.


## КОММЕНТАРИИ АВТОРА

    E Jet: Это заколдованный парсер в котором хочется срать.

Благодарность за идею скрипта захвата атрибутов: [stakanyash](https://github.com/stakanyash).
