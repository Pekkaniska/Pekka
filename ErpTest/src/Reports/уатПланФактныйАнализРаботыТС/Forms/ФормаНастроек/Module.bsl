
&НаСервере
Процедура ОбновитьМакетКомпоновки()
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет", Тип("ОтчетОбъект.уатПланФактныйАнализРаботыТС"));
	ОтчетОбъект.СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемы);
	ЗначениеВРеквизитФормы(ОтчетОбъект, "Отчет");
	
	Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	Если ТипЗнч(ИсходныеНастройки) = Тип("Структура") Тогда 
		Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(ИсходныеНастройки.Настройки);
		Отчет.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(ИсходныеНастройки.ПользовательскиеНастройки);
		Отчет.КомпоновщикНастроек.ЗагрузитьФиксированныеНастройки(ИсходныеНастройки.ФиксированныеНастройки);
	Иначе 
		Сообщить("Ошибка при передаче параметров открытия формы настройки отчета.");
		ЭтаФорма.Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьМакетКомпоновки();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	Результат = Новый Структура("Настройки, ПользовательскиеНастройки, ФиксированныеНастройки",
								Отчет.КомпоновщикНастроек.Настройки,
								Отчет.КомпоновщикНастроек.ПользовательскиеНастройки,
								Отчет.КомпоновщикНастроек.ФиксированныеНастройки);
	ЭтаФорма.Закрыть(Результат);
	
КонецПроцедуры


