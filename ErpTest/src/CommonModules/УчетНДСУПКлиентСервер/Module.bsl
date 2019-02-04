#Область ПрограммныйИнтерфейс

#Область УчетВходящегоНДС

#Область ЗаполнениеНалогообложенияНДСЗакупки

// Возвращает структуру параметров заполнения налогообложения НДС закупки товаров или возврата товаров поставщику.
//
// Возвращаемое значение 
// 	Структура - Параметры заполнения
//		* Контрагент - СправочникСсылка.Контрагенты, СправочникСсылка.Организации - Контрагент или организация-поставщик.
//		* Договор - СправочникСсылка.ДоговорыКонтрагентов, 
//					СправочникСсылка.ДоговорыМеждуОрганизаций - Договор, в рамках которого осуществляется закупка или возврат. 
// 		[Параметры операции]	
// 		* ПриобретениеТоваров - Булево - Документ отражает приобретение товаров или сопутствующие приобретению операции:
//		                                 поступление товаров, прием товаров на хранение для последующего выкупа, акт о расхождении при приемке.
// 		* ПриобретениеРабот - Булево - Документ отражает приобретение работ.
// 		* ПриобретениеНаСтатьи - Булево - Документ отражает приобретение ценностей, которые относятся на статьях прочих расходов или прочих активов.
// 		* ВыкупВозвратнойТарыУПоставщика - Булево - Документ отражает выкуп принятой у поставщика возвратной тары.
//		* ПриемНаКомиссию - Булево - Признак того, что товар принимается на комиссию.
//		* ИмпортТоваров - Булево - Признак того, что приобретаемый товар ввозится из другой страны, с прохождением таможенной процедуры.
//		* ЛизинговыеУслуги - Булево - Признак того, что отражаются лизинговые услуги.
//		* ВвозТоваровИзТаможенногоСоюза - Булево - Признак того, что товар ввозится из стран таможенного союза. В этом случае оформляется заявление о ввозе.
//		* ЗакупкаЧерезПодотчетноеЛицо - Булево - Признак того, что документ отражает операции приобретения через подотчетное лицо.
//		* ВозвратТоваровПоставщику - Булево - Признак того, что документ отражает операцию возврата товаров поставщику.
//		* ВозвратТоваровКомитенту - Булево - Признак того, что документ отражает операцию возврата товаров комитенту.
//	
//	    * ЭтоОперацияМеждуОрганизациями - Булево - Истина, если отражается операция между собственными организациями (интеркампани).
//	                           Параметр указывается для уточнение к параметрам операции (например, совместно с параметром ВозвратТоваровПоставщику).
//
Функция ПараметрыЗаполненияНалогообложенияНДСЗакупки() Экспорт
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Контрагент");
	ПараметрыЗаполнения.Вставить("Договор");
	
	// Параметры отражаемой операции
	ПараметрыЗаполнения.Вставить("ПриобретениеТоваров", Ложь);
	ПараметрыЗаполнения.Вставить("ПриобретениеРабот", Ложь);
	ПараметрыЗаполнения.Вставить("ПриобретениеНаСтатьи", Ложь);
	ПараметрыЗаполнения.Вставить("ВыкупВозвратнойТарыУПоставщика", Ложь);
	ПараметрыЗаполнения.Вставить("ПриемНаКомиссию", Ложь);
	ПараметрыЗаполнения.Вставить("ИмпортТоваров", Ложь);
	ПараметрыЗаполнения.Вставить("ЛизинговыеУслуги", Ложь);
	ПараметрыЗаполнения.Вставить("ВвозТоваровИзТаможенногоСоюза", Ложь);
	ПараметрыЗаполнения.Вставить("ЗакупкаЧерезПодотчетноеЛицо", Ложь);
	ПараметрыЗаполнения.Вставить("ВозвратТоваровПоставщику", Ложь);
	ПараметрыЗаполнения.Вставить("ВозвратТоваровКомитенту", Ложь);
	
	ПараметрыЗаполнения.Вставить("ЭтоОперацияМеждуОрганизациями", Ложь);
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

// Определяет, будет ли ненулевая сумма НДС в документе закупки
// 
// Параметры:
// 	НалогообложениеНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС - налогообложение документа закупки
// 
// Возвращаемое значение:
// 	Булево - Истина, если облагается НДС
//
Функция ЗакупкаОблагаетсяНДС(НалогообложениеНДС) Экспорт
	
	Возврат Не (НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС")
	            Или НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД")
	            Или НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.НалоговыйАгентПоНДС")
	            Или НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя"));
	
КонецФункции

#КонецОбласти

#Область ЗаполнениеВидаДеятельностиНДС

// Возвращает структуру параметров заполнения вида деятельности раздельного учета НДС.
//
// Возвращаемое значение:
// 	Структура - Структура параметров с ключами  
// 		* Организация - СправочникСсылка.Организации - Организация документа.
// 		* Дата - Дата - Дата документа
// 		* Склад - СправочникСсылка.Склады - Склад-получатель товаров (необязательный). Если получателей несколько, но не заполняется.
// 		* Договор - СправочникСсылка.ДоговорыКонтрагентов, 
// 		            СправочникСсылка.ДоговорыМеждуОрганизациями - Договор с поставщиком (необязательный). 
// 		                                                          Указывается в случае отражения операций закупки ценностей.
// 		* НаправлениеДеятельности - СправочникСсылка.НаправленияДеятельности - Направление деятельности - получатель ценностей (необязательный).
// 		[Операции документа]
// 		* ПриобретениеТоваров - Булево - Документ отражает приобретение товаров или сопутствующие приобретению операции:
//		                                 поступление товаров, акт о расхождении, корректировку приобретения товаров.
// 		* ПриобретениеРабот - Булево - Документ отражает приобретение работ.
// 		* ПриобретениеНаСтатьи - Булево - Документ отражает приобретение ценностей, которые в момент приобретения относятся на статьях прочих расходов или прочих активов.
// 		* ДвижениеТоваровНаСкладах - Булево - Документ отражает движение (перемещение) товаров в рамках складского контура, в том числе цеховых кладовых.
// 		* ДвижениеТоваровИРаботВПроизводстве - Булево - Документ отражает передачу товаров в производство, движение товаров и работ внутри контура производства. 
// 		* СписаниеТоваровИРаботНаСтатьи - Булево - Документ отражает списание товаров и работ на статьи расходов или прочих активов.
// 		* ПередачаВЭксплуатацию - Булево - Документ отражает передачу материалов в эксплуатацию.
// 		* СборкаРазборкаТоваров - Булево - Документ отражает сборку или разборку товаров.
// 		* ВыпускПродукцииИРабот - Булево - Документ отражает выпуск продукции (полуфабрикатов) или работ (создание ценности своими силами).
// 		* ПрочееВыбытиеТоваров - Булево - Документ отражает порчу, списание недостач или пересортицу товаров.
// 		* ЛизинговоеИмуществоНаБалансе - Булево - Документ отражает поступление услуг лизинга по имуществу на балансе лизингополучателя.
// 		* КорректировкаВидаДеятельностиНДС - Булево - Документ отражает изменение вида деятельности НДС без реального движения товаров.
// 		* АвансовыйОтчет - Булево - Несмотря на то, что авансовый отчет отражает приобретение, для него используется отдельный параметр,
// 		                             т.к. документ не входит в контур автоматизированного раздельного учета НДС.
Функция ПараметрыЗаполненияВидаДеятельностиНДС() Экспорт
	
	ПараметрыЗаполнения = Новый Структура();
	
	// Реквизиты документа
	ПараметрыЗаполнения.Вставить("Организация",             Неопределено);
	ПараметрыЗаполнения.Вставить("Дата",                    '00010101');
	ПараметрыЗаполнения.Вставить("Склад",                   Неопределено);
	ПараметрыЗаполнения.Вставить("Договор",                 Неопределено);
	ПараметрыЗаполнения.Вставить("НаправлениеДеятельности", Неопределено);
	
	// Параметры операции
	ПараметрыЗаполнения.Вставить("ПриобретениеТоваров",                Ложь);
	ПараметрыЗаполнения.Вставить("ПриобретениеРабот",                  Ложь);
	ПараметрыЗаполнения.Вставить("ПриобретениеНаСтатьи",               Ложь);
	ПараметрыЗаполнения.Вставить("ДвижениеТоваровНаСкладах",           Ложь);
	ПараметрыЗаполнения.Вставить("ДвижениеМеждуФилиалами",             Ложь);
	ПараметрыЗаполнения.Вставить("ДвижениеТоваровИРаботВПроизводстве", Ложь);
	ПараметрыЗаполнения.Вставить("СписаниеТоваровИРаботНаСтатьи",      Ложь);
	ПараметрыЗаполнения.Вставить("ПередачаВЭксплуатацию",              Ложь);
	ПараметрыЗаполнения.Вставить("СборкаРазборкаТоваров",              Ложь);
	ПараметрыЗаполнения.Вставить("ВыпускПродукцииИРабот",              Ложь);
	ПараметрыЗаполнения.Вставить("ПрочееВыбытиеТоваров",               Ложь);
	ПараметрыЗаполнения.Вставить("ЛизинговоеИмуществоНаБалансе",       Ложь);
	
	ПараметрыЗаполнения.Вставить("КорректировкаВидаДеятельностиНДС",   Ложь);
	
	ПараметрыЗаполнения.Вставить("АвансовыйОтчет",                     Ложь);
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

#КонецОбласти

#Область РегистрацияСчетовФактурПолученных

// Возвращает структуру параметров регистрации счетов-фактур на основании документов закупки или возврата товаров от клиента.
//
// Возвращаемое значение:
// 	Структура - Структура параметров с ключами
// 	     * Ссылка - ДокументСсылка - Ссылка на документ закупки.
// 	     * Организация - СправочникСсылка.Организации - Организация, в которой отражается закупка или возврат товаров.
// 	     * Контрагент - СправочникСсылка.Контрагенты,
// 	                    СправочникСсылка.Организации - Контрагент или организация поставщик.
// 	                                                   Покупатель товаров при возврате.
// 	     * НалогообложениеНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС - Налогообложение НДС документа закупки или возврата.
// 	     [Параметры операции]
// 	     * ПриобретениеТоваровРаботУслуг - Признак того, что отражается приобретение товаров, работ, услуг 
// 	                                       или иных ценностей у поставщика (комиссионера, переработчика) на внутреннем рынке.
// 	     * ПриемНаКомиссию - Булево - Признак того, что отражается операция приемки товаров на комиссию.
// 	     * ИмпортТоваров - Булево - Признак того, что отражается операция импорта с прохождением таможенной процедуры.
// 	     * ВвозТоваровИзТаможенногоСоюза - Булево - Признак того, что отражается операция ввоза товаров из стран таможенного союза с оформлением заявление о ввозе.
// 	     * ЗакупкаЧерезПодотчетноеЛицо - Булево - Признак того, что документ отражает операцию закупки через подотчетное лицо.
// 	     * ВозвратТоваровОтПлательщикаНДС - Булево - Признак того, что документ отражает возврат товаров от плательщика НДС.
// 	                                                 В этом случае от клиента ожидается получение счета-фактуры.
// 	     * ВозвратТоваровОтНеплательщикаНДС - Булево - Признак того, что документ отражает возврат товаров от неплательщика НДС.
// 	                                                 В этом случае получение счета-фактуры от клиента не ожидается.
// 	     * ИсправлениеОшибок - Булево - Признак того, что документ отражает исправление ошибок в документе приобретения.
// 	     * КорректировкаПоСогласованиюСторон - Булево - Признак того, что документ отражает корректировку приобретения по согласованию сторон.
//
Функция ПараметрыРегистрацииСчетовФактурПолученных() Экспорт
	
	ПараметрыРегистрации = Новый Структура();
	ПараметрыРегистрации.Вставить("Ссылка");
	ПараметрыРегистрации.Вставить("Дата", '00010101');
	ПараметрыРегистрации.Вставить("Организация");
	ПараметрыРегистрации.Вставить("Контрагент");
	ПараметрыРегистрации.Вставить("НалогообложениеНДС");
	
	ПараметрыРегистрации.Вставить("ПриобретениеТоваровРаботУслуг",     Ложь);
	ПараметрыРегистрации.Вставить("ПриемНаКомиссию",                   Ложь);
	ПараметрыРегистрации.Вставить("ИмпортТоваров",                     Ложь);
	ПараметрыРегистрации.Вставить("ВвозТоваровИзТаможенногоСоюза",     Ложь);
	ПараметрыРегистрации.Вставить("ЗакупкаЧерезПодотчетноеЛицо",       Ложь);
	ПараметрыРегистрации.Вставить("ВозвратТоваровОтПлательщикаНДС",    Ложь);
	ПараметрыРегистрации.Вставить("ВозвратТоваровОтНеплательщикаНДС",  Ложь);
	ПараметрыРегистрации.Вставить("ИсправлениеОшибок",                 Ложь);
	ПараметрыРегистрации.Вставить("КорректировкаПоСогласованиюСторон", Ложь);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

#КонецОбласти

#Область РегистрацияРучныхЗаписейКнигиПокупок

// Возвращает структуру параметров регистрации записей книги покупок на основании документа.
//
// Возвращаемое значение:
// 	Структура - Структура с ключами
// 	         * Ссылка - ДокументСсылка - Ссылка на документ-основание.
// 	         * Организация - СправочникСсылка.Организации - Организация, в которой необходимо отразить запись.
// 	         * Контрагент - СправочникСсылка.Контрагенты, СправочникСсылка.Организации - Поставщик ценностей.
//
Функция ПараметрыРегистрацииЗаписейКнигиПокупок() Экспорт
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Ссылка");
	ПараметрыРегистрации.Вставить("Организация");
	ПараметрыРегистрации.Вставить("Контрагент");
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область УчетИсходящегоНДС

#Область ЗаполнениеНалогообложенияНДСПродажи

// Возвращает структуру параметров для заполнения налогообложения НДС продажи или возврата товаров от покупателя.
//
// Возвращаемое значение
// 	Структура - Параметры заполнения
// 	     * Организация - СправочникСсылка.Организации - Организация документа.
// 	     * Дата - Дата - Дата документа.
// 	     * Договор - СправочникСсылка.ДоговорыКонтрагентов,
// 	                 СправочникСсылка.ДоговорыМеждуОрганизациями - Договор с покупателем.
// 	     * НаправлениеДеятельности - СправочникСсылка.НаправленияДеятельности - Направление деятельности, в рамках которого осуществляется продажа.
// 	                                                                            В случае возврата товаров поставщику не заполняется.
// 	     [Параметры операции]
// 	     * РеализацияТоваров - Булево- Признак того, что документом отражается реализация или возврат товаров, работ или услуг напрямую клиенту или собственной организации.
// 	     * РеализацияРаботУслуг - Булево - Признак того, что документом отражается реализация товаров, работ или услуг напрямую клиенту или собственной организации.
// 	     * РеализацияПрочихАктивов - Булево - Признак того, что документом отражается реализация прочих услуг (без номенклатуры) или прочих активов.
// 	     * ВыкупВозвратнойТарыКлиентом - Булево - Документ отражает выкуп клиентом ранее переданной возвратной тары.
// 	     * ВыкупТоваровХранителем - Булево - Документ отражает выкуп товаров, которые были ранее переданы на хранение с правом продажи.
// 	     * ПередачаНаКомиссию - Булево - Признак того, что документом отражается передача товаров на комиссию.
// 	     * ОтчетДавальцу - Булево -Признак того, что документом отражается реализация услуг по переработке давальческих материалов.
// 	     * ОтчетКомиссионера - Булево -Признак того, что документом отражается факт реализация товаров комиссионером.
// 	     * РозничнаяПродажа - Булево - Признак того, что документом отражается розничная продажа или возврат товаров проданных в розницу.
// 	     * ВозвратТоваровОтКлиента - Булево - Признак того, что отражается возврат товаров от клиента.
// 	     * ВозвратТоваровОтКомиссионера - Булево - Признак того, что отражается выполняется возврат комиссионера.
// 	     
// 	     * ЭтоЗаказ - Булево - Истина, если заполняется налогообложение в Заказе клиента или Заказе давальца.
// 	                           Параметр указывается для уточнение к параметрам операции. 
// 	                           Например, совместно с параметрами РеализацияРаботУслуг и РеализацияТоваров.
// 	     * ЭтоОперацияМеждуОрганизациями - Булево - Истина, если отражается операция между собственными организациями (интеркампани).
// 	                           Параметр указывается для уточнение к параметрам операции. 
// 	                           Например, совместно с параметрами РеализацияРаботУслуг и РеализацияТоваров.                       
//
Функция ПараметрыЗаполненияНалогообложенияНДСПродажи() Экспорт
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Организация");
	ПараметрыЗаполнения.Вставить("Дата");
	ПараметрыЗаполнения.Вставить("Склад");
	ПараметрыЗаполнения.Вставить("Договор");
	ПараметрыЗаполнения.Вставить("НаправлениеДеятельности");
	
	ПараметрыЗаполнения.Вставить("РеализацияТоваров", Ложь);
	ПараметрыЗаполнения.Вставить("РеализацияРаботУслуг", Ложь);
	ПараметрыЗаполнения.Вставить("РеализацияПрочихАктивов", Ложь);
	ПараметрыЗаполнения.Вставить("ВыкупВозвратнойТарыКлиентом", Ложь);
	ПараметрыЗаполнения.Вставить("ВыкупТоваровХранителем", Ложь);
	ПараметрыЗаполнения.Вставить("ПередачаНаКомиссию", Ложь);
	ПараметрыЗаполнения.Вставить("ОтчетДавальцу", Ложь);
	ПараметрыЗаполнения.Вставить("ОтчетКомиссионера", Ложь);
	ПараметрыЗаполнения.Вставить("ВозвратТоваровОтКлиента", Ложь);
	ПараметрыЗаполнения.Вставить("ВозвратТоваровОтКомиссионера", Ложь);
	
	ПараметрыЗаполнения.Вставить("РозничнаяПродажа", Ложь);
	
	ПараметрыЗаполнения.Вставить("ЭтоЗаказ", Ложь);
	ПараметрыЗаполнения.Вставить("ЭтоОперацияМеждуОрганизациями", Ложь);
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

// Определяет, необходимо ли отображение в итогах сумм НДС. 
// 
// Параметры:
// 	НалогообложениеНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС - налогообложение документа продажи
// Возвращаемое значение:
// 	Булево - Истина, если облагается НДС
//
Функция ПродажаОблагаетсяНДС(НалогообложениеНДС) Экспорт
	
	Возврат Не (НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС")
	            Или НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД")
	            Или НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя"));
	
КонецФункции

#КонецОбласти

#Область ФормированиеСчетовФактурВыданных

// Возвращает структуру параметров регистрации счетов-фактур на основании документов продажи или возврата товаров поставщику.
//
// Возвращаемое значение:
// 	Структура - Структура параметров с ключами
// 	     * Ссылка - ДокументСсылка - Ссылка на документ продажи.
// 	     * Организация - СправочникСсылка.Организации - Организация, в которой отражается продажа или возврат товаров.
// 	     * Контрагент - СправочникСсылка.Контрагенты, СправочникСсылка.Организации - Контрагент или организация покупатель.
// 	     * НалогообложениеНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС - Налогообложение НДС документа продажи или возврата.
// 	     [Параметры операции]
// 	     * РеализацияТоваров - Признак того, что документом отражается реализация товаров.
// 	     * РеализацияРаботУслуг - Признак того, что документом отражается реализация работ или услуг.
// 	     * РеализацияПрочихАктивов - Признак того, что документом отражается реализация прочих активов, например ОС.
// 	     * ПередачаНаКомиссию  - Булево - Признак того, что отражается операция передача товаров на комиссию.
// 	     * ВозвратТоваровПоставщику  - Булево - Признак того, что отражается операция возврата товаров поставщику.
// 	     * ИсправлениеОшибок - Булево - Признак того, что документ отражает исправление ошибок в реализации или прочем начислении НДС.
// 	     * КорректировкаПоСогласованиюСторон - Булево - Признак того, что документ отражает корректировку реализации по согласованию сторон.
// 	     * ПрочееНачислениеНДС - Признак того, что документом отражается прочее начисление НДС.
//
Функция ПараметрыРегистрацииСчетовФактурВыданных() Экспорт
	
	ПараметрыРегистрации = Новый Структура();
	ПараметрыРегистрации.Вставить("Ссылка");
	ПараметрыРегистрации.Вставить("Дата", '00010101');
	ПараметрыРегистрации.Вставить("Организация");
	ПараметрыРегистрации.Вставить("Контрагент");
	ПараметрыРегистрации.Вставить("НалогообложениеНДС");
	
	ПараметрыРегистрации.Вставить("РеализацияТоваров", Ложь);
	ПараметрыРегистрации.Вставить("РеализацияРаботУслуг", Ложь);
	ПараметрыРегистрации.Вставить("РеализацияПрочихАктивов", Ложь);
	ПараметрыРегистрации.Вставить("ПередачаНаКомиссию", Ложь);
	ПараметрыРегистрации.Вставить("ВозвратТоваровПоставщику", Ложь);
	ПараметрыРегистрации.Вставить("ИсправлениеОшибок", Ложь);
	ПараметрыРегистрации.Вставить("КорректировкаПоСогласованиюСторон", Ложь);
	ПараметрыРегистрации.Вставить("ПрочееНачислениеНДС", Ложь);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

#КонецОбласти

#Область ФормированиеСчетовФактурКомиссионеру
	
// Возвращает структуру параметров регистрации счетов-фактур на основании отчета комиссионера.
//
// Возвращаемое значение:
// 	Структура - Структура параметров с ключами
// 	     * Ссылка - ДокументСсылка - Ссылка на отчет комиссионера.
// 	     * Организация - СправочникСсылка.Организации - Организация, в которой отражается отчет комиссионера.
// 	     * Контрагент - СправочникСсылка.Контрагенты, СправочникСсылка.Организации - Комиссионер.
// 	     * НалогообложениеНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС - Налогообложение НДС отчета комиссионера.
// 	     * ПередачаНаКомиссию  - Булево - Признак того, что отражается операция передача товаров на комиссию.
//
Функция ПараметрыРегистрацииСчетовФактурКомиссионеру() Экспорт
	
	ПараметрыРегистрации = Новый Структура();
	ПараметрыРегистрации.Вставить("Ссылка");
	ПараметрыРегистрации.Вставить("Организация");
	ПараметрыРегистрации.Вставить("Контрагент");
	ПараметрыРегистрации.Вставить("НалогообложениеНДС");
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ПрочийПрограммныйИнтерфейс

#Область РасчетСуммНДС

// Функция возвращает процент ставки НДС.
//
// Параметры:
//  СтавкаНДС - ПеречислениеСсылка.СтавкиНДС - Ставка НДС.
//
// Возвращаемое значение:
//	Число - Процент ставки НДС.
//
Функция ПолучитьСтавкуНДС(СтавкаНДС) Экспорт
	
	Если СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС10")
		Или СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС10_110") Тогда
		Возврат 10;
	ИначеЕсли СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС18")
		Или СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС18_118") Тогда
		Возврат 18;
	ИначеЕсли СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20")
		Или СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20_120") Тогда
		Возврат 20;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

// Рассчитывает сумму НДС исходя из суммы и флагов налогообложения.
//
// Параметры:
//  Сумма            - Число - сумма от которой надо рассчитывать налоги;
//  СтавкаНДС        - Число - процентная ставка НДС.
//  СуммаВключаетНДС - Булево - признак включения НДС в сумму ("внутри" или "сверху");
//  НалогообложениеНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС - налогообложение документа
//
// Возвращаемое значение:
//  Число - полученная сумма НДС.
//
Функция РассчитатьСуммуНДС(Сумма, СтавкаНДС, СуммаВключаетНДС = Истина, НалогообложениеНДС = Неопределено) Экспорт

	Если НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя") Тогда
		Возврат 0;
	КонецЕсли;

	Если СуммаВключаетНДС Тогда
		СуммаНДС = Сумма - 100 * Сумма / (100 + СтавкаНДС);
	Иначе
		СуммаНДС = Сумма * СтавкаНДС / 100;
	КонецЕсли;
	
	Возврат СуммаНДС;

КонецФункции

// Рассчитывает сумму НДС регл в строке табличной части
// 
// Параметры:
// 	ТекущаяСтрока - Структура - данные обрабатываемой строки.
// 	СтруктураПараметровДействия - Структура - параметры действия.
// 	                   Используются следующие значения:
// 	                    * НалогообложениеНДС
// 	                    * СтавкаНДС
// 	КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке.
//
Процедура ПересчитатьНДСРеглВСтрокеТЧ(ТекущаяСтрока, СтруктураПараметровДействия, КэшированныеЗначения) Экспорт
	
	//++ Локализация
	Перем СтавкаНДС;

	НалогообложениеНДС = Неопределено;
	СтруктураПараметровДействия.Свойство("НалогообложениеНДС", НалогообложениеНДС);
	
	Если Не СтруктураПараметровДействия.Свойство("СтавкаНДС", СтавкаНДС) Тогда
		СтавкаНДС = ТекущаяСтрока.СтавкаНДС;
	КонецЕсли;
	
	ТекущаяСтрока.НДСРегл = РассчитатьСуммуНДС(
		ТекущаяСтрока.СуммаРегл,
		ПолучитьСтавкуНДС(СтавкаНДС),
		Ложь,
		НалогообложениеНДС);
	//-- Локализация
	
КонецПроцедуры

// Пересчитывает сумму продажи НДС товара в текущей строке табличной части документа.
// 
// Параметры:
// 	ТекущаяСтрока - Структура - данные обрабатываемой строки.
// 	СтруктураПараметровДействия - Структура - параметры действия.
// 	                     Используются следующие значения:
// 	                     * НалогообложениеНДС
// 	                     * СтавкаНДС
// 	КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке.
//
Процедура ПересчитатьСуммуПродажиНДСВСтрокеТЧ(ТекущаяСтрока, СтруктураПараметровДействия, КэшированныеЗначения) Экспорт
	
	//++ Локализация
	Перем СтавкаНДС;
	Перем НалогообложениеНДС;
	
	Если СтруктураПараметровДействия <> Неопределено И СтруктураПараметровДействия.Свойство("НалогообложениеНДС", НалогообложениеНДС) Тогда
		Если НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя") Тогда
			// СуммаНДС = 0, пересчет не требуется 
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если СтруктураПараметровДействия = Неопределено Или Не СтруктураПараметровДействия.Свойство("СтавкаНДС", СтавкаНДС) Тогда
		СтавкаНДС = ТекущаяСтрока.СтавкаНДС;
	КонецЕсли;
	
	ТекущийПроцентНДС = ПолучитьСтавкуНДС(СтавкаНДС);
	ТекущаяСтрока.СуммаПродажиНДС = Окр(ТекущаяСтрока.СуммаПродажи * ТекущийПроцентНДС / (100 + ТекущийПроцентНДС), 2, РежимОкругления.Окр15как20);
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

// Возвращает отбор для списка подбора номенклатуры в соответствии с налогообложением операции 
// 
// Параметры:
// 	НалогообложениеНДС - Перечисление.ТипыНалогообложенияНДС - налогообложение операции, в рамках которой производится подбор
// 
// Возвращаемое значение:
// 	Массив - массив структур отбора для справочника Номенклатура
//
Функция ОграничениеТоваровПоНалогообложению(НалогообложениеНДС) Экспорт
	
	Ограничения = Новый Массив;
	СтруктураОтбора = Новый Структура("Реквизит,ВидСравнения,Значение");
	
	//++ Локализация
	Если НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД") Тогда
		СтруктураОтбора.Реквизит = "ПодакцизныйТовар";
		СтруктураОтбора.Значение = Ложь;
		СтруктураОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		Ограничения.Добавить(СтруктураОтбора);
	КонецЕсли;

	СтруктураОтбора.Реквизит = "ОблагаетсяНДСУПокупателя";
	СтруктураОтбора.Значение = (НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя"));
	СтруктураОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	Ограничения.Добавить(СтруктураОтбора);
	//-- Локализация
	Возврат Ограничения;
	
КонецФункции

#КонецОбласти

#КонецОбласти
