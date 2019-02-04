#Область ПрограммныйИнтерфейс

// Определяет объекты конфигурации, в модулях менеджеров которых размещена процедура ДобавитьКомандыПечати,
// формирующая список команд печати, предоставляемых этим объектом.
// Синтаксис процедуры ДобавитьКомандыПечати см. в документации к подсистеме.
//
// Параметры:
//  СписокОбъектов - Массив - менеджеры объектов с процедурой ДобавитьКомандыПечати.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	//++ НЕ ГОСИС
	УправлениеПечатьюУТСервер.ОпределитьОбъектыСКомандамиПечати(СписокОбъектов);
	// ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействие.ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов);
	// Конец ЭлектронноеВзаимодействие
	
	//++ НЕ УТ
	РегламентированнаяОтчетность.ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов);
	//-- НЕ УТ
	
	//-- НЕ ГОСИС
	
	//Владимир Подрезов Рарус 22.07.2016
	СписокОбъектов.Добавить(Документы.пкЗаданиеНаПеревозку);
	СписокОбъектов.Добавить(Документы.пкЗаданиеНаРемонт);
	СписокОбъектов.Добавить(Документы.пкЗаказНаряд);
	СписокОбъектов.Добавить(Документы.пкЗаявкаНаАрендуТехники);
	СписокОбъектов.Добавить(Документы.пкЗаявкаНаВыездМеханика);
	СписокОбъектов.Добавить(Документы.пкОперацииСТехникой);
	СписокОбъектов.Добавить(Документы.пкДоставка);
	СписокОбъектов.Добавить(Документы.пкКорректировкаНетиповыхРегистров);
	СписокОбъектов.Добавить(Документы.пкИзменениеСтатусаТехники);
	СписокОбъектов.Добавить(Документы.пкЗаявкаНаРемонтУДилера);
	СписокОбъектов.Добавить(Документы.пкВыдачаТопливныхКарт);
	СписокОбъектов.Добавить(Документы.пкИнвентаризацияРасчетовСКонтрагентами);
	СписокОбъектов.Добавить(Документы.пкПретензия);
	СписокОбъектов.Добавить(Документы.пкСудебныйИск);
	//byse НЕ ИСПОЛЬЗУЕТСЯ СписокОбъектов.Добавить(Документы.пкСобытие);
	СписокОбъектов.Добавить(Документы.уатВводВЭксплуатациюТСиОборудования);
	//Владимир Подрезов Рарус 22.07.2016 КОНЕЦ
	
	//++ Рарус Лимаренко 31.05.2018
	СписокОбъектов.Добавить(Справочники.ДоговорыКонтрагентов);
	СписокОбъектов.Добавить(Справочники.пкДополнительныеСоглашенияКДоговорам);
	СписокОбъектов.Добавить(Документы.пкАктПриемкиВозврата);
	СписокОбъектов.Добавить(Документы.пкЗаявкаНаРемонтЗапчасти);
	СписокОбъектов.Добавить(Документы.пкКоммерческоеПредложениеНаАрендуТехники);
	СписокОбъектов.Добавить(Документы.пкОперацииСПультами);
	СписокОбъектов.Добавить(Документы.уатПутевойЛист);
	//-- Рарус Лимаренко 31.05.2018
	
	//Владимир Подрезов Рарус 14.01.2017
	СписокОбъектов.Добавить(Документы.пкЗаправочнаяВедомость);
	//Владимир Подрезов Рарус КОНЕЦ
	
КонецПроцедуры

// Переопределяет таблицу возможных форматов для сохранения табличного документа.
// Используется в случае, когда необходимо сократить список форматов сохранения, предлагаемый пользователю
// перед сохранением печатной формы в файл, либо перед отправкой по почте.
//
// Параметры:
//  ТаблицаФорматов - ТаблицаЗначений - коллекция форматов сохранения:
//   * ТипФайлаТабличногоДокумента - ТипФайлаТабличногоДокумента - значение в платформе, соответствующее формату;
//   * Ссылка        - ПеречислениеСсылка.ФорматыСохраненияОтчетов - ссылка на метаданные, где хранится представление;
//   * Представление - Строка - представление типа файла (заполняется из перечисления);
//   * Расширение    - Строка - тип файла для операционной системы;
//   * Картинка      - Картинка - значок формата.
//
Процедура ПриЗаполненииНастроекФорматовСохраненияТабличногоДокумента(ТаблицаФорматов) Экспорт
	
	//++ НЕ ГОСИС
	УправлениеПечатьюУТСервер.ЗаполнитьНастройкиФорматовСохраненияТабличногоДокумента(ТаблицаФорматов);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Переопределяет список команд печати, получаемый функцией УправлениеПечатью.КомандыПечатиФормы.
