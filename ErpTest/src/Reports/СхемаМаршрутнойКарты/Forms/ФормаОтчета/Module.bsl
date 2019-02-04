
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		
		Возврат;
		
	КонецЕсли;
	
	ЗагрузитьНастройкиФормы();
	
	Если Параметры.Свойство("МаршрутнаяКарта") Тогда
		
		Отчет.МаршрутнаяКарта = Параметры.МаршрутнаяКарта;
		СформироватьОтчет();
		
	Иначе
		
		УстановитьСостояниеОтчета(Элементы.ПолеТабличногоДокумента, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МаршрутнаяКартаПриИзменении(Элемент)
	
	УстановитьСостояниеОтчета(Элементы.ПолеТабличногоДокумента, Ложь);
	СохранитьНастройкиФормыКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВложенныеМаршрутыПриИзменении(Элемент)
	
	УстановитьСостояниеОтчета(Элементы.ПолеТабличногоДокумента, Ложь);
	СохранитьНастройкиФормыКлиент();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	ОчиститьСообщения();
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьОтчет();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОтчет()
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	ОтчетОбъект.СформироватьОтчет(ПолеТабличногоДокумента);
	
	УстановитьСостояниеОтчета(Элементы.ПолеТабличногоДокумента, Истина);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСостояниеОтчета(ПолеТабличногоДокумента, Сформирован)
	
	Если НЕ Сформирован Тогда
		Состояние = "НеАктуальность";
	Иначе
		Состояние = "НеИспользовать";
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(ПолеТабличногоДокумента, Состояние);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиФормы()
	
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		КлючФормы(),
		КлючНастроекФормы());
	
	Если ТипЗнч(Настройки) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(Отчет, Настройки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиФормыКлиент()
	
	Настройки = Новый Структура;
	Настройки.Вставить("МаршрутнаяКарта", Отчет.МаршрутнаяКарта);
	Настройки.Вставить("ПоказатьОперацииВложенныхМаршрутов", Отчет.ПоказатьОперацииВложенныхМаршрутов);
	
	СохранитьНастройкиФормыСервер(Настройки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиФормыСервер(Настройки)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		КлючФормы(),
		КлючНастроекФормы(),
		Настройки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КлючФормы()
	
	Возврат "Отчет.СхемаМаршрутнойКарты.ФормаОтчета";
	
КонецФункции

&НаСервереБезКонтекста
Функция КлючНастроекФормы()
	
	Возврат "Основные";
	
КонецФункции

#КонецОбласти
