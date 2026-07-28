<a id="top"></a>

<div align="center">

<table>
  <thead>
    <tr>
      <th style="text-align: center;">Содержание</th>
      <th style="text-align: center;">Table of contents (machine translation)</th>
    </tr>
  </thead>
  <tbody align="center">
    <tr>
      <td><a href="#wtf_ru">"Я вообще ничего не понимаю!"</a></td>
      <td><a href="#wtf_en">"I don't understand anything at all!"</a></td>
    </tr>
    <tr>
      <td><a href="#howToGet_ru">"Как получить информацию?"</a></td>
      <td><a href="#howToGet_en">"How do I get the information?"</a></td>
    </tr>
    <tr>
      <td><a href="#whatThisFunction_ru">"Что возвращают функции и что в них указывать?"</a></td>
      <td><a href="#whatThisFunction_en">"What do the functions return and what should I specify in them?"</a></td>
    </tr>
    <tr>
      <td><a href="#howToUseTable_ru">"Что мне делать с table?"</a></td>
      <td><a href="#howToUseTable_en">"What should I do with the table?"</a></td>
    </tr>
  </tbody>
</table>

</div>

***

<a id="wtf_ru"></a>

# "Я вообще ничего не понимаю!"
Возможно, вам следует для начала посмотреть [видео-туториалы от Павлика RPG](https://www.youtube.com/playlist?list=PLhr7tv0-Tfe97ymmkKnD_wgLVoaGxoJhv), там автор затрагивает самые основные принципы написания скриптов.

Или ознакомиться с уроками по lua Ex Machina для самых маленьких (Work in progress)

Если вы уже имеете базовые знания и можете визуально отличить `lua` от `c++`, ознакомились с [общим ReadMe у XMLParser](https://github.com/ejetaxeblevich/XMLParser/blob/main/README.md), тогда вы уже большой молодец!

<a id="howToGet_ru"></a><a href="#top">Наверх ↑</a>

# "Как получить информацию?"
## Вспомним приведенный пример из общего ReadMe:
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
### Вид файла и `xml` дерева, что тут вообще ищется и читается:
```xml
<?xml version="1.0" encoding="windows-1251" standalone="yes" ?>
<RootTagName>
    <Repository
        Name="My Items"
        OtherParameters="something">
        <Item
            Name="Item01"
            OtherParameter="bibka"
            MyParameterName="Value" />
    </Repository>
</RootTagName>
```
1. Входим внутрь `RootTagName`;
2. Находится дерево `Repository`;
3. Внутри `Repository` ищется объект `Item`;
4. Возвращается значение его `MyParameterName` = в данном случае это будет `Value`.

Здесь информацию возвращает `GetProperty` с интерпретацией `.AsString` - строчное значение строчного значения из файла, вау! 

Окей, если с разными интерпретациями дело относительно понятно (для функций, которые их поддерживают)
```
[.AsInt]     - возвращает целое число,
[.AsString]  - возвращает строку,
[.AsFloat]   - возвращает число с запятой,
[.AsBoolean] - возвращает логическое значение,
[.AsRUchars] - возвращает строку с переведенной латиницей на кириллицу,
[.AsENchars] - возвращает строку с переведенной кириллицей на латиницу
```
то может очень сильно озадачить строго возвращаемый тип данных у множества других функций.

<a id="whatThisFunction_ru"></a><a href="#top">Наверх ↑</a>

## Посмотрим внимательно на список публичных функций
А точнее на буковки после *загадочного* `[M]` и перед самой функцией:
| Какая-то фигня | Что это значит |
|-----------|----------|
|`void`|Функция НИЧЕГО не возвращает. Это значение будет всегда `nil` (пустота)|
|`string`|Возвращает строку с какими-то символами-буквами. Эти значения можно сравнивать `==` `~=` как константы или куда-то использовать дальше|
|`int`|Возвращает цельное число. Их можно как сравнивать `==` `~=` `>=` `>`, так и использовать в математических операциях по прямому назначению|
|`bool`|Возвращает истину `true` или ложь `false`. В некоторых случаях может вернуть `nil`. Это можно использовать как проверки|
|`table`|Возвращает таблицу (список, словарь). Из таблицы можно сразу взять какой-то ключ, либо прочесть эту таблицу перебором в цикле (см. ниже). В игре множество сущностей может расцениваться как таблица по типу данных, но не каждую из них можно прочесть|
|`descriptor`|Возвращает файловый дескриптор lua открытого файла. С его помощью файл *удерживается в памяти* игры, читается и редактируется|
|`tuple` или `&`|Возвращает несколько значений друг за другом. Это не тип данных. *Поймать* несколько значений можно так: `local a, b, c = Func()`|
|`AIParam`|Возвращает тот тип данных, который выбрал пользователь и посчитал скрипт. Обычно это есть у тех функций, которые имеют интерпретации значений|
|`???`|Возвращает тип данных, который неизвестен заранее. В большинстве случаев это может быть строка|

Вы также можете встретить подобные вещи внутри функций:
```
[const char*]  - строка,
[const CStr&]  - строка,
[const table*] - таблица,
[const int*]   - число,
[string]       - строка,
[int]          - число
... и т.д
```
это просто визуальное обозначение типов данных, которые ожидаются функцией при использовании!

Если вы видите функцию:
```c
[M] table ReadFromBigfile( const char* path_to_file, const char* ItemTagName, const char* AttributeName, const char* AttributeValue, int SkokaItems, int SkokaDepth )
```
Она будет использоваться как:
```lua
local myTrigger_tbl = XMLParser:ReadFromBigfile('data\\maps\\r2m1\\triggers.xml', "trigger", "Name", "trStartMap", 1, 2)
```

<a id="howToUseTable_ru"></a><a href="#top">Наверх ↑</a>

## Но основная сложность - это в чтении таблиц, верно?
Давайте разберемся как использовать `table`.

Таблица `{}` это очень мощная вещь в lua, позволяющая хранить любую информацию. Внутри таблицы может быть вложены другие таблицы - так создается иерархия данных (как папки на компьютере).

Перед тем, как прочитать таблицу и изъять из нее информацию, следует для начала понимать, *ЧТО ЗА ТАБЛИЦА* перед вами. Для этого отлично подойдет функция `PrintTable()`:
```lua
local tbl = XMLParser:ReturnTableFunction() --> функция возвращает table, сохраняем эту таблицу как tbl
local findLOGvalue = "Че это за таблица?" --> значение findLOGvalue для поиска по файлу в логе игры
XMLParser:PrintTable(tbl, findLOGvalue)  --> выводим в лог игры содержимое таблицы tbl, вбиваем в поиск по файлу: Че это за таблица?
```
После того, как узнали внутренности таблицы, можно приступать к ее разбору:

### Если таблица начинается с индекса `1` - это таблица-список. Ее мы перебираем в цикле `for` и используем `ipairs()`:
```lua
for i, value in ipairs(tbl) do
    LOG(i, value)
end
```
```lua
for i, value in ipairs(tbl) do
    if value == "bibka" then
        LOG(value)
        break       --> останавливаем цикл
    end
end
```
`ipairs()` передвигается только по индексам `i`, которые не являются `false` или `nil`. Иначе цикл остановится! 

### Если таблица содержит буквенные ключи `key = value` - это таблица-словарь. Ее мы перебираем в цикле `for` и используем `pairs()`:
```lua
for key, value in pairs(tbl) do
    LOG(key, value)
end
```
```lua
for key, value in pairs(tbl) do
    if key == "_itemTag" then
        LOG(value)
        break       --> останавливаем цикл
    end
end
```
`pairs()` передвигается по всем ключам и индексам таблицы, но в неопределенном порядке.

#### Ключ можно сразу получить из таблицы без ее перебора, если вы знаете, что этот ключ там точно есть:
```lua
local Properties = tbl._itemProperties  --> из tbl берем _itemProperties
LOG(Properties.Name)    --> из _itemProperties берем Name
```
#### Или сразу его перебрать, если значение ключа - таблица:
```lua
for key, value in pairs(tbl._itemProperties) do
    LOG(key, value)
end
```
#### Узнать, что значение = таблица, можно вот так:
```lua
--так можно проверить любой тип данных lua
if type(value)=="table" then
    ...
end
```

***ВСЕ ЦИКЛЫ НАГРУЖАЮТ ИГРУ*** в зависимости от количества итераций (тысячи+) и операций внутри тела цикла. Очень нежелательны циклы в циклах, *но кто ими вообще злоупотребляет? :))))*

<a href="#top">Наверх ↑</a>

----

----

<a id="wtf_en"></a>

# "I don't understand anything at all!"
Perhaps you should start by watching [Pavlik RPG Video tutorials](https://www.youtube.com/playlist?list=PLhr7tv0-Tfe97ymmkKnD_wgLVoaGxoJhv), where the author touches on the most basic principles of writing scripts.

Or read the lessons on lua Ex Machina for the youngest (Work in progress)

If you already have basic knowledge and can visually distinguish `lua` from `c++`, check out the [XMLParser general ReadMe](https://github.com/ejetaxeblevich/XMLParser/blob/main/README.md), then you're already doing a great job!

<a id="howToGet_en"></a><a href="#top">Go up ↑</a>

# "How do I get information?"
## Let's recall the given example from the general ReadMe:
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
### The type of file and the `xml` tree, what is generally searched and read here:
```xml
<?xml version="1.0" encoding="windows-1251" standalone="yes" ?>
<RootTagName>
    <Repository
        Name="My Items"
        OtherParameters="something">
        <Item
            Name="Item01"
            OtherParameter="bibka"
            MyParameterName="Value" />
    </Repository>
</RootTagName>
```
1. Enter the `RootTagName`;
2. The `Repository` tree is located;
3. The `Item` object is searched inside the `Repository`;
4. The value of its `MyParameterName` is returned = in this case, it will be `Value`.

Here, the information is returned by `GetProperty` with the interpretation of `.AsString` - the lowercase value of the lowercase value from the file, wow! 

Okay, if the different interpretations are relatively clear (for the functions that support them)
```
[.AsInt]     - returns a integer,
[.AsString]  - returns a string,
[.AsFloat]   - returns a number with a comma,
[.AsBoolean] - returns a boolean value,
[.AsRUchars] - returns a string with the Latin alphabet translated into Cyrillic,
[.AsENchars] - returns a string from translated Cyrillic to Latin
```
but it can be very confusing to have a strictly returned data type in many other functions.

<a id="whatThisFunction_en"></a><a href="#top">Go up ↑</a>

## Let's take a closer look at the list of public functions
Or rather, the letters after the *mysterious* `[M]` and before the function itself:
| Some kind of bullshit | What does it mean |
|-----------|----------|
|`void`|The function does not return ANYTHING. This value will always be `nil` (empty)|
|`string`|Returns a string with some characters-letters. These values can be compared `==` `~=` as constants or used somewhere else.|
|`int`|Returns a whole number. How can they be compared `==` `~=` `>=` `>`, It can also be used in mathematical operations for its intended purpose.|
|`bool`|Returns true `true` or false `false`. In some cases, it may return `nil`. This can be used as a check.|
|`table`|Returns a table (list, dictionary). You can immediately take a key from the table, or you can iterate through this table in a loop (see below). In a game, many entities can be regarded as a table by data type, but not every one of them can be read.|
|`descriptor`|Returns the lua file descriptor of an open file. With it, the file is *held in memory* of the game, read and edited.|
|`tuple` or `&`|Returns multiple values one after the other. This is not a data type. *Catch* multiple values like this: `local a, b, c = Func()`|
|`AIParam`|Returns the data type that the user selected and calculated the script. Usually, those functions that have interpretations of values have this.|
|`???`|Returns a data type that is unknown in advance. In most cases, it can be a string.|

You can also find similar things inside functions:
```
[const char*]  - string,
[const CStr&]  - string,
[const table*] - table,
[const int*]   - number,
[string]       - string,
[int]          - number
... etc
```
this is just a visual indication of the data types that are expected by the function when used!

If you see the function:
```c
[M] table ReadFromBigfile( const char* path_to_file, const char* ItemTagName, const char* AttributeName, const char* AttributeValue, int SkokaItems, int SkokaDepth )
```
It will be used as:
```lua
local myTrigger_tbl = XMLParser:ReadFromBigfile('data\\maps\\r2m1\\triggers.xml', "trigger", "Name", "trStartMap", 1, 2)
```

<a id="howToUseTable_en"></a><a href="#top">Go up ↑</a>

## But the main difficulty is reading the tables, right?
Let's figure out how to use `table`.

The `{}` table is a very powerful thing in lua that allows you to store any information. Other tables can be nested inside the table, which creates a hierarchy of data (like folders on a computer).

Before reading the table and removing information from it, you should first understand *WHAT KIND OF TABLE* is in front of you. The `PrintTable()` function is perfect for this:
```lua
local tbl = XMLParser:ReturnTableFunction() --> the function returns a table, we save this table as tbl
local findLOGvalue = "What kind of table is this?" --> the findLOGvalue value for searching the file in the game log
XMLParser:PrintTable(tbl, findLOGvalue)  --> we output the contents of the tbl table to the game log, enter it into the file search: What kind of table is this?
```
After you have learned the insides of the table, you can start parsing it:

### If the table starts with the index `1`, it is a list table. We iterate through it in the `for` loop and use `ipairs()`:
```lua
for i, value in ipairs(tbl) do
    LOG(i, value)
end
```
```lua
for i, value in ipairs(tbl) do
    if value == "bibka" then
        LOG(value)
        break       --> stops
    end
end
```
`ipairs()` moves only by the `i` indexes, which are not `false` or `nil`. Otherwise, the cycle will stop!

### If the table contains alphabetic keys, `key = value` is a dictionary table. We iterate through it in the `for` loop and use `pairs()`:
```lua
for key, value in pairs(tbl) do
    LOG(key, value)
end
```
```lua
for key, value in pairs(tbl) do
    if key == "_itemTag" then
        LOG(value)
        break       --> stops
    end
end
```
`pairs()` moves through all the keys and indexes of the table, but in an unspecified order.

#### You can immediately get the key from the table without going through it, if you know that this key is definitely there:
```lua
local Properties = tbl._itemProperties  --> we take _itemProperties from tbl
LOG(Properties.Name)    --> we take Name from _itemProperties
```
#### Or go through it right away if the key value is a table:
```lua
for key, value in pairs(tbl._itemProperties) do
    LOG(key, value)
end
```
#### You can find out that the value = table like this:
```lua
--This way you can check any type of lua data
if type(value)=="table" then
    ...
end
```

***ALL THE LOOPS OVERLOAD THE GAME*** depending on the number of iterations (thousands+) and operations inside the loop body. Cycles within cycles are highly undesirable, * but who abuses them at all? :))))*

<a href="#top">Go up ↑</a>

