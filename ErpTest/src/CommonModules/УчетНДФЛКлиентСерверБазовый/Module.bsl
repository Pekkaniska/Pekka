
#Область СлужебныеПроцедурыИФункции

Функция ОписаниеПанелиВычеты() Экспорт
	
	ОписаниеПанели = Новый Структура;
	
	ОписаниеПанели.Вставить("ИмяГруппыФормыПанелиВычеты", "ГруппаКарточка");
	ОписаниеПанели.Вставить("ПутьКДаннымПоляНалоговыйПериод", "");
	ОписаниеПанели.Вставить("ИмяКолонкиПримененныеВычеты", "");
	ОписаниеПанели.Вставить("ТабличнаяЧастьНДФЛ", Новый Структура);
	ОписаниеПанели.Вставить("НастраиваемыеПанели", Новый Соответствие);
	
	Возврат ОписаниеПанели;
	
КонецФункции

Функция ОписаниеТабличнойЧастиНДФЛ() Экспорт
	
	ОписаниеТабличнойЧасти = Новый Структура;
	
	ОписаниеТабличнойЧасти.Вставить("ИмяТаблицыФормы", "НДФЛ");
	ОписаниеТабличнойЧасти.Вставить("ПутьКДаннымНДФЛ", "Объект.НДФЛ");
	ОписаниеТабличнойЧасти.Вставить("ИмяПоляПериод", "МесяцНалоговогоПериода");
	ОписаниеТабличнойЧасти.Вставить("ИмяПоляФизическоеЛицо", "ФизическоеЛицо");
		
	Возврат ОписаниеТабличнойЧасти;
	
КонецФункции

Функция НДФЛТекущиеДанные(Форма, ОписаниеПанелиВычеты) Экспорт
	
	ТекущиеДанные = Неопределено;
	
	ИдентификаторТекущейСтроки = Форма.Элементы[ОписаниеПанелиВычеты.ТабличнаяЧастьНДФЛ.ИмяТаблицыФормы].ТекущаяСтрока;
	Если ИдентификаторТекущейСтроки <> Неопределено Тогда
		ДанныеНДФЛ = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ОписаниеПанелиВычеты.ТабличнаяЧастьНДФЛ.ПутьКДаннымНДФЛ);
		ТекущиеДанные = ДанныеНДФЛ.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
	КонецЕсли; 
	
	Возврат ТекущиеДанные;
	
КонецФункции

Функция ФормаПодробнееОРасчетеНДФЛОписаниеТаблицыНДФЛ() Экспорт
	
	Описание = Новый Структура(
		"ИмяТаблицы,
		|ПутьКДанным,
		|ИмяПоляДляВставкиПоказателей,
		|ИмяПоляРезультат,
		|ИмяРеквизитаПериод,
		|НомерТаблицы,
		|СодержитПолеВидРасчета,
		|СодержитПолеСотрудник,
		|ИмяРеквизитаСотрудник,
		|ПроверяемыеРеквизиты,
		|ПутьКДаннымАдресРаспределенияРезультатовВХранилище,
		|ПутьКДаннымРаспределениеРезультатов,
		|ИмяРеквизитаИдентификаторСтроки,
		|ИмяПоляДляВставкиРаспределенияРезультатов,
		|ОтменятьВсеИсправления");
	
	Описание.ИмяТаблицы						= "НДФЛ";
	Описание.ПутьКДанным					= "НДФЛ";
	Описание.ИмяПоляДляВставкиПоказателей	= "Налог";
	Описание.ИмяПоляРезультат				= "Налог";
	Описание.ИмяРеквизитаПериод				= "МесяцНалоговогоПериода";
	Описание.НомерТаблицы					= 3;
	Описание.СодержитПолеВидРасчета			= Ложь;
	Описание.СодержитПолеСотрудник			= Истина;
	Описание.ИмяРеквизитаСотрудник			= "ФизическоеЛицо";
	Описание.ПроверяемыеРеквизиты			= "ФизическоеЛицо,МесяцНалоговогоПериода";
	
	Описание.ПутьКДаннымАдресРаспределенияРезультатовВХранилище = "АдресРаспределенияРезультатовВХранилище";
	Описание.ПутьКДаннымРаспределениеРезультатов				= "Объект.РаспределениеРезультатовУдержаний";
	Описание.ИмяРеквизитаИдентификаторСтроки					= "ИдентификаторСтрокиНДФЛ";
	Описание.ИмяПоляДляВставкиРаспределенияРезультатов			= "НДФЛМесяцНалоговогоПериода";
	
	Описание.ОтменятьВсеИсправления = Истина;
	
	Возврат Описание;
	
КонецФункции

#КонецОбласти
