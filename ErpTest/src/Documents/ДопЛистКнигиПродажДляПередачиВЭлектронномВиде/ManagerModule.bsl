#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьОбъект(Объект, СтруктураПараметров) Экспорт

	ЗаполнениеДокументов.Заполнить(Объект, СтруктураПараметров);
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("ПериодПоСКНП", Объект.ПериодПоСКНП);
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор());
	ПодготовитьДанныеДляЗаполнения(СтруктураПараметров, АдресХранилища);
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если СтруктураПараметров.ФорматПоПостановлению735 Тогда
		Объект.ДополнительныеСвойства.Вставить("АдресДанныхДляПередачи", АдресХранилища);
	Иначе
		
		Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		
		Если СтруктураДанных.Свойство("ТабличнаяЧасть") Тогда
			Объект.ТабличнаяЧасть.Загрузить(СтруктураДанных.ТабличнаяЧасть);
		КонецЕсли;
		
		Если СтруктураДанных.Свойство("РеквизитыДокумента") Тогда
			ЗаполнитьЗначенияСвойств(Объект, СтруктураДанных.РеквизитыДокумента);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ПодготовитьДанныеДляЗаполнения(ПараметрыДляЗаполнения, АдресХранилища) Экспорт
	
	НачалоНалоговогоПериода = УчетНДСПереопределяемый.НачалоНалоговогоПериода(
		ПараметрыДляЗаполнения.Организация, ПараметрыДляЗаполнения.НалоговыйПериод);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("НачалоПериода",
		?(ПараметрыДляЗаполнения.ФорматПоПостановлению735, 
			НачалоКвартала(ПараметрыДляЗаполнения.НалоговыйПериод), НачалоДня(ПараметрыДляЗаполнения.Дата)));
	СтруктураПараметров.Вставить("КонецПериода",
		?(ПараметрыДляЗаполнения.ФорматПоПостановлению735, 
			КонецКвартала(ПараметрыДляЗаполнения.НалоговыйПериод), КонецДня(ПараметрыДляЗаполнения.Дата)));
			
	СтруктураПараметров.Вставить("Организация",              ПараметрыДляЗаполнения.Организация);
	СтруктураПараметров.Вставить("НачалоНалоговогоПериода",  НачалоНалоговогоПериода);
	СтруктураПараметров.Вставить("КонецНалоговогоПериода",   КонецКвартала(ПараметрыДляЗаполнения.НалоговыйПериод));
	СтруктураПараметров.Вставить("ФорматПоПостановлению735", ПараметрыДляЗаполнения.ФорматПоПостановлению735);
	СтруктураПараметров.Вставить("ПериодПоСКНП",             ПараметрыДляЗаполнения.ПериодПоСКНП);
	
	СтруктураПараметров.Вставить("ФормироватьДополнительныеЛисты",      Истина);
	СтруктураПараметров.Вставить("ДополнительныеЛистыЗаТекущийПериод",  Истина);
	СтруктураПараметров.Вставить("ГруппироватьПоКонтрагентам",          Ложь);
	СтруктураПараметров.Вставить("КонтрагентДляОтбора",                 Справочники.Контрагенты.ПустаяСсылка());
	СтруктураПараметров.Вставить("ВыводитьТолькоДопЛисты",              Истина);
	СтруктураПараметров.Вставить("ВыводитьПокупателейПоАвансам",        Ложь);
	СтруктураПараметров.Вставить("ВключатьОбособленныеПодразделения",   Истина);
	СтруктураПараметров.Вставить("СформироватьОтчетПоСтандартнойФорме", Истина);
	СтруктураПараметров.Вставить("ОтбиратьПоКонтрагенту",               Ложь);
	СтруктураПараметров.Вставить("ВыводитьПродавцовПоАвансам",          Ложь);
	
	СтруктураПараметров.Вставить("СписокОрганизаций",
		ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьСписокОбособленныхПодразделений(СтруктураПараметров.Организация));
	СтруктураПараметров.Вставить("ДатаФормированияДопЛиста");
	СтруктураПараметров.Вставить("ЗаполнениеДокумента",  Истина);
	СтруктураПараметров.Вставить("ЗаполнениеДекларации", Ложь);
	СтруктураПараметров.Вставить("ЭтоКнигаПродаж",       Истина);
	
	ПроверкаКонтрагентов.ДобавитьОбщиеПараметрыДляПроверкиКонтрагентовВОтчете(СтруктураПараметров);
	
	Если НЕ ПараметрыДляЗаполнения.ФорматПоПостановлению735 Тогда
		СтруктураПараметров.Вставить("ТабличнаяЧасть",
			Документы.ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.ПустаяСсылка().ТабличнаяЧасть.ВыгрузитьКолонки());
		РеквизитыДокумента = Новый Структура("ВсегоПродажДо,СуммаБезНДС10До,НДС10До,СуммаБезНДС18До,НДС18До,НДС0До,СуммаСовсемБезНДСДо,
		|ВсегоПродаж,СуммаБезНДС10,НДС10,СуммаБезНДС18,НДС18,НДС0,СуммаСовсемБезНДС");
		
		ПараметрыДляИтогов = Новый Структура;
		
		ПараметрыДляИтогов.Вставить("Организация",				ПараметрыДляЗаполнения.Организация);
		ПараметрыДляИтогов.Вставить("СписокОрганизаций");
		ПараметрыДляИтогов.Вставить("КонецНалоговогоПериода", 	КонецКвартала(ПараметрыДляЗаполнения.НалоговыйПериод));
		ПараметрыДляИтогов.Вставить("НалоговыйПериод", 			ПараметрыДляЗаполнения.НалоговыйПериод);
		ПараметрыДляИтогов.Вставить("ДатаФормированияДопЛиста", ПараметрыДляЗаполнения.Дата);
		ПараметрыДляИтогов.Вставить("Ссылка", 					ПараметрыДляЗаполнения.Ссылка);
		
		ИтогЗаПериод = Документы.ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.ПолучитьИтогиЗаПериодКнигаПродаж(ПараметрыДляИтогов);
		
		ЗаполнитьЗначенияСвойств(РеквизитыДокумента, ИтогЗаПериод);
		
		// Заполнение итогов по книге
		РеквизитыДокумента.Вставить("ВсегоПродажДо", 		ИтогЗаПериод.ВсегоПродаж);
		РеквизитыДокумента.Вставить("СуммаБезНДС10До", 		ИтогЗаПериод.СуммаБезНДС10);
		РеквизитыДокумента.Вставить("НДС10До", 				ИтогЗаПериод.НДС10);
		РеквизитыДокумента.Вставить("СуммаБезНДС18До",		ИтогЗаПериод.СуммаБезНДС18);
		РеквизитыДокумента.Вставить("НДС18До", 				ИтогЗаПериод.НДС18);
		РеквизитыДокумента.Вставить("НДС0До", 				ИтогЗаПериод.НДС0);
		РеквизитыДокумента.Вставить("СуммаСовсемБезНДСДо", 	ИтогЗаПериод.СуммаСовсемБезНДС);
		
		СтруктураПараметров.Вставить("РеквизитыДокумента", РеквизитыДокумента);
	КонецЕсли;

	Отчеты.КнигаПродаж.СформироватьОтчет(СтруктураПараметров, АдресХранилища);
		
КонецПроцедуры

Процедура ВосстановитьДанныеДляОтправки(ПараметрыВосстановления,АдресХранилища) Экспорт

	ПредставлениеОтчета = Новый ТабличныйДокумент;
	
	ДокументСсылка = ПараметрыВосстановления.ДокументСсылка;
	ПоместитьВоВременноеХранилище(ДокументСсылка.ПредставлениеОтчета.Получить(), АдресХранилища);

КонецПроцедуры

Функция ПолучитьИтогиЗаПериодКнигаПродаж(СтруктураПараметров) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДополнительныйЛистКнигиПродаж.ВсегоПродаж,
	|	ДополнительныйЛистКнигиПродаж.СуммаБезНДС18,
	|	ДополнительныйЛистКнигиПродаж.НДС18,
	|	ДополнительныйЛистКнигиПродаж.СуммаБезНДС10,
	|	ДополнительныйЛистКнигиПродаж.НДС10,
	|	ДополнительныйЛистКнигиПродаж.НДС0,
	|	ДополнительныйЛистКнигиПродаж.СуммаБезНДС20,
	|	ДополнительныйЛистКнигиПродаж.НДС20,
	|	ДополнительныйЛистКнигиПродаж.СуммаСовсемБезНДС,
	|	ДополнительныйЛистКнигиПродаж.Дата КАК Дата,
	|	ДополнительныйЛистКнигиПродаж.Ссылка
	|ПОМЕСТИТЬ ПоследнийДополнительныйЛист
	|ИЗ
	|	Документ.ДопЛистКнигиПродажДляПередачиВЭлектронномВиде КАК ДополнительныйЛистКнигиПродаж
	|ГДЕ
	|	ДополнительныйЛистКнигиПродаж.Организация = &Организация
	|	И ДополнительныйЛистКнигиПродаж.НалоговыйПериод = &НалоговыйПериод
	|	И ДополнительныйЛистКнигиПродаж.Дата < &Дата
	|	И ДополнительныйЛистКнигиПродаж.Ссылка <> &ТекущийДокумент
	|	И ДополнительныйЛистКнигиПродаж.Проведен
	|	И НЕ ДополнительныйЛистКнигиПродаж.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	КнигаПродаж.ВсегоПродаж,
	|	КнигаПродаж.СуммаБезНДС18,
	|	КнигаПродаж.НДС18,
	|	КнигаПродаж.СуммаБезНДС10,
	|	КнигаПродаж.НДС10,
	|	КнигаПродаж.НДС0,
	|	КнигаПродаж.СуммаБезНДС20,
	|	КнигаПродаж.НДС20,
	|	КнигаПродаж.СуммаСовсемБезНДС,
	|	КнигаПродаж.Дата
	|ПОМЕСТИТЬ КнигаПродажЗаКорректируемыйПериод
	|ИЗ
	|	Документ.КнигаПродажДляПередачиВЭлектронномВиде КАК КнигаПродаж
	|ГДЕ
	|	КнигаПродаж.Организация = &Организация
	|	И КнигаПродаж.НалоговыйПериод = &НалоговыйПериод
	|	И КнигаПродаж.Проведен
	|	И НЕ КнигаПродаж.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоследнийДополнительныйЛист.ВсегоПродаж КАК ВсегоПродаж,
	|	ПоследнийДополнительныйЛист.СуммаБезНДС18,
	|	ПоследнийДополнительныйЛист.НДС18,
	|	ПоследнийДополнительныйЛист.СуммаБезНДС10,
	|	ПоследнийДополнительныйЛист.НДС10,
	|	ПоследнийДополнительныйЛист.НДС0,
	|	ПоследнийДополнительныйЛист.СуммаБезНДС20,
	|	ПоследнийДополнительныйЛист.НДС20,
	|	ПоследнийДополнительныйЛист.СуммаСовсемБезНДС,
	|	ПоследнийДополнительныйЛист.Дата КАК ДатаОформления,
	|	0 КАК НДС
	|ИЗ
	|	ПоследнийДополнительныйЛист КАК ПоследнийДополнительныйЛист
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	КнигаПродажЗаКорректируемыйПериод.ВсегоПродаж,
	|	КнигаПродажЗаКорректируемыйПериод.СуммаБезНДС18,
	|	КнигаПродажЗаКорректируемыйПериод.НДС18,
	|	КнигаПродажЗаКорректируемыйПериод.СуммаБезНДС10,
	|	КнигаПродажЗаКорректируемыйПериод.НДС10,
	|	КнигаПродажЗаКорректируемыйПериод.НДС0,
	|	КнигаПродажЗаКорректируемыйПериод.СуммаБезНДС20,
	|	КнигаПродажЗаКорректируемыйПериод.НДС20,
	|	КнигаПродажЗаКорректируемыйПериод.СуммаСовсемБезНДС,
	|	КнигаПродажЗаКорректируемыйПериод.Дата,
	|	0
	|ИЗ
	|	КнигаПродажЗаКорректируемыйПериод КАК КнигаПродажЗаКорректируемыйПериод";
			 
	Запрос.УстановитьПараметр("Организация", СтруктураПараметров.Организация);
	Запрос.УстановитьПараметр("НалоговыйПериод", СтруктураПараметров.НалоговыйПериод);
	Запрос.УстановитьПараметр("Дата", СтруктураПараметров.ДатаФормированияДопЛиста);
	Запрос.УстановитьПараметр("ТекущийДокумент", СтруктураПараметров.Ссылка);
	
	ИтогЗаПериод = Запрос.Выполнить();
	
	Если НЕ ИтогЗаПериод.Пустой() Тогда
		
		Возврат ИтогЗаПериод.Выгрузить()[0];
		
	Иначе
		
		// Получим итоги по данным информационной базы
		Возврат Отчеты.КнигаПродаж.ПолучитьИтогиЗаПериодКнигаПродаж(СтруктураПараметров);
		
	КонецЕсли;
	
КонецФункции

// Функция поиска документов, относящихся к выбранному налоговому периоду.
//
// Параметры:
//  Организация        - СправочникСсылка.Организации.
//  НалоговыйПериод    - Дата - налоговый период.
//  Дата               - Дата - дата документа.
//  Позиция            - Число (1,0) - позиция искомого документа:
//                       -1 - до даты текущего;
//                        0 - на дату текущего;
//                        1 - после даты текущего;
//                        2 - искать только по налоговому периоду.
//
// Возвращаемое значение:
//  Массив, Неопределено - упорядоченный по дате массив найденных документов.
//
Функция НайтиДокументыЗаНалоговыйПериод(Организация, НалоговыйПериод, Дата, Позиция = 0) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(НалоговыйПериод) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",				Организация);
	Запрос.УстановитьПараметр("ДатаНачала",					НачалоДня(Дата));
	Запрос.УстановитьПараметр("ДатаКонца",					КонецДня(Дата));
	Запрос.УстановитьПараметр("НачалоНалоговогоПериода",	НачалоКвартала(НалоговыйПериод));
	Запрос.УстановитьПараметр("КонецНалоговогоПериода",		КонецКвартала(НалоговыйПериод));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.Дата КАК Дата,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ДопЛистКнигиПродажДляПередачиВЭлектронномВиде КАК ДопЛистКнигиПродажДляПередачиВЭлектронномВиде
	|ГДЕ
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.Организация = &Организация
	|	И ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.НалоговыйПериод >= &НачалоНалоговогоПериода
	|	И ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.НалоговыйПериод <= &КонецНалоговогоПериода
	|	И НЕ ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.ПометкаУдаления
	|	И &УсловиеПоДате
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	Если Позиция = -1 Тогда
		Запрос.Текст	= СтрЗаменить(Запрос.Текст, "&УсловиеПоДате", 
			"ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.Дата < &ДатаНачала");
	ИначеЕсли Позиция = 1 Тогда
		Запрос.Текст	= СтрЗаменить(Запрос.Текст, "&УсловиеПоДате", 
			"ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.Дата > &ДатаКонца");
	ИначеЕсли Позиция = 2 Тогда
		Запрос.Текст	= СтрЗаменить(Запрос.Текст, "&УсловиеПоДате", 
			"ИСТИНА");
	Иначе
		Запрос.Текст	= СтрЗаменить(Запрос.Текст, "&УсловиеПоДате", 
			"(ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.Дата МЕЖДУ &ДатаНачала И &ДатаКонца)");
	КонецЕсли;
		
	Результат	= Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МассивДокументов	= Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат МассивДокументов;

КонецФункции

#Область ОбработчикиОбновления

// Обработчик обновления на версию 3.0.25.
//
// Процедура заполняет реквизит "ПериодПоСКНП" в тех документах,
// в которых он не заполнен.
//
Процедура ОбработатьДокументыСНезаполненнымРеквизитомПериодПоСКНП() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.Ссылка,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.Организация,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.Реорганизация,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.НалоговыйПериод
	|ИЗ
	|	Документ.ДопЛистКнигиПродажДляПередачиВЭлектронномВиде КАК ДопЛистКнигиПродажДляПередачиВЭлектронномВиде
	|ГДЕ
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.ПериодПоСКНП = """"
	|	И НЕ ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.ПометкаУдаления";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ОбрабатываемыйДокумент = Выборка.Ссылка;
			
			ОбрабатываемыйОбъект = ОбрабатываемыйДокумент.ПолучитьОбъект();
			ОбрабатываемыйОбъект.ПериодПоСКНП = УчетНДСКлиентСервер.ПолучитьКодПоСКНП(Выборка.НалоговыйПериод, Выборка.Реорганизация);
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбрабатываемыйОбъект);
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Печать дополнительного листа книги продаж
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ДополнительныйЛистКнигиПродаж";
	КомандаПечати.Представление = НСтр("ru = 'Печать дополнительного листа книги продаж'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ДополнительныйЛистКнигиПродаж",
		НСтр("ru = 'Доп. лист книги продаж'"),
		ПечатьДополнительногоЛистаКнигиПродаж(МассивОбъектов, ОбъектыПечати));
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
КонецПроцедуры

Функция ПечатьДополнительногоЛистаКнигиПродаж(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТабличнаяЧастьДопЛиста.НомерСтроки,
	|	ТабличнаяЧастьДопЛиста.ДатаНомер,
	|	ТабличнаяЧастьДопЛиста.НомерДатаИсправления,
	|	ТабличнаяЧастьДопЛиста.НомерДатаКорректировки,
	|	ТабличнаяЧастьДопЛиста.НомерДатаИсправленияКорректировки,
	|	ТабличнаяЧастьДопЛиста.ДатаОплаты,
	|	ТабличнаяЧастьДопЛиста.Покупатель,
	|	ТабличнаяЧастьДопЛиста.ПокупательИНН,
	|	ТабличнаяЧастьДопЛиста.ПокупательКПП,
	|	ТабличнаяЧастьДопЛиста.ВсегоПродаж,
	|	ТабличнаяЧастьДопЛиста.СуммаБезНДС18,
	|	ТабличнаяЧастьДопЛиста.НДС18,
	|	ТабличнаяЧастьДопЛиста.СуммаБезНДС10,
	|	ТабличнаяЧастьДопЛиста.НДС10,
	|	ТабличнаяЧастьДопЛиста.НДС0,
	|	ТабличнаяЧастьДопЛиста.СуммаСовсемБезНДС,
	|	ТабличнаяЧастьДопЛиста.Ном,
	|	ТабличнаяЧастьДопЛиста.СчетФактура,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.Организация КАК Организация,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.Организация.ИНН КАК ОрганизацияИНН,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.Организация.КПП КАК ОрганизацияКПП,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.НалоговыйПериод КАК НалоговыйПериод,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.ВсегоПродаж КАК ВсегоПродажИтог,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.СуммаБезНДС18 КАК СуммаБезНДС18Итог,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.НДС18 КАК НДС18Итог,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.СуммаБезНДС10 КАК СуммаБезНДС10Итог,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.НДС10 КАК НДС10Итог,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.НДС0 КАК НДС0Итог,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.СуммаСовсемБезНДС КАК СуммаСовсемБезНДСИтог,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.ВсегоПродажДо КАК ВсегоПродажИтогДо,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.СуммаБезНДС18До КАК СуммаБезНДС18ИтогДо,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.НДС18До КАК НДС18ИтогДо,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.СуммаБезНДС10До КАК СуммаБезНДС10ИтогДо,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.НДС10До КАК НДС10ИтогДо,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.НДС0До КАК НДС0ИтогДо,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.СуммаСовсемБезНДСДо КАК СуммаСовсемБезНДСИтогДо,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.Ссылка КАК Ссылка,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.Дата КАК Дата,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.НомерДополнительногоЛиста КАК НомерДополнительногоЛиста,
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.ПредставлениеОтчета КАК ПредставлениеОтчета
	|ИЗ
	|	Документ.ДопЛистКнигиПродажДляПередачиВЭлектронномВиде КАК ДопЛистКнигиПродажДляПередачиВЭлектронномВиде
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.ТабличнаяЧасть КАК ТабличнаяЧастьДопЛиста
	|		ПО (ТабличнаяЧастьДопЛиста.Ссылка = ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.Ссылка)
	|ГДЕ
	|	ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.Ссылка В(&МассивОбъектов)
	|ИТОГИ
	|	МАКСИМУМ(Организация),
	|	МАКСИМУМ(ОрганизацияИНН),
	|	МАКСИМУМ(ОрганизацияКПП),
	|	МАКСИМУМ(НалоговыйПериод),
	|	МАКСИМУМ(ВсегоПродажИтог),
	|	МАКСИМУМ(СуммаБезНДС18Итог),
	|	МАКСИМУМ(НДС18Итог),
	|	МАКСИМУМ(СуммаБезНДС10Итог),
	|	МАКСИМУМ(НДС10Итог),
	|	МАКСИМУМ(НДС0Итог),
	|	МАКСИМУМ(СуммаСовсемБезНДСИтог),
	|	МАКСИМУМ(ВсегоПродажИтогДо),
	|	МАКСИМУМ(СуммаБезНДС18ИтогДо),
	|	МАКСИМУМ(НДС18ИтогДо),
	|	МАКСИМУМ(СуммаБезНДС10ИтогДо),
	|	МАКСИМУМ(НДС10ИтогДо),
	|	МАКСИМУМ(НДС0ИтогДо),
	|	МАКСИМУМ(СуммаСовсемБезНДСИтогДо),
	|	МАКСИМУМ(Ссылка),
	|	МАКСИМУМ(Дата),
	|	МАКСИМУМ(НомерДополнительногоЛиста)
	|ПО
	|	Ссылка";
	
	Результат = Запрос.Выполнить();
		
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ДополнительныйЛистКнигиПродаж";
	
	ПервыйДокумент = Истина;
		
	ВыборкаПоОбъектам = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоОбъектам.Следующий() Цикл
	
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;

		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ВыборкаТабличнойЧасти = ВыборкаПоОбъектам.Выбрать();
		
		Если ВыборкаТабличнойЧасти.Количество() = 0 Тогда

			Продолжить;
			
		КонецЕсли;
		
		ВерсияПостановленияНДС1137 = УчетНДСПереопределяемый.ВерсияПостановленияНДС1137(ВыборкаПоОбъектам.НалоговыйПериод);
		Если ВерсияПостановленияНДС1137 = 1 Тогда
			Макет = ПолучитьОбщийМакет("ДополнительныйЛистКнигиПродаж1137");
		ИначеЕсли ВерсияПостановленияНДС1137 = 2 Тогда	
			Макет = ПолучитьОбщийМакет("ДополнительныйЛистКнигиПродаж952");
		Иначе
			ПредставлениеОтчета = ВыборкаПоОбъектам.ПредставлениеОтчета.Получить();
			Если ПредставлениеОтчета <> Неопределено Тогда 
				ТабличныйДокумент.Вывести(ПредставлениеОтчета);
			КонецЕсли;
			Продолжить;
		КонецЕсли; 

		Секция = Макет.ПолучитьОбласть("Строка");
		СтрокаИтого = Макет.ПолучитьОбласть("Итого");
		СтрокаВсего = Макет.ПолучитьОбласть("Всего");
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("НалоговыйПериод", ВыборкаПоОбъектам.НалоговыйПериод);
		СтруктураПараметров.Вставить("КонецНалоговогоПериода", КонецКвартала(ВыборкаПоОбъектам.НалоговыйПериод));
		СтруктураПараметров.Вставить("СформироватьОтчетПоСтандартнойФорме", Истина);
		СтруктураПараметров.Вставить("ОтбиратьПоКонтрагенту", Ложь);
		СтруктураПараметров.Вставить("КонтрагентДляОтбора");
		СтруктураПараметров.Вставить("ГруппироватьПоКонтрагентам", Ложь); 
		СтруктураПараметров.Вставить("Организация", ВыборкаПоОбъектам.Организация);
		СтруктураПараметров.Вставить("ДатаОформления", ВыборкаПоОбъектам.Дата);
		СтруктураПараметров.Вставить("ЗаполнениеДокумента", Истина);
		СтруктураПараметров.Вставить("ДополнительныеЛистыЗаТекущийПериод", Истина);
		
		СтруктураПараметров.Вставить("НачалоПериода", НачалоКвартала(ВыборкаПоОбъектам.НалоговыйПериод));
		СтруктураПараметров.Вставить("КонецПериода", КонецКвартала(ВыборкаПоОбъектам.НалоговыйПериод));
		СтруктураПараметров.Вставить("ДатаФормированияДопЛиста", ВыборкаПоОбъектам.Дата);
		СтруктураПараметров.Вставить("СписокОрганизаций", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьСписокОбособленныхПодразделений(ВыборкаПоОбъектам.Организация));
		
		УчетНДС.ВывестиШапкуДопЛиста(ТабличныйДокумент, Макет, СтруктураПараметров, ВыборкаПоОбъектам.НомерДополнительногоЛиста);
		
		ИтогЗаПериод = Новый Структура;
		ИтогЗаПериод.Вставить("ВсегоПродаж", ВыборкаПоОбъектам.ВсегоПродажИтогДо);
		ИтогЗаПериод.Вставить("СуммаБезНДС10", ВыборкаПоОбъектам.СуммаБезНДС10ИтогДо);
		ИтогЗаПериод.Вставить("НДС10", ВыборкаПоОбъектам.СуммаБезНДС10ИтогДо);
		ИтогЗаПериод.Вставить("СуммаБезНДС18", ВыборкаПоОбъектам.СуммаБезНДС18ИтогДо);
		ИтогЗаПериод.Вставить("НДС18", ВыборкаПоОбъектам.НДС18ИтогДо);
		ИтогЗаПериод.Вставить("НДС0", ВыборкаПоОбъектам.НДС0ИтогДо);
		ИтогЗаПериод.Вставить("СуммаСовсемБезНДС", ВыборкаПоОбъектам.СуммаСовсемБезНДСИтогДо);
		
		СтрокаИтого.Параметры.Заполнить(ИтогЗаПериод);
		ТабличныйДокумент.Вывести(СтрокаИтого);
		
		СтруктураСекций = Новый Структура("СекцияСтрока", Макет.ПолучитьОбласть("Строка"));
		ПараметрыСтроки = СтруктураСекций.СекцияСтрока.Параметры;

		Пока ВыборкаТабличнойЧасти.Следующий() Цикл
			
			Секция.Параметры.Заполнить(ВыборкаТабличнойЧасти);
			ТабличныйДокумент.Вывести(Секция);		
			
		КонецЦикла;	
		
		ВсегоЗаПериод = Новый Структура;
		ВсегоЗаПериод.Вставить("ВсегоПродаж", ВыборкаПоОбъектам.ВсегоПродажИтог);
		ВсегоЗаПериод.Вставить("СуммаБезНДС10", ВыборкаПоОбъектам.СуммаБезНДС10Итог);
		ВсегоЗаПериод.Вставить("НДС10", ВыборкаПоОбъектам.СуммаБезНДС10Итог);
		ВсегоЗаПериод.Вставить("СуммаБезНДС18", ВыборкаПоОбъектам.СуммаБезНДС18Итог);
		ВсегоЗаПериод.Вставить("НДС18", ВыборкаПоОбъектам.НДС18Итог);
		ВсегоЗаПериод.Вставить("НДС0", ВыборкаПоОбъектам.НДС0Итог);
		ВсегоЗаПериод.Вставить("СуммаСовсемБезНДС", ВыборкаПоОбъектам.СуммаСовсемБезНДСИтог);
		
		СтрокаВсего.Параметры.Заполнить(ВсегоЗаПериод);
		ТабличныйДокумент.Вывести(СтрокаВсего);

		ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(ВыборкаПоОбъектам.Организация, КонецКвартала(ВыборкаПоОбъектам.НалоговыйПериод));
		Если ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(ВыборкаПоОбъектам.Организация) Тогда
			ИмяОрг = "";
			Свидетельство = "";
		Иначе
			ИмяОрг = ОтветственныеЛица.РуководительПредставление;
			СведенияОЮрФизЛице = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ВыборкаПоОбъектам.Организация);
			Свидетельство = СведенияОЮрФизЛице.Свидетельство;
		КонецЕсли;
		
		Секция = Макет.ПолучитьОбласть("Подвал");
		Секция.Параметры.ИмяРук        = ОтветственныеЛица.РуководительПредставление;
		Секция.Параметры.ИмяОрг        = ИмяОрг;
		Секция.Параметры.Свидетельство = Свидетельство;
		
		ТабличныйДокумент.Вывести(Секция);
					
		УправлениеКолонтитулами.УстановитьКолонтитулы(ТабличныйДокумент);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент,
			НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоОбъектам.Ссылка);

	КонецЦикла;	

	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли