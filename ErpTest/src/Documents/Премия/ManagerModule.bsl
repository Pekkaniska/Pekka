#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Проводит документ по учетам. Если в параметре ВидыУчетов передано Неопределено, то документ проводится по всем учетам.
// Процедура вызывается из обработки проведения и может вызываться из вне.
// 
// Параметры:
//  ДокументСсылка	- ДокументСсылка.Премия - Ссылка на документ
//  РежимПроведения - РежимПроведенияДокумента - Режим проведения документа (оперативный, неоперативный)
//  Отказ 			- Булево - Признак отказа от выполнения проведения
//  ВидыУчетов 		- Строка - Список видов учета, по которым необходимо провести документ. Если параметр пустой или Неопределено, то документ проведется по всем учетам
//  Движения 		- Коллекция движений документа - Передается только при вызове из обработки проведения документа
//  Объект			- ДокументОбъект.Премия - Передается только при вызове из обработки проведения документа
//  ДополнительныеПараметры - Структура - Дополнительные параметры, необходимые для проведения документа.
//
Процедура ПровестиПоУчетам(ДокументСсылка, РежимПроведения, Отказ, ВидыУчетов = Неопределено, Движения = Неопределено, Объект = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	СтруктураВидовУчета = ПроведениеРасширенныйСервер.СтруктураВидовУчета();
	ПроведениеРасширенныйСервер.ПодготовитьНаборыЗаписейКРегистрацииДвиженийПоВидамУчета(РежимПроведения, ДокументСсылка, СтруктураВидовУчета, ВидыУчетов, Движения, Объект, Отказ);
	
	РеквизитыДляПроведения = РеквизитыДляПроведения(ДокументСсылка);
	ПроведениеСервер.ОтключитьПроверкуДатыЗапретаИзменения(Движения, ЗначениеЗаполнено(РеквизитыДляПроведения.ИсправленныйДокумент));
	
	ИсправлениеДокументовЗарплатаКадры.ПриПроведенииИсправления(ДокументСсылка, Движения, РежимПроведения, Отказ, РеквизитыДляПроведения, СтруктураВидовУчета, Объект);
	
	Если РеквизитыДляПроведения.ДокументРассчитан Тогда 
	
		ДанныеДляПроведения = ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета);
		Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
			
			ДатаОперации	= УчетНДФЛРасширенный.ДатаОперацииПоДокументу(РеквизитыДляПроведения.Дата, РеквизитыДляПроведения.ПериодРегистрации);
			МесяцНачисления	= РеквизитыДляПроведения.ПериодРегистрации;
			
			// Начисления
			РасчетЗарплатыРасширенный.СформироватьДвиженияНачислений(
				Движения, Отказ, РеквизитыДляПроведения.Организация, МесяцНачисления, ДанныеДляПроведения.Начисления, ДанныеДляПроведения.ПоказателиНачислений, Истина);
				
			РасчетЗарплатыРасширенный.СформироватьДвиженияРаспределенияПоТерриториямУсловиямТруда(Движения, Отказ, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда);
			РасчетЗарплатыРасширенный.СформироватьДвиженияРаспределенияРезультатовНачислений(Движения, Отказ, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.РаспределениеРезультатовНачислений);
			
			ПерерасчетЗарплаты.СформироватьДвиженияИсходныеДанныхПерерасчетов(Движения, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, ДанныеДляПроведения.Начисления);
			// Удержания
			РасчетЗарплатыРасширенный.СформироватьДвиженияУдержаний(Движения, Отказ, РеквизитыДляПроведения.Организация, ДатаОперации, ДанныеДляПроведения.Удержания, ДанныеДляПроведения.ПоказателиУдержаний);
			ИсполнительныеЛисты.СформироватьУдержанияПоИсполнительнымДокументам(Движения, ДанныеДляПроведения.УдержанияПоИсполнительнымДокументам);
			РасчетЗарплатыРасширенный.СформироватьДвиженияУдержанийДоПределаПоСотрудникам(Движения, Отказ, МесяцНачисления, ДанныеДляПроведения.УдержанияДоПределаПоСотрудникам);
			РасчетЗарплатыРасширенный.СформироватьЗадолженностьПоУдержаниямФизическихЛиц(Движения, ДанныеДляПроведения.ЗадолженностьПоУдержаниям);
			
			// - Регистрация бухучета начислений и удержаний, выполняется до вызова регистрации доходов в учете НДФЛ.
			ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
							Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации,
							ДанныеДляПроведения.НачисленияПоСотрудникам, ДанныеДляПроведения.УдержанияПоСотрудникам, Неопределено,
							РасчетЗарплатыРасширенный.ЭтоМежрасчетнаяВыплата(РеквизитыДляПроведения.ПорядокВыплаты));
				
			// НДФЛ
			УчетНДФЛРасширенный.ЗарегистрироватьДоходыИСуммыНДФЛПоВременнойТаблицеНачислений(
				РеквизитыДляПроведения.Ссылка, Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.Дата, РеквизитыДляПроведения.ПериодРегистрации, РеквизитыДляПроведения.ПорядокВыплаты, РеквизитыДляПроведения.ПланируемаяДатаВыплаты, ДанныеДляПроведения, Истина, РеквизитыДляПроведения.РассчитыватьУдержания Или УчетНДФЛРасширенный.ДоходыВУчетеНДФЛРегистрируютсяПоДатеВыплаты(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РеквизитыДляПроведения.ВидПремии)));
				
			// КорректировкиВыплаты
			РасчетЗарплатыРасширенный.СформироватьДвиженияКорректировкиВыплатыПоВременнойТаблицеНачислений(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, РеквизитыДляПроведения.ПорядокВыплаты, ДанныеДляПроведения, Истина, РеквизитыДляПроведения.РассчитыватьУдержания Или УчетНДФЛРасширенный.ДоходыВУчетеНДФЛРегистрируютсяПоДатеВыплаты(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РеквизитыДляПроведения.ВидПремии)));
			
			Если РеквизитыДляПроведения.РассчитыватьУдержания Тогда
				УчетНДФЛРасширенный.УточнитьУчетНалогаПоЦеннымБумагам(Движения, Истина);
			КонецЕсли;
			
			// Учет начисленной зарплаты
			УчетНачисленнойЗарплаты.ЗарегистрироватьНачисленияУдержания(
				Движения, Отказ, РеквизитыДляПроведения.Организация, МесяцНачисления, ДанныеДляПроведения.НачисленияПоСотрудникам, ДанныеДляПроведения.УдержанияПоСотрудникам, Неопределено, Неопределено, РеквизитыДляПроведения.ПорядокВыплаты);
					
				// - Регистрация бухучета НДФЛ, выполняется после вызова регистрации доходов в учете НДФЛ.
			ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
						Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации,
						Неопределено,
						Неопределено,
						ДанныеДляПроведения.НДФЛПоСотрудникам,
						РасчетЗарплатыРасширенный.ЭтоМежрасчетнаяВыплата(РеквизитыДляПроведения.ПорядокВыплаты));
					
			// Страховые взносы
			УчетСтраховыхВзносов.СформироватьСведенияОДоходахСтраховыеВзносы(
				Движения, Отказ, РеквизитыДляПроведения.Организация, МесяцНачисления, ДанныеДляПроведения.МенеджерВременныхТаблиц, Ложь, Истина, РеквизитыДляПроведения.Ссылка);
				
		КонецЕсли;
			
		Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
			
			// Учет среднего заработка
			УчетСреднегоЗаработка.ЗарегистрироватьДанныеСреднегоЗаработка(Движения, Отказ, ДанныеДляПроведения.НачисленияДляСреднегоЗаработка);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		ПерерасчетЗарплаты.УдалитьПерерасчетыПоДополнительнымПараметрам(РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
		
	КонецЕсли;
	
	ПроведениеРасширенныйСервер.ВыполнитьЗапланированныеКорректировкиДвижений(Движения);
	
	ПроведениеРасширенныйСервер.ЗаписьДвиженийПоУчетам(Движения, СтруктураВидовУчета);
	
КонецПроцедуры

// Сторнирует документ по учетам. Используется подсистемой исправления документов.
//
// Параметры:
//  Движения				 - КоллекцияДвижений, Структура	 - Коллекция движений исправляющего документа в которую будут добавлены сторно стоки.
//  Регистратор				 - ДокументСсылка				 - Документ регистратор исправления (документ исправление).
//  ИсправленныйДокумент	 - ДокументСсылка				 - Исправленный документ движения которого будут сторнированы.
//  СтруктураВидовУчета		 - Структура					 - Виды учета, по которым будет выполнено сторнирование исправленного документа.
//  					Состав полей см. в ПроведениеРасширенныйСервер.СтруктураВидовУчета().
//  ДополнительныеПараметры	 - Структура					 - Структура со свойствами:
//  					* ИсправлениеВТекущемПериоде - Булево - Истина когда исправление выполняется в периоде регистрации исправленного документа.
//						* ОтменаДокумента - Булево - Истина когда исправление вызвано документом СторнированиеНачислений.
//  					* ПериодРегистрации	- Дата - Период регистрации документа регистратора исправления.
// 
// Возвращаемое значение:
//  Булево - "Истина" если сторнирование выполнено этой функцией, "Ложь" если специальной процедуры не предусмотрено.
//
Функция СторнироватьПоУчетам(Движения, Регистратор, ИсправленныйДокумент, СтруктураВидовУчета, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.ОтменаДокумента Или ДополнительныеПараметры.ИсправлениеВТекущемПериоде Тогда
		
		Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
			УчетСреднегоЗаработка.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
		КонецЕсли;
		
		Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
			УчетСтраховыхВзносовРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент, ДополнительныеПараметры);
			УчетНДФЛРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент, ДополнительныеПараметры);
			РасчетЗарплатыРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
			ОтражениеЗарплатыВБухучетеРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
			УчетНачисленнойЗарплатыРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
			
			ИсправлениеДокументовЗарплатаКадры.СторнироватьДвиженияБезСпецификиУчетов(
				Движения, ИсправленныйДокумент,	ДополнительныеПараметры);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.Премия;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.Премия);
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ о поощрении сотрудников (Т-11а).
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Отчет.ПечатнаяФормаТ11";
	КомандаПечати.Идентификатор = "ПФ_MXL_Т11а";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о поощрении сотрудников (Т-11а)'");
	
	// Приказ о поощрении сотрудника (Т-11).
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Отчет.ПечатнаяФормаТ11";
	КомандаПечати.Идентификатор = "ПФ_MXL_Т11";
	КомандаПечати.ДополнительныеПараметры.Вставить("ПечатьВсехПриказов", Истина);
	КомандаПечати.Представление = НСтр("ru = 'Приказы на каждого сотрудника в отдельности (Т-11)'");
	