// Используется для общих форм, у которых нет модуля менеджера для размещения в нем процедуры ДобавитьКомандыПечати,
// для случаев, когда штатных средств добавления команд в такие формы недостаточно. Например, если нужны свои команды,
// которых нет в других объектах.
// 
// Параметры:
//  ИмяФормы             - Строка - полное имя формы, в которой добавляются команды печати;
//  КомандыПечати        - ТаблицаЗначений - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати;
//  СтандартнаяОбработка - Булево - при установке значения Ложь не будет автоматически заполняться коллекция КомандыПечати.
//
Процедура ПередДобавлениемКомандПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	УправлениеПечатьюУТСервер.ДобавитьКомандыПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Дополнительные настройки списка команд печати в журналах документов.
//
// Параметры:
//  НастройкиСписка - Структура - модификаторы списка команд печати.
//   * МенеджерКомандПечати     - МенеджерОбъекта - менеджер объекта, в котором формируется список команд печати;
//   * АвтоматическоеЗаполнение - Булево - заполнять команды печати из объектов, входящих в состав журнала.
//                                         Если установлено значение Ложь, то список команд печати журнала будет
//                                         заполнен вызовом метода ДобавитьКомандыПечати из модуля менеджера журнала.
//                                         Значение по умолчанию: Истина - метод ДобавитьКомандыПечати будет вызван из
//                                         модулей менеджеров документов, входящих в состав журнала.
Процедура ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка) Экспорт
	
	//++ НЕ ГОСИС
	
	УправлениеПечатьюУТСервер.ПолучитьНастройкиСпискаКомандПечати(НастройкиСписка);
	
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Вызывается после завершения вызова процедуры Печать менеджера печати объекта, имеет те же параметры.
// Может использоваться для постобработки всех печатных форм при их формировании.
// Например, можно вставить в колонтитул дату формирования печатной формы.
//
// Параметры:
//  МассивОбъектов - Массив - список объектов, для которых была выполнена процедура Печать;
//  ПараметрыПечати - Структура - произвольные параметры, переданные при вызове команды печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - содержит табличные документы и дополнительную информацию;
//  ОбъектыПечати - СписокЗначений - соответствие между объектами и именами областей в табличных документах, где
//                                   значение - Объект, представление - имя области с объектом в табличных документах;
//  ПараметрыВывода - Структура - параметры, связанные с выводом табличных документов:
//   * ПараметрыОтправки - Структура - информация для заполнения письма при отправке печатной формы по электронной почте.
//                                     Содержит следующие поля (описание см. в общем модуле конфигурации
//                                     РаботаСПочтовымиСообщениямиКлиент в процедуре СоздатьНовоеПисьмо):
//    ** Получатель;
//    ** Тема,
//    ** Текст.
Процедура ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	//++ НЕ ГОСИС
	УправлениеПечатьюУТСервер.ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Переопределяет параметры отправки печатных форм при подготовке письма.
// Может использоваться, например, для подготовки текста письма.
//
// Параметры:
//  ПараметрыОтправки - Структура - коллекция параметров:
//   * Получатель - Массив - коллекция имен получателей;
//   * Тема - Строка - тема письма;
//   * Текст - Строка - текст письма;
//   * Вложения - Структура - коллекция вложений:
//    ** АдресВоВременномХранилище - Строка - адрес вложения во временном хранилище;
//    ** Представление - Строка - имя файла вложения.
//  ОбъектыПечати - Массив - коллекция объектов, по которым сформированы печатные формы.
//  ПараметрыВывода - Структура - параметр ПараметрыВывода в вызове процедуры Печать.
//  ПечатныеФормы - ТаблицаЗначений - коллекция табличных документов:
//   * Название - Строка - название печатной формы;
//   * ТабличныйДокумент - ТабличныйДокумент - печатая форма.
Процедура ПередОтправкойПоПочте(ПараметрыОтправки, ПараметрыВывода, ОбъектыПечати, ПечатныеФормы) Экспорт
	
	//++ НЕ ГОСИС
	УправлениеПечатьюУТСервер.ПередОтправкойПоПочте(ПараметрыОтправки, ПараметрыВывода, ОбъектыПечати, ПечатныеФормы);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти
