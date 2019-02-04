#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Параметры планирования работы в графике производства вида РЦ ""%1""'"),
						Параметры.ДанныеОбъекта.НаименованиеВидаРЦ);
	
	ЗаполнитьЗначенияСвойств(Объект, Параметры.ДанныеОбъекта);
	
	ИнтервалПланирования = Параметры.ДанныеОбъекта.ИнтервалПланирования;
	КонтрольДоступности = Число(Параметры.ДанныеОбъекта.УчитыватьДоступностьПоГрафикуРаботы);
	ВводитьДоступностьДляВидаРЦ = Число(Параметры.ДанныеОбъекта.ВводитьДоступностьДляВидаРЦ);
	
	МинимальныйЗначимыйБуферПриОтсутствииКонтроляДоступности = Параметры.ДанныеОбъекта.МинимальныйЗначимыйБуфер;
	
	ПриИзмененииКонтрольДоступности(ЭтаФорма);
	УправлениеДоступностью(ЭтаФорма);
	
	Если ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.Час Тогда
		Элементы.СпособВводаДоступностиСводно.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОповещениеЗакрытия = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(ОповещениеЗакрытия, Отказ, ЗавершениеРаботы, ТекстВопроса,
			ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтрольДоступности1ПриИзменении(Элемент)
	
	ПриИзмененииКонтрольДоступности(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрольДоступности2ПриИзменении(Элемент)
	
	ПриИзмененииКонтрольДоступности(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособВводаДоступностиПоРабочимЦентрамПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособВводаДоступностиСводноПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗавершитьРедактирование(Команда)
	
	ЗавершитьРедактирование();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииКонтрольДоступности(Форма)

	Если Форма.КонтрольДоступности = 1 Тогда
		Форма.Элементы.СтраницыПараметрыСвязанныеСДоступностью.ТекущаяСтраница = Форма.Элементы.СтраницаПараметрыДоступностьКонтролируется;
	Иначе
		Форма.Элементы.СтраницыПараметрыСвязанныеСДоступностью.ТекущаяСтраница = Форма.Элементы.СтраницаПараметрыДоступностьНеКонтролируется;
	КонецЕсли; 

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)

	ДоступностьВводитсяСводно = (Форма.ВводитьДоступностьДляВидаРЦ = 1);
	
	Форма.Элементы.КоличествоРабочихЦентров.Доступность = ДоступностьВводитсяСводно;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗавершитьРедактирование();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование()

	ОчиститьСообщения();
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат
	КонецЕсли;
	
	РезультатНастройки = Новый Структура("КоличествоРабочихЦентров, КонтрольДоступности, МинимальныйЗначимыйБуфер");
	ЗаполнитьЗначенияСвойств(РезультатНастройки, Объект);
	
	РезультатНастройки.Вставить("УчитыватьДоступностьПоГрафикуРаботы", Булево(КонтрольДоступности));
	РезультатНастройки.Вставить("ВводитьДоступностьДляВидаРЦ", Булево(ВводитьДоступностьДляВидаРЦ));
	
	Если КонтрольДоступности = 0 Тогда
		РезультатНастройки.Вставить("МинимальныйЗначимыйБуфер", МинимальныйЗначимыйБуферПриОтсутствииКонтроляДоступности);
	КонецЕсли; 
	
	Модифицированность = Ложь;
	
	Закрыть(РезультатНастройки);
	
КонецПроцедуры

#КонецОбласти
