////////////////////////////////////////////////////////////////////////////////
// ИнтеграцияСЯндексКассой: механизм интеграции с Яндекс.Кассой.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает ссылку на страницу оплаты через Яндекс.Кассу.
// Если платежная ссылка уже формировалась, то обновляет данные в сервисе.
//
// Параметры:
//  ОснованиеПлатежа - Произвольный - основание платежа, для которого необходимо сформировать ссылку.
//
// Возвращаемое значение:
//  Строка - ссылка на страницу оплаты через Яндекс.Кассу.
//
Функция ПлатежнаяСсылка(Знач ОснованиеПлатежа) Экспорт
	
	ВходящиеПараметры = Новый Структура;
	ВходящиеПараметры.Вставить("ОснованиеПлатежа", ОснованиеПлатежа);
	
	Возврат ИнтеграцияСЯндексКассойСлужебный.ПлатежнаяСсылка(ВходящиеПараметры);
	
КонецФункции

// Отправляет запрос получения операций по Яндекс.Кассе в сервис 1С,
// и возвращает массив структур описывающих операции.
//
// Параметры:
//  ПериодЗапроса - СтандартныйПериод, Структура - Период за который будут выбираться операции по Яндекс.Кассе.
//    * ДатаНачала - Дата - начало периода запроса. 
//                          Если не указан, дата начала будет определена автоматически.
//    * ДатаОкончания - Дата - окончание периода запроса. 
//                             Если не указан, дата окончания будет равна текущей дате.
//  Организация - ОпределяемыйТип.Организация - организация, по которой нужно отобрать операции. 
//                                              Если не указана то, будут обработаны все действительные настройки;
//  СДоговором - Булево, Неопределено - позволяет указать для каких настроек следует загружать операции:
//                                      * Неопределено - будут загружены и операции по схемам "С договором" и "Без договора"
//                                      * Истина - будут загружены операции по схеме "С договором"
//                                      * Ложь - будут загружены операции по схеме "Без договора"
//                                      Если указан параметр Организация, этот параметр не учитывается
// Возвращаемое значение:
//  Неопределено - если параметры заданы неверно.
//  Массив - массив структур, содержащий данные об операциях по Яндекс.Кассе.
//   * ДатаНачала - Дата - начало периода запроса операций.
//   * ДатаОкончания - Дата - окончание периода запроса операций.
//   * ДатаОтвета - Дата - дата ответа от сервиса.
//   * НастройкаЯндексКассы - СправочникСсылка.НастройкиЯндексКассы - настройки Яндекс.Кассы, для которых получены операции.
//   * ОперацииТекстовыйФормат - Строка - данные операций в текстовом формате (см. http://v8.1c.ru/edi/edi_stnd/100/).
//   * Организация - ОпределяемыйТип.Организация - организация, для которой получены операции.
//   * СДоговором - Булево - признак вида настройки интеграции с Яндекс.Кассой (Истина - по договору, Ложь - без договора).
//   * ОперацииМассивСтруктур - Массив структур - операции за заданный период по соответствующей настройке (организации):
//    Общие свойства:
//     ** ИдентификаторТранзакции - Число - идентификатор операции в сервисе Яндекс.Касса.
//     ** ИдентификаторПлатежа - Строка - идентификатор платежа.
//     ** ИдентификаторМагазина - Число - идентификатор магазина в сервисе Яндекс.Касса.
//     ** СДоговором - Булево - признак вида настройки интеграции с Яндекс.Кассой (Истина - по договору, Ложь - без договора).
//     ** ВидОперации - Строка - "Оплата" - для операций оплаты, "Возврат" - для операций возврата.
//    Операция оплаты:
//     ** ДатаОплаты - Дата - дата оплаты.
//     ** СуммаДокумента - Число - сумма оплаты.
//     ** ВалютаДокумента - СправочникСсылка.Валюта - валюта платежа.
//     ** СуммаКЗачислениюНаСчетОрганизации - Число, Неопределено - сумма к зачислению на счет организации (за вычетом комиссии Яндекс.Кассы). 
//                                                                  Передается только для схемы "С договором".
//     ** ВалютаСуммыКЗачислениюНаСчетОрганизации - СправочникСсылка.Валюта - валюта зачисления на счет организации.
//     ** СпособОплаты - Строка - код способа оплаты.
//     ** ИННОрганизации - Строка, Неопределено - ИНН организации. Если не известен, то Неопределено.
//     ** НаименованиеБанкаОрганизации - Строка, Неопределено - банк, на счет которого зачислена оплата. Если не известен, то Неопределено.
//     ** НаименованиеПолноеОрганизации - Строка, Неопределено - организация, на счет которой зачислена оплата. Если не известен, то Неопределено.
//     ** БикБанкаОрганизации - Строка, Неопределено - БИК банка, на счет которого зачислена оплата. Если не известен, то Неопределено.
//     ** КоррСчетБанкаОрганизации - Строка, Неопределено - корр. счет банка, на счет которого зачислена оплата. Если не известен, то Неопределено.
//     ** НомерРасчетногоСчетаОрганизации - Строка, Неопределено - номер расчетного счета, на который зачислена оплата. Если не известен, то Неопределено.
//     ** НазначениеПлатежа - Строка - назначение платежа, определенное при формирование ссылки на оплату.
//     ** ДатаФормированияЧека - Строка - дата формирования чека об оплате(в формате "дд.мм.гггг чч:мм:сс").
//     ** СуммаЧека - Число - сумма чека.
//     ** НомерФискальногоНакопителя - Строка - номер фискального накопителя.
//     ** ФискальныйНомерДокумента - Число - фискальный номер документа.
//     ** ФискальныйПризнакДокумента - Строка - фискальный признак документа
//     ** КонтактныеДанныеЭлектронногоЧека - Строка - телефон или электронная почта, на которые был отправлен чек.
//    Операция возврата:
//     ** ИдентификаторВозврата - Число - идентификатор операции возврата.
//     ** СуммаДокумента - Число - сумма возврата.
//     ** ВалютаДокумента - СправочникСсылка.Валюта - валюта возврата.
//     ** ОписаниеПричиныВозврата - Строка - причина возврата.
//     ** ДатаРегистрацииЗапросаНаВозврат - Дата - дата регистрации запроса на возврат.
//     ** ДатаИсполненияЗапросаНаВозврат - Дата - дата исполнения запроса на возврат.
//     ** ОтправительЗапросаНаВозврат - Строка - отправитель запроса на возврат.
//    Дополнительные настройки:
//     ** Свойства, соответствующие дополнительным переопределяемым настройкам. См. ИнтеграцияСЯндексКассойПереопределяемый.ПриОпределенииДополнительныхНастроекЯндексКассы.
//
Функция ОперацииПоЯндексКассе(ПериодЗапроса = Неопределено, Организация = Неопределено, СДоговором = Неопределено) Экспорт
	
	ДатаНачала    = Неопределено;
	ДатаОкончания = Неопределено;
	Если ТипЗнч(ПериодЗапроса) = Тип("СтандартныйПериод") Тогда 
		ДатаНачала    = ПериодЗапроса.ДатаНачала;
		ДатаОкончания = ПериодЗапроса.ДатаОкончания;
	ИначеЕсли ТипЗнч(ПериодЗапроса) = Тип("Структура") Тогда 
		ПериодЗапроса.Свойство("ДатаНачала",    ДатаНачала);
		ПериодЗапроса.Свойство("ДатаОкончания", ДатаОкончания);
	КонецЕсли;
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	Если Не ДатаНачала = Неопределено Тогда 
		Если ДатаНачала > ТекущаяДатаСеанса ИЛИ ДатаОкончания > КонецДня(ТекущаяДатаСеанса) Тогда
			СообщениеТекст = НСтр("ru = 'Период запроса указан неверно'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеТекст, , "Период");
			Возврат Неопределено;
		КонецЕсли;
		
		Если Не ДатаОкончания = Неопределено Тогда
			Если ДатаНачала > ДатаОкончания Тогда 
				СообщениеТекст = НСтр("ru = 'Период запроса указан неверно'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеТекст, , "Период");
				Возврат Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ДатаОкончания = Неопределено Тогда
		Если КонецДня(ДатаОкончания) = КонецДня(ТекущаяДатаСеанса) Тогда
			ДатаОкончания = ТекущаяДатаСеанса;
		Иначе
			ДатаОкончания = КонецДня(ДатаОкончания);
		КонецЕсли;
	КонецЕсли;
	
	ВходящиеПараметры = Новый Структура();
	ВходящиеПараметры.Вставить("Организация", Организация);
	ВходящиеПараметры.Вставить("ДатаНачала", ДатаНачала);
	ВходящиеПараметры.Вставить("ДатаОкончания", ДатаОкончания);
	ВходящиеПараметры.Вставить("СДоговором", СДоговором);
	
	Результат = ИнтеграцияСЯндексКассойСлужебный.ОперацииПоЯндексКассе(ВходящиеПараметры);
	
	Возврат Результат;
	
КонецФункции

// Загружает операций по Яндекс.Кассе с сервера 1С, 
// и обновляет статус обменов.
//
// Параметры:
//  Период - СтандартныйПериод, Структура - Период за который будут выбираться операции по Яндекс.Кассе.
//    * ДатаНачала - Дата - начало периода запроса. 
//                          Если не указан, дата начала будет определена автоматически.
//    * ДатаОкончания - Дата - окончание периода запроса. 
//                             Если не указан, дата окончания будет равна текущей дате.
//  Организация - ОпределяемыйТип.Организация - организация, по которой нужно отобрать операции. 
//                                              Если не указана то, будут обработаны все действительные настройки;
//  СДоговором - Булево, Неопределено - позволяет указать для каких настроек следует загружать операции:
//                                      * Неопределено - будут загружены и операции по схемам "С договором" и "Без договора"
//                                      * Истина - будут загружены операции по схеме "С договором"
//                                      * Ложь - будут загружены операции по схеме "Без договора"
//                                      Если указан параметр Организация, этот параметр не учитывается.
//
// Возвращаемое значение:
//  Соответствие - результаты загрузки операций для каждой настройки.
//   * Ключ - СправочникСсылка.НастройкиЯндексКассы - настройка Яндекс.Кассы, по которой были загружены операции.
//   * Значение - Произвольный - результаты загрузки операций. Определяются в ИнтеграцияСЯндексКассойПереопределяемый.ПриЗагрузкеОперацийПоЯндексКассе.
//
Функция ЗагрузитьОперацииПоЯндексКассе(Период = Неопределено, Организация = Неопределено, СДоговором = Неопределено) Экспорт
		
	Результат = Новый Соответствие;
	
	Если НЕ ЕстьПравоНаЗагрузкуОперацийПоЯндексКассе() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Недостаточно прав на загрузку операций по Яндекс.Кассе.'"));
		Возврат Результат;
	КонецЕсли;
	
	ОперацииПоОрганизации = ОперацииПоЯндексКассе(Период, Организация, СДоговором);
	
	Если ОперацииПоОрганизации = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для каждого Операции Из ОперацииПоОрганизации Цикл
		
		Отказ = Ложь;
		
		ПромежуточныйРезультат = Неопределено;
		ИнтеграцияСЯндексКассойПереопределяемый.ПриЗагрузкеОперацийПоЯндексКассе(Операции, ПромежуточныйРезультат, Отказ);
		Результат.Вставить(Операции.НастройкаЯндексКассы, ПромежуточныйРезультат);
				
		Если Не Отказ И ЗначениеЗаполнено(Операции.ОперацииМассивСтруктур) Тогда
			
			Статус = Новый Структура("ДатаПоследнегоУспешногоОбмена, Организация", Операции.ДатаОтвета, Операции.Организация);
			ИнтеграцияСЯндексКассойСлужебный.УстановитьСтатусОбменаСЯндексКассой(Операции.НастройкаЯндексКассы, Статус);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает данные эквайера Яндекс.Кассы
//
// Параметры:
//  Период - Дата - дата актуальности данных.
//
// Возвращаемое значение:
//  Структура - данные эквайера:
//   * НаименованиеПолное - Строка - полное наименование эквайера.
//   * Наименование - Строка - сокращенное наименование эквайера.
//   * ИНН - Строка - ИНН эквайера.
//   * КПП - Строка - КПП эквайера.
//   * ОГРН - Строка - ОГРН эквайера.
//   * ОКВЭД - Строка - ОКВЭД эквайера.
//   * КодПоОКПО - Строка - код по ОКПО эквайера.
//
Функция ДанныеЭквайераЯндексКасса(Период) Экспорт
	
	 Возврат Справочники.НастройкиЯндексКассы.ДанныеЭквайераПоУмолчанию(Период);
	
КонецФункции

// Возвращает уникальный идентификатор платежа.
//
// Параметры:
//  Код - Строка - код основания платежа.
//
// Возвращаемое значение:
//  Строка - уникальный идентификатор платежа.
//
Функция ПолучитьУникальныйИдентификаторПлатежа(Код) Экспорт
	
	Возврат ИнтеграцияСЯндексКассойСлужебный.ПолучитьУникальныйИдентификаторПлатежаСКонтрольнымРазрядом(Код);
	
КонецФункции

// Проверка права на загрузку операций по Яндекс.Кассе.
// 
// Возвращаемое значение:
//  Булево - Истина если есть право на загрузку.
//
Функция ЕстьПравоНаЗагрузкуОперацийПоЯндексКассе() Экспорт
	
	Возврат Пользователи.РолиДоступны("ВыполнениеОбменовСЯндексКассой") 
		И ПравоДоступа("Изменение", Метаданные.РегистрыСведений.СтатусОбменовСЯндексКассой);

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// ЭлектронноеВзаимодействие

// См. ЭлектронноеВзаимодействие.ПриПолученииСпискаШаблонов.
Процедура ПриПолученииСпискаШаблонов(ШаблоныЗаданий) Экспорт
	
	ШаблоныЗаданий.Добавить(Метаданные.РегламентныеЗадания.ПолучениеУведомленийОтЯндексКассы.Имя);
	
КонецПроцедуры

// См. ЭлектронноеВзаимодействие.ПриОпределенииПсевдонимовОбработчиков.
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	СоответствиеИменПсевдонимам.Вставить(Метаданные.РегламентныеЗадания.ПолучениеУведомленийОтЯндексКассы.ИмяМетода);
	
КонецПроцедуры

// См. ЭлектронноеВзаимодействие.ПриОпределенииНастроекРегламентныхЗаданий.
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	НоваяСтрока = Настройки.Добавить();
	НоваяСтрока.РегламентноеЗадание = Метаданные.РегламентныеЗадания["ПолучениеУведомленийОтЯндексКассы"];
	НоваяСтрока.ФункциональнаяОпция = Метаданные.ФункциональныеОпции["ИспользоватьИнтеграциюСЯндексКассой"];
	
КонецПроцедуры

// См. ЭлектронноеВзаимодействие.ПриЗаполненииСписковСОграничениемДоступа
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	Списки.Вставить(Метаданные.Справочники.НастройкиЯндексКассы, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.СтатусОбменовСЯндексКассой, Истина);
	
КонецПроцедуры

// См. ЭлектронноеВзаимодействие.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт
	
	Описание = Описание + "
	|Справочник.НастройкиЯндексКассы.Чтение.Организации
	|Справочник.НастройкиЯндексКассы.Изменение.Организации
	|РегистрСведений.СтатусОбменовСЯндексКассой.Чтение.Организации
	|РегистрСведений.СтатусОбменовСЯндексКассой.Изменение.Организации
	|";
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие

// СтандартныеПодсистемы.ПодключаемыеКоманды

// См. ПодключаемыеКомандыПереопределяемый.ПриОпределенииВидовПодключаемыхКоманд.
Процедура ПриОпределенииВидовПодключаемыхКоманд(ВидыПодключаемыхКоманд) Экспорт
	
	Вид = ВидыПодключаемыхКоманд.Добавить();
	Вид.Имя = "ЯндексКасса";
	Вид.ИмяПодменю = "ПодменюЯндексКасса";
	Вид.Заголовок = НСтр("ru = 'Яндекс.Касса'");
	Вид.Картинка = БиблиотекаКартинок.ЯндексКассаБЭД;
	Вид.Отображение = ОтображениеКнопки.Картинка;
	Вид.ВидГруппыФормы = ВидГруппыФормы.Подменю;
	
КонецПроцедуры

// См. ПодключаемыеКомандыПереопределяемый.ПриОпределенииСоставаНастроекПодключаемыхОбъектов.
Процедура ПриОпределенииСоставаНастроекПодключаемыхОбъектов(НастройкиПрограммногоИнтерфейса) Экспорт
	
	Настройка = НастройкиПрограммногоИнтерфейса.Добавить();
	Настройка.Ключ = "ДобавитьКомандыЯндексКассы";
	Настройка.ОписаниеТипов = Новый ОписаниеТипов("Булево");
	Настройка.ВидыПодключаемыхОбъектов = "Отчет, Обработка";
	
КонецПроцедуры

// См. ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту.
Процедура ПриОпределенииКомандПодключенныхКОбъекту(НастройкиФормы, Источники, ПодключенныеОтчетыИОбработки, Команды) Экспорт
	
	Если Не Пользователи.РолиДоступны("ПолучениеПлатежнойСсылкиДляЯндексКассы") Тогда
		Возврат;
	КонецЕсли;
	
	ИменаОснованийПлатежа = ИнтеграцияСЯндексКассойСлужебный.ОснованияПлатежа();
	
	ТипыОбъектов = Новый Массив;
	Для каждого ПолноеИмя Из ИменаОснованийПлатежа Цикл
		Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмя);
		ТипыОбъектов.Добавить(ТипЗнч(Менеджер.ПустаяСсылка()));
	КонецЦикла;
	ТипПараметра = Новый ОписаниеТипов(ТипыОбъектов);
	
	Команда = Команды.Добавить();
	Команда.Вид = "ЯндексКасса";
	Команда.Идентификатор = "ЯндексКасса";
	Команда.Представление = НСтр("ru = 'Оплата через Яндекс.Кассу'");
	Команда.Важность = "Обычное";
	Команда.Порядок = 50;
	Команда.ОтображениеКнопки = ОтображениеКнопки.Картинка;
	Команда.Картинка = БиблиотекаКартинок.ЯндексКассаБЭД;
	Команда.ТипПараметра = ТипПараметра;
	Команда.Назначение = "ДляОбъекта";
	Команда.ФункциональныеОпции = "ИспользоватьИнтеграциюСЯндексКассой";
	Команда.ИзменяетВыбранныеОбъекты = Ложь;
	Команда.МножественныйВыбор = Ложь;
	Команда.РежимЗаписи = "Записывать";
	Команда.Обработчик = "ИнтеграцияСЯндексКассойСлужебныйКлиент.Подключаемый_ОткрытьФормуПлатежнойСсылки";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.ШаблоныСообщений

// См. ШаблоныСообщенийПереопределяемый.ПриПодготовкеШаблонаСообщения.
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, НазначениеШаблона, ДополнительныеПараметры) Экспорт 
	
	Если ПустаяСтрока(НазначениеШаблона) Тогда 
		Возврат;
	КонецЕсли;

	Если Не ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ЗначениеФункциональнойОпции("ИспользоватьИнтеграциюСЯндексКассой") Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ИнтеграцияСЯндексКассойСлужебный.ЭтоОснованиеПлатежа(НазначениеШаблона) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ТипШаблона = "Письмо" Тогда
		
		НовыйРеквизит = Реквизиты.Добавить();
		НовыйРеквизит.Имя = "КнопкаОплатитьЧерезЯндексКассу";
		НовыйРеквизит.Представление = НСтр("ru = 'Кнопка ""Оплатить через Яндекс.Кассу""'");
		
		Если ДополнительныеПараметры.ФорматПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
			КартинкаКнопки = Вложения.Добавить();
			КартинкаКнопки.Идентификатор = "КартинкаКнопкиДляОплатыЯндексКасса";
			КартинкаКнопки.Имя = "КартинкаКнопкиДляОплатыЯндексКасса";
			КартинкаКнопки.Представление = НСтр("ru = 'Кнопка ""Оплатить через Яндекс.Кассу""'");
			КартинкаКнопки.ТипФайла = "png";
			КартинкаКнопки.Реквизит = "КнопкаОплатитьЧерезЯндексКассу";
		КонецЕсли;
		
	ИначеЕсли ДополнительныеПараметры.ТипШаблона = "SMS" Тогда
		
		НовыйРеквизит = Реквизиты.Добавить();
		НовыйРеквизит.Имя = "КнопкаОплатитьЧерезЯндексКассу";
		НовыйРеквизит.Представление = НСтр("ru = 'Кнопка ""Оплатить через Яндекс.Кассу""'");
		
	КонецЕсли;
	
КонецПроцедуры

// См. ШаблоныСообщенийПереопределяемый.ПриФормированииСообщения.
Процедура ПриФормированииСообщения(Сообщение, НазначениеШаблона, ПредметСообщения, ДополнительныеПараметры) Экспорт
	
	Если ПустаяСтрока(НазначениеШаблона) Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ЗначениеФункциональнойОпции("ИспользоватьИнтеграциюСЯндексКассой") Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ИнтеграцияСЯндексКассойСлужебный.ЭтоОснованиеПлатежа(НазначениеШаблона) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ТипШаблона = "Письмо"
		И Сообщение.ЗначенияРеквизитов.Получить("КнопкаОплатитьЧерезЯндексКассу") <> Неопределено Тогда
		
			Если Сообщение.ДополнительныеПараметры.Свойство("ПлатежнаяСсылка") 
				И ЗначениеЗаполнено(Сообщение.ДополнительныеПараметры.ПлатежнаяСсылка) Тогда
				
				ПлатежнаяСсылка = Сообщение.ДополнительныеПараметры.ПлатежнаяСсылка;
			Иначе 
				
				ПлатежнаяСсылка = ПлатежнаяСсылка(ПредметСообщения);
				
			КонецЕсли; 
			
			Если ПустаяСтрока(ПлатежнаяСсылка) Тогда 
				Возврат;
			КонецЕсли;
			
			Если ДополнительныеПараметры.ФорматПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
				Если Сообщение.ЗначенияРеквизитов["КнопкаОплатитьЧерезЯндексКассу"] <> Неопределено Тогда 
					HTMLТекстКнопки = "<a href='" + ПлатежнаяСсылка + "'><img src=""cid:КнопкаОплатитьЧерезЯндексКассу""></a>";
					Если Сообщение.Вложения["КнопкаОплатитьЧерезЯндексКассу"] = Неопределено Тогда
						АдресКартинки = ПоместитьВоВременноеХранилище(
							БиблиотекаКартинок.КнопкаОплатитьБЭД.ПолучитьДвоичныеДанные());
						Сообщение.Вложения["КнопкаОплатитьЧерезЯндексКассу"] = АдресКартинки;
					КонецЕсли;
					Сообщение.ЗначенияРеквизитов["КнопкаОплатитьЧерезЯндексКассу"] = HTMLТекстКнопки;
				КонецЕсли;
			Иначе
				Сообщение.ЗначенияРеквизитов["КнопкаОплатитьЧерезЯндексКассу"] = НСтр("ru = 'Оплатить счет:'") + Символы.ПС + ПлатежнаяСсылка;
			КонецЕсли;
			
	ИначеЕсли ДополнительныеПараметры.ТипШаблона = "SMS"
		И Сообщение.ЗначенияРеквизитов.Получить("КнопкаОплатитьЧерезЯндексКассу") <> Неопределено Тогда 
		
		Сообщение.ЗначенияРеквизитов["КнопкаОплатитьЧерезЯндексКассу"] = ПлатежнаяСсылка(ПредметСообщения);
			
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ШаблоныСообщений

#КонецОбласти

#КонецОбласти



