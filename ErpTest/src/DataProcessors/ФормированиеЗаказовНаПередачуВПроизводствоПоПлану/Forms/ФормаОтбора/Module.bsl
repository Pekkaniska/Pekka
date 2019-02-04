#Область ОписаниеПеременных

&НаКлиенте
Перем ПередЗаписьюПовторныйВызов; // Используется для не модальных вопросов перед записью

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ПередЗаписьюПовторныйВызов = Истина Тогда
		ПередЗаписьюПовторныйВызов = Ложь;
		Возврат;
	КонецЕсли;

	Если Модифицированность Тогда
		
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
		ПередЗаписьюПовторныйВызов = Истина;
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ЗаписатьДанные();
		Закрыть();
		
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		
		Закрыть();
		
	Иначе
		
		ПередЗаписьюПовторныйВызов = Ложь;
	
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	КомпоновщикНастроек = Параметры.КомпоновщикНастроек;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ЗаписатьДанные();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКомпоновщикНастроекПользовательскиеНастройки

&НаКлиенте
Процедура КомпоновщикНастроекПользовательскиеНастройкиПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Функция ЗаписатьДанные()

	ЭтаФорма.ВладелецФормы.КомпоновщикНастроек = КомпоновщикНастроек;

	Модифицированность = Ложь;
	
	Оповестить("УстановленОтбор_ФормированиеЗаказовНаПроизводствоПоПлану");
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти