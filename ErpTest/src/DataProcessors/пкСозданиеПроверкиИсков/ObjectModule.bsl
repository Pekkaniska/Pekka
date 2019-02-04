
Процедура НайтиИскиДляПроверки() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	пкСудебныйИск.Ссылка КАК Иск,
	               |	ЗадачаИсполнителя.Ссылка КАК ЗадачаПоПроверке,
	               |	ЗадачаИсполнителя.БизнесПроцесс КАК БП_Согласования
	               |ИЗ
	               |	Документ.пкСудебныйИск КАК пкСудебныйИск
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	               |		ПО пкСудебныйИск.Ссылка = ЗадачаИсполнителя.Предмет
	               |			И (ЗадачаИсполнителя.Выполнена = ЛОЖЬ)
	               |ГДЕ
	               |	пкСудебныйИск.Проведен = ИСТИНА
	               |	И пкСудебныйИск.НаходитсяВРаботе = ИСТИНА";
	
	Результат = Запрос.Выполнить();
	ДанныеОбработки.Загрузить(Результат.Выгрузить());

КонецПроцедуры

Процедура СоздатьЗадачиПроверки() Экспорт
	
	НачТекДата=НачалоДня(ТекущаяДата());
	
	Для каждого СтрокаИска Из ДанныеОбработки Цикл
		Если ЗначениеЗаполнено(СтрокаИска.ЗадачаПоПроверке) Тогда
			Продолжить;
		КонецЕсли; 	
		БПСогласования=БизнесПроцессы.Задание.СоздатьБизнесПроцесс();
	    БПСогласования.Заполнить(СтрокаИска.Иск);
		БПСогласования.СрокИсполнения=СрокИсполнения;
		Если ЗначениеЗаполнено(Исполнитель) Тогда
		БПСогласования.Исполнитель=Исполнитель;
		КонецЕсли;
		Если не ЗначениеЗаполнено(БПСогласования.Исполнитель) Тогда
		БПСогласования.Исполнитель=СтрокаИска.Иск.Ответственный;	
		КонецЕсли;
		Если не ЗначениеЗаполнено(БПСогласования.Исполнитель) Тогда
		БПСогласования.Исполнитель=Пользователи.АвторизованныйПользователь();	
		КонецЕсли;
		Если ЗначениеЗаполнено(Проверяющий) Тогда
			БПСогласования.НаПроверке=Истина;
			БПСогласования.Проверяющий=Проверяющий;
			БПСогласования.СрокПроверки=СрокПроверки;
		Иначе	
			БПСогласования.НаПроверке=Ложь;
			//БПСогласования.Проверяющий=Неопределено;
			//БПСогласования.СрокПроверки=Неопределено;
		КонецЕсли;
		БПСогласования.Содержание="Проверить статус документа "+Строка(СтрокаИска.Иск);
		БПСогласования.Наименование="Проверить статус документа "+Строка(СтрокаИска.Иск);
		БПСогласования.Дата=НачТекДата;
		БПСогласования.Записать();
		БПСогласования.Старт();
		СтрокаИска.БП_Согласования=БПСогласования.Ссылка;
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ЗадачаИсполнителя.Ссылка
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|ГДЕ
		|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс
		|	И ЗадачаИсполнителя.Выполнена = ЛОЖЬ";
		
		Запрос.УстановитьПараметр("БизнесПроцесс", БПСогласования.Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			СтрокаИска.ЗадачаПоПроверке=Выборка.Ссылка;
		КонецЕсли;
		 
	КонецЦикла; 

КонецПроцедуры

СрокИсполнения=НачалоДня(ТекущаяДата())+5*24*60*60;
СрокПроверки=СрокИсполнения+5*24*60*60;
Исполнитель=Справочники.РолиИсполнителей.НайтиПоНаименованию("Юристы");
Если Не ЗначениеЗаполнено(Исполнитель) Тогда
Исполнитель=Справочники.РолиИсполнителей.НайтиПоНаименованию("Юрист");
КонецЕсли; 