КонецПроцедуры

Функция ПолныеПраваНаДокумент() Экспорт 
	
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеНачисленнойЗарплатыРасширенная, ЧтениеНачисленнойЗарплатыРасширенная", , Ложь);
	
КонецФункции	

Функция ДанныеДляПроверкиОграниченийНаУровнеЗаписей(Объект) Экспорт 

	МассивСотрудников = ОбщегоНазначения.ВыгрузитьКолонку(Объект.Начисления, "Сотрудник", Истина);
	ФизическиеЛицаСотрудников = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивСотрудников, "ФизическоеЛицо");
	МассивФизическихЛиц = ОбщегоНазначения.ВыгрузитьКолонку(ФизическиеЛицаСотрудников, "Значение", Истина);
	
	ДанныеДляПроверкиОграничений = ЗарплатаКадрыРасширенный.ОписаниеСтруктурыДанныхДляПроверкиОграниченийНаУровнеЗаписей();
	
	ДанныеДляПроверкиОграничений.Организация = Объект.Организация;
	ДанныеДляПроверкиОграничений.МассивФизическихЛиц = МассивФизическихЛиц;
	ДанныеДляПроверкиОграничений.Подразделение = Объект.Подразделение;
	
	Возврат ДанныеДляПроверкиОграничений;
	
КонецФункции

Функция ДанныеДляБухучетаЗарплатыПервичныхДокументов(Объект) Экспорт

	ДанныеДляБухучета = Новый Структура;
	ДанныеДляБухучета.Вставить("ДокументОснование", Объект.Ссылка);
	
	ТаблицаБухучетЗарплаты = ОтражениеЗарплатыВБухучетеРасширенный.НоваяТаблицаБухучетЗарплатыПервичныхДокументов();
	НоваяСтрока = ТаблицаБухучетЗарплаты.Добавить();
	НоваяСтрока.ДокументОснование = Объект.Ссылка;
	НоваяСтрока.НачислениеУдержание = Объект.ВидПремии;
	НоваяСтрока.СпособОтраженияЗарплатыВБухучете = Объект.СпособОтраженияЗарплатыВБухучете;
	НоваяСтрока.ОтношениеКЕНВД = Объект.ОтношениеКЕНВД;
	НоваяСтрока.СтатьяФинансирования = Объект.СтатьяФинансирования;
	НоваяСтрока.СтатьяРасходов = Объект.СтатьяРасходов;
	
	ДанныеДляБухучета.Вставить("ТаблицаБухучетЗарплаты", ТаблицаБухучетЗарплаты);
	
	Возврат ДанныеДляБухучета;
	
КонецФункции

Функция ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета) 
	
	ДанныеДляПроведения = РасчетЗарплаты.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		РасчетЗарплатыРасширенный.ЗаполнитьНачисления(
			ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Начисления,НачисленияПерерасчет", "Ссылка.ПериодРегистрации", "Ссылка.ВидПремии");
		
		ОтражениеЗарплатыВБухучете.СоздатьВТНачисленияСДаннымиЕНВД(РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, ДанныеДляПроведения.МенеджерВременныхТаблиц, ДанныеДляПроведения.НачисленияПоСотрудникам);
		
		РасчетЗарплатыРасширенный.ЗаполнитьСписокФизическихЛиц(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Начисления");
		
		РасчетЗарплаты.ЗаполнитьУдержания(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		РасчетЗарплатыРасширенный.ЗаполнитьПогашениеЗадолженностиПоУдержаниям(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.ПериодРегистрации);
		
		РасчетЗарплаты.ЗаполнитьДанныеНДФЛ(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		РасчетЗарплатыРасширенный.ЗаполнитьДанныеКорректировкиВыплаты(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		
	КонецЕсли;
	
	Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
		ДополнительныеПараметры = УчетСреднегоЗаработка.ДополнительныеПараметрыРегистрацииДанныхСреднегоЗаработка();
		ДополнительныеПараметры.МесяцНачисления = "Ссылка.ПериодРегистрации";
		ДополнительныеПараметры.Таблицы.Начисления.ДатаДействия = "ПериодДействия";
		ДополнительныеПараметры.Таблицы.Начисления.Начисление = "Ссылка.ВидПремии";
		ДополнительныеПараметры.Таблицы.Начисления.НачалоБазовогоПериода = "Ссылка.ДатаНачалаБазовогоПериода";
		ДополнительныеПараметры.Таблицы.Начисления.ОкончаниеБазовогоПериода = "Ссылка.ДатаОкончанияБазовогоПериода";
		ДополнительныеПараметры.Таблицы.НачисленияПерерасчет.НачалоБазовогоПериода = "Ссылка.ДатаНачалаБазовогоПериода";
		ДополнительныеПараметры.Таблицы.НачисленияПерерасчет.ОкончаниеБазовогоПериода = "Ссылка.ДатаОкончанияБазовогоПериода";
		УчетСреднегоЗаработка.ЗаполнитьТаблицыДляРегистрацииДанныхСреднегоЗаработка(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
	КонецЕсли;
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведения(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Премия.Ссылка КАК Ссылка,
	|	Премия.ДокументРассчитан КАК ДокументРассчитан,
	|	Премия.Организация КАК Организация,
	|	Премия.ПериодРегистрации КАК ПериодРегистрации,
	|	Премия.Дата КАК Дата,
	|	Премия.ПорядокВыплаты КАК ПорядокВыплаты,
	|	Премия.ПланируемаяДатаВыплаты КАК ПланируемаяДатаВыплаты,
	|	Премия.РассчитыватьУдержания КАК РассчитыватьУдержания,
	|	Премия.ВидПремии КАК ВидПремии,
	|	Премия.ИсправленныйДокумент КАК ИсправленныйДокумент
	|ИЗ
	|	Документ.Премия КАК Премия
	|ГДЕ
	|	Премия.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПремияРаспределениеПоТерриториямУсловиямТруда.НомерСтроки КАК НомерСтроки,
	|	ПремияРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ПремияРаспределениеПоТерриториямУсловиямТруда.Территория КАК Территория,
	|	ПремияРаспределениеПоТерриториямУсловиямТруда.УсловияТруда КАК УсловияТруда,
	|	ПремияРаспределениеПоТерриториямУсловиямТруда.ДоляРаспределения КАК ДоляРаспределения,
	|	ПремияРаспределениеПоТерриториямУсловиямТруда.Результат КАК Результат,
	|	ПремияРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтрокиПоказателей КАК ИдентификаторСтрокиПоказателей
	|ИЗ
	|	Документ.Премия.РаспределениеПоТерриториямУсловиямТруда КАК ПремияРаспределениеПоТерриториямУсловиямТруда
	|ГДЕ
	|	ПремияРаспределениеПоТерриториямУсловиямТруда.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПремияРаспределениеРезультатовНачислений.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ПремияРаспределениеРезультатовНачислений.Территория КАК Территория,
	|	ПремияРаспределениеРезультатовНачислений.СтатьяФинансирования КАК СтатьяФинансирования,
	|	ПремияРаспределениеРезультатовНачислений.СтатьяРасходов КАК СтатьяРасходов,
	|	ПремияРаспределениеРезультатовНачислений.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|	ПремияРаспределениеРезультатовНачислений.ОблагаетсяЕНВД КАК ОблагаетсяЕНВД,
	|	СУММА(ПремияРаспределениеРезультатовНачислений.Результат) КАК Результат,
	|	ПремияРаспределениеРезультатовНачислений.ПодразделениеУчетаЗатрат КАК ПодразделениеУчетаЗатрат
	|ИЗ
	|	Документ.Премия.РаспределениеРезультатовНачислений КАК ПремияРаспределениеРезультатовНачислений
	|ГДЕ
	|	ПремияРаспределениеРезультатовНачислений.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПремияРаспределениеРезультатовНачислений.СпособОтраженияЗарплатыВБухучете,
	|	ПремияРаспределениеРезультатовНачислений.СтатьяФинансирования,
	|	ПремияРаспределениеРезультатовНачислений.ОблагаетсяЕНВД,
	|	ПремияРаспределениеРезультатовНачислений.СтатьяРасходов,
	|	ПремияРаспределениеРезультатовНачислений.ПодразделениеУчетаЗатрат,
	|	ПремияРаспределениеРезультатовНачислений.Территория,
	|	ПремияРаспределениеРезультатовНачислений.ИдентификаторСтроки";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Результаты = Запрос.ВыполнитьПакет();
	
	РеквизитыДляПроведения = РеквизитыДляПроведенияПустаяСтруктура();
	
	ВыборкаРеквизиты = Результаты[0].Выбрать();
	
	Пока ВыборкаРеквизиты.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(РеквизитыДляПроведения, ВыборкаРеквизиты);
		
	КонецЦикла;
	
	РаспределениеПоТерриториямУсловиямТруда = Результаты[1].Выгрузить();
	РаспределениеРезультатовНачислений = Результаты[2].Выгрузить();
	РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда = РаспределениеПоТерриториямУсловиямТруда;
	РеквизитыДляПроведения.РаспределениеРезультатовНачислений = РаспределениеРезультатовНачислений;
	
	Возврат РеквизитыДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведенияПустаяСтруктура()
	
	РеквизитыДляПроведенияПустаяСтруктура = Новый Структура("Ссылка, ДокументРассчитан, Организация, ПериодРегистрации, Дата, ПорядокВыплаты, ПланируемаяДатаВыплаты, 
		| РассчитыватьУдержания, РаспределениеПоТерриториямУсловиямТруда, ВидПремии, ИсправленныйДокумент, РаспределениеРезультатовНачислений");
	
	Возврат РеквизитыДляПроведенияПустаяСтруктура;
	
КонецФункции

Процедура ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента) Экспорт
	
	ЗарплатаКадры.ЗаполнитьДатуЗапретаРедактированияСписочногоДокумента(ОбъектДокумента, "Начисления", "ДатаНачала");
	
КонецПроцедуры

Процедура ЗаполнитьДатыЗапрета(ПараметрыОбновления) Экспорт
	
	ОбновлениеВыполнено = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 100
		|	Премия.Ссылка КАК Ссылка,
		|	Премия.Дата КАК Дата
		|ИЗ
		|	Документ.Премия КАК Премия
		|ГДЕ
		|	Премия.ДатаЗапрета = ДАТАВРЕМЯ(1, 1, 1)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Премия.Дата УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ОбновлениеВыполнено = Ложь;
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				ПараметрыОбновления, Выборка.Ссылка.Метаданные().ПолноеИмя(), "Ссылка", Выборка.Ссылка) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			ОбъектДокумента = Выборка.Ссылка.ПолучитьОбъект();
			
			МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Выборка.Ссылка);
			МенеджерДокумента.ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента);
			
			ОбъектДокумента.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектДокумента);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", ОбновлениеВыполнено);
	
КонецПроцедуры

Процедура ЗаполнитьИсходныеДанныеПерерасчетов(ПараметрыОбновления) Экспорт

	ПараметрыЗаполнения = ПерерасчетЗарплаты.ПараметрыЗаполненияИсходныхДанныхПерерасчетов();
	ПараметрыЗаполнения.ПолеВидРасчета = "Ссылка.ВидПремии";
	ПерерасчетЗарплаты.ЗаполнитьИсходныеДанныеПерерасчетов(ПараметрыОбновления, Метаданные.Документы.Премия, ПараметрыЗаполнения);

КонецПроцедуры

#КонецОбласти

#КонецЕсли