
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если ЗначениеЗаполнено(Параметры.ВариантРасхождений) Тогда
		
		МассивВариантовОтраженияРасхождений = Новый Массив();
		
		Если Параметры.ВариантРасхождений = Перечисления.ВариантыРасхождений.Излишки Тогда
			
			МассивВариантовОтраженияРасхождений.Добавить(Перечисления.ВариантыОтраженияРасхождений.ИзлишкиВПользуПоставщика);
			МассивВариантовОтраженияРасхождений.Добавить(Перечисления.ВариантыОтраженияРасхождений.ИзлишкиНаПрочиеДоходы);
			Заголовок = НСтр("ru='Укажите вариант отражения излишков'");
			
		ИначеЕсли Параметры.ВариантРасхождений = Перечисления.ВариантыРасхождений.Недостачи Тогда
			
			МассивВариантовОтраженияРасхождений.Добавить(Перечисления.ВариантыОтраженияРасхождений.НедостачиЗаСчетПоставщика);
			МассивВариантовОтраженияРасхождений.Добавить(Перечисления.ВариантыОтраженияРасхождений.НедостачиЗаСчетСтороннейКомпании);
			МассивВариантовОтраженияРасхождений.Добавить(Перечисления.ВариантыОтраженияРасхождений.НедостачиНаПрочиеРасходы);
			Заголовок = НСтр("ru='Укажите вариант отражения недостач'");
			
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", МассивВариантовОтраженияРасхождений, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти
