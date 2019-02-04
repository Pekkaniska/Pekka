
#Область ПрограммныйИнтерфейс

// Определяет следующие свойств регламентных заданий:
//  - зависимость от функциональных опций.
//  - возможность выполнения в различных режимах работы программы.
//  - прочие параметры.
//
// см. РегламентныеЗаданияПереопределяемый.ПриОпредеПриОпределенииНастроекРегламентныхЗаданий()
//
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	//++ Локализация
	//++ НЕ ГОСИС
	
	//ИнтеграцияС1СДокументооборот
	ИнтеграцияС1СДокументооборот.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	//Конец ИнтеграцияС1СДокументооборот
	
	//++ НЕ УТКА
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОтражениеДокументовВМеждународномУчете;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьМеждународныйФинансовыйУчет;
	Настройка.ВключатьПриВключенииФункциональнойОпции = Ложь;	
	//-- НЕ УТКА
	
	//++ НЕ УТ
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОтражениеДокументовВРеглУчете;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьРеглУчет;
	Настройка.ВключатьПриВключенииФункциональнойОпции = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОтправкаОтчетности;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПолучениеРезультатовОтправкиОтчетности;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.СписаниеЗатратНаВыпуск;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьПроизводство;
	Настройка.ВключатьПриВключенииФункциональнойОпции = Ложь;
	//-- НЕ УТ
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбменССайтом;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПроверкаКонтрагентов;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.АрхивированиеЧековККМ;
	Настройка.РаботаетСВнешнимиРесурсами = Ложь;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьРозничныеПродажи;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.УдалениеОтложенныхЧековККМ;
	Настройка.РаботаетСВнешнимиРесурсами = Ложь;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьРозничныеПродажи;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.УдалениеЧековККМ;
	Настройка.РаботаетСВнешнимиРесурсами = Ложь;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьРозничныеПродажи;

	//ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействие.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	//Конец ЭлектронноеВзаимодействие
	
	//++ НЕ УТ
	//Регламентированная отчетность
	ОбщегоНазначенияБРО.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	//Конец Регламентированная отчетность
	
	ЗарплатаКадры.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	//-- НЕ УТ
	//-- НЕ ГОСИС

	//++ НЕ ЕГАИС
	//++ НЕ ВЕТИС
	ИнтеграцияГИСМ.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	//-- НЕ ВЕТИС
	//-- НЕ ЕГАИС
	
	//++ НЕ ГИСМ
	//++ НЕ ВЕТИС
	ИнтеграцияЕГАИС.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	//-- НЕ ВЕТИС
	//-- НЕ ГИСМ
	
	//++ НЕ ГИСМ
	//++ НЕ ЕГАИС
	ИнтеграцияВЕТИС.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	//-- НЕ ЕГАИС
	//-- НЕ ГИСМ
	//-- Локализация
	
	
КонецПроцедуры

#КонецОбласти