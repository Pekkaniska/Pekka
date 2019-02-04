#Область ПрограммныйИнтерфейс

// Возвращает новую структуру описания возвращаемых данных.
// 
// Возвращаемое значение:
//   - Структура - описание данных:
//      * МодульМенеджер - ОбщийМодуль, МодульМенеджераОбъекта - модуль менеджера получения данных.
//      * Наименование - Строка - наименование возвращаемых данных.
//      * Описание - Строка - подробное описание возвращаемых данных.
//      * ТипыРезультата - Массив[Строка] - типы возвращаемых данных. 
//
Функция НовыйОписаниеВозвращаемыхДанных() Экспорт
    
    ОписаниеДанных = Новый Структура;
    ОписаниеДанных.Вставить("МодульМенеджер","");
    ОписаниеДанных.Вставить("Наименование","");
    ОписаниеДанных.Вставить("Описание","");
    ОписаниеДанных.Вставить("ТипыРезультата", Новый Массив);
    
    Возврат ОписаниеДанных;
    
КонецФункции
 
// Возвращает перечень доступных данных
// 
// Возвращаемое значение:
//   - Соответствие - перечень доступных возвращаемых данных.
//     * Ключ - идентификатор данных
//     * Значение - Структура - описание данных (см. АсинхронноеПолучениеДанных.НовыйОписаниеВозвращаемыхДанных) 
//
Функция ДоступныеВозвращаемыеДанные() Экспорт
    
    ДоступныеВозвращаемыеДанные = Новый Соответствие;
    АсинхронноеПолучениеДанныхПереопределяемый.УстановитьДоступныеВозвращаемыеДанные(ДоступныеВозвращаемыеДанные);
    
    Если Метаданные.ОбщиеМодули.Найти("_ДемоТехнологияСервиса") <> Неопределено Тогда
        Модуль_ДемоТехнологияСервиса = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("_ДемоТехнологияСервиса");
        Модуль_ДемоТехнологияСервиса.УстановитьДоступныеВозвращаемыеДанные(ДоступныеВозвращаемыеДанные);
    КонецЕсли;     
    
    Возврат ДоступныеВозвращаемыеДанные;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ЛогическоеХранилище
    
// Возвращает описание данных логического хранилища.
//
// Параметры:
//  ИдентификаторХранилища - Строка - идентификатор логического хранилища.
//  ИдентификаторДанных    - Строка - идентификатор данных хранилища.
// 
// Возвращаемое значение:
//   - Структура - описание данных, которые можно получить.
//       - ИмяФайла - Строка - имя файла описания.
//       - Размер - Число - размер файла в байтах.
//       - Данные - ДвоичныеДанные - двоичные данные файла описания задания.
//
Функция Описание(ИдентификаторХранилища, ИдентификаторДанных) Экспорт
    
    Словарь = АсинхронноеПолучениеДанныхСловарь;
    Если ВРег(ИдентификаторДанных) = ВРег(Словарь.ЗапросСписок()) Тогда
        СписокДоступныхВозвращаемыхДанных = Новый Массив;
        ДоступныеВозвращаемыеДанные = ДоступныеВозвращаемыеДанные();
        Для Каждого Элемент Из ДоступныеВозвращаемыеДанные Цикл
            ОписаниеВозвращаемыхДанных = Новый Структура;
            ОписаниеВозвращаемыхДанных.Вставить("id", Элемент.Ключ);
            ОписаниеВозвращаемыхДанных.Вставить("name", Элемент.Значение.Наименование);
            ОписаниеВозвращаемыхДанных.Вставить("description", Элемент.Значение.Описание);
            ОписаниеВозвращаемыхДанных.Вставить("result_types", Элемент.Значение.ТипыРезультата);
            СписокДоступныхВозвращаемыхДанных.Добавить(ОписаниеВозвращаемыхДанных);            
        КонецЦикла; 
        Данные = РаботаВМоделиСервисаБТС.СтрокаИзСтруктурыJSON(СписокДоступныхВозвращаемыхДанных);
        Описание = Новый Структура;
        Описание.Вставить("ИмяФайла", СтрШаблон("%1.%2", Словарь.ЗапросСписок(), Словарь.ТипJSON()));
        Описание.Вставить("Данные", ПолучитьДвоичныеДанныеИзСтроки(Данные));
        Описание.Вставить("Размер", Описание.Данные.Размер());
        Возврат Описание;
    КонецЕсли; 
    
    Возврат Неопределено;
    
КонецФункции

// Возвращает данные логического хранилища.
//
// Параметры:
//  ОписаниеДанных - Структура - описание данных хранилища.
// 
// Возвращаемое значение:
//   ДвоичныеДанные - данные из описания данных (см. метод Описание).
//
Функция Данные(ОписаниеДанных) Экспорт
   
	Возврат ОписаниеДанных.Данные;
	
КонецФункции

// Записывает данные в логическое хранилище.
// 
// Параметры:
//  Структура - описание данных хранилища.
//    - ИмяФайла - Строка - имя файла.
//    - Размер - Число - размер файла в байтах.
//    - Данные - ДвоичныеДанные, Строка - двоичные данные файла или расположение файла на диске.
// 
// Возвращаемое значение:
//  - Строка - идентификатор данных хранилища.
//   
Функция Загрузить(ОписаниеДанных) Экспорт
    
    Словарь = АсинхронноеПолучениеДанныхСловарь;
    УстановитьПривилегированныйРежим(Истина);
    Ответ = ОтветПоУмолчанию();
    ИдентификаторДанных = НРег(ОписаниеДанных.ИмяФайла);
    Параметры = Новый ДвоичныеДанные(ОписаниеДанных.Данные);
    Если ЗначениеЗаполнено(Параметры) Тогда
        ИдентификаторНастроек = ФайлыОбластейДанных.ЗагрузитьФайл(ОписаниеДанных.ИмяФайла + ".settings", Параметры);
    Иначе
        ИдентификаторНастроек = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
    КонецЕсли; 
    
    ДоступныеВозвращаемыеДанные = ДоступныеВозвращаемыеДанные();
    Если ДоступныеВозвращаемыеДанные.Получить(ИдентификаторДанных) = Неопределено Тогда
        УстановитьОтсутствиеДанных(Ответ);
        Возврат Ответ;
    КонецЕсли; 

   	Задание = ДобавитьЗаданиеПодготовкиДанных(ИдентификаторДанных, ИдентификаторНастроек, Параметры);
    ИдентификаторЗадания = Задание.УникальныйИдентификатор();
    РегистрыСведений.СвойстваЗаданий.Установить(Задание);
    Результат = Новый Структура;
    Результат.Вставить(Словарь.ПолеХранилище(), ОчередьЗаданийВнешнийИнтерфейс.ИдентификаторХранилища());
    Результат.Вставить(Словарь.ПолеИдентификатор(), Строка(ИдентификаторЗадания));
    Ответ[Словарь.ПолеРезультат()] = Результат;
    
    Возврат Ответ;
    
КонецФункции

// Возвращает идентификатор хранилища в виде строки.
// 
// Возвращаемое значение:
//   - Строка - идентификатор хранилища. 
//
Функция ИдентификаторХранилища() Экспорт
	
	Возврат "async";
	
КонецФункции

#КонецОбласти

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков.
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	СоответствиеИменПсевдонимам.Вставить("АсинхронноеПолучениеДанных.ПодготовитьДанные");
	
КонецПроцедуры                                                       

// Обработчик задания очереди заданий.
//
// Параметры:
//  ИдентификаторДанных - Строка - идентификатор данных, которые нужно получить.
//  ИдентификаторПараметров - УникальныйИдентификатор - идентификатор файла параметров получения данных.
//
Процедура ПодготовитьДанные(ИдентификаторДанных, ИдентификаторПараметров) Экспорт
	
    Словарь = АсинхронноеПолучениеДанныхСловарь;
    ОчередьСловарь = ОчередьЗаданийВнешнийИнтерфейсСловарь;
    Если ЗначениеЗаполнено(ИдентификаторПараметров) Тогда
        Параметры = ФайлыОбластейДанных.ДвоичныеДанныеФайла(ИдентификаторПараметров);
    Иначе
        Параметры = ПолучитьДвоичныеДанныеИзСтроки("");
    КонецЕсли; 
    КлючЗадания = КлючЗаданияПодготовкиДанных(ИдентификаторДанных, Параметры);
    ИдентификаторЗадания = ОчередьЗаданийВнешнийИнтерфейс.ИдентификаторЗадания(КлючЗадания);
    Попытка
        ВозвращаемыеДанные = ДоступныеВозвращаемыеДанные();
        ПараметрыВозвращаемыхДанных = ВозвращаемыеДанные.Получить(ИдентификаторДанных);
        Если ПараметрыВозвращаемыхДанных = Неопределено Тогда
            Свойства = РегистрыСведений.СвойстваЗаданий.НовыйСвойстваЗадания();
            Свойства.КодСостояния = ОчередьСловарь.КодСостоянияНеНайдено();
            РегистрыСведений.СвойстваЗаданий.Установить(ИдентификаторЗадания, Свойства);
            Возврат;
        КонецЕсли;
        МенеджерДанных = ПараметрыВозвращаемыхДанных.МодульМенеджер;
        Свойства = РегистрыСведений.СвойстваЗаданий.НовыйСвойстваЗадания();
        Свойства.КодСостояния = ОчередьСловарь.КодСостоянияВыполнено();
        Данные = МенеджерДанных.ВозвращаемыеДанные(ИдентификаторДанных, Параметры, 
            Свойства.КодСостояния, Свойства.Ошибка, Свойства.СообщениеОбОшибке);
        Если ЗначениеЗаполнено(Данные) Тогда
            ИдентификаторРезультата = ФайлыОбластейДанных.ЗагрузитьФайл(ИдентификаторДанных, Данные,,, Истина);
            Результат = Новый Структура;
            Результат.Вставить(Словарь.ПолеХранилище(), ФайлыОбластейДанных.ИдентификаторХранилища());
            Результат.Вставить(Словарь.ПолеИдентификатор(), Строка(ИдентификаторРезультата));
            Свойства.Результат = РаботаВМоделиСервисаБТС.СтрокаИзСтруктурыJSON(Результат);
        КонецЕсли; 
        РегистрыСведений.СвойстваЗаданий.Установить(ИдентификаторЗадания, Свойства);
        Если Свойства.КодСостояния <> ОчередьЗаданийВнешнийИнтерфейсСловарь.КодСостоянияОжидание() Тогда
            ФайлыОбластейДанных.УстановитьПризнакВременного(ИдентификаторПараметров);
        КонецЕсли;
    Исключение
        ОчередьЗаданийВнешнийИнтерфейс.УстановитьВнутреннююОшибку(
            ИдентификаторЗадания, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
        ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
    КонецПопытки
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции
 
// Добавляет задание подготовки данных в очередь заданий.
//
// Параметры:
//  ИдентификаторДанных - Строка - идентификатор данных.
//  ИдентификаторПараметров - УникальныйИдентификатор - идентификатор файла параметров получения данных.
//  Параметры - ДвоичныеДанные - параметры получения данных.
// 
// Возвращаемое значение: 
//  - СправочникСсылка.ОчередьЗаданий, СправочникСсылка.ОчередьЗаданийОбластейДанных - идентификатор добавленного задания.
//
Функция ДобавитьЗаданиеПодготовкиДанных(ИдентификаторДанных, ИдентификаторПараметров, Параметры)
    
    КлючЗадания = КлючЗаданияПодготовкиДанных(ИдентификаторДанных, Параметры);
    
    ПараметрыЗапуска = Новый Массив();
    ПараметрыЗапуска.Добавить(ИдентификаторДанных);
    ПараметрыЗапуска.Добавить(ИдентификаторПараметров);
    
    ПараметрыЗадания = Новый Структура;
    ПараметрыЗадания.Вставить("ОбластьДанных", ОбщегоНазначения.ЗначениеРазделителяСеанса());
    ПараметрыЗадания.Вставить("Использование", Истина);
    ПараметрыЗадания.Вставить("ЭксклюзивноеВыполнение", Истина);
    ПараметрыЗадания.Вставить("ИмяМетода", "АсинхронноеПолучениеДанных.ПодготовитьДанные");
    ПараметрыЗадания.Вставить("Параметры", ПараметрыЗапуска);
    ПараметрыЗадания.Вставить("Ключ", КлючЗадания);
    ПараметрыЗадания.Вставить("ИнтервалПовтораПриАварийномЗавершении", 0);
    ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 0);
    
    Возврат ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
	
КонецФункции

Функция КлючЗаданияПодготовкиДанных(ИдентификаторДанных, Параметры)
    
    Хэширование = Новый ХешированиеДанных(ХешФункция.SHA1);
    Хэширование.Добавить(Параметры);
    ХэшНастроек = Base64Строка(Хэширование.ХешСумма);
    
    Возврат СтрШаблон("%1/%2", ИдентификаторДанных, ХэшНастроек);
	
КонецФункции

Функция ОтветПоУмолчанию()
	
    Словарь = АсинхронноеПолучениеДанныхСловарь;
    ОсновнойРаздел = Новый Структура;
    ОсновнойРаздел.Вставить(Словарь.ПолеКодВозврата(), Словарь.КодВозвратаВыполнено());
    ОсновнойРаздел.Вставить(Словарь.ПолеОшибка(), Ложь);
    ОсновнойРаздел.Вставить(Словарь.ПолеСообщениеОбОшибке(), "");
    ОтветПоУмолчанию = Новый Структура;
    ОтветПоУмолчанию.Вставить(Словарь.ПолеОсновнойРаздел(), ОсновнойРаздел);
    ОтветПоУмолчанию.Вставить(Словарь.ПолеРезультат());
    
    Возврат ОтветПоУмолчанию;
    
КонецФункции

Процедура УстановитьОтсутствиеДанных(Ответ)
    
    Словарь = АсинхронноеПолучениеДанныхСловарь;
    Ответ[Словарь.ПолеОсновнойРаздел()][Словарь.ПолеКодВозврата()] = Словарь.КодВозвратаНеНайдено();    
    УдалитьПустойРезультат(Ответ);	
    
КонецПроцедуры

Процедура УдалитьПустойРезультат(Ответ)
	
    ПолеРезультат = ИнтеграцияОбъектовОбластейДанныхСловарь.ПолеРезультат();
    Если Ответ.Свойство(ПолеРезультат) И Не ЗначениеЗаполнено(Ответ[ПолеРезультат]) Тогда
        Ответ.Удалить(ПолеРезультат);
    КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти