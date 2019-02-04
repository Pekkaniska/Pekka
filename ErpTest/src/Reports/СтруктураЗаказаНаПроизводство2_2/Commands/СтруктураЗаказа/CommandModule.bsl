
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ИмяФормы = "Отчет.СтруктураЗаказаНаПроизводство2_2.Форма.СтруктураЗаказа";
	
	ПараметрыФормы = Новый Структура("Заказы", ПараметрКоманды);
	
	Если ПараметрКоманды.Количество() = 1 Тогда
		КлючУникальности = ПараметрКоманды[0];
	Иначе
		КлючУникальности = КлючУникальностиМассиваЗаказов(ПараметрКоманды);
	КонецЕсли;
	
	ОткрытьФорму(
		ИмяФормы,
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		КлючУникальности,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка
	);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция КлючУникальностиМассиваЗаказов(Заказы)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗаказНаПроизводство2_2.Номер
	|ИЗ
	|	Документ.ЗаказНаПроизводство2_2 КАК ЗаказНаПроизводство2_2
	|ГДЕ
	|	ЗаказНаПроизводство2_2.Ссылка В(&Заказы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаказНаПроизводство2_2.МоментВремени");
	Запрос.УстановитьПараметр("Заказы", Заказы);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Результат = "";
	
	Пока Выборка.Следующий() Цикл
		
		Результат = Результат + Выборка.Номер;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
