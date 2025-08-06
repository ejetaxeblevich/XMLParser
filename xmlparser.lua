-- ============================================================
-- ============================================================
-- 
-- 
--               ПЕРВЫЙ В ИСТОРИИ LUA-МОДУЛЬ,
-- 
--          написанный специально для игры Ex Machina 
--              (жопой для жопы руками из жопы)
--
--                      XMLParser 1.0
-- 
-- 
-- ===================== Автор E Jet ==========================
-- ============================================================
-- 
--     Note: Please translate this text, if it nessesary.
-- 
-- 
-- ======================= ЧТО ЭТО ============================
-- 
-- 
--      Универсальный lua-модуль, который может использоваться
-- для ЧТЕНИЯ и ЗАПИСИ .xml файлов через скрипты любой 
-- модификации внутри игры.
--      Вы сможете прочитать xml дерево, получить значения его 
-- объектов и использовать их в игре. Кроме того, здесь имеется,
-- не весть какой, но конструктор, который позволит вам создавать 
-- файлы, а затем записывать/читать деревья и объекты внутри них.
-- 
--      Почему это "модуль" а не любой другой файл с lua скриптами?
-- Хотя он таким и является...
--      Потому что этот файл - таблица функций XMLParser 
-- (далее класс), который имеет свои собственные методы и функции. 
-- Или че-то типа похожее короче.
--
------------------------- Дисклеймер -----------------------
--
--      АВТОР ЭТОГО ТВОРЕНИЯ ДУМАЕТ ЧТО ЗНАЕТ, КАК ПРАВИЛЬНО
-- НАЗЫВАТЬ ВЕЩИ В ПРОГРАММИРОВАНИИ, ПОЭТОМУ ПРОСЬБА ДЛЯ
-- ПРОГРАММИСТОВ ЗДОРОВОГО ЧЕЛОВЕКА - ПОНЯТЬ И ПРОСТИТЬ, ЕСЛИ 
-- ЗДЕСЬ ЧТО-ТО(ВСЕ) НЕ ТАК. 
--      АВТОР ПОНИМАЕТ И ПРИНИМАЕТ, ЧТО ВЕСЬ КОД НИЖЕ И ЭТОТ
-- ТЕКСТ НАПИСАН ПЛОХО И ГРОМОЗДКО, ЧТО ДАЖЕ В ЭТОМ ЗАНЯТИИ
-- НЕТ НИ МАЛЕЙШЕГО СМЫСЛА - КАК И СМЫСЛА В ЭТОМ КАПСОМ 
-- НАПИСАННОМ ДИСКЛЕЙМЕРЕ.
--
--      LUA-МОДУЛЬ РАСПРОСТРАНЯЕТСЯ СВОБОДНО "КАК ЕСТЬ" И 
-- ИСПОЛЬЗУЕТСЯ ИГРОЙ EX MACHINA / HARD TRUCK APOCALYPSE ДЛЯ  
-- ЧТЕНИЯ, ИЗМЕНЕНИЯ, СОЗДАНИЯ, А ТАКЖЕ УДАЛЕНИЯ(!) ФАЙЛОВ НА  
-- ВАШЕМ КОМПЬЮТЕРЕ И МОЖЕТ БЫТЬ ИЗМЕНЕН ЛЮБЫМ ДРУГИМ 
-- ПОЛЬЗОВАТЕЛЕМ (МОДДЕРОМ) ВНУТРИ СВОИХ МОДИФИКАЦИЙ И ПРОЧИХ 
-- РЕСУРСАХ.
--      АВТОР НЕ НЕСЕТ ОТВЕТСТВЕННОСТИ ЗА КАКИЕ ЛИБО ПОСЛЕДСТВИЯ, 
-- ПОВЛЕКШИХ ЗА СОБОЙ УЩЕРБ ВО ВРЕМЯ ИСПОЛЬЗОВАНИЯ ЭТОГО, А
-- ТАКЖЕ ЛЮБОЙ ДРУГОЙ, В Т.Ч. ИЗМЕНЕННОЙ ВЕРСИИ LUA-МОДУЛЯ ИЛИ
-- ЧАСТЕЙ КОДА, ПОЗАИМСТВОВАННЫХ (ПЕРЕПИСАННЫХ) ИЗ ЭТОГО ФАЙЛА.
-- 
---------------------------------------------------------------
-- 
-- ============================================================
--
-- ================= КАК ЭТО ИСПОЛЬЗОВАТЬ =====================
-- 
-- 
--      Для полноценного lua-модуля этой поделке еще далеко, 
-- поэтому ее не нужно устанавливать как библиотеку Lua в системе.
-- 
--      В игру этот lua-модуль загружается двумя способами: через 
-- require() или dofile(). Это внутренние Lua команды игры. 
-- Наш знакомый EXECUTE_SCRIPT не подойдет, так как он не возвращает 
-- объект модуля.
--      Чем отличается require() от dofile()? 
--      - require() загружает файл в игру при первом выполнении
-- и держит в памяти игры до перезапуска. Эта команда используется 
-- для подгрузки модулей здорового человека, которые устанавливаются 
-- в систему (но необязательно);
--      - dofile() загружает в память игры файл столько раз, 
-- сколько был вызван. Очищается весь внутренний кеш lua-модуля и
-- принимаются настройки по умолчанию. Рекомендуется для отладки и
-- прочего дебага.
--      Рекомендую прописывать команду в начало файла server.lua
-- игры, поскольку могут использоваться в модуле команды, которые 
-- грузятся в игру чуть раньше сервера ("могут"? автор альцгеймер!).
--
--      В качестве аргумента функции указывается локальный путь до 
-- файла модуля.
--      Возвращаемая таблица помещается в глобальную переменную, 
-- которая будет использована как объект, на который будут 
-- применяться методы (функции) этого модуля через двоеточие. 
--
-- Чтобы было понятнее, вспомним как мы обращаемся к машине игрока: 
-- [[
--      local Plv = GetPlayerVehicle()
--      if Plv then
--          Plv:SetSkin(1)
--      end /\/\/\/\/\/\/\
-- ]]
-- Или к обжект контейнеру:
-- [[
--      local Gde = CVector(1,2,3)
--      local Gde.y = g_ObjCont:GetHeight(Gde.x, Gde.z)
-- ]]                 /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
-- 
--      После загрузки модуля в игру следует инициализировать
-- его работу через метод init(). Это необходимо, чтобы указать
-- парсеру файл для "анализа" и имя главного корня xml (дерева).
-- Функция может быть вызвана вновь в любой момент.
--
---------------------- ФУНКЦИЯ init() ---------------------------
-- [[
--      XMLParser:init(path_to_file, root_tag_in_file, default_file_content, bLOG)
-- ]]
-- 
--  path_to_file            - путь к xml файлу [string]
--  root_tag_in_file        - имя главного xml корня (дерева) в файле [string]
--  default_file_content    - (необязательно) содержимое xml файла по умолчанию (при создании файла), указывается как пример example_content ниже [string]
--  bLOG                    - (необязательно) разрешает/запрещает принтить (выводить) всю дебаг информацию в лог и консоль игры [bool]
--
-- [[
--      local example_content = '<?xml version="1.0" encoding="windows-1251" standalone="yes" ?>\n<Root>\n<!-- здесь ваши данные -->\n</Root>'
-- ]]
-- 
-----------------------------------------------------------------
--
----------------- \/ Пример кода загрузки \/ --------------------
--
-- [[
--     --Поместите меня в начало server.lua
--     g_XMLParser = dofile("data\\gamedata\\lua_lib\\xmlparser.lua")
--     if not g_XMLParser then
--         LOG("[E] server.lua === Could not find global xmlparser.lua...")
--     else
--         g_XMLParser:init(
--             "data/gamedata/ModStats.xml", 
--             "ModStats"
--         )
--     end
-- ]]
--
---------------------------------------------------------------
--
-- ============================================================
--
-- ================= ТЕХНИКА БЕЗОПАСНОСТИ =====================
--
--
--      НАСТОЯТЕЛЬНО РЕКОМЕНДУЕТСЯ перед работой ознакомиться 
-- с памятками ниже [Что такое "дерево"] и [Что такое "объект"]
-- в понимании этого lua-модуля.
--      В противном случае гарантия правильной работы говно- 
-- парсера аннулируется.
--
--      КАТЕГОРИЧЕСКИ ЗАПРЕЩАЕТСЯ использовать в именах, 
-- значениях и прочих ключах следующие символы: </>"
--      А также рекомендуется отказаться от прочих управляющих
-- и неэкранированных уникальных символов (я поместил их в
-- "клетки" из [""] через запятую): ["\\"],["\""],["'"],["?"],
-- ["["],["]"],["("],[")"],["."],["^"],["$"],["*"],["+"],["-"],
-- ["%"].
--      В противном случае гарантия правильной работы говно- 
-- парсера аннулируется.
--
--      КАТЕГОРИЧЕСКИ ЗАПРЕЩАЕТСЯ использовать этот lua-модуль 
-- на файлах, размещаемых вне игры и модификации! Нет, нельзя!
--      Только Ex Machina и только модификации к ней! 
--
--      Запрещается создавать полностью одинаковые деревья с 
-- идентичными тегами и именами, даже внутри разных деревьев.
--      В противном случае гарантия правильной работы говно- 
-- парсера аннулируется.
--
--      Не рекомендуется использовать этот lua-модуль на важных
-- игровых xml файлах, так как в ходе внезапной неправильной
-- работы парсера сломаете игру. Делайте такие действия с
-- осторожностью.
--
--      Не рекомендуется использовать этот lua-модуль на сложных
-- xml структурах.    
--
--      ЗАПРЕЩАЕТСЯ использовать этот lua-модуль в своих модах
-- без указания авторства.
--      А то натравлю порчу и наколдую недельный понос >:(
--      Шутка :*
--
--
-- ============================================================
--
-- =================== ФУНКЦИИ И МЕТОДЫ =======================
--
--
--      Здесь собраны все публичнные функции этого модуля. У 
-- каждой функции имеется детальное описание что она делает. 
-- Прочтите описание парсера полностью, чтобы лучше понимать, 
-- что это за парацетамол. Пользуйтесь на здоровье!
--
--      Раскомментируйте дерево класса XMLParser, чтобы 
-- программа, через которую вы это читаете, смогла подсветить 
-- синтаксис для удобной навигации по функциям. Не забудьте 
-- закомментировать обратно! Или скопируйте его куда-то себе...
--
--      Обратите внимание, что дочерний класс должен вызывать 
-- главный метод своего родительского класса вплоть до XMLParser.
--
--      Также обратите внимание на то, что функции для
-- редактирования объектов и деревьев РАБОТАТЬ НЕ БУДУТ, если
-- применяются на подобъекты захватываемого дерева. 
--      Сначала вам следует сделать дерево-подобъект активным.
--
---------------------------------------------------------------
--
-- Class XMLParser
-- {
--     /* Основные функции */
--     [M] bool init( const char* path_to_file, const CStr& root_tag_in_file, const CStr& default_file_content, bool LOG )  /* Инициализирует парсер, перезатирает ранее установленные параметры парсера. bool LOG принтит дебаг информацию, если нужно отследить, что не нравится парсеру или где он ломается (Внимание! Принтит ОЧЕНЬ много мусора в лог игры и вызывает НАИСИЛЬНЕЙШУЮ утечку памяти) */
--     [M] bool createFile( const char* path, const CStr& default_file_content )     /* Создает (ПЕРЕЗАТИРАЕТ) файл и записывает в него базовый контент, указанный в default_file_content или в init(). По умолчанию это "data/gamedata/file_name.xml" */
--     [M] bool removeFile()       /* Удаляет файл, указанный в init(). По умолчанию это "data/gamedata/file_name.xml" */
--     [M] void AutoUpdateTree( bool Value )       /* Включает/отключает автоматическое обновление дерева TREE при каждом вызове дочерних методов TREE */
-- 
--     /* Сервисные функции. По возможности не используйте */
--     [M] void clearCache()       /* Сбрасывает глобальные переменные парсера в настройки по умолчанию. После этого необходимо снова инициализировать парсер через init() */
--     [M] table getCache()        /* Возвращает все глобальные переменные парсера. Индексы переменных можно посмотреть в логе игры, если включен bool LOG в init() */
--     [M] bool AddCommentNearItem( string comment, table itemParams )  /* Добавляет комментарий над элементом. Используйте [XMLParser:Tree( table treeParams ):init()] перед выполнением команды */
--     [M] string GetLineWithContent( int line, string Content )        /* Возвращает строку и ее номер из файла, ищет первое совпадение по Content, если указан (поддержка регулярных выражений). Используйте [XMLParser:Tree( table treeParams ):init()] перед выполнением команды */
--     [M] tuple RemoveLineWithContent( int line, string Content )      /* Удаляет строку в файле (Осторожно! Можно сломать разметку файла!). Возвращает истину, номер строки и само значение строки, в противном случае nil. Ищет первое совпадение по Content, если указан (поддержка регулярных выражений). Используйте [XMLParser:Tree( table treeParams ):init()] перед выполнением команды */
--     [M] bool addTree( table treeParams, table put_inParams, table includeKeysForSort )       /* Добавляет xml дерево в дерево table put_inParams, иначе в корень. Сортирует новые ключи параметров сверху вниз, если указаны. Сортируемые ключи сверху вниз по умолчанию: "id", "Id", "ObjectId", "Name", "name", "Amount", "Maximum", "Description" */
--     [M] bool addObject( table objectParams, table put_inParams, table includeKeysForSort)    /* Добавляет xml объект в дерево put_inParams, иначе в корень. Сортирует новые ключи параметров сверху вниз, если указаны. Сортируемые ключи сверху вниз по умолчанию: "id", "Id", "ObjectId", "Name", "name", "Value", "ListOfItems", "Chassis", "Cabin", "Cargo", "Skin", "ListOfGuns", "Name", "Status", "Item", "Description", "Difficulty", "Done" */
--     [M] bool removeTree( table treeParams )     /* Удаляет xml дерево */
--     [M] bool removeObject( table treeParams, table objectParams )     /* Удаляет xml объект в дереве */
--     [M] string Wrap( table objectParams )       /* Возвращает свернутый item */
--     [M] table Unwrap( table objectParams )      /* Возвращает развернутый item */
--     [M] tuple getTree( const table* treeParams, const char* put_in )    /* Возвращает все найденные параметры, items и все childs дерева, сложенного в put_in, иначе найдет первое вхождение или nil */
--     [M] table getItemFromLine( const table* content, const int* Line, const CStr& parentName, const char* parentTabs )       /* Возвращает найденный item из content, все его параметры и все вложенные дочерние item и их параметры, начиная с номера строки Line. Ищет закрывающий тег parentName вместе с parentTabs. Громоздкая и рекурсивная функция, дающая памяти игры утечь куда глаза глядят, если xml конструкция достаточно сложная */
--     [M] string getItemClass( const table* content, const int* curLine )     /* Проверяет item из content, под номером строки curLine и возвращает его класс: "tree", "object" */
--     [M] table GetTagAndCustomKeyFromItem( const table* itemParams )         /* Возвращает имя тега и пользовательский параметр item. Пользовательским ключом может быть: [Name], [name], [ObjectId], [Id], [id], [_customValue] */
-- 
-- 
--     /* Более полезные функции - пользуйтесь */
--     Class TREE 
--     {
--         [M] TREE Tree( table treeParams ) : public XMLParser     /* Это прямое обращение к дереву TREE. Используйте [XMLParser:Tree( table treeParams ):init()] перед выполнением команд. Во время использования команд аргумент в Tree() не нужен */
--         {
--             [M] bool init()      /* Обновляет содержимое TREE, перечитывает xml файл */
--             [M] bool IsObjectExists( table ObjectTagXorCustomKey )      /* Проверяет, существует ли такой объект в дереве: {"TagName", "ObjectParameter"}. Пользовательским ключом может быть: [Name], [name], [ObjectId], [Id], [id], [_customValue] */
--             [M] bool IsTreeExists( table TreeTagXorCustomKey )          /* Проверяет, существует ли такое дерево в дереве: {"TagName", "TreeParameter"}. Пользовательским ключом может быть: [Name], [name], [ObjectId], [Id], [id], [_customValue] */
--             [M] bool CaptureInnerTree( table TreeTagXorCustomKey )      /* Помещает найденное дерево внутри дерева в TREE (новое дерево становится активным). Пользовательским ключом может быть: [Name], [name], [ObjectId], [Id], [id], [_customValue] */
--             [M] bool Add( table itemParams, bool Enters, bool Spaces, table includeKeysForSort )         /* Добавляет новый item в дерево. bool Enters добавляет пробелы (отступы) сверху добавляемых объектов. bool Spaces добавляет пробелы (отступы) между значениями добавляемых объектов. Сортирует новые ключи параметров сверху вниз, если указаны. Сортируемые ключи по умолчанию определяются классом нового элемента */
--             [M] bool Remove( table itemParams or "self")       /* Удаляет item в дереве. Укажите аргументом строку "self" для удаления дерева TREE (активного дерева) */ 
--             [M] string GetName()        /* Возвращает имя тега дерева */
--             [M] string GetObjName()     /* Возвращает Name дерева */
--             [M] ??? GetCustomValue()    /* Возвращает _customValue дерева */
--             [M] bool SetParam( const char* ParameterName, const CStr& ParameterValue )      /* Устанавливает новое значение параметра дерева */
--             [M] AIParam GetParam( const char* ParameterName )    /* Возвращает значение параметра дерева. Имеются интерпретации значения: [.AsInt] - возвращает целое число, [.AsString] - возвращает строку, [.AsFloat] - возвращает число с запятой, [.AsBoolean] - возвращает логическое значение, [.AsRUchars] - возвращает строку с переведенными английскими буквами на русские буквы, [.AsENchars] - возвращает строку с переведенными русскими буквами на английские буквы */
--             [M] int GetParamsAmount()    /* Возвращает количество параметров дерева */
--             [M] bool AddParam( const char* ParameterName, const CStr& ParameterValue, bool Spaces )       /* Добавляет новый параметр дерева. bool Spaces добавляет пробелы (отступы) между значениями добавляемого параметра */
--             [M] bool RemoveParam( const char* ParameterName )        /* Удаляет параметр дерева */
--             [M] table GetObjectByCustomKey( string CustomKey )       /* Возвращает первый найденный объект дерева по пользовательскому параметру. Пользовательским ключом может быть: [Name], [name], [ObjectId], [Id], [id], [_customValue] */
--             [M] table GetObjectByName( const char* ItemObjName )     /* Возвращает первый найденный объект дерева по Name */
--             [M] table GetObjectById( const int* Id )         /* Возвращает первое найденный объект дерева по айди */
--             [M] table GetObject( const char* ItemName )      /* Возвращает первый найденный объект дерева по тегу */
--             [M] table GetTreeByCustomKey( string CustomKey )        /* Возвращает первое найденное дерево по пользовательскому параметру. Пользовательским ключом может быть: [Name], [name], [ObjectId], [Id], [id], [_customValue] */
--             [M] table GetTreeByName( const char* TreeObjName )      /* Возвращает первое найденное дерево по Name внутри дерева */
--             [M] table GetTreeById( const int* Id )          /* Возвращает первое найденное дерево по айди внутри дерева */
--             [M] table GetTree( const char* TreeName )       /* Возвращает первое найденное дерево по тегу внутри дерева */
--             [M] int GetItemsAmount()     /* Возвращает количество items дерева */
--             [M] int GetChildsAmount()    /* Возвращает количество подобъектов дерева */
--             [M] table GetParams()    /* Возвращает все параметры дерева */
--             [M] table GetItems()     /* Возвращает все items дерева */
--             [M] table GetChilds()    /* Возвращает все items дерева, имеющие подобъекты внутри себя */
--             [M] bool Wrap()       /* Сворачивает выбранное дерево */
--             [M] bool Unwrap()     /* Разворачивает выбранное дерево */
--             [M] bool WrapAllItems()       /* Сворачивает все items дерева */
--             [M] bool UnwrapAllItems()     /* Разворачивает все items дерева */
-- 
--             Class OBJ
--             {
--                 [M] object GetObj( table ObjectTagXorCustomKey ) : public Tree       /* Это прямое обращение к объекту OBJ: {"TagName", "ObjectParameter"}. Пользовательским ключом может быть: [Name], [name], [ObjectId], [Id], [id], [_customValue] */
--                 {
--                     [M] string GetName()         /* Возвращает имя тега объекта */
--                     [M] string GetObjName()      /* Возвращает Name объекта */
--                     [M] AIParam GetProperty( const char* PropertyName )     /* Возвращает значение параметра объекта. Имеются интерпретации значения: [.AsInt] - возвращает целое число, [.AsString] - возвращает строку, [.AsFloat] - возвращает число с запятой, [.AsBoolean] - возвращает логическое значение, [.AsRUchars] - возвращает строку с переведенными английскими буквами на русские буквы, [.AsENchars] - возвращает строку с переведенными русскими буквами на английские буквы */
--                     [M] table GetProperties()                               /* Возвращает все параметры объекта */
--                     [M] bool SetProperty( const char* PropertyName, const CStr& PropertyValue )                 /* Устанавливает новое значение параметра объекта */
--                     [M] bool AddProperty( const char* PropertyName, const CStr& PropertyValue, bool Spaces )    /* Добавляет новый параметр объекта. bool Spaces добавляет пробелы (отступы) между значениями добавляемого параметра */
--                     [M] bool RemoveProperty( const char* PropertyName )       /* Удаляет параметр объекта */
--                     [M] string GetParentName()        /* Возвращает имя тега родительского дерева */
--                     [M] bool Wrap()       /* Сворачивает выбранный объект */
--                     [M] bool Unwrap()     /* Разворачивает выбранный объект */
--                 }
--             }
--         }
--     }
-- }
--
---------------------------------------------------------------
--
--------------- \/ Пример использования методов \/ -------------
--
-- [[
--    local XMLParser = g_XMLParser                                                           --> Получаем объект парсера lua-модуля, загруженного с помощью кода выше
--    if XMLParser then
--        local tree = XMLParser:Tree({"Repository", "My Items"}):init()                      --> Инициализируем дерево с тегом "Repository" и параметром имени "My Items"
--        if tree then                                                                        --> Проверяем, существует ли такое дерево в файле
--            println("tree exists")
--            local getTree = XMLParser:Tree()                                                --> Добавляем дерево в локальную переменную
--            local getItem = getTree:GetObj({"Item", "Item01"})                              --> Пытаемся получить объект с тегом "Item" и именем "Item01" в этом дереве
--            if getItem then                                                                 --> Проверяем, существует ли такой объект
--                println("item exists")
--                local isItemParameterExists = getItem:GetProperty("MyParameter").AsBoolean  --> Представим, что наш параметр является строчным не булевым значением, тогда попытаемся узнать его существование
--                local getItemParameter = getItem:GetProperty("MyParameter").AsString        --> Пытаемся получить параметр "MyParameter" этого объекта в виде строки
--                if isItemParameterExists then                                               --> Проверяем, существует ли такой параметр
--                    println("parameter value exists")
--                    println(getItemParameter)                                               --> Принт значения этого параметра в консоль
--                end
--            end
--        end
--    end
-- ]]
--
---------------------------------------------------------------
--
-- ============================================================
--
-- ============= ОБРАЗЕЦ Params ДЕРЕВА/ОБЪЕКТА ================
--
-- [[
--      local itemParams = {                /* Это таблица с ключами */
--           _itemClass = "tree",           <-- Обязательный параметр. _itemClass задает сущность item. "tree" - для дерева, "object" - для объекта.
--           _itemTag = "TreeExample",      <-- Обязательный параметр. _itemTag задает имя открывающего тега item (и закрывающего для дерева).
--           Name = "Example"               <-- Необязательный, но очень рекомендуемый параметр. Ключевое значение, такое как (Name, name, ObjectId, Id, id) задает имя item внутри тегов. Незаменим для правильного поиска среди одинаковых тегов у объектов.
--      }                                   <-- Ниже могут быть любые другие параметры без нижнего подчеркивания. Название параметра может быть любым буквенным ключом, значение параметра - строка.
-- ]]
--
-- [[                                                | [[
--      local treeParams = {                         |       local objectParams = {
--          _itemClass = "tree",                     |           _itemClass = "object", 
--          _itemTag = "TreeExample",                |           _itemTag = "Object",
--          Name = "Example",                        |           ObjectId = "627",
--          Param1 = "6",                            |           Description = "huy",
--          Param2 = "true",                         |           Param3 = "true",
--          Description = "jopa",                    |           Param4 = "value",
--      }                                            |       }
-- ]]                                                | ]]
--
-- ============================================================
--
---------------------- Что такое "дерево" ---------------------
--
-- [[                                                |   [[
--      <RootTree>      <-- Открывающий тег          |           <TreeExample Name="Tree">
--      </RootTree>     <-- Закрывающий тег          |           </TreeExample>
-- ]]                                                |   ]]
--                                                   |
-- [[                                                |   [[
--      <Repository                                  |           <Aboba>       <-- Плохой пример дерева без уникального параметра имени или айди
--          Name="Пример"                            |           </Aboba>        
--          Description="I am a tree">               |   ]]        
--      </Repository>                                |           
-- ]]                                                |   
--
---------------------------------------------------------------
--
---------------------- Что такое "объект" ---------------------
--
-- [[                                                |   [[
--      <Ware                 <-- Открывающий тег    |           <Item Id="666" Value="true" />              <-- Объект 1
--          Name="Картошка"                          |
--      />                    <-- Закрывающий флажок |           <Item Name="Параметр2" Value="false" />     <-- Объект 2
-- ]]                                                |   ]]
--                                                   |
-- [[                                                |   [[
--      <Ending                                      |           
--          Name="Спасибо за игру!"                  |           <Object />       <-- Плохой пример
--          Description="Complete game" />           |           
-- ]]                                                |   ]]
--
---------------------------------------------------------------
--
-- ============================================================
--
-- ====================== ПОДРОБНЕЕ ===========================
--
--
--      Эту и другую информацию вы сможете найти на github  
-- проекта или найти примеры работы парсера в моде ExplorerMod 
-- от того же автора.
-- Ссылка на github автора: https://github.com/ejetaxeblevich
--
--
-- ================== КОММЕНТАРИИ АВТОРА ======================
-- 
-- E Jet: Это заколдованный парсер в котором хочется срать.
--
-- E Jet: Благодарность за идею stakanyash.
-- 
-- ============================================================
-- ============================================================


-- //////////////////////////// MODULE INIT /////////////////////////////////


local XMLParser = {}
XMLParser.__index = XMLParser
XMLParser.version = "1.0"

LOG("[I] Init Module XMLParser.lua "..XMLParser.version)


-- ////////////////////////// DEFAULT MODULE ITEMS //////////////////////////


local treeExample = {
    _itemClass = "tree", 
    _itemTag = "TreeExample", 
    Name = "Example",
    Amount = "1",
    Maximum = "3",
    Description = "jopa",
}

local itemExample = {
    _itemClass = "object", 
    _itemTag = "Object", 
    Name = "obj",
    Description = "value",
    Param3 = "value3",
    Param4 = "value4",
}

EX_ModStats_Repo = {
    _itemClass = "tree",
    _itemTag = "Repository", 
    Name = "TestObjects",
    Amount = "2",
    Maximum = "3"
}
EX_ModStats_Endi = {
    _itemClass = "object",
    _itemTag = "Ending", 
    Name = "Выжить",
    Description = "Сохранить зрение",
    Done = "true" --нет, false
}
EX_ModStats_Achi = {
    _itemClass = "object",
    _itemTag = "Achievement", 
    Name = "Я ебал эти скрипты",
    Description = "Заставить работать конструктор химулей",
    Done = "false"
}


-- ///////////////////////////// DEBUG FUNCTIONS ////////////////////////////


local function parserLOG(...)
    if EX_XMLParserLOG then
        for i, v in ipairs(arg) do
            LOG("[XMLParserLOG]: "..tostring(v))
        end
    end
end
local function parserPRINT(...)
    if EX_XMLParserLOG then
        for i, v in ipairs(arg) do
            println("[XMLParserPRINT]: "..tostring(v))
        end
    end
end


local function _TableToString(tbl, indent)
    parserLOG(":::: local function _TableToString ::::")
    if type(tbl)~="table" then 
        return ""..tostring(tbl) 
    end
    indent = indent or 0
    local result = ""
    for key, value in pairs(tbl) do
        if type(value) == "table" then
            result = result .. string.rep(" ", indent) .. key .. " = {\n" .. _TableToString(value, indent + 4) .. string.rep(" ", indent) .. "}\n"
        else
            result = result .. string.rep(" ", indent) .. key .. " = \"" .. tostring(value) .. "\"\n"
        end
    end
    return result
end


-- ///////////////////// DEFAULT MODULE GLOBAL VARS /////////////////////////


function XMLParser:clearCache()
    parserLOG(":::: global method XMLParser:clearCache ::::")
    parserLOG("Note: LOG is done. Please, use bLOG in XMLParser:init() for see parser LOG")
    
    EX_XMLParserPATH = "data/gamedata/file_name.xml"

    EX_XMLParserROOT = "Main"

    EX_DefaultXMLParserFileContent = '<?xml version="1.0" encoding="windows-1251" standalone="yes" ?>\n<'..tostring(EX_XMLParserROOT)..'>\n</'..tostring(EX_XMLParserROOT)..'>'

    EX_XMLParserLOG = false

    EX_XMLParserENTERS = false
    EX_XMLParserSPACES = false

    EX_AcceptableObjectClasses = {"tree", "object", "item"}

    EX_XMLPARSER_GLOBAL_AUTOUPDATE = false
    EX_XMLPARSER_GLOBAL_TREEDATA = {}
    EX_XMLPARSER_GLOBAL_TREEPARAMS = {}
    EX_XMLPARSER_GLOBAL_FILEDATA = {}
    EX_XMLPARSER_GLOBAL_TREEFIRSTLINE = nil
    EX_XMLPARSER_GLOBAL_TREELASTLINE = nil

    EX_XMLPARSER_CACHE_TREEPARAMS = nil
end

XMLParser:clearCache()



function XMLParser:getCache()
    parserLOG(":::: global method XMLParser:getCache ::::")

          LOG("[I] [1] EX_XMLParserLOG is {"..tostring(EX_XMLParserLOG).."}")
    parserLOG("[I] [2] EX_XMLParserENTERS is {"..tostring(EX_XMLParserENTERS).."}")
    parserLOG("[I] [3] EX_XMLParserSPACES is {"..tostring(EX_XMLParserSPACES).."}") 
    parserLOG("[I] [4] EX_XMLParserPATH is {"..tostring(EX_XMLParserPATH).."}")
    parserLOG("[I] [5] EX_XMLParserROOT is {"..tostring(EX_XMLParserROOT).."}")
    parserLOG("[I] [6] EX_XMLPARSER_GLOBAL_AUTOUPDATE is {"..tostring(EX_XMLPARSER_GLOBAL_AUTOUPDATE).."}")
    parserLOG("[I] [7] EX_AcceptableObjectClasses is \n{\n".._TableToString(EX_AcceptableObjectClasses).."\n}")
    parserLOG("[I] [8] EX_DefaultXMLParserFileContent is \n{\n"..tostring(EX_DefaultXMLParserFileContent).."\n}")
    parserLOG("[I] [9] EX_XMLPARSER_GLOBAL_TREEFIRSTLINE is {"..tostring(EX_XMLPARSER_GLOBAL_TREEFIRSTLINE).."}")
    parserLOG("[I] [10] EX_XMLPARSER_GLOBAL_TREELASTLINE is {"..tostring(EX_XMLPARSER_GLOBAL_TREELASTLINE).."}")
    parserLOG("[I] [11] EX_XMLPARSER_GLOBAL_TREEPARAMS is \n{\n".._TableToString(EX_XMLPARSER_GLOBAL_TREEPARAMS).."\n}")
    parserLOG("[I] [12] EX_XMLPARSER_CACHE_TREEPARAMS is \n{\n".._TableToString(EX_XMLPARSER_CACHE_TREEPARAMS).."\n}")
    parserLOG("[I] [13] EX_XMLPARSER_GLOBAL_TREEDATA is \n{\n".._TableToString(EX_XMLPARSER_GLOBAL_TREEDATA).."\n}")
    parserLOG("[I] [14] EX_XMLPARSER_GLOBAL_FILEDATA is \n{\n".._TableToString(EX_XMLPARSER_GLOBAL_FILEDATA).."\n}")

    parserLOG(":::: ^^^^ global method XMLParser:getCache ^^^^ ::::")

    return {EX_XMLParserLOG, EX_XMLParserENTERS, EX_XMLParserSPACES, EX_XMLParserPATH, EX_XMLParserROOT, EX_XMLPARSER_GLOBAL_AUTOUPDATE, EX_AcceptableObjectClasses, EX_DefaultXMLParserFileContent, EX_XMLPARSER_GLOBAL_TREEFIRSTLINE, EX_XMLPARSER_GLOBAL_TREELASTLINE, EX_XMLPARSER_GLOBAL_TREEPARAMS, EX_XMLPARSER_CACHE_TREEPARAMS, EX_XMLPARSER_GLOBAL_TREEDATA, EX_XMLPARSER_GLOBAL_FILEDATA}
end



-- ///////////////////////////// LOCAL FUNCTIONS ////////////////////////////



local function TranslateRUCharsToENChars(text)
    parserLOG(":::: local function TranslateRUCharsToENChars ::::")
    local translitTable = {
        ['а'] = 'a', ['б'] = 'b', ['в'] = 'v', ['г'] = 'g', ['д'] = 'd',
        ['е'] = 'e', ['ё'] = 'yo', ['ж'] = 'zh', ['з'] = 'z', ['и'] = 'i',
        ['й'] = 'y', ['к'] = 'k', ['л'] = 'l', ['м'] = 'm', ['н'] = 'n',
        ['о'] = 'o', ['п'] = 'p', ['р'] = 'r', ['с'] = 's', ['т'] = 't',
        ['у'] = 'u', ['ф'] = 'f', ['х'] = 'h', ['ц'] = 'ts', ['ч'] = 'ch',
        ['ш'] = 'sh', ['щ'] = 'sch', ['ъ'] = '', ['ы'] = 'y', ['ь'] = '',
        ['э'] = 'e', ['ю'] = 'yu', ['я'] = 'ya',

        ['А'] = 'A', ['Б'] = 'B', ['В'] = 'V', ['Г'] = 'G', ['Д'] = 'D',
        ['Е'] = 'E', ['Ё'] = 'Yo', ['Ж'] = 'Zh', ['З'] = 'Z', ['И'] = 'I',
        ['Й'] = 'Y', ['К'] = 'K', ['Л'] = 'L', ['М'] = 'M', ['Н'] = 'N',
        ['О'] = 'O', ['П'] = 'P', ['Р'] = 'R', ['С'] = 'S', ['Т'] = 'T',
        ['У'] = 'U', ['Ф'] = 'F', ['Х'] = 'H', ['Ц'] = 'Ts', ['Ч'] = 'Ch',
        ['Ш'] = 'Sh', ['Щ'] = 'Sch', ['Ъ'] = '', ['Ы'] = 'Y', ['Ь'] = '',
        ['Э'] = 'E', ['Ю'] = 'Yu', ['Я'] = 'Ya'
    }

    local result = ''

    for i = 1, string.len(text) do
        local char = string.sub(text, i, i)
        if translitTable[char] then
            result = result .. translitTable[char]
        else
            result = result .. char
        end
    end

    return result
end


local function TranslateENCharsToRUChars(text)
    parserLOG(":::: local function TranslateENCharsToRUChars ::::")
    local reverseTranslitTable = {
        ['a'] = 'а', ['b'] = 'б', ['v'] = 'в', ['g'] = 'г', ['d'] = 'д',
        ['e'] = 'е', ['yo'] = 'ё', ['zh'] = 'ж', ['z'] = 'з', ['i'] = 'и',
        ['y'] = 'й', ['k'] = 'к', ['l'] = 'л', ['m'] = 'м', ['n'] = 'н',
        ['o'] = 'о', ['p'] = 'п', ['r'] = 'р', ['s'] = 'с', ['t'] = 'т',
        ['u'] = 'у', ['f'] = 'ф', ['h'] = 'х', ['ts'] = 'ц', ['ch'] = 'ч',
        ['sh'] = 'ш', ['sch'] = 'щ', [''] = 'ъ', ['y'] = 'ы', [''] = 'ь',
        ['e'] = 'э', ['yu'] = 'ю', ['ya'] = 'я',

        ['A'] = 'А', ['B'] = 'Б', ['V'] = 'В', ['G'] = 'Г', ['D'] = 'Д',
        ['E'] = 'Е', ['Yo'] = 'Ё', ['Zh'] = 'Ж', ['Z'] = 'З', ['I'] = 'И',
        ['Y'] = 'Й', ['K'] = 'К', ['L'] = 'Л', ['M'] = 'М', ['N'] = 'Н',
        ['O'] = 'О', ['P'] = 'П', ['R'] = 'Р', ['S'] = 'С', ['T'] = 'Т',
        ['U'] = 'У', ['F'] = 'Ф', ['H'] = 'Х', ['Ts'] = 'Ц', ['Ch'] = 'Ч',
        ['Sh'] = 'Ш', ['Sch'] = 'Щ', [''] = 'Ъ', ['Y'] = 'Ы', [''] = 'Ь',
        ['E'] = 'Э', ['Yu'] = 'Ю', ['Ya'] = 'Я'
    }

    local result = ''

    local i = 1

    while i <= string.len(text) do
        local twoChar = string.sub(text, i, i + 1)
        local twoCharLower = string.lower(twoChar)
        if reverseTranslitTable[twoCharLower] then
            result = result .. reverseTranslitTable[twoCharLower]
            i = i + 2
        else
            local oneChar = string.sub(text, i, i)
            local oneCharLower = string.lower(oneChar)
            if reverseTranslitTable[oneCharLower] then
                result = result .. reverseTranslitTable[oneCharLower]
            else
                result = result .. oneChar
            end
            i = i + 1
        end
    end

    return result
end


local function GetRootTagInFile(path_to_file, root_tag_in_file)
    parserLOG(":::: local function GetRootTagInFile ::::")
    local root_tag_in_file = root_tag_in_file or ""
    local path_to_file = path_to_file or ""

    local file = io.open(path_to_file, "r")
    if not file then
        parserLOG("[E] Module XMLParser.lua === File '"..path_to_file.."' not found")
        parserPRINT("File '"..path_to_file.."' not found")
        return nil
    end

    local fast_content = file:read("*a")

    --LOG("filecontent: {"..tostring(fast_content).."}")

    if (string.find(fast_content, "<"..root_tag_in_file.."(\n*)")) and (string.find(fast_content, "</"..root_tag_in_file..">")) then
        fast_content = nil
        return true, file
    end

    return nil, file
end


local function WriteXMLParserFileForTable(content)
    parserLOG(":::: local function WriteXMLParserFileForTable ::::")
    if (not content) or (not type(content)=="table") then 
        return nil 
    end
    local path = EX_XMLParserPATH
    local file = io.open(path, "w")
    local l=1
    --LOG("START WRITING")
    while content[l]~=nil do
        --LOG("WRITED :: "..tostring(content[l]))
        file:write(content[l].."\n")
        l=l+1
    end
    file:close()
    file = nil
    content = nil
    return true
end


local function PackStringFromTable(tbl, bRemoveTABS)
    parserLOG(":::: local function PackStringFromTable ::::")
    local retVal = ""
    local savedTabs = ""
    if type(tbl)=="table" then 
        for i, v in ipairs(tbl) do
            if i==1 then
                local _,_,savedTabsssss = string.find(v, "(\t*)")
                if savedTabsssss then savedTabs = savedTabsssss end
                retVal = retVal .. "" .. v
            else
                retVal = retVal .. " " .. v
            end
        end
    else
        return tostring(tbl) 
    end
    if bRemoveTABS then
        retVal = string.gsub(retVal, "[\t*]", "")
    end
    retVal = savedTabs..retVal
    return retVal
end


local function UnwrapItemForCommentLines(comment)
    parserLOG(":::: local function UnwrapItemForCommentLines ::::")
    local commentExample = [[       <Comment line1="1" line2="2" line3="3" />]]
    local slicedCommentExample = [[       <Comment 
    line1="1"
    line2="2"
    line3="3"
    />]] --\n
    --[[
        lines = {
            '<Comment line1="1",',
            'line2="2",',
            'line3="3",',
        }
    ]]

    local findParamPattern = '[^<]*%s*=+%s*"[^"]*"'

    local savedTabs = ""
    local _, _, savedTabss = string.find(comment, "(\t*)<")
    if savedTabss then
        savedTabs = savedTabss
    end
    
    local comment = comment or commentExample

    comment = string.gsub(comment, '<([%w]*)%s+', '<%1\n')
    comment = string.gsub(comment, '"%s+', '"\n')
    comment = string.gsub(comment, '</([.]*)', '\n</%1')
    comment = string.gsub(comment, '>[^<]*<([.]*)', '>\n'..savedTabs..'\t<%1')
    comment = string.gsub(comment, '\n%s*/>', ' />')
    
    local lines = {}
    local start_pos = 1

    while true do
        local end_pos = string.find(comment, "\n", start_pos)
        if not end_pos then
            break
        end
        local line = string.sub(comment, start_pos, end_pos - 1)
        line = ""..line
        if lines[1] then
            line = savedTabs.."\t"..line
        end
        table.insert(lines, line)
        start_pos = end_pos + 1
    end

    if start_pos <= string.len(comment) then
        local last_line = string.sub(comment, start_pos)
        if lines[1] then
            last_line = savedTabs.."\t"..last_line
        else
            last_line = ""..last_line
        end
        table.insert(lines, last_line)
    end

    return lines
end


local function SliceParamsForCommentLines(comment)
    parserLOG(":::: local function SliceParamsForCommentLines ::::")
    local commentExample = [[       <Comment line1="1" line2="2" line3="3" />]]
    local slicedCommentExample = [[<Comment line1="1",
    line2="2",
    line3="3",
    />]] --\n
    --[[
        lines = {
            '<Comment line1="1",',
            'line2="2",',
            'line3="3",',
        }
    ]]
    
    local comment = comment or commentExample

    comment = string.gsub(comment, '"%s+', '",\n')
    comment = string.gsub(comment, '[\t*]', '')
    
    local lines = {}
    local start_pos = 1

    while true do
        local end_pos = string.find(comment, "\n", start_pos)
        if not end_pos then
            break
        end
        local line = string.sub(comment, start_pos, end_pos - 1)
        line = " "..line
        table.insert(lines, line)
        start_pos = end_pos + 1
    end

    if start_pos <= string.len(comment) then
        local last_line = string.sub(comment, start_pos)
        last_line = " "..last_line
        table.insert(lines, last_line)
    end

    return lines
end


local function getLineNumberFromSymbolPosition(content, charPosition)
    parserLOG(":::: local function getLineNumberFromSymbolPosition ::::")
    local lineNumber = 1
    for i = 1, charPosition do
        if string.sub(content, i, i) == "\n" then
            lineNumber = lineNumber + 1
        end
    end
    return lineNumber
end


local function CheckXMLParserFileForTree(treeParams, bNotReturnContent)
    parserLOG(":::: local function CheckXMLParserFileForTree ::::")
    local treeParams = treeParams or treeExample

    local tree_name
    local tree_objName
    if type(treeParams)~="table" then
        tree_name = treeParams or EX_XMLParserROOT
        tree_objName = nil
    else
        tree_name = treeParams["_itemTag"] or EX_XMLParserROOT
        tree_objName = treeParams["Name"] or treeParams["name"] or treeParams["ObjectId"] or treeParams["Id"] or treeParams["id"] or treeParams["_customValue"] or nil
    end

    local path_to_file = EX_XMLParserPATH
    local root_tag_in_file = EX_XMLParserROOT
    local exists, file = GetRootTagInFile(path_to_file, root_tag_in_file)
    if not exists then
        parserLOG("[E] Module XMLParser.lua === File '"..tostring(path_to_file).."' without root tag <"..tostring(root_tag_in_file)..">")
        parserPRINT("File '"..tostring(path_to_file).."' without root tag <"..tostring(root_tag_in_file)..">")
        return nil
    end

    file:seek("set",0)
    local content = {}
    local v = 1
    for line in file:lines() do
        content[v] = line
        v=v+1
    end

    file:seek("set",0)
    local fast_content = file:read("*a")
    file:close()
    file = nil

    if not (string.find(fast_content, "<"..tree_name.."(\n*)")) or not (string.find(fast_content, "</"..tree_name..">")) then
        parserLOG("[E] Module XMLParser.lua === Tree <"..tree_name.."> in '"..EX_XMLParserPATH.."' not found")
        parserPRINT("Tree <"..tree_name.."> in '"..EX_XMLParserPATH.."' not found")
        content = nil
        return nil
    end

    local firstLine, lastLine = 0, 0
    for i, value in ipairs(content) do
        if string.find(value, "<"..tree_name) then
            firstLine = i+1
        elseif string.find(value, "</"..tree_name..">") then
            lastLine = i+1
            break
        end
    end

    if (tree_objName) and (tree_objName~="") then
        parserLOG("\\\\ "..tree_objName)
        local gdeStart, gdeEnd, fnd_tree_objName = string.find(fast_content, "<"..tree_name..'[^>]*%s+Name%s*=+%s*"'..tree_objName..'"')
        if gdeStart then
            local ankerTree = string.sub(fast_content, gdeStart, gdeEnd)
            parserLOG("{"..ankerTree.."}")
            firstLine = getLineNumberFromSymbolPosition(fast_content, gdeStart)
            lastLine = firstLine
            while string.find(content[lastLine], "</"..tree_name..">")==nil do
                --parserLOG("<> "..content[lastLine])
                lastLine = lastLine + 1
            end
            parserLOG(">>> "..content[firstLine])
            parserLOG(">>> "..content[lastLine])
            parserLOG("[I] Module XMLParser.lua === Finded tree <"..tree_name.."> in '"..EX_XMLParserPATH.."' with name \""..tree_objName.."\", "..gdeStart..";"..gdeEnd)
            parserPRINT("Finded tree <"..tree_name.."> in '"..EX_XMLParserPATH.."' with name \""..tree_objName.."\", "..gdeStart..";"..gdeEnd)
        end
    end

    if bNotReturnContent then
        content = nil
    end
    return fast_content, content, firstLine, lastLine
end


local function CheckItemClass(put_inParams, itemParams, whoChecker)
    parserLOG(":::: local function CheckItemClass ::::")
    local whoChecker = whoChecker or {}
    local put_in = put_inParams["_itemClass"] or "tree"
    if not itemParams["_itemClass"] then
        parserLOG("[E] Module XMLParser.lua === Attempt to check unknown class item for \""..put_in.."\" in '"..EX_XMLParserPATH.."'")
        error("XMLParser: Attempt to check unknown class item for \""..put_in.."\" in '"..EX_XMLParserPATH.."'")
        return nil
    end
    local classExists, i = false, 1
    while EX_AcceptableObjectClasses[i]~=nil do
        if EX_AcceptableObjectClasses[i]==itemParams["_itemClass"] then
            classExists = true
        end
        i=i+1
    end
    if not classExists then
        parserLOG("[E] Module XMLParser.lua === Attempt to check unknown class item for \""..put_in.."\" in '"..EX_XMLParserPATH.."'")
        error("XMLParser: Attempt to check unknown class item for \""..put_in.."\" in '"..EX_XMLParserPATH.."'")
        return nil
    end
    i=1
    while whoChecker[i]~=nil do
        if itemParams["_itemClass"]==whoChecker[i] then
            parserLOG("[E] Module XMLParser.lua === Attempt to check conflict class item for \""..put_in.."\" in '"..EX_XMLParserPATH.."'")
            error("XMLParser: Attempt to check conflict class item for \""..put_in.."\" in '"..EX_XMLParserPATH.."'")
            return nil
        end
        i=i+1
    end
    return true
end


local function CheckXMLParserFileTreeForItem(treeParams, itemParams)
    parserLOG(":::: local function CheckXMLParserFileTreeForItem ::::")
    local treeParams = treeParams or treeExample
    local itemParams = itemParams or itemExample

    local put_in = treeParams
    if not CheckItemClass(put_in, itemParams) then
        return nil
    end

    local itemParamForSearch = itemParams["Name"] or itemParams["name"] or itemParams["ObjectId"] or itemParams["Id"] or itemParams["id"] or itemParams["_customValue"] or nil

    local treeData, content, firstLine, lastLine = XMLParser:getTree(treeParams)
    local item = 1
    local items = treeData[2]
    if items then
        local itemssss = treeData[2][item]
        if itemssss then
            while treeData[2][item]~=nil do
                local Obj = treeData[2][item]["_itemTag"]
                local ObjClass = treeData[2][item]["_itemClass"]
                local ObjParamForSearch
                if itemParams["Name"]           then ObjParamForSearch = treeData[2][item]["_itemProperties"]["Name"] 
                elseif itemParams["name"]       then ObjParamForSearch = treeData[2][item]["_itemProperties"]["name"]
                elseif itemParams["ObjectId"]   then ObjParamForSearch = treeData[2][item]["_itemProperties"]["ObjectId"]
                elseif itemParams["Id"]         then ObjParamForSearch = treeData[2][item]["_itemProperties"]["Id"]
                elseif itemParams["id"]         then ObjParamForSearch = treeData[2][item]["_itemProperties"]["id"]
                elseif itemParams["_customValue"] then ObjParamForSearch = treeData[2][item]["_itemProperties"][itemParams["_customValue"]] end
                if (itemParams["_itemClass"]=="tree") and ((Obj==itemParams["treeName"]) and (ObjParamForSearch==itemParamForSearch) and (ObjClass==itemParams["_itemClass"])) then
                    parserLOG("[E] Module XMLParser.lua === "..tostring(itemParams["_itemTag"]).." with class '"..tostring(itemParams["_itemClass"]).."' and value \""..tostring(itemParamForSearch).."\" in tree <"..tostring(treeName).."> '"..EX_XMLParserPATH.."' already exists")
                    parserPRINT("[E] Module XMLParser.lua === "..tostring(itemParams["_itemTag"]).." with class '"..tostring(itemParams["_itemClass"]).."' and value \""..tostring(itemParamForSearch).."\" in tree <"..tostring(treeName).."> '"..EX_XMLParserPATH.."' already exists")
                    return true, itemParams, content, firstLine, lastLine 
                end
                item=item+1
            end
        end
    end

    return nil, itemParams, content, firstLine, lastLine 
end


local function CheckXMLParserFileTreeForTree(treeParams_put_in, treeParams)
    parserLOG(":::: local function CheckXMLParserFileTreeForTree ::::")
    local treeParams_put_in = treeParams_put_in or EX_XMLParserROOT
    local treeParams = treeParams or treeExample

    local treeParamForSearch = treeParams["Name"] or treeParams["name"] or treeParams["ObjectId"] or treeParams["Id"] or treeParams["id"] or treeParams["_customValue"] or nil

    local treeData, content, firstLine, lastLine = XMLParser:getTree(treeParams_put_in)
    local tree = 1
    local trees = treeData[2]
    if trees then
        local treessss = treeData[2][tree]
        if treessss then
            while treeData[2][tree]~=nil do
                local Obj = treeData[2][tree]["_itemTag"]
                local ObjClass = treeData[2][tree]["_itemClass"]
                local ObjParamForSearch
                if itemParams["Name"]           then ObjParamForSearch = treeData[2][item]["_itemProperties"]["Name"] 
                elseif itemParams["name"]       then ObjParamForSearch = treeData[2][item]["_itemProperties"]["name"]
                elseif itemParams["ObjectId"]   then ObjParamForSearch = treeData[2][item]["_itemProperties"]["ObjectId"]
                elseif itemParams["Id"]         then ObjParamForSearch = treeData[2][item]["_itemProperties"]["Id"]
                elseif itemParams["id"]         then ObjParamForSearch = treeData[2][item]["_itemProperties"]["id"]
                elseif itemParams["_customValue"] then ObjParamForSearch = treeData[2][item]["_itemProperties"][itemParams["_customValue"]] end
                if (treeParams["_itemClass"]=="tree") and ((Obj==treeParams["treeName"]) and (ObjParamForSearch==treeParamForSearch) and (ObjClass==treeParams["_itemClass"])) then
                    parserLOG("[E] Module XMLParser.lua === "..tostring(treeParams["_itemTag"]).." with value \""..tostring(treeParamForSearch).."\" in tree <"..tostring(treeName).."> '"..EX_XMLParserPATH.."' already exists")
                    parserPRINT("[E] Module XMLParser.lua === "..tostring(treeParams["_itemTag"]).." with value \""..tostring(treeParamForSearch).."\" in tree <"..tostring(treeName).."> '"..EX_XMLParserPATH.."' already exists")
                    return true, treeParams, content, firstLine, lastLine 
                end
                tree=tree+1
            end
        end
    end

    return nil, treeParams, content, firstLine, lastLine 
end


--Функция импортирована из мода ExplorerMod
--Функция возвращает путь установленной игры
local function _GetExeGamePath()
    parserLOG(":::: local function _GetExeGamePath() ::::")
	local ExeGamePath = "С:/"
	local LOG = io.open("exmachina.log","r+")
	if LOG then
		for logLine in LOG:lines() do
			local ExeGamePathfnd = string.find(logLine, 'Path: ')
			if ExeGamePathfnd then
				local strlen = string.len(logLine)
				ExeGamePath = string.sub(logLine, ExeGamePathfnd+6, strlen)
				break
			end
		end
		LOG:close()
	end

	ExeGamePath = string.gsub(ExeGamePath, "\\", "\\\\")
	ExeGamePath = string.gsub(ExeGamePath, "/", "\\\\")

	return ExeGamePath
end


local function _CopyTable(orig)
    parserLOG(":::: local function _CopyTable ::::")
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[_CopyTable(orig_key)] = _CopyTable(orig_value)
        end
        setmetatable(copy, _CopyTable(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end



local function _INTERPRETATION(Value)
    parserLOG(":::: local function _INTERPRETATION ::::")
    local interpreters = {
        AsBoolean = function()
            if Value=="nil" then return nil end
            if Value=="true" then return true end
            if Value=="false" then return false end
            if Value=="" then return nil end
            if Value then return true else return nil end
        end,
        AsString = function()
            if not Value then Value = "nil" end
            local v = tostring(Value)
            if v then return v end
            return Value
        end,
        AsInt = function()
            if not Value then Value = -1.0 end
            local v = math.floor(tonumber(Value))
            if v then return v end
            return Value
        end,
        AsFloat = function()
            if not Value then Value = -1.0 end
            local v = tonumber(Value)
            if v then return v end
            return Value
        end,
        AsENchars = function()
            if not Value then Value = "nil" end
            local v = tostring(Value)
            if v then v = TranslateRUCharsToENChars(v) end
            if v then return v end
            return Value
        end,
        AsRUchars = function()
            if not Value then Value = "nil" end
            local v = tostring(Value)
            if v then v = TranslateENCharsToRUChars(v) end
            if v then return v end
            return Value
        end
    }
    
    local metatable = setmetatable({}, {
        __index = function(_, key)
            local interpreter = interpreters[key]
            if interpreter then
                return interpreter()
            else
                return Value
            end
        end,
        __call = function()
            return Value
        end,
        __tostring = function()
            return tostring(Value)
        end
    })

    return metatable
end


local function ____table_contains(tbl, value)
    parserLOG(":::: local function ____table_contains ::::")
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end




-- ///////////////////////////////////////////////////////////////////////////////

-- //////////////////////// GLOBAL MODULE FUNCTIONS //////////////////////////////

-- ///////////////////////////////////////////////////////////////////////////////



--g_XMLParser:init()
function XMLParser:init(path_to_file, root_tag_in_file, default_file_content, bLog)
    parserLOG(":::: global method XMLParser:init ::::")
    local path_to_file = path_to_file or EX_XMLParserPATH
    local default_file_content = default_file_content or EX_DefaultXMLParserFileContent
    local root_tag_in_file = root_tag_in_file or EX_XMLParserROOT

    local exists, file = GetRootTagInFile(path_to_file, root_tag_in_file)
    if not exists then
        LOG("[E] Module XMLParser.lua === File '"..tostring(path_to_file).."' without root tag <"..tostring(root_tag_in_file)..">")
        println("File '"..tostring(path_to_file).."' without root tag <"..tostring(root_tag_in_file)..">")
        return nil
    end

    if bLog then
        EX_XMLParserLOG = true
    else
        EX_XMLParserLOG = false
    end

    EX_XMLParserPATH = path_to_file
    EX_XMLParserROOT = root_tag_in_file
    EX_DefaultXMLParserFileContent = default_file_content

    return true, file
end


-- ///////////////////////////////////////////////////////////////////////////////


--g_XMLParser:createFile()
function XMLParser:createFile(path, default_file_content)
    parserLOG(":::: global method XMLParser:createFile ::::")
    local path = path or EX_XMLParserPATH
    local file = io.open(path, "w")
    local default_file_content = default_file_content or EX_DefaultXMLParserFileContent
    if default_file_content then EX_DefaultXMLParserFileContent = default_file_content end
    file:write(EX_DefaultXMLParserFileContent)
    file:close()
    file = nil
    return true
end

--g_XMLParser:removeFile()
function XMLParser:removeFile()
    parserLOG(":::: global method XMLParser:removeFile ::::")
    local path = _GetExeGamePath()..EX_XMLParserPATH
    local file = io.open(path, "r")
    if file then
        os.remove(path)
        return true
    end
    return false
end



--g_XMLParser:addTree({_itemClass = "tree", _itemTag = "ExampleTree2"}, "TreeExample")
function XMLParser:addTree(treeParams, put_in, includeKeysForSort)
    parserLOG(":::: global method XMLParser:addTree ::::")
    local treeParams = treeParams or treeExample

    local treeObjName = treeParams["_itemTag"] or "Tree"

    local put_inParams = {
        _itemClass = put_in["_itemClass"] or "tree",
        _itemTag = put_in["_itemTag"] or EX_XMLParserROOT,
        _itemLine = put_in["_itemLine"] or EX_XMLPARSER_GLOBAL_TREEFIRSTLINE,
        Name = put_in["Name"] or nil,
        name = put_in["name"] or nil,
        ObjectId = put_in["ObjectId"] or nil,
        Id = put_in["Id"] or nil,
        id = put_in["id"] or nil,
        _customValue = put_in["_customValue"] or nil
    }

    if not put_inParams["_itemClass"]=="tree" then
        parserLOG("[E] Module XMLParser.lua === Invalid item class")
        error("XMLParser: Invalid item class")
    end

    local fast_content, content, firstLine, lastLine = CheckXMLParserFileForTree(put_inParams)
    if not fast_content then
        return nil
    end

    if not CheckItemClass(put_inParams, treeParams) then
        return nil
    end

    -- if (string.find(fast_content, "<"..tostring(treeParams["_itemTag"]).."(\n*)")) or (string.find(fast_content, "</"..tostring(treeParams["_itemTag"])..">")) then
    --     parserLOG("[E] Module XMLParser.lua === Tree with name \""..tostring(treeParams["_itemTag"]).."\" in '"..EX_XMLParserPATH.."' already exists")
    --     parserPRINT("XMLParser: Tree with name \""..tostring(treeParams["_itemTag"]).."\" in '"..EX_XMLParserPATH.."' already exists")
    --     return nil
    -- end
    fast_content = nil

    firstLine = put_inParams["_itemLine"] or firstLine

    local savedTabs = ""
    local _, _, savedTabss = string.find(content[firstLine], "(\t*)")
    if savedTabss then
        savedTabs = savedTabss
    end

    if not string.find(content[firstLine], ">") then
        repeat
            firstLine=firstLine+1
        until string.find(content[firstLine], ">")
    end

    firstLine = firstLine + 1

    local curLine = firstLine
    local genTree_upTag = savedTabs.."\t<"..tostring(treeParams["_itemTag"])
    -- if EX_XMLParserENTERS then
    --     if (string.find(content[firstLine-1], "</[^>]>")) or (not string.find(content[firstLine-1], '"%s*>')) or (string.find(content[firstLine], '<[^>]>?')) then
    --         genTree_upTag = "\n"..genTree_upTag
    --     end
    -- end
    table.insert(content, firstLine, genTree_upTag)

    local strSpaces = ""
    if EX_XMLParserSPACES then
        strSpaces = " "
    end

    local ordered_keys = {"id", "Id", "ObjectId", "Name", "name", "Amount", "Maximum", "Description"}
    ordered_keys = includeKeysForSort or ordered_keys

    for i, key in ipairs(ordered_keys) do
        if treeParams[key] then
            if (key and key~="_itemTag" and key~="_itemClass") then
                local genTree_paramTag = savedTabs.."\t\t"..key..''..strSpaces..'='..strSpaces..'"'..treeParams[key]..'"'
                curLine=curLine+1
                table.insert(content, curLine, genTree_paramTag)
                treeParams[key] = nil
            end
        end
    end
    for key, value in pairs(treeParams) do
        if not ____table_contains(ordered_keys, key) then
            if (key and key~="_itemTag" and key~="_itemClass") and value then
                local genTree_paramTag = savedTabs.."\t\t"..key..''..strSpaces..'='..strSpaces..'"'..value..'"'
                curLine=curLine+1
                table.insert(content, curLine, genTree_paramTag)
                treeParams[key] = nil
            end
        end
    end
    content[curLine] = content[curLine]..">"

    curLine = curLine + 1

    local genTree_downTag = savedTabs.."\t</"..tostring(treeParams["_itemTag"])..">"
    
    if EX_XMLParserENTERS then
        if string.find(content[curLine], "<[^/>]>?") then
            genTree_downTag = genTree_downTag.."\n"
        end
    end

    table.insert(content, curLine, genTree_downTag)

    --LOG("addtree "..tostring(treeParams["_itemTag"]))
    --LOG("\n".._TableToString(content))
    WriteXMLParserFileForTable(content)

    return true
end



--g_XMLParser:removeTree({_itemClass = "tree", _itemTag = "ExampleTree2"})
function XMLParser:removeTree(treeParams, startLine)
    parserLOG(":::: global method XMLParser:removeTree ::::")
    -- local treeParams = {
    --     _itemTag = "Repository",
    --     Name = "Endings"
    -- }
    local treeName = treeParams["_itemTag"] or EX_XMLParserROOT
    if treeName==(EX_XMLParserROOT or string.lower(EX_XMLParserROOT)) then
        parserLOG("[E] Module XMLParser.lua === Tree with name \""..tostring(EX_XMLParserROOT).."\" in "..EX_XMLParserPATH.." cannot be deleted")
        error("XMLParser: Tree with name \""..tostring(EX_XMLParserROOT).."\" in "..EX_XMLParserPATH.." cannot be deleted")
        return nil
    end
    
    local fast_content, content, firstLine, lastLine = CheckXMLParserFileForTree(treeParams)
    if not fast_content then
        return nil
    end
    fast_content = nil
    local firstLine = startLine or firstLine

    while true do
        if (not content[firstLine]) or (string.find(content[firstLine], "</"..treeName..">")) then
            break
        end
        table.remove(content, firstLine)
    end
    table.remove(content, firstLine)

    firstLine = firstLine - 1
    while (string.find(content[firstLine], "[\t*]") or string.find(content[firstLine], "%s*")) and not string.find(content[firstLine], ">") do
        table.remove(content, firstLine)
        firstLine = firstLine - 1
    end
    firstLine = firstLine + 1
    while (string.find(content[firstLine], "[\t*]") or string.find(content[firstLine], "%s*")) and not string.find(content[firstLine], ">") do
        table.remove(content, firstLine)
    end

    treeParams["Name"] = treeParams["Name"] or treeParams["name"] or treeParams["ObjectId"] or treeParams["Id"] or treeParams["id"] or treeParams["_customValue"] or nil
    parserLOG("[I] Module XMLParser.lua === Tree <"..treeParams["_itemTag"].."> with value \""..tostring(treeParams["Name"]).."\" in '"..EX_XMLParserPATH.."' deleted succesfully")
    parserPRINT("Tree <"..treeParams["_itemTag"].."> with value \""..tostring(treeParams["Name"]).."\" in '"..EX_XMLParserPATH.."' deleted succesfully")

    WriteXMLParserFileForTable(content)
    return true
end



--g_XMLParser:getTree("TreeExample")
function XMLParser:getTree(treeParams, put_in)
    parserLOG(":::: global method XMLParser:getTree ::::")
    -- local treeExample = {
    --     _itemClass = "tree", 
    --     _itemTag = "ModStatsDescription",
    --     --Name = "Endings"
    -- }

    local treeParams = treeParams or treeExample
    local put_in = put_in or EX_XMLParserROOT

    local treeName = treeParams["_itemTag"] or EX_XMLParserROOT
    local treeObjName = treeParams["Name"] or treeParams["name"] or treeParams["ObjectId"] or treeParams["Id"] or treeParams["id"] or treeParams["_customValue"] or nil
    
    
    local folder, _, folder_firstLine, folder_lastLine = CheckXMLParserFileForTree(put_in, true)
    if not folder then
        parserLOG("[E] Module XMLParser.lua === Parent tree with name \""..put_in.."\" in '"..EX_XMLParserPATH.."' does not exist")
        parserPRINT("Parent tree with name \""..put_in.."\" in '"..EX_XMLParserPATH.."' does not exist")
        return nil
    end

    local fast_content, content, firstLine, lastLine = CheckXMLParserFileForTree(treeParams)
    if not fast_content then
        return nil
    end
    if content then
        if not content[firstLine] then
            return nil
        end
    else
        return nil
    end
    fast_content = nil

    firstLine = treeParams["_itemLine"] or firstLine

    parserLOG("TRY GET<<<\n".._TableToString(treeParams))

    parserLOG("dsa "..content[firstLine])
    if ((string.find(content[firstLine], "</"..treeName..">")) or (string.find(content[firstLine], "<"..treeName))==nil) then
        firstLine = firstLine - 1
    end
    -- parserLOG("das "..content[firstLine])
    -- parserLOG("folder "..content[folder_firstLine])

    local findObjectPattern = '%s*<([^>%s%/]+)>?[/%s]?'
    local findParamPattern = '%s+([^<]*)%s*=+%s*"([^"]*)"'

    local startTabs = ""
    local _,_, tabss = string.find(content[firstLine], "(\t*)<")
    if tabss then startTabs = tabss end

    -- if firstLine<folder_firstLine then
    --     firstLine = folder_firstLine
    -- end

    local z = folder_firstLine
    parserLOG("__start tree   :: "..firstLine)
    parserLOG("__start folder :: "..folder_firstLine)
    parserLOG("__enddd tree   :: "..lastLine)
    parserLOG("__enddd folder :: "..folder_lastLine)
    repeat
        local _, _, TreeObj_Name, TreeObj_Value = string.find(content[z], findParamPattern)
        if (TreeObj_Name == treeParams["Name"] or TreeObj_Name == treeParams["name"] or TreeObj_Name == treeParams["ObjectId"] or TreeObj_Name == treeParams["Id"] or TreeObj_Name == treeParams["id"] or TreeObj_Name == treeParams["_customValue"]) and (TreeObj_Value==tostring(treeObjName)) then
            parserLOG("____stop line of tree <"..treeName.."> by name {"..tostring(treeObjName).."}")
            parserLOG("____line of tree name param:: "..z)
            break
        end
        z=z+1
    until ((z==folder_lastLine) or (string.find(content[z-1], "</"..tostring(treeObjName)..">")))

    

    local treeData = {}
    treeData[1] = {}
    treeData[2] = {}
    treeData[3] = {}
    local curLine = firstLine
    local lastStringParam = 0

    treeData[1]["_itemClass"] = "tree"
    treeData[1]["_itemParent"] = put_in
    treeData[1]["_itemLine"] = curLine
    treeData[1]["_itemLineForItems"] = z
    treeData[1]["_itemTag"] = treeName

    -- parserLOG(content[curLine-1])
    -- parserLOG(content[curLine])
    -- parserLOG(content[curLine+1])

    parserLOG("<<<<<<<< "..content[curLine])
    parserLOG("+ Tree: "..tostring(treeData[1]["_itemTag"]))
    parserLOG("\tParent         -> "..tostring(treeData[1]["_itemParent"]))
    parserLOG("\tLine           -> "..tostring(treeData[1]["_itemLine"]))
    parserLOG("\tLineForItems   -> "..tostring(treeData[1]["_itemLineForItems"]))
    local gotAnyValueInTREETAG = string.find(content[curLine], findParamPattern)
    if gotAnyValueInTREETAG then
        parserLOG("gotAnyValueInTREETAG "..content[curLine])
        local itemFirstLineParams = SliceParamsForCommentLines(content[curLine])
        --parserLOG("<"..treeName..">")
        parserLOG(content[curLine])
        for i, line in ipairs(itemFirstLineParams) do
            --parserLOG("{"..line.."}")
            local _, _, getStrParam, getStrValue = string.find(line, findParamPattern)
            if getStrParam and getStrValue then
                parserLOG("\t-> {"..getStrParam.."} {"..getStrValue.."}")

                treeData[1][tostring(getStrParam)] = getStrValue
                lastStringParam = tostring(getStrParam)
            end
        end
    else
        parserLOG("not gotAnyValueInTREETAG "..content[curLine])
        repeat
            parserLOG("getStrParam line "..content[curLine])
            local _, _, getStrParam, getStrValue = string.find(content[curLine], findParamPattern)
            if getStrParam and getStrValue then
                parserLOG("\t-> {"..getStrParam.."} {"..getStrValue.."}")

                treeData[1][tostring(getStrParam)] = getStrValue
                lastStringParam = tostring(getStrParam)
            end
            curLine=curLine+1
            if string.find(content[curLine], startTabs.."</"..treeName..">") then
                treeData[2] = nil
                treeData[3] = nil

                parserLOG("[E] Module XMLParser.lua === Tree \""..treeName.."\" in '"..EX_XMLParserPATH.."' is empty")
                parserPRINT("Tree \""..treeName.."\" in '"..EX_XMLParserPATH.."' is empty")

                return treeData, content, firstLine, lastLine
            end
        until string.find(content[curLine-1], ">")
    end

    local item = 0
    local dropMainChildsRepeat = false
    repeat
        if content[curLine]==content[firstLine] then
            curLine = curLine + 1
        end
        if (content[curLine] == startTabs.."</"..treeName..">") then break end
        local _, _, getStrObject = string.find(content[curLine], startTabs.."\t"..findObjectPattern)
        if getStrObject then
            local ___objectIndexLineNumber = curLine
            item=item+1
            treeData[3][item] = {}

            local itemTabs = ""
            local _,_, tabss = string.find(content[curLine], "(\t*)<")
            if tabss then itemTabs = tabss end

            --class
            local getItemClass = XMLParser:getItemClass(content, curLine, getStrObject)
            
            --item
            treeData[2][item] = {}
            treeData[2][item]["_itemTag"] = getStrObject
            treeData[2][item]["_itemLine"] = ___objectIndexLineNumber
            treeData[2][item]["_itemClass"] = getItemClass
            treeData[2][item]["_itemParent"] = treeName
            treeData[2][item]["_itemProperties"] = {}
            parserLOG("+ Item: "..treeData[2][item]["_itemTag"])
            
            local _, _, getStrParam, getStrValue = string.find(content[curLine], findParamPattern)
            if getStrParam and getStrValue then
                parserLOG("\t-> {"..getStrParam.."} {"..getStrValue.."}")

                treeData[2][item]["_itemProperties"][tostring(getStrParam)] = getStrValue
            end
            repeat
                curLine=curLine+1
                local _, _, getStrParam, getStrValue = string.find(content[curLine], findParamPattern)
                if getStrParam and getStrValue then
                    parserLOG("\t-> {"..getStrParam.."} {"..getStrValue.."}")

                    treeData[2][item]["_itemProperties"][tostring(getStrParam)] = getStrValue
                end
            until string.find(content[curLine-1], ">")

            if not content[curLine] then
                break
            end

            --childs
            if getItemClass=="object" then
                parserLOG("========================= skipGetChilds")
            else
                local child = 1
                treeData[3][item]["_itemChilds"] = {}
                repeat
                    if not (content[curLine] == itemTabs.."</"..getStrObject..">") then
                        curLine=curLine+1
                    end
                    
                    if not content[curLine] then
                        break
                    end
                    if (content[curLine] == itemTabs.."</"..getStrObject..">") or (content[curLine] == startTabs.."</"..treeName..">") then
                        break
                    end
                    local _, _, ifAgainTree = string.find(content[curLine], itemTabs..""..findObjectPattern)
                    if ifAgainTree then
                        while (content[curLine] ~= itemTabs.."</"..getStrObject..">") do
                            if not content[curLine] then break end
                            local _, _, ifAgainTree_ = string.find(content[curLine], itemTabs..""..findObjectPattern)
                            if ifAgainTree_ then
                                ifAgainTree = ifAgainTree_
                                local itemChild, intLine = XMLParser:getItemFromLine(content, curLine, getStrObject, itemTabs)
                                curLine = intLine
                                treeData[3][item]["_itemParent"] = getStrObject
                                treeData[3][item]["_itemChilds"][child] = itemChild
                                child=child+1
                                    parserLOG("[I] Module XMLParser.lua === Tree with name \""..treeName.."\" in '"..EX_XMLParserPATH.."' has item <"..getStrObject.."> with childs by first tag \""..ifAgainTree.."\"")
                                    parserPRINT("Tree with name \""..treeName.."\" in "..EX_XMLParserPATH.." has item <"..getStrObject.."> with childs by first tag \""..ifAgainTree.."\"")    
                            end
                            if (content[curLine] == itemTabs.."</"..ifAgainTree..">") or (content[curLine] == itemTabs.."</"..getStrObject..">") or (content[curLine] == startTabs.."</"..treeName..">") then
                                --dropMainChildsRepeat = true
                                break
                            end
                            curLine=curLine+1
                        end
                        break
                    else
                        local _, _, getStrParam, getStrValue = string.find(content[curLine], findParamPattern)
                        if getStrParam and getStrValue then
                            parserLOG("\t| {"..getStrParam.."} {"..getStrValue.."}")

                            treeData[2][item]["_itemProperties"][tostring(getStrParam)] = getStrValue
                        end
                    end
                until (content[curLine] == itemTabs.."</"..getStrObject..">") or (content[curLine] == startTabs.."</"..treeName..">")
            end
            if treeData[3][item]["_itemChilds"] then
                if not treeData[3][item]["_itemChilds"][1] then
                    treeData[3][item]["_itemChilds"] = nil
                end
            end
        end
        if not content[curLine+1] then
            break
        end
        if content[curLine] == startTabs.."</"..treeName..">" then
            break
        end
        if not string.find(content[curLine], startTabs.."\t"..findObjectPattern) and (content[curLine] ~= startTabs.."</"..treeName..">") then
            curLine = curLine + 1
        end
    until content[curLine] == startTabs.."</"..treeName..">"

    local treeParams = treeData[1][lastStringParam]
    if not treeParams then 
        parserLOG("[I] Module XMLParser.lua === Tree with name \""..treeName.."\" in '"..EX_XMLParserPATH.."' has no parameters")
        parserPRINT("Tree with name \""..treeName.."\" in "..EX_XMLParserPATH.." has no parameters")
        --treeData[1] = nil
    end
    local treeObjects = treeData[2][1]
    if not treeObjects then 
        parserLOG("[I] Module XMLParser.lua === Tree with name \""..treeName.."\" in '"..EX_XMLParserPATH.."' has no items")
        parserPRINT("Tree with name \""..treeName.."\" in '"..EX_XMLParserPATH.."' has no items")
        treeData[2] = nil
        treeData[3] = nil
    end

    parserLOG("\n".._TableToString(treeData))
    
    return treeData, content, firstLine, lastLine
end


function XMLParser:getItemFromLine(content, intLine, parentName, parentTabs)
    parserLOG(":::: global method XMLParser:getItemFromLine ::::")
    local item = {}
    local curLine = intLine
    local parentTabs = parentTabs or ""
    item["_itemParent"] = parentName
    item["_itemLine"] = curLine
    
    local findObjectPattern = '%s*<([^>%s%/]+)>?[/%s]?'
    local findParamPattern = '%s+([^<]*)%s*=+%s*"([^"]*)"';

    _,_, item["_itemTag"] = string.find(content[curLine], findObjectPattern)
    item["_itemClass"] = XMLParser:getItemClass(content, curLine, item["_itemTag"])
    
    item["_itemProperties"] = {}
    
    local startTabs = ""
    local _,_, tabss = string.find(content[curLine], "(\t*)<")
    if tabss then startTabs = tabss end

    parserLOG("+ Child: "..item["_itemTag"])
    local gotAnyValueInTREETAG = string.find(content[curLine], findParamPattern)
    if gotAnyValueInTREETAG then
        --parserLOG("gotAnyValueInTREETAG "..content[curLine])
        local itemFirstLineParams = SliceParamsForCommentLines(content[curLine])
        --parserLOG(content[curLine])
        for i, line in ipairs(itemFirstLineParams) do
            --parserLOG("{"..line.."}")
            local _, _, getStrParam, getStrValue = string.find(line, findParamPattern)
            if getStrParam and getStrValue then
                parserLOG("\t-> {"..getStrParam.."} {"..getStrValue.."}")

                item["_itemProperties"][tostring(getStrParam)] = getStrValue
            end
        end
    else
        --parserLOG("not gotAnyValueInTREETAG "..content[curLine])
        repeat
            local _, _, getStrParam, getStrValue = string.find(content[curLine], findParamPattern)
            if getStrParam and getStrValue then
                parserLOG("\t-> {"..getStrParam.."} {"..getStrValue.."}")

                item["_itemProperties"][tostring(getStrParam)] = getStrValue
            end
            curLine=curLine+1
            if item["_itemClass"]=="tree" then
                if string.find(content[curLine], startTabs.."</"..item["_itemTag"]..">") or string.find(content[curLine], parentTabs.."</"..parentName..">") then
                    return item, curLine
                end
            else
                if string.find(content[curLine-1], "/>") or string.find(content[curLine], parentTabs.."</"..parentName..">") then
                    return item, curLine
                end
            end
        until string.find(content[curLine-1], ">")
    end

    if item["_itemClass"]=="tree" then
        item["_itemChilds"] = {}
        local child = 1
        while string.find(content[curLine], startTabs.."</"..item["_itemTag"]..">")==nil and string.find(content[curLine], parentTabs.."</"..parentName..">")==nil do
            if string.find(content[curLine], findObjectPattern) then
                local curLine_
                item["_itemChilds"][child], curLine_ = XMLParser:getItemFromLine(content, curLine, item["_itemTag"], startTabs)
                child=child+1
                curLine = curLine_
            else
                curLine=curLine+1
            end
        end
    end

    return item, curLine
end


function XMLParser:getItemClass(content, curLine, getStrObject)
    parserLOG(":::: global method XMLParser:getItemClass ::::")
    local findObjectPattern = '%s*<([^>%s%/]+)>?[/%s]?'
    local findParamPattern = '%s+([^<]*)%s*=+%s*"([^"]*)"'

    local getItemClass = "item"
    local lineForScan = curLine
    local openTagLine = content[lineForScan]
    local closeTagLine = ""
    parserLOG("sssss -> "..content[lineForScan])
    if not string.find(openTagLine, "/>") and not string.find(openTagLine, ">") then
        repeat
            closeTagLine = content[lineForScan]
            lineForScan=lineForScan+1
            parserLOG("fnd close tag -> "..closeTagLine)

            if string.find(closeTagLine, "[^/]>") then
                getItemClass = "tree"
                break
            end
            if (not string.find(closeTagLine, "/>") and (string.find(closeTagLine, findObjectPattern))) then
                local _, _, newObj = string.find(closeTagLine, findObjectPattern)
                while ((string.find(closeTagLine, "/>") or (string.find(closeTagLine, "</"..newObj..">")))) do
                    closeTagLine = content[lineForScan]
                    lineForScan=lineForScan+1
                    parserLOG("fnd objec tag -> "..closeTagLine)
                end 
            end
        until ((string.find(content[lineForScan-1], "/>") and not (string.find(content[lineForScan-1], findObjectPattern))) or string.find(content[lineForScan-1], "</"..getStrObject..">"))
        if (string.find(openTagLine, "<"..getStrObject..">?[/%s]?")) and (string.find(closeTagLine, "</"..getStrObject..">")) then
            getItemClass = "tree"
                parserLOG("$tree")
        elseif (string.find(openTagLine, "<"..getStrObject)) and (string.find(closeTagLine, "/>")) then
            getItemClass = "object"
                parserLOG("$object")
        else
            parserLOG("$tree or kurva")
        end
    else
        if string.find(openTagLine, "/>") then
            getItemClass = "object"
                parserLOG("$object")
        elseif string.find(openTagLine, ">") then
            getItemClass = "tree"
                parserLOG("$tree")
        else
            parserLOG("$kurva")
        end
    end
    parserLOG("$GETITEMCLASS: "..getItemClass)
    return getItemClass
end



--g_XMLParser:addObject(nil, "TreeExample")
function XMLParser:addObject(objectParams, put_in, includeKeysForSort)
    parserLOG(":::: global method XMLParser:addObject ::::")
    local put_inParams = {
        _itemClass = put_in["_itemClass"] or "tree",
        _itemTag = put_in["_itemTag"] or EX_XMLParserROOT,
        _itemLine = put_in["_itemLine"] or EX_XMLPARSER_GLOBAL_TREEFIRSTLINE,
        Name = put_in["Name"] or nil,
        name = put_in["name"] or nil,
        ObjectId = put_in["ObjectId"] or nil,
        Id = put_in["Id"] or nil,
        id = put_in["id"] or nil,
        _customValue = put_in["_customValue"] or nil
    }

    if not put_inParams["_itemClass"]=="tree" then
        parserLOG("[E] Module XMLParser.lua === Invalid item class")
        error("XMLParser: Invalid item class")
    end

    local objectParams = objectParams or itemExample

    objectParams["_itemTag"] = objectParams["_itemTag"] or "Object"

    if not objectParams["_itemClass"]=="object" then
        parserLOG("[E] Module XMLParser.lua === Attempt to add item without class 'object' for \""..treeName.."\" in '"..EX_XMLParserPATH.."'")
        error("XMLParser: Attempt to add item without class 'object' for \""..treeName.."\" in '"..EX_XMLParserPATH.."'")
        return nil
    end

    local exists, _, content, firstLine, lastLine = CheckXMLParserFileTreeForItem(put_inParams, objectParams)
    if exists then
        return nil
    end

    firstLine = put_inParams["_itemLine"] or firstLine

    local savedTabs = ""
    local _, _, savedTabss = string.find(content[firstLine], "(\t*)")
    if savedTabss then
        savedTabs = savedTabss
    end

    if not string.find(content[firstLine], ">") then
        repeat
            firstLine=firstLine+1
        until string.find(content[firstLine], ">")
    end

    firstLine = firstLine + 1

    local curLine = firstLine
    local genObject_upTag = savedTabs.."\t<"..tostring(objectParams["_itemTag"])
    -- if EX_XMLParserENTERS then
    --     if (string.find(content[firstLine-1], "</[^>]>")) or (not string.find(content[firstLine-1], "<[^>]>?")) then
    --         genObject_upTag = "\n"..genObject_upTag
    --     end
    -- end
    table.insert(content, firstLine, genObject_upTag)

    local strSpaces = ""
    if EX_XMLParserSPACES then
        strSpaces = " "
    end
    
    local ordered_keys = {"id", "Id", "ObjectId", "Name", "name", "Value", "ListOfItems", "Chassis", "Cabin", "Cargo", "Skin", "ListOfGuns", "Name", "Status", "Item", "Description", "Difficulty", "Done"}
    ordered_keys = includeKeysForSort or ordered_keys

    for i, key in ipairs(ordered_keys) do
        if objectParams[key] then
            if (key and key~="_itemTag" and key~="_itemClass") then
                local genObject_paramTag = savedTabs.."\t\t"..key..''..strSpaces..'='..strSpaces..'"'..objectParams[key]..'"'
                curLine=curLine+1
                table.insert(content, curLine, genObject_paramTag)
                objectParams[key] = nil
            end
        end
    end
    for key, value in pairs(objectParams) do
        if not ____table_contains(ordered_keys, key) then
            if (key and key~="_itemTag" and key~="_itemClass") then
                local genObject_paramTag = savedTabs.."\t\t"..key..''..strSpaces..'='..strSpaces..'"'..value..'"'
                curLine=curLine+1
                table.insert(content, curLine, genObject_paramTag)
                objectParams[key] = nil
            end
        end
    end
    content[curLine] = content[curLine].." />"

    if EX_XMLParserENTERS then
        if string.find(content[curLine+1], "<[^/>]>?") then
            content[curLine] = content[curLine].."\n"
        end
    end

    --LOG("addobject "..tostring(objectParams["_itemTag"]))
    --LOG("\n".._TableToString(content))
    WriteXMLParserFileForTable(content)

    return true
end


--g_XMLParser:removeObject()
--g_ModStats:removeObject()
function XMLParser:removeObject(treeParams, objectParams)
    parserLOG(":::: global method XMLParser:removeObject ::::")
    -- local treeParams = {
    --     _itemTag = "ModStatsDescription",
    --     --Name = "Achievements"
    -- }
    -- local objectParams = {
    --     _itemTag = "PlayerDeaths",
    --     --Name = "Нужна помощь?"
    -- }

    local objectParams = objectParams or itemExample
    local treeName = treeParams["_itemTag"] or EX_XMLParserROOT

    local KeyForSearch = "_customValue"
    if objectParams["Name"]           then KeyForSearch = "Name"
    elseif objectParams["name"]       then KeyForSearch = "name"
    elseif objectParams["ObjectId"]   then KeyForSearch = "ObjectId"
    elseif objectParams["Id"]         then KeyForSearch = "Id"
    elseif objectParams["id"]         then KeyForSearch = "id"
    elseif objectParams["_customValue"] then KeyForSearch = "_customValue" end
    
    local treeData, content, firstLine, lastLine = XMLParser:getTree(treeParams)

    local objLine = nil
    local obj, objj, skoka = 1, 1, 0
    if treeData[2] and treeData[2][obj] then
        while treeData[2][obj]~=nil do
            if (treeData[2][obj]["_itemClass"]=="object") and (treeData[2][obj]["_itemTag"]==objectParams["_itemTag"]) then
                skoka = skoka + 1
                objj = obj
            end
            obj=obj+1
        end
        if skoka>=2 then
            obj = 1
            while treeData[2][obj]~=nil do
                if (treeData[2][obj]["_itemClass"]=="object") and (treeData[2][obj]["_itemTag"]==objectParams["_itemTag"]) and (treeData[2][obj]["_itemProperties"][KeyForSearch]==objectParams[KeyForSearch]) then
                    objLine = treeData[2][obj]["_itemLine"]
                    break
                end
                obj=obj+1
            end
        elseif skoka==1 then
            objLine = treeData[2][objj]["_itemLine"]
        else
            parserLOG("[E] Module XMLParser.lua === Object <"..objectParams["_itemTag"].."> with value \""..tostring(objectParams[KeyForSearch]).."\" in tree <"..treeName.."> with name \""..tostring(treeParams["Name"]).."\" '"..EX_XMLParserPATH.."' not found")
            error("XMLParser: Object <"..objectParams["_itemTag"].."> with value \""..tostring(objectParams[KeyForSearch]).."\" in tree <"..treeName.."> with name \""..tostring(treeParams["Name"]).."\" '"..EX_XMLParserPATH.."' not found")
            return nil
        end
    end
    
    if objLine then
        while true do
            if (not content[objLine]) or (string.find(content[objLine], "/>")) or (string.find(content[objLine], "</"..treeName..">")) then
                break
            end
            table.remove(content, objLine)
        end
        table.remove(content, objLine)

        objLine = objLine - 1
        while (string.find(content[objLine], "[\t*]") or string.find(content[objLine], "%s*")) and not string.find(content[objLine], ">") do
            table.remove(content, objLine)
            objLine = objLine - 1
        end
        objLine = objLine + 1
        while (string.find(content[objLine], "[\t*]") or string.find(content[objLine], "%s*")) and not string.find(content[objLine], "<") do
            table.remove(content, objLine)
        end

        parserLOG("[I] Module XMLParser.lua === Object <"..objectParams["_itemTag"].."> with value \""..tostring(objectParams[KeyForSearch]).."\" in tree <"..treeName.."> with name \""..tostring(treeParams["Name"]).."\" '"..EX_XMLParserPATH.."' deleted succesfully")
        parserPRINT("Object <"..objectParams["_itemTag"].."> with value \""..tostring(objectParams[KeyForSearch]).."\" in tree <"..treeName.."> with name \""..tostring(treeParams["Name"]).."\" '"..EX_XMLParserPATH.."' deleted succesfully")

        WriteXMLParserFileForTable(content)
        return true
    end

    parserLOG("[I] Module XMLParser.lua === Object <"..objectParams["_itemTag"].."> with value \""..tostring(objectParams[KeyForSearch]).."\" in tree <"..treeName.."> with name \""..tostring(treeParams["Name"]).."\" '"..EX_XMLParserPATH.."' not found")
    parserPRINT("Object <"..objectParams["_itemTag"].."> with value \""..tostring(objectParams[KeyForSearch]).."\" in tree <"..treeName.."> with name \""..tostring(treeParams["Name"]).."\" '"..EX_XMLParserPATH.."' not found")

    return false
end


function XMLParser:Wrap(objectParams)
    parserLOG(":::: global method XMLParser:Wrap ::::")
    local fast_content = EX_XMLPARSER_GLOBAL_TREEDATA
    local content = _CopyTable(EX_XMLPARSER_GLOBAL_FILEDATA)
    local firstLine = EX_XMLPARSER_GLOBAL_TREEFIRSTLINE
    local lastLine = EX_XMLPARSER_GLOBAL_TREELASTLINE
    local itemName = EX_XMLPARSER_GLOBAL_TREEDATA[1]["_itemTag"]
    if type(objectParams)=="table" then
        firstLine = objectParams["_itemLine"] or firstLine
        itemName = objectParams["_itemTag"] or EX_XMLPARSER_GLOBAL_TREEDATA[1]["_itemTag"]
    end

    if fast_content and content and firstLine and lastLine and itemName then

        if not content[firstLine] then
            parserLOG("[E] Module XMLParser.lua === Couldn't access the updated tree")
            parserPRINT("Couldn't access the updated tree")
            return nil
        end
        if string.find(content[firstLine], ">") then
            parserLOG("[E] Module XMLParser.lua === Invalid structure of item <"..itemName.."> on line '"..firstLine.."'")
            parserPRINT("Invalid structure of item <"..itemName.."> on line '"..firstLine.."'")
            return nil
        end
        while string.find(content[firstLine], "<"..itemName)==nil do
            parserLOG("nenashol")
            firstLine=firstLine-1
        end

        parserLOG("cathced content = {\n".._TableToString(content).."}end")

        --parserLOG(content[firstLine])
        --parserLOG(content[firstLine+1])
        
        local catchTree = content
        local eraseLine = firstLine
        while string.find(catchTree[eraseLine], ">")==nil do
            eraseLine = eraseLine + 1
            if string.find(catchTree[eraseLine], ">") then
                eraseLine = eraseLine + 1
                break
            end
        end

        if firstLine~=eraseLine then
            catchTree[firstLine-1] = catchTree[firstLine-1].."@@@<superMegaTagForUNWRAP>@@@"

            while (catchTree[eraseLine]~=nil) do
                table.remove(catchTree, eraseLine)
            end
            while (catchTree[1]~=nil) and (not (string.find(catchTree[1], "@@@<superMegaTagForUNWRAP>@@@"))) do
                table.remove(catchTree, 1)
            end
            table.remove(catchTree, 1)

            parserLOG("cathced item = {\n".._TableToString(catchTree).."}end")
        else
            catchTree = catchTree[firstLine]
            parserLOG("cathced line = {"..tostring(catchTree).."}end")
        end

        local wrapedItem = PackStringFromTable(catchTree, true)

        if (not wrapedItem) or (not (string.find(wrapedItem, "<"..itemName))) and (not (string.find(wrapedItem, ">"))) then
            parserLOG("[E] Module XMLParser.lua === Invalid structure of item")
            parserPRINT("Invalid structure of item")
            return nil
        end

        parserLOG("wraped item = {"..tostring(wrapedItem).."}end")

        content = nil
        fast_content = nil

        return wrapedItem
    end
    return nil
end


function XMLParser:Unwrap(objectParams)
    parserLOG(":::: global method XMLParser:Unwrap ::::")
    local fast_content, content, firstLine, lastLine = EX_XMLPARSER_GLOBAL_TREEDATA, EX_XMLPARSER_GLOBAL_FILEDATA, EX_XMLPARSER_GLOBAL_TREEFIRSTLINE, EX_XMLPARSER_GLOBAL_TREELASTLINE
    local itemName = EX_XMLPARSER_GLOBAL_TREEDATA[1]["_itemTag"]
    if type(objectParams)=="table" then
        firstLine = objectParams["_itemLine"] or firstLine
        itemName = objectParams["_itemTag"] or EX_XMLPARSER_GLOBAL_TREEDATA[1]["_itemTag"]
    end

    if fast_content and content and firstLine and lastLine and itemName then

        if not content[firstLine] then
            parserLOG("[E] Module XMLParser.lua === Couldn't access the updated tree")
            parserPRINT("Couldn't access the updated tree")
            return nil
        end
        if not string.find(content[firstLine], ">") then
            parserLOG("[E] Module XMLParser.lua === Invalid structure of item <"..itemName.."> on line '"..firstLine.."'")
            parserPRINT("Invalid structure of item <"..itemName.."> on line '"..firstLine.."'")
            return nil
        end
        while string.find(content[firstLine], "<"..itemName)==nil do
            parserLOG("nenashol")
            firstLine=firstLine-1
        end

        parserLOG("cathced content = {\n".._TableToString(content).."}end")

        parserLOG(content[firstLine])
        --parserLOG(content[firstLine])
        --parserLOG(content[firstLine+1])
        
        local catchTree = content
        local eraseLine = firstLine
        while string.find(catchTree[eraseLine-1], ">")==nil do
            if string.find(catchTree[eraseLine], ">") then
                break
            end
            eraseLine = eraseLine + 1
        end

        if firstLine~=eraseLine then
            catchTree[firstLine] = catchTree[firstLine].."@@@<superMegaTagForUNWRAP>@@@"

            while (catchTree[eraseLine]~=nil) do
                table.remove(catchTree, eraseLine)
            end
            while (catchTree[1]~=nil) and (not (string.find(catchTree[1], "@@@<superMegaTagForUNWRAP>@@@"))) do
                table.remove(catchTree, 1)
            end
            table.remove(catchTree, 1)

            parserLOG("cathced item = {\n".._TableToString(catchTree).."}end")
        else
            catchTree = catchTree[firstLine]
            parserLOG("cathced line = {"..tostring(catchTree).."}end")
        end

        local unwrapedItem = PackStringFromTable(catchTree)

        if (not unwrapedItem) or (not string.find(unwrapedItem, "<"..itemName)) then
            parserLOG("[E] Module XMLParser.lua === Invalid structure of item")
            parserPRINT("Invalid structure of item")
            return nil
        end
        
        unwrapedItem = UnwrapItemForCommentLines(unwrapedItem)

        parserLOG("unwraped item = {\n".._TableToString(unwrapedItem).."}end")

        return unwrapedItem
    end
    return nil
end


function XMLParser:AutoUpdateTree(bool)
    parserLOG(":::: global method XMLParser:AutoUpdateTree ::::")
    if bool then
        EX_XMLPARSER_GLOBAL_AUTOUPDATE = true
    else
        EX_XMLPARSER_GLOBAL_AUTOUPDATE = false
    end
end


function XMLParser:GetTagAndCustomKeyFromItem(itemParams)
    parserLOG(":::: global method XMLParser:GetTagAndCustomKeyFromItem ::::")
    if not itemParams then itemParams = {} end
    local tag = itemParams["_itemTag"]
    local customKey = itemParams["Name"] or itemParams["name"] or itemParams["ObjectId"] or itemParams["Id"] or itemParams["id"] or itemParams["_customValue"] or nil
    local f = function() 
        if itemParams["_itemProperties"]["Name"] then return itemParams["_itemProperties"]["Name"] end
        if itemParams["_itemProperties"]["name"] then return itemParams["_itemProperties"]["name"] end
        if itemParams["_itemProperties"]["ObjectId"] then return itemParams["_itemProperties"]["ObjectId"] end
        if itemParams["_itemProperties"]["Id"] then return itemParams["_itemProperties"]["Id"] end
        if itemParams["_itemProperties"]["id"] then return itemParams["_itemProperties"]["id"] end
        if itemParams["_itemProperties"]["_customValue"] then return itemParams["_itemProperties"]["_customValue"] end
        return nil
    end
    local f_
    if itemParams["_itemProperties"] then
        f_ = f()
    end
    if f_ then customKey = f_ end
    return {tag, customKey}
end


function XMLParser:GetLineWithContent(line, stringContent)
    parserLOG(":::: global method XMLParser:GetLineWithContent ::::")
    if (not line) and (not stringContent) then
        return nil
    end

    XMLParser:Tree():tryUpdate()

    local strLine 
    if line and stringContent then
        if string.find(EX_XMLPARSER_GLOBAL_FILEDATA[line], stringContent) then
            strLine = EX_XMLPARSER_GLOBAL_FILEDATA[line]
        end
    elseif stringContent then
        for i, v in ipairs(EX_XMLPARSER_GLOBAL_FILEDATA) do
            if string.find(v, stringContent) then
                strLine = EX_XMLPARSER_GLOBAL_FILEDATA[i]
                break
            end
        end
    elseif line then
        strLine = EX_XMLPARSER_GLOBAL_FILEDATA[line]
    end

    return strLine, line
end


function XMLParser:RemoveLineWithContent(line, stringContent)
    parserLOG(":::: global method XMLParser:RemoveLineWithContent ::::")
    if (not line) and (not stringContent) then
        return nil
    end

    XMLParser:Tree():tryUpdate()

    local strLine 
    if line and stringContent then
        if string.find(EX_XMLPARSER_GLOBAL_FILEDATA[line], stringContent) then
            strLine = EX_XMLPARSER_GLOBAL_FILEDATA[line]
            if strLine then
                table.remove(EX_XMLPARSER_GLOBAL_FILEDATA, line)
            end
        end
    elseif stringContent then
        for i, v in ipairs(EX_XMLPARSER_GLOBAL_FILEDATA) do
            if string.find(v, stringContent) then
                strLine = EX_XMLPARSER_GLOBAL_FILEDATA[i]
                table.remove(EX_XMLPARSER_GLOBAL_FILEDATA, i)
                break
            end
        end
    elseif line then
        strLine = EX_XMLPARSER_GLOBAL_FILEDATA[line]
        if strLine then
            table.remove(EX_XMLPARSER_GLOBAL_FILEDATA, line)
        end
    end

    if strLine then
        WriteXMLParserFileForTable(EX_XMLPARSER_GLOBAL_FILEDATA)

        return true, line, strLine
    end
    return false
end


function XMLParser:AddCommentNearItem(comment, objectParams)
    parserLOG(":::: global method XMLParser:AddCommentNearItem ::::")
    local comment = comment or ""
    local objectParams = objectParams or itemExample
    if not type(objectParams)=="table" then
        parserLOG("[E] Module XMLParser.lua === Invalid objectParams data")
        parserPRINT("Invalid objectParams data")
        return nil
    end
    if not type(comment)=="string" then
        parserLOG("[E] Module XMLParser.lua === Invalid comment type")
        parserPRINT("Invalid comment type")
        return nil
    end

    local KeyForSearch = "_customValue"
    if objectParams["Name"]           then KeyForSearch = "Name"
    elseif objectParams["name"]       then KeyForSearch = "name"
    elseif objectParams["ObjectId"]   then KeyForSearch = "ObjectId"
    elseif objectParams["Id"]         then KeyForSearch = "Id"
    elseif objectParams["id"]         then KeyForSearch = "id"
    elseif objectParams["_customValue"] then KeyForSearch = "_customValue" end

    objectParams[1] = objectParams["_itemClass"] or objectParams[1]
    objectParams[2] = objectParams["_itemTag"] or objectParams[2]
    objectParams[3] = objectParams["_customValue"] or KeyForSearch or objectParams[3]

    XMLParser:Tree():tryUpdate()

    local idValue = objectParams["ObjectId"] or objectParams["Id"] or objectParams["id"] or nil

    local itemData
    if objectParams[1]=="object" then
        if idValue then objectParams[3] = idValue end
        itemData = XMLParser:Tree():GetObj({objectParams[2], objectParams[3]})
    elseif objectParams[1]=="tree" then
        local treeById = XMLParser:Tree():GetTreeById(idValue)
        local treeByCustomKey = XMLParser:Tree():GetTreeByCustomKey(KeyForSearch)
        local treeByName = XMLParser:Tree():GetTreeByName(objectParams[3])
        local treeByTag = XMLParser:Tree():GetTree(objectParams[2])

        treeById = treeById or {}
        treeByCustomKey = treeByCustomKey or {}
        treeByName = treeByName or {}
        treeByTag = treeByTag or {}

        if treeById["_itemLine"] then
            itemData = treeById
        elseif treeByCustomKey["_itemLine"] then
            itemData = treeByCustomKey
        elseif treeByName["_itemLine"]==treeByTag["_itemLine"] then
            itemData = treeByName
        else
            itemData = treeByTag
        end
    end

    if not itemData then
        return nil
    end

    local commentLine 
    if itemData["_object"] then
        commentLine = itemData["_object"]["_itemLine"]
    elseif itemData["_itemLine"] then
        commentLine = itemData["_itemLine"]
    elseif itemData["firstLine"] then
        commentLine = itemData["firstLine"]
    end
    
    if not commentLine then
        parserLOG("[E] Module XMLParser.lua === Can't find line for comment")
        parserPRINT("Can't find line for comment")
        return nil
    end

    local commentStr = "<!-- "..comment.." -->"

    table.insert(EX_XMLPARSER_GLOBAL_FILEDATA, commentLine, commentStr)

    WriteXMLParserFileForTable(EX_XMLPARSER_GLOBAL_FILEDATA)
    
    return true, commentLine
end



-- ////////////////////// GLOBAL MODULE METHODS //////////////////////////////



--class tree
--XMLParser:Tree({_itemTag="Repository", Name="Achievements"}):init()
function XMLParser:Tree(treeParams)
    parserLOG(":::: global method XMLParser:Tree ::::")
    local treeParams = treeParams or EX_XMLPARSER_CACHE_TREEPARAMS
    if (not treeParams) or (not type(treeParams)=="table") then 
        treeParams = {_itemTag = EX_XMLParserROOT}
    elseif (type(treeParams)=="table") and (treeParams["_itemTag"]==nil) then
        treeParams = {
            _itemTag = treeParams[1],
            _customValue = treeParams[2]
        }
    end
    EX_XMLPARSER_CACHE_TREEPARAMS = treeParams

    --LOG("\n"..tostring(_TableToString(treeParams)))
    
    local TREE = {
        treeName = treeParams["_itemTag"] or EX_XMLParserROOT,
        treeObjName = treeParams["Name"] or treeParams["name"] or treeParams["ObjectId"] or treeParams["Id"] or treeParams["id"] or treeParams["_customValue"] or "",
        _customValue = treeParams["_customValue"],
        treeParams = EX_XMLPARSER_GLOBAL_TREEPARAMS or EX_XMLPARSER_CACHE_TREEPARAMS,
        treeData = EX_XMLPARSER_GLOBAL_TREEDATA or {},
        content = EX_XMLPARSER_GLOBAL_FILEDATA or {},
        firstLine = EX_XMLPARSER_GLOBAL_TREEFIRSTLINE or 1,
        lastLine = EX_XMLPARSER_GLOBAL_TREELASTLINE or 1
    }

    function TREE:tryUpdate()
        if EX_XMLPARSER_GLOBAL_AUTOUPDATE then
            parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:tryUpdate ::::")
            parserLOG("[I] Module XMLParser.lua === AutoUpdateTree() is enabled")
            parserPRINT("AutoUpdateTree() is enabled")
            TREE:init()
            return true
        end
        return nil
    end

    function TREE:init()
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:init ::::")
        local treeData_, content_, firstLine_, lastLine_ = XMLParser:getTree(treeParams)
        if treeData_ and content_ and firstLine_ and lastLine_ then
            --parserLOG("LITERAL\n".._TableToString(content_))
            EX_XMLPARSER_GLOBAL_TREEPARAMS = treeParams
            EX_XMLPARSER_CACHE_TREEPARAMS = treeParams
            EX_XMLPARSER_GLOBAL_TREEDATA = treeData_
            EX_XMLPARSER_GLOBAL_FILEDATA = content_
            EX_XMLPARSER_GLOBAL_TREEFIRSTLINE = firstLine_
            EX_XMLPARSER_GLOBAL_TREELASTLINE = lastLine_
            TREE["treeName"] = treeData_[1]["_itemTag"] or EX_XMLParserROOT
            TREE["treeObjName"] = treeData_[1]["Name"] or treeData_[1]["name"] or treeData_[1]["ObjectId"] or treeData_[1]["Id"] or treeData_[1]["id"] or treeData_[1]["_customValue"] or ""
            TREE["treeParams"] = EX_XMLPARSER_GLOBAL_TREEPARAMS
            TREE["treeData"] = EX_XMLPARSER_GLOBAL_TREEDATA
            TREE["content"] = EX_XMLPARSER_GLOBAL_FILEDATA
            TREE["firstLine"] = EX_XMLPARSER_GLOBAL_TREEFIRSTLINE
            TREE["lastLine"] = EX_XMLPARSER_GLOBAL_TREELASTLINE
            --parserLOG("UPDATE\n".._TableToString(TREE["content"]))
            parserLOG("[I] Module XMLParser.lua === Tree <"..TREE["treeName"].."> with name '"..TREE["treeObjName"].."' updated")
            parserPRINT("Tree <"..TREE["treeName"].."> with name '"..TREE["treeObjName"].."' updated")
            return true
        end
        return nil
    end


    function TREE:Add(objectParams, bEnters, bSpaces, includeKeysForSort)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:Add ::::")
        TREE:tryUpdate()
        if not type(objectParams)=="table" then
            parserLOG("[E] Module XMLParser.lua === Invalid objectParams data")
            error("XMLParser: Invalid objectParams data")
        end
        if not objectParams["_itemTag"] then
            parserLOG("[E] Module XMLParser.lua === Invalid _itemTag data")
            error("XMLParser: Invalid _itemTag data")
        end
        if ((objectParams["_itemClass"]~="tree") and (objectParams["_itemClass"]~="object")) then
            parserLOG("[E] Module XMLParser.lua === Invalid item class data")
            error("XMLParser: Invalid item class data")
        end

        if bEnters then
            EX_XMLParserENTERS = true
        else
            EX_XMLParserENTERS = false
        end
        if bSpaces then
            EX_XMLParserSPACES = true
        else
            EX_XMLParserSPACES = false
        end

        local KeyForSearch = "_customValue"
        if objectParams["Name"]           then KeyForSearch = "Name"
        elseif objectParams["name"]       then KeyForSearch = "name"
        elseif objectParams["ObjectId"]   then KeyForSearch = "ObjectId"
        elseif objectParams["Id"]         then KeyForSearch = "Id"
        elseif objectParams["id"]         then KeyForSearch = "id"
        elseif objectParams["_customValue"] then KeyForSearch = "_customValue" end

        local added = false
        if objectParams["_itemClass"]=="tree" then
            local exists, obj = XMLParser:Tree():IsTreeExists({objectParams["_itemTag"], objectParams[KeyForSearch]})
            --if exists and obj["_object"]["_itemClass"]=="object" then exists = false end
            if not exists then
                added = XMLParser:addTree(objectParams, TREE["treeData"][1], includeKeysForSort)
            end
        elseif objectParams["_itemClass"]=="object" then
            local exists, obj = XMLParser:Tree():IsObjectExists({objectParams["_itemTag"], objectParams[KeyForSearch]})
            --if exists and obj["_object"]["_itemClass"]=="tree" then exists = false end
            if not exists then
                added = XMLParser:addObject(objectParams, TREE["treeData"][1], includeKeysForSort)
            end
        end

        if added then 
            parserLOG("[I] Module XMLParser.lua === Added item with class '"..tostring(objectParams["_itemClass"]).."', tag <"..tostring(objectParams["_itemTag"]).."> and value \""..tostring(objectParams[KeyForSearch]).."\" to '"..tostring(TREE["treeData"][1]["_itemTag"]).."'")
            parserPRINT("Added item with class '"..tostring(objectParams["_itemClass"]).."', tag <"..tostring(objectParams["_itemTag"]).."> and value \""..tostring(objectParams[KeyForSearch]).."\" to '"..tostring(TREE["treeData"][1]["_itemTag"]).."'")
            return true 
        else
            parserLOG("[E] Module XMLParser.lua === Failed to add item with class '"..objectParams["_itemClass"].."', tag <"..tostring(objectParams["_itemTag"]).."> and value \""..tostring(objectParams[KeyForSearch]).."\" to '"..tostring(TREE["treeData"][1]["_itemTag"]).."'")
            parserPRINT("Failed to add item with class '"..tostring(objectParams["_itemClass"]).."', tag <"..tostring(objectParams["_itemTag"]).."> and value \""..tostring(objectParams[KeyForSearch]).."\" to '"..tostring(TREE["treeData"][1]["_itemTag"]).."'")
        end

        return nil
    end

    function TREE:Remove(objectParams)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:Remove ::::")
        TREE:tryUpdate()
        local removed = false

        if type(objectParams)=="table" then
            if not objectParams["_itemTag"] then
                parserLOG("[E] Module XMLParser.lua === Invalid _itemTag data")
                error("XMLParser: Invalid _itemTag data")
            end
            if (not (objectParams["_itemClass"]=="tree") and not (objectParams["_itemClass"]=="object")) then
                parserLOG("[E] Module XMLParser.lua === Invalid item class data")
                error("XMLParser: Invalid item class data")
            end
        elseif objectParams=="self" then
            removed = XMLParser:removeTree(
                TREE["treeData"][1], 
                TREE["firstLine"]
            )
            if removed then 
                return true 
            else
                return nil
            end
        else
            parserLOG("[E] Module XMLParser.lua === Invalid objectParams data")
            error("XMLParser: Invalid objectParams data")
        end

        local KeyForSearch = "_customValue"
        if objectParams["Name"]           then KeyForSearch = "Name"
        elseif objectParams["name"]       then KeyForSearch = "name"
        elseif objectParams["ObjectId"]   then KeyForSearch = "ObjectId"
        elseif objectParams["Id"]         then KeyForSearch = "Id"
        elseif objectParams["id"]         then KeyForSearch = "id"
        elseif objectParams["_customValue"] then KeyForSearch = "_customValue" end
        
        if objectParams["_itemClass"]=="tree" then
            local tree
            local treeByName
            local treeByTag
            local treeByCustomKey
            local treeById
            if not objectParams["Name"] then objectParams["Name"] = "" end
            local idValue = objectParams["ObjectId"] or objectParams["Id"] or objectParams["id"] or nil

            treeById = TREE:GetTreeById(idValue)
            treeByCustomKey = TREE:GetTreeByCustomKey(KeyForSearch)
            treeByName = TREE:GetTreeByName(objectParams["Name"])
            treeByTag = TREE:GetTree(objectParams["_itemTag"])

            treeById = treeById or {}
            treeByCustomKey = treeByCustomKey or {}
            treeByName = treeByName or {}
            treeByTag = treeByTag or {}

            if treeById["_itemLine"] then
                tree = treeById
            elseif treeByCustomKey["_itemLine"] then
                tree = treeByCustomKey
            elseif treeByName["_itemLine"]==treeByTag["_itemLine"] then
                tree = treeByName
            else
                tree = treeByTag
            end

            if tree then
                local line = tree["_itemLine"]
                --println("line : "..line)
                removed = XMLParser:removeTree(objectParams, line)
            end
        else
            removed = XMLParser:removeObject(TREE["treeData"][1], objectParams)
        end

        if removed then 
            parserLOG("[I] Module XMLParser.lua === Removed item with class '"..tostring(objectParams["_itemClass"]).."', tag <"..tostring(objectParams["_itemTag"]).."> and value \""..tostring(objectParams[KeyForSearch]).."\" in '"..tostring(TREE["treeData"][1]["_itemTag"]).."'")
            parserPRINT("Removed item with class '"..tostring(objectParams["_itemClass"]).."', tag <"..tostring(objectParams["_itemTag"]).."> and value \""..tostring(objectParams[KeyForSearch]).."\" in '"..tostring(TREE["treeData"][1]["_itemTag"]).."'")
            return true 
        else
            parserLOG("[E] Module XMLParser.lua === Failed to remove item with class '"..objectParams["_itemClass"].."', tag <"..tostring(objectParams["_itemTag"]).."> and value \""..tostring(objectParams[KeyForSearch]).."\" in '"..tostring(TREE["treeData"][1]["_itemTag"]).."'")
            parserPRINT("Failed to remove item with class '"..tostring(objectParams["_itemClass"]).."', tag <"..tostring(objectParams["_itemTag"]).."> and value \""..tostring(objectParams[KeyForSearch]).."\" in '"..tostring(TREE["treeData"][1]["_itemTag"]).."'")
        end

        return nil
    end



    function TREE:SetParam(paramKey, paramValue)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:SetParam ::::")
        TREE:tryUpdate()
        local paramKey = paramKey or "Name"
        local paramValue = paramValue or "NewValue"
        if paramKey=="_itemTag" then
            parserLOG("[E] Module XMLParser.lua === You cannot change the tag name using this command")
            error("XMLParser: You cannot change the tag name using this command")
        end

        if TREE["content"] then
            local line = TREE["firstLine"]
            while ((TREE["content"][line]~=nil) or (line==TREE["lastLine"])) do
                if string.find(TREE["content"][line], paramKey) then
                    local editedStr, count = string.gsub(TREE["content"][line], '(%s+)'..tostring(paramKey)..'(%s*)=(%s*)"[^"]*"', '%1'..tostring(paramKey)..'%2=%3"'..tostring(paramValue)..'"')
                    if count>0 then
                        TREE["content"][line] = editedStr

                        WriteXMLParserFileForTable(TREE["content"])
                        return true
                    end
                end
                line=line+1
                if string.find(TREE["content"][line-1], ">") then
                    break
                end
            end
        end
        return nil
    end

    function TREE:GetParam(stringParameterName)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetParam ::::")
        TREE:tryUpdate()
        local Value
        if TREE["treeData"][1] then
            Value = TREE["treeData"][1][stringParameterName]
        end
        return _INTERPRETATION(Value)
    end

    function TREE:AddParam(paramKey, paramValue, bSpaces)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:AddParam ::::")
        TREE:tryUpdate()
        local paramKey = paramKey or "NewParam"
        local paramValue = paramValue or "NewValue"
        
        local downedKeys = {"_itemTag", "_itemClass"}
        local i = 1
        while downedKeys[i]~=nil do
            if paramKey==downedKeys[i] then
                parserLOG("[E] Module XMLParser.lua === You cannot add the '"..paramKey.."' using this command")
                error("XMLParser: You cannot add the '"..paramKey.."' using this command")
            end
            i=i+1
        end

        if TREE["treeData"] then
            if TREE["treeData"][1] then
                local linez = 1
                if TREE["treeData"][1][paramKey] then
                    parserLOG("[E] Module XMLParser.lua === This key '"..paramKey.."' already exists")
                    parserPRINT("This key '"..paramKey.."' already exists")
                    return false
                end
            end
        end

        if TREE["content"] then
            local paramLine = TREE["firstLine"]
            while ((TREE["content"][paramLine]~=nil) or (paramLine==TREE["lastLine"])) do
                if string.find(TREE["content"][paramLine], ">") then
                    break
                end
                paramLine=paramLine+1
            end

            local lineForAddParam = TREE["content"][paramLine]

            local savedTabs = ""
            local _, _, savedTabss = string.find(TREE["content"][paramLine], "(\t*)")
            if savedTabss then
                savedTabs = savedTabss
            end

            local strSpaces = ""
            if bSpaces then
                strSpaces = " "
            end

            local newStr = paramKey..''..strSpaces..'='..strSpaces..'"'..paramValue..'"'
            if string.find(TREE["content"][paramLine], "<"..TREE["treeName"]) then
                TREE["content"][paramLine], count = string.gsub(TREE["content"][paramLine], '(%s*[^>]*)>', '%1 '..newStr..'>')
                if count==0 then
                    return nil
                end
            else
                TREE["content"][paramLine] = string.gsub(TREE["content"][paramLine], ">", "")
                paramLine = paramLine + 1
                newStr = savedTabs..""..newStr..">"
                table.insert(TREE["content"], paramLine, newStr)
            end

            WriteXMLParserFileForTable(TREE["content"])
            return true
        end
        return nil
    end

    function TREE:RemoveParam(paramKey)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:RemoveParam ::::")
        TREE:tryUpdate()
        local paramKey = paramKey or "NewParam"
        
        local downedKeys = {"_itemTag", "_itemClass"}
        local i = 1
        while downedKeys[i]~=nil do
            if paramKey==downedKeys[i] then
                parserLOG("[E] Module XMLParser.lua === You cannot remove the '"..paramKey.."' using this command")
                error("XMLParser: You cannot remove the '"..paramKey.."' using this command")
            end
            i=i+1
        end

        if TREE["treeData"] then
            if TREE["treeData"][1] then
                local linez = 1
                if not TREE["treeData"][1][paramKey] then
                    parserLOG("[E] Module XMLParser.lua === Key '"..paramKey.."' does not exist")
                    parserPRINT("Key '"..paramKey.."' does not exist")
                    return false
                end
            end
        end

        if TREE["content"] then
            --local findObjectPattern = '%s*<([^>%s%/]+)>?[/%s]?'
            local findParamPattern = '%s+'..paramKey..'%s*=+%s*"([^"]*)"'

            local paramLine = TREE["firstLine"]
            while ((TREE["content"][paramLine]~=nil) or (paramLine==TREE["lastLine"])) do
                if string.find(TREE["content"][paramLine], findParamPattern) then
                    break
                end
                paramLine=paramLine+1
            end

            local newStr = ""
            if string.find(TREE["content"][paramLine], "<"..TREE["treeName"]) then
                TREE["content"][paramLine], count = string.gsub(TREE["content"][paramLine], '%s*'..findParamPattern, newStr)
                if count==0 then
                    return nil
                end
            else
                if string.find(TREE["content"][paramLine], ">") then
                    table.remove(TREE["content"], paramLine)
                    paramLine=paramLine-1
                    TREE["content"][paramLine] = string.gsub(TREE["content"][paramLine], '(<?[^%s]*"?[^%s])', '%1>')
                else
                    table.remove(TREE["content"], paramLine)
                end
            end

            WriteXMLParserFileForTable(TREE["content"])
            return true
        end
        return nil
    end

    function TREE:GetName()
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetName ::::")
        TREE:tryUpdate()
        return TREE["treeName"]
    end
    function TREE:GetObjName()
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetObjName ::::")
        TREE:tryUpdate()
        return TREE["treeObjName"]
    end
    function TREE:GetCustomValue()
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetCustomValue ::::")
        TREE:tryUpdate()
        return TREE["_customValue"]
    end
    function TREE:GetParamsAmount()
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetParamsAmount ::::")
        TREE:tryUpdate()
        local skoka = 0
        if TREE["treeData"][1] then
            for i, v in pairs(TREE["treeData"][1]) do
                skoka=skoka+1
            end
        end
        return skoka
    end

    function TREE:GetTreeById(intId)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetTreeById ::::")
        TREE:tryUpdate()
        local intId = intId or -1
        local i = 1
        if TREE["treeData"][2] then
            while TREE["treeData"][2][i]~=nil do
                if (TREE["treeData"][2][i]["_itemClass"]=="tree") then
                    local idValue = TREE["treeData"][2][i]["_itemProperties"]["ObjectId"] or TREE["treeData"][2][i]["_itemProperties"]["Id"] or TREE["treeData"][2][i]["_itemProperties"]["id"] or nil
                    if idValue and intId then
                        if tonumber(idValue)==tonumber(intId) then
                            return TREE["treeData"][2][i]
                        end
                    end
                end
                i=i+1
            end
        end
        return nil
    end
    function TREE:GetTreeByCustomKey(stringCustomKey)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetTreeByCustomKey ::::")
        TREE:tryUpdate()
        local stringCustomKey = stringCustomKey or ""
        local i = 1
        if TREE["treeData"][2] then
            while TREE["treeData"][2][i]~=nil do
                if (TREE["treeData"][2][i]["_itemClass"]=="tree") then
                    if TREE["treeData"][2][i]["_itemProperties"][stringCustomKey] then
                        return TREE["treeData"][2][i]
                    end
                end
                i=i+1
            end
        end
        return nil
    end
    function TREE:GetTreeByName(stringTreeObjName)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetTreeByName ::::")
        TREE:tryUpdate()
        local stringTreeObjName = stringTreeObjName or ""
        local i = 1
        if TREE["treeData"][2] then
            while TREE["treeData"][2][i]~=nil do
                if (TREE["treeData"][2][i]["_itemClass"]=="tree") then
                    if TREE["treeData"][2][i]["_itemProperties"]["Name"]==stringTreeObjName then
                        return TREE["treeData"][2][i]
                    end
                end
                i=i+1
            end
        end
        return nil
    end
    function TREE:GetTree(stringTreeName)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetTree ::::")
        TREE:tryUpdate()
        local stringTreeName = stringTreeName or ""
        local i = 1
        if TREE["treeData"][2] then
            while TREE["treeData"][2][i]~=nil do
                if (TREE["treeData"][2][i]["_itemClass"]=="tree") then
                    if (TREE["treeData"][2][i]["_itemTag"]==stringTreeName) then
                        return TREE["treeData"][2][i]
                    end
                end
                i=i+1
            end
        end
        return nil
    end
    function TREE:GetItemsAmount()
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetItemsAmount ::::")
        TREE:tryUpdate()
        local skoka, j = 0, 1
        if TREE["treeData"][2] then
            while TREE["treeData"][2][j]~=nil do
                skoka=skoka+1
                j=j+1
            end
        end
        return skoka
    end
    function TREE:GetChildsAmount()
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetChildsAmount ::::")
        TREE:tryUpdate()
        local skoka = 0
        local skokas = 1
        if TREE["treeData"][3] then
            if TREE["treeData"][3][skokas] then
                while TREE["treeData"][3][skokas]~=nil do
                    if TREE["treeData"][3][skokas]["_itemChild"] then
                        skoka=skoka+1
                    end
                    skokas=skokas+1
                end
            end
        end
        return skoka
    end

    function TREE:GetObjectById(intId)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetObjectById ::::")
        TREE:tryUpdate()
        local intId = intId or -1
        local i = 1
        if TREE["treeData"][2] then
            while TREE["treeData"][2][i]~=nil do
                if (TREE["treeData"][2][i]["_itemClass"]=="object") and (TREE["treeData"][2][i]["_itemProperties"]) then
                    local idValue = TREE["treeData"][2][i]["_itemProperties"]["ObjectId"] or TREE["treeData"][2][i]["_itemProperties"]["Id"] or TREE["treeData"][2][i]["_itemProperties"]["id"] or nil
                    if idValue and intId then
                        if tonumber(idValue)==tonumber(intId) then
                            return TREE["treeData"][2][i]
                        end
                    end
                end
                i=i+1
            end
        end
        return nil
    end
    function TREE:GetObjectByCustomKey(stringCustomKey)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetObjectByName ::::")
        TREE:tryUpdate()
        local stringCustomKey = stringCustomKey or ""
        local i = 1
        if TREE["treeData"][2] then
            while TREE["treeData"][2][i]~=nil do
                if (TREE["treeData"][2][i]["_itemClass"]=="object") and (TREE["treeData"][2][i]["_itemProperties"]) then
                    if TREE["treeData"][2][i]["_itemProperties"][stringCustomKey] then
                        return TREE["treeData"][2][i]
                    end
                end
                i=i+1
            end
        end
        return nil
    end
    function TREE:GetObjectByName(stringItemObjName)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetObjectByName ::::")
        TREE:tryUpdate()
        local stringItemObjName = stringItemObjName or ""
        local i = 1
        if TREE["treeData"][2] then
            while TREE["treeData"][2][i]~=nil do
                if (TREE["treeData"][2][i]["_itemClass"]=="object") and (TREE["treeData"][2][i]["_itemProperties"]) then
                    if TREE["treeData"][2][i]["_itemProperties"]["Name"]==stringItemObjName then
                        return TREE["treeData"][2][i]
                    end
                end
                i=i+1
            end
        end
        return nil
    end
    function TREE:GetObject(stringItemName)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetObject ::::")
        TREE:tryUpdate()
        local stringItemName = stringItemName or ""
        local i = 1
        if TREE["treeData"][2] then
            while TREE["treeData"][2][i]~=nil do
                if (TREE["treeData"][2][i]["_itemClass"]=="object") then
                    if TREE["treeData"][2][i]["_itemTag"]==stringItemName then
                        return TREE["treeData"][2][i]
                    end
                end
                i=i+1
            end
        end
        return nil
    end

    function TREE:GetParams()
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetParams ::::")
        TREE:tryUpdate()
        return TREE["treeData"][1]
    end
    function TREE:GetItems()
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetItems ::::")
        TREE:tryUpdate()
        return TREE["treeData"][2]
    end
    function TREE:GetChilds()
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetChilds ::::")
        TREE:tryUpdate()
        return TREE["treeData"][3]
    end
    -- function TREE:GetParentName()
    --     parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:GetParent ::::")
    --     TREE:tryUpdate()
    --     return TREE["treeData"][1]["_itemParent"]
    -- end


    

    function TREE:IsObjectExists(tableObjectTagXorCustomKey)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:IsObjectExists ::::")
        TREE:tryUpdate()
        local ObjectExists = false
        local obj = TREE:GetObj(tableObjectTagXorCustomKey)
        if obj then
            ObjectExists = true
        end
        return ObjectExists, obj
    end

    function TREE:IsTreeExists(tableTreeTagXorCustomKey)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:IsTreeExists ::::")
        TREE:tryUpdate()
        local TreeExists = false
        local tree

        local stringCustomKey = tableTreeTagXorCustomKey[2]
        local treeById = TREE:GetTreeById(stringCustomKey)
        local treeByCustomKey = TREE:GetTreeByCustomKey(stringCustomKey)
        local treeByName = TREE:GetTreeByName(stringCustomKey)
        local stringTreeTag = tableTreeTagXorCustomKey[1]
        local treeByTag = TREE:GetTree(stringTreeTag)
        
        -- println("{"..tostring(stringCustomKey).."}")
        -- println("{"..tostring(stringTreeTag).."}")

        if treeById then
            tree = treeById
            --println("id")
        elseif treeByCustomKey then
            tree = treeByCustomKey
            --println("CustomKey")
        elseif treeByName then
            tree = treeByName
            --println("Name")
        elseif treeByTag and not stringCustomKey then
            tree = treeByTag
            --println("Tag")
        end
        if tableTreeTagXorCustomKey[1] and tableTreeTagXorCustomKey[2] then
            if treeByCustomKey and treeByTag then
                if treeByCustomKey["_itemLine"]==treeByTag["_itemLine"] then
                    tree = treeByCustomKey or treeByTag
                end
            end
        end

        if tree then
            TreeExists = true
        end
        return TreeExists, tree
    end



    function TREE:CaptureInnerTree(tableTreeTagXorCustomKey)
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:CaptureInnerTree ::::")
        TREE:tryUpdate()

        local exists, tree = TREE:IsTreeExists(tableTreeTagXorCustomKey)

        if exists and tree then
            treeParams = {
                _itemClass = "tree",
                _itemTag = tree["_itemTag"],
                _itemLine = tree["_itemLine"],
                Name = (function() if tree["_itemProperties"] then return tree["_itemProperties"]["Name"] end return nil end)(),
                name = (function() if tree["_itemProperties"] then return tree["_itemProperties"]["name"] end return nil end)(),
                ObjectId = (function() if tree["_itemProperties"] then return tree["_itemProperties"]["ObjectId"] end return nil end)(),
                Id = (function() if tree["_itemProperties"] then return tree["_itemProperties"]["Id"] end return nil end)(),
                id = (function() if tree["_itemProperties"] then return tree["_itemProperties"]["id"] end return nil end)(),
                _customValue = (function() if tree["_itemProperties"] then return tree["_itemProperties"]["_customValue"] end return nil end)() or tree["_customValue"] or nil
            }

            local treeData_, content_, firstLine_, lastLine_ = XMLParser:getTree(treeParams)
            if treeData_ and content_ and firstLine_ and lastLine_ then
                EX_XMLPARSER_GLOBAL_TREEPARAMS = treeParams
                EX_XMLPARSER_CACHE_TREEPARAMS = treeParams
                EX_XMLPARSER_GLOBAL_TREEDATA = treeData_
                EX_XMLPARSER_GLOBAL_FILEDATA = content_
                EX_XMLPARSER_GLOBAL_TREEFIRSTLINE = firstLine_
                EX_XMLPARSER_GLOBAL_TREELASTLINE = lastLine_
                TREE["treeName"] = treeData_[1]["_itemTag"] or EX_XMLParserROOT
                TREE["treeObjName"] = treeData_[1]["Name"] or treeData_[1]["name"] or treeData_[1]["ObjectId"] or treeData_[1]["Id"] or treeData_[1]["id"] or treeData_[1]["_customValue"] or ""
                TREE["treeParams"] = EX_XMLPARSER_GLOBAL_TREEPARAMS
                TREE["treeData"] = EX_XMLPARSER_GLOBAL_TREEDATA
                TREE["content"] = EX_XMLPARSER_GLOBAL_FILEDATA
                TREE["firstLine"] = EX_XMLPARSER_GLOBAL_TREEFIRSTLINE
                TREE["lastLine"] = EX_XMLPARSER_GLOBAL_TREELASTLINE
                --parserLOG("UPDATE\n".._TableToString(TREE["content"]))
                parserLOG("[I] Module XMLParser.lua === Tree <"..TREE["treeName"].."> with name '"..TREE["treeObjName"].."' updated")
                parserPRINT("Tree <"..TREE["treeName"].."> with name '"..TREE["treeObjName"].."' updated")
                return true
            end
        end

        return nil
    end



    local function applyPostWrap(forWho, wrapedContent)
        parserLOG(":::: global method XMLParser:Tree :::: local native function applyPostWrap ::::")
        local wrapedContent = wrapedContent or ""
        if TREE["firstLine"] and TREE["content"] then
            local firstLine
            if forWho=="tree" then
                firstLine = TREE["firstLine"]
            else
                firstLine = forWho
            end
            local content = _CopyTable(TREE["content"])

            parserLOG("BefWrap::\n".._TableToString(content))

            while content[firstLine]=="" do
                firstLine=firstLine+1
            end

            while (content[firstLine]~=nil) and (string.find(content[firstLine], ">")==nil) do
                parserLOG("removed line::"..tostring(content[firstLine]))
                table.remove(content, firstLine)
            end
            parserLOG("removed line::"..tostring(content[firstLine]))
            table.remove(content, firstLine)

            if type(wrapedContent)=="table" then
                firstLine=firstLine-1
                for i, v in ipairs(wrapedContent) do
                    parserLOG("add line::"..v)
                    table.insert(content, firstLine+i, v)
                end
            else
                parserLOG("add line::"..wrapedContent)
                table.insert(content, firstLine, wrapedContent)
            end

            parserLOG("PostWrap::\n".._TableToString(content))

            local new_content = content
            TREE["content"] = new_content

            content = nil
            new_content = nil
            return true
        end
        return nil
    end

    function TREE:Wrap()
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:Wrap ::::")
        TREE:tryUpdate()
        local wrapedTreeStr = XMLParser:Wrap("self")
        if wrapedTreeStr then
            local new_content = applyPostWrap("tree", wrapedTreeStr)
            if new_content then
                WriteXMLParserFileForTable(TREE["content"])
                return true
            end
        end
        return nil
    end
    function TREE:Unwrap()
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:Unwrap ::::")
        TREE:tryUpdate()
        local unwrapedTree = XMLParser:Unwrap("self")
        if unwrapedTree then
            local newcontent = applyPostWrap("tree", unwrapedTree)
            if newcontent then
                WriteXMLParserFileForTable(TREE["content"])
                return true
            end
        end
        return nil
    end

    function TREE:WrapAllItems()
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:WrapAllItems ::::")
        TREE:tryUpdate()
        if TREE["treeData"][2] then
            local item = 1
            while TREE["treeData"][2][item]~=nil do
                if not TREE:tryUpdate() then
                    parserLOG("[E] Module XMLParser.lua === Please, enable AutoUpdateTree() for work this function")
                    parserPRINT("Please, enable AutoUpdateTree() for work this function")
                    return nil
                end
                local objectParams = TREE["treeData"][2][item]
                local wrapedObjStr = XMLParser:Wrap(objectParams)
                if wrapedObjStr then
                    local newcontent = applyPostWrap(objectParams["_itemLine"], wrapedObjStr)
                    if newcontent then
                        WriteXMLParserFileForTable(TREE["content"])
                    end
                end
                item = item + 1
            end
        end
        return nil
    end
    function TREE:UnwrapAllItems()
        parserLOG(":::: global method XMLParser:Tree :::: global native function TREE:UnwrapAllItems ::::")
        TREE:tryUpdate()
        if TREE["treeData"][2] then
            local item = 1
            while TREE["treeData"][2][item]~=nil do
                if not TREE:tryUpdate() then
                    parserLOG("[E] Module XMLParser.lua === Please, enable AutoUpdateTree() for work this function")
                    parserPRINT("Please, enable AutoUpdateTree() for work this function")
                    return nil
                end
                local objectParams = TREE["treeData"][2][item]
                local wrapedObjStr = XMLParser:Unwrap(objectParams)
                if wrapedObjStr then
                    local newcontent = applyPostWrap(objectParams["_itemLine"], wrapedObjStr)
                    if newcontent then
                        WriteXMLParserFileForTable(TREE["content"])
                    end
                end
                item = item + 1
            end
        end
        return nil
    end



    --class object
    function TREE:GetObj(tableObjectTagXorCustomKey)
        parserLOG(":::: global method XMLParser:Tree :::: global method TREE:GetObj ::::")
        TREE:tryUpdate()
        local object
        local stringCustomKey = tableObjectTagXorCustomKey[2]
        local objectById = TREE:GetObjectById(stringCustomKey)
        local objectByCustomKey = TREE:GetObjectByCustomKey(stringCustomKey)
        local objectByName = TREE:GetObjectByName(stringCustomKey)
        local stringObjectTag = tableObjectTagXorCustomKey[1]
        local objectByTag = TREE:GetObject(stringObjectTag)
        
        if objectById then
            object = objectById
            --println("id")
        elseif objectByCustomKey then
            object = objectByCustomKey
            --println("CustomKey")
        elseif objectByName then
            object = objectByName
            --println("Name")
        elseif objectByTag and not stringCustomKey then
            object = objectByTag
            --println("Tag")
        end
        if tableObjectTagXorCustomKey[1] and tableObjectTagXorCustomKey[2] then
            if objectByCustomKey and objectByTag then
                if objectByCustomKey["_itemLine"]==objectByTag["_itemLine"] then
                    object = objectByCustomKey or objectByTag
                end
            end
        end

        if not object then
            parserLOG("[E] Module XMLParser.lua === Obj '"..stringObjectTag.."' does not exist")
            parserPRINT("Obj '"..stringObjectTag.."' does not exist")
            return nil
        end

        --parserLOG(tostring(_TableToString(object)))

        OBJ = {
            _object = object
        }

        function OBJ:GetProperties()
            parserLOG(":::: global method XMLParser:Tree :::: global method TREE:GetObj :::: global native function OBJ:GetProperties ::::")
            return OBJ["_object"]["_itemProperties"]
        end
        function OBJ:GetProperty(paramName)
            parserLOG(":::: global method XMLParser:Tree :::: global method TREE:GetObj :::: global native function OBJ:GetProperty ::::")
            local Value = OBJ["_object"]["_itemProperties"][paramName]
            return _INTERPRETATION(Value)
        end

        function OBJ:SetProperty(paramKey, paramValue)
            parserLOG(":::: global method XMLParser:Tree :::: global method TREE:GetObj :::: global native function OBJ:SetProperty ::::")
            local paramKey = paramKey or "Name"
            local paramValue = paramValue or "NewValue"
            if paramKey=="_itemTag" then
                parserLOG("[E] Module XMLParser.lua === You cannot change the tag name using this command")
                error("XMLParser: You cannot change the tag name using this command")
            end
    
            if TREE["content"] then
                local line = OBJ["_object"]["_itemLine"]
                while ((TREE["content"][line]~=nil) or (line==TREE["lastLine"])) do
                    if string.find(TREE["content"][line], paramKey) then
                        local editedStr, count = string.gsub(TREE["content"][line], '(%s+)'..tostring(paramKey)..'(%s*)=(%s*)"[^"]*"', '%1'..tostring(paramKey)..'%2=%3"'..tostring(paramValue)..'"')
                        if count>0 then
                            TREE["content"][line] = editedStr
    
                            WriteXMLParserFileForTable(TREE["content"])
                            return true
                        end
                    end
                    line=line+1
                    if string.find(TREE["content"][line-1], ">") then
                        break
                    end
                end
            end
            return nil
        end

        function OBJ:AddProperty(paramKey, paramValue, bSpaces)
            parserLOG(":::: global method XMLParser:Tree :::: global method TREE:GetObj :::: global native function OBJ:AddProperty ::::")
            local paramKey = paramKey or "NewParam"
            local paramValue = paramValue or "NewValue"
            
            local downedKeys = {"_itemTag", "_itemClass"}
            local i = 1
            while downedKeys[i]~=nil do
                if paramKey==downedKeys[i] then
                    parserLOG("[E] Module XMLParser.lua === You cannot add the '"..paramKey.."' using this command")
                    error("XMLParser: You cannot add the '"..paramKey.."' using this command")
                end
                i=i+1
            end
    
            if OBJ["_object"]["_itemProperties"] then
                if OBJ["_object"]["_itemProperties"][paramKey] then
                    parserLOG("[E] Module XMLParser.lua === This key '"..paramKey.."' already exists")
                    parserPRINT("This key '"..paramKey.."' already exists")
                    return false
                end
            end
    
            if TREE["content"] then
                local paramLine = OBJ["_object"]["_itemLine"]
                while ((TREE["content"][paramLine]~=nil) or (paramLine==TREE["lastLine"])) do
                    if string.find(TREE["content"][paramLine], "/>") then
                        break
                    end
                    paramLine=paramLine+1
                end
    
                local lineForAddParam = TREE["content"][paramLine]
    
                local savedTabs = ""
                local _, _, savedTabss = string.find(TREE["content"][paramLine], "(\t*)")
                if savedTabss then
                    savedTabs = savedTabss
                end

                local strSpaces = ""
                if bSpaces then
                    strSpaces = " "
                end
    
                local newStr = paramKey..''..strSpaces..'='..strSpaces..'"'..paramValue..'"'
                if string.find(TREE["content"][paramLine], "<"..OBJ["_object"]["_itemTag"]) then
                    TREE["content"][paramLine], count = string.gsub(TREE["content"][paramLine], '(%s*[^/]*)/>', '%1 '..newStr..' />')
                    if count==0 then
                        return nil
                    end
                else
                    TREE["content"][paramLine] = string.gsub(TREE["content"][paramLine], "/>", "")
                    paramLine = paramLine + 1
                    newStr = savedTabs..""..newStr.." />"
                    table.insert(TREE["content"], paramLine, newStr)
                end
    
                WriteXMLParserFileForTable(TREE["content"])
                return true
            end
            return nil
        end
    
        function OBJ:RemoveProperty(paramKey)
            parserLOG(":::: global method XMLParser:Tree :::: global method TREE:GetObj :::: global native function OBJ:RemoveProperty ::::")
            local paramKey = paramKey or "NewParam"
            
            local downedKeys = {"_itemTag", "_itemClass"}
            local i = 1
            while downedKeys[i]~=nil do
                if paramKey==downedKeys[i] then
                    parserLOG("[E] Module XMLParser.lua === You cannot remove the '"..paramKey.."' using this command")
                    error("XMLParser: You cannot remove the '"..paramKey.."' using this command")
                end
                i=i+1
            end
    
            if OBJ["_object"]["_itemProperties"] then
                if not OBJ["_object"]["_itemProperties"][paramKey] then
                    parserLOG("[E] Module XMLParser.lua === Key '"..paramKey.."' does not exist")
                    parserPRINT("Key '"..paramKey.."' does not exist")
                    return false
                end
            end
    
            if TREE["content"] then
                --local findObjectPattern = '%s*<([^>%s%/]+)>?[/%s]?'
                local findParamPattern = '%s+'..paramKey..'%s*=+%s*"([^"]*)"'
    
                local paramLine = OBJ["_object"]["_itemLine"]
                while ((TREE["content"][paramLine]~=nil) or (paramLine==TREE["lastLine"])) do
                    if string.find(TREE["content"][paramLine], findParamPattern) then
                        break
                    end
                    paramLine=paramLine+1
                end
    
                local newStr = ""
                if string.find(TREE["content"][paramLine], "<"..OBJ["_object"]["_itemTag"]) then
                    TREE["content"][paramLine], count = string.gsub(TREE["content"][paramLine], '%s*'..findParamPattern, newStr)
                    if count==0 then
                        return nil
                    end
                else
                    if string.find(TREE["content"][paramLine], "/>") then
                        table.remove(TREE["content"], paramLine)
                        paramLine=paramLine-1
                        TREE["content"][paramLine] = string.gsub(TREE["content"][paramLine], '(<?[^%s]*"?[^%s])', '%1 />')
                    else
                        table.remove(TREE["content"], paramLine)
                    end
                end
    
                WriteXMLParserFileForTable(TREE["content"])
                return true
            end
            return nil
        end

        function OBJ:GetName()
            parserLOG(":::: global method XMLParser:Tree :::: global method TREE:GetObj :::: global native function OBJ:GetName ::::")
            return OBJ["_object"]["_itemTag"]
        end
        function OBJ:GetObjName()
            parserLOG(":::: global method XMLParser:Tree :::: global method TREE:GetObj :::: global native function OBJ:GetObjName ::::")
            return OBJ["_object"]["_itemProperties"]["Name"]
        end

        function OBJ:GetPropertiesAmount()
            parserLOG(":::: global method XMLParser:Tree :::: global method TREE:GetObj :::: global native function OBJ:GetPropertiesAmount ::::")
            local skoka = 0
            if OBJ["_object"]["_itemProperties"] then
                for i, v in pairs(OBJ["_object"]["_itemProperties"]) do
                    skoka=skoka+1
                end
            end
            return skoka
        end
        

        function OBJ:Wrap()
            parserLOG(":::: global method XMLParser:Tree :::: global method TREE:GetObj :::: global native function OBJ:Wrap ::::")
            local objectParams = OBJ["_object"]
            local wrapedObjStr = XMLParser:Wrap(objectParams)
            if wrapedObjStr then
                local newcontent = applyPostWrap(objectParams["_itemLine"], wrapedObjStr)
                if newcontent then
                    WriteXMLParserFileForTable(TREE["content"])
                    return true
                end
            end
            return nil
        end
        function OBJ:Unwrap()
            parserLOG(":::: global method XMLParser:Tree :::: global method TREE:GetObj :::: global native function OBJ:Unwrap ::::")
            local objectParams = OBJ["_object"]
            local unwrapedObj = XMLParser:Unwrap(objectParams)
            if unwrapedObj then
                local newcontent = applyPostWrap(objectParams["_itemLine"], unwrapedObj)
                if newcontent then
                    WriteXMLParserFileForTable(TREE["content"])
                    return true
                end
            end
            return nil
        end

        function OBJ:GetParentName()
            parserLOG(":::: global method XMLParser:Tree :::: global method TREE:GetObj :::: global native function OBJ:GetParentName ::::")
            return OBJ["_object"]["_itemParent"]
        end

        
        return OBJ
    end


    return TREE
end


-- /////////////////////////// RETURN MODULE ////////////////////////////////


return XMLParser