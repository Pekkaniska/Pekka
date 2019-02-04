
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЭлементыГруппыТоваров = ГруппыТоваров.ПолучитьЭлементы();
	Если ЭлементыГруппыТоваров.Количество() = 0.00 Тогда
		КлассификаторЕТСНГ = Обработки.уатПечатьТТН1208.ПолучитьМакет("ЕТСНГ");
		СтрокаГруппы = Неопределено;
		Для итератор = 1 По КлассификаторЕТСНГ.ВысотаТаблицы Цикл
			Если Булево(КлассификаторЕТСНГ.ПолучитьОбласть(итератор, 3, итератор, 3).ТекущаяОбласть.Текст) = Истина Тогда
				СтрокаГруппы = ЭлементыГруппыТоваров.Добавить();
				СтрокаГруппы.Группа = КлассификаторЕТСНГ.ПолучитьОбласть(итератор, 5, итератор, 5).ТекущаяОбласть.Текст;
			Иначе
				Если СтрокаГруппы = Неопределено Тогда
					продолжить;
				КонецЕсли;
				ЭлементГруппы = СтрокаГруппы.ПолучитьЭлементы();
				ДетальнаяСтрока = ЭлементГруппы.Добавить();
				ДетальнаяСтрока.Группа = КлассификаторЕТСНГ.ПолучитьОбласть(итератор, 2, итератор, 2).ТекущаяОбласть.Текст + " " +
										КлассификаторЕТСНГ.ПолучитьОбласть(итератор, 1, итератор, 1).ТекущаяОбласть.Текст;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ГруппыТоваров

&НаКлиенте
Процедура ГруппыТоваровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Элемент.ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
		возврат;
	КонецЕсли;
	Закрыть(Элемент.ТекущиеДанные.Группа);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	Если Элементы.ГруппыТоваров.ТекущиеДанные <> Неопределено
		И Элементы.ГруппыТоваров.ТекущиеДанные.ПолучитьРодителя() <> Неопределено
	Тогда
		Закрыть(Элементы.ГруппыТоваров.ТекущиеДанные.Группа);
	КонецЕсли;      
КонецПроцедуры

#КонецОбласти
